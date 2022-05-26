/**
 * Created by Ruslan on 23.05.2022.
 */

public with sharing class Logger {
    public static void log(Database.BatchableContext context, Exception ex, LoggingLevel level) {
        Event_Log__e event = new Event_Log__e(
                Message__c = ex.getMessage().left(255),
                User_Name__c = UserInfo.getFirstName() + ' ' + UserInfo.getLastName(),
                Stack_trace_String__c = ex.getStackTraceString().left(255),
                Logging_Level__c = level.name(),
                Context_Id__c = context.getJobId(),
                Context_Name__c = [SELECT ApexClassId FROM AsyncApexJob WHERE Id = :context.getJobId()].ApexClass.Name
        );

        EventBus.publish(event);
    }
    public static void log(String message, LoggingLevel level) {
        Event_Log__e event = new Event_Log__e(
                Message__c = message.left(255),
                Logging_Level__c = level.name()
        );
        EventBus.publish(event);
    }
}