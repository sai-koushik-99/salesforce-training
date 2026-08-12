/**
 * PlacementService
 *
 * Service class responsible for initiating the external candidate sync
 * process when an Application status changes to "Selected".
 *
 * This class sits between the Trigger and the Queueable:
 *
 *   StudentJobApplicationTrigger (after update)
 *       → PlacementService.syncSelectedCandidates()
 *           → System.enqueueJob(new PlacementSyncProcessor(appId))
 *
 * Why this layer exists:
 * The Trigger stays thin — it just routes events.
 * The Service contains the business decision logic: who qualifies for sync?
 * The Queueable contains the integration mechanics: how do we sync?
 *
 * Day 11 — Placement Management System Integration
 */
public class PlacementService {

    /**
     * syncSelectedCandidates
     *
     * Called from StudentJobApplicationTrigger on after update.
     * Identifies applications that just transitioned to "Selected"
     * and are not already synced, then enqueues a sync job for each.
     *
     * Bulkification:
     * This method handles a list of applications — it does NOT assume
     * only one record changed at a time. In a bulk update of 50 records,
     * all 50 are processed here safely.
     *
     * We enqueue one PlacementSyncProcessor job per qualifying application.
     * Salesforce allows up to 50 enqueued Queueable jobs per transaction,
     * so this handles bulk scenarios correctly within governor limits.
     *
     * @param newApplications  Trigger.new — the updated application records
     * @param oldMap           Trigger.oldMap — the pre-update application records
     */
    public static void syncSelectedCandidates(
        List<Application__c> newApplications,
        Map<Id, Application__c> oldMap
    ) {
        for (Application__c app : newApplications) {

            Application__c oldApp = oldMap.get(app.Id);

            // Condition 1: Status just changed TO "Selected"
            // We check both old and new to avoid enqueuing on every save
            Boolean justBecameSelected =
                oldApp.Status__c != 'Selected' && app.Status__c == 'Selected';

            // Condition 2: Not already successfully synced (idempotency guard)
            // If a previous job already ran and returned 'Sent', don't enqueue again.
            // We allow re-enqueue if status is null, Pending, Failed, or Retry Required.
            Boolean notAlreadySent = app.Integration_Status__c != 'Sent';

            if (justBecameSelected && notAlreadySent) {

                System.debug('PlacementService: Enqueueing sync for Application: '
                    + app.Name + ' Id: ' + app.Id);

                // Enqueue the Queueable job — this is asynchronous.
                // The HTTP callout happens AFTER this transaction commits.
                System.enqueueJob(new PlacementSyncProcessor(app.Id));
            }
        }
    }
}
