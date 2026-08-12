public class AccountProcessor {
    
    @future
    public static void countContacts(Set<Id> accountIds) {
        
        List<Account> accounts = [
            SELECT Id, Number_of_Contacts__c
            FROM Account
            WHERE Id IN :accountIds
        ];
        
        for(Account acc : accounts) {
            acc.Number_of_Contacts__c = [
                SELECT COUNT()
                FROM Contact
                WHERE AccountId = :acc.Id
            ];
        }
        
        update accounts;
    }
}