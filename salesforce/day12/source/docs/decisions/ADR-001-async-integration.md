# ADR-001: Asynchronous Integration via Queueable Apex

**Date:** 2026-08-14
**Status:** Accepted

## Context
When Application__c status changes to "Selected", we need to POST candidate
data to the RecruitEdge external API. Decision: synchronous or asynchronous?

## Decision
Use Queueable Apex (PlacementSyncProcessor) with Database.AllowsCallouts.

## Reasons
1. Salesforce rule: triggers cannot make HTTP callouts synchronously.
2. User experience: saving a record should not wait for an external network call.
3. Resilience: if RecruitEdge is down, the Salesforce transaction still succeeds.
4. Retry-ability: failed jobs can be retried via the LWC Sync button.

## Trade-offs
| Concern | Impact |
|---|---|
| Eventual consistency | Integration_Status__c may show Pending briefly |
| Debugging | Async failures require checking Apex Jobs log |
| Complexity | More classes required vs. direct callout |

## Alternatives Rejected
- Synchronous callout from trigger: Not allowed in Salesforce.
- Flow + HTTP callout action: Still requires async for trigger-fired flows.
- Platform Event + External Service: Over-engineered for a single endpoint.
