// ─────────────────────────────────────────────────────────────────────────────
// FILE: placementHome.js
// PURPOSE: Controller for placementHome component.
//          Manages properties, handles user interactions, and lifecycle events.
// ─────────────────────────────────────────────────────────────────────────────

// LightningElement → base class every LWC component must extend.
// Provides access to DOM, lifecycle hooks, and LWC framework features.
import { LightningElement } from 'lwc';

// export default → makes this class available to the LWC framework.
// Class name MUST match the folder name in camelCase: placementHome → PlacementHome
export default class PlacementHome extends LightningElement {

    // ─────────────────────────────────────────────────────────────────────────
    // PROPERTIES (Component State)
    // Primitive properties are reactive by default — HTML auto-updates on change.
    // ─────────────────────────────────────────────────────────────────────────

    // Bound to {welcomeMessage} in HTML → displays as the main heading.
    welcomeMessage = 'Welcome to Vishnu Placement Portal';

    // Controls visibility of the confirmation badge via lwc:if={showMessage}.
    // false = badge hidden on initial load.
    showMessage = false;

    // Text displayed inside the lightning-badge after button click.
    statusMessage = '';

    // ─────────────────────────────────────────────────────────────────────────
    // LIFECYCLE HOOK: connectedCallback()
    // Fires automatically when the component is inserted into the DOM.
    // Use for: initial data fetch, subscriptions, setup logic.
    // ─────────────────────────────────────────────────────────────────────────
    connectedCallback() {
        // Component loaded — no logs in production.
    }

    // ─────────────────────────────────────────────────────────────────────────
    // EVENT HANDLER: handleGetStarted()
    // Called when the "Get Started" button is clicked (onclick={handleGetStarted}).
    // 'event' → browser click event object (passed automatically).
    // ─────────────────────────────────────────────────────────────────────────
    handleGetStarted(event) {
        // Set showMessage = true → lwc:if={showMessage} in HTML evaluates to true
        // → the badge <div> is added to the DOM and becomes visible.
        this.showMessage = true;

        // Update statusMessage → lightning-badge label in HTML updates automatically
        // because statusMessage is a reactive property.
        this.statusMessage = '🎉 Welcome! Redirecting to opportunities...';
    }

    // ─────────────────────────────────────────────────────────────────────────
    // LIFECYCLE HOOK: disconnectedCallback()
    // Fires when the component is removed from the DOM.
    // Use for: clearing timers, unsubscribing from platform events, cleanup.
    // ─────────────────────────────────────────────────────────────────────────
    disconnectedCallback() {
        // Cleanup on component removal.
    }
}
