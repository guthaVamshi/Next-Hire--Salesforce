trigger AccountRating on Account (before insert, after insert,before update,after update,before delete) {
    if(trigger.isInsert){
        if(Trigger.isBefore){
            AccountTriggerRatingHandler.AccountRating(Trigger.New,null);
        }else if(Trigger.isAfter){
            AccountTriggerRatingHandler.createOpp(Trigger.New);
        }
    }
    if(trigger.isUpdate){
        if(Trigger.isBefore){
            AccountTriggerRatingHandler.updatePhone(Trigger.new, Trigger.oldMap);
            AccountTriggerRatingHandler.AccountRating(Trigger.New,Trigger.oldMap);
        }else if(Trigger.isAfter){
            AccountTriggerRatingHandler.updateContactPhone(Trigger.New, Trigger.oldMap);
        }
    }
   
    if(trigger.isDelete){
        if(Trigger.isBefore){
            AccountTriggerRatingHandler.deletePrevention(trigger.old);
        }else if(Trigger.isAfter){
           
        }
    }
}