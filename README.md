# Slacker

A endpoint api for Slack commands

----

## Available Endpoints

- `/weather/today`: Current weather for Chicago, Illinois
- `/cta/train`: Current CTA train schedule for the Chicago & Franklin stop

## Getting Started


```
# Install Meteor
curl https://install.meteor.com | /bin/sh

# Start the App
meteor
```

### Environment Variables

The project requires the following environment variables to be set. You can set these in your PaaS provider (e.g. Modulus.io) or by adding a file called `api_keys.coffee` to `/server`, with contents similar to the following (this file should _not_ be kept under version control for security):

```
process.env.FORECAST_API_KEY = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXX'
process.env.CTA_TRAIN_TRACKER_API_KEY = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXX'
```

## Deployment

### …on meteor.com

```
meteor login
meteor deploy slacker
```

### …on modulus.io

The project can also be deployed via [Modulus](https://modulus.io):

```
# While in this project directory

npm install -g modulus
modulus login
...
modulus deploy
```