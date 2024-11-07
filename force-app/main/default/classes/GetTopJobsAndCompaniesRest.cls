@RestResource(URLMapping='/GetTopJobs/')
global with sharing class GetTopJobsAndCompaniesRest {
    
    global class JobWrapper {
        public String companyName;
        public String name;
        public Decimal maxPay;
        public String companyImage;
        public String companyAddress;
        
        public JobWrapper(AggregateResult ar) {
            this.companyName = (String)ar.get('CompnayName__c');
            this.name = (String)ar.get('Name');
            this.maxPay = (Decimal)ar.get('Max_Pay__c');
            this.companyImage = (String)ar.get('Company_Image__c');
            this.companyAddress = (String)ar.get('Company_Address__c');
        }
    }

    @HttpGet
    global static List<JobWrapper> getjobs() {
        List<AggregateResult> aggregateResults = [
            SELECT CompnayName__c, 
                   MAX(Name) Name, 
                   MAX(Max_Pay__c) Max_Pay__c, 
                   MAX(Company_Image__c) Company_Image__c, 
                   MAX(Company_Address__c) Company_Address__c
            FROM Position__c 
            WHERE Max_Pay__c != NULL AND Max_Pay__c > 0 AND CompnayName__c != NULL
            GROUP BY CompnayName__c
            ORDER BY MAX(Max_Pay__c) DESC 
            LIMIT 10
        ];

        List<JobWrapper> jobWrappers = new List<JobWrapper>();
        for(AggregateResult ar : aggregateResults) {
            jobWrappers.add(new JobWrapper(ar));
        }

        return jobWrappers;
    }
}