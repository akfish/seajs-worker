define (require, exports, module) ->
  describe "Simple worker", ->
    Worker = require 'example/example-worker'
    worker = null
    it "exists", ->
      expect(typeof Worker).toBe 'function'
      worker = new Worker()
      expect(worker).not.toBe null
    it "echos", (done) ->
      worker.echo "-_-", (err, msg) ->
        expect(err).toBe null
        expect(msg).toBe "-_-"
        done()
    it "adds", (done) ->
      worker.add 100, 3, (err, msg) ->
        expect(err).toBe null
        expect(msg).toBe 103
        done()
    it "echos (promise)", (done) ->
      worker.echo "T_T"
        .then (msg) -> expect(msg).toBe "T_T"
        .fail (err) -> expect("Failure (#{err})").toBe 'not an option'
        .done -> done()
    it "adds (promise)", (done) ->
      worker.add 5, 4
        .then (msg) -> expect(msg).toBe 9
        .fail (err) -> expect("Failure (#{err})").toBe 'not an option'
        .done -> done()
  return
