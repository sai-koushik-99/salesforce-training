public class ApplicationTriggerHandler {

    public static void validateApplications(List<Application__c> applications) {

        ApplicationService.validateEligibility(applications);

    }

    public static void updateSelectedStudents(
        List<Application__c> applications,
        Map<Id, Application__c> oldMap) {

        ApplicationService.markStudentsSelected(
            applications,
            oldMap
        );

    }

}