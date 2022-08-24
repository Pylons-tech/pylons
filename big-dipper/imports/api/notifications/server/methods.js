import {
  Notifications
} from '../notifications.js'

import {
  Res
} from '../../res.js'

import {
  Utils
} from '../../utils.js'

import {
  Codec
} from '../../codec.js'

import {
  API
} from '../../api.js'


API.addRoute(
  'notifications/getAllNotifications/:address/:limit/:offset', {
    authRequired: false
  }, {
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

      return Res.InValidInput(Codec.BadRequestMessage,"requires params /:address/:limit/:offset")
    }
  }
)

API.addRoute(
  'notifications/markread', {
    authRequired: false
  }, {
    post: function () {

      const notificationIDs = this.bodyParams.notificationIDs
      if (notificationIDs && notificationIDs.length > 0) {

        for (let index = 0; index < notificationIDs.length; index++) {
          const id = notificationIDs[index]
          // mark as Read
          const result = markRead(id)
          if (result !== 1) {
            return Res.InValidInput(Codec.InvalidIDMessage, `notificationID ${id} is invalid`)
          }
        }
        return Res.Success('notifications marked as Read')

      }
      return Res.InValidInput(Codec.InvalidIDMessage, 'notificationIDs list is missing or corrupt')
    }
  }
)

function markRead(id) {
  return Notifications.update({
    _id: id
  }, {
    $set: {
      read: true
    }
  })
}

function getNotifications(address, limit, offset) {
  return Notifications.find({
    from: address
  }, {
    sort: {
      created_at: -1
    },
    limit: parseInt(limit),
    skip: parseInt(offset)
  }).fetch()
}