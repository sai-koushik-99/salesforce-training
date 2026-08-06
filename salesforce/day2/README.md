# Salesforce Training — Day 2

## 1. What is LWC?
**LWC (Lightning Web Component)** is Salesforce's modern UI framework built on web standards — HTML, JavaScript (ES6+), and CSS. Every component has three files: `.html` (view), `.js` (logic), and `.js-meta.xml` (config). Components run inside Lightning Experience and use a reactive data model — when a JS property changes, the HTML updates automatically without a page refresh.

---

## 2. What did you build?
On Day 2, we explored **Salesforce Data Model** and **Object Relationships** — understanding how data is structured and related inside Salesforce, and how to build custom objects for the Placement Management System.

---

## 3. Which file contains HTML?
The **`.html`** file contains the UI layout wrapped inside a single `<template>` tag.
```html
<template>
    <p>Student: {studentName}</p>
</template>
```

---

## 4. Which file contains JavaScript?
The **`.js`** file contains all logic, reactive properties, and event handlers.
```javascript
import { LightningElement } from 'lwc';
export default class StudentCard extends LightningElement {
    studentName = 'Rahul';
}
```

---

## 5. What did you learn today?
- **Salesforce Data Model** — How Salesforce organizes data using Objects, Fields, and Records
- **Standard Objects** — Account, Contact, Lead, Opportunity, Case — built-in Salesforce objects
- **Custom Objects** — Creating your own objects (e.g., Student, Company, Job Posting) for the Placement Portal
- **Object Relationships** — Lookup vs Master-Detail relationships and when to use each
- **Fields and Data Types** — Text, Number, Date, Picklist, Checkbox, Formula, and Lookup fields
- **Page Layouts** — Customizing which fields appear on a record page
- **Validation Rules** — Enforcing data quality with formula-based rules
- **SOQL Basics** — Salesforce Object Query Language for querying records: `SELECT Id, Name FROM Account`

---

## Documents
- `Salesforce_Day2.docx` — Full Day 2 notes and documentation

---
*Salesforce LWC Bootcamp — Vishnu Placement Portal Project*
