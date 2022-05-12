trigger AccountContactTrigger on AccountContact__c (before insert, before update) {
    if (checkRecursive.runOnce()) {
        AccountContactTriggerHandler Handler = new AccountContactTriggerHandler();

        if (Trigger.isBefore && Trigger.isInsert) {
            AccountContactTriggerHandler.onBeforeInsert(Trigger.new);
        }
        if (Trigger.isBefore && Trigger.isUpdate) {
            Handler.twoBeforeUpdate(Trigger.oldMap, Trigger.newMap);
        }
        if (Trigger.isBefore && Trigger.isUpdate) {
            Handler.threeBeforeUpdate(Trigger.oldMap, Trigger.newMap);
        }
    }
}
