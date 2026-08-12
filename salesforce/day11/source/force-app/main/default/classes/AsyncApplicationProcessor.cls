public class AsyncApplicationProcessor {

    @future
    public static void processApplication(String message) {

        System.debug(
            'Future Method Running: ' + message
        );

    }
}