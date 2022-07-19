import { WebApp } from 'meteor/webapp'
import { FCMToken } from '../fcmtoken.js'
import { admin } from '../../admin.js'
import connectRoute from 'connect-route'
import { isString } from 'lodash'
// Global API configuration

const StatusOk = 200
const StatusInvalidInput = 400
const Success = 'Success'
const Failed = 'Failed'
const BadRequest = 'Bad Request'
const AppCheckFailed = 'App Check Failed'

WebApp.connectHandlers.use(
  connectRoute(function (router) {
    router.post('/fcmtoken/update/:address/:token', async function (req, res) {
      // validate that params exist
      if (!Valid(req.params.address) || !Valid(req.params.token)) {
        res.writeHead(StatusOk, {
          'Content-Type': 'text/html'
        })

        res.end(
          JSON.stringify({
            Code: StatusInvalidInput,
            Message: BadRequest,
            Data: null
          })
        )
      }

      const h = req.headers
      // app check header check
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

        const result = updateFCMToken(req.params.address, req.params.token)

        if (result === false) {
          res.writeHead(400, {
            'Content-Type': 'text/html'
          })

          res.end(
            JSON.stringify({
              Code: StatusInvalidInput,
              Message: Failed,
              Data: null
            })
          )
        }

        res.writeHead(200, {
          'Content-Type': 'text/html'
        })

        res.end(
          JSON.stringify({
            Code: StatusOk,
            Message: Success,
            Data: null
          })
        )
      }
    })
  })
)

function updateFCMToken (userAddress, fcmToken) {
  try {
    FCMToken.upsert(
      { address: userAddress },
      {
        $set: {
          address: userAddress,
          token: fcmToken
        }
      }
    )
  } catch (error) {
    console.log(error)
    return false
  }
  return true
}

function Valid (parameter) {
  if (isString(parameter)) {
    return false
  }
  if (parameter.length === 0) {
    return false
  }
  return true
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
