import { LightningElement, api } from 'lwc';
import NAME_FIELD from '@salesforce/schema/Student__c.Name';
import EMAIL_FIELD from '@salesforce/schema/Student__c.Email__c';
import BRANCH_FIELD from '@salesforce/schema/Student__c.Branch__c';
import CGPA_FIELD from '@salesforce/schema/Student__c.CGPA__c';
import PLACEMENT_STATUS_FIELD from '@salesforce/schema/Student__c.Placement_Status__c';

export default class StudentProfile extends LightningElement {

    // @api means this value comes from the parent component (studentPortal)
    // Salesforce automatically passes the current record's Id when placed on a Record Page
    @api recordId;

    // This is the list of fields we want to show in the form
    // These match the actual fields that exist on Student__c in your org
    fields = [
        NAME_FIELD,
        EMAIL_FIELD,
        BRANCH_FIELD,
        CGPA_FIELD,
        PLACEMENT_STATUS_FIELD
    ];

    // Runs when the record is saved successfully
    handleSuccess() {
        alert('Profile updated successfully!');
    }

    // Runs when there is an error saving the record
    handleError() {
        alert('Error updating profile. Please check the fields.');
    }
}
