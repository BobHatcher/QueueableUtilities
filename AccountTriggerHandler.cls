public with sharing class AccountTriggerHandler {
	public static Boolean forceSynchronous = false; // use this in testing if necessary

	public static void afterUpdate(Map<Id,Account> oldMap, Map<Id,Account> newMap)
	{
		// Sample: If the Account was reparented
		List<Account> reparentedAccounts = new List<Account>();
		for (Account a : newMap.values()) {
			if (a.ParentId != oldMap.get(a.Id).ParentId) {
				reparentedAccounts.add(a);
			}
		}

		List<Account> nameChangedAccounts = new List<Account>();
		for (Account a : newMap.values()) {
			if (a.Name != oldMap.get(a.Id).Name) {
				nameChangedAccounts.add(a);
			}
		}
		AccountTriggerHandlerQueueable atq = new AccountTriggerHandlerQueueable();
		atq.addInstruction(atq.INSTRUCTION_REPARENT, reparentedAccounts);
		atq.addInstruction(atq.INSTRUCTION_NAMECHANGE, nameChangedAccounts);
		atq.fire();
	}

}