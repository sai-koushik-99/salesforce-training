public class StatisticsService {

    public static void updateStatistics(
        List<Application__c> newApplications,
        Map<Id,Application__c> oldMap
    ){

        for(Application__c app : newApplications){

            Application__c oldApp = oldMap.get(app.Id);

            if(oldApp.Status__c != 'Selected' &&
               app.Status__c == 'Selected'){

                System.debug('Placement Statistics Updated');

            }

        }

    }

}