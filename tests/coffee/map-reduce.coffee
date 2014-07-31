define (require, exports, module) ->
  describe "Map-Reduce", ->
    Worker = require 'example/example-worker'
    it "maps", (done) ->
      expect(typeof Worker.map).toBe 'function'
      n = 100
      Worker.map [0..n], 'echo', 10, (err, result) ->
        expect(err).toBe null
        expect(result).not.toBe null
        expect(result.length).toBe n
        for v, i in result
          expect(v).toBe i
        done()
    it "reduces", (done) ->
      n = 100
      data = [0..n]
      sum = 0
      for v in data
        sum += v
      Worker.reduce data, ((state, value, index, d) ->
        expect(value).toBe index
        expect(d).toBe data
        expect(state).not.toBe null
        state += value
        ), 0, (err, result) ->
          expect(err).toBe null
          expect(result).toBe sum
          done()
  return
