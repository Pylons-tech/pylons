import { Meteor } from "meteor/meteor";
import { Notifications } from "../notifications.js";
import { FCMToken } from "../../fcmtoken/fcmtoken.js";
import { isNumber } from "lodash";
import { sanitizeUrl } from "@braintree/sanitize-url";
import { HTTP } from "meteor/http";

var admin = require("firebase-admin");

var serviceAccount = require("./firebase.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const StatusOk = 200;
const StatusInvalidInput = 400;
const InternalServerError = 500;
const Success = "Success";
const BadRequest = "Bad Request";
const InvalidHash = "Invalid TxHash";

var Api = new Restivus({
  useDefaultAuth: true,
  prettyJson: true,
});

Api.addRoute(
  "notifications/markread",
  { authRequired: false },
  {
    post: function () {
      const txs = this.bodyParams.txhashs;

      if (txs && txs.length > 0) {
        for (let index = 0; index < txs.length; index++) {
          const hash = txs[index];

          //mark as Read
          var result = markRead(hash);
          if (result != 1) {
            return {
              Code: StatusInvalidInput,
              Message: InvalidHash,
              Data: hash,
            };
          }
        }

        return {
          Code: StatusOk,
          Message: Success,
          Data: "Notifications Marked as Read",
        };
      }

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
        var salehash = sale.txhash;
    
        var token;
        //get Firebase token for specieifed user address
        getFCMToken(sellerAddress).then((token) => {
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

          admin
            .messaging()
            .sendToDevice(token, message, options)
            .then((n) => {
              markSent(salehash);
            })
            .catch((e) => {
              console.log("Notification not sent to ", token);
            });
        });
      })
      .catch((e) => {
        console.log("unable to get fcmtoken");
      });
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

function getFCMToken(address) {
  var obj = null;
  try {
    obj = FCMToken.findOne({ address: address });
  } catch (e) {
    console.log("token not found");
  }
  return obj;
}

async function sendNotification(
  token,
  NFTName,
  buyerAddress,
  priority = "high",
  ttl = 86400
) {
  const buyerUserName = getUserNameInfo(buyerAddress).username.value;

  const message = {
    notification: {
      title: "NFT Sold",
      body: `Your NFT ${NFTName} has been sold to ${buyerUserName}`,
    },
  };

  const options = {
    priority: priority,
    timeToLive: ttl,
  };

  return admin.messaging().sendToDevice(token, message, options);
}
function markRead(hash) {
  return Notifications.update({ txhash: hash }, { $set: { read: true } });
}

function markSent(hash) {
  return Notifications.update({ txhash: hash }, { $set: { settled: true } });
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
