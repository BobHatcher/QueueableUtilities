/**
 * Created by bhatcher on 6/16/20.
 */

@IsTest
public with sharing class AccountTriggerHandlerQueuableTest {

    public static testmethod void baseTest(){
        Account parentAccount = new Account( Name = 'Parent Account');
        insert parentAccount;
        Account childAccount = new Account( Name = 'Child Account', ParentId = parentAccount.Id);
        Account secondParentAccount = new Account( Name = 'Second Parent Account');

        insert new List<Account>{childAccount, secondParentAccount};

        // the 1st queueable will go through as queueable, and the rest will be synchronous within it
        // so be sure to use start test and stop test.
        Test.StartTest();
        parentAccount.Name = 'Updated Account Name';
        childAccount.ParentId = secondParentAccount.Id;
        update new List<Account>{childAccount, parentAccount};
        Test.StopTest();

        // Assertions
    }
}