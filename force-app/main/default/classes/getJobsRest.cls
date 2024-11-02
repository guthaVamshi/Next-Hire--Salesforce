@RestResource(URLMapping = '/getJobs/')
global class getJobsRest {

    @Httpget
    global static list<Position__c> getjobs(){
        list<	Position__c> positionlist = [Select Name,Job_Level__c,Company_Address__c,Open_Date__c,Company_Image__c from Position__c];
        return positionlist;
    }
}