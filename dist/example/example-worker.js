var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define(function(require, exports, module) {
  var ExampleWorker, SeaWorker;
  SeaWorker = require('../worker');
  console.log(JSON.stringify(seajs.data, null, 4));
  ExampleWorker = (function(_super) {
    __extends(ExampleWorker, _super);

    function ExampleWorker() {
      return ExampleWorker.__super__.constructor.apply(this, arguments);
    }

    ExampleWorker.worker_service('echo', function(msg) {
      console.log("Browser send: " + msg);
      return msg;
    });

    ExampleWorker.worker_service('add', function(a, b) {
      var adder;
      console.log("Browser want add " + a + ", " + b);
      adder = require('./adder');
      return adder(a, b);
    });

    return ExampleWorker;

  })(SeaWorker);
  SeaWorker.register(ExampleWorker);
  return module.exports = ExampleWorker;
});
