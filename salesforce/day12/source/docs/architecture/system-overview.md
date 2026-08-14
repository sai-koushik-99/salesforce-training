# Placement Management System — Architecture Overview

## Data Model

```
Student__c ──────────────────────────────────────────┐
  - Name                                             │
  - Email__c                                         │ Lookup
  - Branch__c                                        │
  - CGPA__c                                          │
  - Active_Backlogs__c                               │
  - Placement_Status__c (Picklist)                   │
  - Selected_Company__c                              │
                                                     ▼
Job__c ──────────────────────────────────► Application__c
  - Name                                    - Student__c (Lookup)
  - Company__c                              - Job__c (Lookup)
  - Eligible_Branches__c                    - Status__c (Lifecycle)
  - Minimum_CGPA__c                         - Application_Date__c
  - Allowed_Backlogs__c                     - Integration_Status__c
  - Closing_Date__c                         - External_Candidate_Id__c
                                            - Integration_Error__c
                                            - Last_Integration_Attempt__c
                                                     │
                                                     │ On "Selected"
                                                     ▼
                                          PlacementSyncProcessor
                                          (Queueable + Callout)
                                                     │
                                                     ▼
                                          RecruitEdge External API
                                          POST /candidates
```

## Service Layer Architecture

```
Trigger (thin — routing only)
  StudentJobApplicationTrigger
    ├── before insert  → ApplicationService.validateEligibility()
    └── after update   → StatisticsService.updateStatistics()
                      → NotificationService.sendStatusNotifications()
                      → PlacementService.syncSelectedCandidates()
                                │
                                └── System.enqueueJob(PlacementSyncProcessor)
                                          │
                                          └── HTTP POST → RecruitEdge
```

## LWC Component Map

```
Application__c Record Page
  └── applicationIntegrationStatus (LWC)
        ├── Reads: Application__c integration fields
        ├── Calls: ApplicationIntegrationController.getApplicationStatus()
        └── Button: ApplicationIntegrationController.syncCandidate()
                        └── enqueues PlacementSyncProcessor
```

## Governor Limit Considerations

| Operation | Limit | Our Design |
|---|---|---|
| DML statements per transaction | 150 | Collected, single DML at end |
| SOQL queries per transaction | 100 | All SOQL outside loops |
| Queueable jobs per transaction | 50 | 1 job per qualifying application |
| Callouts per transaction | 100 | 1 per Queueable execution |
| Heap size | 6 MB | Small payloads, no bulk data |
