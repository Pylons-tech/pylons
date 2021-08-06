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
         "result": {
	        "created": "1624712919",
	        "expires_at": "1624713219",
	        "object": "account_link",
	        "url": "https://connect.stripe.com/express/onboarding/gJDYTzaDWMgP"
	    }
    }
    ex->params : {"Country":"US","Email":"your email","Type":"express","Sender":"cosmos1wqn2lerx5d5dpzf5lafq9jfje34g82jkkc4zfz"}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
###  stripe_oauth_token                
    url :  http://localhost:1317/pylons/stripe_oauth_token  
    method : POST
    params : {"Sender":"Sender", "GrantType" : "GrantType", "Code": "Code"}
    Response : 
    {
        "result": {
	        "livemode": false,
	        "scope": "read_write",
	        "stripe_user_id": "acct_1J6bItIX6DBvlzgV",
	        "token_type": "bearer",
	        "access_token": "sk_test_.....",
	        "refresh_token": "rt_Jk5UL9IyJV8xtTm8vfzsliIQDcen1BTCJEgUveXY0anBYOI4",
	        "stripe_publishable_key": "pk_test_....."
	    }
    }
    ex->params : {"Sender":"cosmos1xp6wvve3teaw9gucymywzuserla0k5hfejwrrn", "GrantType" : "authorization_code", "Code": "ac_JjRmm13U6KLgjtloZSCGEuX4qvNAeMXZ"}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 ###  stripe_create_product_sku  
    url : http://localhost:1317/pylons/stripe_create_product_sku
    method : POST
    params :   {"Name":"Name","Description":"Description","Images":["Images"], "Attributes":["Attributes"], "Price":"Price", "Currency":"Currency", "Inventory":["Inventory"], "ClientID": "ClientID" , "Sender":"Sender"}
    Response : 
    {
         "result": {
	        "stripe_sku_id": "sku_Jk5qFGcANahYdp"
	    }
    }
    ex->params : {"Name":"Shirt","Description":"Short Pant","Images":[], "Attributes":[], "Price":"300", "Currency":"USD", "Inventory":{"Quantity": "1", "Type": "finite"}, "ClientID": "acct_1J5z25RLdjb1W5P7" , "Sender":"cosmos1wqn2lerx5d5dpzf5lafq9jfje34g82jkkc4zfz"}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
###  stripe_create_payment_intent  
    url : http://localhost:1317/pylons/stripe_create_payment_intent
    method : POST
    params : {"Amount":"Amount","Currency":"Currency", "SKUID": "SKUID","Sender":"Sender","CustomerID: "CustomerID"} 
    Response : 
    {
        "result": {
            "stripe_payment_intent_id": "pi_3JK84OEdpQgutKvr0T0uKCK9",
            "client_secret": "pi_3JK84OEdpQgutKvr0T0uKCK9_secret_WbgbZAwDtH2TY0Ykxs7Af2DVJ",
            "stripe_ephemeralKey": "ephkey_1JK84OEdpQgutKvryqPxs9Y1",
            "stripe_customer_id": "cus_Jy47JClSoIn9ZP"
        }
    }
    ex->params : {"Amount":"2300","Currency":"US", "SKUID": "sku_JjSCkPYQc32AEa","Sender":"cosmos1wqn2lerx5d5dpzf5lafq9jfje34g82jkkc4zfz", "CustomerID": "cus_Jy47JClSoIn9ZP"} 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
###  stripe_create_customer_id  
    url : http://localhost:1317/pylons/stripe_create_customer_id
    method : POST
    params : {"Sender":"Sender"} 
    Response : 
    {
         "result": {
             "stripe_customer_id": "cus_Jy47JClSoIn9ZP"
         }
    }
    ex->params : {"Sender":"cosmos1wqn2lerx5d5dpzf5lafq9jfje34g82jkkc4zfz"} 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
###  check_payment  
    url : http://localhost:1317/custom/pylons/check_payment/paymentID
    method : GET 
    Response : 
    {
        "result": {
            "paymentID": "pi_3JKT31EdpQgutKvr1fya1Wp3",
            "exist": false
        }
    }
    ex->params : {"paymentID":"pi_3JKT31EdpQgutKvr1fya1Wp6"} 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
###  stripe_payment_history_list  
    url : http://localhost:1317/pylons/stripe_payment_history_list
    method : POST 
    params: {"Sender":"Sender","CustomerID":"CustomerID"} 
    Response : 
    {
         "result": {
            {
                "ID": "pi_3JKkPpEdpQgutKvr0Wd18yxK",
                "Amount": "2200",
                "Currency": "usd",
                "CustomerID": "cus_JyhlxC3I7hdYcL",
                "ClientSecret": "pi_3JKkPpEdpQgutKvr0Wd18yxK_secret_kFMAqEEgVE9Z15079FcFicxrz",
                "Status": "requires_payment_method"
                "Created": "Created"
            },
            {
                "ID": "pi_3JKkPdEdpQgutKvr14xs3LvP",
                "Amount": "2200",
                "Currency": "usd",
                "CustomerID": "cus_JyhlxC3I7hdYcL",
                "ClientSecret": "pi_3JKkPdEdpQgutKvr14xs3LvP_secret_ANZGRoOvBeBxDVMBEcCDIm41A",
                "Status": "requires_payment_method"
                "Created": "Created"
            },
        }
    }
    ex->params : {"Sender":"cosmos1zv9lypqpgtwjcmhup7650wukcull9jehjd3njy","CustomerID":"cus_JyhlxC3I7hdYcL"} 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////