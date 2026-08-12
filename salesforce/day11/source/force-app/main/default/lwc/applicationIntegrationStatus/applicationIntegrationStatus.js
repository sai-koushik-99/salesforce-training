import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import getIntegrationDetails from '@salesforce/apex/ApplicationIntegrationController.getIntegrationDetails';
import syncCandidate from '@salesforce/apex/ApplicationIntegrationController.syncCandidate';

export default class ApplicationIntegrationStatus extends LightningElement {

    // @api recordId is automatically passed by Salesforce when this component
    // is placed on a Lightning Record Page for Application__c
    @api recordId;

    // Track reactive state
    @track isSyncing = false;
    @track syncMessage = '';
    @track wireError = '';

    // Internal reference needed by refreshApex — we store the raw wire result
    _wiredResult;

    // ----------------------------------------------------------------
    // @wire — automatically fetches integration details when recordId changes
    // cacheable=true means it can be refreshed via refreshApex
    // ----------------------------------------------------------------
    @wire(getIntegrationDetails, { applicationId: '$recordId' })
    wiredApplication(result) {
        this._wiredResult = result;
        if (result.error) {
            this.wireError = result.error.body ? result.error.body.message : 'Unknown error';
        } else {
            this.wireError = '';
        }
    }

    // ----------------------------------------------------------------
    // Computed properties — used in the template
    // ----------------------------------------------------------------

    // The Application record (or null while loading)
    get application() {
        return this._wiredResult && this._wiredResult.data
            ? this._wiredResult.data
            : null;
    }

    // Show spinner while loading
    get isLoading() {
        return !this.application && !this.wireError;
    }

    // Can the user trigger a sync?
    // Only if: Status = Selected AND Integration_Status != Sent
    get canSync() {
        if (!this.application) return false;
        return this.application.Status__c === 'Selected'
            && this.application.Integration_Status__c !== 'Sent';
    }

    // Show success state
    get isSent() {
        if (!this.application) return false;
        return this.application.Integration_Status__c === 'Sent';
    }

    // CSS class for the Integration Status badge based on its value
    get integrationStatusClass() {
        if (!this.application) return '';
        const status = this.application.Integration_Status__c;
        if (status === 'Sent')           return 'slds-badge_success';
        if (status === 'Failed')         return 'slds-badge_error';
        if (status === 'Retry Required') return 'slds-badge_warning';
        return ''; // Pending or null
    }

    // CSS class for Application Status badge
    get applicationStatusClass() {
        if (!this.application) return '';
        return this.application.Status__c === 'Selected'
            ? 'slds-badge_success' : '';
    }

    // ----------------------------------------------------------------
    // handleSync — called when "Sync Candidate" button is clicked
    //
    // Flow:
    //   LWC button click
    //   → syncCandidate() Apex method
    //   → System.enqueueJob(new PlacementSyncProcessor(appId))
    //   → HTTP POST to External Recruitment API (async, after this call)
    //   → Application integration fields updated by Queueable
    //   → refreshApex re-fetches the latest data
    //
    // The LWC does NOT do the HTTP callout itself.
    // The LWC calls Apex → Apex enqueues the Queueable → Queueable does callout.
    // ----------------------------------------------------------------
    handleSync() {
        this.isSyncing   = true;
        this.syncMessage = 'Sync request submitted. This may take a few seconds...';

        syncCandidate({ applicationId: this.recordId })
            .then(() => {
                this.dispatchEvent(new ShowToastEvent({
                    title:   'Sync Submitted',
                    message: 'Candidate sync has been queued. Refresh in a moment to see the result.',
                    variant: 'success'
                }));

                // Refresh the @wire data to show updated integration status
                // We wait 3 seconds to give the Queueable time to process
                // In a real scenario, you'd use polling or Platform Events
                setTimeout(() => {
                    refreshApex(this._wiredResult);
                    this.isSyncing   = false;
                    this.syncMessage = '';
                }, 3000);
            })
            .catch(error => {
                const message = error.body ? error.body.message : 'Unknown error';
                this.dispatchEvent(new ShowToastEvent({
                    title:   'Sync Failed',
                    message: message,
                    variant: 'error'
                }));
                this.isSyncing   = false;
                this.syncMessage = '';
            });
    }
}
