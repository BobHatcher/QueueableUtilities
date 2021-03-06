public class QueueableUtilities implements Queueable {

    /**
     * Bob Hatcher February 2021
     * @BobHatcher - stupidcrmtricks.com
     * Documentation: https://github.com/BobHatcher/QueueableUtilities/wiki
     *
     * Licensed GNU GENERAL PUBLIC LICENSE Version 2 (June 1991)
     * Use at your own risk - no warranty expressed or implied
     *
     */

    // Credit to StackExchange user sfdcfox:
    // Adapted from https://salesforce.stackexchange.com/questions/188774/chaining-queueables-clarification-practical-usage

    public static final Boolean IS_RUNNING_TEST = Test.IsRunningTest(); // Alias this heavy function so it's only called once.
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
            System.debug('** REH self.payload.add ');
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
                System.debug('PAYLOAD IS NULL');
            }

            try {
                self.payload.add(item);
            }
            catch (Exception e)
            {
                System.debug('QueueableUtilities: Tried to enqueue a job and encountered a failure. ' + (item == null ? ' Item was null.' : ''));
                MyException.insertException('QueueableUtilities.enqueueJob() #FailedToAddToPayload',e,'QueueableUtilities.enqueueJob()','');
            }
            return null;
        }
    }
    public void execute(QueueableContext context) {
        self = this;
        System.debug('** REH QueueableUtilities execute ');

        payload.remove(0).execute(context);
        if(!payload.isEmpty()) {
            try {
                System.enqueueJob(this);
            }
            catch(Exception e)
            {
                MyException.insertException('QueueableUtilities.enqueueJob() #CouldNotEnqueueJob',e,'QueueableUtilities.enqueueJob()','');
            }
        }
    }
}