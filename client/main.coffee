runningAsIframe = ->
  window != window.top

addIframeClass = ->
  $('body').addClass('as-iframe')

Photos = new Meteor.Collection("photos")
Meteor.startup ->
  addIframeClass() if runningAsIframe()
  Router.route '/', ->
    photos = Photos.find({}, sort: {"slack.timestamp": -1})
    @render 'gallery',
      data: {photos}

Template.gallery.helpers
  photo_title: ->
    @slack.title unless \
      _.any(["jpg", "png", "upload"],
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

updateGallery = ->
  updateJustifiedGallery()
  applySwipebox()

Template.gallery.onRendered ->
  @autorun ->
    Photos.find().count()  # solely to force reactivity in the method
    updateGallery()
