#!/bin/bash

str='
{
  "project_info": {
    "project_number": "884516545293",
    "project_id": "easel-6a999",
    "storage_bucket": "easel-6a999.appspot.com"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "1:884516545293:android:f380641e066fe76ce04644",
        "android_client_info": {
          "package_name": "tech.pylons.easel"
        }
      },
      "oauth_client": [
        {
          "client_id": "884516545293-ah7beh3q87ctdanl1foq796em9699hss.apps.googleusercontent.com",
          "client_type": 3
        }
      ],
      "api_key": [
        {
          "current_key": "SET_CURRENT_KEY"
        }
      ],
      "services": {
        "appinvite_service": {
          "other_platform_oauth_client": [
            {
              "client_id": "884516545293-ah7beh3q87ctdanl1foq796em9699hss.apps.googleusercontent.com",
              "client_type": 3
            }
          ]
        }
      }
    }
  ],
  "configuration_version": "1"
}'

apiKeyPlaceHolder=SET_CURRENT_KEY
replaceWithApiKey=$1
newStr=${str//$oauthKeyPlaceHolder/$oAuthKey}
echo $newStr >> android/app/google-services.json