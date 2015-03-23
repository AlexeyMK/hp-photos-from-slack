Photos = new Meteor.Collection("photos")
Meteor.startup ->
  find_new_uploads_from_slack()

  Router.map ->
    @route 'force-refresh',
      where: 'server'
      path: '/force-refresh'
      action: ->
        console.log "force refresh"
        find_new_uploads_from_slack()
        @response.writeHead(200, {'Content-Type': 'text/html'})
        @response.end """ forcing a refresh """

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
    console.log "found a file: #{upload.file.id}"
    Photos.upsert({uid},
                  {uid, slack: upload.file, photo_url: upload.file.url})
    # TODO(AMK) - use collection FS, save photos
  console.log "done"

channel_history_from_slack = ->
  result = HTTP.get "https://slack.com/api/channels.history", params: Meteor.settings["2015"]
  result.data.messages
