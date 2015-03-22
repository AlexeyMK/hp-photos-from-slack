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
        console.log JSON.stringify(@request.body)
        @response.writeHead(200, {'Content-Type': 'text/html'})
        @response.end """ received thing """


find_new_uploads_from_slack = ->
  messages = channel_history_from_slack()
  file_uploads = (m for m in messages when m.subtype is "file_share")
  for upload in file_uploads
    Photos.insert(slack: upload.file, photo_url: upload.url)
    # TODO(AMK) - use collection FS, save photos
    # TODO(AMK) prevent self from adding duplicates


channel_history_from_slack = ->
  token_2014 = "xoxp-2621760647-2628848560-4134392741-2fbf7a"
  token_2015 = "xoxp-3605837514-3610621308-4137017418-3ab355"
  channelid_2014 = "C03MQP5FZ"
  result = HTTP.get "https://slack.com/api/channels.history",
    params:
      token: token_2014
      channel: channelid_2014

  result.data.messages


#  Router.map ->
#    @route 'weather',
#      where: 'server',
#      path: "/weather/today"
#      action: ->
#        #Currently hard-code to return results for Chicago, IL
#        that = @
#        Meteor.call 'fetchWeather', '41.8819, 87.6278', (error, result) ->
#          console.log 'weather-data', result if result
#          console.log 'weather-data-error', error if error
#          return if error
#
#          # Create cute summary art
#          summaryGraphic = ->
#            switch result.currently.icon
#              when 'snow'
#                return '*.*.*.*.*.*.*'
#              when 'rain', 'sleet'
#                return '/////////////'
#              when 'wind'
#                return '~ ~ ~ ~ ~ ~ ~'
#              when 'fog'
#                return 'o O o O o O o'
#              when 'cloudy', 'partly-cloudy-day', 'partly-cloudy-night'
#                return 'o O o O o O o'
#              else
#                return ''
#
#          that.response.writeHead(200, {'Content-Type': 'text/html'})
#          that.response.end """
#            Current Weather for Chicago, IL
#            #{summaryGraphic()}
#            #{Math.round result.currently.temperature}° and #{result.currently.summary}
#            #{result.currently.precipProbability * 100}% chance of #{if result.currently.precipType? then result.currently.precipType else 'precipitation'}
#            http://forecast.io/#/f/41.8956,-87.6354
#          """
#
#    @route 'ctatrain',
#      where: 'server',
#      path: "/cta/train"
#      action: ->
#        that = @
#        # Currently hard-code to return results for Chicago and Franklin
#        station_id = 40710
#        station_name = 'Chicago & Franklin'
#
#        Meteor.call 'fetchTrains', station_id, (error, result) ->
#          result = xml2js.parseStringSync result
#          console.log 'ctatrain-data', result if result
#          console.log 'ctatrain-data-error', error if error
#          return if error
#
#          stops = ''
#          _.each result.ctatt.eta, (stop) ->
#            time = moment(stop.arrT[0], 'YYYYMMDD HH:mm:ss').fromNow(true)
#            color = ->
#              switch stop.rt[0]
#                when 'Brn'
#                  return 'Brown'
#                when 'Red'
#                  return 'Red'
#                when 'Blue'
#                  return 'Blue'
#                when 'G'
#                  return 'Green'
#                when 'Org'
#                  return 'Orange'
#                when 'P'
#                  return 'Purple'
#                when 'Pink'
#                  return 'Pink'
#                when 'Y'
#                  return 'Yellow'
#                else
#                  return stop.rt
#            stops += """
#              #{time}: #{color()} to #{stop.destNm[0]}
#
#            """
#
#          that.response.writeHead(200, {'Content-Type': 'text/html'})
#          that.response.end """
#            ++++++++++++++
#            Train Schedule for #{station_name}
#            #{stops}
#          """
