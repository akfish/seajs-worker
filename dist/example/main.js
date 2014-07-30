define(function(require, exports, module) {
  var Worker, sea_opts, worker;
  console.log('Yo!');
  console.log('Whats Up!');
  Worker = require('./example-worker');
  sea_opts = {
    base: '../dist'
  };
  Worker.config(sea_opts);
  worker = new Worker();
  console.log("Test 1: worker.echo('whatever')");
  worker.echo("whatever", function(err, msg) {
    return console.log("Worker echos: " + msg);
  });
  console.log("Test 2: worker.add(1 + 2)");
  return worker.add(100, 1, function(err, result) {
    return console.log("Worker adds to " + result);
  });
});
