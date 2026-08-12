import { LightningElement, api } from 'lwc';

export default class EmptyState extends LightningElement {

    // @api means the parent passes these values in when using this component
    // This makes EmptyState reusable — any parent can pass different title/message
    @api title;
    @api message;
    @api actionLabel;

    handleClick() {
        // Tell the parent that the action button was clicked
        this.dispatchEvent(new CustomEvent('action'));
    }
}
