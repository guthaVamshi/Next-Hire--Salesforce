trigger Date_Resolved on Service_Request__c (before insert,before update) {
	 List<Service_Request__c> Service =  new List<Service_Request__c>();
    for(Service_Request__c a : trigger.new){
        if(a.Status__c == 'Resolved'){
            a.Date_Resolved__c = system.today();
            
        }else{
            
        }
    }
    insert Service;
    update Service;
}