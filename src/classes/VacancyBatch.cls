public with sharing class VacancyBatch implements Database.Batchable<SObject> {
    private String batchQuery;
    private String standardQuery = 'Select id from Vacancy__c where status__c = \'closed\' ';

    public VacancyBatch(String query) {
        this.batchQuery = query;
    }
    public VacancyBatch() {
        this.batchQuery = standardQuery;
    }

    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator(this.batchQuery);
    }
    public void execute(
            Database.BatchableContext context,
            List<Vacancy__c> vacancies
    ) {

        try {

            delete vacancies;
            Logger.log('Batch finished successfully', LoggingLevel.INFO);
        } catch (Exception ex) {
            Logger.log(context, ex, LoggingLevel.ERROR);
        }
    }

    public void finish(Database.BatchableContext context) {
    }


    public class customException extends Exception {
    }
}
