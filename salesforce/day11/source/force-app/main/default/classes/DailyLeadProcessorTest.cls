@isTest
private class DailyLeadProcessorTest {

    @isTest
    static void testDailyLeadProcessor() {

        List<Lead> leads = new List<Lead>();

        for(Integer i = 0; i < 200; i++) {

            leads.add(
                new Lead(
                    LastName = 'Lead ' + i,
                    Company = 'Test Company'
                )
            );
        }

        insert leads;

        Test.startTest();

        String cronExp = '0 0 0 1 1 ? 2099';

        System.schedule(
            'Daily Lead Test',
            cronExp,
            new DailyLeadProcessor()
        );

        Test.stopTest();

        List<Lead> updatedLeads = [
            SELECT Id, LeadSource
            FROM Lead
        ];

        for(Lead l : updatedLeads) {

            System.assertEquals(
                'Dreamforce',
                l.LeadSource
            );
        }
    }
}