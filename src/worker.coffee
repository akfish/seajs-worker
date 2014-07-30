define (require, exports, module) ->
  class SeaWorker
    constructor: (sea_url, sea_opts, @services) ->
      @cb = {}
      @id = 0
      # Set up sea.js in worker
      @src = "importScripts('#{sea_url}');\n"
      if sea_opts?
        @src += "seajs.config(#{JSON.stringify(sea_opts)});\n"

        # Begin define()
      @src += "define(function(require, exports, module) {\n"

      # Message handler
      @src +=
      '''
      console.log("-_-");
      var _services = {};
      self.onmessage = function (e) {
        var name = e.data.service;
        var args = e.data.payload;
        var id = e.data.id;

        try {
          var result = _services[name].apply(undefined, args);
          self.postMessage({service: name, id: id, result: result});
        } catch (err) {
          console.error(err);
          self.postMessage({service: name, id: id, error: err.toString()});
        }

      };

      '''

      # Register services
      for name, fn of @services
        @src += "_services['#{name}'] = #{fn.toString()};\n"
        @[name] = () =>
          n = arguments.length
          cb = arguments[n - 1]
          args = Array::slice.call(arguments, 0, n - 1)
          @invoke name, args, cb

          @cb = {}

      # End define()
      @src += "});"

      # Create worker
      @_blob = new Blob [@src]
      @_blob_url = window.URL.createObjectURL @_blob
      @_worker = new Worker @_blob_url
      @_worker.onmessage = (e) =>
        if e.data?.service?
          @handle e.data

    handle: (data) ->
      c = @cb[data.id]
      delete @cb[data.id]
      if c.service != data.service
        throw "Expect callback id=#{data.id} for service #{c.service}. Got #{data.service}"
        c.fn? data.error, data.result

    invoke: (service, args, callback) ->
      @_worker.postMessage
        service: service
        payload: args
        id: @id
      @cb[@id] =
        service: service
        fn: callback
      @id++


      module.exports = SeaWorker
