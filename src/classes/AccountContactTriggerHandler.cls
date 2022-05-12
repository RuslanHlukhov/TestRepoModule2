/**
 * Created by Ruslan on 12.05.2022.
 */

public with sharing class AccountContactTriggerHandler {

    public static void onBeforeInsert(List<AccountContact__c> ListNew) {
        Set<Id> contactsIds = new Set<Id>();
        for (AccountContact__c accountContact : ListNew) {
            contactsIds.add(accountContact.Contact__c);
        }
        List<AccountContact__c> accountContactList = [SELECT Id, Contact__c, Workplace__c, Account__c, isPrimary__c FROM AccountContact__c WHERE Contact__c IN :contactsIds];
        Set<Id> contactIdWithRecordOnAccountContact = new Set<Id>();
        if (!accountContactList.isEmpty()) {
            for (AccountContact__c accountContact : accountContactList) {
                contactIdWithRecordOnAccountContact.add(accountContact.Contact__c);
            }
        }
        for (AccountContact__c accountContact : ListNew) {
            if (contactsIds.contains(accountContact.Contact__c)) {
                accountContact.isPrimary__c = true;
            }
        }
    }

    public void twoBeforeUpdate(Map<Id, AccountContact__c> mapOld, Map<Id, AccountContact__c> mapNew) {
        List<AccountContact__c> accountContsctsUpdate = new List<AccountContact__c>();
        Set<Id> contactsIds = new Set<Id>();
        Set<Id> accountContactIdsWithIsPrimaryTrue = new Set<Id>();
        for (Id accountContactId : mapNew.keySet()) {
            if (mapOld.get(accountContactId).isPrimary__c != mapNew.get(accountContactId).isPrimary__c) {
                if (mapOld.get(accountContactId).isPrimary__c == true) {
                    contactsIds.add(mapOld.get(accountContactId).Contact__c);
                    accountContactIdsWithIsPrimaryTrue.add(accountContactId);
                }
            }
        }
        List<AccountContact__c> accountContactList = [
                SELECT Id, Contact__c, Workplace__c, Account__c, isPrimary__c, CreatedDate
                FROM AccountContact__c
                WHERE Contact__c IN :contactsIds
                AND Id NOT IN :accountContactIdsWithIsPrimaryTrue
        ];
        Map<Id, List<AccountContact__c>> accountContactListByContactId = new Map<Id, List<AccountContact__c>>();
        for (AccountContact__c accountContact : accountContactList) {
            if (accountContactListByContactId.containsKey(accountContact.Contact__c)) {
                accountContactListByContactId.get(accountContact.Contact__c).add(accountContact);
            } else {
                accountContactListByContactId.put(accountContact.Contact__c, new List<AccountContact__c>{
                        accountContact
                });
            }
        }
        System.debug(accountContactListByContactId);
        for (Id contactId : accountContactListByContactId.keySet()) {
            List<AccountContact__c> listAccountContact = accountContactListByContactId.get(contactId);
            AccountContact__c accountContactToMakePrimary = listAccountContact.get(0);
            for (AccountContact__c accountContact : listAccountContact) {
                if (accountContact.CreatedDate > accountContactToMakePrimary.CreatedDate) {
                    accountContactToMakePrimary = accountContact;
                }
            }
            accountContactToMakePrimary.isPrimary__c = true;
            accountContsctsUpdate.add(accountContactToMakePrimary);
        }

        update accountContsctsUpdate;

    }
    public void threeBeforeUpdate(Map<Id, AccountContact__c> mapOld, Map<Id, AccountContact__c> mapNew) {
        List<AccountContact__c> accountContsctsUpdate = new List<AccountContact__c>();
        Set<Id> contactsIds = new Set<Id>();
        Set<Id> changedAccountContactIds = new Set<Id>();
        for (Id accountContactId : mapNew.keySet()) {
            if (mapOld.get(accountContactId).isPrimary__c != mapNew.get(accountContactId).isPrimary__c) {
                if (mapOld.get(accountContactId).isPrimary__c == false) {
                    contactsIds.add(mapOld.get(accountContactId).Contact__c);
                    changedAccountContactIds.add(accountContactId);
                }
            }
        }
        List<AccountContact__c> accountContactList = [
                SELECT Id, Contact__c, Workplace__c, Account__c, isPrimary__c, CreatedDate
                FROM AccountContact__c
                WHERE Contact__c IN :contactsIds
                AND Id NOT IN :changedAccountContactIds AND isPrimary__c = true
        ];
        for (AccountContact__c accountContact : accountContactList) {
            accountContact.isPrimary__c = false;
            accountContsctsUpdate.add(accountContact);
        }
        update accountContsctsUpdate;
    }
}

