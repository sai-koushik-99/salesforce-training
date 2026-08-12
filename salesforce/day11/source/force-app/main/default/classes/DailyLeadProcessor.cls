public class DailyLeadProcessor implements Schedulable {

    public void execute(SchedulableContext sc) {

        List<Lead> leads = [
            SELECT Id, LeadSource
            FROM Lead
            WHERE LeadSource = null
            LIMIT 200
        ];

        for(Lead l : leads) {

            l.LeadSource = 'Dreamforce';
        }

        update leads;
    }
}