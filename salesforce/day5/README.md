# Salesforce Training — Day 5

## 1. What is LWC?
**LWC (Lightning Web Component)** is Salesforce's modern UI framework built on web standards — HTML, JavaScript (ES6+), and CSS. Every component has three files: `.html` (view), `.js` (logic), and `.js-meta.xml` (config). Components run inside Lightning Experience and use a reactive data model — when a JS property changes, the HTML updates automatically without a page refresh.

---

## 2. What did you build?
On Day 5, we continued building the **Placement Management System** — exploring deeper LWC concepts including component communication, input handling, and conditional rendering patterns.

---

## 3. Which file contains HTML?
The **`.html`** file contains the UI layout wrapped inside a single `<template>` tag.
```html
<template>
    <div>{message}</div>
</template>
```

---

## 4. Which file contains JavaScript?
The **`.js`** file contains all logic, reactive properties, and event handlers.
```javascript
import { LightningElement } from 'lwc';
export default class MyComponent extends LightningElement {
    message = 'Hello from Day 5';
}
```

---

## 5. What did you learn today?
- **Component Input (`@api`)** — passing data from parent to child components using the `@api` decorator
- **User Input Handling** — capturing form input using `onchange` events and `event.target.value`
- **Two-way data flow** — how child components communicate back to parents using custom events (`this.dispatchEvent`)
- **`lwc:if` vs `lwc:elseif` vs `lwc:else`** — handling multiple conditional render states
- **lightning-input** — Salesforce Base Component for text, number, email, date fields

---

## Project Structure
```
day5/
├── README.md
├── Day 5.docx
└── Screenshots/
```

---
*Salesforce LWC Bootcamp — Vishnu Placement Portal Project*
