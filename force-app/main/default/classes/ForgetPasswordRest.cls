@RestResource(URLMapping = '/ForgetPassword/')
global class ForgetPasswordRest {
    
    
    private static Map<String, String> otpStore = new Map<String, String>(); 

    @HttpGet
    global static String GenerateOtp() {
        Map<String, String> response = new Map<String, String>();
        Map<String,String> parms = RestContext.request.params;
        String userEmail = parms.get('UserEmail'); 
        List<Users__c> emailList = [SELECT UserName__c, Email__c ,OTP__c FROM Users__c WHERE Email__c = :userEmail LIMIT 1];
        
        if (emailList.size() >= 1) {
            
            Integer randomNumber = (Math.random() * 900000).intValue() + 100000;
            String otp = String.valueOf(randomNumber);
            for(Users__c use: emailList){
                use.OTP__c = randomNumber;
            }
            
            update emailList;

            System.debug('Generated OTP: ' + otp);

         
            OrgWideEmailAddress[] orgWideEmails = [SELECT Id, Address FROM OrgWideEmailAddress LIMIT 1];
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
			email.setSaveAsActivity( false );
            email.setOrgWideEmailAddressId(orgWideEmails[0].Id);
            email.setToAddresses(new String[] { userEmail });
            email.setSubject('Your OTP Reset Code | Next Hire');
            email.setPlainTextBody('Hello ' + emailList[0].UserName__c + ',\n\nThis is your OTP to reset your password: ' + otp + '\n\nThanks,\n\nNextHire Team');
            
        
            Messaging.SendEmailResult[] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            
        
            if (result[0].isSuccess()) {
                response.put('success', 'True');
                response.put('Response', 'OTP has been sent to your email.');
            } else {
                response.put('Response', 'Failed to send email: ' + result[0].getErrors()[0].getMessage());
            } 
        } else {
            response.put('Response', 'No user found with the provided email.');
        }
        
        return JSON.serialize(response);
    }

    @HttpPost
    global static String ResetPassword() {
        Map<String, String> parms = RestContext.request.params;
        Map<String, String> response = new Map<String, String>();

        String userEmail = parms.get('UserEmail');
        String otp = parms.get('Otp');
        String newPassword = parms.get('NewPassword');
        system.debug(userEmail + otp + newPassword);
         List<Users__c> emailList = [SELECT Id, UserName__c,OTP__c FROM Users__c WHERE Email__c = :userEmail  LIMIT 1];
        // Validate if OTP exists for the provided email
        if (emailList.size()>=1) {
            String storedOtp =String.valueOf( emailList[0].OTP__c);
            
            if (storedOtp == otp) {
                // OTP matches, update the password             
                    Users__c user = emailList[0];
                    user.Password__c = newPassword; 

                    update user;
					response.put('success', 'True');
                    response.put('Response', 'Password has been successfully updated.');
                    otpStore.remove(userEmail); 
                
            } else {
                response.put('Response', 'Invalid OTP.');
            }
        } else {
            response.put('Response', 'No User Found');
        }
        
        return JSON.serialize(response);
    }
}