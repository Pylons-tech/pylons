# Warning

This code is outdated and no longer maintained. I was told sentry.io is a good looking alternative here.

# Crashlytics Webhook

Call a webhook when a new issue is reported in firebase crashlytics.

Note: This assumes that you have Crashlytics in Firebase. [Learn more about Crashlytics](https://firebase.google.com/docs/crashlytics/)

## Setting up

 Create and setup the Firebase project:
  1. Create a Firebase project using the [Firebase Developer Console](https://console.firebase.google.com).
  1. Enable Billing on your Firebase by switching to the **Blaze** or **Pay as you Go** plan, this is currently needed to be able to perform HTTP requests to external services from a Cloud Function.
  1. Include [Crashlytics in your project](https://firebase.google.com/docs/crashlytics/get-started).

 Configuring the hook
  1. Clone or download this repo.
  1. You must have the Firebase CLI installed. If you don't have it, install it with `npm install -g firebase-tools` and then configure it with `firebase login`.
  1. Configure the CLI locally by using `firebase use --add` and select your project in the list.
  1. Install `npm` dependencies in the functions directory locally, by running: `cd functions; npm install;`
  1. Set the environment variable for the webhook: `firebase functions:config:set webhook.url="http://www.example.com/hook/crash"`

## Deploy and test

 1. Deploy your project using `firebase deploy`
 1. Simulate a test crash. [Instructions](https://firebase.google.com/docs/crashlytics/force-a-crash)

## Enjoy
