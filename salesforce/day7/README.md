# Salesforce Training — Day 7

## 1. What is LWC?
**LWC (Lightning Web Component)** is Salesforce's modern UI framework built on web standards — HTML, JavaScript (ES6+), and CSS. Every component has three files: `.html` (view), `.js` (logic), and `.js-meta.xml` (config). Components run inside Lightning Experience and use a reactive data model — when a JS property changes, the HTML updates automatically without a page refresh.

---

## 2. What did you build?
On Day 7, we completed the **Placement Management System** — integrating all components together into a full working application with navigation, data persistence, and a polished UI.

---

## 3. Which file contains HTML?
The **`.html`** file contains the UI layout wrapped inside a single `<template>` tag.
```html
<template>
    <lightning-datatable
        data={records}
        columns={columns}
        key-field="id">
    </lightning-datatable>
</template>
```

---

## 4. Which file contains JavaScript?
The **`.js`** file contains all logic, navigation, Apex calls, and state management.
```javascript
import { LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class PlacementApp extends NavigationMixin(LightningElement) {
    navigateToJobs() {
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: { pageName: 'home' }
        });
    }
}
```

---

## 5. What did you learn today?
- **NavigationMixin** — navigating between pages and records programmatically from LWC
- **`lightning-record-form`** — auto-generated forms for creating and editing Salesforce records
- **`lightning-record-view-form`** — displaying record field values without writing HTML manually
- **`getRecord` wire adapter** — fetching a single record's fields using the record ID
- **`getFieldValue`** — reading individual field values from a wired record
- **Component Composition** — building a full app by nesting multiple LWC components together
- **Deployment Best Practices** — organizing components, deploying with SF CLI, and version control with Git

---

## Project Structure
```
day7/
└── README.md
```

---
*Salesforce LWC Bootcamp — Vishnu Placement Portal Project*
