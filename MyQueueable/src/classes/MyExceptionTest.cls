@IsTest
public with sharing class MyExceptionTest {

    /**
     * Bob Hatcher February 2021
     * @BobHatcher - stupidcrmtricks.com
     * Documentation: https://github.com/BobHatcher/QueueableUtilities/wiki
     *
     * Licensed GNU GENERAL PUBLIC LICENSE Version 2 (June 1991)
     * Use at your own risk - no warranty expressed or implied
     *
     */

    public static final String ERROR_NAME = 'ERRORNAME';
    public static final String PROCESS_NAME = 'PROCESSNAME';
    public static final String ERROR_MESSAGE = 'ERRORMESSAGE';
    public static final String EXCEPTION_MSG = 'EXCEPTIONMESSAGE';
    public static Set<Id> ids = new Set<Id>();


    @IsTest static void insertWarning() {

        Account a = new Account(Name = 'WarningTest');
        insert a;

        MyException.insertWarning(ERROR_NAME, ERROR_MESSAGE, PROCESS_NAME, a.Id);

        Test.startTest();
        List<Error_Log__c> errors = [SELECT Name, Description__c, Error_Message__c, Process_or_Tool_Name__c, Record_ID__c, Type__c, Level__c FROM Error_Log__c];
        Test.stopTest();

        System.assertEquals(errors.size(), 1);

        for (Error_Log__c error : errors) {
            System.assertEquals(error.Type__c, 'Apex');
            System.assertEquals(error.Name, ERROR_NAME);
            System.assert(error.Record_ID__c.contains(a.Id));
            System.assertEquals(error.Description__c, ERROR_NAME);
            System.assertEquals(error.Process_or_Tool_Name__c, PROCESS_NAME);
            System.assertEquals(error.Level__c, 'Warning');

        }
    }

    @isTest static void insertException() {

        Account a = new Account(Name = 'ExceptionTest');
        insert a;

        MyException.setIsRunningTest(true); // tells the test class to not throw a hard error

        Test.startTest();
        MyException.insertException(ERROR_NAME, ERROR_MESSAGE, PROCESS_NAME, a.Id);

        Test.stopTest();
        List<Error_Log__c> errors = [SELECT Name, Description__c, Error_Message__c, Process_or_Tool_Name__c, Record_ID__c, Type__c, Level__c FROM Error_Log__c];

        System.assertEquals(errors.size(), 1);

        for (Error_Log__c error : errors) {
            System.assertEquals(error.Type__c, 'Apex');
            System.assertEquals(error.Name, ERROR_NAME);
            System.assert(error.Record_ID__c.contains(a.Id));
            System.assertEquals(error.Description__c, ERROR_NAME);
            System.assertEquals(error.Process_or_Tool_Name__c, PROCESS_NAME);
            System.assertEquals(error.Level__c, 'Error');

        }
    }

    // unable to test MyException methods containing an Exception since Exceptions cannot be constructed
}