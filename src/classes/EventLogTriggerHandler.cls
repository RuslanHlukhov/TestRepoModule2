/**
 * Created by Ruslan on 23.05.2022.
 */

public with sharing class EventLogTriggerHandler {
    public void insertLog(List<Event_Log__e> ListNew) {
        List<Log__c> logs = new List<Log__c>();
        for (Event_Log__e event : ListNew) {
            logs.add(new Log__c(
                    Message__c = event.Message__c,
                    User_Name__c = event.User_Name__c,
                    Stack_trace_String__c = event.Stack_trace_String__c,
                    Logging_Level__c = event.Logging_Level__c,
                    Context_Id__c = event.Context_Id__c,
                    Context_Name__c = event.Context_Name__c
            )
            );
        }
        insert logs;
    }
}