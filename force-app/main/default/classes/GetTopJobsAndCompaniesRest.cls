@RestResource(URLMapping='/GetTopJobs/')
global with sharing class GetTopJobsAndCompaniesRest{
    @HttpGet
    global static List<Position__c> getjobs() {
        List<Position__c> joblist = [SELECT Name,CompnayName__c, Max_Pay__c , Company_Image__c,Company_Address__c
                                        FROM Position__c 
                                        WHERE Max_Pay__c != NULL AND Max_Pay__c > 0 
                                        ORDER BY Max_Pay__c DESC 
                                        LIMIT 10];
        return joblist;
    }
}

