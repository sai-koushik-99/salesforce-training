# Salesforce Training — Day 1

## 1. What is LWC?
**LWC (Lightning Web Component)** is Salesforce's modern UI framework built on web standards — HTML, JavaScript (ES6+), and CSS. Every component has three files: `.html` (view), `.js` (logic), and `.js-meta.xml` (config). Components run inside Lightning Experience and use a reactive data model — when a JS property changes, the HTML updates automatically without a page refresh.

---

## 2. What did you build?
On Day 1, we explored the **Salesforce Platform** — understanding what Salesforce is, how it works, and setting up the development environment for the bootcamp.

---

## 3. Which file contains HTML?
The **`.html`** file contains the UI layout wrapped inside a single `<template>` tag.
```html
<template>
    <h1>Hello Salesforce!</h1>
</template>
```

---

## 4. Which file contains JavaScript?
The **`.js`** file contains all logic, reactive properties, and event handlers.
```javascript
import { LightningElement } from 'lwc';
export default class HelloWorld extends LightningElement {}
```

---

## 5. What did you learn today?
- **What is Salesforce** — A cloud-based CRM (Customer Relationship Management) platform used by businesses to manage sales, service, and marketing
- **Salesforce Editions** — Developer, Professional, Enterprise, Unlimited editions and their differences
- **Salesforce Architecture** — Multi-tenant cloud architecture where all customers share the same infrastructure
- **Key Salesforce Products** — Sales Cloud, Service Cloud, Marketing Cloud, Experience Cloud
- **Developer Org Setup** — Creating a free Salesforce Developer org at developer.salesforce.com
- **Salesforce UI Navigation** — App Launcher, Setup menu, Object Manager, Lightning App Builder
- **Standard vs Custom Objects** — Built-in objects (Account, Contact, Lead) vs objects you create
- **Trailhead** — Salesforce's free learning platform for guided hands-on training

---

## Documents
- `Salesforce_Day1_Documentation.docx` — Full Day 1 notes and documentation

---
*Salesforce LWC Bootcamp — Vishnu Placement Portal Project*
