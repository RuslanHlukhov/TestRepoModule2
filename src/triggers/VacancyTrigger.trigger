/**
 * Created by Ruslan on 26.05.2022.
 */

trigger VacancyTrigger on Vacancy__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    VacancyTriggerHandler vacancy = new VacancyTriggerHandler();

    if (Trigger.isBefore && Trigger.isUpdate) {
        vacancy.vacancyUser(Trigger.new, Trigger.oldMap);
    }
}