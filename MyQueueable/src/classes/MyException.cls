public virtual class MyException extends Exception {

    /**
     * Bob Hatcher February 2021
     * @BobHatcher - stupidcrmtricks.com
     * Documentation: https://github.com/BobHatcher/QueueableUtilities/wiki
     *
     * Licensed GNU GENERAL PUBLIC LICENSE Version 2 (June 1991)
     * Use at your own risk - no warranty expressed or implied
     *
     */

    // Error processing class for Queueable exceptions. Since they can fail silently, this will insert an
    // Error_Log__c record, and you can use workflow to be notified. This will catch all errors except
    // CPU Time errors.

    // Warnings and exceptions differ in the Level__c value, and errors have an Exception involved
    // In the end Warnings get a passed in message to log, and Exceptions get the stack trace,etc assembled
    // from the core Exception before they are inserted.

    public static Boolean IS_RUNNING_TEST = false;
    public static void setIsRunningTest(Boolean isTest)
    {
        IS_RUNNING_TEST = isTest;
    }

    public static void insertWarning(String eName, String eMessage, String eProcess, String eRecord) {
        Error_Log__c err = getBaseErrLog(eName, eMessage, eProcess, eRecord);
        err.Level__c = 'Warning';
        insert err;
    }

    /// Core Insert Method
    public static void insertException(String eName, String eMessage, String eProcess, String eRecord) {
        Error_Log__c err = getBaseErrLog(eName, eMessage, eProcess, eRecord);
        err.Level__c = 'Error';
        insert err;
        if (Test.isRunningTest() && !IS_RUNNING_TEST) {
            throw new MyException(eMessage);
        }
    }

    private static Error_Log__c getBaseErrLog(String eName, String eMessage, String eProcess, String eRecord) {
        return new Error_Log__c(
                Name = eName.abbreviate(80),
                Description__c = eName,
                Error_Message__c = eMessage,
                Process_or_Tool_Name__c = eProcess.abbreviate(255),
                Record_ID__c = eRecord.abbreviate(10000),
                Type__c = 'Apex');
    }

    // Splits an error up into a text block
    private static String getDescription(Exception e) {
        if (e == null){
            return '';
        } else {
            return 'Type: ' + e.getTypeName() + ' \nMessage: ' + e.getMessage() + '\nCause: ' + e.getCause() + '\nStack Trace: ' + e.getStackTraceString();
        }
    }


    public static void insertException(String eName, Exception e, String eMethodName, String eRecord) {
        insertException(eName, getDescription(e), eMethodName, eRecord);
        if (QueueableUtilities.IS_RUNNING_TEST) {
            throw e;
        }
    }

    // Override method so we can easily send in a set of ID's
    // Convert any list of objects to a Set using --> (new Map<Id,SObject>(contacts)).keySet())
    public static void insertException(String eName, Exception e, String eMethodName, Set<Id> idList) {
        insertException(eName, getDescription(e), eMethodName, 'ID List: ' + idSetToString(idList));
        if (QueueableUtilities.IS_RUNNING_TEST) {
            throw e;
        }
    }

    public static void insertException(String eName, Exception e, String eMethodName, List<sObject> records) {
        insertException(eName, getDescription(e), eMethodName, 'ID List: ' + allIdsFromList(records));
        if (QueueableUtilities.IS_RUNNING_TEST) {
            throw e;
        }
    }

    // Override method so we can easily send in a set of ID's
    public static void insertWarning(String eName, String eMessage, String eMethodName, Set<Id> idList) {
        insertException(eName, eMessage, eMethodName, 'ID List: ' + idSetToString(idList));
    }

    private static String idSetToString(Set<Id> objects) {
        String idStr = '';
        for (Id s : objects) {
            idStr += (idStr == '' ? '' : ',') + s;
        }
        return idStr;
    }

    public static Set<Id> allIdsFromList(List<sObject> objects){
        if (objects==null || objects.size() == 0){
            return new Set<Id>();
        } else {
            Set<Id> allIds = new Set<Id>();
            for (sObject myObj: objects){
                if (myObj.Id != null){
                    allIds.add(myObj.Id);
                }
            }
            return allIds;
        }
    }

    public static Set<Id> allIdsFromInstructionMap(Map<String,List<sObject>> objects){
        Set<Id> allIds = new Set<Id>();
        for (String key: objects.keySet()){
            allIds.addAll(allIdsFromList(objects.get(key)));
        }
        return allIds;
    }
}