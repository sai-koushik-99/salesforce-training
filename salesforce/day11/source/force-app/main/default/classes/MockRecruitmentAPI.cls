/**
 * MockRecruitmentAPI
 *
 * HttpCalloutMock implementation for testing PlacementSyncProcessor.
 *
 * This class intercepts all HTTP callouts made during test execution and
 * returns a configurable fake response. No real network call is made.
 *
 * Usage in tests:
 *   Test.setMock(HttpCalloutMock.class, new MockRecruitmentAPI(201,
 *       '{"success":true,"externalCandidateId":"EXT1001"}'));
 *
 * The mock is registered BEFORE the callout is triggered. Salesforce
 * automatically intercepts http.send() during the test and routes it here.
 *
 * Day 11 — Placement Management System Integration
 */
@isTest
public class MockRecruitmentAPI implements HttpCalloutMock {

    // The HTTP status code this mock will return (200, 201, 400, 500, etc.)
    private Integer statusCode;

    // The response body JSON this mock will return
    private String responseBody;

    /**
     * Constructor — configure what response this mock returns.
     *
     * @param statusCode    e.g. 201
     * @param responseBody  e.g. '{"success":true,"externalCandidateId":"EXT1001"}'
     */
    public MockRecruitmentAPI(Integer statusCode, String responseBody) {
        this.statusCode   = statusCode;
        this.responseBody = responseBody;
    }

    /**
     * respond — called automatically by Salesforce when http.send() is
     * executed during a test. Returns a fake HttpResponse.
     *
     * @param req  the HttpRequest that was attempted
     * @return     a fake HttpResponse with the configured status and body
     */
    public HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(statusCode);
        res.setBody(responseBody);
        res.setHeader('Content-Type', 'application/json');
        return res;
    }
}
