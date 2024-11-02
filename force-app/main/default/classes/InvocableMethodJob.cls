public with sharing class InvocableMethodJob {
    @InvocableMethod(label='Fetch External Jobs from REST Resource')
    public static List<String> fetchExternalJobsFromResource(List<String> inputs) {
    
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        HttpResponse res;
        
        
        String endpoint = URL.getOrgDomainUrl().toExternalForm() + '/services/apexrest/externalJobs'; 
        
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        
       
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());  
        List<String> responseList = new List<String>();
        
        try {
            
            res = http.send(req);
            
           
            if (res.getStatusCode() == 200) {
                responseList.add(res.getBody()); 
            } else {
                responseList.add('Error: ' + res.getStatus());
            }
        } catch (Exception e) {
            responseList.add('Exception: ' + e.getMessage());
        }
        
        return responseList; 
    }
}
