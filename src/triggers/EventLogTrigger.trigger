/**
 * Created by Ruslan on 23.05.2022.
 */

trigger EventLogTrigger on Event_Log__e (after insert) {
    EventLogTriggerHandler eventLog = new EventLogTriggerHandler();

    if (Trigger.isAfter && Trigger.isInsert) {
        eventLog.insertLog(Trigger.new);
    }
}