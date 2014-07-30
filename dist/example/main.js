define(function(require, exports, module) {
  var Worker, sea_opts, worker;
  console.log('Yo!');
  console.log('Whats Up!');
  Worker = require('./example-worker');
  sea_opts = {
    base: '../dist'
  };
  worker = new Worker(sea_opts);
  console.log("Test 1: worker.echo('whatever')");
  worker.echo("whatever", function(err, msg) {
    return console.log("Worker echos: " + msg);
  });
  console.log("Test 2: worker.add(1 + 2)");
  console.log("An adder module is loaded with sea.js within worker");
  return worker.add(100, 1, function(err, result) {
    return console.log("Worker adds to " + result);
  });
});
