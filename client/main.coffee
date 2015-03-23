
Photos = new Meteor.Collection("photos")
Meteor.startup ->
  Router.route '/', ->
    photos = Photos.find({}, sort: {"slack.timestamp": -1}).fetch()
    @render 'gallery',
      data: {photos}

Template.gallery.onRendered ->
  @autorun ->
    # creating this session thing only so that this function
    # is properly reactive
    photo_count = Photos.find().count()
    if photo_count isnt Session.get('photo_count')
      Session.set('photo_count', photo_count)
      setTimeout((->
        $('#gallery').justifiedGallery({
          rowHeight: 200,
          lastRow: 'nojustify',
          margins: 15
      })), 250)
