import { Meteor } from "meteor/meteor";
import { Notifications } from "../notifications.js";
import { FCMToken } from "../../fcmtoken/fcmtoken.js";
import { isNumber } from "lodash";
import { sanitizeUrl } from "@braintree/sanitize-url";
import { HTTP } from "meteor/http";
import {admin} from "../../admin.js"




const StatusOk = 200;
const StatusInvalidInput = 400;
const InternalServerError = 500;
const Success = "Success";
const BadRequest = "Bad Request";
const InvalidID = "Invalid Notification ID";
const AppCheckFailed = "App Check Failed"

var Api = new Restivus({
  useDefaultAuth: true,
  prettyJson: true,
});

Api.addRoute(
  "notifications/markread",
  { authRequired: false },
  {
    post: function () {
      
      let h = this.request.headers;
      if(!h['x-firebase-appcheck']){
        return {
          Code: StatusInvalidInput,
          Message: AppCheckFailed,
          Data: "x-firebase-appcheck header missing",
        }; 
      }

      admin.appCheck().verifyToken(h['x-firebase-appcheck']).then((res)=>{
        const notifcationIDs = this.bodyParams.notifcationIDs;

        if (notifcationIDs && notifcationIDs.length > 0) {
          for (let index = 0; index < notifcationIDs.length; index++) {
            const id = notifcationIDs[index];
  
            //mark as Read
            var result = markRead(id);
            if (result != 1) {
              return {
                Code: StatusInvalidInput,
                Message: InvalidID,
                Data: id,
              };
            }
          }
  
          return {
            Code: StatusOk,
            Message: Success,
            Data: "Notifications Marked as Read",
          };
        }
      }).catch((e)=>{
          return {
            Code: StatusInvalidInput,
            Message: AppCheckFailed,
            Data: "x-firebase-appcheck Failed",
          };
      })
      
      
      
      return {
        Code: StatusInvalidInput,
        Message: BadRequest,
        Data: null,
      };
    },
  }
);

Api.addRoute(
  "notifications/getAllNotifcations/:address/:limit/:offset",
  { authRequired: false },
  {
    get: function () {
      if (
        Valid(this.urlParams.address) ||
        isNumber(this.urlParams.limit) ||
        isNumber(this.urlParams.offset)
      ) {
        try {
          var res = getNotifications(
            this.urlParams.address,
            this.urlParams.limit,
            this.urlParams.offset
          );
          return {
            Code: StatusOk,
            Message: Success,
            Data: { results: res },
          };
        } catch (e) {
          return {
            Code: StatusInvalidInput,
            Message: BadRequest,
            Data: e, //"Error Fetching Notifcations",
          };
        }
      }
      return {
        Code: StatusInvalidInput,
        Message: BadRequest,
        Data: "Invalid Params",
      };
    },
  }
);

Meteor.methods({
  //send un settleed notifications
  "Notifications.sendPushNotifications": function () {
    this.unblock();

    const unSettled = Notifications.find({ settled: false });


   
    unSettled
      .forEach((sale) => {
        var sellerAddress = sale.from;
        var saleID = sale._id;
        var token;      
        //get Firebase token for specieifed user address
        try{
          token = FCMToken.findOne({ address: sellerAddress }).token
        }catch(e){
          return e
        }
        
        const buyerUserName = getUserNameInfo(sale.to).username.value;
        const message = {
          notification: {
            title: "NFT Sold",
            body: `Your NFT ${sale.item_name} has been sold to ${buyerUserName}`,
          },
        };
        
        const options = {
          priority: "high",
          timeToLive: 86400,
        };
        
        if(Meteor.settings.params.sendNotifications === 1){

          admin
          .messaging()
          .sendToDevice(token, message, options)
          .then((n) => {
            markSent(saleID);
           console.log(n)
          })
          .catch((e) => {
            console.log("Notification not sent to ", token);
            console.log(e)
          });
          
        }
      })
      
  },
});

function Valid(parameter) {
  if (typeof parameter != "string") {
    return false;
  }
  if (parameter.length == 0) {
    return false;
  }
  return true;
}

function markRead(id) {
  return Notifications.update({ _id: id }, { $set: { read: true } });
}

function markSent(id) {
  Notifications.update({ _id: id }, { $set: { settled: true } });
  return Notifications.update({ _id: id }, { $set: { settled: true } });
}
function getNotifications(address, limit, offset) {
  return Notifications.find(
    { from: address },
    {
      sort: { time: -1 },
      limit: parseInt(limit),
      skip: parseInt(offset),
    }
  ).fetch();
}

function getUserNameInfo(address) {
  var result;
  var url = sanitizeUrl(
    `${Meteor.settings.remote.api}/pylons/account/address/${address}`
  );
  try {
    let response = HTTP.get(url);
    result = JSON.parse(response.content);
  } catch (e) {
    console.log("error getting userNameInfo: ", e);
  }
  return result;
}
