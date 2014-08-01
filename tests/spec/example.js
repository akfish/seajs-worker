define(function(require, exports, module) {
  var test_add_callback, test_add_promise, test_echo_callback, test_echo_promise, test_exists;
  test_exists = function(worker_class) {
    var worker;
    expect(typeof worker_class).toBe('function');
    worker = new worker_class();
    expect(worker).not.toBe(null);
    return worker;
  };
  test_echo_callback = function(worker, done) {
    return worker.echo("-_-", function(err, msg) {
      expect(err).toBe(null);
      expect(msg).toBe("-_-");
      return done();
    });
  };
  test_add_callback = function(worker, done) {
    return worker.add(100, 3, function(err, msg) {
      expect(err).toBe(null);
      expect(msg).toBe(103);
      return done();
    });
  };
  test_echo_promise = function(worker, done) {
    return worker.echo("T_T").then(function(msg) {
      return expect(msg).toBe("T_T");
    }).fail(function(err) {
      return expect("Failure (" + err + ")").toBe('not an option');
    }).done(function() {
      return done();
    });
  };
  test_add_promise = function(worker, done) {
    return worker.add(5, 4).then(function(msg) {
      return expect(msg).toBe(9);
    }).fail(function(err) {
      return expect("Failure (" + err + ")").toBe('not an option');
    }).done(function() {
      return done();
    });
  };
  describe("Simple worker", function() {
    var Worker, worker;
    Worker = require('example/example-worker');
    worker = null;
    it("exists", function() {
      return worker = test_exists(Worker);
    });
    it("echos", function(done) {
      return test_echo_callback(worker, done);
    });
    it("adds", function(done) {
      return test_add_callback(worker, done);
    });
    it("echos (promise)", function(done) {
      return test_echo_promise(worker, done);
    });
    return it("adds (promise)", function(done) {
      return test_add_promise(worker, done);
    });
  });
  describe("Simple worker (JavaScript Implementation)", function() {
    var Worker, worker;
    Worker = require('example/js-worker');
    worker = null;
    it("exists", function() {
      return worker = test_exists(Worker);
    });
    it("echos", function(done) {
      return test_echo_callback(worker, done);
    });
    it("adds", function(done) {
      return test_add_callback(worker, done);
    });
    it("echos (promise)", function(done) {
      return test_echo_promise(worker, done);
    });
    return it("adds (promise)", function(done) {
      return test_add_promise(worker, done);
    });
  });
});
