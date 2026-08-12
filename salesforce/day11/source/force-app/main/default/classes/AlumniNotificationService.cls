public class AlumniNotificationService {

    public static void notifyAlumniOffice(
        List<Application__c> newApplications,
        Map<Id, Application__c> oldMap
    ) {

        for (Application__c app : newApplications) {

            Application__c oldApp = oldMap.get(app.Id);

            if (oldApp.Status__c != 'Offer Accepted' &&
                app.Status__c == 'Offer Accepted') {

                System.debug('Alumni Office Notified');

            }
        }
    }
}