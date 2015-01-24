Meteor.startup ->
  Router.map ->
    @route 'weather',
      where: 'server',
      path: "/weather/today"
      action: ->
        #Currently hard-code to return results for Chicago, IL
        that = @
        Meteor.call 'fetchWeather', '41.8819, 87.6278', (error, result) ->
          console.log 'weather-data', result if result
          console.log 'weather-data-error', error if error
          return if error

          # Create cute summary art
          summaryGraphic = ->
            switch result.currently.icon
              when 'snow'
                return '*.*.*.*.*.*.*'
              when 'rain', 'sleet'
                return '/////////////'
              when 'wind'
                return '~ ~ ~ ~ ~ ~ ~'
              when 'fog'
                return 'o O o O o O o'
              when 'cloudy', 'partly-cloudy-day', 'partly-cloudy-night'
                return 'o O o O o O o'
              else
                return ''

          that.response.writeHead(200, {'Content-Type': 'text/html'})
          that.response.end """
            Current Weather for Chicago, IL
            #{summaryGraphic()}
            #{Math.round result.currently.temperature}° and #{result.currently.summary}
            #{result.currently.precipProbability * 100}% chance of #{if result.currently.precipType? then result.currently.precipType else 'precipitation'}
            http://forecast.io/#/f/41.8956,-87.6354
          """

    @route 'ctatrain',
      where: 'server',
      path: "/cta/train"
      action: ->
        that = @
        # Currently hard-code to return results for Chicago and Franklin
        station_id = 40710
        station_name = 'Chicago & Franklin'
          
        Meteor.call 'fetchTrains', station_id, (error, result) ->
          result = xml2js.parseStringSync result
          console.log 'ctatrain-data', result if result
          console.log 'ctatrain-data-error', error if error
          return if error

          stops = ''
          _.each result.ctatt.eta, (stop) ->
            time = moment(stop.arrT[0], 'YYYYMMDD HH:mm:ss').fromNow(true)
            color = ->
              switch stop.rt[0]
                when 'Brn'
                  return 'Brown'
                when 'Red'
                  return 'Red'
                when 'Blue'
                  return 'Blue'
                when 'G'
                  return 'Green'
                when 'Org'
                  return 'Orange'
                when 'P'
                  return 'Purple'
                when 'Pink'
                  return 'Pink'
                when 'Y'
                  return 'Yellow'
                else
                  return stop.rt
            stops += """
              #{time}: #{color()} to #{stop.destNm[0]}

            """

          that.response.writeHead(200, {'Content-Type': 'text/html'})
          that.response.end """
            ++++++++++++++
            Train Schedule for #{station_name}
            #{stops}
          """