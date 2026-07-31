// ═════════════════════════════════════════════════════════════════════════════
// FILE    : welcomeMessage.js
// PURPOSE : Controller for the welcomeMessage LWC component.
//           Manages visibility state and handles button click events.
// CONCEPT : Event Handling — how onclick connects HTML buttons to JS methods.
// ═════════════════════════════════════════════════════════════════════════════

// IMPORT: LightningElement is the base class all LWC components must extend.
// It gives access to the DOM, lifecycle hooks, and the LWC framework features.
import { LightningElement } from 'lwc';

// ─────────────────────────────────────────────────────────────────────────────
// HOW EVENT HANDLING WORKS IN LWC (Overview)
// ─────────────────────────────────────────────────────────────────────────────
// 
// STEP 1 — HTML registers the event:
//   <lightning-button onclick={handleShowMessage}>
//   'onclick' is the event type (fires on mouse click).
//   '{handleShowMessage}' points to the JS method to run.
//
// STEP 2 — User clicks the button:
//   The browser fires the native 'click' event on the element.
//
// STEP 3 — LWC routes the event to the JS method:
//   The LWC framework automatically calls handleShowMessage(event)
//   in this class, passing an Event object as the argument.
//
// STEP 4 — JS method runs and updates properties:
//   this.isMessageVisible = true;
//
// STEP 5 — LWC reactive system detects the change:
//   The HTML template re-renders and shows the welcome message.
//
// Result: User sees "Welcome to Salesforce Development." on screen.
// ─────────────────────────────────────────────────────────────────────────────

export default class WelcomeMessage extends LightningElement {

    // ─────────────────────────────────────────────────────────────────────────
    // REACTIVE PROPERTIES
    // These are the "source of truth" that the HTML template reads from.
    // Changing any of these automatically updates the UI.
    // ─────────────────────────────────────────────────────────────────────────

    // isMessageVisible: Controls whether the welcome message block is shown.
    // Used with lwc:if={isMessageVisible} in the HTML.
    // false → message hidden (initial state on page load).
    // true  → message visible (after button click).
    isMessageVisible = false;

    // welcomeText: The actual welcome message string to display.
    // Bound to {welcomeText} in the HTML template.
    // Set here in JS so it can be changed dynamically if needed.
    welcomeText = 'Welcome to Salesforce Development.';

    // ─────────────────────────────────────────────────────────────────────────
    // LIFECYCLE HOOK: connectedCallback()
    // Runs automatically when the component is added to the DOM (page load).
    // Use for: initialization, API calls, subscriptions.
    // ─────────────────────────────────────────────────────────────────────────
    connectedCallback() {
        // Component loaded — visibility state initialized.
    }

    // ─────────────────────────────────────────────────────────────────────────
    // EVENT HANDLER: handleShowMessage()
    //
    // CONNECTED TO: onclick={handleShowMessage} on the "Show Welcome Message" 
    //               button in welcomeMessage.html.
    //
    // WHEN CALLED: Every time the user clicks the "Show Welcome Message" button.
    //
    // PARAMETER:
    //   event → The browser Event object passed automatically by the framework.
    //           Contains info like: event.target (element clicked),
    //           event.type (type of event = "click"), mouse coordinates, etc.
    //           You don't have to use 'event' but always include it as best practice.
    //
    // PURPOSE: Sets isMessageVisible to true → shows the welcome message in HTML.
    // ─────────────────────────────────────────────────────────────────────────
    handleShowMessage(event) {
        // Update reactive property — LWC re-renders HTML automatically.
        this.isMessageVisible = true;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // EVENT HANDLER: handleHideMessage()
    //
    // CONNECTED TO: onclick={handleHideMessage} on the "Hide Message" 
    //               button in welcomeMessage.html.
    //
    // WHEN CALLED: When the user clicks the "Hide Message" button.
    //
    // PURPOSE: Sets isMessageVisible back to false → hides the welcome message.
    //          Also hides the "Hide Message" button itself (since it uses same flag).
    // ─────────────────────────────────────────────────────────────────────────
    handleHideMessage(event) {
        // Reset visibility — message removed from DOM.
        this.isMessageVisible = false;
    }

    // ─────────────────────────────────────────────────────────────────────────
    // LIFECYCLE HOOK: disconnectedCallback()
    // Runs when the component is removed from the DOM.
    // Use for: cleanup — clearing timers, unsubscribing from events.
    // ─────────────────────────────────────────────────────────────────────────
    disconnectedCallback() {
        // Cleanup on component removal.
    }
}

// ═════════════════════════════════════════════════════════════════════════════
// SUMMARY: EVENT HANDLING BEST PRACTICES IN LWC
// ═════════════════════════════════════════════════════════════════════════════
//
// ✅ DO:
//   - Always prefix event handler method names with 'handle'
//     (handleSave, handleClick, handleSubmit) — makes code readable.
//   - Include the 'event' parameter even if unused — future-proofing.
//   - Keep handlers focused on ONE task — delegate logic to helper methods.
//   - Log event.type and event.target during development for debugging.
//   - Use lwc:if to show/hide UI based on event results — not CSS display:none.
//
// ❌ DON'T:
//   - Don't put complex business logic inside event handlers.
//     Call a separate method for logic and keep the handler as a thin bridge.
//   - Don't use addEventListener() inside event handlers.
//     LWC handles event delegation automatically.
//   - Don't manipulate the DOM directly (no document.querySelector in LWC).
//     Always use reactive properties and let the framework update the DOM.
//   - Don't forget that lwc:if REMOVES elements from DOM 
//     vs CSS visibility:hidden which just hides them visually.
//
// ═════════════════════════════════════════════════════════════════════════════
