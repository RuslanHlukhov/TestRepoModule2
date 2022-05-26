/**
 * Created by Ruslan on 24.05.2022.
 */
@IsTest
private with sharing class AccountProcessorTest {
    @IsTest
    private static void countContactTest() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 300; i++) {
            accounts.add(new Account(Name = 'Test Name' + i));
        }
        insert accounts;

        List<Contact> contacts = new List<Contact>();
        List<Id> accountsIds = new List<Id>();
        for (Account acc : accounts) {
            contacts.add(new Contact(FirstName = acc.Name, LastName = 'test contact', AccountId = acc.Id));
            accountsIds.add(acc.Id);
        }
        insert contacts;
        Test.startTest();
        AccountProcessor.countContacts(accountsIds);
        Test.stopTest();

        List<Account> accs = [SELECT Id, Number_Of_Contacts__c FROM Account];
        for (Account acc : accs) {
            System.assertEquals(1, acc.Number_Of_Contacts__c, 'Error');
        }
    }
}