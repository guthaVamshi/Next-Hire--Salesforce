public class AccountTriggerRatingHandler {
    public static void deletePrevention(list<Account> acclist){
        for(Account acc: acclist){
            if(acc.Active__c == 'Yes'){
                acc.addError(label.Deletion_Prevention_Account);
            }
        }
    }
    public static void updateContactPhone(list<Account> acclist, map<Id,Account> accOldMap){
        for(Account a : acclist){
        if(a.Phone != accOldMap.get(a.Id).Phone){
            list<Contact> conlist = new list<Contact>();
            conlist = [select Id,AccountId,HomePhone from Contact WHERE AccountId= :a.Id];
            for(contact c : conlist){
                c.HomePhone = a.Phone;
            }
            Update conlist;
        }
    }
    }
    public static void AccountRating(list<Account> acclist,map<Id,Account> accOldMap){
        for(Account a:acclist){
            if(accOldMap !=null && a.Industry != accOldMap.get(a.Id).Industry ){
                if(a.Industry == 'Media'){
                    a.Rating='Hot';
                }
            }
            if(a.Industry!=null && a.Industry=='Media'){
                a.Rating='Hot';
            }
        }
    }
    public static void createOpp(list<Account> acclist){
        list<Opportunity> opplist = new List<Opportunity>();
        for(Account a : acclist){
            Opportunity opp = new Opportunity();
            opp.Name = a.Name;
            opp.CloseDate = Date.today();
            opp.StageName='New';
            opp.AccountId = a.Id;
            opplist.add(opp);
        }
        insert opplist;
    }
    public static void updatePhone(list<Account> acclist, map<Id,Account> accoldmap){
        for(Account acc: acclist){
            if(acc.Phone != accoldmap.get(acc.Id).Phone){
                acc.Description = 'Phone Updated form '+ accoldmap.get(acc.Id).phone + ' to ' + acc.Phone;
            }
        }
    }
}