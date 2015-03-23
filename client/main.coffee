
Photos = new Meteor.Collection("photos")
Meteor.startup ->
  Router.route '/', ->
    photos = Photos.find().fetch()
    window.photos = photos
    @render 'gallery',
      data: {photos}

Template.gallery.onRendered ->
  window.setTimeout((->
    $('#gallery').justifiedGallery({
      rowHeight: 200,
      lastRow: 'justify',
      margins: 15
    })), 500)

