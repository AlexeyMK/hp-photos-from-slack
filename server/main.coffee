Photos = new Meteor.Collection("photos")
Meteor.startup ->
  find_new_uploads_from_slack()

  Router.map ->
    @route 'new-message',
      where: 'server'
      path: '/new-message'
      action: ->
        if @request.body.user_name is "slackbot"
          console.log "probably found an attachment"
          find_new_uploads_from_slack()
        console.log JSON.stringify(@request.body)
        @response.writeHead(200, {'Content-Type': 'text/html'})
        @response.end """ received thing """

find_new_uploads_from_slack = ->
  messages = channel_history_from_slack()
  console.log "looking for new uploads..."
  file_uploads = (m for m in messages when m.subtype is "file_share")
  for upload in file_uploads
    uid = "slack_#{upload.file.id}"
    Photos.upsert({uid},
                  {uid, slack: upload.file, photo_url: upload.file.url})
    # TODO(AMK) - use collection FS, save photos

channel_history_from_slack = ->
  token_2014 = "xoxp-2621760647-2628848560-4134392741-2fbf7a"
  token_2015 = "xoxp-3605837514-3610621308-4137017418-3ab355"
  channelid_2014 = "C03MQP5FZ"
  result = HTTP.get "https://slack.com/api/channels.history",
    params:
      token: token_2014
      channel: channelid_2014

  result.data.messages
