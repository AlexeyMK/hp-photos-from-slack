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
            #{Math.round result.currently.temperature}&deg; and #{result.currently.summary}
            #{result.currently.precipProbability * 100}% chance of #{if result.currently.precipType? then result.currently.precipType else 'precipitation'}
          """