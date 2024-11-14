@RestResource(urlMapping = '/profile')
global with sharing class GetAndUpdateProfile {
	  // GET method to retrieve the candidate profile
    @HttpGet
    global static List<Candidate__c> getProfile() {
        // Extract the CandidateId from query parameters
        String candidateId = RestContext.request.params.get('CandidateId');
        List<Candidate__c> canlist = new List<Candidate__c>();

        // Validate the CandidateId input
        if (String.isBlank(candidateId)) {
            // If no CandidateId is provided, return an error
            RestContext.response.statusCode = 400;
            RestContext.response.responseBody = Blob.valueOf('Error: CandidateId is required');
            return null;
        }

        // Query the candidate record
        try {
            canlist = [
                select City__c, Country__c, Current_Employeer__c, Currently_Emoloyed__c, Education__c, Email__c, 
                        First_Name__c, Id, Last_Name__c, LastActivityDate, LastModifiedDate, Name, Mobile__c, Phone__c, 
                        Postal_Code__c, State__c, Street__c, US_Citizen__c, Visa_Required__c, Years_of_Experience__c from Candidate__c 
                WHERE Id = :candidateId
            ];

            // Check if a record was found
            if (canlist.isEmpty()) {
                RestContext.response.statusCode = 404;
                RestContext.response.responseBody = Blob.valueOf('Error: Candidate not found');
                return null;
            }

        } catch (Exception e) {
            // Handle any exceptions
            RestContext.response.statusCode = 500;
            RestContext.response.responseBody = Blob.valueOf('Error: ' + e.getMessage());
            return null;
        }

        return canlist;
    }
    // PATCH method to update specific fields of a candidate profile
  		


    @HttpPatch
    global static void updateProfile() {
        RestRequest req = RestContext.request;
    
        // Extract CandidateId from the query parameters
        String candidateId = RestContext.request.params.get('CandidateId');
        if (String.isBlank(candidateId)) {
            RestContext.response.statusCode = 400;
            RestContext.response.responseBody = Blob.valueOf('{"error": "CandidateId is required"}');
            return;
        }
    
        // Ensure the request body is present
        if (req.requestBody == null || String.isBlank(req.requestBody.toString())) {
            RestContext.response.statusCode = 400;
            RestContext.response.responseBody = Blob.valueOf('{"error": "Request body is required"}');
            return;
        }
    
        // Try to deserialize the request body to a Map
        Map<String, Object> body;
        try {
            body = (Map<String, Object>) JSON.deserializeUntyped(req.requestBody.toString());
        } catch (System.TypeException e) {
            RestContext.response.statusCode = 400;
            RestContext.response.responseBody = Blob.valueOf('{"error": "Request body must be a JSON object"}');
            return;
        }
    
        try {
            // Query the existing candidate record
            Candidate__c candidate = [SELECT Id, Years_of_Experience__c FROM Candidate__c WHERE Id = :candidateId LIMIT 1];
    
            // Dynamically update fields from the request body
            for (String fieldName : body.keySet()) {
                if (fieldName != 'Id') {  // Skip Id itself
                    Object value = body.get(fieldName);
    
                    // Convert numeric fields as necessary
                    if (fieldName == 'Years_of_Experience__c' && value instanceof String) {
                        candidate.put(fieldName, Decimal.valueOf((String) value));
                    } else {
                        candidate.put(fieldName, value); // Assign other fields directly
                    }
                }
            }
    
            // Save the updated candidate record
            update candidate;
    
            // Send success response
                // Send success response
                Map<String, Object> responseBody = new Map<String, Object>{
                    'status' => 'success',
                    'message' => 'Candidate profile updated successfully',
                    'candidateId' => candidateId
                };
                RestContext.response.statusCode = 200;
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(responseBody));
            System.debug(RestContext.response.responseBody);
            return;  // Ensure the method exits after setting the response
    
        } catch (DmlException e) {
            RestContext.response.statusCode = 500;
            RestContext.response.responseBody = Blob.valueOf('{"error": "' + e.getMessage() + '"}');
        } catch (QueryException e) {
            RestContext.response.statusCode = 404;
            RestContext.response.responseBody = Blob.valueOf('{"error": "Candidate not found"}');
        } catch (System.TypeException e) {
            RestContext.response.statusCode = 400;
            RestContext.response.responseBody = Blob.valueOf('{"error": "Invalid type for field update"}');
        }
    }
    
    
}