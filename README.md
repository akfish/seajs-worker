# seajs-worker

Seamless & Modular Web Worker

## Motivation

Working with web workers can be painful sometimes.

The worker script has to be in a separate file/blob
and communicate with browser script via messages:

```js
// worker.js
console.log("Yo, I am a worker");

self.onmessage = function (e) {
  if (e.data == 'something') {
    // Do stuff
    self.postMessage "stuff";  
  }
};
```

```js
// browser.js
var worker = new Worker('worker.js');
worker.onmessage = function (e) {
  console.log("Worker says: " + e.data);
}
```

The code can easily become too messy to maintain as application's complexity grows.

Sea.js acquired web worker support from pull request [#1279](https://github.com/seajs/seajs/pull/1279),
which enables developer to use `importScript` to load sea.js in a web worker context and then `require`
other sea.js modules.

This sea.js plugin makes it even easier by managing all low level web workers detials for developers.

## Example

Using seajs-worker is simple. It works the best with CoffeeScript syntax. There are only 2 steps.

Step 1 - create a worker class

```coffee
# worker.coffee
define (require, exports, module) ->
  # This plugin comes as a CMD module and can be loaded with sea.js
  SeaWorker = require 'path/to/sea/worker'
  # `SeaWorker` is the base class for all workers
  class FooWorker extends SeaWorker
    # Worker_service is a web worker method that can be called from browser side
    # It runs in the worker
    @worker_service 'echo', (msg) ->
      return msg
    @worker_service 'add', (a, b) ->
      # You can load whatever sea.js module you want
      adder = require './adder'
      return adder a, b

  # Register the worker
  SeaWorker.register FooWorker

  # Export the class
  module.exports = FooWorker
```

Step 2 - use the worker

```coffee
# any-browser-script.cofee
define (require, exports, module) ->
  # Require worker class
  Worker = require './worker'

  # Config sea.js in worker (same as seajs.config)
  Worker.config
    base: 'path/to/base'

  # Create worker instance
  worker = new Worker()

  # Call worker service directly, result or error is returned with callback
  worker.echo "whatever", (err, msg) ->
    if err?
      console.error err
      return
    console.log "Worker echos: #{msg}"

  # If Q is loaded, service call returns a promise
  worker.echo "whatever"
    .then (msg) -> console.log "Worker echos: #{msg} as promised"
  worker.add 100, 1
    .then (sum) -> console.log "Worker adds: #{sum} as promised"
```

That's all one have to do. Simple as that.

See `example` folder for complete code.
