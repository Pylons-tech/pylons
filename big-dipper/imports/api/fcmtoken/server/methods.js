import {
  FCMToken
} from '../fcmtoken.js'

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
  'fcmtoken/update/:address/:token', {
    authRequired: false
  }, {
    post: function () {

      let address = this.urlParams.address
      let token = this.urlParams.token

      if (!Utils.ValidateAddress(address) || !Utils.ValidateToken(token)) {

        return Res.InValidInput(Codec.BadRequestMessage, null)

      } else {

        const result = updateFCMToken(address, token)
        if (result === false) {
          return Res.Failed(Codec.FailedMessage, null)
        }
        return Res.Success(null)
      }

    }
  }
)

function updateFCMToken(userAddress, fcmToken) {
  try {
    FCMToken.upsert({
      address: userAddress
    }, {
      $set: {
        address: userAddress,
        token: fcmToken
      }
    })
  } catch (error) {
    console.log(error)
    return false
  }
  return true
}