Meteor-based photo gallery that reads from a Slack channel.

Originally built for and used by [Hacker Paradise](http://hackerparadise.org).

<img src="/docs/screenshot-in-action.png"></img>

### How to add a new slack Team

I'm assuming you've run meteor service before. If not, go to meteor.com and install Meteor. It's good time.

#### 1. Get yourself an API token
Go to https://api.slack.com/web and click `generate token` next to your team.  It'll look something like `xoxp-...`.

Hold on to that token.

#### 2. Find your channel ID.
Usually, we use #photos for our photos channel, but you can use whichever you like.  Create the channel if you haven't already.

We'll need to find that channel's internal slack ID. Go to https://api.slack.com/methods/channels.list/test and hit 'Test Method'.  In the resulting JSON, find your channel's name. It's ID will be nearby and look something like `C0...`.  Hold on to the channel name.

#### 3. Update (or create) settings.json

Here's what your `settings.json` file needs to look like:

```json
{
  "public": {
    "current-batch-name": "YOUR_TEAM_GOES_HERE"
  },

  "batches": {
    "YOUR_TEAM_GOES_HERE": { "token": "YOUR_TOKEN_FROM_STEP_1",
      "channel": "YOUR CHANNEL ID FROM STEP 2"
    }
  }
}
```

If you have multiple teams you support, you may have other batches in the `batches` section.

#### 4. Try locally
Add a photo or two to your channel.

Run locally via `meteor --settings=settings.json`

Then, go to `http://localhost:3000/force-refresh`, in your browser, which will trigger the photos to get loaded locally.

Make sure you get pretty photos.

#### 5. Deploy to meteor.com
Once things work locally, you're ready to `meteor deploy YOURSECRETSITENAME.meteor.com --settings=settings.json`.


#### 6. Set up webhooks from Slack.
To get Slack to add new photos whenever they get created rather than update manually via `/force-refresh`:

  - Go to https://YOUR_TEAM_SUBDOMAIN.slack.com/services/new.
  - Add a new 'outgoing webhook'
    - Set Channel to the channel you chose above
    - Set the Descriptive Label to "Slack Photo Gallery" (or anything you'd like)
    - Set the URL to be `http://YOURSECRETSITENAME.meteor.com/new-message`
  - Save.

#### 6. (Optional) support for old/non-default teams
Users from the non-default batch should still be able to access their photos at http://YOURSECRETSITENAME.meteor.com/?batch=OLD_BATCH_NAME.
