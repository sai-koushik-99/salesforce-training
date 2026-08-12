import { LightningElement, api } from 'lwc';

export default class StudentPortal extends LightningElement {

    // @api recordId is automatically given by Salesforce when this component
    // is placed on a Lightning Record Page
    // The parent then passes this down to studentProfile using record-id={recordId}
    @api recordId;
}
