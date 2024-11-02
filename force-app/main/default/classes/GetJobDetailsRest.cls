@RestResource(UrlMapping = '/getJobDetails/')
global class GetJobDetailsRest {
	@HttpPost
    global static list<Position__c> getjobdetails(Id Jobid){
        list<Position__c> posdata = [select Id,Apex__c, C_Sharp__c, Certifications__c, Close_Date__c, Days_Open__c, 
                                     Educational_Requirements__c, Excel__c, Functional_Area__c, Hire_By__c, Hiring_Manager__c, 
                                     Java__c, JavaScript__c, Job_Description__c, Job_Level__c, Company_Address__c, Max_Pay__c, 
                                     Min_pay__c, Name, Open_Date__c, Power_Point__c, Responsibilities__c, Severity__c, Skills_Required__c, 
                                     Status__c, Team_Building__c, Travel_Required__c, Working_Days__c,Company_Image__c,Question_1__c,Question_2__c,
                                     Question_3__c,Total_No_of_Job_Application__c
                                     from Position__c where Id =:Jobid ];
        return posdata;
    }
}