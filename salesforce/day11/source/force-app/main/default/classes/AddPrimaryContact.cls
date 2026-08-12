public class AddPrimaryContact implements Queueable {

    private Contact con;
    private String state;

    public AddPrimaryContact(Contact con, String state) {
        this.con = con;
        this.state = state;
    }

    public void execute(QueueableContext context) {

        List<Account> accounts = [
            SELECT Id
            FROM Account
            WHERE BillingState = :state
            LIMIT 200
        ];

        List<Contact> contactsToInsert = new List<Contact>();

        for(Account acc : accounts) {

            Contact c = con.clone(false, false, false, false);

            c.AccountId = acc.Id;

            contactsToInsert.add(c);
        }

        insert contactsToInsert;
    }
}