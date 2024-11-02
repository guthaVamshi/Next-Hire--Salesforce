trigger PositionCreate on Position__c (before insert,after insert) {
    if(Trigger.isInsert){
        if(Trigger.isBefore){
            PositionCreateHandler.addPositionDetails(Trigger.New);
        }else if(Trigger.isAfter){
            PositionCreateHandler.createTask(Trigger.New);
        }
    }
}