
public abstract class MyQueueable implements Queueable{

    /**
     * Bob Hatcher February 2021
     * @BobHatcher - stupidcrmtricks.com
     *
     * Very simple abstract class.
     * A Map<Id,List<sObject>> is maintained. The String is an "instruction" and the list is the data to be operated on.
     *
     * ** IN YOUR EXTENSION CLASS
     *
     * In the class that extends this, you can maintain some public static final instruction variables:
     *
     * public static final String INSTRUCTION_PROPAGATE_ABM_FIELDS = 'propagate_abm_fields';
     *
     * Also set the ClassName:
     *
     * In your override execute method, iterate over Instructions and call whatever logic you want from there.
     * for (String instruction : Instructions.keySet())
        {
            if (instruction == INSTRUCTION_PROPAGATE_ABM_FIELDS) {
                try {
                    // this method local to the extended class
                    // Since the abstract class uses generic sObjects, cast the list to your specific type.
                    propagateABMFields((List<Account>) Instructions.get(instruction));
                }
                catch (Exception e) {
                    ImprivataException.insertException(ClassName + ' #Execute  ' + instruction , e, instruction + ' propagateABMFields()', GlobalUtilities.allIdsFromList(Instructions.get(instruction)));
                }
            else if (instruction ==
             ....
     *
     * Your extension class should maintain two constructors:
     *
     * public MyConstructor() {}
     * ..and..
     * public MyConstructor(String instruction, List<sObject> records){
     *    super(instruction,records);
     * }
     *
     *
     * ** USAGE IN TRIGGERS AND OTHER APEX CODE
     *
     * In your trigger, assemble a list of records you want processed by the queueable.
     * You can either instantiate the class then add the lists to process in distinct steps:
     * MyObjectQueueable moq = new MyObjectQueueable();
     * moq.addInstruction(moq.INSTRUCTION_DO_SOMETHING, listOfObjects);
     *
     * Or there are constructors available to pass in a Map<String,List<sObject>> directly. If you do that
     * you can still use addInstruction later.
     *
     * When you are ready to go, just call the fire() method:
     * moq.fire();
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
    public static final Boolean IS_TEST = Test.isRunningTest(); // this way we only pull this once

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
        return !IS_TEST || (IS_TEST && !System.isQueueable());
    }

}