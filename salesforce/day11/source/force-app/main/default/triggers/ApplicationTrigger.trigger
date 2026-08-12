trigger ApplicationTrigger on Application__c (before insert, after update) {

    if (Trigger.isBefore && Trigger.isInsert) {
        ApplicationTriggerHandler.validateApplications(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        ApplicationTriggerHandler.updateSelectedStudents(
            Trigger.new,
            Trigger.oldMap
        );
    }

}