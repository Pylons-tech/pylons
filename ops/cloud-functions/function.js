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
  // const status = ['SUCCESS', 'FAILURE', 'INTERNAL_ERROR', 'TIMEOUT'];
  // if (status.indexOf(build.status) === -1) {
  //   return;
  // }

  // Send message to Slack.
  const message = createSlackMessage(build);
  webhook.send(message);
};

// eventToBuild transforms pubsub event message to a build object.
const eventToBuild = (data) => {
  return JSON.parse(Buffer.from(data, 'base64').toString());
}

// createSlackMessage create a message from a build object.
const createSlackMessage = (build) => {
  var embeds = []
let repoName = build.substitutions.REPO_NAME
  let message = {
   text: repoName,
    mrkdwn: true,
    attachments: [
      {
        title: build.name,
        title_link: build.logUrl,
        fields: [{
          title: 'Status',
          value: build.status
        }]
      }
    ]
  };
      if (build && build.steps) {
        build.steps.forEach(function (step) {
            var time = '';
            if (step.timing && step.timing.endTime) {
                time = "took " + (new Date(step.timing.endTime) - new Date(step.timing.startTime)) * .001;
            }
            embeds.push({
                title: step.name,
                description: step.entrypoint + " " + step.args.join(' ') + " " + time + " and " + step.status,
                color: build.status === 'FAILURE' ? 16714507 : 6618931
            });
        });
        message.embeds = embeds;
    }
  return message
}