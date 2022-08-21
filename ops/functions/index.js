const functions = require('@google-cloud/functions-framework');
const { IncomingWebhook } = require('@slack/webhook');
const JSON5 = require('json5')
const url = process.env.SLACK_WEBHOOK_URL;

const webhook = new IncomingWebhook(url);


module.exports = functions.http('discordAlerts', (request, response) => {

  
  // const tag = request.body.queryResult.intent

  // let jsonResponse = {};
    //fulfillment response to be sent to the agent if the request tag is equal to "welcome tag"
  // errAlert = parseEvent(request.data)

  
  message = createDiscordMessage(request.body)
  console.log(request.body)
  webhook.send(message)



  // response.end()


});

const createDiscordMessage = (error) => {
  var embeds = []
  let message = {
    "text": "GCP Alerts",
    "blocks": [
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": "ERR:"  + error
        }

      }
    ],
    "mrkdwn": true,
    "attachments": [
      {
        "title": error.incident.condition.displayName,
        "title_link":  error.incident.url,
        "fields": [{
        "title": error.incident.state,
        "value": error.incident.summary
      }]
  }
]
};
embeds.push({
  title: "GCP error",
  description: "error"})

  
message.embeds = embeds;
console.log(message)
return message;
}


