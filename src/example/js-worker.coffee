define (require, exports, module) ->
  SeaWorker = require '../worker'

  `
  var JsWorker = SeaWorker.extend();

  JsWorker.worker_service('echo', function (msg) {
    return msg;
  });

  JsWorker.worker_service('add', function (a, b) {
    var adder = require('./adder');
    return adder(a, b);
  });

  SeaWorker.register(JsWorker);
  `

  module.exports = JsWorker
