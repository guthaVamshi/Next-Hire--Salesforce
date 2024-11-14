@RestResource(URLMapping='/Auth/')
global class LoginFunctionalityRest {
    @HttpGet
    global static String GetAuth() {
        Map<String,String> parms = RestContext.request.params;
        String User = parms.get('Username');
        String pass = parms.get('Password');
        Map<String, String> response = new Map<String, String>();

        List<Users__c> AuthUser = [SELECT UserName__c, Password__c, Id 
                                   FROM Users__c 
                                   WHERE UserName__c = :User 
                                   AND Password__c = :pass];

        if (!AuthUser.isEmpty()) {
            Id AuthUserId = AuthUser[0].Id;
            List<Candidate__c> CandidateUser = [SELECT Id, Users__c, First_Name__c 
                                                FROM Candidate__c 
                                                WHERE Users__c = :AuthUserId];
            if (!CandidateUser.isEmpty()) {
                response.put('CandidateId', CandidateUser[0].Id);
            }
            response.put('ResString', 'Auth Success');
            response.put('Id', AuthUser[0].Id);
            response.put('Username', AuthUser[0].UserName__c);
        } else {
            response.put('ResString', 'failed');
        }

        return JSON.serialize(response);
    }
}