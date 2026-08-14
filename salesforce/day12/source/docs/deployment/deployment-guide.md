# Deployment Guide — Placement Management System
# Chapter 12: From Developer Org to Production

## Pre-Deployment Checklist
- [ ] All Apex tests pass: sf apex run test --target-org placement-dev
- [ ] No syntax errors in VS Code Problems panel
- [ ] Correct org confirmed: sf org display --target-org placement-dev
- [ ] Feature branch merged via Pull Request (never push directly to main)
- [ ] README updated if architecture changed
- [ ] No credentials in any committed file

## Environment Promotion Path
```
Developer Org  →  QA Sandbox  →  UAT Sandbox  →  Production
    (dev)           (test)          (uat)           (prod)
```

## Deploy Commands

### Developer Org
```powershell
# Validate only (dry run)
sf project deploy validate --target-org placement-dev --test-level RunLocalTests

# Real deploy
sf project deploy start --target-org placement-dev --test-level RunLocalTests
```

### QA Sandbox
```powershell
sf org login web --alias placement-qa
sf project deploy start --target-org placement-qa --test-level RunLocalTests
```

### Production
```powershell
sf project deploy start --target-org placement-prod --test-level RunLocalTests
```

## What to Deploy — All Interdependent Components

### Custom Objects (deploy first)
- Student__c
- Job__c
- Application__c (with all integration fields)
- Offer_Letter__c

### Apex Classes (deploy after objects)
- PlacementSyncProcessor + test class
- PlacementService, ApplicationService
- NotificationService, StatisticsService
- ApplicationIntegrationController
- MockRecruitmentAPI (test mock)

### Apex Triggers
- StudentJobApplicationTrigger

### Lightning Web Components
- applicationIntegrationStatus
- studentPortal, eligibleJobs, studentProfile, jobCard, emptyState

## Why You Cannot Deploy Just One File

Salesforce validates ALL metadata references on every deploy.
Deploying applicationIntegrationStatus LWC alone fails because:
1. LWC references ApplicationIntegrationController → class missing? FAIL
2. Controller references Application__c.Integration_Status__c → field missing? FAIL
3. Field needs Application__c object → object missing? FAIL

Rule: always deploy sf project deploy start (full project).

## Deployment Log
| Date | Environment | By | Components | Status |
|---|---|---|---|---|
| 2026-08-14 | Developer Org | Sai Koushik | Full project | Success |

## Rollback Strategy
```powershell
git log --oneline
git checkout <last-good-commit-hash> -- force-app/
git commit -m "revert: rollback to pre-chapter12 state"
sf project deploy start --target-org placement-dev
```
