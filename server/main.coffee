Meteor.startup ->
  runMigrations()

  for batch_name, _ of Meteor.settings.batches
    find_new_uploads_from_slack(batch_name)
    console.log "publishing #{batch_name}"
    Meteor.publish "photos", -> Photos.find()

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

find_new_uploads_from_slack = (batch_name=BATCH_NAME) ->
  messages = channel_history_from_slack(batch_name)
  console.log "looking for new uploads..."
  if messages?
    file_uploads = (m for m in messages when m.subtype is "file_share")
    for upload in file_uploads
      uid = "slack_#{upload.file.id}"
      console.log "found a file: #{upload.file.id}"
      Photos.upsert({uid},
                    {uid, slack: upload.file, photo_url: upload.file.url, batch: batch_name})
    # TODO(AMK) - use collection FS, save photos
    console.log "done"
  else
    console.log "could not load channel history for photos in #{batch_name}"

channel_history_from_slack = (batch_name)->
  channel_details = Meteor.settings.batches[batch_name]
  result = HTTP.get "https://slack.com/api/channels.history", params: channel_details
  result.data.messages
