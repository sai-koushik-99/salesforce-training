trigger BadTrigger on Student__c (after insert) {

    Set<Id> ids = new Set<Id>();

    for(Student__c s : Trigger.new){
        ids.add(s.Id);
    }

    Map<Id, Student__c> mapStudents =
        new Map<Id, Student__c>(
            [SELECT Id, Name
             FROM Student__c
             WHERE Id IN :ids]
        );

    System.debug(mapStudents.size());
}