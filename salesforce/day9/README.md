# Day 9 – Lightning Web Components (LWC)

## Overview

Today I started learning Lightning Web Components (LWC) and focused on understanding how Salesforce can be used to build interactive user interfaces.

Instead of trying to learn everything at once, I built the component step by step and tested each part before moving to the next one.

---

## What I Learned

- Basic structure of an LWC
- Role of the HTML, JavaScript, and metadata files
- Data binding between JavaScript and HTML
- Handling button click events
- Creating and displaying job information
- Using arrays and objects in LWC
- Displaying multiple records using iteration
- Conditional rendering
- Loading, empty, and error states
- Basic understanding of Lightning Data Service
- Basic understanding of `@wire`
- When LWC can use Apex to retrieve or process data

---

## LWC Structure

The basic component I worked with was:

```
eligibleJobs
├── eligibleJobs.html
├── eligibleJobs.js
└── eligibleJobs.js-meta.xml
```

The HTML file is responsible for the UI, the JavaScript file contains the component's data and behaviour, and the metadata file controls where the component can be used in Salesforce.

---

## Hands-on Work

I created an `eligibleJobs` component and started with a simple Lightning Card.

After that, I practiced data binding by keeping values in JavaScript and displaying them in HTML.

For example:

```javascript
studentName = 'Koushik';
```

Displaying it in HTML using:

```html
<p>Welcome, {studentName}</p>
```

I then created a sample job with details such as:
- Company
- Job Role
- Package
- Location
- Deadline

I also added a **View Details** button to understand how events work in LWC.

---

## Multiple Jobs and Iteration

After getting one job working, I moved to multiple jobs using an array of objects.

This helped me understand how LWC iteration can be used to display multiple job records without writing the same HTML repeatedly.

```
Jobs Array
    ↓
Iteration
    ↓
Job 1  Job 2  Job 3
    ↓
Job Cards
```

---

## Conditional Rendering

I also learned that a real component should handle different situations instead of only displaying data when everything works.

The main states I looked at were:

| State | Description |
|-------|-------------|
| Loading | Show a spinner while data is being fetched |
| Success | Display the job cards when data is available |
| Empty | Show a message when no eligible jobs exist |
| Error | Show an error message when something goes wrong |

For example, if there are no eligible jobs, the component should display a suitable message instead of showing an empty screen.

---

## Data Access Concepts

I also started understanding how an LWC can get data from Salesforce.

The main concepts covered were:

- **Lightning Data Service** — Access standard Salesforce record data without Apex
- **`@wire`** — Automatically fetch data when the component loads
- **Apex Integration** — Call server-side Apex for complex business logic

The important thing I learned is that **not every LWC needs Apex**. The simplest suitable approach should be used depending on the requirement.

For more complicated business logic, such as job eligibility, the logic should remain in the appropriate Apex/service layer rather than being duplicated inside the LWC.

---

## What I Built

By the end of this day, I had worked towards an **Eligible Jobs** component that can:

- Display job information
- Use JavaScript data in the UI
- Handle button events
- Display multiple jobs using iteration
- Handle different UI states (loading, empty, error)

The component will later be connected to actual Salesforce data and the eligibility logic from the backend.

---

## Key Takeaway

The biggest thing I learned today was that **LWC is not just about writing HTML and JavaScript**. It is about connecting the Salesforce backend with a user-friendly interface.

I am still learning LWC, so I focused more on understanding how each part works rather than trying to memorize the syntax.

---

## Day 9 Progress

| Topic | Status |
|-------|--------|
| LWC Basics | ✅ |
| Component Structure | ✅ |
| Data Binding | ✅ |
| Events | ✅ |
| Job Card | ✅ |
| Iteration | ✅ |
| Conditional UI | ✅ |
| LDS / @wire | 📚 Learning |
| Apex Integration | 📚 Next Step |

---

## Component — eligibleJobs

```
source/
└── force-app/main/default/lwc/
    └── eligibleJobs/
        ├── eligibleJobs.html
        ├── eligibleJobs.js
        └── eligibleJobs.js-meta.xml
```

---

*Salesforce LWC Bootcamp — Vishnu Placement Portal Project*
