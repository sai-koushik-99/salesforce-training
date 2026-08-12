import { LightningElement } from 'lwc';

export default class EligibleJobs extends LightningElement {

    // Hardcoded job data — no Apex needed for now
    // Later you can replace this with a @wire call to an Apex method
    jobs = [
        {
            Id: '1',
            Name: 'Salesforce Developer',
            Company__c: 'ABC Company',
            Minimum_CGPA__c: 7.0
        },
        {
            Id: '2',
            Name: 'Software Developer',
            Company__c: 'XYZ Company',
            Minimum_CGPA__c: 7.5
        }
    ];

    // get hasJobs is a getter — it computes a value based on the jobs array
    // if jobs has items → returns true → if:true block shows
    // if jobs is empty → returns false → if:false block shows (EmptyState)
    get hasJobs() {
        return this.jobs && this.jobs.length > 0;
    }

    // This runs when a JobCard child fires the 'apply' CustomEvent
    // onapply={handleApply} in the HTML connects them
    handleApply(event) {
        alert('Apply button clicked!');
    }

    // This runs when a JobCard child fires the 'view' CustomEvent
    // onview={handleView} in the HTML connects them
    handleView(event) {
        alert('View Details clicked!');
    }
}
