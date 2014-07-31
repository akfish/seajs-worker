define(function(require, exports, module) {
  describe("Simple worker", function() {
    var Worker, worker;
    Worker = require('example/example-worker');
    worker = null;
    it("exists", function() {
      expect(typeof Worker).toBe('function');
      worker = new Worker();
      return expect(worker).not.toBe(null);
    });
    it("echos", function(done) {
      return worker.echo("-_-", function(err, msg) {
        expect(err).toBe(null);
        expect(msg).toBe("-_-");
        return done();
      });
    });
    it("adds", function(done) {
      return worker.add(100, 3, function(err, msg) {
        expect(err).toBe(null);
        expect(msg).toBe(103);
        return done();
      });
    });
    it("echos (promise)", function(done) {
      return worker.echo("T_T").then(function(msg) {
        return expect(msg).toBe("T_T");
      }).fail(function(err) {
        return expect("Failure (" + err + ")").toBe('not an option');
      }).done(function() {
        return done();
      });
    });
    return it("adds (promise)", function(done) {
      return worker.add(5, 4).then(function(msg) {
        return expect(msg).toBe(9);
      }).fail(function(err) {
        return expect("Failure (" + err + ")").toBe('not an option');
      }).done(function() {
        return done();
      });
    });
  });
});
