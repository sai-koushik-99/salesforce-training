@isTest
private class LeadProcessorTestCopy {

    @isTest
    static void testLeadProcessor() {

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

        LeadProcessorCopy lp = new LeadProcessorCopy();
        Database.executeBatch(lp);

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