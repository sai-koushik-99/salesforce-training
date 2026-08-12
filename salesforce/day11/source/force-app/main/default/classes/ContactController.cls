public with sharing class ContactController {

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList() {

        throw new AuraHandledException('Forced error');

    }
}