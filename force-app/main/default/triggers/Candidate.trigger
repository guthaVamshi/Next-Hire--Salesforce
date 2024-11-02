trigger Candidate on Candidate__c (before insert,after update) {
    if(Trigger.isInsert){
        if(Trigger.isBefore){
            CandidateHandler.SendEmail(Trigger.New);
        }
    }
    if(Trigger.isUpdate){
        if(Trigger.isBefore){
            
        }
    }

}