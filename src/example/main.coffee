define (require, exports, module) ->
  console.log 'Yo!'
  console.log 'Up!'
  Worker = require './example-worker'
  sea_opts =
    base: '../dist'
  worker_url = location.href + '../dist/example/example-worker'
  worker = new Worker worker_url, sea_opts
  console.log worker
  console.log "Generated worker source:"
  console.log worker.src
  console.log "Test 1: worker.echo('whatever')"
  worker.echo "whatever", (err, msg) ->
    console.log "Worker echos: #{msg}"
  console.log "Test 2: worker.add(1 + 2)"
  console.log "An adder module is loaded with sea.js within worker"
  worker.add 100, 1, (err, result) ->
    console.log "Worker adds to #{result}"
