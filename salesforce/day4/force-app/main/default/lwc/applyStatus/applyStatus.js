// ═════════════════════════════════════════════════════════════════════════════
// FILE    : applyStatus.js
// PURPOSE : Controller for applyStatus component.
//           Manages status toggle using ONLY JavaScript reactive properties.
//           No Apex. No Salesforce Database. Pure client-side JS.
// ═════════════════════════════════════════════════════════════════════════════

// IMPORT: LightningElement — the base class every LWC must extend.
import { LightningElement } from 'lwc';

export default class ApplyStatus extends LightningElement {

    // =========================================================================
    // REACTIVE PROPERTIES — THE ONLY "DATABASE" WE NEED
    // =========================================================================
    // These JavaScript class properties hold the component's current state.
    // They are "reactive" — meaning whenever their value changes,
    // the LWC framework automatically re-renders the HTML template.
    // No manual DOM update. No page refresh. It just works.
    // =========================================================================

    // statusText: The status value displayed in the HTML.
    // Bound to {statusText} in the HTML template.
    // Initial value → "Not Applied" (shown on page load).
    // After Apply click → changes to "Applied".
    statusText = 'Not Applied';

    // statusStyle: Inline CSS style string bound to style={statusStyle} in HTML.
    // Controls the COLOR of the status text dynamically.
    // Initial → red text for "Not Applied".
    // After Apply → green text for "Applied".
    // Inline style binding in LWC: style={propertyName} where property 
    // must return a valid CSS string like "color: red; font-weight: bold;"
    statusStyle = 'color: red; font-weight: bold; font-size: 1.2rem;';

    // showApplyButton: Boolean that controls visibility of the "Apply" button.
    // Bound to lwc:if={showApplyButton} in HTML.
    // true  → "Apply" button is in the DOM and visible (initial state).
    // false → "Apply" button is removed from the DOM (after click).
    showApplyButton = true;

    // showSuccessMessage: Boolean that controls visibility of the success box.
    // Bound to lwc:if={showSuccessMessage} in HTML.
    // false → success box hidden (initial state).
    // true  → success box appears (after Apply click).
    showSuccessMessage = false;

    // successMessage: Text shown inside the green success box after applying.
    // Bound to {successMessage} in HTML.
    successMessage = '🎉 You have successfully applied! Good luck.';

    // =========================================================================
    // LIFECYCLE HOOK: connectedCallback()
    // Runs automatically when the component is mounted into the DOM.
    // =========================================================================
    connectedCallback() {
        // Component loaded — initial status ready.
    }

    // =========================================================================
    // EVENT HANDLER: handleApply()
    // Connected to: onclick={handleApply} on the "Apply" button in HTML.
    // Triggered: When user clicks the "Apply" button.
    //
    // PURPOSE: Changes all reactive properties to reflect "Applied" state.
    //
    // HOW UI UPDATES AUTOMATICALLY (Reactive System):
    // ─────────────────────────────────────────────────────────────────────────
    // 1. User clicks "Apply" button.
    // 2. Browser fires 'click' event → LWC calls handleApply(event).
    // 3. Inside this method, we update reactive properties:
    //      this.statusText = 'Applied'          ← new value assigned
    //      this.statusStyle = 'color: green...' ← new value assigned
    //      this.showApplyButton = false          ← new value assigned
    //      this.showSuccessMessage = true        ← new value assigned
    // 4. LWC's reactivity engine detects each property change.
    // 5. Framework schedules a re-render of the HTML template.
    // 6. In the re-rendered HTML:
    //      {statusText}         → now shows "Applied" (was "Not Applied")
    //      {statusStyle}        → now green color (was red)
    //      lwc:if={showApplyButton}     → false → button REMOVED from DOM
    //      lwc:if={showSuccessMessage}  → true  → success box ADDED to DOM
    // 7. User sees all changes instantly — no page reload needed.
    // ─────────────────────────────────────────────────────────────────────────
    handleApply(event) {
        // Update all reactive properties — LWC re-renders automatically.
        this.statusText = 'Applied';
        this.statusStyle = 'color: green; font-weight: bold; font-size: 1.2rem;';
        this.showApplyButton = false;
        this.showSuccessMessage = true;
    }

    // =========================================================================
    // EVENT HANDLER: handleReset()
    // Connected to: onclick={handleReset} on the "Reset Status" button in HTML.
    // Triggered: When user clicks "Reset Status" after applying.
    //
    // PURPOSE: Resets all properties back to their initial values,
    //          returning the component to "Not Applied" state.
    // =========================================================================
    handleReset(event) {
        // Reset all properties back to initial "Not Applied" state.
        this.statusText = 'Not Applied';
        this.statusStyle = 'color: red; font-weight: bold; font-size: 1.2rem;';
        this.showApplyButton = true;
        this.showSuccessMessage = false;
    }

    // =========================================================================
    // LIFECYCLE HOOK: disconnectedCallback()
    // Runs when the component is removed from the DOM (cleanup).
    // =========================================================================
    disconnectedCallback() {
        // Cleanup on component removal.
    }
}

// =============================================================================
// HOW REACTIVE PROPERTIES UPDATE THE UI — DEEP EXPLANATION
// =============================================================================
//
// WHAT IS A REACTIVE PROPERTY?
// A property defined directly on a LWC class (without any decorator for 
// primitives like string/boolean/number) is reactive by default.
// This means LWC "watches" it. When its value changes, the framework 
// automatically triggers a re-render of the HTML template.
//
// THE RENDER CYCLE:
//
//   Initial Load:
//   ┌─────────────────────────────────────────────┐
//   │ JS properties set with initial values        │
//   │   statusText      = 'Not Applied'            │
//   │   showApplyButton = true                     │
//   │   showSuccessMessage = false                 │
//   └──────────────────────┬──────────────────────┘
//                          │ LWC renders HTML
//                          ▼
//   ┌─────────────────────────────────────────────┐
//   │ HTML shows:                                  │
//   │   Status: Not Applied (red)                  │
//   │   [Apply] button visible                     │
//   │   Success box hidden                         │
//   └─────────────────────────────────────────────┘
//
//   After Apply click:
//   ┌─────────────────────────────────────────────┐
//   │ handleApply() runs — properties updated:     │
//   │   statusText      = 'Applied'                │
//   │   showApplyButton = false                    │
//   │   showSuccessMessage = true                  │
//   └──────────────────────┬──────────────────────┘
//                          │ LWC detects changes → re-renders
//                          ▼
//   ┌─────────────────────────────────────────────┐
//   │ HTML shows:                                  │
//   │   Status: Applied (green)                    │
//   │   [Apply] button GONE (removed from DOM)     │
//   │   Success box VISIBLE                        │
//   └─────────────────────────────────────────────┘
//
// KEY POINT: You NEVER manually update the DOM.
// You only update JavaScript properties.
// LWC handles the rest automatically.
//
// =============================================================================
