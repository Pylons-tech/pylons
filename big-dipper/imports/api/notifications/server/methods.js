import { Meteor } from "meteor/meteor";
import { Notifications } from "../notifications.js";
import { FCMToken } from "../../fcmtoken/fcmtoken.js";

const StatusOk = 200;
const StatusInvalidInput = 400;
const Success = "Success";
const BadRequest = "Bad Request";
const ActionTypeLike = "Like";
const ActionTypeView = "View";

var Api = new Restivus({
  useDefaultAuth: true,
  prettyJson: true,
});

Api.addRoute(
  "notification/markread/:notificationid",
  { authRequired: false },
  {
    //update fcm token against address
    post: function () {
      if (!Valid(this.urlParams.notificationid)) {
        return {
          Code: StatusInvalidInput,
          Message: BadRequest,
          Data: null,
        };
      }

      var result = markRead(this.urlParams.notificationID);

      if (result !== 1) {
        return {
          Code: InternalServerError,
          Message: Failed,
          Data: null,
        };
      }

      return {
        Code: StatusOk,
        Message: Success,
        Data: null,
      };
    },
  }
);

Meteor.methods({
  //send un settleed notifications
  "Notifications.sendPushNotifications": function () {
    this.unblock();
    const unSettled = Notifications.find({ settled: false });

    unSettled.forEach((sale) => {
      var sellerAddress = sale.from;
      var salehash = sale.txhash;

      var token = getFCMToken(sellerAddress).token;
      // sendNotification(token).then(() => {
      Notifications.update({ txhash: salehash }, { $set: { settled: true } });
      // });
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

function sendNotification(token) {
  //implement send notification here
  return 1;
}

function markRead(notificationID) {
  return Notifications.update(
    { _id: notificationID },
    { $set: { read: true } }
  );
}
