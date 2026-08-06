# Day 6 – Apex Triggers & Trigger Handler (Placement Management System)

## Overview

This module focuses on implementing Apex Triggers using a clean and scalable architecture. Instead of placing all business logic directly inside the trigger, the logic is separated into service classes, making the code easier to maintain, test, and extend.

The implementation is based on a Placement Management System, where students apply for jobs and the system validates applications, updates placement statistics, and handles notifications based on application status changes.

## Objectives

* Understand the purpose of Apex Triggers.
* Learn the Trigger Handler design pattern.
* Implement business logic using service classes.
* Follow Salesforce best practices by writing bulk-safe code.
* Keep triggers lightweight and maintainable.

## Features Implemented

* Created an `Application__c` trigger for handling record events.
* Validated student eligibility before application submission.
* Updated placement statistics after a student is selected.
* Triggered notifications when the application status changes.
* Organized business logic into reusable service classes.

## Project Structure

```text
force-app/
└── main/
    └── default/
        ├── classes/
        │   ├── ApplicationService.cls
        │   ├── StatisticsService.cls
        │   ├── NotificationService.cls
        │   └── Test Classes
        └── triggers/
            └── ApplicationTrigger.trigger
```

## Business Logic

### Before Insert

* Validates whether the student meets the job eligibility criteria.
* Checks conditions such as minimum CGPA and allowed backlogs before creating an application.

### After Update

* Updates placement statistics when an application is marked as **Selected**.
* Handles notification logic for important status changes such as Interview Scheduled, Selected, Rejected, and Offer Accepted.

## Concepts Covered

* Apex Triggers
* Trigger Context Variables
* Before Insert Trigger
* After Update Trigger
* Trigger Handler Pattern
* Service Layer Architecture
* Bulk-Safe Development
* SOQL
* DML Operations
* Collections (List, Set, Map)

## Best Practices Followed

* Business logic is separated from the trigger.
* Bulk processing is used to support multiple records.
* SOQL and DML operations are performed outside loops.
* Code is structured for better readability and future maintenance.

## Learning Outcomes

After completing this module, I gained a better understanding of how Salesforce triggers work and how to build scalable Apex solutions using the Trigger Handler pattern. I also learned the importance of writing bulk-safe code, organizing business logic into service classes, and following Salesforce development best practices.
