
Photos = new Meteor.Collection("photos")
Meteor.startup ->
  Router.route '/', ->
    photos = Photos.find().fetch()
    window.photos = photos
    @render 'gallery',
      data: {photos}

