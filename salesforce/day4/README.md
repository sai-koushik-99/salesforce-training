# Salesforce LWC Training — Day 4

> Lightning Web Components built during Salesforce bootcamp training.

---

## 1. What is LWC?

**LWC (Lightning Web Component)** is a modern UI framework built by Salesforce for creating fast, reusable components on the Salesforce platform.

- Built on **web standards** — HTML, JavaScript (ES6+), and CSS
- Every component has three files: `.html`, `.js`, and `.js-meta.xml`
- Components run inside the **Lightning Experience** (Salesforce UI)
- Uses a **reactive data model** — when a JavaScript property changes, the HTML updates automatically
- No page refresh needed — changes happen instantly in the browser

---

## 2. What Did You Build?

Five Lightning Web Components were built during Day 4:

| Component | Purpose |
|-----------|---------|
| `placementHome` | Welcome screen for the Placement Portal with a "Get Started" button |
| `studentInfo` | Displays student name, roll number, and department using data binding |
| `welcomeMessage` | Shows a welcome message when a button is clicked (event handling demo) |
| `applyStatus` | Toggles status between "Not Applied" and "Applied" using reactive properties |
| `placementDashboard` | Full dashboard UI with stat cards, date, welcome banner, and quick actions |

All components were deployed to a **Salesforce Developer Org** using the Salesforce CLI.

---

## 3. Which File Contains HTML?

The **`.html`** file contains the UI layout of the component.

**Example:** `placementHome.html`

```html
<template>
    <div class="slds-card">
        <h1>{welcomeMessage}</h1>
        <lightning-button label="Get Started" variant="brand" onclick={handleGetStarted}>
        </lightning-button>
    </div>
</template>
```

**Key rules:**
- Every LWC HTML file must have exactly **one root `<template>` tag**
- Data binding uses `{propertyName}` syntax — reads values from the JS file
- Event binding uses `onclick={methodName}` to connect buttons to JS methods
- Conditional rendering uses `lwc:if={booleanProperty}` to show/hide elements

---

## 4. Which File Contains JavaScript?

The **`.js`** file contains the logic and state management of the component.

**Example:** `placementHome.js`

```javascript
import { LightningElement } from 'lwc';

export default class PlacementHome extends LightningElement {

    // Reactive property — bound to {welcomeMessage} in HTML
    welcomeMessage = 'Welcome to Vishnu Placement Portal';

    showMessage = false;
    statusMessage = '';

    // Called when "Get Started" button is clicked
    handleGetStarted(event) {
        this.showMessage = true;
        this.statusMessage = '🎉 Welcome! Redirecting to opportunities...';
    }
}
```

**Key rules:**
- Must `import { LightningElement } from 'lwc'`
- Class must `extend LightningElement`
- Class name must match the folder name in camelCase
- Primitive properties (string, boolean, number) are **reactive by default**

---

## 5. What Did You Learn Today?

### ✅ LWC Component Structure
Every LWC component is a folder with three files:
```
componentName/
├── componentName.html        ← View (what user sees)
├── componentName.js          ← Controller (logic)
└── componentName.js-meta.xml ← Config (where it can be used)
```

### ✅ Data Binding
Connecting JavaScript properties to HTML using `{propertyName}`:
```javascript
// JS
studentName = 'Rahul';
```
```html
<!-- HTML — displays "Rahul" automatically -->
<span>{studentName}</span>
```

### ✅ Event Handling
Connecting button clicks to JavaScript methods using `onclick`:
```html
<lightning-button onclick={handleApply}></lightning-button>
```
```javascript
handleApply(event) {
    this.statusText = 'Applied'; // UI updates automatically
}
```

### ✅ Reactive Properties
When a JavaScript property value changes, the HTML re-renders automatically — no manual DOM manipulation needed.

### ✅ Conditional Rendering
Show or hide elements based on a boolean property:
```html
<div lwc:if={showMessage}>
    This only appears when showMessage = true
</div>
```

### ✅ Salesforce CLI Deployment
Deploying components from VS Code to a Salesforce org:
```bash
sf org login web --alias myOrg
sf project deploy start --source-dir force-app/main/default/lwc
```

### ✅ SLDS (Salesforce Lightning Design System)
Using Salesforce's built-in CSS utility classes for layout and styling:
- `slds-grid` → flexbox row layout
- `slds-col` → flex column
- `slds-p-around_medium` → padding
- `slds-text-heading_large` → heading style

---

## Project Structure

```
day 4/
├── force-app/
│   └── main/
│       └── default/
│           └── lwc/
│               ├── placementHome/
│               │   ├── placementHome.html
│               │   ├── placementHome.js
│               │   └── placementHome.js-meta.xml
│               ├── studentInfo/
│               │   ├── studentInfo.html
│               │   ├── studentInfo.js
│               │   └── studentInfo.js-meta.xml
│               ├── welcomeMessage/
│               │   ├── welcomeMessage.html
│               │   ├── welcomeMessage.js
│               │   └── welcomeMessage.js-meta.xml
│               ├── applyStatus/
│               │   ├── applyStatus.html
│               │   ├── applyStatus.js
│               │   └── applyStatus.js-meta.xml
│               └── placementDashboard/
│                   ├── placementDashboard.html
│                   ├── placementDashboard.js
│                   ├── placementDashboard.css
│                   └── placementDashboard.js-meta.xml
├── sfdx-project.json
└── README.md
```

---

## Tech Stack

| Tool | Purpose |
|------|---------|
| Salesforce LWC | UI framework |
| Salesforce CLI (`sf`) | Deploy components to org |
| SLDS | Salesforce design system / CSS |
| VS Code | Code editor |
| GitHub | Version control |

---

*Built during Salesforce LWC Bootcamp — Vishnu Placement Portal Project*
