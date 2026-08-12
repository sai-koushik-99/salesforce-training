import { LightningElement, api } from 'lwc';

export default class JobCard extends LightningElement {

    // @api job means the parent (eligibleJobs) will pass the job object into this component
    // This is Parent → Child communication
    @api job;

    handleView() {
        // Fire a custom event called 'view' up to the parent
        // The parent listens using onview={handleView}
        this.dispatchEvent(new CustomEvent('view'));
    }

    handleApply() {
        // Fire a custom event called 'apply' up to the parent
        // The parent listens using onapply={handleApply}
        this.dispatchEvent(new CustomEvent('apply'));
    }
}
