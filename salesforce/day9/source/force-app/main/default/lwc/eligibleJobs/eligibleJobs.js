import { LightningElement } from 'lwc';

export default class EligibleJobs extends LightningElement {
    isLoading = false;
    errorMessage;

    jobs = [
        {
            id: 1,
            company: 'Microsoft',
            role: 'Software Engineer',
            packageOffered: '12 LPA',
            location: 'Hyderabad',
            deadline: '18 August'
        },
        {
            id: 2,
            company: 'Infosys',
            role: 'Software Developer',
            packageOffered: '6 LPA',
            location: 'Bengaluru',
            deadline: '21 August'
        },
        {
            id: 3,
            company: 'TCS',
            role: 'Associate Developer',
            packageOffered: '7 LPA',
            location: 'Chennai',
            deadline: '25 August'
        }
    ];

    get hasJobs() {
        return this.jobs.length > 0;
    }

    handleViewDetails(event) {
        const company = event.target.dataset.company;
        const role = event.target.dataset.role;
        alert('Company: ' + company + '\nRole: ' + role);
    }
}
