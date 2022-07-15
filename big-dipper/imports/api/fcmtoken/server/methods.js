import { Meteor } from "meteor/meteor";
import { FCMToken } from "../fcmtoken.js";
import { admin } from "../../admin.js";
// Global API configuration
var Api = new Restivus({
  useDefaultAuth: true,
  prettyJson: true,
});

const StatusOk = 200;
const StatusInvalidInput = 400;
const InternalServerError = 500;
const Success = "Success";
const Failed = "Failed";
const BadRequest = "Bad Request";
const AppCheckFailed = "App Check Failed"

Api.addRoute(
  "fcmtoken/update/:address/:token",
  { authRequired: false },
  {
    //update fcm token against address
    post: function () {
      if (!Valid(this.urlParams.address) || !Valid(this.urlParams.token)) {
        return {
          Code: StatusInvalidInput,
          Message: BadRequest,
          Data: null,
        };
      }


      let h = this.request.headers;
      if(!h['x-firebase-appcheck']){
        return {
          Code: StatusInvalidInput,
          Message: AppCheckFailed,
          Data: "x-firebase-appcheck header not found",
        }; 
      }
      
      // admin.appCheck().verifyToken(h['x-firebase-appcheck']).then((res) => {
          var result = updateFCMToken(this.urlParams.address, this.urlParams.token);
          
          if (result === false) {
            return {
              Code: InternalServerError,
              Message: Failed,
              Data: "",
            };
          }
    
          return {
            Code: StatusOk,
            Message: Success,
            Data: result,
          };

      // Useful for future debug
      // }).catch((e)=>{
      //   return {
      //     Code: StatusInvalidInput,
      //     Message: AppCheckFailed,
      //     Data: "x-firebase-appcheck Failed",
      //   };
      // })
        
      return {
        Code: StatusInvalidInput,
        Message: BadRequest,
        Data: null,
      };
       
    },
  }
);

function updateFCMToken(userAddress, fcmToken) {
  try {
    FCMToken.upsert(
      { address: userAddress },
      {
        $set: {
          address: userAddress,
          token: fcmToken,
        },
      }
    );
  } catch (error) {
    console.log(error)
    return false;
  }
  return true;
}

function Valid(parameter) {
  if (typeof(parameter) != "string"){
    return false
  }
  if (parameter.length == 0){
    return false
  }
  return true
}
