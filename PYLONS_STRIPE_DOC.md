# STRIPE API 
###  stripe_info  
    url : http://localhost:1317/pylons/stripe_info
    method : GET 
    Response : 
    {
        "result": {
            "Public_Key": "pk_test_.....",
            "ClientID": "ca_Jd44I5yQ4pKBpePVtiROVcTFRzQVU6cT",
            "Redirect_Uri": "https://wallet.pylons.tech"
        }
    } 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
###  stripe_create_account  
    url : http://localhost:1317/pylons/stripe_create_account
    method : POST
    params : {"Country":"Country","Email":"Email","Type":"Type","Sender":"Sender"}
    Response : 
    {
        "result": "https://connect.stripe.com/express/onboarding/DASJXXKuioV7"
    }
    ex->params : {"Country":"US","Email":"your email","Type":"express","Sender":"cosmos1wqn2lerx5d5dpzf5lafq9jfje34g82jkkc4zfz"}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
###  oauth_token                
    url :  http://localhost:1317/pylons/oauth_token  
    method : POST
    params : {"Sender":"Sender", "GrantType" : "GrantType", "Code": "Code"}
    Response : 
    {
        "result": {
            "livemode": false,
            "scope": "read_write",
            "stripe_user_id": "acct_1J5ysqJfslWhkkGm",
            "token_type": "bearer",
            "access_token": "sk_test_...",
            "refresh_token": "rt_JjRmuqUtksii1ntgaMpqM3T0722iEX5x6KfIm4RH29ZiUEsM",
            "stripe_publishable_key": "pk_test_..."
        }
    }
    ex->params : {"Sender":"cosmos1xp6wvve3teaw9gucymywzuserla0k5hfejwrrn", "GrantType" : "authorization_code", "Code": "ac_JjRmm13U6KLgjtloZSCGEuX4qvNAeMXZ"}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 ###  stripe_create_product_sku  
    url : http://localhost:1317/pylons/stripe_create_product_sku
    method : POST
    params :   {"Name":"Name","Description":"Description","Images":["Images"], "Attributes":["Attributes"], "Price":"Price", "Currency":"Currency", "Inventory":["Inventory"], "ClientId": "ClientId" , "Sender":"Sender"}
    Response : 
    {
        "result": "sku_JjSCkPYQc32AEa" 
    }
    ex->params : {"Name":"Shirt","Description":"Short Pant","Images":[], "Attributes":[], "Price":"300", "Currency":"USD", "Inventory":{"Quantity": "1", "Type": "finite"}, "ClientId": "acct_1J5z25RLdjb1W5P7" , "Sender":"cosmos1wqn2lerx5d5dpzf5lafq9jfje34g82jkkc4zfz"}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
###  stripe_create_payment_intent  
    url : http://localhost:1317/pylons/stripe_create_payment_intent
    method : POST
    params : {"Amount":"Amount","Country":"Country", "SKUID": "SKUID","Sender":"Sender"} 
    Response : 
    {
        "result": "pi_1J5zKrEdpQgutKvrqhN3n8t6_secret_kwwuOESEvtLj2JtqZIvFdTMlJ"
    }
    ex->params : {"Amount":"2300","Country":"US", "SKUID": "sku_JjSCkPYQc32AEa","Sender":"cosmos1wqn2lerx5d5dpzf5lafq9jfje34g82jkkc4zfz"} 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    