import { Meteor } from 'meteor/meteor'
import { WebApp } from 'meteor/webapp'
import { Notifications } from '../notifications.js'
import { FCMToken } from '../../fcmtoken/fcmtoken.js'
import { isNumber, isString } from 'lodash'
import { sanitizeUrl } from '@braintree/sanitize-url'
import { HTTP } from 'meteor/http'
import { admin } from '../../admin.js'
import connectRoute from 'connect-route'

const StatusOk = 200
const StatusInvalidInput = 400
const Success = 'Success'
const BadRequest = 'Bad Request'
const InvalidID = 'Invalid Notification ID'
const AppCheckFailed = 'App Check Failed'

/* eslint-disable */
const Api = new Restivus({
  useDefaultAuth: true,
  prettyJson: true
})

Api.addRoute(
  'notifications/getAllNotifcations/:address/:limit/:offset',
  { authRequired: false },
  {
    get: function () {
      if (
        Valid(this.urlParams.address) ||
        isNumber(this.urlParams.limit) ||
        isNumber(this.urlParams.offset)
      ) {
        try {
          const res = getNotifications(
            this.urlParams.address,
            this.urlParams.limit,
            this.urlParams.offset
          )
          return {
            Code: StatusOk,
            Message: Success,
            Data: { results: res }
          }
        } catch (e) {
          return {
            Code: StatusInvalidInput,
            Message: BadRequest,
            Data: e // "Error Fetching Notifcations",
          }
        }
      }
      return {
        Code: StatusInvalidInput,
        Message: BadRequest,
        Data: 'Invalid Params'
      }
    }
  }
)

WebApp.connectHandlers.use(
  connectRoute(function (router) {
    router.post('/notifications/markread', async function (req, res) {
      const h = req.headers
      const notificationIDs = req.body.notificationIDs

      if (!h['x-firebase-appcheck']) {
        res.writeHead(StatusOk, {
          'Content-Type': 'text/html'
        })

        res.end(
          JSON.stringify({
            Code: StatusInvalidInput,
            Message: AppCheckFailed,
            Data: 'x-firebase-appcheck header missing'
          })
        )
      } else {
        if (notificationIDs && notificationIDs.length > 0) {
          // performing app check
          const appCheckClaims = await verifyAppCheckToken(
            h['x-firebase-appcheck']
          )

          // app check failed
          if (!appCheckClaims) {
            res.writeHead(StatusOk, {
              'Content-Type': 'text/html'
            })

            res.end(
              JSON.stringify({
                Code: StatusInvalidInput,
                Message: AppCheckFailed,
                Data: 'invalid x-firebase-appcheck header'
              })
            )
          }

          // app check passed
          if (notificationIDs && notificationIDs.length > 0) {
            for (let index = 0; index < notificationIDs.length; index++) {
              const id = notificationIDs[index]

              // mark as Read
              const result = markRead(id)
              if (result !== 1) {
                res.writeHead(StatusOk, {
                  'Content-Type': 'text/html'
                })

                res.end(
                  JSON.stringify({
                    Code: StatusInvalidInput,
                    Message: InvalidID,
                    Data: `notificationID ${id} is invalid`
                  })
                )
              }
            }

            // Success
            res.writeHead(StatusOk, {
              'Content-Type': 'text/html'
            })

            res.end(
              JSON.stringify({
                Code: StatusOk,
                Message: Success,
                Data: 'notifications marked as Read'
              })
            )
          }
        }

        // invalid request
        res.writeHead(StatusOk, {
          'Content-Type': 'text/html'
        })

        res.end(
          JSON.stringify({
            Code: StatusInvalidInput,
            Message: BadRequest,
            Data: 'notifcationIDs list is missing or corrupt'
          })
        )
      }
    })
  })
)

Meteor.methods({
  // send un settleed notifications
  'Notifications.sendPushNotifications': function () {
    this.unblock()

    const unSettled = Notifications.find({ settled: false })

    unSettled.forEach((sale) => {
      const sellerAddress = sale.from
      const saleID = sale._id
      let token
      // get Firebase token for specified user address
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

function Valid (parameter) {
  if (isString(parameter)) {
    return false
  }
  if (parameter.length === 0) {
    return false
  }
  return true
}

function markRead (id) {
  return Notifications.update({ _id: id }, { $set: { read: true } })
}

function markSent (id) {
  Notifications.update({ _id: id }, { $set: { settled: true } })
  return Notifications.update({ _id: id }, { $set: { settled: true } })
}
function getNotifications (address, limit, offset) {
  return Notifications.find(
    { from: address },
    {
      sort: { time: -1 },
      limit: parseInt(limit),
      skip: parseInt(offset)
    }
  ).fetch()
}

function getUserNameInfo (address) {
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

async function verifyAppCheckToken (appCheckToken) {
  if (!appCheckToken) {
    return null
  }
  try {
    return admin.appCheck().verifyToken(appCheckToken)
  } catch (err) {
    return null
  }
}
