
public abstract class MyQueueable implements Queueable{

    /**
     * Bob Hatcher February 2021
     * @BobHatcher - stupidcrmtricks.com
     * Documentation: https://github.com/BobHatcher/QueueableUtilities/wiki
     *
     * Licensed GNU GENERAL PUBLIC LICENSE Version 2 (June 1991)
     * Use at your own risk - no warranty expressed or implied
     *
     */

    protected Map<String,List<sObject>> Instructions  {get;set;}
    protected Map<String,Set<Id>> InstructionsIds  {get;set;} // used in special cases when an instruction needs to be sent with a list of IDs only.
    protected Set<String> ValidInstructions {get;set;}
    protected Boolean HasInstructions {get { return (Instructions?.size() > 0 || InstructionsIds?.size() > 0) ; }}
    protected String ClassName ;
    protected QueueableContext Context {get;set;} // some, like Attachment, store the Job ID
    public String ContextType { get{ return System.isQueueable() ? 'Queueable' : 'Synchronous'; }}
    public Boolean ForceSynchronous { get; set; }

    public void setClassName(String cn){
        ClassName = cn;
    }
    public abstract String getClassName();

    /**
     * Constructors
     */
    public MyQueueable() {
        instantiateInstructions();
    }

    public MyQueueable(String instruction, List<sObject> objects, String className){

        this(instruction,objects);
    }

    public MyQueueable(String instruction, List<sObject> objects){
        instantiateInstructions();
        addInstruction(instruction, objects);
    }

    public MyQueueable(Map<String, List<sObject>> objects){
        instantiateInstructions();
        addInstruction(objects);
    }

    public void addInstruction(String instruction, List<sObject> objects){
        instantiateInstructions();
        System.debug('Queueable '+ClassName+' received request to add single instruction: ' + instruction + ' for ' + objects?.size() + 'objects.');
        if (isInstructionValid(instruction) && objects != null && objects.size() > 0) {
            Instructions.put(instruction,objects);
            ValidInstructions.add(instruction);
        }
    }

    public void addInstruction (Map<String,List<sObject>> instructionsAndData){
        instantiateInstructions();
        System.debug('Queueable received request to add multiple instructions: ' + instructionsAndData?.keySet());
        if (instructionsAndData != null && instructionsAndData.size() > 0) {
            // need to validate that each list is not null and size > 0 so go through each.
            for (String instruction : instructionsAndData.keySet()) {
                addInstruction(instruction, instructionsAndData.get(instruction));
            }
        }
    }

    private void instantiateInstructions(){
        if (Instructions == null)
            Instructions = new Map<String,List<sObject>>();
        if (ValidInstructions== null)
            ValidInstructions = new Set<String>();
        if (InstructionsIds== null)
            InstructionsIds = new Map<String,Set<Id>>();
        if (ForceSynchronous == null)
            ForceSynchronous = false;
    }

    protected Boolean isInstructionValid(String instruction){
        if (Instructions.containsKey(instruction)) {
            throw new MyException(ClassName + ' Cannot Add Instruction: instruction ' + instruction + ' already exists.');
        } else {
            return true;
        }
    }

    /**
     * Execution Methods
     */

    public void execute(QueueableContext myContext) {
        Context = myContext;
        try {
            execute();
        } catch (Exception e){
            MyException.insertException('ImprivataQueueable.execute() #QueueableExecute', e, 'execute()', MyException.allIdsFromInstructionMap(Instructions));
        }

    }

    public abstract void execute();

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

    public static Boolean childProcessesAsQueueable(){
        // Run the process as queueable if not in test, or in test and not already in a queueable context
        return !QueueableUtilities.IS_RUNNING_TEST || (QueueableUtilities.IS_RUNNING_TEST && !System.isQueueable());
    }

}