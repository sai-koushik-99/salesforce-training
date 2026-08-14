# ADR-002: Point-to-Point Integration vs. Middleware

**Date:** 2026-08-14
**Status:** Accepted

## Context
The system integrates with one external system (RecruitEdge).
Decision: direct point-to-point or middleware (MuleSoft, Azure Service Bus)?

## Decision
Use point-to-point integration via Salesforce Named Credential.

## Reasons
1. Only one external system — middleware adds cost with no benefit.
2. Simple integration: one POST request, one response.
3. No message routing or transformation required.

## When Middleware Would Be Appropriate
- Integrating with 5+ external systems.
- Complex routing (one event → multiple downstream systems).
- Guaranteed delivery with dead-letter queues required.

## Named Credential Usage
All credentials stored in Named Credential (Recruitment_API).
Apex references: callout:Recruitment_API/candidates
No credentials ever appear in source code.
