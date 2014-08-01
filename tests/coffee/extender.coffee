define (require, exports, module) ->
  console.log 'Basic test loaded'
  extend = require 'extender'
  describe "Extender", ->
    it "loads", ->
      expect(typeof extend).toBe 'function'
    it "extends class", ->
      # Define classes
      class SimpleBase
        @extend: extend
        constructor: ->
          @foo = 1
        whatever: ->
          return '-_-'

      # Javascript code
      `
      var Derived = SimpleBase.extend({
        bar: 2,
        add: function(a, b) {
          return a + b;
        }
        });
      var d = new Derived()
      `
      # Assert
      expect(d.foo).toBe 1
      expect(d.bar).toBe 2
      expect(d.whatever()).toBe '-_-'
      expect(d.add(1, 2)).toBe 3

    it "extends class with parameterized constructor", ->
      class ParamBase
        @extend: extend
        constructor: (@foo) ->

      # Javascript code
      `
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
      `
      # Assert
      expect(d.foo).toBe 100
      expect(d.bar).toBe 200
      expect(d.mul()).toBe 100 * 200
    return
  return
