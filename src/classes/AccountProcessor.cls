/**
 * Created by Ruslan on 24.05.2022.
 */

public without sharing class AccountProcessor {
    @Future
    public static void countContacts(List<Id> accountsIds) {
        List<Account> accounts = [SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE Id IN :accountsIds];

        for (Account acc : accounts) {
            acc.Number_Of_Contacts__c = acc.Contacts.size();
        }
        update accounts;
    }
}