public with sharing class AccountTriggerHandler {

	/**
     * Bob Hatcher February 2021
     * @BobHatcher - stupidcrmtricks.com
     * Documentation: https://github.com/BobHatcher/QueueableUtilities/wiki
     *
     * Licensed GNU GENERAL PUBLIC LICENSE Version 2 (June 1991)
     * Use at your own risk - no warranty expressed or implied
     *
     */

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