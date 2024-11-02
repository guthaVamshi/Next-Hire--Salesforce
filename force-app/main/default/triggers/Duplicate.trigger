trigger Duplicate on Account (before insert) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            AccountDuplicateHandler.NoDuplicate(Trigger.new);
        }
    }
}