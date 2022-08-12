(function () {

/* Imports */
var Meteor = Package.meteor.Meteor;
var global = Package.meteor.global;
var meteorEnv = Package.meteor.meteorEnv;
var EJSON = Package.ejson.EJSON;
var Random = Package.random.Random;
var ECMAScript = Package.ecmascript.ECMAScript;
var meteorInstall = Package.modules.meteorInstall;
var Promise = Package.promise.Promise;

/* Package-scope variables */
var hexString, MongoID;

var require = meteorInstall({"node_modules":{"meteor":{"mongo-id":{"id.js":function module(require,exports,module){

///////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                           //
// packages/mongo-id/id.js                                                                   //
//                                                                                           //
///////////////////////////////////////////////////////////////////////////////////////////////
                                                                                             //
module.export({
  MongoID: () => MongoID
});
let EJSON;
module.link("meteor/ejson", {
  EJSON(v) {
    EJSON = v;
  }

}, 0);
let Random;
module.link("meteor/random", {
  Random(v) {
    Random = v;
  }

}, 1);
const MongoID = {};

MongoID._looksLikeObjectID = str => str.length === 24 && str.match(/^[0-9a-f]*$/);

MongoID.ObjectID = class ObjectID {
  constructor(hexString) {
    //random-based impl of Mongo ObjectID
    if (hexString) {
      hexString = hexString.toLowerCase();

      if (!MongoID._looksLikeObjectID(hexString)) {
        throw new Error('Invalid hexadecimal string for creating an ObjectID');
      } // meant to work with _.isEqual(), which relies on structural equality


      this._str = hexString;
    } else {
      this._str = Random.hexString(24);
    }
  }

  equals(other) {
    return other instanceof MongoID.ObjectID && this.valueOf() === other.valueOf();
  }

  toString() {
    return "ObjectID(\"".concat(this._str, "\")");
  }

  clone() {
    return new MongoID.ObjectID(this._str);
  }

  typeName() {
    return 'oid';
  }

  getTimestamp() {
    return Number.parseInt(this._str.substr(0, 8), 16);
  }

  valueOf() {
    return this._str;
  }

  toJSONValue() {
    return this.valueOf();
  }

  toHexString() {
    return this.valueOf();
  }

};
EJSON.addType('oid', str => new MongoID.ObjectID(str));

MongoID.idStringify = id => {
  if (id instanceof MongoID.ObjectID) {
    return id.valueOf();
  } else if (typeof id === 'string') {
    var firstChar = id.charAt(0);

    if (id === '') {
      return id;
    } else if (firstChar === '-' || // escape previously dashed strings
    firstChar === '~' || // escape escaped numbers, true, false
    MongoID._looksLikeObjectID(id) || // escape object-id-form strings
    firstChar === '{') {
      // escape object-form strings, for maybe implementing later
      return "-".concat(id);
    } else {
      return id; // other strings go through unchanged.
    }
  } else if (id === undefined) {
    return '-';
  } else if (typeof id === 'object' && id !== null) {
    throw new Error('Meteor does not currently support objects other than ObjectID as ids');
  } else {
    // Numbers, true, false, null
    return "~".concat(JSON.stringify(id));
  }
};

MongoID.idParse = id => {
  var firstChar = id.charAt(0);

  if (id === '') {
    return id;
  } else if (id === '-') {
    return undefined;
  } else if (firstChar === '-') {
    return id.substr(1);
  } else if (firstChar === '~') {
    return JSON.parse(id.substr(1));
  } else if (MongoID._looksLikeObjectID(id)) {
    return new MongoID.ObjectID(id);
  } else {
    return id;
  }
};
///////////////////////////////////////////////////////////////////////////////////////////////

}}}}},{
  "extensions": [
    ".js",
    ".json"
  ]
});

var exports = require("/node_modules/meteor/mongo-id/id.js");

/* Exports */
Package._define("mongo-id", exports, {
  MongoID: MongoID
});

})();

//# sourceURL=meteor://💻app/packages/mongo-id.js
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvbW9uZ28taWQvaWQuanMiXSwibmFtZXMiOlsibW9kdWxlIiwiZXhwb3J0IiwiTW9uZ29JRCIsIkVKU09OIiwibGluayIsInYiLCJSYW5kb20iLCJfbG9va3NMaWtlT2JqZWN0SUQiLCJzdHIiLCJsZW5ndGgiLCJtYXRjaCIsIk9iamVjdElEIiwiY29uc3RydWN0b3IiLCJoZXhTdHJpbmciLCJ0b0xvd2VyQ2FzZSIsIkVycm9yIiwiX3N0ciIsImVxdWFscyIsIm90aGVyIiwidmFsdWVPZiIsInRvU3RyaW5nIiwiY2xvbmUiLCJ0eXBlTmFtZSIsImdldFRpbWVzdGFtcCIsIk51bWJlciIsInBhcnNlSW50Iiwic3Vic3RyIiwidG9KU09OVmFsdWUiLCJ0b0hleFN0cmluZyIsImFkZFR5cGUiLCJpZFN0cmluZ2lmeSIsImlkIiwiZmlyc3RDaGFyIiwiY2hhckF0IiwidW5kZWZpbmVkIiwiSlNPTiIsInN0cmluZ2lmeSIsImlkUGFyc2UiLCJwYXJzZSJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7QUFBQUEsTUFBTSxDQUFDQyxNQUFQLENBQWM7QUFBQ0MsU0FBTyxFQUFDLE1BQUlBO0FBQWIsQ0FBZDtBQUFxQyxJQUFJQyxLQUFKO0FBQVVILE1BQU0sQ0FBQ0ksSUFBUCxDQUFZLGNBQVosRUFBMkI7QUFBQ0QsT0FBSyxDQUFDRSxDQUFELEVBQUc7QUFBQ0YsU0FBSyxHQUFDRSxDQUFOO0FBQVE7O0FBQWxCLENBQTNCLEVBQStDLENBQS9DO0FBQWtELElBQUlDLE1BQUo7QUFBV04sTUFBTSxDQUFDSSxJQUFQLENBQVksZUFBWixFQUE0QjtBQUFDRSxRQUFNLENBQUNELENBQUQsRUFBRztBQUFDQyxVQUFNLEdBQUNELENBQVA7QUFBUzs7QUFBcEIsQ0FBNUIsRUFBa0QsQ0FBbEQ7QUFHNUcsTUFBTUgsT0FBTyxHQUFHLEVBQWhCOztBQUVBQSxPQUFPLENBQUNLLGtCQUFSLEdBQTZCQyxHQUFHLElBQUlBLEdBQUcsQ0FBQ0MsTUFBSixLQUFlLEVBQWYsSUFBcUJELEdBQUcsQ0FBQ0UsS0FBSixDQUFVLGFBQVYsQ0FBekQ7O0FBRUFSLE9BQU8sQ0FBQ1MsUUFBUixHQUFtQixNQUFNQSxRQUFOLENBQWU7QUFDaENDLGFBQVcsQ0FBRUMsU0FBRixFQUFhO0FBQ3RCO0FBQ0EsUUFBSUEsU0FBSixFQUFlO0FBQ2JBLGVBQVMsR0FBR0EsU0FBUyxDQUFDQyxXQUFWLEVBQVo7O0FBQ0EsVUFBSSxDQUFDWixPQUFPLENBQUNLLGtCQUFSLENBQTJCTSxTQUEzQixDQUFMLEVBQTRDO0FBQzFDLGNBQU0sSUFBSUUsS0FBSixDQUFVLHFEQUFWLENBQU47QUFDRCxPQUpZLENBS2I7OztBQUNBLFdBQUtDLElBQUwsR0FBWUgsU0FBWjtBQUNELEtBUEQsTUFPTztBQUNMLFdBQUtHLElBQUwsR0FBWVYsTUFBTSxDQUFDTyxTQUFQLENBQWlCLEVBQWpCLENBQVo7QUFDRDtBQUNGOztBQUVESSxRQUFNLENBQUNDLEtBQUQsRUFBUTtBQUNaLFdBQU9BLEtBQUssWUFBWWhCLE9BQU8sQ0FBQ1MsUUFBekIsSUFDUCxLQUFLUSxPQUFMLE9BQW1CRCxLQUFLLENBQUNDLE9BQU4sRUFEbkI7QUFFRDs7QUFFREMsVUFBUSxHQUFHO0FBQ1QsZ0NBQW9CLEtBQUtKLElBQXpCO0FBQ0Q7O0FBRURLLE9BQUssR0FBRztBQUNOLFdBQU8sSUFBSW5CLE9BQU8sQ0FBQ1MsUUFBWixDQUFxQixLQUFLSyxJQUExQixDQUFQO0FBQ0Q7O0FBRURNLFVBQVEsR0FBRztBQUNULFdBQU8sS0FBUDtBQUNEOztBQUVEQyxjQUFZLEdBQUc7QUFDYixXQUFPQyxNQUFNLENBQUNDLFFBQVAsQ0FBZ0IsS0FBS1QsSUFBTCxDQUFVVSxNQUFWLENBQWlCLENBQWpCLEVBQW9CLENBQXBCLENBQWhCLEVBQXdDLEVBQXhDLENBQVA7QUFDRDs7QUFFRFAsU0FBTyxHQUFHO0FBQ1IsV0FBTyxLQUFLSCxJQUFaO0FBQ0Q7O0FBRURXLGFBQVcsR0FBRztBQUNaLFdBQU8sS0FBS1IsT0FBTCxFQUFQO0FBQ0Q7O0FBRURTLGFBQVcsR0FBRztBQUNaLFdBQU8sS0FBS1QsT0FBTCxFQUFQO0FBQ0Q7O0FBOUMrQixDQUFsQztBQWtEQWhCLEtBQUssQ0FBQzBCLE9BQU4sQ0FBYyxLQUFkLEVBQXFCckIsR0FBRyxJQUFJLElBQUlOLE9BQU8sQ0FBQ1MsUUFBWixDQUFxQkgsR0FBckIsQ0FBNUI7O0FBRUFOLE9BQU8sQ0FBQzRCLFdBQVIsR0FBdUJDLEVBQUQsSUFBUTtBQUM1QixNQUFJQSxFQUFFLFlBQVk3QixPQUFPLENBQUNTLFFBQTFCLEVBQW9DO0FBQ2xDLFdBQU9vQixFQUFFLENBQUNaLE9BQUgsRUFBUDtBQUNELEdBRkQsTUFFTyxJQUFJLE9BQU9ZLEVBQVAsS0FBYyxRQUFsQixFQUE0QjtBQUNqQyxRQUFJQyxTQUFTLEdBQUdELEVBQUUsQ0FBQ0UsTUFBSCxDQUFVLENBQVYsQ0FBaEI7O0FBQ0EsUUFBSUYsRUFBRSxLQUFLLEVBQVgsRUFBZTtBQUNiLGFBQU9BLEVBQVA7QUFDRCxLQUZELE1BRU8sSUFBSUMsU0FBUyxLQUFLLEdBQWQsSUFBcUI7QUFDckJBLGFBQVMsS0FBSyxHQURkLElBQ3FCO0FBQ3JCOUIsV0FBTyxDQUFDSyxrQkFBUixDQUEyQndCLEVBQTNCLENBRkEsSUFFa0M7QUFDbENDLGFBQVMsS0FBSyxHQUhsQixFQUd1QjtBQUFFO0FBQzlCLHdCQUFXRCxFQUFYO0FBQ0QsS0FMTSxNQUtBO0FBQ0wsYUFBT0EsRUFBUCxDQURLLENBQ007QUFDWjtBQUNGLEdBWk0sTUFZQSxJQUFJQSxFQUFFLEtBQUtHLFNBQVgsRUFBc0I7QUFDM0IsV0FBTyxHQUFQO0FBQ0QsR0FGTSxNQUVBLElBQUksT0FBT0gsRUFBUCxLQUFjLFFBQWQsSUFBMEJBLEVBQUUsS0FBSyxJQUFyQyxFQUEyQztBQUNoRCxVQUFNLElBQUloQixLQUFKLENBQVUsc0VBQVYsQ0FBTjtBQUNELEdBRk0sTUFFQTtBQUFFO0FBQ1Asc0JBQVdvQixJQUFJLENBQUNDLFNBQUwsQ0FBZUwsRUFBZixDQUFYO0FBQ0Q7QUFDRixDQXRCRDs7QUF3QkE3QixPQUFPLENBQUNtQyxPQUFSLEdBQW1CTixFQUFELElBQVE7QUFDeEIsTUFBSUMsU0FBUyxHQUFHRCxFQUFFLENBQUNFLE1BQUgsQ0FBVSxDQUFWLENBQWhCOztBQUNBLE1BQUlGLEVBQUUsS0FBSyxFQUFYLEVBQWU7QUFDYixXQUFPQSxFQUFQO0FBQ0QsR0FGRCxNQUVPLElBQUlBLEVBQUUsS0FBSyxHQUFYLEVBQWdCO0FBQ3JCLFdBQU9HLFNBQVA7QUFDRCxHQUZNLE1BRUEsSUFBSUYsU0FBUyxLQUFLLEdBQWxCLEVBQXVCO0FBQzVCLFdBQU9ELEVBQUUsQ0FBQ0wsTUFBSCxDQUFVLENBQVYsQ0FBUDtBQUNELEdBRk0sTUFFQSxJQUFJTSxTQUFTLEtBQUssR0FBbEIsRUFBdUI7QUFDNUIsV0FBT0csSUFBSSxDQUFDRyxLQUFMLENBQVdQLEVBQUUsQ0FBQ0wsTUFBSCxDQUFVLENBQVYsQ0FBWCxDQUFQO0FBQ0QsR0FGTSxNQUVBLElBQUl4QixPQUFPLENBQUNLLGtCQUFSLENBQTJCd0IsRUFBM0IsQ0FBSixFQUFvQztBQUN6QyxXQUFPLElBQUk3QixPQUFPLENBQUNTLFFBQVosQ0FBcUJvQixFQUFyQixDQUFQO0FBQ0QsR0FGTSxNQUVBO0FBQ0wsV0FBT0EsRUFBUDtBQUNEO0FBQ0YsQ0FmRCxDIiwiZmlsZSI6Ii9wYWNrYWdlcy9tb25nby1pZC5qcyIsInNvdXJjZXNDb250ZW50IjpbImltcG9ydCB7IEVKU09OIH0gZnJvbSAnbWV0ZW9yL2Vqc29uJztcbmltcG9ydCB7IFJhbmRvbSB9IGZyb20gJ21ldGVvci9yYW5kb20nO1xuXG5jb25zdCBNb25nb0lEID0ge307XG5cbk1vbmdvSUQuX2xvb2tzTGlrZU9iamVjdElEID0gc3RyID0+IHN0ci5sZW5ndGggPT09IDI0ICYmIHN0ci5tYXRjaCgvXlswLTlhLWZdKiQvKTtcblxuTW9uZ29JRC5PYmplY3RJRCA9IGNsYXNzIE9iamVjdElEIHtcbiAgY29uc3RydWN0b3IgKGhleFN0cmluZykge1xuICAgIC8vcmFuZG9tLWJhc2VkIGltcGwgb2YgTW9uZ28gT2JqZWN0SURcbiAgICBpZiAoaGV4U3RyaW5nKSB7XG4gICAgICBoZXhTdHJpbmcgPSBoZXhTdHJpbmcudG9Mb3dlckNhc2UoKTtcbiAgICAgIGlmICghTW9uZ29JRC5fbG9va3NMaWtlT2JqZWN0SUQoaGV4U3RyaW5nKSkge1xuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoJ0ludmFsaWQgaGV4YWRlY2ltYWwgc3RyaW5nIGZvciBjcmVhdGluZyBhbiBPYmplY3RJRCcpO1xuICAgICAgfVxuICAgICAgLy8gbWVhbnQgdG8gd29yayB3aXRoIF8uaXNFcXVhbCgpLCB3aGljaCByZWxpZXMgb24gc3RydWN0dXJhbCBlcXVhbGl0eVxuICAgICAgdGhpcy5fc3RyID0gaGV4U3RyaW5nO1xuICAgIH0gZWxzZSB7XG4gICAgICB0aGlzLl9zdHIgPSBSYW5kb20uaGV4U3RyaW5nKDI0KTtcbiAgICB9XG4gIH1cblxuICBlcXVhbHMob3RoZXIpIHtcbiAgICByZXR1cm4gb3RoZXIgaW5zdGFuY2VvZiBNb25nb0lELk9iamVjdElEICYmXG4gICAgdGhpcy52YWx1ZU9mKCkgPT09IG90aGVyLnZhbHVlT2YoKTtcbiAgfVxuXG4gIHRvU3RyaW5nKCkge1xuICAgIHJldHVybiBgT2JqZWN0SUQoXCIke3RoaXMuX3N0cn1cIilgO1xuICB9XG5cbiAgY2xvbmUoKSB7XG4gICAgcmV0dXJuIG5ldyBNb25nb0lELk9iamVjdElEKHRoaXMuX3N0cik7XG4gIH1cblxuICB0eXBlTmFtZSgpIHtcbiAgICByZXR1cm4gJ29pZCc7XG4gIH1cblxuICBnZXRUaW1lc3RhbXAoKSB7XG4gICAgcmV0dXJuIE51bWJlci5wYXJzZUludCh0aGlzLl9zdHIuc3Vic3RyKDAsIDgpLCAxNik7XG4gIH1cblxuICB2YWx1ZU9mKCkge1xuICAgIHJldHVybiB0aGlzLl9zdHI7XG4gIH1cblxuICB0b0pTT05WYWx1ZSgpIHtcbiAgICByZXR1cm4gdGhpcy52YWx1ZU9mKCk7XG4gIH1cblxuICB0b0hleFN0cmluZygpIHtcbiAgICByZXR1cm4gdGhpcy52YWx1ZU9mKCk7XG4gIH1cblxufVxuXG5FSlNPTi5hZGRUeXBlKCdvaWQnLCBzdHIgPT4gbmV3IE1vbmdvSUQuT2JqZWN0SUQoc3RyKSk7XG5cbk1vbmdvSUQuaWRTdHJpbmdpZnkgPSAoaWQpID0+IHtcbiAgaWYgKGlkIGluc3RhbmNlb2YgTW9uZ29JRC5PYmplY3RJRCkge1xuICAgIHJldHVybiBpZC52YWx1ZU9mKCk7XG4gIH0gZWxzZSBpZiAodHlwZW9mIGlkID09PSAnc3RyaW5nJykge1xuICAgIHZhciBmaXJzdENoYXIgPSBpZC5jaGFyQXQoMCk7XG4gICAgaWYgKGlkID09PSAnJykge1xuICAgICAgcmV0dXJuIGlkO1xuICAgIH0gZWxzZSBpZiAoZmlyc3RDaGFyID09PSAnLScgfHwgLy8gZXNjYXBlIHByZXZpb3VzbHkgZGFzaGVkIHN0cmluZ3NcbiAgICAgICAgICAgICAgIGZpcnN0Q2hhciA9PT0gJ34nIHx8IC8vIGVzY2FwZSBlc2NhcGVkIG51bWJlcnMsIHRydWUsIGZhbHNlXG4gICAgICAgICAgICAgICBNb25nb0lELl9sb29rc0xpa2VPYmplY3RJRChpZCkgfHwgLy8gZXNjYXBlIG9iamVjdC1pZC1mb3JtIHN0cmluZ3NcbiAgICAgICAgICAgICAgIGZpcnN0Q2hhciA9PT0gJ3snKSB7IC8vIGVzY2FwZSBvYmplY3QtZm9ybSBzdHJpbmdzLCBmb3IgbWF5YmUgaW1wbGVtZW50aW5nIGxhdGVyXG4gICAgICByZXR1cm4gYC0ke2lkfWA7XG4gICAgfSBlbHNlIHtcbiAgICAgIHJldHVybiBpZDsgLy8gb3RoZXIgc3RyaW5ncyBnbyB0aHJvdWdoIHVuY2hhbmdlZC5cbiAgICB9XG4gIH0gZWxzZSBpZiAoaWQgPT09IHVuZGVmaW5lZCkge1xuICAgIHJldHVybiAnLSc7XG4gIH0gZWxzZSBpZiAodHlwZW9mIGlkID09PSAnb2JqZWN0JyAmJiBpZCAhPT0gbnVsbCkge1xuICAgIHRocm93IG5ldyBFcnJvcignTWV0ZW9yIGRvZXMgbm90IGN1cnJlbnRseSBzdXBwb3J0IG9iamVjdHMgb3RoZXIgdGhhbiBPYmplY3RJRCBhcyBpZHMnKTtcbiAgfSBlbHNlIHsgLy8gTnVtYmVycywgdHJ1ZSwgZmFsc2UsIG51bGxcbiAgICByZXR1cm4gYH4ke0pTT04uc3RyaW5naWZ5KGlkKX1gO1xuICB9XG59O1xuXG5Nb25nb0lELmlkUGFyc2UgPSAoaWQpID0+IHtcbiAgdmFyIGZpcnN0Q2hhciA9IGlkLmNoYXJBdCgwKTtcbiAgaWYgKGlkID09PSAnJykge1xuICAgIHJldHVybiBpZDtcbiAgfSBlbHNlIGlmIChpZCA9PT0gJy0nKSB7XG4gICAgcmV0dXJuIHVuZGVmaW5lZDtcbiAgfSBlbHNlIGlmIChmaXJzdENoYXIgPT09ICctJykge1xuICAgIHJldHVybiBpZC5zdWJzdHIoMSk7XG4gIH0gZWxzZSBpZiAoZmlyc3RDaGFyID09PSAnficpIHtcbiAgICByZXR1cm4gSlNPTi5wYXJzZShpZC5zdWJzdHIoMSkpO1xuICB9IGVsc2UgaWYgKE1vbmdvSUQuX2xvb2tzTGlrZU9iamVjdElEKGlkKSkge1xuICAgIHJldHVybiBuZXcgTW9uZ29JRC5PYmplY3RJRChpZCk7XG4gIH0gZWxzZSB7XG4gICAgcmV0dXJuIGlkO1xuICB9XG59O1xuXG5leHBvcnQgeyBNb25nb0lEIH07XG4iXX0=
