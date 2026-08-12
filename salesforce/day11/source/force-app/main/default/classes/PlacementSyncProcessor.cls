/**
 * PlacementSyncProcessor
 *
 * Queueable Apex class that syncs a selected candidate to the
 * external RecruitEdge recruitment platform via HTTP POST.
 *
 * Architecture:
 *   StudentJobApplicationTrigger
 *       → PlacementService.syncSelectedCandidates()
 *           → System.enqueueJob(new PlacementSyncProcessor(appId))
 *               → HTTP POST callout:Recruitment_API/candidates
 *               → Update Application__c integration fields
 *
 * Implements Database.AllowsCallouts because Queueable classes that
 * make HTTP callouts MUST declare this interface. Without it, Salesforce
 * throws a CalloutException at runtime.
 *
 * Day 11 — Placement Management System Integration
 */
public class PlacementSyncProcessor implements Queueable, Database.AllowsCallouts {

    // The Id of the Application__c record to sync
    private Id applicationId;

    /**
     * Constructor — receives the Application Id from PlacementService.
     * We pass only the Id (a primitive) rather than the full SObject.
     * This is intentional: Queueable jobs are serialized to the queue,
     * so keeping the payload minimal is a best practice.
     */
    public PlacementSyncProcessor(Id applicationId) {
        this.applicationId = applicationId;
    }

    /**
     * execute() — called by Salesforce when the job runs from the queue.
     *
     * Flow:
     * 1. Query the Application + Student + Job data
     * 2. Check idempotency — skip if already Sent
     * 3. Build the candidate JSON request
     * 4. Make the HTTP callout
     * 5. Process the response
     * 6. Update Application__c integration fields
     */
    public void execute(QueueableContext context) {

        // ----------------------------------------------------------------
        // Step 1: Query all data needed for the API request
        // We query Application, and traverse to Student and Job in one SOQL
        // ----------------------------------------------------------------
        Application__c app;
        try {
            app = [
                SELECT Id,
                       Name,
                       Status__c,
                       Application_Date__c,
                       Integration_Status__c,
                       External_Candidate_Id__c,
                       Student__c,
                       Student__r.Name,
                       Student__r.Email__c,
                       Student__r.Branch__c,
                       Student__r.CGPA__c,
                       Job__c,
                       Job__r.Name,
                       Job__r.Company__c
                FROM Application__c
                WHERE Id = :applicationId
                LIMIT 1
            ];
        } catch (QueryException qe) {
            System.debug('PlacementSyncProcessor: Application not found for Id: ' + applicationId);
            return;
        }

        // ----------------------------------------------------------------
        // Step 2: Idempotency check
        // If this application was already successfully synced, do not
        // send again. This prevents duplicate candidate creation on the
        // external system if the job is enqueued more than once.
        // ----------------------------------------------------------------
        if (app.Integration_Status__c == 'Sent') {
            System.debug('PlacementSyncProcessor: Application ' + app.Name
                + ' already synced. Skipping.');
            return;
        }

        // ----------------------------------------------------------------
        // Step 3: Build the candidate request wrapper
        // This is a clean DTO — only the fields the API contract requires
        // ----------------------------------------------------------------
        CandidateRequest candidateReq = new CandidateRequest();
        candidateReq.studentId   = app.Student__r.Name;
        candidateReq.name        = app.Student__r.Name;
        candidateReq.email       = app.Student__r.Email__c;
        candidateReq.branch      = app.Student__r.Branch__c;
        candidateReq.cgpa        = app.Student__r.CGPA__c;
        candidateReq.jobId       = app.Job__r.Name;
        candidateReq.company     = app.Job__r.Company__c;
        candidateReq.role        = app.Job__r.Name;
        candidateReq.selectionDate = app.Application_Date__c != null
            ? String.valueOf(app.Application_Date__c)
            : String.valueOf(Date.today());

        // ----------------------------------------------------------------
        // Step 4: Serialize the wrapper to JSON
        // JSON.serialize() converts the Apex object into a JSON string.
        // Only the fields on CandidateRequest are included — not Salesforce
        // internal fields.
        // ----------------------------------------------------------------
        String requestBody = JSON.serialize(candidateReq);
        System.debug('PlacementSyncProcessor: Request body: ' + requestBody);

        // ----------------------------------------------------------------
        // Step 5: Build the HttpRequest
        // callout:Recruitment_API tells Salesforce to use the Named
        // Credential named Recruitment_API for the base URL and auth.
        // ----------------------------------------------------------------
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Recruitment_API/candidates');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setBody(requestBody);
        req.setTimeout(10000); // 10 seconds — don't wait forever

        // ----------------------------------------------------------------
        // Step 6: Perform the callout
        // We wrap in try-catch for CalloutException (timeouts, network errors)
        // ----------------------------------------------------------------
        HttpResponse res;
        try {
            Http http = new Http();
            res = http.send(req);
        } catch (CalloutException ce) {
            // Network timeout or connection failure
            // This is a transient error — Retry Required
            updateIntegrationStatus(
                app.Id,
                'Retry Required',
                null,
                'Callout exception: ' + ce.getMessage()
            );
            return;
        }

        // ----------------------------------------------------------------
        // Step 7: Process the response based on HTTP status code
        // ----------------------------------------------------------------
        Integer statusCode = res.getStatusCode();
        String responseBody = res.getBody();

        System.debug('PlacementSyncProcessor: Response code: ' + statusCode);
        System.debug('PlacementSyncProcessor: Response body: ' + responseBody);

        if (statusCode == 200 || statusCode == 201) {
            // SUCCESS — candidate created in external system
            handleSuccess(app.Id, responseBody);

        } else if (statusCode == 400) {
            // BAD REQUEST — something wrong with our data
            // Do not retry — the data needs fixing
            updateIntegrationStatus(
                app.Id,
                'Failed',
                null,
                '400 Bad Request: ' + responseBody
            );

        } else if (statusCode == 401) {
            // UNAUTHORIZED — Named Credential / auth issue
            // Do not retry — fix the credential configuration
            updateIntegrationStatus(
                app.Id,
                'Failed',
                null,
                '401 Unauthorized: Check Named Credential configuration'
            );

        } else if (statusCode == 403) {
            // FORBIDDEN — authenticated but not permitted
            // Do not retry — fix API permissions
            updateIntegrationStatus(
                app.Id,
                'Failed',
                null,
                '403 Forbidden: Insufficient permissions on external system'
            );

        } else if (statusCode == 500) {
            // SERVER ERROR — external system failure, not our fault
            // Retry is appropriate — the external system may recover
            updateIntegrationStatus(
                app.Id,
                'Retry Required',
                null,
                '500 Server Error: External system failure'
            );

        } else {
            // UNEXPECTED status code — unknown situation
            // Mark as Failed until investigated
            updateIntegrationStatus(
                app.Id,
                'Failed',
                null,
                'Unexpected status: ' + statusCode + ' ' + responseBody
            );
        }
    }

    /**
     * handleSuccess
     *
     * Called when the external API returns 200 or 201.
     * Deserializes the response JSON to extract the externalCandidateId.
     *
     * Expected response: { "success": true, "externalCandidateId": "EXT1001" }
     *
     * JSON.deserializeUntyped() returns a Map<String, Object> which we
     * cast to read individual fields without needing a full response class.
     */
    private void handleSuccess(Id appId, String responseBody) {
        String externalId = null;

        try {
            // Deserialize the JSON response into a generic Map
            Map<String, Object> responseMap =
                (Map<String, Object>) JSON.deserializeUntyped(responseBody);

            // Extract the external candidate Id if present
            if (responseMap.containsKey('externalCandidateId')) {
                externalId = String.valueOf(responseMap.get('externalCandidateId'));
            }
        } catch (Exception e) {
            // Response JSON was malformed — still mark as Sent
            // because the status code (200/201) confirms success
            System.debug('PlacementSyncProcessor: Could not parse success response: '
                + e.getMessage());
        }

        updateIntegrationStatus(appId, 'Sent', externalId, null);
    }

    /**
     * updateIntegrationStatus
     *
     * Centralized DML method — updates the four integration fields on
     * Application__c in one update call.
     *
     * Parameters:
     *   appId       — the Application record Id
     *   status      — Pending / Sent / Failed / Retry Required
     *   externalId  — EXT1001 etc, or null
     *   errorMsg    — error message to store, or null on success
     */
    private void updateIntegrationStatus(
        Id appId,
        String status,
        String externalId,
        String errorMsg
    ) {
        Application__c appToUpdate = new Application__c(Id = appId);
        appToUpdate.Integration_Status__c       = status;
        appToUpdate.External_Candidate_Id__c    = externalId;
        appToUpdate.Integration_Error__c        = errorMsg;
        appToUpdate.Last_Integration_Attempt__c = DateTime.now();

        try {
            update appToUpdate;
        } catch (DmlException de) {
            System.debug('PlacementSyncProcessor: Failed to update integration status: '
                + de.getMessage());
        }
    }

    /**
     * CandidateRequest — inner DTO class
     *
     * Represents exactly the JSON structure the external API expects.
     * Using a wrapper instead of serializing the SObject directly ensures:
     * - Only the required fields are included
     * - Field names match the API contract (camelCase, not Salesforce API names)
     * - Clean separation between Salesforce internals and the external contract
     */
    public class CandidateRequest {
        public String  studentId;
        public String  name;
        public String  email;
        public String  branch;
        public Decimal cgpa;
        public String  jobId;
        public String  company;
        public String  role;
        public String  selectionDate;
    }
}
