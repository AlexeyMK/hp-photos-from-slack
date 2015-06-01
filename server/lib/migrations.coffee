@runMigrations = ->
  console.log "Running migrations..."
  Photos.update({ "batch" : { "$exists" : false } },
                {$set: {batch: "2015-seasia" }},
                {multi: true})
  console.log "migrations done."
