define (require, exports, module) ->
  test_exists = (worker_class) ->
    expect(typeof worker_class).toBe 'function'
    worker = new worker_class()
    expect(worker).not.toBe null
    return worker
  test_echo_callback = (worker, done) ->
    worker.echo "-_-", (err, msg) ->
      expect(err).toBe null
      expect(msg).toBe "-_-"
      done()
  test_add_callback = (worker, done) ->
    worker.add 100, 3, (err, msg) ->
      expect(err).toBe null
      expect(msg).toBe 103
      done()
  test_echo_promise = (worker, done) ->
    worker.echo "T_T"
      .then (msg) -> expect(msg).toBe "T_T"
      .fail (err) -> expect("Failure (#{err})").toBe 'not an option'
      .done -> done()
  test_add_promise = (worker, done) ->
    worker.add 5, 4
      .then (msg) -> expect(msg).toBe 9
      .fail (err) -> expect("Failure (#{err})").toBe 'not an option'
      .done -> done()

  describe "Simple worker", ->
    Worker = require 'example/example-worker'
    worker = null
    it "exists", ->
      worker = test_exists Worker
    it "echos", (done) ->
      test_echo_callback worker, done
    it "adds", (done) ->
      test_add_callback worker, done
    it "echos (promise)", (done) ->
      test_echo_promise worker, done
    it "adds (promise)", (done) ->
      test_add_promise worker, done

  describe "Simple worker (JavaScript Implementation)", ->
    Worker = require 'example/js-worker'
    worker = null
    it "exists", ->
      worker = test_exists Worker
    it "echos", (done) ->
      test_echo_callback worker, done
    it "adds", (done) ->
      test_add_callback worker, done
    it "echos (promise)", (done) ->
      test_echo_promise worker, done
    it "adds (promise)", (done) ->
      test_add_promise worker, done
  return
