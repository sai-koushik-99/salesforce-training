public class ApexCollection {
    public void myMethod(){
        List<String> li = new List<String>();
        li.add('Hyderabad');
        li.add('Chennai');
        li.add('Delhi');
        li.add('Mumbai');
        li.add('Pune');
        for(String city : li){
            System.debug(city.toUpperCase());
        }
    }
    
    public void mySet(){
        Set<Id> ids = new Set<Id>();

        for(Student__c s : [
            SELECT Id
            FROM Student__c
        ]){
            ids.add(s.Id);
        }
        
        System.debug(ids.size());
    }
    
    
    
    public void myMap(){
        Map<Id, Student__c> studentMap =
        new Map<Id, Student__c>(
        [
        SELECT Id, Name
        FROM Student__c
        ]);
        
        Id sampleId =
        studentMap.keySet().iterator().next();
        
        System.debug(studentMap.get(sampleId).Name);
    }
}