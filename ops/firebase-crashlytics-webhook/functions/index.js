'use strict';

const functions = require('firebase-functions');
var rp = require('request-promise');

exports.sendOnNewIssue = functions.crashlytics.issue().onNew(async (issue) => {

  const wekbook_url = functions.config().webhook.url

  var options = {
    method: "POST",
    uri: wekbook_url,
    body: {
      issueId: issue.issueId,
      issueTitle: issue.issueTitle,
      appName: issue.appInfo.appName,
      appId: issue.appInfo.appId,
      appPlatform: issue.appInfo.appPlatform,
      latestAppVersion: issue.appInfo.latestAppVersion,
      createTime: issue.createTime
    },
    json: true
  }

  try {
    await rp(options)
    console.log('Successfully sent webhook');
  } catch (error) {
    console.error(error.toString());
  }
});

exports.sendOnRegressedIssue = functions.crashlytics.issue().onRegressed(async (issue) => {

  const wekbook_url = functions.config().webhook.url

  var options = {
    method: "POST",
    uri: wekbook_url,
    body: {
      issueId: issue.issueId,
      issueTitle: issue.issueTitle,
      appName: issue.appInfo.appName,
      appId: issue.appInfo.appId,
      appPlatform: issue.appInfo.appPlatform,
      latestAppVersion: issue.appInfo.latestAppVersion,
      createTime: issue.createTime,
      resolvedTime: issue.resolvedTime
    },
    json: true
  }

  try {
    await rp(options)
    console.log('Successfully sent webhook');
  } catch (error) {
    console.error(error.toString());
  }
});

exports.sendOnVelocityAlert = functions.crashlytics.issue().onVelocityAlert(async (issue) => {

  const wekbook_url = functions.config().webhook.url

  var options = {
    method: "POST",
    uri: wekbook_url,
    body: {
      issueId: issue.issueId,
      issueTitle: issue.issueTitle,
      appName: issue.appInfo.appName,
      appId: issue.appInfo.appId,
      appPlatform: issue.appInfo.appPlatform,
      latestAppVersion: issue.appInfo.latestAppVersion,
      createTime: issue.createTime,
      crashes: issue.velocityAlert.crashes,
      crashPercentage: issue.velocityAlert.crashPercentage
    },
    json: true
  }

  try {
    await rp(options)
    console.log('Successfully sent webhook');
  } catch (error) {
    console.error(error.toString());
  }
});
