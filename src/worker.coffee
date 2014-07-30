define (require, exports, module) ->
  is_worker = typeof importScripts == 'function'
  console.log "Running in worker: #{is_worker}"
  console.log JSON.stringify seajs.data, null, 4
  Function::worker_method = (name, fn) ->
    if not is_worker or typeof fn != 'function'
      return
    @::[name] = fn

  Function::browser_method = (name, fn) ->
    if is_worker or typeof fn != 'function'
      return
    @::[name] = fn

  Function::worker_service = (name, fn) ->
    if typeof fn != 'function'
      return
    if is_worker
      console.log("Register worker service #{name} in worker")
      @::[name] = fn
    else
      console.log("Register worker service #{name} in browser")
      @::[name] = ->
        n = arguments.length
        cb = arguments[n - 1]
        args = Array::slice.call(arguments, 0, n - 1)
        @invoke name, args, cb

  class SeaWorker
    @worker_method 'foo', ->
      console.log 'In worker'
    @browser_method 'foo', ->
      console.log 'In browser'

    @worker_method 'init', ->
      # Message handler
      self.onmessage = (e) =>
        name = e.data.service
        args = e.data.payload
        id = e.data.id

        try
          result = @[name].apply undefined, args
          self.postMessage
            service: name
            id: id
            result: result
        catch err
          self.postMessage
            service: name
            id: id
            error: err.toString()

    @browser_method 'init', (worker_url, sea_opts) ->
      # Data members
      @cb = {}
      @id = 0
      # Set up sea.js in worker
      @src = "importScripts('#{seajs.data.loader}');\n"
      if sea_opts?
        @src += "seajs.config(#{JSON.stringify(sea_opts)});\n"

      # TODO: find path of this script
      this_path = worker_url
      console.log new Error().stack
      @src += "seajs.use('#{this_path}');\n"

      # Create worker
      @_blob = new Blob [@src]
      @_blob_url = window.URL.createObjectURL @_blob
      @_worker = new Worker @_blob_url
      @_worker.onmessage = (e) =>
        if e.data?.service?
          @handle e.data

    @browser_method 'handle', (data) ->
      c = @cb[data.id]
      delete @cb[data.id]
      if c.service != data.service
        throw "Expect callback id=#{data.id} for service #{c.service}. Got #{data.service}"
      c.fn? data.error, data.result

    @browser_method 'invoke', (service, args, callback) ->
      @_worker.postMessage
        service: service
        payload: args
        id: @id
      @cb[@id] =
        service: service
        fn: callback
      @id++

    constructor: (worker_url, sea_opts) ->
      @init worker_url, sea_opts

    @start_worker: (worker_class)->
      if not is_worker
        return

      worker = new worker_class()

  module.exports = SeaWorker
