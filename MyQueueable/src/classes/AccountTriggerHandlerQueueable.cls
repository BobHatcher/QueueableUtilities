public with sharing class AccountTriggerHandlerQueueable extends MyQueueable{

    /**
     * Bob Hatcher February 2021
     * @BobHatcher - stupidcrmtricks.com
     * Documentation: https://github.com/BobHatcher/QueueableUtilities/wiki
     *
     * Licensed GNU GENERAL PUBLIC LICENSE Version 2 (June 1991)
     * Use at your own risk - no warranty expressed or implied
     *
     */

    public final String INSTRUCTION_REPARENT = 'reparentlogic';
    public final String INSTRUCTION_NAMECHANGE = 'namechangelogic';
    public static final String ClassName = 'AccountTriggerHandlerQueueable';

    public AccountTriggerHandlerQueueable() {}

    public AccountTriggerHandlerQueueable(String instruction, List<sObject> accounts){
        super(instruction,accounts);
    }

    public AccountTriggerHandlerQueueable(Map<String,List<sObject>> accounts){
        super(accounts);
    }

    public override void execute() {
        System.debug('AccountTriggerHandlerQueueable - Execute - Instructions (' + Instructions.size() + ') ' + Instructions.keySet());
        ExecutedAs = ContextType;
        for (String instruction : Instructions.keySet()) {
            if (instruction == INSTRUCTION_REPARENT) {
                try {
                    reparentLogic((List<Account>) Instructions.get(instruction));
                } catch (Exception e) {
                    MyException.insertException(ClassName + ' #Execute  ' + instruction, e, instruction + ' insertTrace()', MyException.allIdsFromList(Instructions.get(instruction)));
                }
            } else if (instruction == INSTRUCTION_NAMECHANGE) {
                try {
                    namechangeLogic((List<Account>) Instructions.get(instruction));
                } catch (Exception e) {
                    MyException.insertException(ClassName + ' #Execute  ' + instruction, e, instruction + ' upsertTrace()', MyException.allIdsFromList(Instructions.get(instruction)));
                }
            }
        }
    }

    private static void reparentLogic(List<Account> accounts){
        // Your logic here
        System.debug('Reparent Logic');
    }

    private static void namechangeLogic(List<Account> accounts){
        // Your logic here
    }

    /**
     * The following methods are boilerplate, but must be in the child Class since the execute() is
     * relative to child-specific logic.
     */
    public override void execute(QueueableContext myContext) {
        Context = myContext;
        try {
            execute();
        } catch (Exception e){
            MyException.insertException('MyQueueable.execute() #QueueableExecute', e, 'execute()', MyException.allIdsFromInstructionMap(Instructions));
        }
    }

    public void fire(){
        if (HasInstructions) {
            if (childProcessesAsQueueable() && !ForceSynchronous) {
                System.debug('** ' + ClassName + '  Enqueueing with Instructions ' + Instructions.keySet());
                QueueableUtilities.enqueueJob(this);
            } else {
                System.debug('** ' + ClassName + ' Firing Synchronously with Instructions ' + Instructions.keySet());
                execute();
            }
        } else {
            System.debug('** ' + ClassName + ' Has no instructions so not firing. ');
        }
    }
}