# Day 7 – Bulk-Safe Business Logic with Apex

## Overview

On Day 7, I focused on writing **bulk-safe Apex code** and understanding why Salesforce applications must be designed to handle multiple records in a single transaction. I learned how to avoid governor limit issues by using collections like **List**, **Set**, and **Map**, and by writing efficient SOQL and DML operations.

I also implemented a simple **Trigger → Handler → Service** architecture to separate trigger logic from business logic, making the code cleaner and easier to maintain.

---

## What I Learned

* What bulkification is and why it is important in Salesforce.
* How Salesforce processes multiple records using `Trigger.new`.
* Difference between `Trigger.new`, `Trigger.old`, and `Trigger.oldMap`.
* When to use **Before** and **After** triggers.
* How to use **Lists**, **Sets**, and **Maps** in Apex.
* Why SOQL and DML statements should never be placed inside loops.
* How to organize Apex code using Trigger, Handler, and Service classes.

---

## Hands-on Tasks Completed

### 1. Bulk Eligibility Validation

Implemented validation logic to check whether a student is eligible to apply for a job.

The implementation included:

* Collecting Student IDs and Job IDs using `Set<Id>`.
* Querying Student and Job records using bulk SOQL.
* Storing queried records in Maps for quick lookup.
* Comparing the student's CGPA with the job's minimum CGPA.
* Displaying an error message when the student does not meet the eligibility criteria.

---

### 2. Bulk Student Status Update

Implemented logic to detect when an application's status changes to **Selected**.

The implementation included:

* Comparing old and new status values using `Trigger.oldMap`.
* Collecting affected Student IDs.
* Querying Student records in a single SOQL query.
* Updating all required Student records using one DML operation.

---

### 3. Trigger Architecture

Created a simple three-layer architecture:

```text
ApplicationTrigger
        │
        ▼
ApplicationTriggerHandler
        │
        ▼
ApplicationService
```

* **Trigger** – Listens for record events.
* **Handler** – Routes trigger events to the appropriate methods.
* **Service** – Contains the actual business logic.

---

## Key Concepts Practiced

### Trigger Context Variables

* `Trigger.new`
* `Trigger.old`
* `Trigger.oldMap`
* `Trigger.isBefore`
* `Trigger.isAfter`
* `Trigger.isInsert`
* `Trigger.isUpdate`

---

### Collections

* **List** – Stores multiple records.
* **Set** – Stores unique values and removes duplicates.
* **Map** – Provides fast record lookup using an Id.

---

### Bulk Processing Best Practices

* Avoid SOQL queries inside loops.
* Avoid DML statements inside loops.
* Use Sets to collect unique record IDs.
* Use Maps to reduce unnecessary searches.
* Perform bulk queries and bulk updates whenever possible.
