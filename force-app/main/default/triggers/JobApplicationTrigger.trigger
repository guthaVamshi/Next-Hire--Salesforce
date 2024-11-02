trigger JobApplicationTrigger on Job_Application__c (before insert, After Update) {
    if(Trigger.isUpdate ){
        if(Trigger.isAfter){
            
        }
    }
}