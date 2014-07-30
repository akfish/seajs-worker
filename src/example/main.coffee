define (require, exports, module) ->
  console.log 'Yo!'
  console.log 'Whats Up!'
  Worker = require './example-worker'
  sea_opts =
    base: '../dist'
  Worker.config sea_opts
  worker = new Worker()
  console.log "Test 1: worker.echo('whatever'), using callback"
  worker.echo "whatever", (err, msg) ->
    console.log "Finished 1. Worker echos: #{msg}"
  console.log "Test 2: worker.add(100 + 1), using callback"
  worker.add 100, 1, (err, sum) ->
    console.log "Finished 2. Worker adds to #{sum}"
  console.log "Test 3: worker.echo('-_-|||||'), using promise"
  worker.echo "-_-|||||"
    .then (msg) -> console.log "Finished 3. Worker echos: #{msg}"
  console.log "Test 4: worker.add(1 + 2), using promise"
  worker.add 1, 2
    .then (sum) -> console.log "Finished 4. Worker adds to #{sum}"
