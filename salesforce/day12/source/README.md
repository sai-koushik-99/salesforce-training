# Placement Management System

> **Chapter 12 — From Developer Org to Production**
> Git · Salesforce CLI · Metadata · Sandboxes · Deployment

---

## Project Overview

The **Placement Management System** is a Salesforce application that automates the
end-to-end student placement lifecycle — from job discovery to offer letter generation
and external recruitment platform integration.

### Core Salesforce Objects

| Object | Purpose |
|---|---|
| `Student__c` | Student master record (CGPA, branch, placement status) |
| `Job__c` | Job posting (company, role, eligibility criteria) |
| `Application__c` | Junction: Student + Job, tracks the full application lifecycle |
| `Offer_Letter__c` | Generated when a student is placed |

### Application Status Lifecycle

```
Applied → Under Review → Shortlisted → Selected / Rejected
```

### Integration

When `Application__c.Status__c` transitions to **Selected**, the system automatically
POSTs candidate data to the **RecruitEdge** external recruitment API via a Queueable
Apex job (asynchronous, non-blocking).

---

## Prerequisites

| Tool | Minimum Version | Check Command |
|---|---|---|
| Git | 2.40+ | `git --version` |
| Salesforce CLI (sf) | 2.0+ | `sf --version` |
| Node.js (for LWC linting) | 18+ | `node --version` |
| VS Code + Salesforce Extension Pack | Latest | Open VS Code |

---

## Repository Structure

```
placement-management-system/
├── README.md                          <- This file (start here)
├── sfdx-project.json                  <- Salesforce DX project config
├── .forceignore                       <- Files ignored by sf push/retrieve
├── .gitignore                         <- Files excluded from Git
│
├── force-app/
│   └── main/
│       └── default/
│           ├── classes/               <- Apex classes and test classes
│           ├── triggers/              <- Apex triggers
│           ├── lwc/                   <- Lightning Web Components
│           └── objects/               <- Custom objects and fields
│               ├── Student__c/
│               ├── Job__c/
│               ├── Application__c/
│               └── Offer_Letter__c/
│
├── docs/
│   ├── architecture/                  <- System design and data model
│   ├── api/                           <- API contracts (RecruitEdge)
│   ├── deployment/                    <- Deployment guides and changelogs
│   └── decisions/                     <- Architectural Decision Records (ADRs)
│
├── scripts/
│   ├── deploy.ps1                     <- One-click deployment script
│   └── retrieve.ps1                   <- One-click metadata retrieval script
│
├── tests/
│   └── test-data.md                   <- Manual test scenarios and data
│
└── screenshots/
    └── chapter12/                     <- Evidence screenshots for trainer
```

---

## Git Setup

```powershell
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Verify
git config --global --list
```

### Branching Strategy

| Branch | Purpose |
|---|---|
| `main` | Stable, production-ready code only |
| `feature/*` | New features (e.g., `feature/candidate-integration`) |
| `bugfix/*` | Bug fixes (e.g., `bugfix/cgpa-validation`) |
| `hotfix/*` | Emergency production fixes |

**Rule:** Never commit directly to `main`. Always use a feature branch and Pull Request.

---

## Salesforce CLI Setup

```powershell
# Verify installation
sf --version

# sf = current CLI (always use this)
# sfdx = legacy CLI (being retired, avoid)
```

---

## Authentication — Connect to Your Salesforce Org

```powershell
# Authenticate (opens browser login)
sf org login web --alias placement-dev --set-default

# Verify connection
sf org display --target-org placement-dev

# List all authenticated orgs
sf org list
```

### WARNING — Wrong Org Deployment

**ALWAYS verify which org you are targeting before deploying.**

```powershell
sf org display --target-org placement-dev
```

Always use `--target-org placement-dev` on every deploy command. Without it,
Salesforce CLI uses the default org which could be a different environment.

---

## Clone Instructions

```powershell
git clone https://github.com/sai-koushik-99/salesforce-training.git
cd salesforce-training
cd "day 4/salesforce/day12/source"
```

---

## Retrieve Metadata from Org

```powershell
# Retrieve all source
sf project retrieve start --target-org placement-dev

# Retrieve specific metadata types
sf project retrieve start ^
  --metadata ApexClass ^
  --metadata ApexTrigger ^
  --metadata LightningComponentBundle ^
  --metadata CustomObject ^
  --target-org placement-dev
```

### What Gets Retrieved Where

| Metadata Type | Local Path |
|---|---|
| Apex Classes | `force-app/main/default/classes/` |
| Apex Triggers | `force-app/main/default/triggers/` |
| LWC Components | `force-app/main/default/lwc/` |
| Custom Objects | `force-app/main/default/objects/<ObjectName__c>/` |
| Custom Fields | `force-app/main/default/objects/<ObjectName__c>/fields/` |
| Validation Rules | `force-app/main/default/objects/<ObjectName__c>/validationRules/` |

---

## Deploy Instructions

```powershell
# Validate only (dry run — no actual deploy)
sf project deploy validate --target-org placement-dev --test-level RunLocalTests

# Deploy all source
sf project deploy start --target-org placement-dev --test-level RunLocalTests

# Deploy specific component
sf project deploy start --metadata ApexClass:PlacementSyncProcessor --target-org placement-dev
```

### Deployment Dependency Rule

Never deploy a single component in isolation if it has dependencies.
`applicationIntegrationStatus` LWC depends on:
- `ApplicationIntegrationController` Apex class
- `Application__c` object with integration fields
- `Student__c` and `Job__c` lookup fields

Deploying the LWC alone WILL FAIL. Deploy the full project together.

---

## Test Instructions

```powershell
# Run all Apex tests
sf apex run test --target-org placement-dev --result-format human

# Run a specific test class
sf apex run test --class-names PlacementSyncProcessorTest --target-org placement-dev --result-format human
```

### Expected Test Results

| Test Class | Tests | Expected Result |
|---|---|---|
| `PlacementSyncProcessorTest` | 13 | All Pass |
| `AccountProcessorTest` | - | All Pass |
| `DailyLeadProcessorTest` | - | All Pass |
| `LeadProcessorTest` | - | All Pass |

Minimum required code coverage: **75%** (Salesforce production requirement)

---

## Verification Steps

After deployment, verify in the Salesforce org:

1. **Objects exist** — Setup > Object Manager > Student__c, Job__c, Application__c
2. **Fields present** — Open each object and confirm custom fields exist
3. **Apex compiled** — Setup > Apex Classes > no compilation errors
4. **Triggers active** — Setup > Apex Triggers > StudentJobApplicationTrigger is Active
5. **LWC deployed** — Setup > Lightning Components > applicationIntegrationStatus exists
6. **End-to-end test** — Create Student, Job, Application; change status to Selected;
   verify Integration_Status__c becomes Sent or Retry Required

---

## Deployment Workflow

```
Developer Org (development)
        |
   git commit + push
        |
   feature branch
        |
   Pull Request + Code Review
        |
   Merge to main
        |
   QA Org (testing)
        |
   UAT Org (user acceptance)
        |
   Production Org
```

### Environment Information

| Environment | Purpose | Alias |
|---|---|---|
| Developer Org | Active development | `placement-dev` |
| QA Sandbox | Testing and validation | `placement-qa` |
| UAT Sandbox | User acceptance testing | `placement-uat` |
| Production | Live org | `placement-prod` |

---

## Metadata vs Code vs Data

| Category | Examples | Goes in Git? |
|---|---|---|
| **Code** | Apex classes, triggers, LWC | Yes |
| **Metadata** | Objects, fields, layouts, flows | Yes |
| **Config** | Named credentials, remote sites | Config only (no secrets) |
| **Data** | Account records, student records | No — use Data Loader |
| **Credentials** | Passwords, tokens, keys | Never |

---

## Deployment Tools Comparison

| Tool | Best For | Limitations |
|---|---|---|
| **Salesforce CLI (sf)** | Developer-to-org, automation, CI/CD | Requires CLI setup |
| **Metadata API** | Programmatic large deployments | Complex XML, low-level |
| **Changesets** | Point-and-click org-to-org | No version control, slow |
| **Sandboxes** | Full-copy testing environment | Refresh cost/time |
| **Scratch Orgs** | Isolated dev per feature | Expire in 30 days |

---

## Troubleshooting

### Problem 1: sf org login web fails or browser does not open

**Cause:** Browser blocked the OAuth callback or My Domain not enabled.
**Fix:**
```powershell
sf org login web --alias placement-dev --instance-url https://login.salesforce.com
```

### Problem 2: Deploy fails with "Entity of type X named Y not found"

**Cause:** A dependency (object, field, class) does not exist in the target org.
**Fix:** Deploy the full project, not individual components:
```powershell
sf project deploy start --target-org placement-dev
```

### Problem 3: Apex test fails during deployment — code coverage below 75%

**Cause:** One or more classes have insufficient test coverage.
**Fix:**
```powershell
sf apex run test --target-org placement-dev --result-format human
```
Check the coverage column and add test methods for uncovered lines.

### Problem 4: FIELD_CUSTOM_VALIDATION_EXCEPTION on deploy

**Cause:** Validation rule in target org blocking test data insert.
**Fix:** Check Application__c Validate_CGPA rule. Ensure test data uses valid CGPA values.

### Problem 5: Integration_Status__c stuck on Pending after setting status to Selected

**Cause:** Queueable failed silently, or Named Credential Recruitment_API not configured.
**Fix:**
1. Setup > Apex Jobs — check for failed PlacementSyncProcessor jobs
2. Verify Named Credential Recruitment_API exists in Setup
3. Check Integration_Error__c field on the Application record

---

## Feature Branch Workflow

```powershell
# 1. Always start from latest main
git checkout main
git pull origin main

# 2. Create feature branch
git checkout -b feature/candidate-integration

# 3. Make changes, then stage and commit
git add force-app/
git commit -m "feat: add PlacementSyncProcessor queueable for RecruitEdge integration"

# 4. Push branch to GitHub
git push -u origin feature/candidate-integration

# 5. Create Pull Request on GitHub
# Title: feat: Add candidate integration with RecruitEdge API
# Base: main  <--  Compare: feature/candidate-integration
```

---

## Pull Request Review Checklist

- [ ] Apex classes follow trigger handler pattern (no logic in trigger body)
- [ ] All DML operations are bulkified (no DML inside loops)
- [ ] All SOQL queries are outside loops
- [ ] Test classes have no SeeAllData=true
- [ ] Test coverage is 75% or above on all new classes
- [ ] No hardcoded IDs or credentials
- [ ] Named Credential used for all HTTP callouts
- [ ] Database.AllowsCallouts present on Queueable doing HTTP calls
- [ ] Error handling covers all HTTP status codes
- [ ] LWC does not make direct HTTP calls (goes through Apex)
- [ ] README updated if architecture changed

---

*Chapter 12 — Deployment Exercise*
*Repository: https://github.com/sai-koushik-99/salesforce-training*
