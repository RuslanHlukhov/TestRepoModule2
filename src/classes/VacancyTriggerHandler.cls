/**
 * Created by Ruslan on 26.05.2022.
 */

public with sharing class VacancyTriggerHandler {
    public void vacancyUser(List<Vacancy__c> newVacancy, Map<Id, Vacancy__c> oldVacancy) {
        makePublic(newVacancy);
        makePrivate(newVacancy, oldVacancy);
    }

    public static void makePublic(List<Vacancy__c> newVacancy) {

        List<Vacancy__Share> shareVacancyToEdit = new List<Vacancy__Share>();
        for (Vacancy__c vacancy : newVacancy) {

            if (vacancy.User__c == '005IY000000ZZiVYAW') {
                Vacancy__Share shareVacancy = new Vacancy__Share();
                shareVacancy.ParentId = vacancy.Id;
                shareVacancy.AccessLevel = 'Read';
                shareVacancy.UserOrGroupId = '005IY000000ZZiVYAW';
                shareVacancy.RowCause = 'Manual';

                shareVacancyToEdit.add(shareVacancy);
            }
        }
        if (!shareVacancyToEdit.isEmpty()) {
            insert shareVacancyToEdit;
        }
        System.debug('shareVacancyToEdit ' + shareVacancyToEdit);
    }

    private static void makePrivate(List<Vacancy__c> newVacancy, Map<Id, Vacancy__c> oldVacancy) {

        List<Id> deleteSharedVacancy = new List<Id>();

        for (Vacancy__c vacancy : newVacancy) {
            if (oldVacancy.get(vacancy.Id).User__c == '005IY000000ZZiVYAW' && vacancy.User__c != '005IY000000ZZiVYAW') {
                deleteSharedVacancy.add(vacancy.Id);
            }
            if (!deleteSharedVacancy.isEmpty()) {
                delete [SELECT Id FROM Vacancy__Share WHERE ParentId IN :deleteSharedVacancy AND RowCause = 'Manual'];
            }
        }
    }
}

