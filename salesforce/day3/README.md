Salesforce Day 3 Notes
Validation Rules, Flows & Triggers
Validation Rule

A Validation Rule is used to validate the data entered by a user before the record is saved. If the validation condition is true, Salesforce prevents the record from being saved and displays an error message.

Purpose
Ensure data quality.
Prevent invalid data from being saved.
Enforce business rules.
Features
Executes before the record is saved.
Displays an error message when the rule is violated.
Uses formulas.
Cannot update field values.
Example

A student should not apply if the CGPA is less than the required CGPA.

Formula:

Student_CGPA__c < Minimum_CGPA__c
Flow

A Flow is a declarative automation tool used to automate business processes without writing Apex code.

Purpose
Update records.
Create records.
Delete records.
Send emails.
Perform calculations.
Call Apex methods.
Advantages
No coding required.
Easy to maintain.
Faster development.
Recommended by Salesforce over Apex whenever possible.
Record-Triggered Flow

A Record-Triggered Flow runs automatically whenever a record is created, updated, or deleted.

There are two types:

Before-Save Flow

Runs before the record is saved.

Used for:

Updating fields on the same record.
Fast field updates.

Example: Automatically set the Application Date.

After-Save Flow

Runs after the record is saved.

Used for:

Creating related records.
Sending emails.
Updating related records.
Calling Apex.

Example: Create an Offer Letter when the application status becomes Selected.

Apex Trigger

An Apex Trigger is Apex code that runs automatically before or after changes are made to Salesforce records.

Trigger Events
Before Insert
Before Update
Before Delete
After Insert
After Update
After Delete
After Undelete
Uses
Complex business logic.
Processing multiple objects.
External API integration.
Bulk data processing.
Difference Between Validation Rule, Flow and Trigger
Validation Rule	Flow	Trigger
Validates data	Automates business processes	Executes Apex code
No coding	No coding	Requires Apex programming
Prevents invalid records	Updates and creates records	Performs complex logic
Cannot update fields	Can update fields	Can update fields
Before-Save Flow vs After-Save Flow
Before-Save Flow	After-Save Flow
Runs before saving the record	Runs after saving the record
Faster	Slightly slower
Updates the current record	Creates related records
Cannot send emails	Can send emails
Used for field updates	Used for automation actions
When to Use Validation Rule

Use Validation Rules when:

Required fields must not be empty.
A date should not exceed another date.
Numeric values should be within a range.
Business rules need to be enforced.
When to Use Flow

Use Flows when:

Automatically update field values.
Create related records.
Send email notifications.
Automate approval processes.
Perform simple business automation.
When to Use Apex Trigger

Use Apex Triggers when:

Business logic is too complex for Flow.
Multiple objects are involved.
External APIs need to be called.
Large amounts of data must be processed efficiently.
