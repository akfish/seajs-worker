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
  console.log("Test 1: worker.echo('whatever'), using callback");
  worker.echo("whatever", function(err, msg) {
    return console.log("Finished 1. Worker echos: " + msg);
  });
  console.log("Test 2: worker.add(100 + 1), using callback");
  worker.add(100, 1, function(err, sum) {
    return console.log("Finished 2. Worker adds to " + sum);
  });
  console.log("Test 3: worker.echo('-_-|||||'), using promise");
  worker.echo("-_-|||||").then(function(msg) {
    return console.log("Finished 3. Worker echos: " + msg);
  });
  console.log("Test 4: worker.add(1 + 2), using promise");
  return worker.add(1, 2).then(function(sum) {
    return console.log("Finished 4. Worker adds to " + sum);
  });
});
