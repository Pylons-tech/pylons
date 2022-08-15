import { Meteor } from 'meteor/meteor'
import { Notifications } from '../notifications.js'
import { FCMToken } from '../../fcmtoken/fcmtoken.js'
import { sanitizeUrl } from '@braintree/sanitize-url'
import { HTTP } from 'meteor/http'
import { admin } from '../../admin.js'

import { Notifications } from '../notifications.js'

import { Res } from '../../res.js'

import { Utils } from '../../utils.js'

import { Codec } from '../../codec.js'

import { API } from '../../api.js'

API.addRoute(
  'notifications/getAllNotifications/:address/:limit/:offset',
  {
    authRequired: false
  },
  {
    get: function () {
      if (
        Utils.ValidateAddress(this.urlParams.address) &&
        this.urlParams.limit &&
        this.urlParams.offset
      ) {
        try {
          const res = getNotifications(
            this.urlParams.address,
            this.urlParams.limit,
            this.urlParams.offset
          )

          return Res.Success({
            results: res
          })
        } catch (e) {
          return Res.InValidInput(Codec.BadRequestMessage, null)
        }
      }

      return Res.InValidInput(
        Codec.BadRequestMessage,
        'requires params /:address/:limit/:offset'
      )
    }
  }
)

API.addRoute(
  'notifications/markread',
  {
    authRequired: false
  },
  {
    post: function () {
      const notificationIDs = this.bodyParams.notificationIDs
      if (notificationIDs && notificationIDs.length > 0) {
        for (let index = 0; index < notificationIDs.length; index++) {
          const id = notificationIDs[index]
          // mark as Read
          const result = markRead(id)
          if (result !== 1) {
            return Res.InValidInput(
              Codec.InvalidIDMessage,
              `notificationID ${id} is invalid`
            )
          }
        }
        return Res.Success('notifications marked as Read')
      }
      return Res.InValidInput(
        Codec.InvalidIDMessage,
        'notificationIDs list is missing or corrupt'
      )
    }
  }
)

API.addRoute(
  'notifications/getAllNotifications/:address/:limit/:offset',
  {
    authRequired: false
  },
  {
    get: function () {
      if (
        Utils.ValidateAddress(this.urlParams.address) &&
        this.urlParams.limit &&
        this.urlParams.offset
      ) {
        try {
          const res = getNotifications(
            this.urlParams.address,
            this.urlParams.limit,
            this.urlParams.offset
          )

          return Res.Success({
            results: res
          })
        } catch (e) {
          return Res.InValidInput(Codec.BadRequestMessage, null)
        }
      }

      return Res.InValidInput(
        Codec.BadRequestMessage,
        'requires params /:address/:limit/:offset'
      )
    }
  }
)

API.addRoute(
  'notifications/markread',
  {
    authRequired: false
  },
  {
    post: function () {
      const notificationIDs = this.bodyParams.notificationIDs
      if (notificationIDs && notificationIDs.length > 0) {
        for (let index = 0; index < notificationIDs.length; index++) {
          const id = notificationIDs[index]
          // mark as Read
          const result = markRead(id)
          if (result !== 1) {
            return Res.InValidInput(
              Codec.InvalidIDMessage,
              `notificationID ${id} is invalid`
            )
          }
        }
        return Res.Success('notifications marked as Read')
      }
      return Res.InValidInput(
        Codec.InvalidIDMessage,
        'notificationIDs list is missing or corrupt'
      )
    }
  }
)

Meteor.methods({
  //send un settled notifications
  'Notifications.sendPushNotifications': function () {
    this.unblock()

    const unSettled = Notifications.find({ settled: false })

    unSettled.forEach((sale) => {
      var sellerAddress = sale.from
      var saleID = sale._id
      var token
      //get Firebase token for specified user address
      try {
        token = FCMToken.findOne({ address: sellerAddress }).token
      } catch (e) {
        return e
      }

      const buyerUserName = getUserNameInfo(sale.to).username.value
      const message = {
        notification: {
          title: 'NFT Sold',
          body: `Your NFT ${sale.item_name} has been sold to ${buyerUserName}`
        },
        data: {
          type: 'NFT Sold'
        }
      }

      const options = {
        priority: 'high',
        timeToLive: 86400
      }

      if (Meteor.settings.params.sendNotifications === 1) {
        admin
          .messaging()
          .sendToDevice(token, message, options)
          .then((n) => {
            markSent(saleID)
            console.log(n)
          })
          .catch((e) => {
            console.log('Notification not sent to ', token)
            console.log(e)
          })
      }
    })
  }
})

function markRead(id) {
  return Notifications.update({ _id: id }, { $set: { read: true } })
}

function markSent(id) {
  Notifications.update({ _id: id }, { $set: { settled: true } })
  return Notifications.update({ _id: id }, { $set: { settled: true } })
}
function getNotifications(address, limit, offset) {
  return Notifications.find(
    { from: address },
    {
      sort: { created_at: -1 },
      limit: parseInt(limit),
      skip: parseInt(offset)
    }
  ).fetch()
}

function getUserNameInfo(address) {
  let result
  const url = sanitizeUrl(
    `${Meteor.settings.remote.api}/pylons/account/address/${address}`
  )
  try {
    const response = HTTP.get(url)
    result = JSON.parse(response.content)
  } catch (e) {
    console.log('error getting userNameInfo: ', e)
  }
  return result
}
