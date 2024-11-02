@RestResource (URLMapping='/CreateCandidate/')
global class CreateCandidateRest {
    
    @HttpPost
    global static String CreateCandidate(String firstName, String lastName, String phone, String email, String currentEmployer, Boolean currentlyEmployed, Boolean usCitizen, Boolean sponsorshipNeeded,Id UserId) {
        Map<String, String> response = new Map<String, String>();
    Candidate__c newcan = new Candidate__c();
     	newcan.First_Name__c=firstName;
        newcan.Last_Name__c = lastName;
        newcan.Phone__c = phone;
        newcan.Email__c = email;
        newcan.Current_Employeer__c = currentEmployer;
        newcan.Currently_Emoloyed__c = currentlyEmployed;
        newcan.US_Citizen__c = usCitizen;
        newcan.Visa_Required__c = sponsorshipNeeded;
		newcan.Users__c = UserId;
        insert newcan;
        response.put('CandidateId', newcan.id);
        return JSON.serialize(response);
}


}