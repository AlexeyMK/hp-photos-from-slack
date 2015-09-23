runningAsIframe = ->
  window != window.top

addIframeClass = ->
  $('body').addClass('as-iframe')

Meteor.startup ->
  addIframeClass() if runningAsIframe()
  Router.route '/', ->
    Meteor.subscribe("photos")
    batch = @params.query.batch or BATCH_NAME
    photos = Photos.find({batch}, sort: {"slack.timestamp": -1})
    @render 'gallery',
      data: {photos}

Template.gallery.helpers
  photo_title: ->
    @slack.title unless \
      _.any(["jpg", "jpeg", "png", "gif", "upload"],
            (badEnding) => @slack.title.toLowerCase().endsWith(badEnding)) or
      @slack.title.startsWith("DSC")

updateJustifiedGallery = ->
  $('#gallery').justifiedGallery({
    rowHeight: 200,
    lastRow: 'nojustify',
    margins: 15})

applySwipebox = ->
  $('#gallery a').swipebox
    hideBarsDelay: 0
    afterOpen: -> $('#gallery').hide()  # gallery was causing scrollbars under swipebox
    afterClose: -> $('#gallery').show()

updateGallery = ->
  updateJustifiedGallery()
  applySwipebox()

Template.gallery.onRendered ->
  @autorun ->
    Photos.find().count()  # solely to force reactivity in the method
    updateGallery()
