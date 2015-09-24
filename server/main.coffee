Meteor.startup ->
  runMigrations()

  find_new_uploads_from_slack()
  Meteor.publish "photos", (batch=BATCH_NAME) -> Photos.find({batch})

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
  for batch, _ of Meteor.settings.batches
    messages = channel_history_from_slack(batch)
    console.log "looking for new uploads for #{batch}..."
    if messages?
      file_uploads = (m for m in messages when m.subtype is "file_share")
      for upload in file_uploads
        uid = "slack_#{upload.file.id}"
        console.log "found a file: #{upload.file.id}"
        Photos.upsert({uid},
                      {uid, slack: upload.file, photo_url: upload.file.url, batch: batch})
    # TODO(AMK) - use collection FS, save photos
      console.log "done"
    else
      console.log "could not load channel history for photos in #{batch}"

channel_history_from_slack = (batch_name) ->
  channel_details = Meteor.settings.batches[batch_name]
  result = HTTP.get "https://slack.com/api/channels.history", params: channel_details
  result.data.messages
