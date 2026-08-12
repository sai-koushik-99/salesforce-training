public class StudentFuture {

    @future
    public static void updateStudent(Id studentId){

        Student__c s = [
            SELECT Id, Name
            FROM Student__c
            WHERE Id = :studentId
            LIMIT 1
        ];

        s.Name = s.Name + ' Updated';

        update s;
    }
}