trigger PositonTrigger on Position__c (before insert) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            for(Position__c pos : Trigger.new){
                pos.Source__c = 'Recruter';
            }
        }
    }
}