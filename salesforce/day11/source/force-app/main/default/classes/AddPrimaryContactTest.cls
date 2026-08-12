@isTest
private class AddPrimaryContactTest {

    @isTest
    static void testAddPrimaryContact() {

        List<Account> accounts = new List<Account>();

        for(Integer i = 0; i < 50; i++) {

            accounts.add(
                new Account(
                    Name = 'NY Account ' + i,
                    BillingState = 'NY'
                )
            );
        }

        for(Integer i = 0; i < 50; i++) {

            accounts.add(
                new Account(
                    Name = 'CA Account ' + i,
                    BillingState = 'CA'
                )
            );
        }

        insert accounts;

        Contact c = new Contact(
            FirstName = 'Test',
            LastName = 'Contact'
        );

        Test.startTest();

        AddPrimaryContact job =
            new AddPrimaryContact(c, 'CA');

        System.enqueueJob(job);

        Test.stopTest();

        List<Contact> contacts = [
            SELECT Id, AccountId
            FROM Contact
        ];

        System.assertEquals(
            50,
            contacts.size()
        );
    }
}