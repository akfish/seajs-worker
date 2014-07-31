define(function(require, exports, module) {
  describe("Map-Reduce", function() {
    var Worker;
    Worker = require('example/example-worker');
    it("maps", function(done) {
      var n, _i, _results;
      expect(typeof Worker.map).toBe('function');
      n = 1000;
      return Worker.map((function() {
        _results = [];
        for (var _i = 0; 0 <= n ? _i <= n : _i >= n; 0 <= n ? _i++ : _i--){ _results.push(_i); }
        return _results;
      }).apply(this), 'echo', 10, function(err, result) {
        var i, v, _j, _len;
        console.log("Map Finished");
        console.log(result);
        expect(err).toBe(null);
        expect(result).not.toBe(null);
        expect(result.length).toBe(n + 1);
        for (i = _j = 0, _len = result.length; _j < _len; i = ++_j) {
          v = result[i];
          expect(v).toBe(i);
        }
        return done();
      });
    });
    return it("reduces", function(done) {
      var data, n, sum, v, _i, _j, _len, _results;
      n = 100;
      data = (function() {
        _results = [];
        for (var _i = 0; 0 <= n ? _i <= n : _i >= n; 0 <= n ? _i++ : _i--){ _results.push(_i); }
        return _results;
      }).apply(this);
      sum = 0;
      for (_j = 0, _len = data.length; _j < _len; _j++) {
        v = data[_j];
        sum += v;
      }
      return Worker.reduce(data, (function(state, value, index, d) {
        expect(value).toBe(index);
        expect(d).toBe(data);
        expect(state).not.toBe(null);
        return state + value;
      }), 0, function(err, result) {
        expect(err).toBe(null);
        expect(result).toBe(sum);
        return done();
      });
    });
  });
});
