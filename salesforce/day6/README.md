# Salesforce Training — Day 6

## 1. What is LWC?
**LWC (Lightning Web Component)** is Salesforce's modern UI framework built on web standards — HTML, JavaScript (ES6+), and CSS. Every component has three files: `.html` (view), `.js` (logic), and `.js-meta.xml` (config). Components run inside Lightning Experience and use a reactive data model — when a JS property changes, the HTML updates automatically without a page refresh.

---

## 2. What did you build?
On Day 6, we built advanced features of the **Placement Management System** — focusing on connecting LWC components to Salesforce data using **Apex** and **Wire Adapters**.

---

## 3. Which file contains HTML?
The **`.html`** file contains the UI layout wrapped inside a single `<template>` tag.
```html
<template>
    <div>{studentName}</div>
</template>
```

---

## 4. Which file contains JavaScript?
The **`.js`** file contains all logic, Apex calls, wire adapters, and event handlers.
```javascript
import { LightningElement, wire } from 'lwc';
import getStudents from '@salesforce/apex/StudentController.getStudents';

export default class StudentList extends LightningElement {
    @wire(getStudents) students;
}
```

---

## 5. What did you learn today?
- **Apex Integration** — calling server-side Apex methods from LWC using `@wire` and imperative calls
- **`@wire` decorator** — automatically fetching Salesforce data when the component loads
- **Imperative Apex** — manually calling Apex inside event handlers for user-triggered data operations
- **`lightning-datatable`** — displaying records in a professional table with sorting and row actions
- **Error Handling** — using `lwc:if={error}` to show user-friendly error messages when Apex fails
- **`@salesforce/apex`** — the import syntax for bringing Apex methods into JavaScript

---

## Project Structure
```
day6/
└── README.md
```

---
*Salesforce LWC Bootcamp — Vishnu Placement Portal Project*
