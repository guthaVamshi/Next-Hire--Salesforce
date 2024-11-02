trigger Date_Setup on Service_Request__c (before insert,after insert) {
   
    if(Trigger.isbefore){
         List<Service_Request__c> Service =  new List<Service_Request__c>();
    for(Service_Request__c a : trigger.new){
        a.Date_Created__c = system.today();
    }
    insert Service;
    }
   
	
}