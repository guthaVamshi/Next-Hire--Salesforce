trigger Accounts_Default_Plan on Acount__c (before insert, before update) {
   
    	Plan__c oPlan = [Select Id, Name from Plan__C where Id ='a025g000004tjYGAAY'];
  
    for(Acount__c Acc : Trigger.New){
       Acc.Plan1__c = oPlan.Id;
    }
    
}