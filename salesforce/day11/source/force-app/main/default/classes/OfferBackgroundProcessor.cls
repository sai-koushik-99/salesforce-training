public class OfferBackgroundProcessor implements Queueable {

    private String message;

    public OfferBackgroundProcessor(String message) {

        this.message = message;

    }

    public void execute(QueueableContext context) {

        System.debug(
            'Queueable Job Running: ' + message
        );

    }
}