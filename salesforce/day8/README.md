# Day 8 – Asynchronous Apex

## Overview

Day 8 was mainly about understanding how Salesforce handles work that doesn't need to be completed immediately.

I worked with different types of Asynchronous Apex and learned when each one is useful. The main focus was on **Future Methods**, **Queueable Apex**, **Queueable Chaining**, **Batch Apex**, and **Scheduled Apex**.

Instead of just learning the syntax, I focused on understanding why a particular asynchronous approach should be selected for a specific requirement.

---

## What I Learned

### Future Methods

I learned how `@future` methods allow certain operations to run asynchronously.

A Future Method is useful when some work does not have to be completed as part of the current transaction. I also understood that existing Future Methods should not be replaced with Queueable Apex automatically just because Queueable provides more features.

The basic structure I practiced was:

```apex
@future
public static void processApplicationAsync(Id applicationId) {
    // Background processing
}
```

I also learned that `@future(callout=true)` can be used when the asynchronous method needs to make a callout.

---

### Queueable Apex

Queueable Apex was the main hands-on topic for the day.

I learned that Queueable is a class-based approach to asynchronous processing. Instead of using an annotation on a method, I create a class that implements the `Queueable` interface.

The basic structure is:

```apex
public class OfferPostProcessingJob implements Queueable {

    private Id offerId;

    public OfferPostProcessingJob(Id offerId) {
        this.offerId = offerId;
    }

    public void execute(QueueableContext context) {
        // Background processing
    }
}
```

The job is submitted using:

```apex
System.enqueueJob(
    new OfferPostProcessingJob(offerId)
);
```

One thing that became clearer to me was that I don't directly call the `execute()` method. I enqueue the job, and Salesforce executes it asynchronously.

---

### Queueable Chaining

I also learned about Queueable Chaining.

The idea is that one Queueable job can start another Queueable job after completing its work.

```
ExternalPlacementSyncJob
        ↓
PlacementNotificationJob
```

This is useful when background tasks need to happen in a particular sequence.

I practiced passing an ID through the jobs and using `System.enqueueJob()` to start the next job.

---

### Batch Apex

Next, I learned about Batch Apex and why it is useful when working with a large number of records.

The basic Batch Apex structure contains three methods:

```
start()
   ↓
execute()
   ↓
finish()
```

I practiced creating a `PlacementCategoryBatch` class and using `Database.QueryLocator` to identify the records that needed processing.

The main idea I learned was that Batch Apex processes records in smaller scopes instead of trying to process a very large dataset in one transaction.

I also learned that batch size is an engineering decision and depends on the amount of processing, queries, DML, callouts, CPU usage, and heap usage involved.

---

### Scheduled Apex

I then learned about Scheduled Apex.

Scheduled Apex is useful when a process needs to run at a particular time rather than immediately.

The basic structure is:

```apex
public class ExpiredJobScheduler implements Schedulable {

    public void execute(SchedulableContext context) {
        // Scheduled processing
    }
}
```

The important idea I understood is: **Scheduled Apex is mainly responsible for deciding when something should run.**

---

### Scheduled Apex with Batch Apex

I also learned how Scheduled Apex and Batch Apex can work together.

```
Scheduled Apex
      ↓
Start Batch Apex
      ↓
Process Large Dataset
```

This separates the responsibilities. The Scheduler decides **when** the process starts, while Batch Apex handles **how** to process a large number of records.

---

### Monitoring Asynchronous Jobs

I learned that asynchronous jobs need to be monitored instead of assuming that they always complete successfully.

Salesforce provides `AsyncApexJob` for checking information about asynchronous jobs.

I practiced querying information such as:
- Job status
- Job type
- Number of errors
- Records processed
- Total records

This helped me understand how I would investigate an asynchronous process if something went wrong.

---

### Partial Success and Error Handling

Another important concept I learned was partial-success processing.

Instead of simply using:
```apex
update records;
```

Salesforce provides:
```apex
Database.update(records, false);
```

This allows individual results to be checked so that the application can determine which records succeeded and which ones failed.

I also learned that partial success should not be used automatically. It depends on the business requirement and whether it is acceptable for some records to succeed while others fail.

---

## Key Takeaways

The biggest thing I learned today was that asynchronous Apex is not just about making code run later. The type of asynchronous process should be selected based on the actual requirement.

| Requirement | Approach |
|-------------|----------|
| Simple asynchronous work | Future Method |
| Structured background job | Queueable Apex |
| Dependent background jobs | Queueable Chaining |
| Large number of records | Batch Apex |
| Run at a particular time | Scheduled Apex |
| Scheduled large-volume processing | Scheduled Apex + Batch Apex |

I also learned that moving code to asynchronous Apex does not automatically solve poor design or governor-limit problems. The code still needs to be **bulkified**, **efficient**, and **designed according to the actual workload**.

---

## Day 8 Outcome

By the end of Day 8, I was able to understand and practice the basic structure of Future, Queueable, Batch, and Scheduled Apex.

More importantly, I started looking at Apex from an **architecture point of view** — not just asking *"How do I write this code?"*, but also asking *"When should this code run, how much data will it process, and which asynchronous approach makes the most sense?"*
