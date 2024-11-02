@RestResource(UrlMapping = '/getdata/')
global class AccountData {
    @HttpGet
    global static accWrapper getRecords(){
        Map<String,String> parms = RestContext.request.params;
        String indus = parms.get('Industry');
        list<Account> acclist = [Select Id,Name,Active__c,Industry from Account where Industry =: indus];
        list<Id> accid = new List<Id>();
        for(Account a:acclist){
            accid.add(a.Id);
        }
        list<Contact> conlist = [Select Id,FirstName,LastName,Email from Contact where AccountId In:accid];
        list<Case> caselist = [select id,Subject from case where AccountId In:accid];
        accWrapper accwrap = new accWrapper();
        accwrap.acclist = acclist;
        accwrap.conlist = conlist;
        accwrap.caselist = caselist;
        return accwrap;
    }
    global class accwrapper{
        global list<Account> acclist;
        global list<Contact> conlist;
        global list<Case> caselist;
    }
    @HttpPost
    global static Id CreateAccount(String Accname,String Active){
        Account a = new Account();
        a.Name = Accname;
        a.Active__c = Active;
        try{
            insert a;
            return a.Id;
        }catch(Exception ex){
            return ex.getMessage();
        }
    }
}