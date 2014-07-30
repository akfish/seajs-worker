define(function(require, exports, module) {
  var SeaWorker;
  return SeaWorker = (function() {
    function SeaWorker(sea_url, sea_opts, services) {
      var fn, name, _ref;
      this.services = services;
      this.cb = {};
      this.id = 0;
      this.src = "importScripts('" + sea_url + "');\n";
      if (sea_opts != null) {
        this.src += "seajs.config(" + (JSON.stringify(sea_opts)) + ");\n";
      }
      this.src += "define(function(require, exports, module) {\n";
      this.src += 'console.log("-_-");\nvar _services = {};\nself.onmessage = function (e) {\n  var name = e.data.service;\n  var args = e.data.payload;\n  var id = e.data.id;\n\n  try {\n    var result = _services[name].apply(undefined, args);\n    self.postMessage({service: name, id: id, result: result});\n  } catch (err) {\n    console.error(err);\n    self.postMessage({service: name, id: id, error: err.toString()});\n  }\n\n};\n';
      _ref = this.services;
      for (name in _ref) {
        fn = _ref[name];
        this.src += "_services['" + name + "'] = " + (fn.toString()) + ";\n";
        this[name] = (function(_this) {
          return function() {
            var args, cb, n;
            n = arguments.length;
            cb = arguments[n - 1];
            args = Array.prototype.slice.call(arguments, 0, n - 1);
            _this.invoke(name, args, cb);
            return _this.cb = {};
          };
        })(this);
      }
      this.src += "});";
      this._blob = new Blob([this.src]);
      this._blob_url = window.URL.createObjectURL(this._blob);
      this._worker = new Worker(this._blob_url);
      this._worker.onmessage = (function(_this) {
        return function(e) {
          var _ref1;
          if (((_ref1 = e.data) != null ? _ref1.service : void 0) != null) {
            return _this.handle(e.data);
          }
        };
      })(this);
    }

    SeaWorker.prototype.handle = function(data) {
      var c;
      c = this.cb[data.id];
      delete this.cb[data.id];
      if (c.service !== data.service) {
        throw "Expect callback id=" + data.id + " for service " + c.service + ". Got " + data.service;
        return typeof c.fn === "function" ? c.fn(data.error, data.result) : void 0;
      }
    };

    SeaWorker.prototype.invoke = function(service, args, callback) {
      this._worker.postMessage({
        service: service,
        payload: args,
        id: this.id
      });
      this.cb[this.id] = {
        service: service,
        fn: callback
      };
      this.id++;
      return module.exports = SeaWorker;
    };

    return SeaWorker;

  })();
});
