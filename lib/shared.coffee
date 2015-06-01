@BATCH_NAME = Meteor.settings.public["current-batch-name"]
@Photos = new Meteor.Collection("photos")

# make developing easier
if Meteor.isClient and "localhost" in window.location.href
  window.Photos = @Photos
