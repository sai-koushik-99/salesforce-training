// ═════════════════════════════════════════════════════════════════════════════
// FILE: studentInfo.js
// PURPOSE: Controller for studentInfo component.
//          Manages student data properties and handles user interactions.
// ═════════════════════════════════════════════════════════════════════════════

// IMPORT: LightningElement is the base class for all LWC components.
// Every LWC component class MUST extend LightningElement to work.
import { LightningElement } from 'lwc';

// ═════════════════════════════════════════════════════════════════════════════
// CLASS DEFINITION
// 'export default' makes this class available to the LWC framework.
// Class name MUST be in camelCase and match the folder name.
// Folder: studentInfo → Class: StudentInfo
// ═════════════════════════════════════════════════════════════════════════════
export default class StudentInfo extends LightningElement {

    // ─────────────────────────────────────────────────────────────────────────
    // REACTIVE PROPERTIES (Component State)
    // These are the "source of truth" for the UI.
    // When any of these values change, the HTML automatically re-renders 
    // to reflect the new values.
    // ─────────────────────────────────────────────────────────────────────────

    // studentName: Stores the student's full name.
    // Bound to {studentName} in HTML using DATA BINDING.
    // Initial value: 'Rahul'
    studentName = 'Rahul';

    // rollNumber: Stores the student's unique roll number.
    // Bound to {rollNumber} in HTML.
    // Initial value: '22B81A0501'
    rollNumber = '22B81A0501';

    // department: Stores the student's academic department.
    // Bound to {department} in HTML.
    // Initial value: 'CSE' (Computer Science Engineering)
    department = 'CSE';

    // isUpdated: Boolean flag that controls visibility of the confirmation badge.
    // Bound to lwc:if={isUpdated} in HTML.
    // false = badge hidden, true = badge visible.
    // Initially false → badge is hidden on page load.
    isUpdated = false;

    // updateMessage: Text displayed inside the confirmation badge.
    // Bound to {updateMessage} in HTML inside lightning-badge.
    // Empty initially because the badge is hidden until button click.
    updateMessage = '';

    // ─────────────────────────────────────────────────────────────────────────
    // LIFECYCLE HOOK: connectedCallback()
    // This method is automatically called by the LWC framework when the 
    // component is inserted into the DOM (like page load or component mount).
    // Use it for: initial data fetching, subscriptions, or setup logic.
    // ─────────────────────────────────────────────────────────────────────────
    connectedCallback() {
        // Component loaded — initial student data ready.
    }

    // ─────────────────────────────────────────────────────────────────────────
    // EVENT HANDLER: handleUpdateInfo()
    // This method is called when the "Update Student Info" button is clicked.
    // Connected via onclick={handleUpdateInfo} in the HTML button element.
    // 
    // Purpose: Simulates updating student data dynamically.
    // In a real app, this would call an Apex method to save to the database.
    // ─────────────────────────────────────────────────────────────────────────
    handleUpdateInfo(event) {

        // Change the student name from 'Rahul' to 'Rahul Kumar'.
        this.studentName = 'Rahul Kumar';

        // Change roll number from '22B81A0501' to '22B81A0502'.
        this.rollNumber = '22B81A0502';

        // Change department from 'CSE' to 'CSE - AI & ML'.
        this.department = 'CSE - AI & ML';

        // Set isUpdated to true → this makes lwc:if={isUpdated} in HTML 
        // evaluate to true, which adds the confirmation badge div to the DOM.
        this.isUpdated = true;

        // Set the confirmation message text that appears in the badge.
        this.updateMessage = '✅ Student information updated successfully!';
    }

    // ─────────────────────────────────────────────────────────────────────────
    // LIFECYCLE HOOK: disconnectedCallback()
    // Called when the component is removed from the DOM.
    // Use for: cleanup tasks like clearing timers, unsubscribing from events.
    // Not required for this component but included as best practice reference.
    // ─────────────────────────────────────────────────────────────────────────
    disconnectedCallback() {
        // Cleanup on component removal.
    }
}

// ═════════════════════════════════════════════════════════════════════════════
// KEY CONCEPT: DATA BINDING IN LWC
// ═════════════════════════════════════════════════════════════════════════════
//
// Data Binding = Linking JavaScript properties to HTML template expressions.
// 
// SYNTAX IN HTML:
// {propertyName} → reads the value of 'propertyName' from this JS class.
//
// HOW IT WORKS:
// 1. JS properties (like studentName) are the "source of truth".
// 2. HTML template expressions (like {studentName}) display those values.
// 3. When JS property changes, LWC's reactivity system detects it.
// 4. The framework automatically re-renders the affected parts of the HTML.
// 5. User sees updated values on screen WITHOUT manual DOM manipulation.
//
// ONE-WAY BINDING:
// LWC uses one-way data binding by default:
// JS → HTML (data flows from JavaScript to the view).
// HTML cannot directly change JS properties unless using event handlers.
//
// EXAMPLE FLOW:
// this.studentName = 'Rahul'  →  HTML shows "Rahul"
// this.studentName = 'Raj'    →  HTML automatically updates to "Raj"
//
// ═════════════════════════════════════════════════════════════════════════════
