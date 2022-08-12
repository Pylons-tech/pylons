const admin = require('firebase-admin')
//const serviceAccount = require('../../firebase.json')
let serviceAccount = process.env.FIREBASE_CONFIG
serviceAccount = JSON.parse(serviceAccount)
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
})
module.exports.admin = admin
