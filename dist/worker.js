define(function(require, exports, module) {
  var SeaWorker, is_worker;
  is_worker = typeof importScripts === 'function';
  console.log("Running in worker: " + is_worker);
  console.log(JSON.stringify(seajs.data, null, 4));
  Function.prototype.worker_method = function(name, fn) {
    if (!is_worker || typeof fn !== 'function') {
      return;
    }
    return this.prototype[name] = fn;
  };
  Function.prototype.browser_method = function(name, fn) {
    if (is_worker || typeof fn !== 'function') {
      return;
    }
    return this.prototype[name] = fn;
  };
  Function.prototype.worker_service = function(name, fn) {
    if (typeof fn !== 'function') {
      return;
    }
    if (is_worker) {
      console.log("Register worker service " + name + " in worker");
      return this.prototype[name] = fn;
    } else {
      console.log("Register worker service " + name + " in browser");
      return this.prototype[name] = function() {
        var args, cb, n;
        n = arguments.length;
        cb = arguments[n - 1];
        args = Array.prototype.slice.call(arguments, 0, n - 1);
        return this.invoke(name, args, cb);
      };
    }
  };
  SeaWorker = (function() {
    SeaWorker.worker_method('foo', function() {
      return console.log('In worker');
    });

    SeaWorker.browser_method('foo', function() {
      return console.log('In browser');
    });

    SeaWorker.worker_method('init', function() {
      return self.onmessage = (function(_this) {
        return function(e) {
          var args, err, id, name, result;
          name = e.data.service;
          args = e.data.payload;
          id = e.data.id;
          try {
            result = _this[name].apply(void 0, args);
            return self.postMessage({
              service: name,
              id: id,
              result: result
            });
          } catch (_error) {
            err = _error;
            return self.postMessage({
              service: name,
              id: id,
              error: err.toString()
            });
          }
        };
      })(this);
    });

    SeaWorker.browser_method('init', function(worker_url, sea_opts) {
      var this_path;
      this.cb = {};
      this.id = 0;
      this.src = "importScripts('" + seajs.data.loader + "');\n";
      if (sea_opts != null) {
        this.src += "seajs.config(" + (JSON.stringify(sea_opts)) + ");\n";
      }
      this_path = worker_url;
      console.log(new Error().stack);
      this.src += "seajs.use('" + this_path + "');\n";
      this._blob = new Blob([this.src]);
      this._blob_url = window.URL.createObjectURL(this._blob);
      this._worker = new Worker(this._blob_url);
      return this._worker.onmessage = (function(_this) {
        return function(e) {
          var _ref;
          if (((_ref = e.data) != null ? _ref.service : void 0) != null) {
            return _this.handle(e.data);
          }
        };
      })(this);
    });

    SeaWorker.browser_method('handle', function(data) {
      var c;
      c = this.cb[data.id];
      delete this.cb[data.id];
      if (c.service !== data.service) {
        throw "Expect callback id=" + data.id + " for service " + c.service + ". Got " + data.service;
      }
      return typeof c.fn === "function" ? c.fn(data.error, data.result) : void 0;
    });

    SeaWorker.browser_method('invoke', function(service, args, callback) {
      this._worker.postMessage({
        service: service,
        payload: args,
        id: this.id
      });
      this.cb[this.id] = {
        service: service,
        fn: callback
      };
      return this.id++;
    });

    function SeaWorker(worker_url, sea_opts) {
      this.init(worker_url, sea_opts);
    }

    SeaWorker.start_worker = function(worker_class) {
      var worker;
      if (!is_worker) {
        return;
      }
      return worker = new worker_class();
    };

    return SeaWorker;

  })();
  return module.exports = SeaWorker;
});
