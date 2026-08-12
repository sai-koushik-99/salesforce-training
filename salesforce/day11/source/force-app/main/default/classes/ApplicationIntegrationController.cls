/**
 * ApplicationIntegrationController
 *
 * Apex controller for the applicationIntegrationStatus LWC component.
 *
 * Provides two methods:
 *   1. getIntegrationDetails() — @wire-compatible, returns integration fields
 *   2. syncCandidate()         — called by the Sync button, enqueues a new job
 *
 * Day 11 — Placement Management System Integration
 */
public with sharing class ApplicationIntegrationController {

    /**
     * getIntegrationDetails
     *
     * Returns the integration-related fields for a given Application.
     * Used with @wire in LWC to automatically display current values.
     *
     * @param applicationId  the Id of the Application__c record
     * @return               the Application with integration fields populated
     */
    @AuraEnabled(cacheable=true)
    public static Application__c getIntegrationDetails(Id applicationId) {
        return [
            SELECT Id,
                   Name,
                   Status__c,
                   Integration_Status__c,
                   External_Candidate_Id__c,
                   Integration_Error__c,
                   Last_Integration_Attempt__c,
                   Student__r.Name,
                   Job__r.Company__c,
                   Job__r.Name
            FROM Application__c
            WHERE Id = :applicationId
            LIMIT 1
        ];
    }

    /**
     * syncCandidate
     *
     * Called by the LWC "Sync Candidate" button.
     * Enqueues a new PlacementSyncProcessor job for the given Application.
     *
     * Only enqueues if the Application status is 'Selected' and
     * Integration_Status is not already 'Sent'.
     *
     * @param applicationId  the Id of the Application__c to re-sync
     */
    @AuraEnabled
    public static void syncCandidate(Id applicationId) {
        Application__c app = [
            SELECT Id, Status__c, Integration_Status__c
            FROM Application__c
            WHERE Id = :applicationId
            LIMIT 1
        ];

        // Only sync if the application is actually Selected
        if (app.Status__c != 'Selected') {
            throw new AuraHandledException(
                'Cannot sync: Application is not in Selected status.'
            );
        }

        // Idempotency: don't re-sync if already successfully sent
        if (app.Integration_Status__c == 'Sent') {
            throw new AuraHandledException(
                'Candidate is already synced to the external system (Status: Sent).'
            );
        }

        System.enqueueJob(new PlacementSyncProcessor(applicationId));
    }
}
