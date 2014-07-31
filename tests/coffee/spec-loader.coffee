define (require, exports, module) ->
  console.log "Loading specs..."
  # Config SeaWorker
  # SeaWorker = require 'worker'

  # Load specs here
  require './basic'
  require './example'
  require './map-reduce'
  return
