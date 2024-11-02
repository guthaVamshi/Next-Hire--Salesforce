@RestResource(urlMapping='/externalJobs')
global with sharing class ExternalJobResource {

    @HttpGet
    global static String getExternalJobs() {
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        HttpResponse res;
        String url = 'https://devitjobs.com/api/jobsLight?utm_source=apislist.com';
        req.setEndpoint(url);
        req.setMethod('GET');

        try {
            res = http.send(req);
            if (res.getStatusCode() == 200) {
                List<Object> jobsList;
                try {
                    jobsList = (List<Object>) JSON.deserializeUntyped(res.getBody());
                } catch (Exception e) {
                    return 'Error deserializing the response: ' + e.getMessage();
                }

                if (jobsList != null && !jobsList.isEmpty()) {
                    List<Position__c> positionsToInsert = new List<Position__c>();
                    Set<String> jobIds = new Set<String>();

                    
                    for (Object jobObj : jobsList) {
                        Map<String, Object> jobDetails = (Map<String, Object>) jobObj;
                        String jobId = (String) jobDetails.get('_id');
                        jobIds.add(jobId);
                    }

                    
                    Map<String, Position__c> existingPositionsMap = new Map<String, Position__c>();
                    for (Position__c position : [SELECT Id, Job_Id__c FROM Position__c WHERE Job_Id__c IN :jobIds]) {
                        existingPositionsMap.put(position.Job_Id__c.toLowerCase(), position); // Store in lowercase
                    }

                    
                    for (Object jobObj : jobsList) {
                        Map<String, Object> jobDetails = (Map<String, Object>) jobObj;
                        String jobTitle;
                        String jobId = ((String) jobDetails.get('_id')).toLowerCase(); 
                        String JobLength = (String) jobDetails.get('name');
                        if (JobLength.length() > 80) {
                            jobTitle = JobLength.substring(0, 80);
                        } else {
                            jobTitle = JobLength;
                        }
                       
                        String company = (String) jobDetails.get('company');
                        String description = (String) jobDetails.get('description');
                        String logoImg = (String) jobDetails.get('logoImg');
                        String employmentType = (String) jobDetails.get('jobType');
                        String address = (String) jobDetails.get('address') + ' '+(String) jobDetails.get('actualCity')+ ' ' + (String) jobDetails.get('postalCode');
                        Decimal annualSalaryFrom = (Decimal) jobDetails.get('annualSalaryFrom');
                        Decimal annualSalaryTo = (Decimal) jobDetails.get('annualSalaryTo');

                        
                        List<Object> perkKeysList = (List<Object>) jobDetails.get('perkKeys');
                        List<String> perkKeys = new List<String>();
                        for (Object perk : perkKeysList) {
                            perkKeys.add((String) perk);
                        }
                        list<Object> technoligieslist = (List<object>)jobDetails.get('technologies');
                        list<String> technoligies = new list<String>();
                        for(Object tech: technoligieslist){
                            technoligies.add((String)tech);
                        }
                        list<Object> AdditionalTech = (List<Object>) jobDetails.get('filterTags');
                        list<String> Addtechnoligies = new list<String>();
                        for(Object Additech: AdditionalTech){
                            Addtechnoligies.add((String)Additech);
                        }

                        String ExpLevel = (String)jobDetails.get('expLevel');
                        // Check if the job is already in the map of existing positions
                        if (!existingPositionsMap.containsKey(jobId)) {
                            // No existing position found, create a new Position__c record
                            Position__c newPosition = new Position__c();
                            newPosition.Job_Id__c = jobId;
                            newPosition.Name = jobTitle;
                            newPosition.CompnayName__c = company;
                            newPosition.Job_Description__c = description;
                            newPosition.Company_Image__c = logoImg;
                            newPosition.Type__c = employmentType;
                            newPosition.Company_Address__c = address;
                            newPosition.Min_pay__c = annualSalaryFrom;
                            newPosition.Max_Pay__c = annualSalaryTo;
                            newPosition.Perks__c = String.join(perkKeys, ', '); 
                            NewPosition.Source__c = 'Web';
                            newPosition.Skills_Required__c = String.join(technoligies,',') + String.join(Addtechnoligies,',');
                            newPosition.Experience_Level__c = ExpLevel;
                            positionsToInsert.add(newPosition);
                        }
                    }

                    // Insert new positions if any
                    if (!positionsToInsert.isEmpty()) {
                        insert positionsToInsert;
                    }

                    return 'Records created successfully';
                } else {
                    return 'No jobs found in the response';
                }
            } else {
                return 'Error: ' + res.getStatus();
            }
        } catch (Exception e) {
            return 'Exception: ' + e.getMessage();
        }
    }
}