@RestResource(urlMapping='/AppliedJobs')
global with sharing class AppliedJobs {
    
    @HttpPost
    global static list<Job_Application__c> getAppliedJobs(Id candidateId) {
       
            list<Job_Application__c> jobApplied = [SELECT Candidate__r.First_Name__c, Candidate__r.Last_Name__c, 
                                                    Position__r.Name, Status__c ,Position__r.Type__c,Position__r.Functional_Area__c,
                                                   Position__r.Company_Image__c,
                                                   Position__r.Company_Address__c
                                                    FROM Job_Application__c 
                                                    WHERE Candidate__c = :candidateId];
            return jobApplied;
      
    }
}