
Photos = new Meteor.Collection("photos")
Meteor.startup ->
  Router.route '/', ->
    photos = Photos.find().fetch()
    window.photos = photos
    @render 'gallery',
      data: {photos}

Template.gallery.onRendered(->
  $('#gallery').justifiedGallery({
    rowHeight: 270,
    lastRow: 'justify',
    margins: 15,
  })
)

