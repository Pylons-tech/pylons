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
var check, Match;

var require = meteorInstall({"node_modules":{"meteor":{"check":{"match.js":function module(require,exports,module){

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
// packages/check/match.js                                                                                       //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                 //
module.export({
  check: () => check,
  Match: () => Match
});
let isPlainObject;
module.link("./isPlainObject", {
  isPlainObject(v) {
    isPlainObject = v;
  }

}, 0);
// Things we explicitly do NOT support:
//    - heterogenous arrays
const currentArgumentChecker = new Meteor.EnvironmentVariable();
const hasOwn = Object.prototype.hasOwnProperty;
/**
 * @summary Check that a value matches a [pattern](#matchpatterns).
 * If the value does not match the pattern, throw a `Match.Error`.
 *
 * Particularly useful to assert that arguments to a function have the right
 * types and structure.
 * @locus Anywhere
 * @param {Any} value The value to check
 * @param {MatchPattern} pattern The pattern to match `value` against
 */

function check(value, pattern) {
  // Record that check got called, if somebody cared.
  //
  // We use getOrNullIfOutsideFiber so that it's OK to call check()
  // from non-Fiber server contexts; the downside is that if you forget to
  // bindEnvironment on some random callback in your method/publisher,
  // it might not find the argumentChecker and you'll get an error about
  // not checking an argument that it looks like you're checking (instead
  // of just getting a "Node code must run in a Fiber" error).
  const argChecker = currentArgumentChecker.getOrNullIfOutsideFiber();

  if (argChecker) {
    argChecker.checking(value);
  }

  const result = testSubtree(value, pattern);

  if (result) {
    const err = new Match.Error(result.message);

    if (result.path) {
      err.message += " in field ".concat(result.path);
      err.path = result.path;
    }

    throw err;
  }
}

;
/**
 * @namespace Match
 * @summary The namespace for all Match types and methods.
 */

const Match = {
  Optional: function (pattern) {
    return new Optional(pattern);
  },
  Maybe: function (pattern) {
    return new Maybe(pattern);
  },
  OneOf: function () {
    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    return new OneOf(args);
  },
  Any: ['__any__'],
  Where: function (condition) {
    return new Where(condition);
  },
  ObjectIncluding: function (pattern) {
    return new ObjectIncluding(pattern);
  },
  ObjectWithValues: function (pattern) {
    return new ObjectWithValues(pattern);
  },
  // Matches only signed 32-bit integers
  Integer: ['__integer__'],
  // XXX matchers should know how to describe themselves for errors
  Error: Meteor.makeErrorType('Match.Error', function (msg) {
    this.message = "Match error: ".concat(msg); // The path of the value that failed to match. Initially empty, this gets
    // populated by catching and rethrowing the exception as it goes back up the
    // stack.
    // E.g.: "vals[3].entity.created"

    this.path = ''; // If this gets sent over DDP, don't give full internal details but at least
    // provide something better than 500 Internal server error.

    this.sanitizedError = new Meteor.Error(400, 'Match failed');
  }),

  // Tests to see if value matches pattern. Unlike check, it merely returns true
  // or false (unless an error other than Match.Error was thrown). It does not
  // interact with _failIfArgumentsAreNotAllChecked.
  // XXX maybe also implement a Match.match which returns more information about
  //     failures but without using exception handling or doing what check()
  //     does with _failIfArgumentsAreNotAllChecked and Meteor.Error conversion

  /**
   * @summary Returns true if the value matches the pattern.
   * @locus Anywhere
   * @param {Any} value The value to check
   * @param {MatchPattern} pattern The pattern to match `value` against
   */
  test(value, pattern) {
    return !testSubtree(value, pattern);
  },

  // Runs `f.apply(context, args)`. If check() is not called on every element of
  // `args` (either directly or in the first level of an array), throws an error
  // (using `description` in the message).
  _failIfArgumentsAreNotAllChecked(f, context, args, description) {
    const argChecker = new ArgumentChecker(args, description);
    const result = currentArgumentChecker.withValue(argChecker, () => f.apply(context, args)); // If f didn't itself throw, make sure it checked all of its arguments.

    argChecker.throwUnlessAllArgumentsHaveBeenChecked();
    return result;
  }

};

class Optional {
  constructor(pattern) {
    this.pattern = pattern;
  }

}

class Maybe {
  constructor(pattern) {
    this.pattern = pattern;
  }

}

class OneOf {
  constructor(choices) {
    if (!choices || choices.length === 0) {
      throw new Error('Must provide at least one choice to Match.OneOf');
    }

    this.choices = choices;
  }

}

class Where {
  constructor(condition) {
    this.condition = condition;
  }

}

class ObjectIncluding {
  constructor(pattern) {
    this.pattern = pattern;
  }

}

class ObjectWithValues {
  constructor(pattern) {
    this.pattern = pattern;
  }

}

const stringForErrorMessage = function (value) {
  let options = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : {};

  if (value === null) {
    return 'null';
  }

  if (options.onlyShowType) {
    return typeof value;
  } // Your average non-object things.  Saves from doing the try/catch below for.


  if (typeof value !== 'object') {
    return EJSON.stringify(value);
  }

  try {
    // Find objects with circular references since EJSON doesn't support them yet (Issue #4778 + Unaccepted PR)
    // If the native stringify is going to choke, EJSON.stringify is going to choke too.
    JSON.stringify(value);
  } catch (stringifyError) {
    if (stringifyError.name === 'TypeError') {
      return typeof value;
    }
  }

  return EJSON.stringify(value);
};

const typeofChecks = [[String, 'string'], [Number, 'number'], [Boolean, 'boolean'], // While we don't allow undefined/function in EJSON, this is good for optional
// arguments with OneOf.
[Function, 'function'], [undefined, 'undefined']]; // Return `false` if it matches. Otherwise, return an object with a `message` and a `path` field.

const testSubtree = (value, pattern) => {
  // Match anything!
  if (pattern === Match.Any) {
    return false;
  } // Basic atomic types.
  // Do not match boxed objects (e.g. String, Boolean)


  for (let i = 0; i < typeofChecks.length; ++i) {
    if (pattern === typeofChecks[i][0]) {
      if (typeof value === typeofChecks[i][1]) {
        return false;
      }

      return {
        message: "Expected ".concat(typeofChecks[i][1], ", got ").concat(stringForErrorMessage(value, {
          onlyShowType: true
        })),
        path: ''
      };
    }
  }

  if (pattern === null) {
    if (value === null) {
      return false;
    }

    return {
      message: "Expected null, got ".concat(stringForErrorMessage(value)),
      path: ''
    };
  } // Strings, numbers, and booleans match literally. Goes well with Match.OneOf.


  if (typeof pattern === 'string' || typeof pattern === 'number' || typeof pattern === 'boolean') {
    if (value === pattern) {
      return false;
    }

    return {
      message: "Expected ".concat(pattern, ", got ").concat(stringForErrorMessage(value)),
      path: ''
    };
  } // Match.Integer is special type encoded with array


  if (pattern === Match.Integer) {
    // There is no consistent and reliable way to check if variable is a 64-bit
    // integer. One of the popular solutions is to get reminder of division by 1
    // but this method fails on really large floats with big precision.
    // E.g.: 1.348192308491824e+23 % 1 === 0 in V8
    // Bitwise operators work consistantly but always cast variable to 32-bit
    // signed integer according to JavaScript specs.
    if (typeof value === 'number' && (value | 0) === value) {
      return false;
    }

    return {
      message: "Expected Integer, got ".concat(stringForErrorMessage(value)),
      path: ''
    };
  } // 'Object' is shorthand for Match.ObjectIncluding({});


  if (pattern === Object) {
    pattern = Match.ObjectIncluding({});
  } // Array (checked AFTER Any, which is implemented as an Array).


  if (pattern instanceof Array) {
    if (pattern.length !== 1) {
      return {
        message: "Bad pattern: arrays must have one type element ".concat(stringForErrorMessage(pattern)),
        path: ''
      };
    }

    if (!Array.isArray(value) && !isArguments(value)) {
      return {
        message: "Expected array, got ".concat(stringForErrorMessage(value)),
        path: ''
      };
    }

    for (let i = 0, length = value.length; i < length; i++) {
      const result = testSubtree(value[i], pattern[0]);

      if (result) {
        result.path = _prependPath(i, result.path);
        return result;
      }
    }

    return false;
  } // Arbitrary validation checks. The condition can return false or throw a
  // Match.Error (ie, it can internally use check()) to fail.


  if (pattern instanceof Where) {
    let result;

    try {
      result = pattern.condition(value);
    } catch (err) {
      if (!(err instanceof Match.Error)) {
        throw err;
      }

      return {
        message: err.message,
        path: err.path
      };
    }

    if (result) {
      return false;
    } // XXX this error is terrible


    return {
      message: 'Failed Match.Where validation',
      path: ''
    };
  }

  if (pattern instanceof Maybe) {
    pattern = Match.OneOf(undefined, null, pattern.pattern);
  } else if (pattern instanceof Optional) {
    pattern = Match.OneOf(undefined, pattern.pattern);
  }

  if (pattern instanceof OneOf) {
    for (let i = 0; i < pattern.choices.length; ++i) {
      const result = testSubtree(value, pattern.choices[i]);

      if (!result) {
        // No error? Yay, return.
        return false;
      } // Match errors just mean try another choice.

    } // XXX this error is terrible


    return {
      message: 'Failed Match.OneOf, Match.Maybe or Match.Optional validation',
      path: ''
    };
  } // A function that isn't something we special-case is assumed to be a
  // constructor.


  if (pattern instanceof Function) {
    if (value instanceof pattern) {
      return false;
    }

    return {
      message: "Expected ".concat(pattern.name || 'particular constructor'),
      path: ''
    };
  }

  let unknownKeysAllowed = false;
  let unknownKeyPattern;

  if (pattern instanceof ObjectIncluding) {
    unknownKeysAllowed = true;
    pattern = pattern.pattern;
  }

  if (pattern instanceof ObjectWithValues) {
    unknownKeysAllowed = true;
    unknownKeyPattern = [pattern.pattern];
    pattern = {}; // no required keys
  }

  if (typeof pattern !== 'object') {
    return {
      message: 'Bad pattern: unknown pattern type',
      path: ''
    };
  } // An object, with required and optional keys. Note that this does NOT do
  // structural matches against objects of special types that happen to match
  // the pattern: this really needs to be a plain old {Object}!


  if (typeof value !== 'object') {
    return {
      message: "Expected object, got ".concat(typeof value),
      path: ''
    };
  }

  if (value === null) {
    return {
      message: "Expected object, got null",
      path: ''
    };
  }

  if (!isPlainObject(value)) {
    return {
      message: "Expected plain object",
      path: ''
    };
  }

  const requiredPatterns = Object.create(null);
  const optionalPatterns = Object.create(null);
  Object.keys(pattern).forEach(key => {
    const subPattern = pattern[key];

    if (subPattern instanceof Optional || subPattern instanceof Maybe) {
      optionalPatterns[key] = subPattern.pattern;
    } else {
      requiredPatterns[key] = subPattern;
    }
  });

  for (let key in Object(value)) {
    const subValue = value[key];

    if (hasOwn.call(requiredPatterns, key)) {
      const result = testSubtree(subValue, requiredPatterns[key]);

      if (result) {
        result.path = _prependPath(key, result.path);
        return result;
      }

      delete requiredPatterns[key];
    } else if (hasOwn.call(optionalPatterns, key)) {
      const result = testSubtree(subValue, optionalPatterns[key]);

      if (result) {
        result.path = _prependPath(key, result.path);
        return result;
      }
    } else {
      if (!unknownKeysAllowed) {
        return {
          message: 'Unknown key',
          path: key
        };
      }

      if (unknownKeyPattern) {
        const result = testSubtree(subValue, unknownKeyPattern[0]);

        if (result) {
          result.path = _prependPath(key, result.path);
          return result;
        }
      }
    }
  }

  const keys = Object.keys(requiredPatterns);

  if (keys.length) {
    return {
      message: "Missing key '".concat(keys[0], "'"),
      path: ''
    };
  }
};

class ArgumentChecker {
  constructor(args, description) {
    // Make a SHALLOW copy of the arguments. (We'll be doing identity checks
    // against its contents.)
    this.args = [...args]; // Since the common case will be to check arguments in order, and we splice
    // out arguments when we check them, make it so we splice out from the end
    // rather than the beginning.

    this.args.reverse();
    this.description = description;
  }

  checking(value) {
    if (this._checkingOneValue(value)) {
      return;
    } // Allow check(arguments, [String]) or check(arguments.slice(1), [String])
    // or check([foo, bar], [String]) to count... but only if value wasn't
    // itself an argument.


    if (Array.isArray(value) || isArguments(value)) {
      Array.prototype.forEach.call(value, this._checkingOneValue.bind(this));
    }
  }

  _checkingOneValue(value) {
    for (let i = 0; i < this.args.length; ++i) {
      // Is this value one of the arguments? (This can have a false positive if
      // the argument is an interned primitive, but it's still a good enough
      // check.)
      // (NaN is not === to itself, so we have to check specially.)
      if (value === this.args[i] || Number.isNaN(value) && Number.isNaN(this.args[i])) {
        this.args.splice(i, 1);
        return true;
      }
    }

    return false;
  }

  throwUnlessAllArgumentsHaveBeenChecked() {
    if (this.args.length > 0) throw new Error("Did not check() all arguments during ".concat(this.description));
  }

}

const _jsKeywords = ['do', 'if', 'in', 'for', 'let', 'new', 'try', 'var', 'case', 'else', 'enum', 'eval', 'false', 'null', 'this', 'true', 'void', 'with', 'break', 'catch', 'class', 'const', 'super', 'throw', 'while', 'yield', 'delete', 'export', 'import', 'public', 'return', 'static', 'switch', 'typeof', 'default', 'extends', 'finally', 'package', 'private', 'continue', 'debugger', 'function', 'arguments', 'interface', 'protected', 'implements', 'instanceof']; // Assumes the base of path is already escaped properly
// returns key + base

const _prependPath = (key, base) => {
  if (typeof key === 'number' || key.match(/^[0-9]+$/)) {
    key = "[".concat(key, "]");
  } else if (!key.match(/^[a-z_$][0-9a-z_$]*$/i) || _jsKeywords.indexOf(key) >= 0) {
    key = JSON.stringify([key]);
  }

  if (base && base[0] !== '[') {
    return "".concat(key, ".").concat(base);
  }

  return key + base;
};

const isObject = value => typeof value === 'object' && value !== null;

const baseIsArguments = item => isObject(item) && Object.prototype.toString.call(item) === '[object Arguments]';

const isArguments = baseIsArguments(function () {
  return arguments;
}()) ? baseIsArguments : value => isObject(value) && typeof value.callee === 'function';
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"isPlainObject.js":function module(require,exports,module){

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
// packages/check/isPlainObject.js                                                                               //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                 //
module.export({
  isPlainObject: () => isPlainObject
});
// Copy of jQuery.isPlainObject for the server side from jQuery v3.1.1.
const class2type = {};
const toString = class2type.toString;
const hasOwn = Object.prototype.hasOwnProperty;
const fnToString = hasOwn.toString;
const ObjectFunctionString = fnToString.call(Object);
const getProto = Object.getPrototypeOf;

const isPlainObject = obj => {
  let proto;
  let Ctor; // Detect obvious negatives
  // Use toString instead of jQuery.type to catch host objects

  if (!obj || toString.call(obj) !== '[object Object]') {
    return false;
  }

  proto = getProto(obj); // Objects with no prototype (e.g., `Object.create( null )`) are plain

  if (!proto) {
    return true;
  } // Objects with prototype are plain iff they were constructed by a global Object function


  Ctor = hasOwn.call(proto, 'constructor') && proto.constructor;
  return typeof Ctor === 'function' && fnToString.call(Ctor) === ObjectFunctionString;
};
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}}}}},{
  "extensions": [
    ".js",
    ".json"
  ]
});

var exports = require("/node_modules/meteor/check/match.js");

/* Exports */
Package._define("check", exports, {
  check: check,
  Match: Match
});

})();

//# sourceURL=meteor://💻app/packages/check.js
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvY2hlY2svbWF0Y2guanMiLCJtZXRlb3I6Ly/wn5K7YXBwL3BhY2thZ2VzL2NoZWNrL2lzUGxhaW5PYmplY3QuanMiXSwibmFtZXMiOlsibW9kdWxlIiwiZXhwb3J0IiwiY2hlY2siLCJNYXRjaCIsImlzUGxhaW5PYmplY3QiLCJsaW5rIiwidiIsImN1cnJlbnRBcmd1bWVudENoZWNrZXIiLCJNZXRlb3IiLCJFbnZpcm9ubWVudFZhcmlhYmxlIiwiaGFzT3duIiwiT2JqZWN0IiwicHJvdG90eXBlIiwiaGFzT3duUHJvcGVydHkiLCJ2YWx1ZSIsInBhdHRlcm4iLCJhcmdDaGVja2VyIiwiZ2V0T3JOdWxsSWZPdXRzaWRlRmliZXIiLCJjaGVja2luZyIsInJlc3VsdCIsInRlc3RTdWJ0cmVlIiwiZXJyIiwiRXJyb3IiLCJtZXNzYWdlIiwicGF0aCIsIk9wdGlvbmFsIiwiTWF5YmUiLCJPbmVPZiIsImFyZ3MiLCJBbnkiLCJXaGVyZSIsImNvbmRpdGlvbiIsIk9iamVjdEluY2x1ZGluZyIsIk9iamVjdFdpdGhWYWx1ZXMiLCJJbnRlZ2VyIiwibWFrZUVycm9yVHlwZSIsIm1zZyIsInNhbml0aXplZEVycm9yIiwidGVzdCIsIl9mYWlsSWZBcmd1bWVudHNBcmVOb3RBbGxDaGVja2VkIiwiZiIsImNvbnRleHQiLCJkZXNjcmlwdGlvbiIsIkFyZ3VtZW50Q2hlY2tlciIsIndpdGhWYWx1ZSIsImFwcGx5IiwidGhyb3dVbmxlc3NBbGxBcmd1bWVudHNIYXZlQmVlbkNoZWNrZWQiLCJjb25zdHJ1Y3RvciIsImNob2ljZXMiLCJsZW5ndGgiLCJzdHJpbmdGb3JFcnJvck1lc3NhZ2UiLCJvcHRpb25zIiwib25seVNob3dUeXBlIiwiRUpTT04iLCJzdHJpbmdpZnkiLCJKU09OIiwic3RyaW5naWZ5RXJyb3IiLCJuYW1lIiwidHlwZW9mQ2hlY2tzIiwiU3RyaW5nIiwiTnVtYmVyIiwiQm9vbGVhbiIsIkZ1bmN0aW9uIiwidW5kZWZpbmVkIiwiaSIsIkFycmF5IiwiaXNBcnJheSIsImlzQXJndW1lbnRzIiwiX3ByZXBlbmRQYXRoIiwidW5rbm93bktleXNBbGxvd2VkIiwidW5rbm93bktleVBhdHRlcm4iLCJyZXF1aXJlZFBhdHRlcm5zIiwiY3JlYXRlIiwib3B0aW9uYWxQYXR0ZXJucyIsImtleXMiLCJmb3JFYWNoIiwia2V5Iiwic3ViUGF0dGVybiIsInN1YlZhbHVlIiwiY2FsbCIsInJldmVyc2UiLCJfY2hlY2tpbmdPbmVWYWx1ZSIsImJpbmQiLCJpc05hTiIsInNwbGljZSIsIl9qc0tleXdvcmRzIiwiYmFzZSIsIm1hdGNoIiwiaW5kZXhPZiIsImlzT2JqZWN0IiwiYmFzZUlzQXJndW1lbnRzIiwiaXRlbSIsInRvU3RyaW5nIiwiYXJndW1lbnRzIiwiY2FsbGVlIiwiY2xhc3MydHlwZSIsImZuVG9TdHJpbmciLCJPYmplY3RGdW5jdGlvblN0cmluZyIsImdldFByb3RvIiwiZ2V0UHJvdG90eXBlT2YiLCJvYmoiLCJwcm90byIsIkN0b3IiXSwibWFwcGluZ3MiOiI7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7QUFBQUEsTUFBTSxDQUFDQyxNQUFQLENBQWM7QUFBQ0MsT0FBSyxFQUFDLE1BQUlBLEtBQVg7QUFBaUJDLE9BQUssRUFBQyxNQUFJQTtBQUEzQixDQUFkO0FBQWlELElBQUlDLGFBQUo7QUFBa0JKLE1BQU0sQ0FBQ0ssSUFBUCxDQUFZLGlCQUFaLEVBQThCO0FBQUNELGVBQWEsQ0FBQ0UsQ0FBRCxFQUFHO0FBQUNGLGlCQUFhLEdBQUNFLENBQWQ7QUFBZ0I7O0FBQWxDLENBQTlCLEVBQWtFLENBQWxFO0FBR25FO0FBQ0E7QUFFQSxNQUFNQyxzQkFBc0IsR0FBRyxJQUFJQyxNQUFNLENBQUNDLG1CQUFYLEVBQS9CO0FBQ0EsTUFBTUMsTUFBTSxHQUFHQyxNQUFNLENBQUNDLFNBQVAsQ0FBaUJDLGNBQWhDO0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBQ08sU0FBU1gsS0FB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bkIsQ0FBZDtBQUFBO0FBRUEsTUFBTTJGLFVBQVUsR0FBRyxFQUFuQjtBQUVBLE1BQU1ILFFBQVEsR0FBR0csVUFBVSxDQUFDSCxRQUE1QjtBQUVBLE1BQU1sRixNQUFNLEdBQUdDLE1BQU0sQ0FBQ0MsU0FBUCxDQUFpQkMsY0FBaEM7QUFFQSxNQUFNbUYsVUFBVSxHQUFHdEYsTUFBTSxDQUFDa0YsUUFBMUI7QUFFQSxNQUFNSyxvQkFBb0IsR0FBR0QsVUFBVSxDQUFDakIsSUFBWCxDQUFnQnBFLE1BQWhCLENBQTdCO0FBRUEsTUFBTXVGLFFBQVEsR0FBR3ZGLE1BQU0sQ0FBQ3dGLGNBQXhCOztBQUVPLE1BQU0vRixhQUFhLEdBQUdnRyxHQUFHLElBQUk7QUFDbEMsTUFBSUMsS0FBSjtBQUNBLE1BQUlDLElBQUosQ0FGa0MsQ0FJbEM7QUFDQTs7QUFDQSxNQUFJLENBQUNGLEdBQUQsSUFBUVIsUUFBUSxDQUFDYixJQUFULENBQWNxQixHQUFkLE1BQXVCLGlCQUFuQyxFQUFzRDtBQUNwRCxXQUFPLEtBQVA7QUFDRDs7QUFFREMsT0FBSyxHQUFHSCxRQUFRLENBQUNFLEdBQUQsQ0FBaEIsQ0FWa0MsQ0FZbEM7O0FBQ0EsTUFBSSxDQUFDQyxLQUFMLEVBQVk7QUFDVixXQUFPLElBQVA7QUFDRCxHQWZpQyxDQWlCbEM7OztBQUNBQyxNQUFJLEdBQUc1RixNQUFNLENBQUNxRSxJQUFQLENBQVlzQixLQUFaLEVBQW1CLGFBQW5CLEtBQXFDQSxLQUFLLENBQUN0RCxXQUFsRDtBQUNBLFNBQU8sT0FBT3VELElBQVAsS0FBZ0IsVUFBaEIsSUFDTE4sVUFBVSxDQUFDakIsSUFBWCxDQUFnQnVCLElBQWhCLE1BQTBCTCxvQkFENUI7QUFFRCxDQXJCTSxDIiwiZmlsZSI6Ii9wYWNrYWdlcy9jaGVjay5qcyIsInNvdXJjZXNDb250ZW50IjpbIi8vIFhYWCBkb2NzXG5pbXBvcnQgeyBpc1BsYWluT2JqZWN0IH0gZnJvbSAnLi9pc1BsYWluT2JqZWN0JztcblxuLy8gVGhpbmdzIHdlIGV4cGxpY2l0bHkgZG8gTk9UIHN1cHBvcnQ6XG4vLyAgICAtIGhldGVyb2dlbm91cyBhcnJheXNcblxuY29uc3QgY3VycmVudEFyZ3VtZW50Q2hlY2tlciA9IG5ldyBNZXRlb3IuRW52aXJvbm1lbnRWYXJpYWJsZTtcbmNvbnN0IGhhc093biA9IE9iamVjdC5wcm90b3R5cGUuaGFzT3duUHJvcGVydHk7XG5cbi8qKlxuICogQHN1bW1hcnkgQ2hlY2sgdGhhdCBhIHZhbHVlIG1hdGNoZXMgYSBbcGF0dGVybl0oI21hdGNocGF0dGVybnMpLlxuICogSWYgdGhlIHZhbHVlIGRvZXMgbm90IG1hdGNoIHRoZSBwYXR0ZXJuLCB0aHJvdyBhIGBNYXRjaC5FcnJvcmAuXG4gKlxuICogUGFydGljdWxhcmx5IHVzZWZ1bCB0byBhc3NlcnQgdGhhdCBhcmd1bWVudHMgdG8gYSBmdW5jdGlvbiBoYXZlIHRoZSByaWdodFxuICogdHlwZXMgYW5kIHN0cnVjdHVyZS5cbiAqIEBsb2N1cyBBbnl3aGVyZVxuICogQHBhcmFtIHtBbnl9IHZhbHVlIFRoZSB2YWx1ZSB0byBjaGVja1xuICogQHBhcmFtIHtNYXRjaFBhdHRlcm59IHBhdHRlcm4gVGhlIHBhdHRlcm4gdG8gbWF0Y2ggYHZhbHVlYCBhZ2FpbnN0XG4gKi9cbmV4cG9ydCBmdW5jdGlvbiBjaGVjayh2YWx1ZSwgcGF0dGVybikge1xuICAvLyBSZWNvcmQgdGhhdCBjaGVjayBnb3QgY2FsbGVkLCBpZiBzb21lYm9keSBjYXJlZC5cbiAgLy9cbiAgLy8gV2UgdXNlIGdldE9yTnVsbElmT3V0c2lkZUZpYmVyIHNvIHRoYXQgaXQncyBPSyB0byBjYWxsIGNoZWNrKClcbiAgLy8gZnJvbSBub24tRmliZXIgc2VydmVyIGNvbnRleHRzOyB0aGUgZG93bnNpZGUgaXMgdGhhdCBpZiB5b3UgZm9yZ2V0IHRvXG4gIC8vIGJpbmRFbnZpcm9ubWVudCBvbiBzb21lIHJhbmRvbSBjYWxsYmFjayBpbiB5b3VyIG1ldGhvZC9wdWJsaXNoZXIsXG4gIC8vIGl0IG1pZ2h0IG5vdCBmaW5kIHRoZSBhcmd1bWVudENoZWNrZXIgYW5kIHlvdSdsbCBnZXQgYW4gZXJyb3IgYWJvdXRcbiAgLy8gbm90IGNoZWNraW5nIGFuIGFyZ3VtZW50IHRoYXQgaXQgbG9va3MgbGlrZSB5b3UncmUgY2hlY2tpbmcgKGluc3RlYWRcbiAgLy8gb2YganVzdCBnZXR0aW5nIGEgXCJOb2RlIGNvZGUgbXVzdCBydW4gaW4gYSBGaWJlclwiIGVycm9yKS5cbiAgY29uc3QgYXJnQ2hlY2tlciA9IGN1cnJlbnRBcmd1bWVudENoZWNrZXIuZ2V0T3JOdWxsSWZPdXRzaWRlRmliZXIoKTtcbiAgaWYgKGFyZ0NoZWNrZXIpIHtcbiAgICBhcmdDaGVja2VyLmNoZWNraW5nKHZhbHVlKTtcbiAgfVxuXG4gIGNvbnN0IHJlc3VsdCA9IHRlc3RTdWJ0cmVlKHZhbHVlLCBwYXR0ZXJuKTtcbiAgaWYgKHJlc3VsdCkge1xuICAgIGNvbnN0IGVyciA9IG5ldyBNYXRjaC5FcnJvcihyZXN1bHQubWVzc2FnZSk7XG4gICAgaWYgKHJlc3VsdC5wYXRoKSB7XG4gICAgICBlcnIubWVzc2FnZSArPSBgIGluIGZpZWxkICR7cmVzdWx0LnBhdGh9YDtcbiAgICAgIGVyci5wYXRoID0gcmVzdWx0LnBhdGg7XG4gICAgfVxuXG4gICAgdGhyb3cgZXJyO1xuICB9XG59O1xuXG4vKipcbiAqIEBuYW1lc3BhY2UgTWF0Y2hcbiAqIEBzdW1tYXJ5IFRoZSBuYW1lc3BhY2UgZm9yIGFsbCBNYXRjaCB0eXBlcyBhbmQgbWV0aG9kcy5cbiAqL1xuZXhwb3J0IGNvbnN0IE1hdGNoID0ge1xuICBPcHRpb25hbDogZnVuY3Rpb24ocGF0dGVybikge1xuICAgIHJldHVybiBuZXcgT3B0aW9uYWwocGF0dGVybik7XG4gIH0sXG5cbiAgTWF5YmU6IGZ1bmN0aW9uKHBhdHRlcm4pIHtcbiAgICByZXR1cm4gbmV3IE1heWJlKHBhdHRlcm4pO1xuICB9LFxuXG4gIE9uZU9mOiBmdW5jdGlvbiguLi5hcmdzKSB7XG4gICAgcmV0dXJuIG5ldyBPbmVPZihhcmdzKTtcbiAgfSxcblxuICBBbnk6IFsnX19hbnlfXyddLFxuICBXaGVyZTogZnVuY3Rpb24oY29uZGl0aW9uKSB7XG4gICAgcmV0dXJuIG5ldyBXaGVyZShjb25kaXRpb24pO1xuICB9LFxuXG4gIE9iamVjdEluY2x1ZGluZzogZnVuY3Rpb24ocGF0dGVybikge1xuICAgIHJldHVybiBuZXcgT2JqZWN0SW5jbHVkaW5nKHBhdHRlcm4pXG4gIH0sXG5cbiAgT2JqZWN0V2l0aFZhbHVlczogZnVuY3Rpb24ocGF0dGVybikge1xuICAgIHJldHVybiBuZXcgT2JqZWN0V2l0aFZhbHVlcyhwYXR0ZXJuKTtcbiAgfSxcblxuICAvLyBNYXRjaGVzIG9ubHkgc2lnbmVkIDMyLWJpdCBpbnRlZ2Vyc1xuICBJbnRlZ2VyOiBbJ19faW50ZWdlcl9fJ10sXG5cbiAgLy8gWFhYIG1hdGNoZXJzIHNob3VsZCBrbm93IGhvdyB0byBkZXNjcmliZSB0aGVtc2VsdmVzIGZvciBlcnJvcnNcbiAgRXJyb3I6IE1ldGVvci5tYWtlRXJyb3JUeXBlKCdNYXRjaC5FcnJvcicsIGZ1bmN0aW9uIChtc2cpIHtcbiAgICB0aGlzLm1lc3NhZ2UgPSBgTWF0Y2ggZXJyb3I6ICR7bXNnfWA7XG5cbiAgICAvLyBUaGUgcGF0aCBvZiB0aGUgdmFsdWUgdGhhdCBmYWlsZWQgdG8gbWF0Y2guIEluaXRpYWxseSBlbXB0eSwgdGhpcyBnZXRzXG4gICAgLy8gcG9wdWxhdGVkIGJ5IGNhdGNoaW5nIGFuZCByZXRocm93aW5nIHRoZSBleGNlcHRpb24gYXMgaXQgZ29lcyBiYWNrIHVwIHRoZVxuICAgIC8vIHN0YWNrLlxuICAgIC8vIEUuZy46IFwidmFsc1szXS5lbnRpdHkuY3JlYXRlZFwiXG4gICAgdGhpcy5wYXRoID0gJyc7XG5cbiAgICAvLyBJZiB0aGlzIGdldHMgc2VudCBvdmVyIEREUCwgZG9uJ3QgZ2l2ZSBmdWxsIGludGVybmFsIGRldGFpbHMgYnV0IGF0IGxlYXN0XG4gICAgLy8gcHJvdmlkZSBzb21ldGhpbmcgYmV0dGVyIHRoYW4gNTAwIEludGVybmFsIHNlcnZlciBlcnJvci5cbiAgICB0aGlzLnNhbml0aXplZEVycm9yID0gbmV3IE1ldGVvci5FcnJvcig0MDAsICdNYXRjaCBmYWlsZWQnKTtcbiAgfSksXG5cbiAgLy8gVGVzdHMgdG8gc2VlIGlmIHZhbHVlIG1hdGNoZXMgcGF0dGVybi4gVW5saWtlIGNoZWNrLCBpdCBtZXJlbHkgcmV0dXJucyB0cnVlXG4gIC8vIG9yIGZhbHNlICh1bmxlc3MgYW4gZXJyb3Igb3RoZXIgdGhhbiBNYXRjaC5FcnJvciB3YXMgdGhyb3duKS4gSXQgZG9lcyBub3RcbiAgLy8gaW50ZXJhY3Qgd2l0aCBfZmFpbElmQXJndW1lbnRzQXJlTm90QWxsQ2hlY2tlZC5cbiAgLy8gWFhYIG1heWJlIGFsc28gaW1wbGVtZW50IGEgTWF0Y2gubWF0Y2ggd2hpY2ggcmV0dXJucyBtb3JlIGluZm9ybWF0aW9uIGFib3V0XG4gIC8vICAgICBmYWlsdXJlcyBidXQgd2l0aG91dCB1c2luZyBleGNlcHRpb24gaGFuZGxpbmcgb3IgZG9pbmcgd2hhdCBjaGVjaygpXG4gIC8vICAgICBkb2VzIHdpdGggX2ZhaWxJZkFyZ3VtZW50c0FyZU5vdEFsbENoZWNrZWQgYW5kIE1ldGVvci5FcnJvciBjb252ZXJzaW9uXG5cbiAgLyoqXG4gICAqIEBzdW1tYXJ5IFJldHVybnMgdHJ1ZSBpZiB0aGUgdmFsdWUgbWF0Y2hlcyB0aGUgcGF0dGVybi5cbiAgICogQGxvY3VzIEFueXdoZXJlXG4gICAqIEBwYXJhbSB7QW55fSB2YWx1ZSBUaGUgdmFsdWUgdG8gY2hlY2tcbiAgICogQHBhcmFtIHtNYXRjaFBhdHRlcm59IHBhdHRlcm4gVGhlIHBhdHRlcm4gdG8gbWF0Y2ggYHZhbHVlYCBhZ2FpbnN0XG4gICAqL1xuICB0ZXN0KHZhbHVlLCBwYXR0ZXJuKSB7XG4gICAgcmV0dXJuICF0ZXN0U3VidHJlZSh2YWx1ZSwgcGF0dGVybik7XG4gIH0sXG5cbiAgLy8gUnVucyBgZi5hcHBseShjb250ZXh0LCBhcmdzKWAuIElmIGNoZWNrKCkgaXMgbm90IGNhbGxlZCBvbiBldmVyeSBlbGVtZW50IG9mXG4gIC8vIGBhcmdzYCAoZWl0aGVyIGRpcmVjdGx5IG9yIGluIHRoZSBmaXJzdCBsZXZlbCBvZiBhbiBhcnJheSksIHRocm93cyBhbiBlcnJvclxuICAvLyAodXNpbmcgYGRlc2NyaXB0aW9uYCBpbiB0aGUgbWVzc2FnZSkuXG4gIF9mYWlsSWZBcmd1bWVudHNBcmVOb3RBbGxDaGVja2VkKGYsIGNvbnRleHQsIGFyZ3MsIGRlc2NyaXB0aW9uKSB7XG4gICAgY29uc3QgYXJnQ2hlY2tlciA9IG5ldyBBcmd1bWVudENoZWNrZXIoYXJncywgZGVzY3JpcHRpb24pO1xuICAgIGNvbnN0IHJlc3VsdCA9IGN1cnJlbnRBcmd1bWVudENoZWNrZXIud2l0aFZhbHVlKFxuICAgICAgYXJnQ2hlY2tlciwgXG4gICAgICAoKSA9PiBmLmFwcGx5KGNvbnRleHQsIGFyZ3MpXG4gICAgKTtcblxuICAgIC8vIElmIGYgZGlkbid0IGl0c2VsZiB0aHJvdywgbWFrZSBzdXJlIGl0IGNoZWNrZWQgYWxsIG9mIGl0cyBhcmd1bWVudHMuXG4gICAgYXJnQ2hlY2tlci50aHJvd1VubGVzc0FsbEFyZ3VtZW50c0hhdmVCZWVuQ2hlY2tlZCgpO1xuICAgIHJldHVybiByZXN1bHQ7XG4gIH1cbn07XG5cbmNsYXNzIE9wdGlvbmFsIHtcbiAgY29uc3RydWN0b3IocGF0dGVybikge1xuICAgIHRoaXMucGF0dGVybiA9IHBhdHRlcm47XG4gIH1cbn1cblxuY2xhc3MgTWF5YmUge1xuICBjb25zdHJ1Y3RvcihwYXR0ZXJuKSB7XG4gICAgdGhpcy5wYXR0ZXJuID0gcGF0dGVybjtcbiAgfVxufVxuXG5jbGFzcyBPbmVPZiB7XG4gIGNvbnN0cnVjdG9yKGNob2ljZXMpIHtcbiAgICBpZiAoIWNob2ljZXMgfHwgY2hvaWNlcy5sZW5ndGggPT09IDApIHtcbiAgICAgIHRocm93IG5ldyBFcnJvcignTXVzdCBwcm92aWRlIGF0IGxlYXN0IG9uZSBjaG9pY2UgdG8gTWF0Y2guT25lT2YnKTtcbiAgICB9XG5cbiAgICB0aGlzLmNob2ljZXMgPSBjaG9pY2VzO1xuICB9XG59XG5cbmNsYXNzIFdoZXJlIHtcbiAgY29uc3RydWN0b3IoY29uZGl0aW9uKSB7XG4gICAgdGhpcy5jb25kaXRpb24gPSBjb25kaXRpb247XG4gIH1cbn1cblxuY2xhc3MgT2JqZWN0SW5jbHVkaW5nIHtcbiAgY29uc3RydWN0b3IocGF0dGVybikge1xuICAgIHRoaXMucGF0dGVybiA9IHBhdHRlcm47XG4gIH1cbn1cblxuY2xhc3MgT2JqZWN0V2l0aFZhbHVlcyB7XG4gIGNvbnN0cnVjdG9yKHBhdHRlcm4pIHtcbiAgICB0aGlzLnBhdHRlcm4gPSBwYXR0ZXJuO1xuICB9XG59XG5cbmNvbnN0IHN0cmluZ0ZvckVycm9yTWVzc2FnZSA9ICh2YWx1ZSwgb3B0aW9ucyA9IHt9KSA9PiB7XG4gIGlmICggdmFsdWUgPT09IG51bGwgKSB7XG4gICAgcmV0dXJuICdudWxsJztcbiAgfVxuXG4gIGlmICggb3B0aW9ucy5vbmx5U2hvd1R5cGUgKSB7XG4gICAgcmV0dXJuIHR5cGVvZiB2YWx1ZTtcbiAgfVxuXG4gIC8vIFlvdXIgYXZlcmFnZSBub24tb2JqZWN0IHRoaW5ncy4gIFNhdmVzIGZyb20gZG9pbmcgdGhlIHRyeS9jYXRjaCBiZWxvdyBmb3IuXG4gIGlmICggdHlwZW9mIHZhbHVlICE9PSAnb2JqZWN0JyApIHtcbiAgICByZXR1cm4gRUpTT04uc3RyaW5naWZ5KHZhbHVlKVxuICB9XG5cbiAgdHJ5IHtcblxuICAgIC8vIEZpbmQgb2JqZWN0cyB3aXRoIGNpcmN1bGFyIHJlZmVyZW5jZXMgc2luY2UgRUpTT04gZG9lc24ndCBzdXBwb3J0IHRoZW0geWV0IChJc3N1ZSAjNDc3OCArIFVuYWNjZXB0ZWQgUFIpXG4gICAgLy8gSWYgdGhlIG5hdGl2ZSBzdHJpbmdpZnkgaXMgZ29pbmcgdG8gY2hva2UsIEVKU09OLnN0cmluZ2lmeSBpcyBnb2luZyB0byBjaG9rZSB0b28uXG4gICAgSlNPTi5zdHJpbmdpZnkodmFsdWUpO1xuICB9IGNhdGNoIChzdHJpbmdpZnlFcnJvcikge1xuICAgIGlmICggc3RyaW5naWZ5RXJyb3IubmFtZSA9PT0gJ1R5cGVFcnJvcicgKSB7XG4gICAgICByZXR1cm4gdHlwZW9mIHZhbHVlO1xuICAgIH1cbiAgfVxuXG4gIHJldHVybiBFSlNPTi5zdHJpbmdpZnkodmFsdWUpO1xufTtcblxuY29uc3QgdHlwZW9mQ2hlY2tzID0gW1xuICBbU3RyaW5nLCAnc3RyaW5nJ10sXG4gIFtOdW1iZXIsICdudW1iZXInXSxcbiAgW0Jvb2xlYW4sICdib29sZWFuJ10sXG5cbiAgLy8gV2hpbGUgd2UgZG9uJ3QgYWxsb3cgdW5kZWZpbmVkL2Z1bmN0aW9uIGluIEVKU09OLCB0aGlzIGlzIGdvb2QgZm9yIG9wdGlvbmFsXG4gIC8vIGFyZ3VtZW50cyB3aXRoIE9uZU9mLlxuICBbRnVuY3Rpb24sICdmdW5jdGlvbiddLFxuICBbdW5kZWZpbmVkLCAndW5kZWZpbmVkJ10sXG5dO1xuXG4vLyBSZXR1cm4gYGZhbHNlYCBpZiBpdCBtYXRjaGVzLiBPdGhlcndpc2UsIHJldHVybiBhbiBvYmplY3Qgd2l0aCBhIGBtZXNzYWdlYCBhbmQgYSBgcGF0aGAgZmllbGQuXG5jb25zdCB0ZXN0U3VidHJlZSA9ICh2YWx1ZSwgcGF0dGVybikgPT4ge1xuXG4gIC8vIE1hdGNoIGFueXRoaW5nIVxuICBpZiAocGF0dGVybiA9PT0gTWF0Y2guQW55KSB7XG4gICAgcmV0dXJuIGZhbHNlO1xuICB9XG5cbiAgLy8gQmFzaWMgYXRvbWljIHR5cGVzLlxuICAvLyBEbyBub3QgbWF0Y2ggYm94ZWQgb2JqZWN0cyAoZS5nLiBTdHJpbmcsIEJvb2xlYW4pXG4gIGZvciAobGV0IGkgPSAwOyBpIDwgdHlwZW9mQ2hlY2tzLmxlbmd0aDsgKytpKSB7XG4gICAgaWYgKHBhdHRlcm4gPT09IHR5cGVvZkNoZWNrc1tpXVswXSkge1xuICAgICAgaWYgKHR5cGVvZiB2YWx1ZSA9PT0gdHlwZW9mQ2hlY2tzW2ldWzFdKSB7XG4gICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIHtcbiAgICAgICAgbWVzc2FnZTogYEV4cGVjdGVkICR7dHlwZW9mQ2hlY2tzW2ldWzFdfSwgZ290ICR7c3RyaW5nRm9yRXJyb3JNZXNzYWdlKHZhbHVlLCB7IG9ubHlTaG93VHlwZTogdHJ1ZSB9KX1gLFxuICAgICAgICBwYXRoOiAnJyxcbiAgICAgIH07XG4gICAgfVxuICB9XG5cbiAgaWYgKHBhdHRlcm4gPT09IG51bGwpIHtcbiAgICBpZiAodmFsdWUgPT09IG51bGwpIHtcbiAgICAgIHJldHVybiBmYWxzZTtcbiAgICB9XG5cbiAgICByZXR1cm4ge1xuICAgICAgbWVzc2FnZTogYEV4cGVjdGVkIG51bGwsIGdvdCAke3N0cmluZ0ZvckVycm9yTWVzc2FnZSh2YWx1ZSl9YCxcbiAgICAgIHBhdGg6ICcnLFxuICAgIH07XG4gIH1cblxuICAvLyBTdHJpbmdzLCBudW1iZXJzLCBhbmQgYm9vbGVhbnMgbWF0Y2ggbGl0ZXJhbGx5LiBHb2VzIHdlbGwgd2l0aCBNYXRjaC5PbmVPZi5cbiAgaWYgKHR5cGVvZiBwYXR0ZXJuID09PSAnc3RyaW5nJyB8fCB0eXBlb2YgcGF0dGVybiA9PT0gJ251bWJlcicgfHwgdHlwZW9mIHBhdHRlcm4gPT09ICdib29sZWFuJykge1xuICAgIGlmICh2YWx1ZSA9PT0gcGF0dGVybikge1xuICAgICAgcmV0dXJuIGZhbHNlO1xuICAgIH1cblxuICAgIHJldHVybiB7XG4gICAgICBtZXNzYWdlOiBgRXhwZWN0ZWQgJHtwYXR0ZXJufSwgZ290ICR7c3RyaW5nRm9yRXJyb3JNZXNzYWdlKHZhbHVlKX1gLFxuICAgICAgcGF0aDogJycsXG4gICAgfTtcbiAgfVxuXG4gIC8vIE1hdGNoLkludGVnZXIgaXMgc3BlY2lhbCB0eXBlIGVuY29kZWQgd2l0aCBhcnJheVxuICBpZiAocGF0dGVybiA9PT0gTWF0Y2guSW50ZWdlcikge1xuXG4gICAgLy8gVGhlcmUgaXMgbm8gY29uc2lzdGVudCBhbmQgcmVsaWFibGUgd2F5IHRvIGNoZWNrIGlmIHZhcmlhYmxlIGlzIGEgNjQtYml0XG4gICAgLy8gaW50ZWdlci4gT25lIG9mIHRoZSBwb3B1bGFyIHNvbHV0aW9ucyBpcyB0byBnZXQgcmVtaW5kZXIgb2YgZGl2aXNpb24gYnkgMVxuICAgIC8vIGJ1dCB0aGlzIG1ldGhvZCBmYWlscyBvbiByZWFsbHkgbGFyZ2UgZmxvYXRzIHdpdGggYmlnIHByZWNpc2lvbi5cbiAgICAvLyBFLmcuOiAxLjM0ODE5MjMwODQ5MTgyNGUrMjMgJSAxID09PSAwIGluIFY4XG4gICAgLy8gQml0d2lzZSBvcGVyYXRvcnMgd29yayBjb25zaXN0YW50bHkgYnV0IGFsd2F5cyBjYXN0IHZhcmlhYmxlIHRvIDMyLWJpdFxuICAgIC8vIHNpZ25lZCBpbnRlZ2VyIGFjY29yZGluZyB0byBKYXZhU2NyaXB0IHNwZWNzLlxuICAgIGlmICh0eXBlb2YgdmFsdWUgPT09ICdudW1iZXInICYmICh2YWx1ZSB8IDApID09PSB2YWx1ZSkge1xuICAgICAgcmV0dXJuIGZhbHNlO1xuICAgIH1cbiAgICBcbiAgICByZXR1cm4ge1xuICAgICAgbWVzc2FnZTogYEV4cGVjdGVkIEludGVnZXIsIGdvdCAke3N0cmluZ0ZvckVycm9yTWVzc2FnZSh2YWx1ZSl9YCxcbiAgICAgIHBhdGg6ICcnLFxuICAgIH07XG4gIH1cblxuICAvLyAnT2JqZWN0JyBpcyBzaG9ydGhhbmQgZm9yIE1hdGNoLk9iamVjdEluY2x1ZGluZyh7fSk7XG4gIGlmIChwYXR0ZXJuID09PSBPYmplY3QpIHtcbiAgICBwYXR0ZXJuID0gTWF0Y2guT2JqZWN0SW5jbHVkaW5nKHt9KTtcbiAgfVxuXG4gIC8vIEFycmF5IChjaGVja2VkIEFGVEVSIEFueSwgd2hpY2ggaXMgaW1wbGVtZW50ZWQgYXMgYW4gQXJyYXkpLlxuICBpZiAocGF0dGVybiBpbnN0YW5jZW9mIEFycmF5KSB7XG4gICAgaWYgKHBhdHRlcm4ubGVuZ3RoICE9PSAxKSB7XG4gICAgICByZXR1cm4ge1xuICAgICAgICBtZXNzYWdlOiBgQmFkIHBhdHRlcm46IGFycmF5cyBtdXN0IGhhdmUgb25lIHR5cGUgZWxlbWVudCAke3N0cmluZ0ZvckVycm9yTWVzc2FnZShwYXR0ZXJuKX1gLFxuICAgICAgICBwYXRoOiAnJyxcbiAgICAgIH07XG4gICAgfVxuXG4gICAgaWYgKCFBcnJheS5pc0FycmF5KHZhbHVlKSAmJiAhaXNBcmd1bWVudHModmFsdWUpKSB7XG4gICAgICByZXR1cm4ge1xuICAgICAgICBtZXNzYWdlOiBgRXhwZWN0ZWQgYXJyYXksIGdvdCAke3N0cmluZ0ZvckVycm9yTWVzc2FnZSh2YWx1ZSl9YCxcbiAgICAgICAgcGF0aDogJycsXG4gICAgICB9O1xuICAgIH1cblxuICAgIGZvciAobGV0IGkgPSAwLCBsZW5ndGggPSB2YWx1ZS5sZW5ndGg7IGkgPCBsZW5ndGg7IGkrKykge1xuICAgICAgY29uc3QgcmVzdWx0ID0gdGVzdFN1YnRyZWUodmFsdWVbaV0sIHBhdHRlcm5bMF0pO1xuICAgICAgaWYgKHJlc3VsdCkge1xuICAgICAgICByZXN1bHQucGF0aCA9IF9wcmVwZW5kUGF0aChpLCByZXN1bHQucGF0aCk7XG4gICAgICAgIHJldHVybiByZXN1bHQ7XG4gICAgICB9XG4gICAgfVxuICAgIFxuICAgIHJldHVybiBmYWxzZTtcbiAgfVxuXG4gIC8vIEFyYml0cmFyeSB2YWxpZGF0aW9uIGNoZWNrcy4gVGhlIGNvbmRpdGlvbiBjYW4gcmV0dXJuIGZhbHNlIG9yIHRocm93IGFcbiAgLy8gTWF0Y2guRXJyb3IgKGllLCBpdCBjYW4gaW50ZXJuYWxseSB1c2UgY2hlY2soKSkgdG8gZmFpbC5cbiAgaWYgKHBhdHRlcm4gaW5zdGFuY2VvZiBXaGVyZSkge1xuICAgIGxldCByZXN1bHQ7XG4gICAgdHJ5IHtcbiAgICAgIHJlc3VsdCA9IHBhdHRlcm4uY29uZGl0aW9uKHZhbHVlKTtcbiAgICB9IGNhdGNoIChlcnIpIHtcbiAgICAgIGlmICghKGVyciBpbnN0YW5jZW9mIE1hdGNoLkVycm9yKSkge1xuICAgICAgICB0aHJvdyBlcnI7XG4gICAgICB9XG4gICAgICBcbiAgICAgIHJldHVybiB7XG4gICAgICAgIG1lc3NhZ2U6IGVyci5tZXNzYWdlLFxuICAgICAgICBwYXRoOiBlcnIucGF0aFxuICAgICAgfTtcbiAgICB9XG5cbiAgICBpZiAocmVzdWx0KSB7XG4gICAgICByZXR1cm4gZmFsc2U7XG4gICAgfVxuXG4gICAgLy8gWFhYIHRoaXMgZXJyb3IgaXMgdGVycmlibGVcbiAgICByZXR1cm4ge1xuICAgICAgbWVzc2FnZTogJ0ZhaWxlZCBNYXRjaC5XaGVyZSB2YWxpZGF0aW9uJyxcbiAgICAgIHBhdGg6ICcnLFxuICAgIH07XG4gIH1cblxuICBpZiAocGF0dGVybiBpbnN0YW5jZW9mIE1heWJlKSB7XG4gICAgcGF0dGVybiA9IE1hdGNoLk9uZU9mKHVuZGVmaW5lZCwgbnVsbCwgcGF0dGVybi5wYXR0ZXJuKTtcbiAgfSBlbHNlIGlmIChwYXR0ZXJuIGluc3RhbmNlb2YgT3B0aW9uYWwpIHtcbiAgICBwYXR0ZXJuID0gTWF0Y2guT25lT2YodW5kZWZpbmVkLCBwYXR0ZXJuLnBhdHRlcm4pO1xuICB9XG5cbiAgaWYgKHBhdHRlcm4gaW5zdGFuY2VvZiBPbmVPZikge1xuICAgIGZvciAobGV0IGkgPSAwOyBpIDwgcGF0dGVybi5jaG9pY2VzLmxlbmd0aDsgKytpKSB7XG4gICAgICBjb25zdCByZXN1bHQgPSB0ZXN0U3VidHJlZSh2YWx1ZSwgcGF0dGVybi5jaG9pY2VzW2ldKTtcbiAgICAgIGlmICghcmVzdWx0KSB7XG5cbiAgICAgICAgLy8gTm8gZXJyb3I/IFlheSwgcmV0dXJuLlxuICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICB9XG5cbiAgICAgIC8vIE1hdGNoIGVycm9ycyBqdXN0IG1lYW4gdHJ5IGFub3RoZXIgY2hvaWNlLlxuICAgIH1cblxuICAgIC8vIFhYWCB0aGlzIGVycm9yIGlzIHRlcnJpYmxlXG4gICAgcmV0dXJuIHtcbiAgICAgIG1lc3NhZ2U6ICdGYWlsZWQgTWF0Y2guT25lT2YsIE1hdGNoLk1heWJlIG9yIE1hdGNoLk9wdGlvbmFsIHZhbGlkYXRpb24nLFxuICAgICAgcGF0aDogJycsXG4gICAgfTtcbiAgfVxuXG4gIC8vIEEgZnVuY3Rpb24gdGhhdCBpc24ndCBzb21ldGhpbmcgd2Ugc3BlY2lhbC1jYXNlIGlzIGFzc3VtZWQgdG8gYmUgYVxuICAvLyBjb25zdHJ1Y3Rvci5cbiAgaWYgKHBhdHRlcm4gaW5zdGFuY2VvZiBGdW5jdGlvbikge1xuICAgIGlmICh2YWx1ZSBpbnN0YW5jZW9mIHBhdHRlcm4pIHtcbiAgICAgIHJldHVybiBmYWxzZTtcbiAgICB9XG5cbiAgICByZXR1cm4ge1xuICAgICAgbWVzc2FnZTogYEV4cGVjdGVkICR7cGF0dGVybi5uYW1lIHx8ICdwYXJ0aWN1bGFyIGNvbnN0cnVjdG9yJ31gLFxuICAgICAgcGF0aDogJycsXG4gICAgfTtcbiAgfVxuXG4gIGxldCB1bmtub3duS2V5c0FsbG93ZWQgPSBmYWxzZTtcbiAgbGV0IHVua25vd25LZXlQYXR0ZXJuO1xuICBpZiAocGF0dGVybiBpbnN0YW5jZW9mIE9iamVjdEluY2x1ZGluZykge1xuICAgIHVua25vd25LZXlzQWxsb3dlZCA9IHRydWU7XG4gICAgcGF0dGVybiA9IHBhdHRlcm4ucGF0dGVybjtcbiAgfVxuXG4gIGlmIChwYXR0ZXJuIGluc3RhbmNlb2YgT2JqZWN0V2l0aFZhbHVlcykge1xuICAgIHVua25vd25LZXlzQWxsb3dlZCA9IHRydWU7XG4gICAgdW5rbm93bktleVBhdHRlcm4gPSBbcGF0dGVybi5wYXR0ZXJuXTtcbiAgICBwYXR0ZXJuID0ge307ICAvLyBubyByZXF1aXJlZCBrZXlzXG4gIH1cblxuICBpZiAodHlwZW9mIHBhdHRlcm4gIT09ICdvYmplY3QnKSB7XG4gICAgcmV0dXJuIHtcbiAgICAgIG1lc3NhZ2U6ICdCYWQgcGF0dGVybjogdW5rbm93biBwYXR0ZXJuIHR5cGUnLFxuICAgICAgcGF0aDogJycsXG4gICAgfTtcbiAgfVxuXG4gIC8vIEFuIG9iamVjdCwgd2l0aCByZXF1aXJlZCBhbmQgb3B0aW9uYWwga2V5cy4gTm90ZSB0aGF0IHRoaXMgZG9lcyBOT1QgZG9cbiAgLy8gc3RydWN0dXJhbCBtYXRjaGVzIGFnYWluc3Qgb2JqZWN0cyBvZiBzcGVjaWFsIHR5cGVzIHRoYXQgaGFwcGVuIHRvIG1hdGNoXG4gIC8vIHRoZSBwYXR0ZXJuOiB0aGlzIHJlYWxseSBuZWVkcyB0byBiZSBhIHBsYWluIG9sZCB7T2JqZWN0fSFcbiAgaWYgKHR5cGVvZiB2YWx1ZSAhPT0gJ29iamVjdCcpIHtcbiAgICByZXR1cm4ge1xuICAgICAgbWVzc2FnZTogYEV4cGVjdGVkIG9iamVjdCwgZ290ICR7dHlwZW9mIHZhbHVlfWAsXG4gICAgICBwYXRoOiAnJyxcbiAgICB9O1xuICB9XG5cbiAgaWYgKHZhbHVlID09PSBudWxsKSB7XG4gICAgcmV0dXJuIHtcbiAgICAgIG1lc3NhZ2U6IGBFeHBlY3RlZCBvYmplY3QsIGdvdCBudWxsYCxcbiAgICAgIHBhdGg6ICcnLFxuICAgIH07XG4gIH1cblxuICBpZiAoISBpc1BsYWluT2JqZWN0KHZhbHVlKSkge1xuICAgIHJldHVybiB7XG4gICAgICBtZXNzYWdlOiBgRXhwZWN0ZWQgcGxhaW4gb2JqZWN0YCxcbiAgICAgIHBhdGg6ICcnLFxuICAgIH07XG4gIH1cblxuICBjb25zdCByZXF1aXJlZFBhdHRlcm5zID0gT2JqZWN0LmNyZWF0ZShudWxsKTtcbiAgY29uc3Qgb3B0aW9uYWxQYXR0ZXJucyA9IE9iamVjdC5jcmVhdGUobnVsbCk7XG5cbiAgT2JqZWN0LmtleXMocGF0dGVybikuZm9yRWFjaChrZXkgPT4ge1xuICAgIGNvbnN0IHN1YlBhdHRlcm4gPSBwYXR0ZXJuW2tleV07XG4gICAgaWYgKHN1YlBhdHRlcm4gaW5zdGFuY2VvZiBPcHRpb25hbCB8fFxuICAgICAgICBzdWJQYXR0ZXJuIGluc3RhbmNlb2YgTWF5YmUpIHtcbiAgICAgIG9wdGlvbmFsUGF0dGVybnNba2V5XSA9IHN1YlBhdHRlcm4ucGF0dGVybjtcbiAgICB9IGVsc2Uge1xuICAgICAgcmVxdWlyZWRQYXR0ZXJuc1trZXldID0gc3ViUGF0dGVybjtcbiAgICB9XG4gIH0pO1xuXG4gIGZvciAobGV0IGtleSBpbiBPYmplY3QodmFsdWUpKSB7XG4gICAgY29uc3Qgc3ViVmFsdWUgPSB2YWx1ZVtrZXldO1xuICAgIGlmIChoYXNPd24uY2FsbChyZXF1aXJlZFBhdHRlcm5zLCBrZXkpKSB7XG4gICAgICBjb25zdCByZXN1bHQgPSB0ZXN0U3VidHJlZShzdWJWYWx1ZSwgcmVxdWlyZWRQYXR0ZXJuc1trZXldKTtcbiAgICAgIGlmIChyZXN1bHQpIHtcbiAgICAgICAgcmVzdWx0LnBhdGggPSBfcHJlcGVuZFBhdGgoa2V5LCByZXN1bHQucGF0aCk7XG4gICAgICAgIHJldHVybiByZXN1bHQ7XG4gICAgICB9XG5cbiAgICAgIGRlbGV0ZSByZXF1aXJlZFBhdHRlcm5zW2tleV07XG4gICAgfSBlbHNlIGlmIChoYXNPd24uY2FsbChvcHRpb25hbFBhdHRlcm5zLCBrZXkpKSB7XG4gICAgICBjb25zdCByZXN1bHQgPSB0ZXN0U3VidHJlZShzdWJWYWx1ZSwgb3B0aW9uYWxQYXR0ZXJuc1trZXldKTtcbiAgICAgIGlmIChyZXN1bHQpIHtcbiAgICAgICAgcmVzdWx0LnBhdGggPSBfcHJlcGVuZFBhdGgoa2V5LCByZXN1bHQucGF0aCk7XG4gICAgICAgIHJldHVybiByZXN1bHQ7XG4gICAgICB9XG5cbiAgICB9IGVsc2Uge1xuICAgICAgaWYgKCF1bmtub3duS2V5c0FsbG93ZWQpIHtcbiAgICAgICAgcmV0dXJuIHtcbiAgICAgICAgICBtZXNzYWdlOiAnVW5rbm93biBrZXknLFxuICAgICAgICAgIHBhdGg6IGtleSxcbiAgICAgICAgfTtcbiAgICAgIH1cblxuICAgICAgaWYgKHVua25vd25LZXlQYXR0ZXJuKSB7XG4gICAgICAgIGNvbnN0IHJlc3VsdCA9IHRlc3RTdWJ0cmVlKHN1YlZhbHVlLCB1bmtub3duS2V5UGF0dGVyblswXSk7XG4gICAgICAgIGlmIChyZXN1bHQpIHtcbiAgICAgICAgICByZXN1bHQucGF0aCA9IF9wcmVwZW5kUGF0aChrZXksIHJlc3VsdC5wYXRoKTtcbiAgICAgICAgICByZXR1cm4gcmVzdWx0O1xuICAgICAgICB9XG4gICAgICB9XG4gICAgfVxuICB9XG5cbiAgY29uc3Qga2V5cyA9IE9iamVjdC5rZXlzKHJlcXVpcmVkUGF0dGVybnMpO1xuICBpZiAoa2V5cy5sZW5ndGgpIHtcbiAgICByZXR1cm4ge1xuICAgICAgbWVzc2FnZTogYE1pc3Npbmcga2V5ICcke2tleXNbMF19J2AsXG4gICAgICBwYXRoOiAnJyxcbiAgICB9O1xuICB9XG59O1xuXG5jbGFzcyBBcmd1bWVudENoZWNrZXIge1xuICBjb25zdHJ1Y3RvciAoYXJncywgZGVzY3JpcHRpb24pIHtcblxuICAgIC8vIE1ha2UgYSBTSEFMTE9XIGNvcHkgb2YgdGhlIGFyZ3VtZW50cy4gKFdlJ2xsIGJlIGRvaW5nIGlkZW50aXR5IGNoZWNrc1xuICAgIC8vIGFnYWluc3QgaXRzIGNvbnRlbnRzLilcbiAgICB0aGlzLmFyZ3MgPSBbLi4uYXJnc107XG5cbiAgICAvLyBTaW5jZSB0aGUgY29tbW9uIGNhc2Ugd2lsbCBiZSB0byBjaGVjayBhcmd1bWVudHMgaW4gb3JkZXIsIGFuZCB3ZSBzcGxpY2VcbiAgICAvLyBvdXQgYXJndW1lbnRzIHdoZW4gd2UgY2hlY2sgdGhlbSwgbWFrZSBpdCBzbyB3ZSBzcGxpY2Ugb3V0IGZyb20gdGhlIGVuZFxuICAgIC8vIHJhdGhlciB0aGFuIHRoZSBiZWdpbm5pbmcuXG4gICAgdGhpcy5hcmdzLnJldmVyc2UoKTtcbiAgICB0aGlzLmRlc2NyaXB0aW9uID0gZGVzY3JpcHRpb247XG4gIH1cblxuICBjaGVja2luZyh2YWx1ZSkge1xuICAgIGlmICh0aGlzLl9jaGVja2luZ09uZVZhbHVlKHZhbHVlKSkge1xuICAgICAgcmV0dXJuO1xuICAgIH1cblxuICAgIC8vIEFsbG93IGNoZWNrKGFyZ3VtZW50cywgW1N0cmluZ10pIG9yIGNoZWNrKGFyZ3VtZW50cy5zbGljZSgxKSwgW1N0cmluZ10pXG4gICAgLy8gb3IgY2hlY2soW2ZvbywgYmFyXSwgW1N0cmluZ10pIHRvIGNvdW50Li4uIGJ1dCBvbmx5IGlmIHZhbHVlIHdhc24ndFxuICAgIC8vIGl0c2VsZiBhbiBhcmd1bWVudC5cbiAgICBpZiAoQXJyYXkuaXNBcnJheSh2YWx1ZSkgfHwgaXNBcmd1bWVudHModmFsdWUpKSB7XG4gICAgICBBcnJheS5wcm90b3R5cGUuZm9yRWFjaC5jYWxsKHZhbHVlLCB0aGlzLl9jaGVja2luZ09uZVZhbHVlLmJpbmQodGhpcykpO1xuICAgIH1cbiAgfVxuXG4gIF9jaGVja2luZ09uZVZhbHVlKHZhbHVlKSB7XG4gICAgZm9yIChsZXQgaSA9IDA7IGkgPCB0aGlzLmFyZ3MubGVuZ3RoOyArK2kpIHtcblxuICAgICAgLy8gSXMgdGhpcyB2YWx1ZSBvbmUgb2YgdGhlIGFyZ3VtZW50cz8gKFRoaXMgY2FuIGhhdmUgYSBmYWxzZSBwb3NpdGl2ZSBpZlxuICAgICAgLy8gdGhlIGFyZ3VtZW50IGlzIGFuIGludGVybmVkIHByaW1pdGl2ZSwgYnV0IGl0J3Mgc3RpbGwgYSBnb29kIGVub3VnaFxuICAgICAgLy8gY2hlY2suKVxuICAgICAgLy8gKE5hTiBpcyBub3QgPT09IHRvIGl0c2VsZiwgc28gd2UgaGF2ZSB0byBjaGVjayBzcGVjaWFsbHkuKVxuICAgICAgaWYgKHZhbHVlID09PSB0aGlzLmFyZ3NbaV0gfHxcbiAgICAgICAgICAoTnVtYmVyLmlzTmFOKHZhbHVlKSAmJiBOdW1iZXIuaXNOYU4odGhpcy5hcmdzW2ldKSkpIHtcbiAgICAgICAgdGhpcy5hcmdzLnNwbGljZShpLCAxKTtcbiAgICAgICAgcmV0dXJuIHRydWU7XG4gICAgICB9XG4gICAgfVxuICAgIHJldHVybiBmYWxzZTtcbiAgfVxuXG4gIHRocm93VW5sZXNzQWxsQXJndW1lbnRzSGF2ZUJlZW5DaGVja2VkKCkge1xuICAgIGlmICh0aGlzLmFyZ3MubGVuZ3RoID4gMClcbiAgICAgIHRocm93IG5ldyBFcnJvcihgRGlkIG5vdCBjaGVjaygpIGFsbCBhcmd1bWVudHMgZHVyaW5nICR7dGhpcy5kZXNjcmlwdGlvbn1gKTtcbiAgfVxufVxuXG5jb25zdCBfanNLZXl3b3JkcyA9IFsnZG8nLCAnaWYnLCAnaW4nLCAnZm9yJywgJ2xldCcsICduZXcnLCAndHJ5JywgJ3ZhcicsICdjYXNlJyxcbiAgJ2Vsc2UnLCAnZW51bScsICdldmFsJywgJ2ZhbHNlJywgJ251bGwnLCAndGhpcycsICd0cnVlJywgJ3ZvaWQnLCAnd2l0aCcsXG4gICdicmVhaycsICdjYXRjaCcsICdjbGFzcycsICdjb25zdCcsICdzdXBlcicsICd0aHJvdycsICd3aGlsZScsICd5aWVsZCcsXG4gICdkZWxldGUnLCAnZXhwb3J0JywgJ2ltcG9ydCcsICdwdWJsaWMnLCAncmV0dXJuJywgJ3N0YXRpYycsICdzd2l0Y2gnLFxuICAndHlwZW9mJywgJ2RlZmF1bHQnLCAnZXh0ZW5kcycsICdmaW5hbGx5JywgJ3BhY2thZ2UnLCAncHJpdmF0ZScsICdjb250aW51ZScsXG4gICdkZWJ1Z2dlcicsICdmdW5jdGlvbicsICdhcmd1bWVudHMnLCAnaW50ZXJmYWNlJywgJ3Byb3RlY3RlZCcsICdpbXBsZW1lbnRzJyxcbiAgJ2luc3RhbmNlb2YnXTtcblxuLy8gQXNzdW1lcyB0aGUgYmFzZSBvZiBwYXRoIGlzIGFscmVhZHkgZXNjYXBlZCBwcm9wZXJseVxuLy8gcmV0dXJucyBrZXkgKyBiYXNlXG5jb25zdCBfcHJlcGVuZFBhdGggPSAoa2V5LCBiYXNlKSA9PiB7XG4gIGlmICgodHlwZW9mIGtleSkgPT09ICdudW1iZXInIHx8IGtleS5tYXRjaCgvXlswLTldKyQvKSkge1xuICAgIGtleSA9IGBbJHtrZXl9XWA7XG4gIH0gZWxzZSBpZiAoIWtleS5tYXRjaCgvXlthLXpfJF1bMC05YS16XyRdKiQvaSkgfHxcbiAgICAgICAgICAgICBfanNLZXl3b3Jkcy5pbmRleE9mKGtleSkgPj0gMCkge1xuICAgIGtleSA9IEpTT04uc3RyaW5naWZ5KFtrZXldKTtcbiAgfVxuXG4gIGlmIChiYXNlICYmIGJhc2VbMF0gIT09ICdbJykge1xuICAgIHJldHVybiBgJHtrZXl9LiR7YmFzZX1gO1xuICB9XG5cbiAgcmV0dXJuIGtleSArIGJhc2U7XG59XG5cbmNvbnN0IGlzT2JqZWN0ID0gdmFsdWUgPT4gdHlwZW9mIHZhbHVlID09PSAnb2JqZWN0JyAmJiB2YWx1ZSAhPT0gbnVsbDtcblxuY29uc3QgYmFzZUlzQXJndW1lbnRzID0gaXRlbSA9PlxuICBpc09iamVjdChpdGVtKSAmJlxuICBPYmplY3QucHJvdG90eXBlLnRvU3RyaW5nLmNhbGwoaXRlbSkgPT09ICdbb2JqZWN0IEFyZ3VtZW50c10nO1xuXG5jb25zdCBpc0FyZ3VtZW50cyA9IGJhc2VJc0FyZ3VtZW50cyhmdW5jdGlvbigpIHsgcmV0dXJuIGFyZ3VtZW50czsgfSgpKSA/XG4gIGJhc2VJc0FyZ3VtZW50cyA6XG4gIHZhbHVlID0+IGlzT2JqZWN0KHZhbHVlKSAmJiB0eXBlb2YgdmFsdWUuY2FsbGVlID09PSAnZnVuY3Rpb24nO1xuIiwiLy8gQ29weSBvZiBqUXVlcnkuaXNQbGFpbk9iamVjdCBmb3IgdGhlIHNlcnZlciBzaWRlIGZyb20galF1ZXJ5IHYzLjEuMS5cblxuY29uc3QgY2xhc3MydHlwZSA9IHt9O1xuXG5jb25zdCB0b1N0cmluZyA9IGNsYXNzMnR5cGUudG9TdHJpbmc7XG5cbmNvbnN0IGhhc093biA9IE9iamVjdC5wcm90b3R5cGUuaGFzT3duUHJvcGVydHk7XG5cbmNvbnN0IGZuVG9TdHJpbmcgPSBoYXNPd24udG9TdHJpbmc7XG5cbmNvbnN0IE9iamVjdEZ1bmN0aW9uU3RyaW5nID0gZm5Ub1N0cmluZy5jYWxsKE9iamVjdCk7XG5cbmNvbnN0IGdldFByb3RvID0gT2JqZWN0LmdldFByb3RvdHlwZU9mO1xuXG5leHBvcnQgY29uc3QgaXNQbGFpbk9iamVjdCA9IG9iaiA9PiB7XG4gIGxldCBwcm90bztcbiAgbGV0IEN0b3I7XG5cbiAgLy8gRGV0ZWN0IG9idmlvdXMgbmVnYXRpdmVzXG4gIC8vIFVzZSB0b1N0cmluZyBpbnN0ZWFkIG9mIGpRdWVyeS50eXBlIHRvIGNhdGNoIGhvc3Qgb2JqZWN0c1xuICBpZiAoIW9iaiB8fCB0b1N0cmluZy5jYWxsKG9iaikgIT09ICdbb2JqZWN0IE9iamVjdF0nKSB7XG4gICAgcmV0dXJuIGZhbHNlO1xuICB9XG5cbiAgcHJvdG8gPSBnZXRQcm90byhvYmopO1xuXG4gIC8vIE9iamVjdHMgd2l0aCBubyBwcm90b3R5cGUgKGUuZy4sIGBPYmplY3QuY3JlYXRlKCBudWxsIClgKSBhcmUgcGxhaW5cbiAgaWYgKCFwcm90bykge1xuICAgIHJldHVybiB0cnVlO1xuICB9XG5cbiAgLy8gT2JqZWN0cyB3aXRoIHByb3RvdHlwZSBhcmUgcGxhaW4gaWZmIHRoZXkgd2VyZSBjb25zdHJ1Y3RlZCBieSBhIGdsb2JhbCBPYmplY3QgZnVuY3Rpb25cbiAgQ3RvciA9IGhhc093bi5jYWxsKHByb3RvLCAnY29uc3RydWN0b3InKSAmJiBwcm90by5jb25zdHJ1Y3RvcjtcbiAgcmV0dXJuIHR5cGVvZiBDdG9yID09PSAnZnVuY3Rpb24nICYmIFxuICAgIGZuVG9TdHJpbmcuY2FsbChDdG9yKSA9PT0gT2JqZWN0RnVuY3Rpb25TdHJpbmc7XG59O1xuIl19
