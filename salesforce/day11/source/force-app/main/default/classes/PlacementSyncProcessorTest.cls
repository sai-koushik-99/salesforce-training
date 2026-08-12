/**
 * PlacementSyncProcessorTest
 *
 * Test class for PlacementSyncProcessor, PlacementService, and the
 * Trigger → Service → Queueable → Callout integration.
 *
 * Key concepts demonstrated:
 *   - HttpCalloutMock (never make real callouts from tests)
 *   - Test.setMock() to register the mock before callouts occur
 *   - Test.startTest() / Test.stopTest() to force async execution
 *   - Testing each HTTP status code scenario independently
 *   - Verifying database state after Queueable runs
 *   - Bulkification testing
 *   - Idempotency testing
 *
 * Day 11 — Placement Management System Integration
 */
@isTest
private class PlacementSyncProcessorTest {

    // ====================================================================
    // TEST DATA SETUP
    // ====================================================================

    /**
     * createTestData
     *
     * Creates one Student, one Job, and one Application in the Pending status.
     * Returned as a map so individual tests can use what they need.
     * We use a helper to avoid duplicating setup code in every test.
     *
     * Note: Application is created with Status = 'Applied' so tests can
     * control the status transition themselves.
     */
    private static Application__c createTestData() {

        // Create a Student
        Student__c student = new Student__c(
            Name   = 'Sai Koushik',
            Email__c  = 'saikoushik@example.com',
            Branch__c = 'CSE',
            CGPA__c   = 8.5
        );
        insert student;

        // Create a Job
        Job__c job = new Job__c(
            Name          = 'Salesforce Developer',
            Company__c    = 'TechCorp Solutions',
            Minimum_CGPA__c = 7.0
        );
        insert job;

        // Create an Application — status starts as Applied
        Application__c app = new Application__c(
            Student__c        = student.Id,
            Job__c            = job.Id,
            Status__c         = 'Applied',
            Application_Date__c = Date.today()
        );
        insert app;

        return app;
    }


    // ====================================================================
    // TEST 1: 201 Created — Successful sync
    // ====================================================================

    /**
     * What this tests:
     * When the external API returns 201, the Application should be updated:
     *   Integration_Status__c = 'Sent'
     *   External_Candidate_Id__c = 'EXT1001'
     *   Integration_Error__c = null
     *   Last_Integration_Attempt__c = populated
     */
    @isTest
    static void testSuccessful201Response() {

        Application__c app = createTestData();

        // Register the mock: 201 response with an externalCandidateId
        Test.setMock(HttpCalloutMock.class, new MockRecruitmentAPI(
            201,
            '{"success":true,"externalCandidateId":"EXT1001","message":"Candidate created"}'
        ));

        Test.startTest();
            // Directly enqueue the processor — tests the Queueable in isolation
            System.enqueueJob(new PlacementSyncProcessor(app.Id));
        Test.stopTest();
        // Test.stopTest() forces all async (Queueable) jobs to complete
        // before the assertions below run

        // Verify the Application was updated correctly
        Application__c updated = [
            SELECT Integration_Status__c,
                   External_Candidate_Id__c,
                   Integration_Error__c,
                   Last_Integration_Attempt__c
            FROM Application__c
            WHERE Id = :app.Id
        ];

        System.assertEquals('Sent', updated.Integration_Status__c,
            'Integration Status should be Sent after 201 response');
        System.assertEquals('EXT1001', updated.External_Candidate_Id__c,
            'External Candidate ID should be stored from response');
        System.assertNotEquals(null, updated.Last_Integration_Attempt__c,
            'Last Integration Attempt should be set');
        System.assertEquals(null, updated.Integration_Error__c,
            'Error field should be null on success');
    }


    // ====================================================================
    // TEST 2: 200 OK — Also treated as success
    // ====================================================================

    @isTest
    static void testSuccessful200Response() {

        Application__c app = createTestData();

        Test.setMock(HttpCalloutMock.class, new MockRecruitmentAPI(
            200,
            '{"success":true,"externalCandidateId":"EXT2002"}'
        ));

        Test.startTest();
            System.enqueueJob(new PlacementSyncProcessor(app.Id));
        Test.stopTest();

        Application__c updated = [
            SELECT Integration_Status__c, External_Candidate_Id__c
            FROM Application__c WHERE Id = :app.Id
        ];

        System.assertEquals('Sent', updated.Integration_Status__c,
            '200 response should also result in Sent status');
        System.assertEquals('EXT2002', updated.External_Candidate_Id__c,
            'External ID should be stored from 200 response');
    }


    // ====================================================================
    // TEST 3: 400 Bad Request — Failed, do not retry
    // ====================================================================

    @isTest
    static void test400BadRequest() {

        Application__c app = createTestData();

        Test.setMock(HttpCalloutMock.class, new MockRecruitmentAPI(
            400,
            '{"success":false,"error":"Invalid email format","field":"email"}'
        ));

        Test.startTest();
            System.enqueueJob(new PlacementSyncProcessor(app.Id));
        Test.stopTest();

        Application__c updated = [
            SELECT Integration_Status__c, Integration_Error__c
            FROM Application__c WHERE Id = :app.Id
        ];

        System.assertEquals('Failed', updated.Integration_Status__c,
            '400 response should result in Failed status');
        System.assert(updated.Integration_Error__c.contains('400'),
            'Error message should contain the status code');
    }


    // ====================================================================
    // TEST 4: 401 Unauthorized — Auth failure
    // ====================================================================

    @isTest
    static void test401Unauthorized() {

        Application__c app = createTestData();

        Test.setMock(HttpCalloutMock.class, new MockRecruitmentAPI(
            401,
            '{"success":false,"error":"Unauthorized"}'
        ));

        Test.startTest();
            System.enqueueJob(new PlacementSyncProcessor(app.Id));
        Test.stopTest();

        Application__c updated = [
            SELECT Integration_Status__c, Integration_Error__c
            FROM Application__c WHERE Id = :app.Id
        ];

        System.assertEquals('Failed', updated.Integration_Status__c,
            '401 response should result in Failed status');
        System.assert(updated.Integration_Error__c.contains('401'),
            'Error message should mention 401 Unauthorized');
    }


    // ====================================================================
    // TEST 5: 403 Forbidden — Permissions failure
    // ====================================================================

    @isTest
    static void test403Forbidden() {

        Application__c app = createTestData();

        Test.setMock(HttpCalloutMock.class, new MockRecruitmentAPI(
            403,
            '{"success":false,"error":"Forbidden"}'
        ));

        Test.startTest();
            System.enqueueJob(new PlacementSyncProcessor(app.Id));
        Test.stopTest();

        Application__c updated = [
            SELECT Integration_Status__c, Integration_Error__c
            FROM Application__c WHERE Id = :app.Id
        ];

        System.assertEquals('Failed', updated.Integration_Status__c,
            '403 response should result in Failed status');
        System.assert(updated.Integration_Error__c.contains('403'),
            'Error message should mention 403 Forbidden');
    }


    // ====================================================================
    // TEST 6: 500 Server Error — Retry Required
    // ====================================================================

    /**
     * What this tests:
     * A 500 means the external system had an internal error — not our fault.
     * We should mark as Retry Required so the sync can be attempted again.
     * The Application Status should remain 'Selected' — these are independent.
     */
    @isTest
    static void test500ServerError() {

        Application__c app = createTestData();

        Test.setMock(HttpCalloutMock.class, new MockRecruitmentAPI(
            500,
            '{"success":false,"error":"Internal server error"}'
        ));

        Test.startTest();
            System.enqueueJob(new PlacementSyncProcessor(app.Id));
        Test.stopTest();

        Application__c updated = [
            SELECT Integration_Status__c, Integration_Error__c, Status__c
            FROM Application__c WHERE Id = :app.Id
        ];

        // Integration status = Retry Required
        System.assertEquals('Retry Required', updated.Integration_Status__c,
            '500 response should result in Retry Required status');

        // Business status is unchanged — Application is still Applied
        // (we didn't change it in this test, it was never set to Selected)
        System.assert(updated.Integration_Error__c.contains('500'),
            'Error message should mention 500 Server Error');
    }


    // ====================================================================
    // TEST 7: Unexpected status code (e.g. 502)
    // ====================================================================

    @isTest
    static void testUnexpectedStatusCode() {

        Application__c app = createTestData();

        Test.setMock(HttpCalloutMock.class, new MockRecruitmentAPI(
            502,
            'Bad Gateway'
        ));

        Test.startTest();
            System.enqueueJob(new PlacementSyncProcessor(app.Id));
        Test.stopTest();

        Application__c updated = [
            SELECT Integration_Status__c, Integration_Error__c
            FROM Application__c WHERE Id = :app.Id
        ];

        System.assertEquals('Failed', updated.Integration_Status__c,
            'Unexpected status code should result in Failed');
        System.assert(updated.Integration_Error__c.contains('502'),
            'Error should contain the unexpected status code');
    }


    // ====================================================================
    // TEST 8: CalloutException (network timeout / connection failure)
    // ====================================================================

    /**
     * We cannot directly throw a CalloutException from a mock.
     * Instead, we use a dedicated mock that throws the exception.
     */
    @isTest
    static void testCalloutException() {

        Application__c app = createTestData();

        // Use a special mock that throws a CalloutException
        Test.setMock(HttpCalloutMock.class, new CalloutExceptionMock());

        Test.startTest();
            System.enqueueJob(new PlacementSyncProcessor(app.Id));
        Test.stopTest();

        Application__c updated = [
            SELECT Integration_Status__c, Integration_Error__c
            FROM Application__c WHERE Id = :app.Id
        ];

        System.assertEquals('Retry Required', updated.Integration_Status__c,
            'Callout exception should result in Retry Required');
        System.assert(updated.Integration_Error__c.contains('Callout exception'),
            'Error should describe the callout exception');
    }


    // ====================================================================
    // TEST 9: Idempotency — already Sent, should not re-enqueue
    // ====================================================================

    /**
     * What this tests:
     * If an Application already has Integration_Status__c = 'Sent',
     * the Queueable should detect this and exit without making a callout.
     *
     * We verify by using a mock that would fail if called — the fact
     * that Integration_Status__c remains 'Sent' proves the callout
     * was skipped (a new callout would have overwritten the status).
     */
    @isTest
    static void testIdempotencySkipsAlreadySent() {

        Application__c app = createTestData();

        // Manually set the application as already synced
        app.Integration_Status__c    = 'Sent';
        app.External_Candidate_Id__c = 'EXT_EXISTING';
        update app;

        // This mock returns 500 — if called, it would change status to Retry Required
        // The fact that status stays 'Sent' proves the callout was NOT made
        Test.setMock(HttpCalloutMock.class, new MockRecruitmentAPI(
            500,
            '{"error":"should not be called"}'
        ));

        Test.startTest();
            System.enqueueJob(new PlacementSyncProcessor(app.Id));
        Test.stopTest();

        Application__c updated = [
            SELECT Integration_Status__c, External_Candidate_Id__c
            FROM Application__c WHERE Id = :app.Id
        ];

        // Status should still be Sent — the Queueable skipped the callout
        System.assertEquals('Sent', updated.Integration_Status__c,
            'Already Sent application should not be re-synced');
        System.assertEquals('EXT_EXISTING', updated.External_Candidate_Id__c,
            'External ID should not be overwritten');
    }


    // ====================================================================
    // TEST 10: Trigger → Service → Queueable integration
    // ====================================================================

    /**
     * What this tests:
     * The full end-to-end trigger path.
     * Update an Application Status to 'Selected' and verify the
     * Queueable runs and updates Integration_Status_c to 'Sent'.
     */
    @isTest
    static void testTriggerEnqueuesAndRunsSync() {

        Application__c app = createTestData();

        Test.setMock(HttpCalloutMock.class, new MockRecruitmentAPI(
            201,
            '{"success":true,"externalCandidateId":"EXT_TRIG_001"}'
        ));

        Test.startTest();
            // Trigger the status change — this fires the Trigger → PlacementService
            app.Status__c = 'Selected';
            update app;
        Test.stopTest();
        // Test.stopTest() forces the Queueable to execute synchronously

        Application__c updated = [
            SELECT Integration_Status__c, External_Candidate_Id__c, Status__c
            FROM Application__c WHERE Id = :app.Id
        ];

        // Business status — Selected
        System.assertEquals('Selected', updated.Status__c,
            'Application Status should be Selected');

        // Integration status — Sent
        System.assertEquals('Sent', updated.Integration_Status__c,
            'Integration Status should be Sent after trigger flow');

        // External ID stored
        System.assertEquals('EXT_TRIG_001', updated.External_Candidate_Id__c,
            'External Candidate ID should be stored from API response');
    }


    // ====================================================================
    // TEST 11: Trigger → Status = 'Selected' then 500 response
    // End-to-end failure scenario
    // ====================================================================

    @isTest
    static void testTriggerWithServerError() {

        Application__c app = createTestData();

        Test.setMock(HttpCalloutMock.class, new MockRecruitmentAPI(
            500,
            '{"success":false,"error":"Internal server error"}'
        ));

        Test.startTest();
            app.Status__c = 'Selected';
            update app;
        Test.stopTest();

        Application__c updated = [
            SELECT Integration_Status__c, Status__c, Integration_Error__c
            FROM Application__c WHERE Id = :app.Id
        ];

        // Business status remains Selected — integration failure doesn't revert it
        System.assertEquals('Selected', updated.Status__c,
            'Application Status should remain Selected even when integration fails');

        // Integration marked for retry
        System.assertEquals('Retry Required', updated.Integration_Status__c,
            'Integration Status should be Retry Required after 500 response');
    }


    // ====================================================================
    // TEST 12: Bulk — Multiple applications selected at once
    // ====================================================================

    @isTest
    static void testBulkApplicationsSelected() {

        // Create 5 students, 5 jobs, 5 applications
        List<Student__c> students = new List<Student__c>();
        for (Integer i = 0; i < 5; i++) {
            students.add(new Student__c(
                Name      = 'Student ' + i,
                Email__c  = 'student' + i + '@example.com',
                Branch__c = 'CSE',
                CGPA__c   = 8.0
            ));
        }
        insert students;

        List<Job__c> jobs = new List<Job__c>();
        for (Integer i = 0; i < 5; i++) {
            jobs.add(new Job__c(
                Name          = 'Job ' + i,
                Company__c    = 'Company ' + i,
                Minimum_CGPA__c = 7.0
            ));
        }
        insert jobs;

        List<Application__c> apps = new List<Application__c>();
        for (Integer i = 0; i < 5; i++) {
            apps.add(new Application__c(
                Student__c = students[i].Id,
                Job__c     = jobs[i].Id,
                Status__c  = 'Applied'
            ));
        }
        insert apps;

        // Mock all 5 callouts to return 201
        Test.setMock(HttpCalloutMock.class, new MockRecruitmentAPI(
            201,
            '{"success":true,"externalCandidateId":"EXT_BULK"}'
        ));

        Test.startTest();
            // Bulk update all 5 to Selected
            for (Application__c a : apps) {
                a.Status__c = 'Selected';
            }
            update apps;
        Test.stopTest();

        // Verify all 5 were synced
        List<Application__c> updated = [
            SELECT Integration_Status__c
            FROM Application__c
            WHERE Id IN :apps
        ];

        for (Application__c a : updated) {
            System.assertEquals('Sent', a.Integration_Status__c,
                'All bulk applications should be Sent');
        }
    }


    // ====================================================================
    // TEST 13: PlacementService — does not enqueue if already Sent
    // ====================================================================

    @isTest
    static void testServiceSkipsAlreadySentOnUpdate() {

        Application__c app = createTestData();
        app.Integration_Status__c = 'Sent';
        update app;

        Test.setMock(HttpCalloutMock.class, new MockRecruitmentAPI(
            500, '{"error":"should not be called"}'
        ));

        Test.startTest();
            // Even though Status becomes Selected, Integration_Status is Sent
            // PlacementService should NOT enqueue a new job
            app.Status__c = 'Selected';
            update app;
        Test.stopTest();

        Application__c updated = [
            SELECT Integration_Status__c
            FROM Application__c WHERE Id = :app.Id
        ];

        System.assertEquals('Sent', updated.Integration_Status__c,
            'Integration status should remain Sent — no re-sync');
    }


    // ====================================================================
    // Helper inner mock: throws CalloutException
    // ====================================================================

    /**
     * CalloutExceptionMock
     * Simulates a network timeout or unreachable host.
     * Used only in testCalloutException().
     */
    private class CalloutExceptionMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            CalloutException e = new CalloutException();
            e.setMessage('Read timed out');
            throw e;
        }
    }
}
