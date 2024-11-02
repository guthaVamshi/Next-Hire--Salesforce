public class PositionCreateHandler {
    public static void addPositionDetails(list<Position__c> poslist){
        for(Position__c po : poslist){
            if(po.Status__c =='New Position' && 	po.Open_Date__c == null && po.Min_pay__c == null && 	po.Max_Pay__c ==null){
                po.Open_Date__c = Date.today();
                po.Min_pay__c = 1000.00;
                po.Max_Pay__c = 15000.00;
            }
        }
    }
    public static void createTask(list<Position__c> poslist){
        list<Task> taslist = new list<Task>();
        for(Position__c po : poslist){
            if(po.Status__c == 'New Position'){
                Task tas = new Task();
                tas.OwnerId = '0055g00000HEkCMAA1';
                tas.Priority = 'Normal';
                tas.Status = 'Not Started';
                tas.Subject = 'Email';
                taslist.add(tas);
            }
            if(!taslist.isEmpty()){
                insert taslist;
            }
            
        }
    }
    public static void updatePhone(list<Account> acclist, map<Id,Account> accoldmap){
        for(Account acc: acclist){
            if(acc.Phone != accoldmap.get(acc.Id).Phone){
                acc.Description = 'Phone Updated form '+ accoldmap.get(acc.Id).phone + ' to ' + acc.Phone;
            }
        }
    }
}