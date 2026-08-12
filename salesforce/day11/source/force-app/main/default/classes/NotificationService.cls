public class NotificationService {

    public static void sendNotifications(
        List<Application__c> newApplications,
        Map<Id,Application__c> oldMap
    ){

        for(Application__c app : newApplications){

            Application__c oldApp = oldMap.get(app.Id);

            if(oldApp.Status__c != app.Status__c){

                if(app.Status__c == 'Interview Scheduled'
                || app.Status__c == 'Selected'
                || app.Status__c == 'Rejected'){

                    System.debug('Notification Sent');

                }

            }

        }

    }

}