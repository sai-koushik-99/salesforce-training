trigger StudentJobApplicationTrigger on Application__c (
    before insert,
    after update
) {

    if (Trigger.isBefore && Trigger.isInsert) {
        ApplicationService.validateEligibility(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        StatisticsService.updateStatistics(
            Trigger.new,
            Trigger.oldMap
        );

        NotificationService.sendNotifications(
            Trigger.new,
            Trigger.oldMap
        );

        // Day 11: Sync selected candidates to external recruitment platform
        PlacementService.syncSelectedCandidates(
            Trigger.new,
            Trigger.oldMap
        );
    }
}