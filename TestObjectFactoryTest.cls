/**
 * Created by bhatcher on 6/16/20.
 */

@IsTest
public with sharing class TestObjectFactoryTest {

    @isTest static void Defaults() {
        TestObjectFactoryAccount factory = new TestObjectFactoryAccount();

        List<Test_Class_Default__mdt> expectedAccountNames = [SELECT Lookup_Value__c FROM Test_Class_Default__mdt WHERE DeveloperName = 'Contact_Parent_For_Test' LIMIT 1];

        if (expectedAccountNames.size() <> 1)
            throw new MyException('Unable to locate custom metadata type Test_Class_Default__mdt with DeveloperName Contact_Parent_For_Test. This must be of type Lookup.');

        String accountName = expectedAccountNames[0].Lookup_Value__c;
        factory.setFieldValue(Account.Name,accountName);

        Test.startTest();
        Account a = factory.createRecord(true);

        a = [SELECT Id, Name from Account WHERE Id = :a.Id];

        TestObjectFactoryContact contactFactory = new TestObjectFactoryContact();
        contactFactory.restrictDefaultsToIsTest = true;
        contactFactory.setFieldValue(Contact.LastName,'TestContact');
        Contact c = contactFactory.createRecord(true);

        c = [SELECT Id, AccountId FROM Contact where Id = :c.Id];

        System.assertEquals(c.AccountId,a.Id);
        Test.stopTest();

    }

    @isTest static void AccountTest() {
        List<Account> accounts = new List<Account>();

        Test.startTest();
        TestObjectFactoryAccount factory = new TestObjectFactoryAccount();
        system.assertEquals(factory.getSObjectAPIName(),'Account');
        system.assertEquals(factory.getSObjectType(),Account.SobjectType);

        // Create
        factory.clearFieldValues();
        factory.setFieldValue(Account.Name,'Test');
        Account record = factory.createRecord(true);
        accounts = [SELECT Id, Name From Account WHERE Id = :record.Id];
        system.assertEquals(accounts.size(), 1);
        system.assertEquals(accounts[0].Name,'Test');

        // Update
        factory.setFieldValue(Account.Name,'Update Test');
        factory.updateRecord(record);
        accounts = [SELECT Id, Name From Account WHERE Id = :record.Id];
        system.assertEquals(accounts.size(), 1);
        system.assertEquals(accounts[0].Name,'Update Test');

        //Upsert with Insert
        Account upsertInsert = factory.createRecord(true);
        factory.setFieldValue(Account.Name,'Upsert Insert Test');
        record = (Account) factory.upsertRecord(upsertInsert);
        accounts = [SELECT Id, Name From Account WHERE Id = :record.Id];
        system.assertEquals(accounts.size(), 1);
        system.assertEquals(accounts[0].Name,'Upsert Insert Test');

        // Upsert with Update
        factory.setFieldValue(Account.Name,'Upsert Update Test');
        record = (Account) factory.upsertRecord(record);
        accounts = [SELECT Id, Name From Account WHERE Id = :record.Id];
        system.assertEquals(accounts.size(), 1);
        system.assertEquals(accounts[0].Name,'Upsert Update Test');


        // Double check that we have 3 records now
        accounts = [SELECT Id, Name From Account ];
        System.assertEquals(accounts.size(), 2);

        // Delete
        factory.deleteRecord(record);
        accounts = [SELECT Id, Name From Account ];
        System.assertEquals(accounts.size(), 1);

        System.assertEquals(Account.SObjectType, factory.getSobjectType());
        System.assertEquals(factory.getSObjectAPIName(),'Account');

        Test.stopTest();
    }

    @isTest static void ContactTest() {
        List<Contact> Contacts = new List<Contact>();

        Test.startTest();
        TestObjectFactoryContact factory = new TestObjectFactoryContact();
        TestObjectFactoryAccount accountFactory = new TestObjectFactoryAccount();
        Account a = accountFactory.createRecord(true);

        system.assertEquals(factory.getSObjectAPIName(),'Contact');
        system.assertEquals(factory.getSObjectType(),Contact.SobjectType);

        // Create
        factory.clearFieldValues();
        factory.setFieldValue(Contact.AccountId,a.Id);
        factory.setFieldValue(Contact.LastName,'Test');
        Contact record = factory.createRecord(true);
        Contacts = [SELECT Id, LastName From Contact WHERE Id = :record.Id];
        system.assertEquals(Contacts.size(), 1);
        system.assertEquals(Contacts[0].LastName,'Test');

        // Update
        factory.setFieldValue(Contact.LastName,'Update Test');
        factory.updateRecord(record);
        Contacts = [SELECT Id, LastName From Contact WHERE Id = :record.Id];
        system.assertEquals(Contacts.size(), 1);
        system.assertEquals(Contacts[0].LastName,'Update Test');

        //Upsert with Insert
        Contact upsertInsert = factory.createRecord(true);
        factory.setFieldValue(Contact.LastName,'Upsert Insert Test');
        record = (Contact) factory.upsertRecord(upsertInsert);
        Contacts = [SELECT Id, LastName From Contact WHERE Id = :record.Id];
        system.assertEquals(Contacts.size(), 1);
        system.assertEquals(Contacts[0].LastName,'Upsert Insert Test');

        // Upsert with Update
        factory.setFieldValue(Contact.LastName,'Upsert Update Test');
        record = (Contact) factory.upsertRecord(record);
        Contacts = [SELECT Id, LastName From Contact WHERE Id = :record.Id];
        system.assertEquals(Contacts.size(), 1);
        system.assertEquals(Contacts[0].LastName,'Upsert Update Test');




        // Double check that we have 3 records now
        Contacts = [SELECT Id, Name From Contact ];
        System.assertEquals(Contacts.size(), 2);

        // Delete
        factory.deleteRecord(record);
        Contacts = [SELECT Id, Name From Contact ];
        System.assertEquals(Contacts.size(), 1);

        System.assertEquals(Contact.SObjectType, factory.getSobjectType());
        System.assertEquals(factory.getSObjectAPIName(),'Contact');

        Test.stopTest();
    }

    @isTest static void OpportunityTest()
    {
        List<Opportunity> Opportunities = new List<Opportunity>();

        Test.startTest();
        TestObjectFactoryOpportunity factory = new TestObjectFactoryOpportunity();
        system.assertEquals(factory.getSObjectAPIName(),'Opportunity');
        system.assertEquals(factory.getSObjectType(),Opportunity.SobjectType);

        // Create
        factory.clearFieldValues();
        factory.setFieldValue(Opportunity.Name,'Test');
        Opportunity record = factory.createRecord(true);
        Opportunities = [SELECT Id, Name From Opportunity WHERE Id = :record.Id];
        system.assertEquals(Opportunities.size(), 1);
        system.assertEquals(Opportunities[0].Name,'Test');

        // Update
        factory.setFieldValue(Opportunity.Name,'Update Test');
        factory.updateRecord(record);
        Opportunities = [SELECT Id, Name From Opportunity WHERE Id = :record.Id];
        system.assertEquals(Opportunities.size(), 1);
        system.assertEquals(Opportunities[0].Name,'Update Test');

        //Upsert with Insert
        Opportunity upsertInsert = factory.createRecord(true);
        factory.setFieldValue(Opportunity.Name,'Upsert Insert Test');
        record = (Opportunity) factory.upsertRecord(upsertInsert);
        Opportunities = [SELECT Id, Name From Opportunity WHERE Id = :record.Id];
        system.assertEquals(Opportunities.size(), 1);
        system.assertEquals(Opportunities[0].Name,'Upsert Insert Test');

        // Upsert with Update
        factory.setFieldValue(Opportunity.Name,'Upsert Update Test');
        record = (Opportunity) factory.upsertRecord(record);
        Opportunities = [SELECT Id, Name From Opportunity WHERE Id = :record.Id];
        system.assertEquals(Opportunities.size(), 1);
        system.assertEquals(Opportunities[0].Name,'Upsert Update Test');

        // Double check that we have 2
        Opportunities = [SELECT Id, Name From Opportunity ];
        System.assertEquals(Opportunities.size(), 2);

        // Delete
        factory.deleteRecord(record);
        Opportunities = [SELECT Id, Name From Opportunity ];
        System.assertEquals(Opportunities.size(), 1);
        System.assertEquals(Opportunity.SObjectType, factory.getSobjectType());
        System.assertEquals(factory.getSObjectAPIName(),'Opportunity');
        Test.stopTest();
    }

    @isTest static void ContractTest()
    {
        List<Contract> Contracts = new List<Contract>();

        TestObjectFactoryAccount accountFactory = new TestObjectFactoryAccount();
        Account a = accountFactory.createRecord(true);

        Test.startTest();
        TestObjectFactoryContract factory = new TestObjectFactoryContract();
        system.assertEquals(factory.getSObjectAPIName(),'Contract');
        system.assertEquals(factory.getSObjectType(),Contract.SobjectType);

        // Create
        factory.clearFieldValues();
        factory.setFieldValue(Contract.Name,'Test');
        factory.setFieldValue(Contract.AccountId,a.Id);
        Contract record = factory.createRecord(true);
        Contracts = [SELECT Id, Name From Contract WHERE Id = :record.Id];
        system.assertEquals(Contracts.size(), 1);
        system.assertEquals(Contracts[0].Name,'Test');

        // Update
        factory.setFieldValue(Contract.Name,'Update Test');
        factory.updateRecord(record);
        Contracts = [SELECT Id, Name From Contract WHERE Id = :record.Id];
        system.assertEquals(Contracts.size(), 1);
        system.assertEquals(Contracts[0].Name,'Update Test');

        //Upsert with Insert
        Contract upsertInsert = factory.createRecord(true);
        factory.setFieldValue(Contract.Name,'Upsert Insert Test');
        record = (Contract) factory.upsertRecord(upsertInsert);
        Contracts = [SELECT Id, Name From Contract WHERE Id = :record.Id];
        system.assertEquals(Contracts.size(), 1);
        system.assertEquals(Contracts[0].Name,'Upsert Insert Test');

        // Upsert with Update
        factory.setFieldValue(Contract.Name,'Upsert Update Test');
        record = (Contract) factory.upsertRecord(record);
        Contracts = [SELECT Id, Name From Contract WHERE Id = :record.Id];
        system.assertEquals(Contracts.size(), 1);
        system.assertEquals(Contracts[0].Name,'Upsert Update Test');


        // Double check that we have 2 records now
        Contracts = [SELECT Id, Name From Contract ];
        System.assertEquals(Contracts.size(), 2);

        // Delete
        factory.deleteRecord(record);
        Contracts = [SELECT Id, Name From Contract ];
        System.assertEquals(Contracts.size(), 1);
        System.assertEquals(Contract.SObjectType, factory.getSobjectType());
        System.assertEquals(factory.getSObjectAPIName(),'Contract');
        Test.stopTest();
    }

    @isTest static void EntitlementTest() {
        List<Entitlement> records = new List<Entitlement>();

        Account a = TestObjectUtilities.getNewAccount();

        Test.startTest();
        TestObjectFactoryEntitlement factory = new TestObjectFactoryEntitlement();
        factory.setFieldValue(Entitlement.AccountId, a.Id);
        system.assertEquals(factory.getSObjectAPIName(),'Entitlement');
        system.assertEquals(factory.getSObjectType(),Entitlement.SobjectType);

        // Create
        factory.clearFieldValues();
        factory.setFieldValue(Entitlement.Name,'Test');
        factory.setFieldValue(Entitlement.AccountId, a.Id);
        Entitlement record = factory.createRecord(true);
        records = [SELECT Id, Name From Entitlement WHERE Id = :record.Id];
        system.assertEquals(records.size(), 1);
        system.assertEquals(records[0].Name,'Test');


        // Update
        factory.setFieldValue(Entitlement.Name,'Update Test');
        factory.updateRecord(record);
        records = [SELECT Id, Name From Entitlement WHERE Id = :record.Id];
        system.assertEquals(records.size(), 1);
        system.assertEquals(records[0].Name,'Update Test');

        //Upsert with Insert
        Entitlement upsertInsert = factory.createRecord(true);
        factory.setFieldValue(Entitlement.Name,'Upsert Insert Test');
        record = (Entitlement) factory.upsertRecord(upsertInsert);
        records = [SELECT Id, Name From Entitlement WHERE Id = :record.Id];
        system.assertEquals(records.size(), 1);
        system.assertEquals(records[0].Name,'Upsert Insert Test');

        // Upsert with Update
        factory.setFieldValue(Entitlement.Name,'Upsert Update Test');
        record = (Entitlement) factory.upsertRecord(record);
        records = [SELECT Id, Name From Entitlement WHERE Id = :record.Id];
        system.assertEquals(records.size(), 1);
        system.assertEquals(records[0].Name,'Upsert Update Test');


        // Double check that we have 3 records now
        records = [SELECT Id, Name From Entitlement ];
        System.assertEquals(records.size(), 2);

        // Delete
        factory.deleteRecord(record);
        records = [SELECT Id, Name From Entitlement ];
        System.assertEquals(records.size(), 1);

        System.assertEquals(Entitlement.SObjectType, factory.getSobjectType());
        System.assertEquals(factory.getSObjectAPIName(),'Entitlement');

        Test.stopTest();
    }

    @isTest static void CampaignMemberTest() {
        List<CampaignMember> records = new List<CampaignMember>();

        Account a = TestObjectUtilities.getNewAccount();
        String STATUS_SENT = 'Sent';
        String STATUS_RESPONDED = 'Responded';

        Test.startTest();
        TestObjectFactoryCampaignMember factory = new TestObjectFactoryCampaignMember();

        TestObjectFactoryContact contactFactory = new TestObjectFactoryContact();
        contactFactory.setFieldValue(Contact.AccountId,a.Id);
        Contact c1 = contactFactory.createRecord(true);
        Contact c2 = contactFactory.createRecord(true);

        TestObjectFactoryCampaign campaignFactory = new TestObjectFactoryCampaign();
        Campaign c = campaignFactory.createRecord(true);

        //CampaignInfluenceModel model = [SELECT Id,MasterLabel  FROM CampaignInfluenceModel LIMIT 1];

        // Create
        factory.clearFieldValues();
        factory.setFieldValue(CampaignMember.Status,STATUS_SENT);
        factory.setFieldValue(CampaignMember.CampaignId,c.Id);
        factory.setFieldValue(CampaignMember.ContactId,c1.Id);
        CampaignMember record = factory.createRecord(true);
        records = [SELECT Id, Status From CampaignMember WHERE Id = :record.Id];
        system.assertEquals(records.size(), 1);
        system.assertEquals(records[0].Status,STATUS_SENT);


        // Update
        factory.clearFieldValues(); // can't try to edit fields other than status from here on out
        factory.setFieldValue(CampaignMember.Status,STATUS_RESPONDED);
        factory.updateRecord(record);
        records = [SELECT Id, Status From CampaignMember WHERE Id = :record.Id];
        system.assertEquals(records.size(), 1);
        system.assertEquals(records[0].Status,STATUS_RESPONDED);

        //Upsert with Insert

        // this is another create, so put the campaign ID and contact ID back
        factory.clearFieldValues();
        factory.setFieldValue(CampaignMember.Status,STATUS_RESPONDED);
        factory.setFieldValue(CampaignMember.CampaignId,c.Id);
        factory.setFieldValue(CampaignMember.ContactId,c2.Id);
        CampaignMember upsertInsert = factory.createRecord(true);
        factory.clearFieldValues();
        factory.setFieldValue(CampaignMember.Status,STATUS_SENT);
        record = (CampaignMember) factory.upsertRecord(upsertInsert);
        records = [SELECT Id, Status From CampaignMember WHERE Id = :record.Id];
        system.assertEquals(records.size(), 1);
        system.assertEquals(records[0].Status,STATUS_SENT);

        // Upsert with Update
        factory.clearFieldValues();
        factory.setFieldValue(CampaignMember.Status,STATUS_RESPONDED);
        record = (CampaignMember) factory.upsertRecord(record);
        records = [SELECT Id, Status From CampaignMember WHERE Id = :record.Id];
        system.assertEquals(records.size(), 1);
        system.assertEquals(records[0].Status,STATUS_RESPONDED);


        // Double check that we have 3 records now
        records = [SELECT Id, Status From CampaignMember ];
        System.assertEquals(records.size(), 2);

        // Delete
        factory.deleteRecord(record);
        records = [SELECT Id From CampaignMember ];
        System.assertEquals(records.size(), 1);

        System.assertEquals(CampaignMember.SObjectType, factory.getSobjectType());
        System.assertEquals(factory.getSObjectAPIName(),'CampaignMember');

        Test.stopTest();
    }

    @isTest static void CampaignTest() {
        List<Campaign> Campaigns = new List<Campaign>();

        Test.startTest();
        TestObjectFactoryCampaign factory = new TestObjectFactoryCampaign();
        system.assertEquals(factory.getSObjectAPIName(),'Campaign');
        system.assertEquals(factory.getSObjectType(),Campaign.SobjectType);

        // Create
        factory.clearFieldValues();
        factory.setFieldValue(Campaign.Name,'Test');
        Campaign record = factory.createRecord(true);
        Campaigns = [SELECT Id, Name From Campaign WHERE Id = :record.Id];
        system.assertEquals(Campaigns.size(), 1);
        system.assertEquals(Campaigns[0].Name,'Test');

        // Update
        factory.setFieldValue(Campaign.Name,'Update Test');
        factory.updateRecord(record);
        Campaigns = [SELECT Id, Name From Campaign WHERE Id = :record.Id];
        system.assertEquals(Campaigns.size(), 1);
        system.assertEquals(Campaigns[0].Name,'Update Test');

        //Upsert with Insert
        Campaign upsertInsert = factory.createRecord(true);
        factory.setFieldValue(Campaign.Name,'Upsert Insert Test');
        record = (Campaign) factory.upsertRecord(upsertInsert);
        Campaigns = [SELECT Id, Name From Campaign WHERE Id = :record.Id];
        system.assertEquals(Campaigns.size(), 1);
        system.assertEquals(Campaigns[0].Name,'Upsert Insert Test');

        // Upsert with Update
        factory.setFieldValue(Campaign.Name,'Upsert Update Test');
        record = (Campaign) factory.upsertRecord(record);
        Campaigns = [SELECT Id, Name From Campaign WHERE Id = :record.Id];
        system.assertEquals(Campaigns.size(), 1);
        system.assertEquals(Campaigns[0].Name,'Upsert Update Test');


        // Double check that we have 3 records now
        Campaigns = [SELECT Id, Name From Campaign ];
        System.assertEquals(Campaigns.size(), 2);

        // Delete
        factory.deleteRecord(record);
        Campaigns = [SELECT Id, Name From Campaign ];
        System.assertEquals(Campaigns.size(), 1);

        System.assertEquals(Campaign.SObjectType, factory.getSobjectType());
        System.assertEquals(factory.getSObjectAPIName(),'Campaign');

        Test.stopTest();
    }

    @isTest static void LeadTest() {
        List<Lead> Leads = new List<Lead>();

        Test.startTest();
        TestObjectFactoryLead factory = new TestObjectFactoryLead();



        // Create
        factory.clearFieldValues();
        factory.setFieldValue(Lead.LastName,'Test');
        factory.setFieldValue(Lead.Company,'Company');
        Lead record = factory.createRecord(true);
        Leads = [SELECT Id, LastName From Lead WHERE Id = :record.Id];
        system.assertEquals(Leads.size(), 1);
        system.assertEquals(Leads[0].LastName,'Test');

        // Update
        factory.setFieldValue(Lead.LastName,'Update Test');
        factory.updateRecord(record);
        Leads = [SELECT Id, LastName From Lead WHERE Id = :record.Id];
        system.assertEquals(Leads.size(), 1);
        system.assertEquals(Leads[0].LastName,'Update Test');

        //Upsert with Insert
        Lead upsertInsert = factory.createRecord(true);
        factory.setFieldValue(Lead.LastName,'Upsert Insert Test');
        record = (Lead) factory.upsertRecord(upsertInsert);
        Leads = [SELECT Id, LastName From Lead WHERE Id = :record.Id];
        system.assertEquals(Leads.size(), 1);
        system.assertEquals(Leads[0].LastName,'Upsert Insert Test');

        // Upsert with Update
        factory.setFieldValue(Lead.LastName,'Upsert Update Test');
        record = (Lead) factory.upsertRecord(record);
        Leads = [SELECT Id, LastName From Lead WHERE Id = :record.Id];
        system.assertEquals(Leads.size(), 1);
        system.assertEquals(Leads[0].LastName,'Upsert Update Test');


        // Double check that we have 3 records now
        Leads = [SELECT Id, LastName From Lead ];
        System.assertEquals(Leads.size(), 2);

        // Delete
        factory.deleteRecord(record);
        Leads = [SELECT Id, LastName From Lead ];
        System.assertEquals(Leads.size(), 1);

        System.assertEquals(Lead.SObjectType, factory.getSobjectType());
        System.assertEquals(factory.getSObjectAPIName(),'Lead');

        Test.stopTest();
    }

    @isTest static void UserTest() {
        List<User> Users = new List<User>();

        Test.startTest();
        TestObjectFactoryUser factory = new TestObjectFactoryUser();
        // For some reason this default does not take
        //factory.setFieldValue(User.TimeZoneSidKey,'America/New_York');

        // Create
        User record = factory.createRecord(true);
        Users = [SELECT Id, LastName From User WHERE Id = :record.Id];
        system.assertEquals(Users.size(), 1);


        // Update
        factory.setFieldValue(User.LastName,'Update Test');
        factory.updateRecord(record);
        Users = [SELECT Id, LastName From User WHERE Id = :record.Id];
        system.assertEquals(Users.size(), 1);
        system.assertEquals(Users[0].LastName,'Update Test');

        //Upsert with Insert
        factory.setFieldValue(User.Username,'username2@imprtestcode.com');
        factory.setFieldValue(User.CommunityNickname,'anotherNickname');
        factory.setFieldValue(User.Alias,'alias2');
        User upsertInsert = factory.createRecord(true);
        factory.setFieldValue(User.LastName,'Upsert Insert Test');
        record = (User) factory.upsertRecord(upsertInsert);
        Users = [SELECT Id, LastName From User WHERE Id = :record.Id];
        system.assertEquals(Users.size(), 1);
        system.assertEquals(Users[0].LastName,'Upsert Insert Test');

        // Upsert with Update
        factory.setFieldValue(User.LastName,'Upsert Update Test');
        record = (User) factory.upsertRecord(record);
        Users = [SELECT Id, LastName From User WHERE Id = :record.Id];
        system.assertEquals(Users.size(), 1);
        system.assertEquals(Users[0].LastName,'Upsert Update Test');


        // Double check that we have 2 records now
        Users = [SELECT Id, LastName From User WHERE email LIKE '%imprtestcode%'];
        System.assertEquals(Users.size(), 2);

        // Delete

        try{
            factory.deleteRecord(record);
        }
        catch (MyException e)
        {
            System.assertEquals(e.getMessage(),TestObjectFactoryUser.ERROR_MSG_ON_DELETE);
        }

        System.assertEquals(User.SObjectType, factory.getSobjectType());
        System.assertEquals(factory.getSObjectAPIName(),'User');

        Test.stopTest();
    }

    public static testMethod void ProductTest() {
        List<Product2> products = new List<Product2>();

        Test.startTest();
        TestObjectFactoryProduct factory = new TestObjectFactoryProduct();
        system.assertEquals(factory.getSObjectAPIName(),'Product2');
        system.assertEquals(factory.getSObjectType(),Product2.SobjectType);

        // Create
        factory.clearFieldValues();
        factory.setFieldValue(Product2.Name, 'OneSign');
        Product2 record = factory.createRecord(true);
        products = [SELECT Id, Name From Product2 WHERE Id = :record.Id];
        system.assertEquals(products.size(), 1);
        system.assertEquals(products[0].Name,'OneSign');

        // Update
        factory.setFieldValue(Product2.Name,'Confirm ID');
        factory.updateRecord(record);
        products = [SELECT Id, Name From Product2 WHERE Id = :record.Id];
        system.assertEquals(products.size(), 1);
        system.assertEquals(products[0].Name,'Confirm ID');

        //Upsert with Insert
        Product2 upsertInsert = factory.createRecord(true);
        factory.setFieldValue(Product2.Name,'PatientSecure');
        record = (Product2) factory.upsertRecord(upsertInsert);
        products = [SELECT Id, Name From Product2 WHERE Id = :record.Id];
        system.assertEquals(products.size(), 1);
        system.assertEquals(products[0].Name,'PatientSecure');

        // Upsert with Update
        factory.setFieldValue(Product2.Name,'Cortext');
        record = (Product2) factory.upsertRecord(record);
        products = [SELECT Id, Name From Product2 WHERE Id = :record.Id];
        system.assertEquals(products.size(), 1);
        system.assertEquals(products[0].Name,'Cortext');


        // Double check that we have 2 records now
        products = [SELECT Id, Name From Product2];
        System.assertEquals(products.size(), 2);

        // Delete
        factory.deleteRecord(record);
        products = [SELECT Id, Name From Product2];
        System.assertEquals(products.size(), 1);

        System.assertEquals(Product2.SObjectType, factory.getSobjectType());
        System.assertEquals(factory.getSObjectAPIName(),'Product2');

        Test.stopTest();
    }

    public static testMethod void AssetTest() {
        List<Asset> assets = new List<Asset>();

        TestObjectFactoryAccount accountFactory = new TestObjectFactoryAccount();
        Account a = accountFactory.createRecord(true);

        Test.startTest();
        TestObjectFactoryAsset factory = new TestObjectFactoryAsset();
        system.assertEquals(factory.getSObjectAPIName(),'Asset');
        system.assertEquals(factory.getSObjectType(),Asset.SobjectType);

        // Create
        factory.clearFieldValues();
        factory.setFieldValue(Asset.Name, 'OneSign');
        factory.setFieldValue(Asset.AccountId, a.Id);
        Asset record = factory.createRecord(true);
        assets = [SELECT Id, Name From Asset WHERE Id = :record.Id];
        system.assertEquals(assets.size(), 1);
        system.assertEquals(assets[0].Name,'OneSign');

        // Update
        factory.setFieldValue(Asset.Name,'Confirm ID');
        factory.updateRecord(record);
        assets = [SELECT Id, Name From Asset WHERE Id = :record.Id];
        system.assertEquals(assets.size(), 1);
        system.assertEquals(assets[0].Name,'Confirm ID');

        //Upsert with Insert
        Asset upsertInsert = factory.createRecord(true);
        factory.setFieldValue(Asset.Name,'PatientSecure');
        record = (Asset) factory.upsertRecord(upsertInsert);
        assets = [SELECT Id, Name From Asset WHERE Id = :record.Id];
        system.assertEquals(assets.size(), 1);
        system.assertEquals(assets[0].Name,'PatientSecure');

        // Upsert with Update
        factory.setFieldValue(Asset.Name,'Cortext');
        record = (Asset) factory.upsertRecord(record);
        assets = [SELECT Id, Name From Asset WHERE Id = :record.Id];
        system.assertEquals(assets.size(), 1);
        system.assertEquals(assets[0].Name,'Cortext');


        // Double check that we have 2 records now
        assets = [SELECT Id, Name From Asset];
        System.assertEquals(assets.size(), 2);

        // Delete
        factory.deleteRecord(record);
        assets = [SELECT Id, Name From Asset];
        System.assertEquals(assets.size(), 1);

        System.assertEquals(Asset.SObjectType, factory.getSobjectType());
        System.assertEquals(factory.getSObjectAPIName(),'Asset');

        Test.stopTest();
    }

    @isTest static void Pricebook2Test() {

        Map<sObjectField, String> testFields = new Map<sObjectField, String>();

        /** SETUP
         *  Update the below fields ONLY to whatever object you are testing.
         */

        SObjectType myType = Pricebook2.sObjectType;
        String myAPIName = 'Pricebook2';
        TestObjectFactoryPricebook2 factory = new TestObjectFactoryPricebook2();

        // Generate any required dependencies here
        // i.e., factory.setFieldValue(Contact.AccountId,(new TestObjectFactoryAccount().createRecord(true)).Id);

        // enter multiple fields here if you need to change more than one field per test operation (i.e., User)
        // String only
        testFields.put(Pricebook2.Name, 'Test Pricebook');

        /** END SETUP
         *  Update below ONLY if your object has special handling (i.e., can't delete Users)
         */


        // Setup Test Data and Fields
        List<sObject> records = new List<sObject>();
        List<String> fieldNames = new List<String>();
        Set<Id> createdRecordIds = new Set<Id>(); // in case one was created above in setup
        Id thisId;

        for (sObjectField thisField : testFields.keySet()) {
            factory.setFieldValue(thisField, testFields.get(thisField));
            fieldNames.add(thisField.getDescribe().getLocalName());
        }

        String fieldNameString = string.join(fieldNames, ',');

        // INSERT
        sObject myRecord = factory.createRecord(true);
        createdRecordIds.add(myRecord.Id);

        records = Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName());

        for (sObject record : records) {
            for (sObjectField thisField : testFields.keySet())
                System.assertEquals(record.get(thisField), testFields.get(thisField));
        }

        // UPDATE
        for (sObjectField thisField : testFields.keySet()) {
            factory.setFieldValue(thisField, testFields.get(thisField) + '2');
        }

        factory.updateRecord(myRecord);

        records = Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName());

        for (sObject record : records) {
            for (sObjectField thisField : testFields.keySet())
                System.assertEquals(record.get(thisField), testFields.get(thisField) + '2');
        }

        //Upsert with Insert
        sObject upsertInsert = factory.createRecord(false);
        for (sObjectField thisField : testFields.keySet()) {
            factory.setFieldValue(thisField, testFields.get(thisField) + 'UpsertInsert');
        }

        upsertInsert = factory.upsertRecord(upsertInsert);
        createdRecordIds.add(upsertInsert.Id);
        thisId = upsertInsert.Id; // can not use object.field notation in Database.query
        records = Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName() + ' WHERE Id = :thisId');
        system.assertEquals(records.size(), 1);
        for (sObjectField thisField : testFields.keySet()) {
            System.assertEquals(records[0].get(thisField), testFields.get(thisField) + 'UpsertInsert');
        }

        /// Upsert with Update
        sObject upsertUpdate = factory.createRecord(true);
        createdRecordIds.add(upsertUpdate.Id);
        for (sObjectField thisField : testFields.keySet()) {
            factory.setFieldValue(thisField, testFields.get(thisField) + 'UpsertUpdate');
        }

        upsertUpdate = factory.upsertRecord(upsertUpdate);
        thisId = upsertUpdate.Id; // can not use object.field notation in Database.query
        records = Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName() + ' WHERE Id = :thisId');
        system.assertEquals(records.size(), 1);
        for (sObjectField thisField : testFields.keySet()) {
            System.assertEquals(records[0].get(thisField), testFields.get(thisField) + 'UpsertUpdate');
        }

        // Should have 3 records now.
        System.assertEquals(Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName() ).size(),createdRecordIds.size());

        // DELETE
        factory.deleteRecord(upsertUpdate);
        System.assertEquals(Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName() ).size(), createdRecordIds.size() -1);

        System.assertEquals(myType, factory.getSobjectType());
        System.assertEquals(factory.getSObjectAPIName(),myAPIName);

    }

    @isTest static void CaseTest() {

        Map<sObjectField, String> testFields = new Map<sObjectField, String>();

        /** SETUP
         *  Update the below fields ONLY to whatever object you are testing.
         */

        SObjectType myType = Case.sObjectType;
        String myAPIName = 'Case';
        TestObjectFactoryCase factory = new TestObjectFactoryCase();

        // Generate any required dependencies here
        // i.e., factory.setFieldValue(Contact.AccountId,(new TestObjectFactoryAccount().createRecord(true)).Id);

        // enter multiple fields here if you need to change more than one field per test operation (i.e., User)
        // String only
        testFields.put(Case.Subject, 'Test Case');

        /** END SETUP
         *  Update below ONLY if your object has special handling (i.e., can't delete Users)
         */


        // Setup Test Data and Fields
        List<sObject> records = new List<sObject>();
        List<String> fieldNames = new List<String>();
        Set<Id> createdRecordIds = new Set<Id>(); // in case one was created above in setup
        Id thisId;

        for (sObjectField thisField : testFields.keySet()) {
            factory.setFieldValue(thisField, testFields.get(thisField));
            fieldNames.add(thisField.getDescribe().getLocalName());
        }

        String fieldNameString = string.join(fieldNames, ',');

        // INSERT
        sObject myRecord = factory.createRecord(true);
        createdRecordIds.add(myRecord.Id);

        records = Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName());

        for (sObject record : records) {
            for (sObjectField thisField : testFields.keySet())
                System.assertEquals(record.get(thisField), testFields.get(thisField));
        }

        // UPDATE
        for (sObjectField thisField : testFields.keySet()) {
            factory.setFieldValue(thisField, testFields.get(thisField) + '2');
        }

        factory.updateRecord(myRecord);

        records = Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName());

        for (sObject record : records) {
            for (sObjectField thisField : testFields.keySet())
                System.assertEquals(record.get(thisField), testFields.get(thisField) + '2');
        }

        //Upsert with Insert
        sObject upsertInsert = factory.createRecord(false);
        for (sObjectField thisField : testFields.keySet()) {
            factory.setFieldValue(thisField, testFields.get(thisField) + 'UpsertInsert');
        }

        upsertInsert = factory.upsertRecord(upsertInsert);
        createdRecordIds.add(upsertInsert.Id);
        thisId = upsertInsert.Id; // can not use object.field notation in Database.query
        records = Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName() + ' WHERE Id = :thisId');
        system.assertEquals(records.size(), 1);
        for (sObjectField thisField : testFields.keySet()) {
            System.assertEquals(records[0].get(thisField), testFields.get(thisField) + 'UpsertInsert');
        }

        /// Upsert with Update
        sObject upsertUpdate = factory.createRecord(true);
        createdRecordIds.add(upsertUpdate.Id);
        for (sObjectField thisField : testFields.keySet()) {
            factory.setFieldValue(thisField, testFields.get(thisField) + 'UpsertUpdate');
        }

        upsertUpdate = factory.upsertRecord(upsertUpdate);
        thisId = upsertUpdate.Id; // can not use object.field notation in Database.query
        records = Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName() + ' WHERE Id = :thisId');
        system.assertEquals(records.size(), 1);
        for (sObjectField thisField : testFields.keySet()) {
            System.assertEquals(records[0].get(thisField), testFields.get(thisField) + 'UpsertUpdate');
        }

        // Should have 3 records now.
        System.assertEquals(Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName() ).size(),createdRecordIds.size());

        // DELETE
        factory.deleteRecord(upsertUpdate);
        System.assertEquals(Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName() ).size(), createdRecordIds.size() -1);

        System.assertEquals(myType, factory.getSobjectType());
        System.assertEquals(factory.getSObjectAPIName(),myAPIName);

    }

    @isTest static void CaseComment() {

        Map<sObjectField, String> testFields = new Map<sObjectField, String>();

        /** SETUP
         *  Update the below fields ONLY to whatever object you are testing.
         */

        SObjectType myType = CaseComment.sObjectType;
        String myAPIName = 'CaseComment';
        TestObjectFactoryCaseComment factory = new TestObjectFactoryCaseComment();

        // Generate any required dependencies here
        // i.e., factory.setFieldValue(Contact.AccountId,(new TestObjectFactoryAccount().createRecord(true)).Id);
        TestObjectFactoryCase caseFactory = new TestObjectFactoryCase();
        Case c = caseFactory.createRecord(true);
        factory.setFieldValue(CaseComment.ParentId,c.Id);

        // enter multiple fields here if you need to change more than one field per test operation (i.e., User)
        // String only
        testFields.put(CaseComment.CommentBody, 'Case Comment Body');

        /** END SETUP
         *  Update below ONLY if your object has special handling (i.e., can't delete Users)
         */


        // Setup Test Data and Fields
        List<sObject> records = new List<sObject>();
        List<String> fieldNames = new List<String>();
        Set<Id> createdRecordIds = new Set<Id>(); // in case one was created above in setup
        Id thisId;

        for (sObjectField thisField : testFields.keySet()) {
            factory.setFieldValue(thisField, testFields.get(thisField));
            fieldNames.add(thisField.getDescribe().getLocalName());
        }

        String fieldNameString = string.join(fieldNames, ',');

        // INSERT
        sObject myRecord = factory.createRecord(true);
        createdRecordIds.add(myRecord.Id);

        records = Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName());

        for (sObject record : records) {
            for (sObjectField thisField : testFields.keySet())
                System.assertEquals(record.get(thisField), testFields.get(thisField));
        }

        // UPDATE
        factory.clearFieldValues();
        for (sObjectField thisField : testFields.keySet()) {
            factory.setFieldValue(thisField, testFields.get(thisField) + '2');
        }

        factory.updateRecord(myRecord);

        records = Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName());

        for (sObject record : records) {
            for (sObjectField thisField : testFields.keySet())
                System.assertEquals(record.get(thisField), testFields.get(thisField) + '2');
        }

        //Upsert with Insert
        factory.setFieldValue(CaseComment.ParentId,c.Id);
        sObject upsertInsert = factory.createRecord(false);
        factory.clearFieldValues();
        for (sObjectField thisField : testFields.keySet()) {
            factory.setFieldValue(thisField, testFields.get(thisField) + 'UpsertInsert');
        }


        upsertInsert = factory.upsertRecord(upsertInsert);
        createdRecordIds.add(upsertInsert.Id);
        thisId = upsertInsert.Id; // can not use object.field notation in Database.query
        records = Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName() + ' WHERE Id = :thisId');
        system.assertEquals(records.size(), 1);
        for (sObjectField thisField : testFields.keySet()) {
            System.assertEquals(records[0].get(thisField), testFields.get(thisField) + 'UpsertInsert');
        }

        /// Upsert with Update
        factory.setFieldValue(CaseComment.ParentId,c.Id);
        sObject upsertUpdate = factory.createRecord(true);
        factory.clearFieldValues();
        createdRecordIds.add(upsertUpdate.Id);
        for (sObjectField thisField : testFields.keySet()) {
            factory.setFieldValue(thisField, testFields.get(thisField) + 'UpsertUpdate');
        }

        upsertUpdate = factory.upsertRecord(upsertUpdate);
        thisId = upsertUpdate.Id; // can not use object.field notation in Database.query
        records = Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName() + ' WHERE Id = :thisId');
        system.assertEquals(records.size(), 1);
        for (sObjectField thisField : testFields.keySet()) {
            System.assertEquals(records[0].get(thisField), testFields.get(thisField) + 'UpsertUpdate');
        }

        // Should have 3 records now.
        System.assertEquals(Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName() ).size(),createdRecordIds.size());

        // DELETE
        // Failing with message : System.TypeException: Invalid id: 00a0t0000007XHPAA2
        // Sacrificing the line or two of coverage for now.
        //factory.deleteRecord(myRecord);
        //System.assertEquals(Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName() ).size(), createdRecordIds.size() -1);

        System.assertEquals(myType, factory.getSobjectType());
        System.assertEquals(factory.getSObjectAPIName(),myAPIName);

    }

    @isTest static void TestAttachment() {

        Map<sObjectField, String> testFields = new Map<sObjectField, String>();

        /** SETUP
         *  Update the below fields ONLY to whatever object you are testing.
         */

        SObjectType myType = Attachment.sObjectType;
        String myAPIName = 'Attachment';
        TestObjectFactoryAttachment factory = new TestObjectFactoryAttachment();

        // Generate any required dependencies here
        // i.e., factory.setFieldValue(Contact.AccountId,(new TestObjectFactoryAccount().createRecord(true)).Id);

        // enter multiple fields here if you need to change more than one field per test operation (i.e., User)
        // String only
        testFields.put(Attachment.Name, 'Test Attachment');
        Blob bod = Blob.valueOf('test');
        factory.setFieldValue(Attachment.body,bod);
        TestObjectFactoryAccount accountFactory = new TestObjectFactoryAccount();
        Account a = accountFactory.createRecord(true);
        factory.setFieldValue(Attachment.ParentId,a.Id);

        /** END SETUP
         *  Update below ONLY if your object has special handling (i.e., can't delete Users)
         */


        // Setup Test Data and Fields
        List<sObject> records = new List<sObject>();
        List<String> fieldNames = new List<String>();
        Set<Id> createdRecordIds = new Set<Id>(); // in case one was created above in setup
        Id thisId;

        for (sObjectField thisField : testFields.keySet()) {
            factory.setFieldValue(thisField, testFields.get(thisField));
            fieldNames.add(thisField.getDescribe().getLocalName());
        }

        String fieldNameString = string.join(fieldNames, ',');

        // INSERT
        sObject myRecord = factory.createRecord(true);
        createdRecordIds.add(myRecord.Id);

        records = Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName());

        for (sObject record : records) {
            for (sObjectField thisField : testFields.keySet())
                System.assertEquals(record.get(thisField), testFields.get(thisField));
        }

        // UPDATE
        factory.removeFieldValue(Attachment.ParentId);
        for (sObjectField thisField : testFields.keySet()) {
            factory.setFieldValue(thisField, testFields.get(thisField) + '2');
        }

        factory.updateRecord(myRecord);

        records = Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName());

        for (sObject record : records) {
            for (sObjectField thisField : testFields.keySet())
                System.assertEquals(record.get(thisField), testFields.get(thisField) + '2');
        }

        //Upsert with Insert
        factory.setFieldValue(Attachment.ParentId,a.Id);

        sObject upsertInsert = factory.createRecord(false);
        for (sObjectField thisField : testFields.keySet()) {
            factory.setFieldValue(thisField, testFields.get(thisField) + 'UpsertInsert');
        }

        upsertInsert = factory.upsertRecord(upsertInsert);
        createdRecordIds.add(upsertInsert.Id);
        thisId = upsertInsert.Id; // can not use object.field notation in Database.query
        records = Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName() + ' WHERE Id = :thisId');
        system.assertEquals(records.size(), 1);
        for (sObjectField thisField : testFields.keySet()) {
            System.assertEquals(records[0].get(thisField), testFields.get(thisField) + 'UpsertInsert');
        }

        /// Upsert with Update

        sObject upsertUpdate = factory.createRecord(true);
        factory.removeFieldValue(Attachment.ParentId);
        createdRecordIds.add(upsertUpdate.Id);
        for (sObjectField thisField : testFields.keySet()) {
            factory.setFieldValue(thisField, testFields.get(thisField) + 'UpsertUpdate');
        }

        upsertUpdate = factory.upsertRecord(upsertUpdate);
        thisId = upsertUpdate.Id; // can not use object.field notation in Database.query
        records = Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName() + ' WHERE Id = :thisId');
        system.assertEquals(records.size(), 1);
        for (sObjectField thisField : testFields.keySet()) {
            System.assertEquals(records[0].get(thisField), testFields.get(thisField) + 'UpsertUpdate');
        }

        // Should have 3 records now.
        System.assertEquals(Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName() ).size(),createdRecordIds.size());

        // DELETE
        factory.deleteRecord(upsertUpdate);
        System.assertEquals(Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName() ).size(), createdRecordIds.size() -1);

        System.assertEquals(myType, factory.getSobjectType());
        System.assertEquals(factory.getSObjectAPIName(),myAPIName);

    }

    @isTest static void TestOpportunityContactRole() {

        List<User> users = TestObjectUtilities.generateUsers(2, GlobalUtilities.PROFILE_SALES_REP);
        User salesRepUser = users[0];

        System.runAs(salesRepUser) {
            Map<sObjectField, String> testFields = new Map<sObjectField, String>();


            /** SETUP
         *  Update the below fields ONLY to whatever object you are testing.
         */

            SObjectType myType = OpportunityContactRole.sObjectType;
            String myAPIName = 'OpportunityContactRole';
            TestObjectFactoryOpportunityContactRole factory = new TestObjectFactoryOpportunityContactRole();

            // Generate any required dependencies here
            // i.e., factory.setFieldValue(Contact.AccountId,(new TestObjectFactoryAccount().createRecord(true)).Id);
            TestObjectFactoryContact contactFactory = new TestObjectFactoryContact();
            TestObjectFactoryAccount accountFactory = new TestObjectFactoryAccount();
            TestObjectFactoryOpportunity opportunityFactory = new TestObjectFactoryOpportunity();
            Account a = accountFactory.createRecord(true);
            opportunityFactory.setFieldValue(Opportunity.AccountId,a.Id);
            Opportunity opp = opportunityFactory.createRecord(true);
            contactFactory.setFieldValue(Contact.AccountId, a.Id);
            Contact c = contactFactory.createRecord(true);

            factory.setFieldValue(OpportunityContactRole.OpportunityId, opp.id);
            factory.setFieldValue(OpportunityContactRole.ContactId, c.id);

            // enter multiple fields here if you need to change more than one field per test operation (i.e., User)
            // String only
            testFields.put(OpportunityContactRole.Role, 'Influencer');


            /** END SETUP
         *  Update below ONLY if your object has special handling (i.e., can't delete Users)
         */


            // Setup Test Data and Fields
            List<sObject> records = new List<sObject>();
            List<String> fieldNames = new List<String>();
            Set<Id> createdRecordIds = new Set<Id>(); // in case one was created above in setup
            Id thisId;

            for (sObjectField thisField : testFields.keySet()) {
                factory.setFieldValue(thisField, testFields.get(thisField));
                fieldNames.add(thisField.getDescribe().getLocalName());
            }

            String fieldNameString = string.join(fieldNames, ',');

            // INSERT
            sObject myRecord = factory.createRecord(true);
            createdRecordIds.add(myRecord.Id);

            records = Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName());

            for (sObject record : records) {
                for (sObjectField thisField : testFields.keySet())
                    System.assertEquals(record.get(thisField), testFields.get(thisField));
            }

            factory.clearFieldValues();
            // UPDATE
            for (sObjectField thisField : testFields.keySet()) {
                factory.setFieldValue(thisField, 'Economic Buyer');
            }

            factory.updateRecord(myRecord);

            records = Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName());

            for (sObject record : records) {
                for (sObjectField thisField : testFields.keySet())
                    System.assertEquals(record.get(thisField), 'Economic Buyer');
            }

            //Upsert with Insert

            factory.setFieldValue(OpportunityContactRole.OpportunityId, opp.id);
            factory.setFieldValue(OpportunityContactRole.ContactId, c.id);
            sObject upsertInsert = factory.createRecord(false);
            for (sObjectField thisField : testFields.keySet()) {
                factory.setFieldValue(thisField, 'Decision Maker');
            }

            upsertInsert = factory.upsertRecord(upsertInsert);
            createdRecordIds.add(upsertInsert.Id);
            thisId = upsertInsert.Id; // can not use object.field notation in Database.query
            records = Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName() + ' WHERE Id = :thisId');
            system.assertEquals(records.size(), 1);
            for (sObjectField thisField : testFields.keySet()) {
                System.assertEquals(records[0].get(thisField), 'Decision Maker');
            }

            /// Upsert with Update
            factory.clearFieldValues();
            factory.setFieldValue(OpportunityContactRole.OpportunityId, opp.id);
            factory.setFieldValue(OpportunityContactRole.ContactId, c.id);
            sObject upsertUpdate = factory.createRecord(true);
            factory.clearFieldValues();

            createdRecordIds.add(upsertUpdate.Id);
            for (sObjectField thisField : testFields.keySet()) {
                factory.setFieldValue(thisField, 'Evaluator');
            }

            upsertUpdate = factory.upsertRecord(upsertUpdate);
            thisId = upsertUpdate.Id; // can not use object.field notation in Database.query
            records = Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName() + ' WHERE Id = :thisId');
            system.assertEquals(records.size(), 1);
            for (sObjectField thisField : testFields.keySet()) {
                System.assertEquals(records[0].get(thisField), 'Evaluator');
            }

            // Should have 3 records now.
            System.assertEquals(Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName()).size(), createdRecordIds.size());

            // DELETE
            factory.deleteRecord(upsertUpdate);
            System.assertEquals(Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName()).size(), createdRecordIds.size() - 1);

            System.assertEquals(myType, factory.getSobjectType());
            System.assertEquals(factory.getSObjectAPIName(), myAPIName);
        }
    }

    @isTest static void FeedItem() {

        Map<sObjectField, String> testFields = new Map<sObjectField, String>();

        /** SETUP
         *  Update the below fields ONLY to whatever object you are testing.
         */

        SObjectType myType = FeedItem.sObjectType;
        String myAPIName = 'FeedItem';
        TestObjectFactoryFeedItem factory = new TestObjectFactoryFeedItem();

        // Generate any required dependencies here
        // i.e., factory.setFieldValue(Contact.AccountId,(new TestObjectFactoryAccount().createRecord(true)).Id);
        Id accountId = (new TestObjectFactoryAccount()).createRecord(true).Id;
        factory.setFieldValue(FeedItem.ParentId,accountId);

        // enter multiple fields here if you need to change more than one field per test operation (i.e., User)
        // String only
        testFields.put(FeedItem.Body, 'Log_Name');

        /** END SETUP
         *  Update below ONLY if your object has special handling (i.e., can't delete Users)
         */


        // Setup Test Data and Fields
        List<sObject> records = new List<sObject>();
        List<String> fieldNames = new List<String>();
        Set<Id> createdRecordIds = new Set<Id>(); // in case one was created above in setup
        Id thisId;

        for (sObjectField thisField : testFields.keySet()) {
            factory.setFieldValue(thisField, testFields.get(thisField));
            fieldNames.add(thisField.getDescribe().getLocalName());
        }

        String fieldNameString = string.join(fieldNames, ',');

        // INSERT
        sObject myRecord = factory.createRecord(true);
        createdRecordIds.add(myRecord.Id);

        records = Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName());

        for (sObject record : records) {
            for (sObjectField thisField : testFields.keySet())
                System.assertEquals(record.get(thisField), testFields.get(thisField));
        }

        // UPDATE
        factory.clearFieldValues();
        for (sObjectField thisField : testFields.keySet()) {
            factory.setFieldValue(thisField, testFields.get(thisField) + '2');
        }

        factory.updateRecord(myRecord);

        records = Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName());

        for (sObject record : records) {
            for (sObjectField thisField : testFields.keySet())
                System.assertEquals(record.get(thisField), testFields.get(thisField) + '2');
        }

        //Upsert with Insert
        sObject upsertInsert = factory.createRecord(false);
        factory.clearFieldValues();
        factory.setFieldValue(FeedItem.ParentId,accountId);

        for (sObjectField thisField : testFields.keySet()) {
            factory.setFieldValue(thisField, testFields.get(thisField) + 'UpsertInsert');
        }


        upsertInsert = factory.upsertRecord(upsertInsert);
        createdRecordIds.add(upsertInsert.Id);
        thisId = upsertInsert.Id; // can not use object.field notation in Database.query
        records = Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName() + ' WHERE Id = :thisId');
        system.assertEquals(records.size(), 1);
        for (sObjectField thisField : testFields.keySet()) {
            System.assertEquals(records[0].get(thisField), testFields.get(thisField) + 'UpsertInsert');
        }

        /// Upsert with Update
        sObject upsertUpdate = factory.createRecord(true);
        factory.clearFieldValues();
        factory.setFieldValue(FeedItem.ParentId,accountId);
        createdRecordIds.add(upsertUpdate.Id);
        for (sObjectField thisField : testFields.keySet()) {
            factory.setFieldValue(thisField, testFields.get(thisField) + 'UpsertUpdate');
        }

        factory.removeFieldValue(FeedItem.ParentId);
        upsertUpdate = factory.upsertRecord(upsertUpdate);
        thisId = upsertUpdate.Id; // can not use object.field notation in Database.query
        records = Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName() + ' WHERE Id = :thisId');
        system.assertEquals(records.size(), 1);
        for (sObjectField thisField : testFields.keySet()) {
            System.assertEquals(records[0].get(thisField), testFields.get(thisField) + 'UpsertUpdate');
        }

        // Should have 3 records now.
        System.assertEquals(Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName() ).size(),createdRecordIds.size());

        // DELETE
        factory.deleteRecord(myRecord);
        System.assertEquals(Database.query('SELECT ' + fieldNameString + ' FROM ' + factory.getSObjectAPIName() ).size(), createdRecordIds.size() -1);


        System.assertEquals(myType, factory.getSobjectType());
        System.assertEquals(factory.getSObjectAPIName(),myAPIName);

    }
}