const { IncomingWebhook } = require('@slack/webhook');
const url = process.env.SLACK_WEBHOOK_URL;

const webhook = new IncomingWebhook(url);

// subscribeSlack is the main function called by Cloud Functions.
module.exports.subscribeSlack = (pubSubEvent, context) => {
  const build = eventToBuild(pubSubEvent.data);
  console.log("DATA: " + pubSubEvent.data);

  // Skip if the current status is not in the status list.
  // Add additional statuses to list if you'd like:
  // QUEUED, WORKING, SUCCESS, FAILURE,
  // INTERNAL_ERROR, TIMEOUT, CANCELLED
  const status = ['SUCCESS', 'FAILURE', 'INTERNAL_ERROR', 'TIMEOUT'];
  if (status.indexOf(build.status) === -1) {
    return;
  }

  // Send message to Slack.
  const message = createSlackMessage(build);
  console.log("webhook message", message)
  console.log("build substitutions", JSON.stringify(build.substitutions))
  console.log("build source", JSON.stringify(build.source))
  console.log("build steps", JSON.stringify(build.steps))
  console.log("build results", JSON.stringify(build.results))
  console.log("build failure info", JSON.stringify(build.failureInfo))
  webhook.send(message);
};

// eventToBuild transforms pubsub event message to a build object.
const eventToBuild = (data) => {
  return JSON.parse(Buffer.from(data, 'base64').toString());
}

const generateMessageText = (build) => {
  return `[${build.substitutions.SHORT_SHA}](https://www.github.com/pylons-tech/pylons/commit/${build.substitutions.COMMIT_SHA})\
 was a [${build.status}](${build.logUrl})`
}

// createSlackMessage create a message from a build object.
const createSlackMessage = (build) => {
  var embeds = []
  let message = {
    username: build.substitutions.TRIGGER_NAME,
    text: generateMessageText(build),
    attachments: [{
      title: "Build steps",
      fields: []
    }]
  }
  if (build && build.steps) {
    build.steps.forEach(function (step) {
      var time = '';
      if (step.timing && step.timing.endTime) {
        time = "took " + (new Date(step.timing.endTime) - new Date(step.timing.startTime)) * .001;
      }
      message.attachments[0].fields.push({
        title: step.name,
        value: step.entrypoint + " " + step.args.join(' ') + " " + time + " and " + step.status,
        color: step.status === 'FAILURE' ? 16714507 : 6618931
      });
    });
  }
  return message
}