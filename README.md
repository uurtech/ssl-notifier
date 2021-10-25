# ssl-notifier

## SSL Expire Notification Bash Script

You can deploy it to the Lambda and trigger it on a weekly schedule to prevent forgetting SSL cert updates.

Because sometimes you clients forget to let you know about SSL expire notification emails and you will be the one who is responsilbe for it. 

In this case you can prevent this happening just by running this BASH script on your AWS/GCP/AZURE and send Slack notifications

## how to use it

just update .env file

```
SLACK_WEBHOOK_ENDPOINT=""
URL_LIST="https://google.com https://php.net https://facebook.com"

```
