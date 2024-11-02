@RestResource (UrlMapping='/SignupUser/')
global class CreateUserRest {
    @HttpPost
    global static string CreateUser(String Username,String Password,String Phone,String Email){
        Users__c user = new Users__c();
        user.UserName__c = Username;
        user.Password__c = Password;
        user.Phone__c = Phone;
        user.Email__c = Email;
        insert user;
        return 'Account Created';
    }

}