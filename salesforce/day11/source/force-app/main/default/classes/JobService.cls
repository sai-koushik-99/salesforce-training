public class JobService {

    public static Job__c getJob(Id jobId){

        Job__c job = [
            SELECT Id,
                   Name,
                   Minimum_CGPA__c
            FROM Job__c
            LIMIT 1
        ];

        return job;
    }

}