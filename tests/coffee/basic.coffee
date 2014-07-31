define (require, exports, module) ->
  console.log 'Basic test loaded'
  describe "Test Enviroment", ->
    it "has sea.js", ->
      expect(typeof seajs).toBe 'object'
    it "has Q", ->
      expect(typeof Q).toBe 'function'
    it "has SeaWorker", ->
      SeaWorker = require 'worker'
      expect(typeof SeaWorker).toBe 'function'
  return
