define (require, exports, module) ->
  is_worker = typeof importScripts == 'function'
  console.log "Running in worker: #{is_worker}"
  console.log module.uri
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

    @browser_method 'init', (sea_opts) ->
      # Data members
      @cb = {}
      @id = 0

      # Find launcher script
      this_url = module.uri
      launcher_url = this_url.replace "worker.js", "launcher.js"

      # Payload for initialize worker
      payload =
        sea_url: seajs.data.loader
        opts: sea_opts
        worker_url: @constructor.__sea_mod_uri

      # Create worker
      @_worker = new Worker launcher_url
      @_worker.onmessage = (e) =>
        if e.data?.service?
          @handle e.data
      @_worker.postMessage payload

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

    constructor: (sea_opts) ->
      @init sea_opts

    @register: (worker_class)->
      if not is_worker
        return

      worker = new worker_class()

    # Fired when module is first loaded and executed
    seajs.on "exec", (mod) ->
      # Set module URI for later use
      mod.exports?.__sea_mod_uri = mod.uri

  module.exports = SeaWorker
