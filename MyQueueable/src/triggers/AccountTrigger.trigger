trigger AccountTrigger on Account (after update) {

	/**
     * Bob Hatcher February 2021
     * @BobHatcher - stupidcrmtricks.com
     * Documentation: https://github.com/BobHatcher/QueueableUtilities/wiki
     *
     * Licensed GNU GENERAL PUBLIC LICENSE Version 2 (June 1991)
     * Use at your own risk - no warranty expressed or implied
     *
     */

	if (Trigger.isAfter && Trigger.IsUpdate)
	{
		AccountTriggerHandler.afterUpdate(Trigger.oldMap, Trigger.newMap);
	}

}