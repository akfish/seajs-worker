define(function(require, exports, module) {
  var extend;
  console.log('Basic test loaded');
  extend = require('extender');
  describe("Extender", function() {
    it("loads", function() {
      return expect(typeof extend).toBe('function');
    });
    it("extends class", function() {
      var SimpleBase;
      SimpleBase = (function() {
        SimpleBase.extend = extend;

        function SimpleBase() {
          this.foo = 1;
        }

        SimpleBase.prototype.whatever = function() {
          return '-_-';
        };

        return SimpleBase;

      })();
      
      var Derived = SimpleBase.extend({
        bar: 2,
        add: function(a, b) {
          return a + b;
        }
        });
      var d = new Derived()
      ;
      expect(d.foo).toBe(1);
      expect(d.bar).toBe(2);
      expect(d.whatever()).toBe('-_-');
      return expect(d.add(1, 2)).toBe(3);
    });
    it("extends class with parameterized constructor", function() {
      var ParamBase;
      ParamBase = (function() {
        ParamBase.extend = extend;

        function ParamBase(foo) {
          this.foo = foo;
        }

        return ParamBase;

      })();
      
      var ParamDerived = ParamBase.extend({
        constructor: function (foo, bar) {
          // Call super
          this.__super(foo);
          this.bar = bar;
        },
        mul: function () {
          return this.foo * this.bar;
        }
        });
      var d = new ParamDerived(100, 200);
      ;
      expect(d.foo).toBe(100);
      expect(d.bar).toBe(200);
      return expect(d.mul()).toBe(100 * 200);
    });
  });
});
