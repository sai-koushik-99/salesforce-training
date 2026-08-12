public class ApplicationService {

    public static void validateEligibility(List<Application__c> applications) {

        Set<Id> studentIds = new Set<Id>();
        Set<Id> jobIds = new Set<Id>();

        for (Application__c app : applications) {

            if (app.Student__c != null)
                studentIds.add(app.Student__c);

            if (app.Job__c != null)
                jobIds.add(app.Job__c);

        }

        Map<Id, Student__c> studentMap =
            new Map<Id, Student__c>([
                SELECT Id, CGPA__c
                FROM Student__c
                WHERE Id IN :studentIds
            ]);

        Map<Id, Job__c> jobMap =
            new Map<Id, Job__c>([
                SELECT Id, Minimum_CGPA__c
                FROM Job__c
                WHERE Id IN :jobIds
            ]);

        for (Application__c app : applications) {

            Student__c student = studentMap.get(app.Student__c);
            Job__c job = jobMap.get(app.Job__c);

            if (student != null && job != null) {

                if (student.CGPA__c < job.Minimum_CGPA__c) {

                    app.addError('Student is not eligible.');

                }

            }

        }

    }
    public static void markStudentsSelected(

        List<Application__c> applications,
        Map<Id,Application__c> oldMap){

        Set<Id> studentIds = new Set<Id>();

        for(Application__c app : applications){

            Application__c oldApp = oldMap.get(app.Id);

            if(oldApp.Status__c != 'Selected'
                && app.Status__c == 'Selected'){

                studentIds.add(app.Student__c);

            }

        }

        List<Student__c> students = [

            SELECT Id, Placement_Status__c

            FROM Student__c

            WHERE Id IN :studentIds

        ];

        for(Student__c stu : students){

            stu.Placement_Status__c = 'Selected';

        }

        update students;

    }

}