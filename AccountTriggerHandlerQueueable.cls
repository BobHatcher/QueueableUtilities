

public with sharing class AccountTriggerHandlerQueueable extends MyQueueable{

    public final String INSTRUCTION_REPARENT = 'reparentlogic';
    public final String INSTRUCTION_NAMECHANGE = 'namechangelogic';

    public override String getClassName() { return 'AccountTriggerHandlerQueueable'; }
    public AccountTriggerHandlerQueueable() {}

    public AccountTriggerHandlerQueueable(String instruction, List<sObject> accounts){
        super(instruction,accounts);
    }

    public AccountTriggerHandlerQueueable(Map<String,List<sObject>> accounts){
        super(accounts);
    }

    public override void execute() {
        System.debug('AccountTriggerHandlerQueueable - Execute - Instructions (' + Instructions.size() + ') ' + Instructions.keySet());
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
    }

    private static void namechangeLogic(List<Account> accounts){
        // Your logic here
    }

}
