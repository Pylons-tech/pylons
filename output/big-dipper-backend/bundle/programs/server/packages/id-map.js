(function () {

/* Imports */
var Meteor = Package.meteor.Meteor;
var global = Package.meteor.global;
var meteorEnv = Package.meteor.meteorEnv;
var ECMAScript = Package.ecmascript.ECMAScript;
var EJSON = Package.ejson.EJSON;
var meteorInstall = Package.modules.meteorInstall;
var Promise = Package.promise.Promise;

/* Package-scope variables */
var IdMap;

var require = meteorInstall({"node_modules":{"meteor":{"id-map":{"id-map.js":function module(require,exports,module){

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                //
// packages/id-map/id-map.js                                                                                      //
//                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                  //
module.export({
  IdMap: () => IdMap
});

class IdMap {
  constructor(idStringify, idParse) {
    this._map = new Map();
    this._idStringify = idStringify || JSON.stringify;
    this._idParse = idParse || JSON.parse;
  } // Some of these methods are designed to match methods on OrderedDict, since
  // (eg) ObserveMultiplex and _CachingChangeObserver use them interchangeably.
  // (Conceivably, this should be replaced with "UnorderedDict" with a specific
  // set of methods that overlap between the two.)


  get(id) {
    const key = this._idStringify(id);

    return this._map.get(key);
  }

  set(id, value) {
    const key = this._idStringify(id);

    this._map.set(key, value);
  }

  remove(id) {
    const key = this._idStringify(id);

    this._map.delete(key);
  }

  has(id) {
    const key = this._idStringify(id);

    return this._map.has(key);
  }

  empty() {
    return this._map.size === 0;
  }

  clear() {
    this._map.clear();
  } // Iterates over the items in the map. Return `false` to break the loop.


  forEach(iterator) {
    // don't use _.each, because we can't break out of it.
    for (let [key, value] of this._map) {
      const breakIfFalse = iterator.call(null, value, this._idParse(key));

      if (breakIfFalse === false) {
        return;
      }
    }
  }

  size() {
    return this._map.size;
  }

  setDefault(id, def) {
    const key = this._idStringify(id);

    if (this._map.has(key)) {
      return this._map.get(key);
    }

    this._map.set(key, def);

    return def;
  } // Assumes that values are EJSON-cloneable, and that we don't need to clone
  // IDs (ie, that nobody is going to mutate an ObjectId).


  clone() {
    const clone = new IdMap(this._idStringify, this._idParse); // copy directly to avoid stringify/parse overhead

    this._map.forEach(function (value, key) {
      clone._map.set(key, EJSON.clone(value));
    });

    return clone;
  }

}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}}}}},{
  "extensions": [
    ".js",
    ".json"
  ]
});

var exports = require("/node_modules/meteor/id-map/id-map.js");

/* Exports */
Package._define("id-map", exports, {
  IdMap: IdMap
});

})();

//# sourceURL=meteor://💻app/packages/id-map.js
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvaWQtbWFwL2lkLW1hcC5qcyJdLCJuYW1lcyI6WyJtb2R1bGUiLCJleHBvcnQiLCJJZE1hcCIsImNvbnN0cnVjdG9yIiwiaWRTdHJpbmdpZnkiLCJpZFBhcnNlIiwiX21hcCIsIk1hcCIsIl9pZFN0cmluZ2lmeSIsIkpTT04iLCJzdHJpbmdpZnkiLCJfaWRQYXJzZSIsInBhcnNlIiwiZ2V0IiwiaWQiLCJrZXkiLCJzZXQiLCJ2YWx1ZSIsInJlbW92ZSIsImRlbGV0ZSIsImhhcyIsImVtcHR5Iiwic2l6ZSIsImNsZWFyIiwiZm9yRWFjaCIsIml0ZXJhdG9yIiwiYnJlYWtJZkZhbHNlIiwiY2FsbCIsInNldERlZmF1bHQiLCJkZWYiLCJjbG9uZSIsIkVKU09OIl0sIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7O0FBQUFBLE1BQU0sQ0FBQ0MsTUFBUCxDQUFjO0FBQUNDLE9BQUssRUFBQyxNQUFJQTtBQUFYLENBQWQ7O0FBQ08sTUFBTUEsS0FBTixDQUFZO0FBQ2pCQyxhQUFXLENBQUNDLFdBQUQsRUFBY0MsT0FBZCxFQUF1QjtBQUNoQyxTQUFLQyxJQUFMLEdBQVksSUFBSUMsR0FBSixFQUFaO0FBQ0EsU0FBS0MsWUFBTCxHQUFvQkosV0FBVyxJQUFJSyxJQUFJLENBQUNDLFNBQXhDO0FBQ0EsU0FBS0MsUUFBTCxHQUFnQk4sT0FBTyxJQUFJSSxJQUFJLENBQUNHLEtBQWhDO0FBQ0QsR0FMZ0IsQ0FPbkI7QUFDQTtBQUNBO0FBQ0E7OztBQUVFQyxLQUFHLENBQUNDLEVBQUQsRUFBSztBQUNOLFVBQU1DLEdBQUcsR0FBRyxLQUFLUCxZQUFMLENBQWtCTSxFQUFsQixDQUFaOztBQUNBLFdBQU8sS0FBS1IsSUFBTCxDQUFVTyxHQUFWLENBQWNFLEdBQWQsQ0FBUDtBQUNEOztBQUVEQyxLQUFHLENBQUNGLEVBQUQsRUFBS0csS0FBTCxFQUFZO0FBQ2IsVUFBTUYsR0FBRyxHQUFHLEtBQUtQLFlBQUwsQ0FBa0JNLEVBQWxCLENBQVo7O0FBQ0EsU0FBS1IsSUFBTCxDQUFVVSxHQUFWLENBQWNELEdBQWQsRUFBbUJFLEtBQW5CO0FBQ0Q7O0FBRURDLFFBQU0sQ0FBQ0osRUFBRCxFQUFLO0FBQ1QsVUFBTUMsR0FBRyxHQUFHLEtBQUtQLFlBQUwsQ0FBa0JNLEVBQWxCLENBQVo7O0FBQ0EsU0FBS1IsSUFBTCxDQUFVYSxNQUFWLENBQWlCSixHQUFqQjtBQUNEOztBQUVESyxLQUFHLENBQUNOLEVBQUQsRUFBSztBQUNOLFVBQU1DLEdBQUcsR0FBRyxLQUFLUCxZQUFMLENBQWtCTSxFQUFsQixDQUFaOztBQUNBLFdBQU8sS0FBS1IsSUFBTCxDQUFVYyxHQUFWLENBQWNMLEdBQWQsQ0FBUDtBQUNEOztBQUVETSxPQUFLLEdBQUc7QUFDTixXQUFPLEtBQUtmLElBQUwsQ0FBVWdCLElBQVYsS0FBbUIsQ0FBMUI7QUFDRDs7QUFFREMsT0FBSyxHQUFHO0FBQ04sU0FBS2pCLElBQUwsQ0FBVWlCLEtBQVY7QUFDRCxHQXRDZ0IsQ0F3Q2pCOzs7QUFDQUMsU0FBTyxDQUFDQyxRQUFELEVBQVc7QUFDaEI7QUFDQSxTQUFLLElBQUksQ0FBQ1YsR0FBRCxFQUFNRSxLQUFOLENBQVQsSUFBeUIsS0FBS1gsSUFBOUIsRUFBbUM7QUFDakMsWUFBTW9CLFlBQVksR0FBR0QsUUFBUSxDQUFDRSxJQUFULENBQ25CLElBRG1CLEVBRW5CVixLQUZtQixFQUduQixLQUFLTixRQUFMLENBQWNJLEdBQWQsQ0FIbUIsQ0FBckI7O0FBS0EsVUFBSVcsWUFBWSxLQUFLLEtBQXJCLEVBQTRCO0FBQzFCO0FBQ0Q7QUFDRjtBQUNGOztBQUVESixNQUFJLEdBQUc7QUFDTCxXQUFPLEtBQUtoQixJQUFMLENBQVVnQixJQUFqQjtBQUNEOztBQUVETSxZQUFVLENBQUNkLEVBQUQsRUFBS2UsR0FBTCxFQUFVO0FBQ2xCLFVBQU1kLEdBQUcsR0FBRyxLQUFLUCxZQUFMLENBQWtCTSxFQUFsQixDQUFaOztBQUNBLFFBQUksS0FBS1IsSUFBTCxDQUFVYyxHQUFWLENBQWNMLEdBQWQsQ0FBSixFQUF3QjtBQUN0QixhQUFPLEtBQUtULElBQUwsQ0FBVU8sR0FBVixDQUFjRSxHQUFkLENBQVA7QUFDRDs7QUFDRCxTQUFLVCxJQUFMLENBQVVVLEdBQVYsQ0FBY0QsR0FBZCxFQUFtQmMsR0FBbkI7O0FBQ0EsV0FBT0EsR0FBUDtBQUNELEdBbEVnQixDQW9FakI7QUFDQTs7O0FBQ0FDLE9BQUssR0FBRztBQUNOLFVBQU1BLEtBQUssR0FBRyxJQUFJNUIsS0FBSixDQUFVLEtBQUtNLFlBQWYsRUFBNkIsS0FBS0csUUFBbEMsQ0FBZCxDQURNLENBRU47O0FBQ0EsU0FBS0wsSUFBTCxDQUFVa0IsT0FBVixDQUFrQixVQUFTUCxLQUFULEVBQWdCRixHQUFoQixFQUFvQjtBQUNwQ2UsV0FBSyxDQUFDeEIsSUFBTixDQUFXVSxHQUFYLENBQWVELEdBQWYsRUFBb0JnQixLQUFLLENBQUNELEtBQU4sQ0FBWWIsS0FBWixDQUFwQjtBQUNELEtBRkQ7O0FBR0EsV0FBT2EsS0FBUDtBQUNEOztBQTdFZ0IsQyIsImZpbGUiOiIvcGFja2FnZXMvaWQtbWFwLmpzIiwic291cmNlc0NvbnRlbnQiOlsiXG5leHBvcnQgY2xhc3MgSWRNYXAge1xuICBjb25zdHJ1Y3RvcihpZFN0cmluZ2lmeSwgaWRQYXJzZSkge1xuICAgIHRoaXMuX21hcCA9IG5ldyBNYXAoKTtcbiAgICB0aGlzLl9pZFN0cmluZ2lmeSA9IGlkU3RyaW5naWZ5IHx8IEpTT04uc3RyaW5naWZ5O1xuICAgIHRoaXMuX2lkUGFyc2UgPSBpZFBhcnNlIHx8IEpTT04ucGFyc2U7XG4gIH1cblxuLy8gU29tZSBvZiB0aGVzZSBtZXRob2RzIGFyZSBkZXNpZ25lZCB0byBtYXRjaCBtZXRob2RzIG9uIE9yZGVyZWREaWN0LCBzaW5jZVxuLy8gKGVnKSBPYnNlcnZlTXVsdGlwbGV4IGFuZCBfQ2FjaGluZ0NoYW5nZU9ic2VydmVyIHVzZSB0aGVtIGludGVyY2hhbmdlYWJseS5cbi8vIChDb25jZWl2YWJseSwgdGhpcyBzaG91bGQgYmUgcmVwbGFjZWQgd2l0aCBcIlVub3JkZXJlZERpY3RcIiB3aXRoIGEgc3BlY2lmaWNcbi8vIHNldCBvZiBtZXRob2RzIHRoYXQgb3ZlcmxhcCBiZXR3ZWVuIHRoZSB0d28uKVxuXG4gIGdldChpZCkge1xuICAgIGNvbnN0IGtleSA9IHRoaXMuX2lkU3RyaW5naWZ5KGlkKTtcbiAgICByZXR1cm4gdGhpcy5fbWFwLmdldChrZXkpO1xuICB9XG5cbiAgc2V0KGlkLCB2YWx1ZSkge1xuICAgIGNvbnN0IGtleSA9IHRoaXMuX2lkU3RyaW5naWZ5KGlkKTtcbiAgICB0aGlzLl9tYXAuc2V0KGtleSwgdmFsdWUpO1xuICB9XG5cbiAgcmVtb3ZlKGlkKSB7XG4gICAgY29uc3Qga2V5ID0gdGhpcy5faWRTdHJpbmdpZnkoaWQpO1xuICAgIHRoaXMuX21hcC5kZWxldGUoa2V5KTtcbiAgfVxuXG4gIGhhcyhpZCkge1xuICAgIGNvbnN0IGtleSA9IHRoaXMuX2lkU3RyaW5naWZ5KGlkKTtcbiAgICByZXR1cm4gdGhpcy5fbWFwLmhhcyhrZXkpO1xuICB9XG5cbiAgZW1wdHkoKSB7XG4gICAgcmV0dXJuIHRoaXMuX21hcC5zaXplID09PSAwO1xuICB9XG5cbiAgY2xlYXIoKSB7XG4gICAgdGhpcy5fbWFwLmNsZWFyKCk7XG4gIH1cblxuICAvLyBJdGVyYXRlcyBvdmVyIHRoZSBpdGVtcyBpbiB0aGUgbWFwLiBSZXR1cm4gYGZhbHNlYCB0byBicmVhayB0aGUgbG9vcC5cbiAgZm9yRWFjaChpdGVyYXRvcikge1xuICAgIC8vIGRvbid0IHVzZSBfLmVhY2gsIGJlY2F1c2Ugd2UgY2FuJ3QgYnJlYWsgb3V0IG9mIGl0LlxuICAgIGZvciAobGV0IFtrZXksIHZhbHVlXSBvZiB0aGlzLl9tYXApe1xuICAgICAgY29uc3QgYnJlYWtJZkZhbHNlID0gaXRlcmF0b3IuY2FsbChcbiAgICAgICAgbnVsbCxcbiAgICAgICAgdmFsdWUsXG4gICAgICAgIHRoaXMuX2lkUGFyc2Uoa2V5KVxuICAgICAgKTtcbiAgICAgIGlmIChicmVha0lmRmFsc2UgPT09IGZhbHNlKSB7XG4gICAgICAgIHJldHVybjtcbiAgICAgIH1cbiAgICB9XG4gIH1cblxuICBzaXplKCkge1xuICAgIHJldHVybiB0aGlzLl9tYXAuc2l6ZTtcbiAgfVxuXG4gIHNldERlZmF1bHQoaWQsIGRlZikge1xuICAgIGNvbnN0IGtleSA9IHRoaXMuX2lkU3RyaW5naWZ5KGlkKTtcbiAgICBpZiAodGhpcy5fbWFwLmhhcyhrZXkpKSB7XG4gICAgICByZXR1cm4gdGhpcy5fbWFwLmdldChrZXkpO1xuICAgIH1cbiAgICB0aGlzLl9tYXAuc2V0KGtleSwgZGVmKTtcbiAgICByZXR1cm4gZGVmO1xuICB9XG5cbiAgLy8gQXNzdW1lcyB0aGF0IHZhbHVlcyBhcmUgRUpTT04tY2xvbmVhYmxlLCBhbmQgdGhhdCB3ZSBkb24ndCBuZWVkIHRvIGNsb25lXG4gIC8vIElEcyAoaWUsIHRoYXQgbm9ib2R5IGlzIGdvaW5nIHRvIG11dGF0ZSBhbiBPYmplY3RJZCkuXG4gIGNsb25lKCkge1xuICAgIGNvbnN0IGNsb25lID0gbmV3IElkTWFwKHRoaXMuX2lkU3RyaW5naWZ5LCB0aGlzLl9pZFBhcnNlKTtcbiAgICAvLyBjb3B5IGRpcmVjdGx5IHRvIGF2b2lkIHN0cmluZ2lmeS9wYXJzZSBvdmVyaGVhZFxuICAgIHRoaXMuX21hcC5mb3JFYWNoKGZ1bmN0aW9uKHZhbHVlLCBrZXkpe1xuICAgICAgY2xvbmUuX21hcC5zZXQoa2V5LCBFSlNPTi5jbG9uZSh2YWx1ZSkpO1xuICAgIH0pO1xuICAgIHJldHVybiBjbG9uZTtcbiAgfVxufVxuIl19
