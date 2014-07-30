define (require, exports, module) ->
  SeaWorker = require '../worker'
  console.log JSON.stringify seajs.data, null, 4
  class ExampleWorker extends SeaWorker
    @worker_service 'echo', (msg) ->
      console.log "Browser send: #{msg}"
      return msg

    @worker_service 'add', (a, b) ->
      console.log "Browser want add #{a}, #{b}"
      adder = require './adder'
      return adder a, b

  SeaWorker.start_worker ExampleWorker

  module.exports = ExampleWorker
