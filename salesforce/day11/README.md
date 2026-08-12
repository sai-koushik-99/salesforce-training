# Day 11 – API Integration & External System Communication

## Overview

Today I worked on API Integration in Salesforce and understood how a Salesforce application can communicate with an external system. The main goal was to extend the Placement Management System so that selected candidates can be sent to an external recruitment system.

---

## What I Learned

### APIs and REST APIs

I started with the basics of APIs and REST APIs. An API acts as a way for two different software systems to communicate with each other. In a REST API, communication happens through HTTP methods such as:

- `GET` — retrieve data
- `POST` — send/create data
- `PUT` — replace data
- `PATCH` — update part of data
- `DELETE` — remove data

I also learned about the structure of an API request and response:

| Part | Description |
|------|-------------|
| Endpoint | The URL of the external system |
| HTTP Method | The operation to perform |
| Headers | Metadata like Content-Type, Authorization |
| Request Body | Data sent to the external system |
| Response Body | Data returned by the external system |
| HTTP Status Codes | Result of the request (200, 400, 500 etc.) |

For the project, the main operation is a **POST request** that sends selected candidate information to an external recruitment system.

---

### JSON

I learned how JSON is used to exchange data between systems. For example, the candidate information sent from Salesforce can contain:

```json
{
  "studentId": "S001",
  "name": "Rahul Kumar",
  "email": "rahul@example.com",
  "branch": "CSE",
  "cgpa": 8.5,
  "jobId": "J001",
  "company": "TCS",
  "role": "Software Engineer",
  "selectionDate": "2026-08-12"
}
```

I also learned about **JSON serialization** (converting Apex objects to JSON) and **deserialization** (converting JSON back to Apex objects).

---

### HTTP Callouts

The main hands-on part of today was understanding HTTP Callouts in Apex.

The basic flow is:

```
Apex
  ↓
HttpRequest
  ↓
HTTP Callout
  ↓
External API
  ↓
HttpResponse
```

I learned how `HttpRequest`, `Http`, and `HttpResponse` are used to create a request, send it, and process the response.

---

### Named Credentials

I learned why credentials should not be hard-coded inside Apex.

Instead of keeping API credentials directly in the code, Salesforce **Named Credentials** can be used to manage the endpoint and authentication details more securely.

```
Apex
  ↓
Named Credential
  ↓
Authentication
  ↓
External API
```

This also makes it easier to manage and change authentication details without modifying the Apex code.

---

### Connecting API Integration with Queueable Apex

One of the important parts of Day 11 was connecting the API callout with the Queueable Apex concepts learned previously.

The final flow of the project is:

```
Application Status = Selected
          ↓
        Trigger
          ↓
    Handler / Service
          ↓
     Queueable Apex
          ↓
      HTTP Callout
          ↓
    Named Credential
          ↓
  External Recruitment API
          ↓
        Response
          ↓
 Update Integration Status
```

This keeps the trigger focused on detecting the change while the Queueable handles the external communication.

---

### Integration Status

I learned that the Salesforce transaction and external API transaction are not necessarily the same thing.

For example, a student can successfully become **Selected** in Salesforce while the external recruitment API may be unavailable.

So I added the idea of tracking integration separately:

| Field | Values |
|-------|--------|
| Application Status | Selected |
| Integration Status | Sent / Failed / Retry Required |

I also learned that storing the external candidate ID and error information makes the integration easier to monitor.

---

### Error Handling

I learned how different HTTP responses represent different situations:

| Status Code | Meaning |
|-------------|---------|
| 200 / 201 | Successful request |
| 400 | Bad Request |
| 401 | Authentication problem |
| 403 | Permission problem |
| 500 | External server problem |

Instead of treating every failure the same way, the integration should decide whether the request should be marked as **failed** or **retried**.

---

### Retry and Idempotency

Another important concept I learned was **idempotency**.

For example, if Salesforce sends a candidate successfully but does not receive the response, it might try sending the same candidate again. Without proper handling, the external system could create duplicate candidates.

To avoid this, the integration can use a unique reference such as the **Salesforce Application ID** or another external reference.

---

### LWC and Integration

I also understood where LWC fits into the integration.

The actual HTTP callout should not be performed directly from the LWC. Instead, LWC communicates with Apex and displays the result of the integration.

```
LWC
  ↓
Apex
  ↓
Queueable
  ↓
External API
```

The LWC can display information such as:
- Application Status
- Integration Status
- External Candidate ID
- Last Integration Attempt
- Error Message

So the LWC acts as the **user interface** while Apex handles the **integration logic**.

---

### Testing

I learned that HTTP callouts should be tested using `HttpCalloutMock` instead of depending on a real external API during Apex tests.

The important scenarios to test are:
- Successful response (200/201)
- 400 error
- 401 error
- 403 error
- 500 error
- Unexpected response
- Callout exception
- Queueable execution
- Integration status updates

---

### Other Concepts

I also went through the concepts of:

- **Synchronous vs Asynchronous integration** — when to use each approach
- **Point-to-point integration** — direct connection between two systems
- **Middleware** — a layer that sits between systems to manage communication
- **Salesforce Connect** — connecting to external data sources in real time
- **External Objects** — representing external data inside Salesforce
- **Authentication vs Authorization** — who you are vs what you can do
- **API contracts** — the agreement between systems about request/response structure

These helped me understand that API integration is not just about writing an HTTP callout. The overall design also needs to consider **security, error handling, retries, duplicate prevention, monitoring and scalability**.

---

## Final Architecture

```
LWC
  ↓
Application
  ↓
Status changes to Selected
  ↓
Trigger
  ↓
Handler
  ↓
Service
  ↓
Queueable
  ↓
Named Credential
  ↓
REST API
  ↓
External Recruitment System
  ↓
Response
  ↓
Integration Status Update
  ↓
LWC
```

---

## Project Structure

```
day11/
├── README.md
├── source/
│   └── force-app/main/default/
│       ├── classes/
│       │   ├── ApplicationIntegrationController.cls
│       │   ├── ApplicationService.cls
│       │   ├── MockRecruitmentAPI.cls
│       │   ├── PlacementSyncProcessor.cls
│       │   ├── PlacementSyncProcessorTest.cls
│       │   └── ... (other Apex classes)
│       ├── lwc/
│       │   ├── applicationIntegrationStatus/
│       │   ├── eligibleJobs/
│       │   ├── jobCard/
│       │   ├── studentPortal/
│       │   └── studentProfile/
│       ├── objects/
│       │   └── Application__c/ (with Integration_Status__c, External_Candidate_Id__c fields)
│       └── triggers/
│           └── ApplicationTrigger.trigger
└── candidate-api.md
```

---

*Salesforce LWC Bootcamp — Vishnu Placement Portal Project*
