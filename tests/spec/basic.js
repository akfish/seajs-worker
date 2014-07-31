define(function(require, exports, module) {
  console.log('Basic test loaded');
  describe("Test Enviroment", function() {
    it("has sea.js", function() {
      return expect(typeof seajs).toBe('object');
    });
    it("has Q", function() {
      return expect(typeof Q).toBe('function');
    });
    return it("has SeaWorker", function() {
      var SeaWorker;
      SeaWorker = require('worker');
      return expect(typeof SeaWorker).toBe('function');
    });
  });
});
