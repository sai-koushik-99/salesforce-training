# Chapter 12 — Interview Corner: 15 Questions & Answers

**Q1. What is the difference between sf and sfdx?**
sfdx is the original Salesforce DX CLI (2017). sf is the new unified CLI that
replaces it. Both install together but sfdx is being retired. Always use sf
for all new commands (sf project deploy start, not sfdx force:source:push).

**Q2. What is a Salesforce DX project structure and why does it matter?**
A SFDX project organises metadata in force-app/main/default/ with each component
in its own folder plus a -meta.xml file. This lets Git track changes at the
component level, enables CI/CD, and makes code review meaningful. Changesets
treat metadata as opaque blobs — no diffing possible.

**Q3. What is the difference between metadata, code, and data in Salesforce?**
- Code: Apex classes, triggers, LWC — logic that runs on the platform.
- Metadata: Objects, fields, page layouts, validation rules, flows — org config.
  Both code and metadata belong in Git.
- Data: Account records, student records — rows in the database. Data does NOT
  belong in Git. Use Data Loader for data migration.

**Q4. What should NOT be stored in Git in a Salesforce project?**
- Record data (student/job records)
- Credentials, API keys, OAuth tokens
- Named Credential secrets
- .sfdx/ and .sf/ folders (machine-specific local tracking)
- Sandbox-specific config that differs per environment

**Q5. What is a Named Credential and why should URLs never be hardcoded?**
A Named Credential stores the base URL and auth details for an external service.
Apex references callout:Recruitment_API/candidates instead of a hardcoded URL.
Benefits: credentials never in code (security), URL changeable without code
deploy (agility), each environment points to a different endpoint (isolation).

**Q6. Why can Apex triggers not make HTTP callouts directly?**
Triggers execute in a synchronous database transaction. HTTP callouts are I/O
that could take seconds or time out, which holds a database lock open.
Salesforce prohibits this. Correct pattern: trigger → enqueue Queueable
(with Database.AllowsCallouts) → Queueable makes callout after transaction commits.

**Q7. What is the difference between a Changeset and Salesforce CLI deployment?**
| Aspect | Changeset | Salesforce CLI |
|---|---|---|
| Version control | No — manual selection | Yes — Git-tracked |
| Automation | No — click-only | Yes — scriptable, CI/CD |
| Rollback | No undo | Git revert + redeploy |
| Audit trail | Limited | Full Git history |
Changesets are for one-off admin deployments. CLI is the professional standard.

**Q8. What does --test-level RunLocalTests do during deployment?**
Tells Salesforce to run all Apex test classes that are NOT from managed packages.
Required for production deployments. Without it, the production minimum of 75%
code coverage is not verified. Always use RunLocalTests for QA and above.

**Q9. What is a feature branch and why is it important?**
A feature branch is a copy of main where one feature is developed in isolation.
Importance: (1) main stays stable/deployable always, (2) multiple developers
work simultaneously without conflicts, (3) code review via PR happens before
main, (4) broken feature = delete branch, main unaffected.

**Q10. What is a Pull Request and what makes a good one?**
A PR is a formal request to merge a feature branch into main. A good PR has:
clear title (feat: add RecruitEdge integration), description of WHY the change
was made, what was tested, and a reviewer checklist covering governor limits,
test coverage, security, and naming conventions.

**Q11. How do you resolve a Git merge conflict?**
1. git pull/merge reveals the conflict
2. Open conflicted file — Git marks it with <<<<<<<, =======, >>>>>>>
3. <<<<<<< to ======= is YOUR change; ======= to >>>>>>> is THEIRS
4. Read both sides, write the correct final version combining both
5. Remove all conflict markers from the file
6. git add <file> then git commit to complete the merge
Never blindly pick ours or theirs — understand the intent of both changes.

**Q12. What is the deployment pipeline from Developer Org to Production?**
Developer Org → feature branch → PR → merge to main →
QA Sandbox (automated tests) → UAT Sandbox (real users) → Production (live).
Each stage validates for a different audience.

**Q13. Why must you deploy the entire system and not just one file?**
Salesforce validates all metadata references on every deploy. An LWC referencing
an Apex class, which queries a custom object — all must be present. A partial
deploy missing any dependency fails with "Entity of type X named Y not found."

**Q14. What is sfdx-project.json and what does it do?**
The Salesforce DX project config file. Defines: which directories contain source
(packageDirectories), the API version (sourceApiVersion), and the login URL.
The Salesforce CLI reads this file to locate source files and determine the API
version for deployment and retrieval.

**Q15. What is a Scratch Org and when would you use one?**
A Scratch Org is a temporary Salesforce environment (expires in 1-30 days) spun
up from a definition file in minutes. Use for: isolated feature development,
CI/CD pipelines (fresh org per build), testing org shape. Use a Developer Org
when you need persistence, long-running integrations, or learning/training.

---

# Debug This! — 5 Deployment Review Situations

**Situation 1:** Deploy fails: "The object named Application__c does not exist"
Root Cause: Deployed Apex class/LWC references Application__c but object
metadata not included in deployment.
Fix: Run sf project deploy start from project root to deploy everything together.

**Situation 2:** Tests pass locally but fail with "You have uncommitted work
pending" during deployment.
Root Cause: Test class makes callout but does not use HttpCalloutMock.
In deployment test runs, Salesforce blocks real callouts.
Fix: Add Test.setMock(HttpCalloutMock.class, new MockRecruitmentAPI(201, true));

**Situation 3:** Code coverage shows 72%, production deployment rejected.
Root Cause: Salesforce production requires minimum 75% coverage on all classes.
Fix: Run sf apex run test and check coverage column. Add test methods covering
catch blocks and edge cases (400, 401, 500 HTTP responses, CalloutException).

**Situation 4:** Trigger deploys successfully but nothing happens when status
changes to Selected.
Root Cause: Trigger deployed but inactive, OR conditional check not met.
Fix: Setup → Apex Triggers → verify StudentJobApplicationTrigger is Active.
Add a Debug Log trace, reproduce the issue, check log for trigger execution.

**Situation 5:** Integration_Status__c always "Pending", never updates.
Root Cause: Queueable job enqueued but fails silently. Common causes:
Named Credential Recruitment_API missing, Queueable class not deployed,
or governor limit hit.
Fix: Setup → Apex Jobs — find failed PlacementSyncProcessor jobs, read error.
Check Integration_Error__c field on the Application record.
Verify Named Credential: Setup → Named Credentials.
