public class QueueableUtilities implements Queueable {

    // Adapted from https://salesforce.stackexchange.com/questions/188774/chaining-queueables-clarification-practical-usage

    public static final Boolean IS_RUNNING_TEST = Test.IsRunningTest(); // Alias this heavy function so it's only called once.
    public static Boolean isBulkTest = false; // set this to true to force asynchronous processing
    // can't chain queueables in test.
    public static Boolean childProcessesAsQueueable(){  return !IS_RUNNING_TEST || (IS_RUNNING_TEST && !System.isQueueable())  || isBulkTest; } // cannot do this as a simple static variable; returns incorrect results

    Queueable[] payload;
    static QueueableUtilities self ;
    QueueableUtilities(Queueable item) {
        payload = new Queueable[] { item };
    }

    public static Id enqueueJob(Queueable item) {
        if(item == null)
        {
            System.debug('** REH *** WARNING QueueableUtilities.enqueueJob() Attempted to Invoke a Queueable with a Null Item');
            return null;
        }
        if(!System.isQueueable()) {
            return System.enqueueJob(new QueueableUtilities(item));
        } else {
            if (self == null)
            {
                self = new QueueableUtilities(item);
            }
            if (self.payload != null)
            {
                System.debug('payload = ' + self.payload.size());
            }
            else
            {
                System.debug(LoggingLevel.WARN,'PAYLOAD IS NULL');
            }

            try {
                self.payload.add(item);
            }
            catch (Exception e )
            {
                System.debug('QueueableUtilities: Tried to enqueue a job and encountered a failure. ' + (item == null ? ' Item was null.' : ''));
                throw new MyException('QueueableUtilities.enqueueJob() #FailedToAddToPayload ' + e.getMessage());
            }
            return null;
        }
    }
    public void execute(QueueableContext context) {
        self = this;

        payload.remove(0).execute(context);
        if(!payload.isEmpty()) {
            try {
                System.enqueueJob(this);
            }
            catch(Exception e)
            {
                throw new MyException('QueueableUtilities.enqueueJob() #CouldNotEnqueueJob ' + e.getMessage());
            }
        }
    }
}