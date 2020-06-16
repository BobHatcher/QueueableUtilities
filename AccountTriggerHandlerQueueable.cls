

public with sharing class AccountTriggerHandlerQueueable implements Queueable{

    public final String INSTRUCTION_REPARENT = 'reparentlogic';
    public final String INSTRUCTION_NAMECHANGE = 'namechangelogic';
    Set<String> validInstructions = new Set<String>{ INSTRUCTION_REPARENT, INSTRUCTION_NAMECHANGE};

    private Map<String,List<Account>> g_toExecute = new Map<String,List<Account>>();
    public Boolean HasInstructions { get { return g_toExecute.size() > 0; }}

    /***
     *  Queueable takes a Map<String,List<Account>>. The String is the INSTRUCTION.
     *  The List<Account> is the list of Accounts to process when executing the instruction.
     *
     *  Or construct one using no parameters and addInstruction() to add work to the queueable prior to execution.
    */

    public AccountTriggerHandlerQueueable (Map<String,List<Account>> toExecute)
    {
        if (toExecute != null) {
            addInstruction(toExecute);
        }
    }

    public AccountTriggerHandlerQueueable (String instruction, List<Account> accounts)
    {
        if (accounts != null && accounts.size() > 0) {
            addInstruction(instruction, accounts);
        }
    }

    public AccountTriggerHandlerQueueable() {}

    public void addInstruction (Map<String,List<Account>> toExecute){
        if (toExecute != null && toExecute.size() > 0) {
            for (String instruction : toExecute.keySet()) {
                addInstruction(instruction, toExecute.get(instruction));
            }
        }
    }

    public void addInstruction(String instruction, List<Account> accounts){
        if (accounts != null && accounts.size() > 0) {
            validateDuplicateInstruction(instruction);
            g_toExecute.put(instruction, accounts);
        }
    }

    public void execute(QueueableContext context) {
        execute();
    }

    public void execute()
    {
        System.debug('** REH AccountTriggerHandlerQueueable Execute; Instructions = ' + g_toExecute.keySet());
        if (!HasInstructions)
            return;

        for (String instruction : g_toExecute.keySet())
        {
            if (instruction == INSTRUCTION_REPARENT) {
                try {
                    reparentLogic(g_toExecute.get(instruction));
                }
                catch (Exception e) {
                    MyException.insertException('AccountTriggerHandlerQueueable #Execute  ' + instruction , e, instruction + ' reparentLogic()', myException.allIdsFromList(g_toExecute.get(instruction)));
                }
            } else if (instruction == INSTRUCTION_NAMECHANGE) {
                try {
                    nameChange(g_toExecute.get(instruction));
                }
                catch (Exception e) {
                    MyException.insertException('AccountTriggerHandlerQueueable #Execute  ' + instruction , e, instruction + ' nameChange()', myException.allIdsFromList(g_toExecute.get(instruction)));
                }
            }
        }
    }

    private void reparentLogic(List<Account> accounts){
        // your logic here
    }

    private void nameChange(List<Account> accounts){
        // your logic here
    }

    private void validateDuplicateInstruction(String instruction){
        if (!validInstructions.contains(instruction))
            throw new MyException('AccountTriggerHandlerQueueable Cannot Add Instruction: instruction ' + instruction + ' is not a valid instruction ');
        if (g_toExecute.containsKey(instruction))
            throw new MyException('AccountTriggerHandlerQueueable Cannot Add Instruction: instruction ' + instruction + ' already exists ');
    }

}