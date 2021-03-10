/**
 * Created by bhatcher on 3/10/21.
 */

@IsTest
public with sharing class AccountTriggerHandlerTest {

    /**
     * Bob Hatcher February 2021
     * @BobHatcher - stupidcrmtricks.com
     * Documentation: https://github.com/BobHatcher/QueueableUtilities/wiki
     *
     * Licensed GNU GENERAL PUBLIC LICENSE Version 2 (June 1991)
     * Use at your own risk - no warranty expressed or implied
     *
     */

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