(function () {

/* Imports */
var Meteor = Package.meteor.Meteor;
var global = Package.meteor.global;
var meteorEnv = Package.meteor.meteorEnv;
var ECMAScript = Package.ecmascript.ECMAScript;
var Base64 = Package.base64.Base64;
var meteorInstall = Package.modules.meteorInstall;
var Promise = Package.promise.Promise;

/* Package-scope variables */
var EJSON;

var require = meteorInstall({"node_modules":{"meteor":{"ejson":{"ejson.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                             //
// packages/ejson/ejson.js                                                                                     //
//                                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                               //
module.export({
  EJSON: () => EJSON
});
let isFunction, isObject, keysOf, lengthOf, hasOwn, convertMapToObject, isArguments, isInfOrNaN, handleError;
module.link("./utils", {
  isFunction(v) {
    isFunction = v;
  },

  isObject(v) {
    isObject = v;
  },

  keysOf(v) {
    keysOf = v;
  },

  lengthOf(v) {
    lengthOf = v;
  },

  hasOwn(v) {
    hasOwn = v;
  },

  convertMapToObject(v) {
    convertMapToObject = v;
  },

  isArguments(v) {
    isArguments = v;
  },

  isInfOrNaN(v) {
    isInfOrNaN = v;
  },

  handleError(v) {
    handleError = v;
  }

}, 0);

/**
 * @namespace
 * @summary Namespace for EJSON functions
 */
const EJSON = {}; // Custom type interface definition

/**
 * @class CustomType
 * @instanceName customType
 * @memberOf EJSON
 * @summary The interface that a class must satisfy to be able to become an
 * EJSON custom type via EJSON.addType.
 */

/**
 * @function typeName
 * @memberOf EJSON.CustomType
 * @summary Return the tag used to identify this type.  This must match the
 *          tag used to register this type with
 *          [`EJSON.addType`](#ejson_add_type).
 * @locus Anywhere
 * @instance
 */

/**
 * @function toJSONValue
 * @memberOf EJSON.CustomType
 * @summary Serialize this instance into a JSON-compatible value.
 * @locus Anywhere
 * @instance
 */

/**
 * @function clone
 * @memberOf EJSON.CustomType
 * @summary Return a value `r` such that `this.equals(r)` is true, and
 *          modifications to `r` do not affect `this` and vice versa.
 * @locus Anywhere
 * @instance
 */

/**
 * @function equals
 * @memberOf EJSON.CustomType
 * @summary Return `true` if `other` has a value equal to `this`; `false`
 *          otherwise.
 * @locus Anywhere
 * @param {Object} other Another object to compare this to.
 * @instance
 */

const customTypes = new Map(); // Add a custom type, using a method of your choice to get to and
// from a basic JSON-able representation.  The factory argument
// is a function of JSON-able --> your object
// The type you add must have:
// - A toJSONValue() method, so that Meteor can serialize it
// - a typeName() method, to show how to look it up in our type table.
// It is okay if these methods are monkey-patched on.
// EJSON.clone will use toJSONValue and the given factory to produce
// a clone, but you may specify a method clone() that will be
// used instead.
// Similarly, EJSON.equals will use toJSONValue to make comparisons,
// but you may provide a method equals() instead.

/**
 * @summary Add a custom datatype to EJSON.
 * @locus Anywhere
 * @param {String} name A tag for your custom type; must be unique among
 *                      custom data types defined in your project, and must
 *                      match the result of your type's `typeName` method.
 * @param {Function} factory A function that deserializes a JSON-compatible
 *                           value into an instance of your type.  This should
 *                           match the serialization performed by your
 *                           type's `toJSONValue` method.
 */

EJSON.addType = (name, factory) => {
  if (customTypes.has(name)) {
    throw new Error("Type ".concat(name, " already present"));
  }

  customTypes.set(name, factory);
};

const builtinConverters = [{
  // Date
  matchJSONValue(obj) {
    return hasOwn(obj, '$date') && lengthOf(obj) === 1;
  },

  matchObject(obj) {
    return obj instanceof Date;
  },

  toJSONValue(obj) {
    return {
      $date: obj.getTime()
    };
  },

  fromJSONValue(obj) {
    return new Date(obj.$date);
  }

}, {
  // RegExp
  matchJSONValue(obj) {
    return hasOwn(obj, '$regexp') && hasOwn(obj, '$flags') && lengthOf(obj) === 2;
  },

  matchObject(obj) {
    return obj instanceof RegExp;
  },

  toJSONValue(regexp) {
    return {
      $regexp: regexp.source,
      $flags: regexp.flags
    };
  },

  fromJSONValue(obj) {
    // Replaces duplicate / invalid flags.
    return new RegExp(obj.$regexp, obj.$flags // Cut off flags at 50 chars to avoid abusing RegExp for DOS.
    .slice(0, 50).replace(/[^gimuy]/g, '').replace(/(.)(?=.*\1)/g, ''));
  }

}, {
  // NaN, Inf, -Inf. (These are the only objects with typeof !== 'object'
  // which we match.)
  matchJSONValue(obj) {
    return hasOwn(obj, '$InfNaN') && lengthOf(obj) === 1;
  },

  matchObject: isInfOrNaN,

  toJSONValue(obj) {
    let sign;

    if (Number.isNaN(obj)) {
      sign = 0;
    } else if (obj === Infinity) {
      sign = 1;
    } else {
      sign = -1;
    }

    return {
      $InfNaN: sign
    };
  },

  fromJSONValue(obj) {
    return obj.$InfNaN / 0;
  }

}, {
  // Binary
  matchJSONValue(obj) {
    return hasOwn(obj, '$binary') && lengthOf(obj) === 1;
  },

  matchObject(obj) {
    return typeof Uint8Array !== 'undefined' && obj instanceof Uint8Array || obj && hasOwn(obj, '$Uint8ArrayPolyfill');
  },

  toJSONValue(obj) {
    return {
      $binary: Base64.encode(obj)
    };
  },

  fromJSONValue(obj) {
    return Base64.decode(obj.$binary);
  }

}, {
  // Escaping one level
  matchJSONValue(obj) {
    return hasOwn(obj, '$escape') && lengthOf(obj) === 1;
  },

  matchObject(obj) {
    let match = false;

    if (obj) {
      const keyCount = lengthOf(obj);

      if (keyCount === 1 || keyCount === 2) {
        match = builtinConverters.some(converter => converter.matchJSONValue(obj));
      }
    }

    return match;
  },

  toJSONValue(obj) {
    const newObj = {};
    keysOf(obj).forEach(key => {
      newObj[key] = EJSON.toJSONValue(obj[key]);
    });
    return {
      $escape: newObj
    };
  },

  fromJSONValue(obj) {
    const newObj = {};
    keysOf(obj.$escape).forEach(key => {
      newObj[key] = EJSON.fromJSONValue(obj.$escape[key]);
    });
    return newObj;
  }

}, {
  // Custom
  matchJSONValue(obj) {
    return hasOwn(obj, '$type') && hasOwn(obj, '$value') && lengthOf(obj) === 2;
  },

  matchObject(obj) {
    return EJSON._isCustomType(obj);
  },

  toJSONValue(obj) {
    const jsonValue = Meteor._noYieldsAllowed(() => obj.toJSONValue());

    return {
      $type: obj.typeName(),
      $value: jsonValue
    };
  },

  fromJSONValue(obj) {
    const typeName = obj.$type;

    if (!customTypes.has(typeName)) {
      throw new Error("Custom EJSON type ".concat(typeName, " is not defined"));
    }

    const converter = customTypes.get(typeName);
    return Meteor._noYieldsAllowed(() => converter(obj.$value));
  }

}];

EJSON._isCustomType = obj => obj && isFunction(obj.toJSONValue) && isFunction(obj.typeName) && customTypes.has(obj.typeName());

EJSON._getTypes = function () {
  let isOriginal = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : false;
  return isOriginal ? customTypes : convertMapToObject(customTypes);
};

EJSON._getConverters = () => builtinConverters; // Either return the JSON-compatible version of the argument, or undefined (if
// the item isn't itself replaceable, but maybe some fields in it are)


const toJSONValueHelper = item => {
  for (let i = 0; i < builtinConverters.length; i++) {
    const converter = builtinConverters[i];

    if (converter.matchObject(item)) {
      return converter.toJSONValue(item);
    }
  }

  return undefined;
}; // for both arrays and objects, in-place modification.


const adjustTypesToJSONValue = obj => {
  // Is it an atom that we need to adjust?
  if (obj === null) {
    return null;
  }

  const maybeChanged = toJSONValueHelper(obj);

  if (maybeChanged !== undefined) {
    return maybeChanged;
  } // Other atoms are unchanged.


  if (!isObject(obj)) {
    return obj;
  } // Iterate over array or object structure.


  keysOf(obj).forEach(key => {
    const value = obj[key];

    if (!isObject(value) && value !== undefined && !isInfOrNaN(value)) {
      return; // continue
    }

    const changed = toJSONValueHelper(value);

    if (changed) {
      obj[key] = changed;
      return; // on to the next key
    } // if we get here, value is an object but not adjustable
    // at this level.  recurse.


    adjustTypesToJSONValue(value);
  });
  return obj;
};

EJSON._adjustTypesToJSONValue = adjustTypesToJSONValue;
/**
 * @summary Serialize an EJSON-compatible value into its plain JSON
 *          representation.
 * @locus Anywhere
 * @param {EJSON} val A value to serialize to plain JSON.
 */

EJSON.toJSONValue = item => {
  const changed = toJSONValueHelper(item);

  if (changed !== undefined) {
    return changed;
  }

  let newItem = item;

  if (isObject(item)) {
    newItem = EJSON.clone(item);
    adjustTypesToJSONValue(newItem);
  }

  return newItem;
}; // Either return the argument changed to have the non-json
// rep of itself (the Object version) or the argument itself.
// DOES NOT RECURSE.  For actually getting the fully-changed value, use
// EJSON.fromJSONValue


const fromJSONValueHelper = value => {
  if (isObject(value) && value !== null) {
    const keys = keysOf(value);

    if (keys.length <= 2 && keys.every(k => typeof k === 'string' && k.substr(0, 1) === '$')) {
      for (let i = 0; i < builtinConverters.length; i++) {
        const converter = builtinConverters[i];

        if (converter.matchJSONValue(value)) {
          return converter.fromJSONValue(value);
        }
      }
    }
  }

  return value;
}; // for both arrays and objects. Tries its best to just
// use the object you hand it, but may return something
// different if the object you hand it itself needs changing.


const adjustTypesFromJSONValue = obj => {
  if (obj === null) {
    return null;
  }

  const maybeChanged = fromJSONValueHelper(obj);

  if (maybeChanged !== obj) {
    return maybeChanged;
  } // Other atoms are unchanged.


  if (!isObject(obj)) {
    return obj;
  }

  keysOf(obj).forEach(key => {
    const value = obj[key];

    if (isObject(value)) {
      const changed = fromJSONValueHelper(value);

      if (value !== changed) {
        obj[key] = changed;
        return;
      } // if we get here, value is an object but not adjustable
      // at this level.  recurse.


      adjustTypesFromJSONValue(value);
    }
  });
  return obj;
};

EJSON._adjustTypesFromJSONValue = adjustTypesFromJSONValue;
/**
 * @summary Deserialize an EJSON value from its plain JSON representation.
 * @locus Anywhere
 * @param {JSONCompatible} val A value to deserialize into EJSON.
 */

EJSON.fromJSONValue = item => {
  let changed = fromJSONValueHelper(item);

  if (changed === item && isObject(item)) {
    changed = EJSON.clone(item);
    adjustTypesFromJSONValue(changed);
  }

  return changed;
};
/**
 * @summary Serialize a value to a string. For EJSON values, the serialization
 *          fully represents the value. For non-EJSON values, serializes the
 *          same way as `JSON.stringify`.
 * @locus Anywhere
 * @param {EJSON} val A value to stringify.
 * @param {Object} [options]
 * @param {Boolean | Integer | String} options.indent Indents objects and
 * arrays for easy readability.  When `true`, indents by 2 spaces; when an
 * integer, indents by that number of spaces; and when a string, uses the
 * string as the indentation pattern.
 * @param {Boolean} options.canonical When `true`, stringifies keys in an
 *                                    object in sorted order.
 */


EJSON.stringify = handleError((item, options) => {
  let serialized;
  const json = EJSON.toJSONValue(item);

  if (options && (options.canonical || options.indent)) {
    let canonicalStringify;
    module.link("./stringify", {
      default(v) {
        canonicalStringify = v;
      }

    }, 1);
    serialized = canonicalStringify(json, options);
  } else {
    serialized = JSON.stringify(json);
  }

  return serialized;
});
/**
 * @summary Parse a string into an EJSON value. Throws an error if the string
 *          is not valid EJSON.
 * @locus Anywhere
 * @param {String} str A string to parse into an EJSON value.
 */

EJSON.parse = item => {
  if (typeof item !== 'string') {
    throw new Error('EJSON.parse argument should be a string');
  }

  return EJSON.fromJSONValue(JSON.parse(item));
};
/**
 * @summary Returns true if `x` is a buffer of binary data, as returned from
 *          [`EJSON.newBinary`](#ejson_new_binary).
 * @param {Object} x The variable to check.
 * @locus Anywhere
 */


EJSON.isBinary = obj => {
  return !!(typeof Uint8Array !== 'undefined' && obj instanceof Uint8Array || obj && obj.$Uint8ArrayPolyfill);
};
/**
 * @summary Return true if `a` and `b` are equal to each other.  Return false
 *          otherwise.  Uses the `equals` method on `a` if present, otherwise
 *          performs a deep comparison.
 * @locus Anywhere
 * @param {EJSON} a
 * @param {EJSON} b
 * @param {Object} [options]
 * @param {Boolean} options.keyOrderSensitive Compare in key sensitive order,
 * if supported by the JavaScript implementation.  For example, `{a: 1, b: 2}`
 * is equal to `{b: 2, a: 1}` only when `keyOrderSensitive` is `false`.  The
 * default is `false`.
 */


EJSON.equals = (a, b, options) => {
  let i;
  const keyOrderSensitive = !!(options && options.keyOrderSensitive);

  if (a === b) {
    return true;
  } // This differs from the IEEE spec for NaN equality, b/c we don't want
  // anything ever with a NaN to be poisoned from becoming equal to anything.


  if (Number.isNaN(a) && Number.isNaN(b)) {
    return true;
  } // if either one is falsy, they'd have to be === to be equal


  if (!a || !b) {
    return false;
  }

  if (!(isObject(a) && isObject(b))) {
    return false;
  }

  if (a instanceof Date && b instanceof Date) {
    return a.valueOf() === b.valueOf();
  }

  if (EJSON.isBinary(a) && EJSON.isBinary(b)) {
    if (a.length !== b.length) {
      return false;
    }

    for (i = 0; i < a.length; i++) {
      if (a[i] !== b[i]) {
        return false;
      }
    }

    return true;
  }

  if (isFunction(a.equals)) {
    return a.equals(b, options);
  }

  if (isFunction(b.equals)) {
    return b.equals(a, options);
  } // Array.isArray works across iframes while instanceof won't


  const aIsArray = Array.isArray(a);
  const bIsArray = Array.isArray(b); // if not both or none are array they are not equal

  if (aIsArray !== bIsArray) {
    return false;
  }

  if (aIsArray && bIsArray) {
    if (a.length !== b.length) {
      return false;
    }

    for (i = 0; i < a.length; i++) {
      if (!EJSON.equals(a[i], b[i], options)) {
        return false;
      }
    }

    return true;
  } // fallback for custom types that don't implement their own equals


  switch (EJSON._isCustomType(a) + EJSON._isCustomType(b)) {
    case 1:
      return false;

    case 2:
      return EJSON.equals(EJSON.toJSONValue(a), EJSON.toJSONValue(b));

    default: // Do nothing

  } // fall back to structural equality of objects


  let ret;
  const aKeys = keysOf(a);
  const bKeys = keysOf(b);

  if (keyOrderSensitive) {
    i = 0;
    ret = aKeys.every(key => {
      if (i >= bKeys.length) {
        return false;
      }

      if (key !== bKeys[i]) {
        return false;
      }

      if (!EJSON.equals(a[key], b[bKeys[i]], options)) {
        return false;
      }

      i++;
      return true;
    });
  } else {
    i = 0;
    ret = aKeys.every(key => {
      if (!hasOwn(b, key)) {
        return false;
      }

      if (!EJSON.equals(a[key], b[key], options)) {
        return false;
      }

      i++;
      return true;
    });
  }

  return ret && i === bKeys.length;
};
/**
 * @summary Return a deep copy of `val`.
 * @locus Anywhere
 * @param {EJSON} val A value to copy.
 */


EJSON.clone = v => {
  let ret;

  if (!isObject(v)) {
    return v;
  }

  if (v === null) {
    return null; // null has typeof "object"
  }

  if (v instanceof Date) {
    return new Date(v.getTime());
  } // RegExps are not really EJSON elements (eg we don't define a serialization
  // for them), but they're immutable anyway, so we can support them in clone.


  if (v instanceof RegExp) {
    return v;
  }

  if (EJSON.isBinary(v)) {
    ret = EJSON.newBinary(v.length);

    for (let i = 0; i < v.length; i++) {
      ret[i] = v[i];
    }

    return ret;
  }

  if (Array.isArray(v)) {
    return v.map(EJSON.clone);
  }

  if (isArguments(v)) {
    return Array.from(v).map(EJSON.clone);
  } // handle general user-defined typed Objects if they have a clone method


  if (isFunction(v.clone)) {
    return v.clone();
  } // handle other custom types


  if (EJSON._isCustomType(v)) {
    return EJSON.fromJSONValue(EJSON.clone(EJSON.toJSONValue(v)), true);
  } // handle other objects


  ret = {};
  keysOf(v).forEach(key => {
    ret[key] = EJSON.clone(v[key]);
  });
  return ret;
};
/**
 * @summary Allocate a new buffer of binary data that EJSON can serialize.
 * @locus Anywhere
 * @param {Number} size The number of bytes of binary data to allocate.
 */
// EJSON.newBinary is the public documented API for this functionality,
// but the implementation is in the 'base64' package to avoid
// introducing a circular dependency. (If the implementation were here,
// then 'base64' would have to use EJSON.newBinary, and 'ejson' would
// also have to use 'base64'.)


EJSON.newBinary = Base64.newBinary;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"stringify.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                             //
// packages/ejson/stringify.js                                                                                 //
//                                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                               //
// Based on json2.js from https://github.com/douglascrockford/JSON-js
//
//    json2.js
//    2012-10-08
//
//    Public Domain.
//
//    NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
function quote(string) {
  return JSON.stringify(string);
}

const str = (key, holder, singleIndent, outerIndent, canonical) => {
  const value = holder[key]; // What happens next depends on the value's type.

  switch (typeof value) {
    case 'string':
      return quote(value);

    case 'number':
      // JSON numbers must be finite. Encode non-finite numbers as null.
      return isFinite(value) ? String(value) : 'null';

    case 'boolean':
      return String(value);
    // If the type is 'object', we might be dealing with an object or an array or
    // null.

    case 'object':
      {
        // Due to a specification blunder in ECMAScript, typeof null is 'object',
        // so watch out for that case.
        if (!value) {
          return 'null';
        } // Make an array to hold the partial results of stringifying this object
        // value.


        const innerIndent = outerIndent + singleIndent;
        const partial = [];
        let v; // Is the value an array?

        if (Array.isArray(value) || {}.hasOwnProperty.call(value, 'callee')) {
          // The value is an array. Stringify every element. Use null as a
          // placeholder for non-JSON values.
          const length = value.length;

          for (let i = 0; i < length; i += 1) {
            partial[i] = str(i, value, singleIndent, innerIndent, canonical) || 'null';
          } // Join all of the elements together, separated with commas, and wrap
          // them in brackets.


          if (partial.length === 0) {
            v = '[]';
          } else if (innerIndent) {
            v = '[\n' + innerIndent + partial.join(',\n' + innerIndent) + '\n' + outerIndent + ']';
          } else {
            v = '[' + partial.join(',') + ']';
          }

          return v;
        } // Iterate through all of the keys in the object.


        let keys = Object.keys(value);

        if (canonical) {
          keys = keys.sort();
        }

        keys.forEach(k => {
          v = str(k, value, singleIndent, innerIndent, canonical);

          if (v) {
            partial.push(quote(k) + (innerIndent ? ': ' : ':') + v);
          }
        }); // Join all of the member texts together, separated with commas,
        // and wrap them in braces.

        if (partial.length === 0) {
          v = '{}';
        } else if (innerIndent) {
          v = '{\n' + innerIndent + partial.join(',\n' + innerIndent) + '\n' + outerIndent + '}';
        } else {
          v = '{' + partial.join(',') + '}';
        }

        return v;
      }

    default: // Do nothing

  }
}; // If the JSON object does not yet have a stringify method, give it one.


const canonicalStringify = (value, options) => {
  // Make a fake root object containing our value under the key of ''.
  // Return the result of stringifying the value.
  const allOptions = Object.assign({
    indent: '',
    canonical: false
  }, options);

  if (allOptions.indent === true) {
    allOptions.indent = '  ';
  } else if (typeof allOptions.indent === 'number') {
    let newIndent = '';

    for (let i = 0; i < allOptions.indent; i++) {
      newIndent += ' ';
    }

    allOptions.indent = newIndent;
  }

  return str('', {
    '': value
  }, allOptions.indent, '', allOptions.canonical);
};

module.exportDefault(canonicalStringify);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"utils.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                             //
// packages/ejson/utils.js                                                                                     //
//                                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                               //
module.export({
  isFunction: () => isFunction,
  isObject: () => isObject,
  keysOf: () => keysOf,
  lengthOf: () => lengthOf,
  hasOwn: () => hasOwn,
  convertMapToObject: () => convertMapToObject,
  isArguments: () => isArguments,
  isInfOrNaN: () => isInfOrNaN,
  checkError: () => checkError,
  handleError: () => handleError
});

const isFunction = fn => typeof fn === 'function';

const isObject = fn => typeof fn === 'object';

const keysOf = obj => Object.keys(obj);

const lengthOf = obj => Object.keys(obj).length;

const hasOwn = (obj, prop) => Object.prototype.hasOwnProperty.call(obj, prop);

const convertMapToObject = map => Array.from(map).reduce((acc, _ref) => {
  let [key, value] = _ref;
  // reassign to not create new object
  acc[key] = value;
  return acc;
}, {});

const isArguments = obj => obj != null && hasOwn(obj, 'callee');

const isInfOrNaN = obj => Number.isNaN(obj) || obj === Infinity || obj === -Infinity;

const checkError = {
  maxStack: msgError => new RegExp('Maximum call stack size exceeded', 'g').test(msgError)
};

const handleError = fn => function () {
  try {
    return fn.apply(this, arguments);
  } catch (error) {
    const isMaxStack = checkError.maxStack(error.message);

    if (isMaxStack) {
      throw new Error('Converting circular structure to JSON');
    }

    throw error;
  }
};
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}}}}},{
  "extensions": [
    ".js",
    ".json"
  ]
});

var exports = require("/node_modules/meteor/ejson/ejson.js");

/* Exports */
Package._define("ejson", exports, {
  EJSON: EJSON
});

})();

//# sourceURL=meteor://💻app/packages/ejson.js
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvZWpzb24vZWpzb24uanMiLCJtZXRlb3I6Ly/wn5K7YXBwL3BhY2thZ2VzL2Vqc29uL3N0cmluZ2lmeS5qcyIsIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvZWpzb24vdXRpbHMuanMiXSwibmFtZXMiOlsibW9kdWxlIiwiZXhwb3J0IiwiRUpTT04iLCJpc0Z1bmN0aW9uIiwiaXNPYmplY3QiLCJrZXlzT2YiLCJsZW5ndGhPZiIsImhhc093biIsImNvbnZlcnRNYXBUb09iamVjdCIsImlzQXJndW1lbnRzIiwiaXNJbmZPck5hTiIsImhhbmRsZUVycm9yIiwibGluayIsInYiLCJjdXN0b21UeXBlcyIsIk1hcCIsImFkZFR5cGUiLCJuYW1lIiwiZmFjdG9yeSIsImhhcyIsIkVycm9yIiwic2V0IiwiYnVpbHRpbkNvbnZlcnRlcnMiLCJtYXRjaEpTT05WYWx1ZSIsIm9iaiIsIm1hdGNoT2JqZWN0IiwiRGF0ZSIsInRvSlNPTlZhbHVlIiwiJGRhdGUiLCJnZXRUaW1lIiwiZnJvbUpTT05WYWx1ZSIsIlJlZ0V4cCIsInJlZ2V4cCIsIiRyZWdleHAiLCJzb3VyY2UiLCIkZmxhZ3MiLCJmbGFncyIsInNsaWNlIiwicmVwbGFjZSIsInNpZ24iLCJOdW1iZXIiLCJpc05hTiIsIkluZmluaXR5IiwiJEluZk5hTiIsIlVpbnQ4QXJyYXkiLCIkYmluYXJ5IiwiQmFzZTY0IiwiZW5jb2RlIiwiZGVjb2RlIiwibWF0Y2giLCJrZXlDb3VudCIsInNvbWUiLCJjb252ZXJ0ZXIiLCJuZXdPYmoiLCJmb3JFYWNoIiwia2V5IiwiJGVzY2FwZSIsIl9pc0N1c3RvbVR5cGUiLCJqc29uVmFsdWUiLCJNZXRlb3IiLCJfbm9ZaWVsZHNBbGxvd2VkIiwiJHR5cGUiLCJ0eXBlTmFtZSIsIiR2YWx1ZSIsImdldCIsIl9nZXRUeXBlcyIsImlzT3JpZ2luYWwiLCJfZ2V0Q29udmVydGVycyIsInRvSlNPTlZhbHVlSGVscGVyIiwiaXRlbSIsImkiLCJsZW5ndGgiLCJ1bmRlZmluZWQiLCJhZGp1c3RUeXBlc1RvSlNPTlZhbHVlIiwibWF5YmVDaGFuZ2VkIiwidmFsdWUiLCJjaGFuZ2VkIiwiX2FkanVzdFR5cGVzVG9KU09OVmFsdWUiLCJuZXdJdGVtIiwiY2xvbmUiLCJmcm9tSlNPTlZhbHVlSGVscGVyIiwia2V5cyIsImV2ZXJ5IiwiayIsInN1YnN0ciIsImFkanVzdFR5cGVzRnJvbUpTT05WYWx1ZSIsIl9hZGp1c3RUeXBlc0Zyb21KU09OVmFsdWUiLCJzdHJpbmdpZnkiLCJvcHRpb25zIiwic2VyaWFsaXplZCIsImpzb24iLCJjYW5vbmljYWwiLCJpbmRlbnQiLCJjYW5vbmljYWxTdHJpbmdpZnkiLCJkZWZhdWx0IiwiSlNPTiIsInBhcnNlIiwiaXNCaW5hcnkiLCIkVWludDhBcnJheVBvbHlmaWxsIiwiZXF1YWxzIiwiYSIsImIiLCJrZXlPcmRlclNlbnNpdGl2ZSIsInZhbHVlT2YiLCJhSXNBcnJheSIsIkFycmF5IiwiaXNBcnJheSIsImJJc0FycmF5IiwicmV0IiwiYUtleXMiLCJiS2V5cyIsIm5ld0JpbmFyeSIsIm1hcCIsImZyb20iLCJxdW90ZSIsInN0cmluZyIsInN0ciIsImhvbGRlciIsInNpbmdsZUluZGVudCIsIm91dGVySW5kZW50IiwiaXNGaW5pdGUiLCJTdHJpbmciLCJpbm5lckluZGVudCIsInBhcnRpYWwiLCJoYXNPd25Qcm9wZXJ0eSIsImNhbGwiLCJqb2luIiwiT2JqZWN0Iiwic29ydCIsInB1c2giLCJhbGxPcHRpb25zIiwiYXNzaWduIiwibmV3SW5kZW50IiwiZXhwb3J0RGVmYXVsdCIsImNoZWNrRXJyb3IiLCJmbiIsInByb3AiLCJwcm90b3R5cGUiLCJyZWR1Y2UiLCJhY2MiLCJtYXhTdGFjayIsIm1zZ0Vycm9yIiwidGVzdCIsImFwcGx5IiwiYXJndW1lbnRzIiwiZXJyb3IiLCJpc01heFN0YWNrIiwibWVzc2FnZSJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OztBQUFBQSxNQUFNLENBQUNDLE1BQVAsQ0FBYztBQUFDQyxPQUFLLEVBQUMsTUFBSUE7QUFBWCxDQUFkO0FBQWlDLElBQUlDLFVBQUosRUFBZUMsUUFBZixFQUF3QkMsTUFBeEIsRUFBK0JDLFFBQS9CLEVBQXdDQyxNQUF4QyxFQUErQ0Msa0JBQS9DLEVBQWtFQyxXQUFsRSxFQUE4RUMsVUFBOUUsRUFBeUZDLFdBQXpGO0FBQXFHWCxNQUFNLENBQUNZLElBQVAsQ0FBWSxTQUFaLEVBQXNCO0FBQUNULFlBQVUsQ0FBQ1UsQ0FBRCxFQUFHO0FBQUNWLGNBQVUsR0FBQ1UsQ0FBWDtBQUFhLEdBQTVCOztBQUE2QlQsVUFBUSxDQUFDUyxDQUFELEVBQUc7QUFBQ1QsWUFBUSxHQUFDUyxDQUFUO0FBQVcsR0FBcEQ7O0FBQXFEUixRQUFNLENBQUNRLENBQUQsRUFBRztBQUFDUixVQUFNLEdBQUNRLENBQVA7QUFBUyxHQUF4RTs7QUFBeUVQLFVBQVEsQ0FBQ08sQ0FBRCxFQUFHO0FBQUNQLFlBQVEsR0FBQ08sQ0FBVDtBQUFXLEdBQWhHOztBQUFpR04sUUFBTSxDQUFDTSxDQUFELEVBQUc7QUFBQ04sVUFBTSxHQUFDTSxDQUFQO0FBQVMsR0FBcEg7O0FBQXFITCxvQkFBa0IsQ0FBQ0ssQ0FBRCxFQUFHO0FBQUNMLHNCQUFrQixHQUFDSyxDQUFuQjtBQUFxQixHQUFoSzs7QUFBaUtKLGFBQVcsQ0FBQ0ksQ0FBRCxFQUFHO0FBQUNKLGVBQVcsR0FBQ0ksQ0FBWjtBQUFjLEdBQTlMOztBQUErTEgsWUFBVSxDQUFDRyxDQUFELEVBQUc7QUFBQ0gsY0FBVSxHQUFDRyxDQUFYO0FBQWEsR0FBMU47O0FBQTJORixhQUFXLENBQUNFLENBQUQsRUFBRztBQUFDRixlQUFXLEdBQUNFLENBQVo7QUFBYzs7QUFBeFAsQ0FBdEIsRUFBZ1IsQ0FBaFI7O0FBWXRJO0FBQ0E7QUFDQTtBQUNBO0FBQ0EsTUFBTVgsS0FBSyxHQUFHLEVBQWQsQyxDQUVBOztBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFFQSxNQUFNWSxXQUFXLEdBQUcsSUFBSUMsR0FBSixFQUFwQixDLENBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBQ0FiLEtBQUssQ0FBQ2MsT0FBTixHQUFnQixDQUFDQyxJQUFELEVBQU9DLE9BQVAsS0FBbUI7QUFDakMsTUFBSUosV0FBVyxDQUFDSyxHQUFaLENBQWdCRixJQUFoQixDQUFKLEVBQTJCO0FBQ3pCLFVBQU0sSUFBSUcsS0FBSixnQkFBa0JILElBQWxCLHNCQUFOO0FBQ0Q7O0FBQ0RILGFBQVcsQ0FBQ08sR0FBWixDQUFnQkosSUFBaEIsRUFBc0JDLE9BQXRCO0FBQ0QsQ0FMRDs7QUFPQSxNQUFNSSxpQkFBaUIsR0FBRyxDQUN4QjtBQUFFO0FBQ0FDLGdCQUFjLENBQUNDLEdBQUQsRUFBTTtBQUNsQixXQUFPakIsTUFBTSxDQUFDaUIsR0FBRCxFQUFNLE9BQU4sQ0FBTixJQUF3QmxCLFFBQVEsQ0FBQ2tCLEdBQUQsQ0FBUixLQUFrQixDQUFqRDtBQUNELEdBSEg7O0FBSUVDLGFBQVcsQ0FBQ0QsR0FBRCxFQUFNO0FBQ2YsV0FBT0EsR0FBRyxZQUFZRSxJQUF0QjtBQUNELEdBTkg7O0FBT0VDLGFBQVcsQ0FBQ0gsR0FBRCxFQUFNO0FBQ2YsV0FBTztBQUFDSSxXQUFLLEVBQUVKLEdBQUcsQ0FBQ0ssT0FBSjtBQUFSLEtBQVA7QUFDRCxHQVRIOztBQVVFQyxlQUFhLENBQUNOLEdBQUQsRUFBTTtBQUNqQixXQUFPLElBQUlFLElBQUosQ0FBU0YsR0FBRyxDQUFDSSxLQUFiLENBQVA7QUFDRDs7QUFaSCxDQUR3QixFQWV4QjtBQUFFO0FBQ0FMLGdCQUFjLENBQUNDLEdBQUQsRUFBTTtBQUNsQixXQUFPakIsTUFBTSxDQUFDaUIsR0FBRCxFQUFNLFNBQU4sQ0FBTixJQUNGakIsTUFBTSxDQUFDaUIsR0FBRCxFQUFNLFFBQU4sQ0FESixJQUVGbEIsUUFBUSxDQUFDa0IsR0FBRCxDQUFSLEtBQWtCLENBRnZCO0FBR0QsR0FMSDs7QUFNRUMsYUFBVyxDQUFDRCxHQUFELEVBQU07QUFDZixXQUFPQSxHQUFHLFlBQVlPLE1BQXRCO0FBQ0QsR0FSSDs7QUFTRUosYUFBVyxDQUFDSyxNQUFELEVBQVM7QUFDbEIsV0FBTztBQUNMQyxhQUFPLEVBQUVELE1BQU0sQ0FBQ0UsTUFEWDtBQUVMQyxZQUFNLEVBQUVILE1BQU0sQ0FBQ0k7QUFGVixLQUFQO0FBSUQsR0FkSDs7QUFlRU4sZUFBYSxDQUFDTixHQUFELEVBQU07QUFDakI7QUFDQSxXQUFPLElBQUlPLE1BQUosQ0FDTFAsR0FBRyxDQUFDUyxPQURDLEVBRUxULEdBQUcsQ0FBQ1csTUFBSixDQUNFO0FBREYsS0FFR0UsS0FGSCxDQUVTLENBRlQsRUFFWSxFQUZaLEVBR0dDLE9BSEgsQ0FHVyxXQUhYLEVBR3VCLEVBSHZCLEVBSUdBLE9BSkgsQ0FJVyxjQUpYLEVBSTJCLEVBSjNCLENBRkssQ0FBUDtBQVFEOztBQXpCSCxDQWZ3QixFQTBDeEI7QUFBRTtBQUNBO0FBQ0FmLGdCQUFjLENBQUNDLEdBQUQsRUFBTTtBQUNsQixXQUFPakIsTUFBTSxDQUFDaUIsR0FBRCxFQUFNLFNBQU4sQ0FBTixJQUEwQmxCLFFBQVEsQ0FBQ2tCLEdBQUQsQ0FBUixLQUFrQixDQUFuRDtBQUNELEdBSkg7O0FBS0VDLGFBQVcsRUFBRWYsVUFMZjs7QUFNRWlCLGFBQVcsQ0FBQ0gsR0FBRCxFQUFNO0FBQ2YsUUFBSWUsSUFBSjs7QUFDQSxRQUFJQyxNQUFNLENBQUNDLEtBQVAsQ0FBYWpCLEdBQWIsQ0FBSixFQUF1QjtBQUNyQmUsVUFBSSxHQUFHLENBQVA7QUFDRCxLQUZELE1BRU8sSUFBSWYsR0FBRyxLQUFLa0IsUUFBWixFQUFzQjtBQUMzQkgsVUFBSSxHQUFHLENBQVA7QUFDRCxLQUZNLE1BRUE7QUFDTEEsVUFBSSxHQUFHLENBQUMsQ0FBUjtBQUNEOztBQUNELFdBQU87QUFBQ0ksYUFBTyxFQUFFSjtBQUFWLEtBQVA7QUFDRCxHQWhCSDs7QUFpQkVULGVBQWEsQ0FBQ04sR0FBRCxFQUFNO0FBQ2pCLFdBQU9BLEdBQUcsQ0FBQ21CLE9BQUosR0FBYyxDQUFyQjtBQUNEOztBQW5CSCxDQTFDd0IsRUErRHhCO0FBQUU7QUFDQXBCLGdCQUFjLENBQUNDLEdBQUQsRUFBTTtBQUNsQixXQUFPakIsTUFBTSxDQUFDaUIsR0FBRCxFQUFNLFNBQU4sQ0FBTixJQUEwQmxCLFFBQVEsQ0FBQ2tCLEdBQUQsQ0FBUixLQUFrQixDQUFuRDtBQUNELEdBSEg7O0FBSUVDLGFBQVcsQ0FBQ0QsR0FBRCxFQUFNO0FBQ2YsV0FBTyxPQUFPb0IsVUFBUCxLQUFzQixXQUF0QixJQUFxQ3BCLEdBQUcsWUFBWW9CLFVBQXBELElBQ0RwQixHQUFHLElBQUlqQixNQUFNLENBQUNpQixHQUFELEVBQU0scUJBQU4sQ0FEbkI7QUFFRCxHQVBIOztBQVFFRyxhQUFXLENBQUNILEdBQUQsRUFBTTtBQUNmLFdBQU87QUFBQ3FCLGFBQU8sRUFBRUMsTUFBTSxDQUFDQyxNQUFQLENBQWN2QixHQUFkO0FBQVYsS0FBUDtBQUNELEdBVkg7O0FBV0VNLGVBQWEsQ0FBQ04sR0FBRCxFQUFNO0FBQ2pCLFdBQU9zQixNQUFNLENBQUNFLE1BQVAsQ0FBY3hCLEdBQUcsQ0FBQ3FCLE9BQWxCLENBQVA7QUFDRDs7QUFiSCxDQS9Ed0IsRUE4RXhCO0FBQUU7QUFDQXRCLGdCQUFjLENBQUNDLEdBQUQsRUFBTTtBQUNsQixXQUFPakIsTUFBTSxDQUFDaUIsR0FBRCxFQUFNLFNBQU4sQ0FBTixJQUEwQmxCLFFBQVEsQ0FBQ2tCLEdBQUQsQ0FBUixLQUFrQixDQUFuRDtBQUNELEdBSEg7O0FBSUVDLGFBQVcsQ0FBQ0QsR0FBRCxFQUFNO0FBQ2YsUUFBSXlCLEtBQUssR0FBRyxLQUFaOztBQUNBLFFBQUl6QixHQUFKLEVBQVM7QUFDUCxZQUFNMEIsUUFBUSxHQUFHNUMsUUFBUSxDQUFDa0IsR0FBRCxDQUF6Qjs7QUFDQSxVQUFJMEIsUUFBUSxLQUFLLENBQWIsSUFBa0JBLFFBQVEsS0FBSyxDQUFuQyxFQUFzQztBQUNwQ0QsYUFBSyxHQUNIM0IsaUJBQWlCLENBQUM2QixJQUFsQixDQUF1QkMsU0FBUyxJQUFJQSxTQUFTLENBQUM3QixjQUFWLENBQXlCQyxHQUF6QixDQUFwQyxDQURGO0FBRUQ7QUFDRjs7QUFDRCxXQUFPeUIsS0FBUDtBQUNELEdBZEg7O0FBZUV0QixhQUFXLENBQUNILEdBQUQsRUFBTTtBQUNmLFVBQU02QixNQUFNLEdBQUcsRUFBZjtBQUNBaEQsVUFBTSxDQUFDbUIsR0FBRCxDQUFOLENBQVk4QixPQUFaLENBQW9CQyxHQUFHLElBQUk7QUFDekJGLFlBQU0sQ0FBQ0UsR0FBRCxDQUFOLEdBQWNyRCxLQUFLLENBQUN5QixXQUFOLENBQWtCSCxHQUFHLENBQUMrQixHQUFELENBQXJCLENBQWQ7QUFDRCxLQUZEO0FBR0EsV0FBTztBQUFDQyxhQUFPLEVBQUVIO0FBQVYsS0FBUDtBQUNELEdBckJIOztBQXNCRXZCLGVBQWEsQ0FBQ04sR0FBRCxFQUFNO0FBQ2pCLFVBQU02QixNQUFNLEdBQUcsRUFBZjtBQUNBaEQsVUFBTSxDQUFDbUIsR0FBRyxDQUFDZ0MsT0FBTCxDQUFOLENBQW9CRixPQUFwQixDQUE0QkMsR0FBRyxJQUFJO0FBQ2pDRixZQUFNLENBQUNFLEdBQUQsQ0FBTixHQUFjckQsS0FBSyxDQUFDNEIsYUFBTixDQUFvQk4sR0FBRyxDQUFDZ0MsT0FBSixDQUFZRCxHQUFaLENBQXBCLENBQWQ7QUFDRCxLQUZEO0FBR0EsV0FBT0YsTUFBUDtBQUNEOztBQTVCSCxDQTlFd0IsRUE0R3hCO0FBQUU7QUFDQTlCLGdCQUFjLENBQUNDLEdBQUQsRUFBTTtBQUNsQixXQUFPakIsTUFBTSxDQUFDaUIsR0FBRCxFQUFNLE9BQU4sQ0FBTixJQUNGakIsTUFBTSxDQUFDaUIsR0FBRCxFQUFNLFFBQU4sQ0FESixJQUN1QmxCLFFBQVEsQ0FBQ2tCLEdBQUQsQ0FBUixLQUFrQixDQURoRDtBQUVELEdBSkg7O0FBS0VDLGFBQVcsQ0FBQ0QsR0FBRCxFQUFNO0FBQ2YsV0FBT3RCLEtBQUssQ0FBQ3VELGFBQU4sQ0FBb0JqQyxHQUFwQixDQUFQO0FBQ0QsR0FQSDs7QUFRRUcsYUFBVyxDQUFDSCxHQUFELEVBQU07QUFDZixVQUFNa0MsU0FBUyxHQUFHQyxNQUFNLENBQUNDLGdCQUFQLENBQXdCLE1BQU1wQyxHQUFHLENBQUNHLFdBQUosRUFBOUIsQ0FBbEI7O0FBQ0EsV0FBTztBQUFDa0MsV0FBSyxFQUFFckMsR0FBRyxDQUFDc0MsUUFBSixFQUFSO0FBQXdCQyxZQUFNLEVBQUVMO0FBQWhDLEtBQVA7QUFDRCxHQVhIOztBQVlFNUIsZUFBYSxDQUFDTixHQUFELEVBQU07QUFDakIsVUFBTXNDLFFBQVEsR0FBR3RDLEdBQUcsQ0FBQ3FDLEtBQXJCOztBQUNBLFFBQUksQ0FBQy9DLFdBQVcsQ0FBQ0ssR0FBWixDQUFnQjJDLFFBQWhCLENBQUwsRUFBZ0M7QUFDOUIsWUFBTSxJQUFJMUMsS0FBSiw2QkFBK0IwQyxRQUEvQixxQkFBTjtBQUNEOztBQUNELFVBQU1WLFNBQVMsR0FBR3RDLFdBQVcsQ0FBQ2tELEdBQVosQ0FBZ0JGLFFBQWhCLENBQWxCO0FBQ0EsV0FBT0gsTUFBTSxDQUFDQyxnQkFBUCxDQUF3QixNQUFNUixTQUFTLENBQUM1QixHQUFHLENBQUN1QyxNQUFMLENBQXZDLENBQVA7QUFDRDs7QUFuQkgsQ0E1R3dCLENBQTFCOztBQW1JQTdELEtBQUssQ0FBQ3VELGFBQU4sR0FBdUJqQyxHQUFELElBQ3BCQSxHQUFHLElBQ0hyQixVQUFVLENBQUNxQixHQUFHLENBQUNHLFdBQUwsQ0FEVixJQUVBeEIsVUFBVSxDQUFDcUIsR0FBRyxDQUFDc0MsUUFBTCxDQUZWLElBR0FoRCxXQUFXLENBQUNLLEdBQVosQ0FBZ0JLLEdBQUcsQ0FBQ3NDLFFBQUosRUFBaEIsQ0FKRjs7QUFPQTVELEtBQUssQ0FBQytELFNBQU4sR0FBa0I7QUFBQSxNQUFDQyxVQUFELHVFQUFjLEtBQWQ7QUFBQSxTQUF5QkEsVUFBVSxHQUFHcEQsV0FBSCxHQUFpQk4sa0JBQWtCLENBQUNNLFdBQUQsQ0FBdEU7QUFBQSxDQUFsQjs7QUFFQVosS0FBSyxDQUFDaUUsY0FBTixHQUF1QixNQUFNN0MsaUJBQTdCLEMsQ0FFQTtBQUNBOzs7QUFDQSxNQUFNOEMsaUJBQWlCLEdBQUdDLElBQUksSUFBSTtBQUNoQyxPQUFLLElBQUlDLENBQUMsR0FBRyxDQUFiLEVBQWdCQSxDQUFDLEdBQUdoRCxpQkFBaUIsQ0FBQ2lELE1BQXRDLEVBQThDRCxDQUFDLEVBQS9DLEVBQW1EO0FBQ2pELFVBQU1sQixTQUFTLEdBQUc5QixpQkFBaUIsQ0FBQ2dELENBQUQsQ0FBbkM7O0FBQ0EsUUFBSWxCLFNBQVMsQ0FBQzNCLFdBQVYsQ0FBc0I0QyxJQUF0QixDQUFKLEVBQWlDO0FBQy9CLGFBQU9qQixTQUFTLENBQUN6QixXQUFWLENBQXNCMEMsSUFBdEIsQ0FBUDtBQUNEO0FBQ0Y7O0FBQ0QsU0FBT0csU0FBUDtBQUNELENBUkQsQyxDQVVBOzs7QUFDQSxNQUFNQyxzQkFBc0IsR0FBR2pELEdBQUcsSUFBSTtBQUNwQztBQUNBLE1BQUlBLEdBQUcsS0FBSyxJQUFaLEVBQWtCO0FBQ2hCLFdBQU8sSUFBUDtBQUNEOztBQUVELFFBQU1rRCxZQUFZLEdBQUdOLGlCQUFpQixDQUFDNUMsR0FBRCxDQUF0Qzs7QUFDQSxNQUFJa0QsWUFBWSxLQUFLRixTQUFyQixFQUFnQztBQUM5QixXQUFPRSxZQUFQO0FBQ0QsR0FUbUMsQ0FXcEM7OztBQUNBLE1BQUksQ0FBQ3RFLFFBQVEsQ0FBQ29CLEdBQUQsQ0FBYixFQUFvQjtBQUNsQixXQUFPQSxHQUFQO0FBQ0QsR0FkbUMsQ0FnQnBDOzs7QUFDQW5CLFFBQU0sQ0FBQ21CLEdBQUQsQ0FBTixDQUFZOEIsT0FBWixDQUFvQkMsR0FBRyxJQUFJO0FBQ3pCLFVBQU1vQixLQUFLLEdBQUduRCxHQUFHLENBQUMrQixHQUFELENBQWpCOztBQUNBLFFBQUksQ0FBQ25ELFFBQVEsQ0FBQ3VFLEtBQUQsQ0FBVCxJQUFvQkEsS0FBSyxLQUFLSCxTQUE5QixJQUNBLENBQUM5RCxVQUFVLENBQUNpRSxLQUFELENBRGYsRUFDd0I7QUFDdEIsYUFEc0IsQ0FDZDtBQUNUOztBQUVELFVBQU1DLE9BQU8sR0FBR1IsaUJBQWlCLENBQUNPLEtBQUQsQ0FBakM7O0FBQ0EsUUFBSUMsT0FBSixFQUFhO0FBQ1hwRCxTQUFHLENBQUMrQixHQUFELENBQUgsR0FBV3FCLE9BQVg7QUFDQSxhQUZXLENBRUg7QUFDVCxLQVh3QixDQVl6QjtBQUNBOzs7QUFDQUgsMEJBQXNCLENBQUNFLEtBQUQsQ0FBdEI7QUFDRCxHQWZEO0FBZ0JBLFNBQU9uRCxHQUFQO0FBQ0QsQ0FsQ0Q7O0FBb0NBdEIsS0FBSyxDQUFDMkUsdUJBQU4sR0FBZ0NKLHNCQUFoQztBQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7QUFDQXZFLEtBQUssQ0FBQ3lCLFdBQU4sR0FBb0IwQyxJQUFJLElBQUk7QUFDMUIsUUFBTU8sT0FBTyxHQUFHUixpQkFBaUIsQ0FBQ0MsSUFBRCxDQUFqQzs7QUFDQSxNQUFJTyxPQUFPLEtBQUtKLFNBQWhCLEVBQTJCO0FBQ3pCLFdBQU9JLE9BQVA7QUFDRDs7QUFFRCxNQUFJRSxPQUFPLEdBQUdULElBQWQ7O0FBQ0EsTUFBSWpFLFFBQVEsQ0FBQ2lFLElBQUQsQ0FBWixFQUFvQjtBQUNsQlMsV0FBTyxHQUFHNUUsS0FBSyxDQUFDNkUsS0FBTixDQUFZVixJQUFaLENBQVY7QUFDQUksMEJBQXNCLENBQUNLLE9BQUQsQ0FBdEI7QUFDRDs7QUFDRCxTQUFPQSxPQUFQO0FBQ0QsQ0FaRCxDLENBY0E7QUFDQTtBQUNBO0FBQ0E7OztBQUNBLE1BQU1FLG1CQUFtQixHQUFHTCxLQUFLLElBQUk7QUFDbkMsTUFBSXZFLFFBQVEsQ0FBQ3VFLEtBQUQsQ0FBUixJQUFtQkEsS0FBSyxLQUFLLElBQWpDLEVBQXVDO0FBQ3JDLFVBQU1NLElBQUksR0FBRzVFLE1BQU0sQ0FBQ3NFLEtBQUQsQ0FBbkI7O0FBQ0EsUUFBSU0sSUFBSSxDQUFDVixNQUFMLElBQWUsQ0FBZixJQUNHVSxJQUFJLENBQUNDLEtBQUwsQ0FBV0MsQ0FBQyxJQUFJLE9BQU9BLENBQVAsS0FBYSxRQUFiLElBQXlCQSxDQUFDLENBQUNDLE1BQUYsQ0FBUyxDQUFULEVBQVksQ0FBWixNQUFtQixHQUE1RCxDQURQLEVBQ3lFO0FBQ3ZFLFdBQUssSUFBSWQsQ0FBQyxHQUFHLENBQWIsRUFBZ0JBLENBQUMsR0FBR2hELGlCQUFpQixDQUFDaUQsTUFBdEMsRUFBOENELENBQUMsRUFBL0MsRUFBbUQ7QUFDakQsY0FBTWxCLFNBQVMsR0FBRzlCLGlCQUFpQixDQUFDZ0QsQ0FBRCxDQUFuQzs7QUFDQSxZQUFJbEIsU0FBUyxDQUFDN0IsY0FBVixDQUF5Qm9ELEtBQXpCLENBQUosRUFBcUM7QUFDbkMsaUJBQU92QixTQUFTLENBQUN0QixhQUFWLENBQXdCNkMsS0FBeEIsQ0FBUDtBQUNEO0FBQ0Y7QUFDRjtBQUNGOztBQUNELFNBQU9BLEtBQVA7QUFDRCxDQWRELEMsQ0FnQkE7QUFDQTtBQUNBOzs7QUFDQSxNQUFNVSx3QkFBd0IsR0FBRzdELEdBQUcsSUFBSTtBQUN0QyxNQUFJQSxHQUFHLEtBQUssSUFBWixFQUFrQjtBQUNoQixXQUFPLElBQVA7QUFDRDs7QUFFRCxRQUFNa0QsWUFBWSxHQUFHTSxtQkFBbUIsQ0FBQ3hELEdBQUQsQ0FBeEM7O0FBQ0EsTUFBSWtELFlBQVksS0FBS2xELEdBQXJCLEVBQTBCO0FBQ3hCLFdBQU9rRCxZQUFQO0FBQ0QsR0FScUMsQ0FVdEM7OztBQUNBLE1BQUksQ0FBQ3RFLFFBQVEsQ0FBQ29CLEdBQUQsQ0FBYixFQUFvQjtBQUNsQixXQUFPQSxHQUFQO0FBQ0Q7O0FBRURuQixRQUFNLENBQUNtQixHQUFELENBQU4sQ0FBWThCLE9BQVosQ0FBb0JDLEdBQUcsSUFBSTtBQUN6QixVQUFNb0IsS0FBSyxHQUFHbkQsR0FBRyxDQUFDK0IsR0FBRCxDQUFqQjs7QUFDQSxRQUFJbkQsUUFBUSxDQUFDdUUsS0FBRCxDQUFaLEVBQXFCO0FBQ25CLFlBQU1DLE9BQU8sR0FBR0ksbUJBQW1CLENBQUNMLEtBQUQsQ0FBbkM7O0FBQ0EsVUFBSUEsS0FBSyxLQUFLQyxPQUFkLEVBQXVCO0FBQ3JCcEQsV0FBRyxDQUFDK0IsR0FBRCxDQUFILEdBQVdxQixPQUFYO0FBQ0E7QUFDRCxPQUxrQixDQU1uQjtBQUNBOzs7QUFDQVMsOEJBQXdCLENBQUNWLEtBQUQsQ0FBeEI7QUFDRDtBQUNGLEdBWkQ7QUFhQSxTQUFPbkQsR0FBUDtBQUNELENBN0JEOztBQStCQXRCLEtBQUssQ0FBQ29GLHlCQUFOLEdBQWtDRCx3QkFBbEM7QUFFQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUNBbkYsS0FBSyxDQUFDNEIsYUFBTixHQUFzQnVDLElBQUksSUFBSTtBQUM1QixNQUFJTyxPQUFPLEdBQUdJLG1CQUFtQixDQUFDWCxJQUFELENBQWpDOztBQUNBLE1BQUlPLE9BQU8sS0FBS1AsSUFBWixJQUFvQmpFLFFBQVEsQ0FBQ2lFLElBQUQsQ0FBaEMsRUFBd0M7QUFDdENPLFdBQU8sR0FBRzFFLEtBQUssQ0FBQzZFLEtBQU4sQ0FBWVYsSUFBWixDQUFWO0FBQ0FnQiw0QkFBd0IsQ0FBQ1QsT0FBRCxDQUF4QjtBQUNEOztBQUNELFNBQU9BLE9BQVA7QUFDRCxDQVBEO0FBU0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7O0FBQ0ExRSxLQUFLLENBQUNxRixTQUFOLEdBQWtCNUUsV0FBVyxDQUFDLENBQUMwRCxJQUFELEVBQU9tQixPQUFQLEtBQW1CO0FBQy9DLE1BQUlDLFVBQUo7QUFDQSxRQUFNQyxJQUFJLEdBQUd4RixLQUFLLENBQUN5QixXQUFOLENBQWtCMEMsSUFBbEIsQ0FBYjs7QUFDQSxNQUFJbUIsT0FBTyxLQUFLQSxPQUFPLENBQUNHLFNBQVIsSUFBcUJILE9BQU8sQ0FBQ0ksTUFBbEMsQ0FBWCxFQUFzRDtBQTVZeEQsUUFBSUMsa0JBQUo7QUFBdUI3RixVQUFNLENBQUNZLElBQVAsQ0FBWSxhQUFaLEVBQTBCO0FBQUNrRixhQUFPLENBQUNqRixDQUFELEVBQUc7QUFBQ2dGLDBCQUFrQixHQUFDaEYsQ0FBbkI7QUFBcUI7O0FBQWpDLEtBQTFCLEVBQTZELENBQTdEO0FBOFluQjRFLGNBQVUsR0FBR0ksa0JBQWtCLENBQUNILElBQUQsRUFBT0YsT0FBUCxDQUEvQjtBQUNELEdBSEQsTUFHTztBQUNMQyxjQUFVLEdBQUdNLElBQUksQ0FBQ1IsU0FBTCxDQUFlRyxJQUFmLENBQWI7QUFDRDs7QUFDRCxTQUFPRCxVQUFQO0FBQ0QsQ0FWNEIsQ0FBN0I7QUFZQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBQ0F2RixLQUFLLENBQUM4RixLQUFOLEdBQWMzQixJQUFJLElBQUk7QUFDcEIsTUFBSSxPQUFPQSxJQUFQLEtBQWdCLFFBQXBCLEVBQThCO0FBQzVCLFVBQU0sSUFBSWpELEtBQUosQ0FBVSx5Q0FBVixDQUFOO0FBQ0Q7O0FBQ0QsU0FBT2xCLEtBQUssQ0FBQzRCLGFBQU4sQ0FBb0JpRSxJQUFJLENBQUNDLEtBQUwsQ0FBVzNCLElBQVgsQ0FBcEIsQ0FBUDtBQUNELENBTEQ7QUFPQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUNBbkUsS0FBSyxDQUFDK0YsUUFBTixHQUFpQnpFLEdBQUcsSUFBSTtBQUN0QixTQUFPLENBQUMsRUFBRyxPQUFPb0IsVUFBUCxLQUFzQixXQUF0QixJQUFxQ3BCLEdBQUcsWUFBWW9CLFVBQXJELElBQ1BwQixHQUFHLElBQUlBLEdBQUcsQ0FBQzBFLG1CQUROLENBQVI7QUFFRCxDQUhEO0FBS0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUNBaEcsS0FBSyxDQUFDaUcsTUFBTixHQUFlLENBQUNDLENBQUQsRUFBSUMsQ0FBSixFQUFPYixPQUFQLEtBQW1CO0FBQ2hDLE1BQUlsQixDQUFKO0FBQ0EsUUFBTWdDLGlCQUFpQixHQUFHLENBQUMsRUFBRWQsT0FBTyxJQUFJQSxPQUFPLENBQUNjLGlCQUFyQixDQUEzQjs7QUFDQSxNQUFJRixDQUFDLEtBQUtDLENBQVYsRUFBYTtBQUNYLFdBQU8sSUFBUDtBQUNELEdBTCtCLENBT2hDO0FBQ0E7OztBQUNBLE1BQUk3RCxNQUFNLENBQUNDLEtBQVAsQ0FBYTJELENBQWIsS0FBbUI1RCxNQUFNLENBQUNDLEtBQVAsQ0FBYTRELENBQWIsQ0FBdkIsRUFBd0M7QUFDdEMsV0FBTyxJQUFQO0FBQ0QsR0FYK0IsQ0FhaEM7OztBQUNBLE1BQUksQ0FBQ0QsQ0FBRCxJQUFNLENBQUNDLENBQVgsRUFBYztBQUNaLFdBQU8sS0FBUDtBQUNEOztBQUVELE1BQUksRUFBRWpHLFFBQVEsQ0FBQ2dHLENBQUQsQ0FBUixJQUFlaEcsUUFBUSxDQUFDaUcsQ0FBRCxDQUF6QixDQUFKLEVBQW1DO0FBQ2pDLFdBQU8sS0FBUDtBQUNEOztBQUVELE1BQUlELENBQUMsWUFBWTFFLElBQWIsSUFBcUIyRSxDQUFDLFlBQVkzRSxJQUF0QyxFQUE0QztBQUMxQyxXQUFPMEUsQ0FBQyxDQUFDRyxPQUFGLE9BQWdCRixDQUFDLENBQUNFLE9BQUYsRUFBdkI7QUFDRDs7QUFFRCxNQUFJckcsS0FBSyxDQUFDK0YsUUFBTixDQUFlRyxDQUFmLEtBQXFCbEcsS0FBSyxDQUFDK0YsUUFBTixDQUFlSSxDQUFmLENBQXpCLEVBQTRDO0FBQzFDLFFBQUlELENBQUMsQ0FBQzdCLE1BQUYsS0FBYThCLENBQUMsQ0FBQzlCLE1BQW5CLEVBQTJCO0FBQ3pCLGFBQU8sS0FBUDtBQUNEOztBQUNELFNBQUtELENBQUMsR0FBRyxDQUFULEVBQVlBLENBQUMsR0FBRzhCLENBQUMsQ0FBQzdCLE1BQWxCLEVBQTBCRCxDQUFDLEVBQTNCLEVBQStCO0FBQzdCLFVBQUk4QixDQUFDLENBQUM5QixDQUFELENBQUQsS0FBUytCLENBQUMsQ0FBQy9CLENBQUQsQ0FBZCxFQUFtQjtBQUNqQixlQUFPLEtBQVA7QUFDRDtBQUNGOztBQUNELFdBQU8sSUFBUDtBQUNEOztBQUVELE1BQUluRSxVQUFVLENBQUNpRyxDQUFDLENBQUNELE1BQUgsQ0FBZCxFQUEwQjtBQUN4QixXQUFPQyxDQUFDLENBQUNELE1BQUYsQ0FBU0UsQ0FBVCxFQUFZYixPQUFaLENBQVA7QUFDRDs7QUFFRCxNQUFJckYsVUFBVSxDQUFDa0csQ0FBQyxDQUFDRixNQUFILENBQWQsRUFBMEI7QUFDeEIsV0FBT0UsQ0FBQyxDQUFDRixNQUFGLENBQVNDLENBQVQsRUFBWVosT0FBWixDQUFQO0FBQ0QsR0E1QytCLENBOENoQzs7O0FBQ0EsUUFBTWdCLFFBQVEsR0FBR0MsS0FBSyxDQUFDQyxPQUFOLENBQWNOLENBQWQsQ0FBakI7QUFDQSxRQUFNTyxRQUFRLEdBQUdGLEtBQUssQ0FBQ0MsT0FBTixDQUFjTCxDQUFkLENBQWpCLENBaERnQyxDQWtEaEM7O0FBQ0EsTUFBSUcsUUFBUSxLQUFLRyxRQUFqQixFQUEyQjtBQUN6QixXQUFPLEtBQVA7QUFDRDs7QUFFRCxNQUFJSCxRQUFRLElBQUlHLFFBQWhCLEVBQTBCO0FBQ3hCLFFBQUlQLENBQUMsQ0FBQzdCLE1BQUYsS0FBYThCLENBQUMsQ0FBQzlCLE1BQW5CLEVBQTJCO0FBQ3pCLGFBQU8sS0FBUDtBQUNEOztBQUNELFNBQUtELENBQUMsR0FBRyxDQUFULEVBQVlBLENBQUMsR0FBRzhCLENBQUMsQ0FBQzdCLE1BQWxCLEVBQTBCRCxDQUFDLEVBQTNCLEVBQStCO0FBQzdCLFVBQUksQ0FBQ3BFLEtBQUssQ0FBQ2lHLE1BQU4sQ0FBYUMsQ0FBQyxDQUFDOUIsQ0FBRCxDQUFkLEVBQW1CK0IsQ0FBQyxDQUFDL0IsQ0FBRCxDQUFwQixFQUF5QmtCLE9BQXpCLENBQUwsRUFBd0M7QUFDdEMsZUFBTyxLQUFQO0FBQ0Q7QUFDRjs7QUFDRCxXQUFPLElBQVA7QUFDRCxHQWpFK0IsQ0FtRWhDOzs7QUFDQSxVQUFRdEYsS0FBSyxDQUFDdUQsYUFBTixDQUFvQjJDLENBQXBCLElBQXlCbEcsS0FBSyxDQUFDdUQsYUFBTixDQUFvQjRDLENBQXBCLENBQWpDO0FBQ0UsU0FBSyxDQUFMO0FBQVEsYUFBTyxLQUFQOztBQUNSLFNBQUssQ0FBTDtBQUFRLGFBQU9uRyxLQUFLLENBQUNpRyxNQUFOLENBQWFqRyxLQUFLLENBQUN5QixXQUFOLENBQWtCeUUsQ0FBbEIsQ0FBYixFQUFtQ2xHLEtBQUssQ0FBQ3lCLFdBQU4sQ0FBa0IwRSxDQUFsQixDQUFuQyxDQUFQOztBQUNSLFlBSEYsQ0FHVzs7QUFIWCxHQXBFZ0MsQ0EwRWhDOzs7QUFDQSxNQUFJTyxHQUFKO0FBQ0EsUUFBTUMsS0FBSyxHQUFHeEcsTUFBTSxDQUFDK0YsQ0FBRCxDQUFwQjtBQUNBLFFBQU1VLEtBQUssR0FBR3pHLE1BQU0sQ0FBQ2dHLENBQUQsQ0FBcEI7O0FBQ0EsTUFBSUMsaUJBQUosRUFBdUI7QUFDckJoQyxLQUFDLEdBQUcsQ0FBSjtBQUNBc0MsT0FBRyxHQUFHQyxLQUFLLENBQUMzQixLQUFOLENBQVkzQixHQUFHLElBQUk7QUFDdkIsVUFBSWUsQ0FBQyxJQUFJd0MsS0FBSyxDQUFDdkMsTUFBZixFQUF1QjtBQUNyQixlQUFPLEtBQVA7QUFDRDs7QUFDRCxVQUFJaEIsR0FBRyxLQUFLdUQsS0FBSyxDQUFDeEMsQ0FBRCxDQUFqQixFQUFzQjtBQUNwQixlQUFPLEtBQVA7QUFDRDs7QUFDRCxVQUFJLENBQUNwRSxLQUFLLENBQUNpRyxNQUFOLENBQWFDLENBQUMsQ0FBQzdDLEdBQUQsQ0FBZCxFQUFxQjhDLENBQUMsQ0FBQ1MsS0FBSyxDQUFDeEMsQ0FBRCxDQUFOLENBQXRCLEVBQWtDa0IsT0FBbEMsQ0FBTCxFQUFpRDtBQUMvQyxlQUFPLEtBQVA7QUFDRDs7QUFDRGxCLE9BQUM7QUFDRCxhQUFPLElBQVA7QUFDRCxLQVpLLENBQU47QUFhRCxHQWZELE1BZU87QUFDTEEsS0FBQyxHQUFHLENBQUo7QUFDQXNDLE9BQUcsR0FBR0MsS0FBSyxDQUFDM0IsS0FBTixDQUFZM0IsR0FBRyxJQUFJO0FBQ3ZCLFVBQUksQ0FBQ2hELE1BQU0sQ0FBQzhGLENBQUQsRUFBSTlDLEdBQUosQ0FBWCxFQUFxQjtBQUNuQixlQUFPLEtBQVA7QUFDRDs7QUFDRCxVQUFJLENBQUNyRCxLQUFLLENBQUNpRyxNQUFOLENBQWFDLENBQUMsQ0FBQzdDLEdBQUQsQ0FBZCxFQUFxQjhDLENBQUMsQ0FBQzlDLEdBQUQsQ0FBdEIsRUFBNkJpQyxPQUE3QixDQUFMLEVBQTRDO0FBQzFDLGVBQU8sS0FBUDtBQUNEOztBQUNEbEIsT0FBQztBQUNELGFBQU8sSUFBUDtBQUNELEtBVEssQ0FBTjtBQVVEOztBQUNELFNBQU9zQyxHQUFHLElBQUl0QyxDQUFDLEtBQUt3QyxLQUFLLENBQUN2QyxNQUExQjtBQUNELENBM0dEO0FBNkdBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUNBckUsS0FBSyxDQUFDNkUsS0FBTixHQUFjbEUsQ0FBQyxJQUFJO0FBQ2pCLE1BQUkrRixHQUFKOztBQUNBLE1BQUksQ0FBQ3hHLFFBQVEsQ0FBQ1MsQ0FBRCxDQUFiLEVBQWtCO0FBQ2hCLFdBQU9BLENBQVA7QUFDRDs7QUFFRCxNQUFJQSxDQUFDLEtBQUssSUFBVixFQUFnQjtBQUNkLFdBQU8sSUFBUCxDQURjLENBQ0Q7QUFDZDs7QUFFRCxNQUFJQSxDQUFDLFlBQVlhLElBQWpCLEVBQXVCO0FBQ3JCLFdBQU8sSUFBSUEsSUFBSixDQUFTYixDQUFDLENBQUNnQixPQUFGLEVBQVQsQ0FBUDtBQUNELEdBWmdCLENBY2pCO0FBQ0E7OztBQUNBLE1BQUloQixDQUFDLFlBQVlrQixNQUFqQixFQUF5QjtBQUN2QixXQUFPbEIsQ0FBUDtBQUNEOztBQUVELE1BQUlYLEtBQUssQ0FBQytGLFFBQU4sQ0FBZXBGLENBQWYsQ0FBSixFQUF1QjtBQUNyQitGLE9BQUcsR0FBRzFHLEtBQUssQ0FBQzZHLFNBQU4sQ0FBZ0JsRyxDQUFDLENBQUMwRCxNQUFsQixDQUFOOztBQUNBLFNBQUssSUFBSUQsQ0FBQyxHQUFHLENBQWIsRUFBZ0JBLENBQUMsR0FBR3pELENBQUMsQ0FBQzBELE1BQXRCLEVBQThCRCxDQUFDLEVBQS9CLEVBQW1DO0FBQ2pDc0MsU0FBRyxDQUFDdEMsQ0FBRCxDQUFILEdBQVN6RCxDQUFDLENBQUN5RCxDQUFELENBQVY7QUFDRDs7QUFDRCxXQUFPc0MsR0FBUDtBQUNEOztBQUVELE1BQUlILEtBQUssQ0FBQ0MsT0FBTixDQUFjN0YsQ0FBZCxDQUFKLEVBQXNCO0FBQ3BCLFdBQU9BLENBQUMsQ0FBQ21HLEdBQUYsQ0FBTTlHLEtBQUssQ0FBQzZFLEtBQVosQ0FBUDtBQUNEOztBQUVELE1BQUl0RSxXQUFXLENBQUNJLENBQUQsQ0FBZixFQUFvQjtBQUNsQixXQUFPNEYsS0FBSyxDQUFDUSxJQUFOLENBQVdwRyxDQUFYLEVBQWNtRyxHQUFkLENBQWtCOUcsS0FBSyxDQUFDNkUsS0FBeEIsQ0FBUDtBQUNELEdBbENnQixDQW9DakI7OztBQUNBLE1BQUk1RSxVQUFVLENBQUNVLENBQUMsQ0FBQ2tFLEtBQUgsQ0FBZCxFQUF5QjtBQUN2QixXQUFPbEUsQ0FBQyxDQUFDa0UsS0FBRixFQUFQO0FBQ0QsR0F2Q2dCLENBeUNqQjs7O0FBQ0EsTUFBSTdFLEtBQUssQ0FBQ3VELGFBQU4sQ0FBb0I1QyxDQUFwQixDQUFKLEVBQTRCO0FBQzFCLFdBQU9YLEtBQUssQ0FBQzRCLGFBQU4sQ0FBb0I1QixLQUFLLENBQUM2RSxLQUFOLENBQVk3RSxLQUFLLENBQUN5QixXQUFOLENBQWtCZCxDQUFsQixDQUFaLENBQXBCLEVBQXVELElBQXZELENBQVA7QUFDRCxHQTVDZ0IsQ0E4Q2pCOzs7QUFDQStGLEtBQUcsR0FBRyxFQUFOO0FBQ0F2RyxRQUFNLENBQUNRLENBQUQsQ0FBTixDQUFVeUMsT0FBVixDQUFtQkMsR0FBRCxJQUFTO0FBQ3pCcUQsT0FBRyxDQUFDckQsR0FBRCxDQUFILEdBQVdyRCxLQUFLLENBQUM2RSxLQUFOLENBQVlsRSxDQUFDLENBQUMwQyxHQUFELENBQWIsQ0FBWDtBQUNELEdBRkQ7QUFHQSxTQUFPcUQsR0FBUDtBQUNELENBcEREO0FBc0RBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOzs7QUFDQTFHLEtBQUssQ0FBQzZHLFNBQU4sR0FBa0JqRSxNQUFNLENBQUNpRSxTQUF6QixDOzs7Ozs7Ozs7OztBQzVtQkE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUVBLFNBQVNHLEtBQVQsQ0FBZUMsTUFBZixFQUF1QjtBQUNyQixTQUFPcEIsSUFBSSxDQUFDUixTQUFMLENBQWU0QixNQUFmLENBQVA7QUFDRDs7QUFFRCxNQUFNQyxHQUFHLEdBQUcsQ0FBQzdELEdBQUQsRUFBTThELE1BQU4sRUFBY0MsWUFBZCxFQUE0QkMsV0FBNUIsRUFBeUM1QixTQUF6QyxLQUF1RDtBQUNqRSxRQUFNaEIsS0FBSyxHQUFHMEMsTUFBTSxDQUFDOUQsR0FBRCxDQUFwQixDQURpRSxDQUdqRTs7QUFDQSxVQUFRLE9BQU9vQixLQUFmO0FBQ0EsU0FBSyxRQUFMO0FBQ0UsYUFBT3VDLEtBQUssQ0FBQ3ZDLEtBQUQsQ0FBWjs7QUFDRixTQUFLLFFBQUw7QUFDRTtBQUNBLGFBQU82QyxRQUFRLENBQUM3QyxLQUFELENBQVIsR0FBa0I4QyxNQUFNLENBQUM5QyxLQUFELENBQXhCLEdBQWtDLE1BQXpDOztBQUNGLFNBQUssU0FBTDtBQUNFLGFBQU84QyxNQUFNLENBQUM5QyxLQUFELENBQWI7QUFDRjtBQUNBOztBQUNBLFNBQUssUUFBTDtBQUFlO0FBQ2I7QUFDQTtBQUNBLFlBQUksQ0FBQ0EsS0FBTCxFQUFZO0FBQ1YsaUJBQU8sTUFBUDtBQUNELFNBTFksQ0FNYjtBQUNBOzs7QUFDQSxjQUFNK0MsV0FBVyxHQUFHSCxXQUFXLEdBQUdELFlBQWxDO0FBQ0EsY0FBTUssT0FBTyxHQUFHLEVBQWhCO0FBQ0EsWUFBSTlHLENBQUosQ0FWYSxDQVliOztBQUNBLFlBQUk0RixLQUFLLENBQUNDLE9BQU4sQ0FBYy9CLEtBQWQsS0FBeUIsRUFBRCxDQUFLaUQsY0FBTCxDQUFvQkMsSUFBcEIsQ0FBeUJsRCxLQUF6QixFQUFnQyxRQUFoQyxDQUE1QixFQUF1RTtBQUNyRTtBQUNBO0FBQ0EsZ0JBQU1KLE1BQU0sR0FBR0ksS0FBSyxDQUFDSixNQUFyQjs7QUFDQSxlQUFLLElBQUlELENBQUMsR0FBRyxDQUFiLEVBQWdCQSxDQUFDLEdBQUdDLE1BQXBCLEVBQTRCRCxDQUFDLElBQUksQ0FBakMsRUFBb0M7QUFDbENxRCxtQkFBTyxDQUFDckQsQ0FBRCxDQUFQLEdBQ0U4QyxHQUFHLENBQUM5QyxDQUFELEVBQUlLLEtBQUosRUFBVzJDLFlBQVgsRUFBeUJJLFdBQXpCLEVBQXNDL0IsU0FBdEMsQ0FBSCxJQUF1RCxNQUR6RDtBQUVELFdBUG9FLENBU3JFO0FBQ0E7OztBQUNBLGNBQUlnQyxPQUFPLENBQUNwRCxNQUFSLEtBQW1CLENBQXZCLEVBQTBCO0FBQ3hCMUQsYUFBQyxHQUFHLElBQUo7QUFDRCxXQUZELE1BRU8sSUFBSTZHLFdBQUosRUFBaUI7QUFDdEI3RyxhQUFDLEdBQUcsUUFDRjZHLFdBREUsR0FFRkMsT0FBTyxDQUFDRyxJQUFSLENBQWEsUUFDYkosV0FEQSxDQUZFLEdBSUYsSUFKRSxHQUtGSCxXQUxFLEdBTUYsR0FORjtBQU9ELFdBUk0sTUFRQTtBQUNMMUcsYUFBQyxHQUFHLE1BQU04RyxPQUFPLENBQUNHLElBQVIsQ0FBYSxHQUFiLENBQU4sR0FBMEIsR0FBOUI7QUFDRDs7QUFDRCxpQkFBT2pILENBQVA7QUFDRCxTQXRDWSxDQXdDYjs7O0FBQ0EsWUFBSW9FLElBQUksR0FBRzhDLE1BQU0sQ0FBQzlDLElBQVAsQ0FBWU4sS0FBWixDQUFYOztBQUNBLFlBQUlnQixTQUFKLEVBQWU7QUFDYlYsY0FBSSxHQUFHQSxJQUFJLENBQUMrQyxJQUFMLEVBQVA7QUFDRDs7QUFDRC9DLFlBQUksQ0FBQzNCLE9BQUwsQ0FBYTZCLENBQUMsSUFBSTtBQUNoQnRFLFdBQUMsR0FBR3VHLEdBQUcsQ0FBQ2pDLENBQUQsRUFBSVIsS0FBSixFQUFXMkMsWUFBWCxFQUF5QkksV0FBekIsRUFBc0MvQixTQUF0QyxDQUFQOztBQUNBLGNBQUk5RSxDQUFKLEVBQU87QUFDTDhHLG1CQUFPLENBQUNNLElBQVIsQ0FBYWYsS0FBSyxDQUFDL0IsQ0FBRCxDQUFMLElBQVl1QyxXQUFXLEdBQUcsSUFBSCxHQUFVLEdBQWpDLElBQXdDN0csQ0FBckQ7QUFDRDtBQUNGLFNBTEQsRUE3Q2EsQ0FvRGI7QUFDQTs7QUFDQSxZQUFJOEcsT0FBTyxDQUFDcEQsTUFBUixLQUFtQixDQUF2QixFQUEwQjtBQUN4QjFELFdBQUMsR0FBRyxJQUFKO0FBQ0QsU0FGRCxNQUVPLElBQUk2RyxXQUFKLEVBQWlCO0FBQ3RCN0csV0FBQyxHQUFHLFFBQ0Y2RyxXQURFLEdBRUZDLE9BQU8sQ0FBQ0csSUFBUixDQUFhLFFBQ2JKLFdBREEsQ0FGRSxHQUlGLElBSkUsR0FLRkgsV0FMRSxHQU1GLEdBTkY7QUFPRCxTQVJNLE1BUUE7QUFDTDFHLFdBQUMsR0FBRyxNQUFNOEcsT0FBTyxDQUFDRyxJQUFSLENBQWEsR0FBYixDQUFOLEdBQTBCLEdBQTlCO0FBQ0Q7O0FBQ0QsZUFBT2pILENBQVA7QUFDRDs7QUFFRCxZQWhGQSxDQWdGUzs7QUFoRlQ7QUFrRkQsQ0F0RkQsQyxDQXdGQTs7O0FBQ0EsTUFBTWdGLGtCQUFrQixHQUFHLENBQUNsQixLQUFELEVBQVFhLE9BQVIsS0FBb0I7QUFDN0M7QUFDQTtBQUNBLFFBQU0wQyxVQUFVLEdBQUdILE1BQU0sQ0FBQ0ksTUFBUCxDQUFjO0FBQy9CdkMsVUFBTSxFQUFFLEVBRHVCO0FBRS9CRCxhQUFTLEVBQUU7QUFGb0IsR0FBZCxFQUdoQkgsT0FIZ0IsQ0FBbkI7O0FBSUEsTUFBSTBDLFVBQVUsQ0FBQ3RDLE1BQVgsS0FBc0IsSUFBMUIsRUFBZ0M7QUFDOUJzQyxjQUFVLENBQUN0QyxNQUFYLEdBQW9CLElBQXBCO0FBQ0QsR0FGRCxNQUVPLElBQUksT0FBT3NDLFVBQVUsQ0FBQ3RDLE1BQWxCLEtBQTZCLFFBQWpDLEVBQTJDO0FBQ2hELFFBQUl3QyxTQUFTLEdBQUcsRUFBaEI7O0FBQ0EsU0FBSyxJQUFJOUQsQ0FBQyxHQUFHLENBQWIsRUFBZ0JBLENBQUMsR0FBRzRELFVBQVUsQ0FBQ3RDLE1BQS9CLEVBQXVDdEIsQ0FBQyxFQUF4QyxFQUE0QztBQUMxQzhELGVBQVMsSUFBSSxHQUFiO0FBQ0Q7O0FBQ0RGLGNBQVUsQ0FBQ3RDLE1BQVgsR0FBb0J3QyxTQUFwQjtBQUNEOztBQUNELFNBQU9oQixHQUFHLENBQUMsRUFBRCxFQUFLO0FBQUMsUUFBSXpDO0FBQUwsR0FBTCxFQUFrQnVELFVBQVUsQ0FBQ3RDLE1BQTdCLEVBQXFDLEVBQXJDLEVBQXlDc0MsVUFBVSxDQUFDdkMsU0FBcEQsQ0FBVjtBQUNELENBakJEOztBQXRHQTNGLE1BQU0sQ0FBQ3FJLGFBQVAsQ0F5SGV4QyxrQkF6SGYsRTs7Ozs7Ozs7Ozs7QUNBQTdGLE1BQU0sQ0FBQ0MsTUFBUCxDQUFjO0FBQUNFLFlBQVUsRUFBQyxNQUFJQSxVQUFoQjtBQUEyQkMsVUFBUSxFQUFDLE1BQUlBLFFBQXhDO0FBQWlEQyxRQUFNLEVBQUMsTUFBSUEsTUFBNUQ7QUFBbUVDLFVBQVEsRUFBQyxNQUFJQSxRQUFoRjtBQUF5RkMsUUFBTSxFQUFDLE1BQUlBLE1BQXBHO0FBQTJHQyxvQkFBa0IsRUFBQyxNQUFJQSxrQkFBbEk7QUFBcUpDLGFBQVcsRUFBQyxNQUFJQSxXQUFySztBQUFpTEMsWUFBVSxFQUFDLE1BQUlBLFVBQWhNO0FBQTJNNEgsWUFBVSxFQUFDLE1BQUlBLFVBQTFOO0FBQXFPM0gsYUFBVyxFQUFDLE1BQUlBO0FBQXJQLENBQWQ7O0FBQU8sTUFBTVIsVUFBVSxHQUFJb0ksRUFBRCxJQUFRLE9BQU9BLEVBQVAsS0FBYyxVQUF6Qzs7QUFFQSxNQUFNbkksUUFBUSxHQUFJbUksRUFBRCxJQUFRLE9BQU9BLEVBQVAsS0FBYyxRQUF2Qzs7QUFFQSxNQUFNbEksTUFBTSxHQUFJbUIsR0FBRCxJQUFTdUcsTUFBTSxDQUFDOUMsSUFBUCxDQUFZekQsR0FBWixDQUF4Qjs7QUFFQSxNQUFNbEIsUUFBUSxHQUFJa0IsR0FBRCxJQUFTdUcsTUFBTSxDQUFDOUMsSUFBUCxDQUFZekQsR0FBWixFQUFpQitDLE1BQTNDOztBQUVBLE1BQU1oRSxNQUFNLEdBQUcsQ0FBQ2lCLEdBQUQsRUFBTWdILElBQU4sS0FBZVQsTUFBTSxDQUFDVSxTQUFQLENBQWlCYixjQUFqQixDQUFnQ0MsSUFBaEMsQ0FBcUNyRyxHQUFyQyxFQUEwQ2dILElBQTFDLENBQTlCOztBQUVBLE1BQU1oSSxrQkFBa0IsR0FBSXdHLEdBQUQsSUFBU1AsS0FBSyxDQUFDUSxJQUFOLENBQVdELEdBQVgsRUFBZ0IwQixNQUFoQixDQUF1QixDQUFDQyxHQUFELFdBQXVCO0FBQUEsTUFBakIsQ0FBQ3BGLEdBQUQsRUFBTW9CLEtBQU4sQ0FBaUI7QUFDdkY7QUFDQWdFLEtBQUcsQ0FBQ3BGLEdBQUQsQ0FBSCxHQUFXb0IsS0FBWDtBQUNBLFNBQU9nRSxHQUFQO0FBQ0QsQ0FKMEMsRUFJeEMsRUFKd0MsQ0FBcEM7O0FBTUEsTUFBTWxJLFdBQVcsR0FBR2UsR0FBRyxJQUFJQSxHQUFHLElBQUksSUFBUCxJQUFlakIsTUFBTSxDQUFDaUIsR0FBRCxFQUFNLFFBQU4sQ0FBaEQ7O0FBRUEsTUFBTWQsVUFBVSxHQUNyQmMsR0FBRyxJQUFJZ0IsTUFBTSxDQUFDQyxLQUFQLENBQWFqQixHQUFiLEtBQXFCQSxHQUFHLEtBQUtrQixRQUE3QixJQUF5Q2xCLEdBQUcsS0FBSyxDQUFDa0IsUUFEcEQ7O0FBR0EsTUFBTTRGLFVBQVUsR0FBRztBQUN4Qk0sVUFBUSxFQUFHQyxRQUFELElBQWMsSUFBSTlHLE1BQUosQ0FBVyxrQ0FBWCxFQUErQyxHQUEvQyxFQUFvRCtHLElBQXBELENBQXlERCxRQUF6RDtBQURBLENBQW5COztBQUlBLE1BQU1sSSxXQUFXLEdBQUk0SCxFQUFELElBQVEsWUFBVztBQUM1QyxNQUFJO0FBQ0YsV0FBT0EsRUFBRSxDQUFDUSxLQUFILENBQVMsSUFBVCxFQUFlQyxTQUFmLENBQVA7QUFDRCxHQUZELENBRUUsT0FBT0MsS0FBUCxFQUFjO0FBQ2QsVUFBTUMsVUFBVSxHQUFHWixVQUFVLENBQUNNLFFBQVgsQ0FBb0JLLEtBQUssQ0FBQ0UsT0FBMUIsQ0FBbkI7O0FBQ0EsUUFBSUQsVUFBSixFQUFnQjtBQUNkLFlBQU0sSUFBSTlILEtBQUosQ0FBVSx1Q0FBVixDQUFOO0FBQ0Q7O0FBQ0QsVUFBTTZILEtBQU47QUFDRDtBQUNGLENBVk0sQyIsImZpbGUiOiIvcGFja2FnZXMvZWpzb24uanMiLCJzb3VyY2VzQ29udGVudCI6WyJpbXBvcnQge1xuICBpc0Z1bmN0aW9uLFxuICBpc09iamVjdCxcbiAga2V5c09mLFxuICBsZW5ndGhPZixcbiAgaGFzT3duLFxuICBjb252ZXJ0TWFwVG9PYmplY3QsXG4gIGlzQXJndW1lbnRzLFxuICBpc0luZk9yTmFOLFxuICBoYW5kbGVFcnJvcixcbn0gZnJvbSAnLi91dGlscyc7XG5cbi8qKlxuICogQG5hbWVzcGFjZVxuICogQHN1bW1hcnkgTmFtZXNwYWNlIGZvciBFSlNPTiBmdW5jdGlvbnNcbiAqL1xuY29uc3QgRUpTT04gPSB7fTtcblxuLy8gQ3VzdG9tIHR5cGUgaW50ZXJmYWNlIGRlZmluaXRpb25cbi8qKlxuICogQGNsYXNzIEN1c3RvbVR5cGVcbiAqIEBpbnN0YW5jZU5hbWUgY3VzdG9tVHlwZVxuICogQG1lbWJlck9mIEVKU09OXG4gKiBAc3VtbWFyeSBUaGUgaW50ZXJmYWNlIHRoYXQgYSBjbGFzcyBtdXN0IHNhdGlzZnkgdG8gYmUgYWJsZSB0byBiZWNvbWUgYW5cbiAqIEVKU09OIGN1c3RvbSB0eXBlIHZpYSBFSlNPTi5hZGRUeXBlLlxuICovXG5cbi8qKlxuICogQGZ1bmN0aW9uIHR5cGVOYW1lXG4gKiBAbWVtYmVyT2YgRUpTT04uQ3VzdG9tVHlwZVxuICogQHN1bW1hcnkgUmV0dXJuIHRoZSB0YWcgdXNlZCB0byBpZGVudGlmeSB0aGlzIHR5cGUuICBUaGlzIG11c3QgbWF0Y2ggdGhlXG4gKiAgICAgICAgICB0YWcgdXNlZCB0byByZWdpc3RlciB0aGlzIHR5cGUgd2l0aFxuICogICAgICAgICAgW2BFSlNPTi5hZGRUeXBlYF0oI2Vqc29uX2FkZF90eXBlKS5cbiAqIEBsb2N1cyBBbnl3aGVyZVxuICogQGluc3RhbmNlXG4gKi9cblxuLyoqXG4gKiBAZnVuY3Rpb24gdG9KU09OVmFsdWVcbiAqIEBtZW1iZXJPZiBFSlNPTi5DdXN0b21UeXBlXG4gKiBAc3VtbWFyeSBTZXJpYWxpemUgdGhpcyBpbnN0YW5jZSBpbnRvIGEgSlNPTi1jb21wYXRpYmxlIHZhbHVlLlxuICogQGxvY3VzIEFueXdoZXJlXG4gKiBAaW5zdGFuY2VcbiAqL1xuXG4vKipcbiAqIEBmdW5jdGlvbiBjbG9uZVxuICogQG1lbWJlck9mIEVKU09OLkN1c3RvbVR5cGVcbiAqIEBzdW1tYXJ5IFJldHVybiBhIHZhbHVlIGByYCBzdWNoIHRoYXQgYHRoaXMuZXF1YWxzKHIpYCBpcyB0cnVlLCBhbmRcbiAqICAgICAgICAgIG1vZGlmaWNhdGlvbnMgdG8gYHJgIGRvIG5vdCBhZmZlY3QgYHRoaXNgIGFuZCB2aWNlIHZlcnNhLlxuICogQGxvY3VzIEFueXdoZXJlXG4gKiBAaW5zdGFuY2VcbiAqL1xuXG4vKipcbiAqIEBmdW5jdGlvbiBlcXVhbHNcbiAqIEBtZW1iZXJPZiBFSlNPTi5DdXN0b21UeXBlXG4gKiBAc3VtbWFyeSBSZXR1cm4gYHRydWVgIGlmIGBvdGhlcmAgaGFzIGEgdmFsdWUgZXF1YWwgdG8gYHRoaXNgOyBgZmFsc2VgXG4gKiAgICAgICAgICBvdGhlcndpc2UuXG4gKiBAbG9jdXMgQW55d2hlcmVcbiAqIEBwYXJhbSB7T2JqZWN0fSBvdGhlciBBbm90aGVyIG9iamVjdCB0byBjb21wYXJlIHRoaXMgdG8uXG4gKiBAaW5zdGFuY2VcbiAqL1xuXG5jb25zdCBjdXN0b21UeXBlcyA9IG5ldyBNYXAoKTtcblxuLy8gQWRkIGEgY3VzdG9tIHR5cGUsIHVzaW5nIGEgbWV0aG9kIG9mIHlvdXIgY2hvaWNlIHRvIGdldCB0byBhbmRcbi8vIGZyb20gYSBiYXNpYyBKU09OLWFibGUgcmVwcmVzZW50YXRpb24uICBUaGUgZmFjdG9yeSBhcmd1bWVudFxuLy8gaXMgYSBmdW5jdGlvbiBvZiBKU09OLWFibGUgLS0+IHlvdXIgb2JqZWN0XG4vLyBUaGUgdHlwZSB5b3UgYWRkIG11c3QgaGF2ZTpcbi8vIC0gQSB0b0pTT05WYWx1ZSgpIG1ldGhvZCwgc28gdGhhdCBNZXRlb3IgY2FuIHNlcmlhbGl6ZSBpdFxuLy8gLSBhIHR5cGVOYW1lKCkgbWV0aG9kLCB0byBzaG93IGhvdyB0byBsb29rIGl0IHVwIGluIG91ciB0eXBlIHRhYmxlLlxuLy8gSXQgaXMgb2theSBpZiB0aGVzZSBtZXRob2RzIGFyZSBtb25rZXktcGF0Y2hlZCBvbi5cbi8vIEVKU09OLmNsb25lIHdpbGwgdXNlIHRvSlNPTlZhbHVlIGFuZCB0aGUgZ2l2ZW4gZmFjdG9yeSB0byBwcm9kdWNlXG4vLyBhIGNsb25lLCBidXQgeW91IG1heSBzcGVjaWZ5IGEgbWV0aG9kIGNsb25lKCkgdGhhdCB3aWxsIGJlXG4vLyB1c2VkIGluc3RlYWQuXG4vLyBTaW1pbGFybHksIEVKU09OLmVxdWFscyB3aWxsIHVzZSB0b0pTT05WYWx1ZSB0byBtYWtlIGNvbXBhcmlzb25zLFxuLy8gYnV0IHlvdSBtYXkgcHJvdmlkZSBhIG1ldGhvZCBlcXVhbHMoKSBpbnN0ZWFkLlxuLyoqXG4gKiBAc3VtbWFyeSBBZGQgYSBjdXN0b20gZGF0YXR5cGUgdG8gRUpTT04uXG4gKiBAbG9jdXMgQW55d2hlcmVcbiAqIEBwYXJhbSB7U3RyaW5nfSBuYW1lIEEgdGFnIGZvciB5b3VyIGN1c3RvbSB0eXBlOyBtdXN0IGJlIHVuaXF1ZSBhbW9uZ1xuICogICAgICAgICAgICAgICAgICAgICAgY3VzdG9tIGRhdGEgdHlwZXMgZGVmaW5lZCBpbiB5b3VyIHByb2plY3QsIGFuZCBtdXN0XG4gKiAgICAgICAgICAgICAgICAgICAgICBtYXRjaCB0aGUgcmVzdWx0IG9mIHlvdXIgdHlwZSdzIGB0eXBlTmFtZWAgbWV0aG9kLlxuICogQHBhcmFtIHtGdW5jdGlvbn0gZmFjdG9yeSBBIGZ1bmN0aW9uIHRoYXQgZGVzZXJpYWxpemVzIGEgSlNPTi1jb21wYXRpYmxlXG4gKiAgICAgICAgICAgICAgICAgICAgICAgICAgIHZhbHVlIGludG8gYW4gaW5zdGFuY2Ugb2YgeW91ciB0eXBlLiAgVGhpcyBzaG91bGRcbiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgbWF0Y2ggdGhlIHNlcmlhbGl6YXRpb24gcGVyZm9ybWVkIGJ5IHlvdXJcbiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgdHlwZSdzIGB0b0pTT05WYWx1ZWAgbWV0aG9kLlxuICovXG5FSlNPTi5hZGRUeXBlID0gKG5hbWUsIGZhY3RvcnkpID0+IHtcbiAgaWYgKGN1c3RvbVR5cGVzLmhhcyhuYW1lKSkge1xuICAgIHRocm93IG5ldyBFcnJvcihgVHlwZSAke25hbWV9IGFscmVhZHkgcHJlc2VudGApO1xuICB9XG4gIGN1c3RvbVR5cGVzLnNldChuYW1lLCBmYWN0b3J5KTtcbn07XG5cbmNvbnN0IGJ1aWx0aW5Db252ZXJ0ZXJzID0gW1xuICB7IC8vIERhdGVcbiAgICBtYXRjaEpTT05WYWx1ZShvYmopIHtcbiAgICAgIHJldHVybiBoYXNPd24ob2JqLCAnJGRhdGUnKSAmJiBsZW5ndGhPZihvYmopID09PSAxO1xuICAgIH0sXG4gICAgbWF0Y2hPYmplY3Qob2JqKSB7XG4gICAgICByZXR1cm4gb2JqIGluc3RhbmNlb2YgRGF0ZTtcbiAgICB9LFxuICAgIHRvSlNPTlZhbHVlKG9iaikge1xuICAgICAgcmV0dXJuIHskZGF0ZTogb2JqLmdldFRpbWUoKX07XG4gICAgfSxcbiAgICBmcm9tSlNPTlZhbHVlKG9iaikge1xuICAgICAgcmV0dXJuIG5ldyBEYXRlKG9iai4kZGF0ZSk7XG4gICAgfSxcbiAgfSxcbiAgeyAvLyBSZWdFeHBcbiAgICBtYXRjaEpTT05WYWx1ZShvYmopIHtcbiAgICAgIHJldHVybiBoYXNPd24ob2JqLCAnJHJlZ2V4cCcpXG4gICAgICAgICYmIGhhc093bihvYmosICckZmxhZ3MnKVxuICAgICAgICAmJiBsZW5ndGhPZihvYmopID09PSAyO1xuICAgIH0sXG4gICAgbWF0Y2hPYmplY3Qob2JqKSB7XG4gICAgICByZXR1cm4gb2JqIGluc3RhbmNlb2YgUmVnRXhwO1xuICAgIH0sXG4gICAgdG9KU09OVmFsdWUocmVnZXhwKSB7XG4gICAgICByZXR1cm4ge1xuICAgICAgICAkcmVnZXhwOiByZWdleHAuc291cmNlLFxuICAgICAgICAkZmxhZ3M6IHJlZ2V4cC5mbGFnc1xuICAgICAgfTtcbiAgICB9LFxuICAgIGZyb21KU09OVmFsdWUob2JqKSB7XG4gICAgICAvLyBSZXBsYWNlcyBkdXBsaWNhdGUgLyBpbnZhbGlkIGZsYWdzLlxuICAgICAgcmV0dXJuIG5ldyBSZWdFeHAoXG4gICAgICAgIG9iai4kcmVnZXhwLFxuICAgICAgICBvYmouJGZsYWdzXG4gICAgICAgICAgLy8gQ3V0IG9mZiBmbGFncyBhdCA1MCBjaGFycyB0byBhdm9pZCBhYnVzaW5nIFJlZ0V4cCBmb3IgRE9TLlxuICAgICAgICAgIC5zbGljZSgwLCA1MClcbiAgICAgICAgICAucmVwbGFjZSgvW15naW11eV0vZywnJylcbiAgICAgICAgICAucmVwbGFjZSgvKC4pKD89LipcXDEpL2csICcnKVxuICAgICAgKTtcbiAgICB9LFxuICB9LFxuICB7IC8vIE5hTiwgSW5mLCAtSW5mLiAoVGhlc2UgYXJlIHRoZSBvbmx5IG9iamVjdHMgd2l0aCB0eXBlb2YgIT09ICdvYmplY3QnXG4gICAgLy8gd2hpY2ggd2UgbWF0Y2guKVxuICAgIG1hdGNoSlNPTlZhbHVlKG9iaikge1xuICAgICAgcmV0dXJuIGhhc093bihvYmosICckSW5mTmFOJykgJiYgbGVuZ3RoT2Yob2JqKSA9PT0gMTtcbiAgICB9LFxuICAgIG1hdGNoT2JqZWN0OiBpc0luZk9yTmFOLFxuICAgIHRvSlNPTlZhbHVlKG9iaikge1xuICAgICAgbGV0IHNpZ247XG4gICAgICBpZiAoTnVtYmVyLmlzTmFOKG9iaikpIHtcbiAgICAgICAgc2lnbiA9IDA7XG4gICAgICB9IGVsc2UgaWYgKG9iaiA9PT0gSW5maW5pdHkpIHtcbiAgICAgICAgc2lnbiA9IDE7XG4gICAgICB9IGVsc2Uge1xuICAgICAgICBzaWduID0gLTE7XG4gICAgICB9XG4gICAgICByZXR1cm4geyRJbmZOYU46IHNpZ259O1xuICAgIH0sXG4gICAgZnJvbUpTT05WYWx1ZShvYmopIHtcbiAgICAgIHJldHVybiBvYmouJEluZk5hTiAvIDA7XG4gICAgfSxcbiAgfSxcbiAgeyAvLyBCaW5hcnlcbiAgICBtYXRjaEpTT05WYWx1ZShvYmopIHtcbiAgICAgIHJldHVybiBoYXNPd24ob2JqLCAnJGJpbmFyeScpICYmIGxlbmd0aE9mKG9iaikgPT09IDE7XG4gICAgfSxcbiAgICBtYXRjaE9iamVjdChvYmopIHtcbiAgICAgIHJldHVybiB0eXBlb2YgVWludDhBcnJheSAhPT0gJ3VuZGVmaW5lZCcgJiYgb2JqIGluc3RhbmNlb2YgVWludDhBcnJheVxuICAgICAgICB8fCAob2JqICYmIGhhc093bihvYmosICckVWludDhBcnJheVBvbHlmaWxsJykpO1xuICAgIH0sXG4gICAgdG9KU09OVmFsdWUob2JqKSB7XG4gICAgICByZXR1cm4geyRiaW5hcnk6IEJhc2U2NC5lbmNvZGUob2JqKX07XG4gICAgfSxcbiAgICBmcm9tSlNPTlZhbHVlKG9iaikge1xuICAgICAgcmV0dXJuIEJhc2U2NC5kZWNvZGUob2JqLiRiaW5hcnkpO1xuICAgIH0sXG4gIH0sXG4gIHsgLy8gRXNjYXBpbmcgb25lIGxldmVsXG4gICAgbWF0Y2hKU09OVmFsdWUob2JqKSB7XG4gICAgICByZXR1cm4gaGFzT3duKG9iaiwgJyRlc2NhcGUnKSAmJiBsZW5ndGhPZihvYmopID09PSAxO1xuICAgIH0sXG4gICAgbWF0Y2hPYmplY3Qob2JqKSB7XG4gICAgICBsZXQgbWF0Y2ggPSBmYWxzZTtcbiAgICAgIGlmIChvYmopIHtcbiAgICAgICAgY29uc3Qga2V5Q291bnQgPSBsZW5ndGhPZihvYmopO1xuICAgICAgICBpZiAoa2V5Q291bnQgPT09IDEgfHwga2V5Q291bnQgPT09IDIpIHtcbiAgICAgICAgICBtYXRjaCA9XG4gICAgICAgICAgICBidWlsdGluQ29udmVydGVycy5zb21lKGNvbnZlcnRlciA9PiBjb252ZXJ0ZXIubWF0Y2hKU09OVmFsdWUob2JqKSk7XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICAgIHJldHVybiBtYXRjaDtcbiAgICB9LFxuICAgIHRvSlNPTlZhbHVlKG9iaikge1xuICAgICAgY29uc3QgbmV3T2JqID0ge307XG4gICAgICBrZXlzT2Yob2JqKS5mb3JFYWNoKGtleSA9PiB7XG4gICAgICAgIG5ld09ialtrZXldID0gRUpTT04udG9KU09OVmFsdWUob2JqW2tleV0pO1xuICAgICAgfSk7XG4gICAgICByZXR1cm4geyRlc2NhcGU6IG5ld09ian07XG4gICAgfSxcbiAgICBmcm9tSlNPTlZhbHVlKG9iaikge1xuICAgICAgY29uc3QgbmV3T2JqID0ge307XG4gICAgICBrZXlzT2Yob2JqLiRlc2NhcGUpLmZvckVhY2goa2V5ID0+IHtcbiAgICAgICAgbmV3T2JqW2tleV0gPSBFSlNPTi5mcm9tSlNPTlZhbHVlKG9iai4kZXNjYXBlW2tleV0pO1xuICAgICAgfSk7XG4gICAgICByZXR1cm4gbmV3T2JqO1xuICAgIH0sXG4gIH0sXG4gIHsgLy8gQ3VzdG9tXG4gICAgbWF0Y2hKU09OVmFsdWUob2JqKSB7XG4gICAgICByZXR1cm4gaGFzT3duKG9iaiwgJyR0eXBlJylcbiAgICAgICAgJiYgaGFzT3duKG9iaiwgJyR2YWx1ZScpICYmIGxlbmd0aE9mKG9iaikgPT09IDI7XG4gICAgfSxcbiAgICBtYXRjaE9iamVjdChvYmopIHtcbiAgICAgIHJldHVybiBFSlNPTi5faXNDdXN0b21UeXBlKG9iaik7XG4gICAgfSxcbiAgICB0b0pTT05WYWx1ZShvYmopIHtcbiAgICAgIGNvbnN0IGpzb25WYWx1ZSA9IE1ldGVvci5fbm9ZaWVsZHNBbGxvd2VkKCgpID0+IG9iai50b0pTT05WYWx1ZSgpKTtcbiAgICAgIHJldHVybiB7JHR5cGU6IG9iai50eXBlTmFtZSgpLCAkdmFsdWU6IGpzb25WYWx1ZX07XG4gICAgfSxcbiAgICBmcm9tSlNPTlZhbHVlKG9iaikge1xuICAgICAgY29uc3QgdHlwZU5hbWUgPSBvYmouJHR5cGU7XG4gICAgICBpZiAoIWN1c3RvbVR5cGVzLmhhcyh0eXBlTmFtZSkpIHtcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKGBDdXN0b20gRUpTT04gdHlwZSAke3R5cGVOYW1lfSBpcyBub3QgZGVmaW5lZGApO1xuICAgICAgfVxuICAgICAgY29uc3QgY29udmVydGVyID0gY3VzdG9tVHlwZXMuZ2V0KHR5cGVOYW1lKTtcbiAgICAgIHJldHVybiBNZXRlb3IuX25vWWllbGRzQWxsb3dlZCgoKSA9PiBjb252ZXJ0ZXIob2JqLiR2YWx1ZSkpO1xuICAgIH0sXG4gIH0sXG5dO1xuXG5FSlNPTi5faXNDdXN0b21UeXBlID0gKG9iaikgPT4gKFxuICBvYmogJiZcbiAgaXNGdW5jdGlvbihvYmoudG9KU09OVmFsdWUpICYmXG4gIGlzRnVuY3Rpb24ob2JqLnR5cGVOYW1lKSAmJlxuICBjdXN0b21UeXBlcy5oYXMob2JqLnR5cGVOYW1lKCkpXG4pO1xuXG5FSlNPTi5fZ2V0VHlwZXMgPSAoaXNPcmlnaW5hbCA9IGZhbHNlKSA9PiAoaXNPcmlnaW5hbCA/IGN1c3RvbVR5cGVzIDogY29udmVydE1hcFRvT2JqZWN0KGN1c3RvbVR5cGVzKSk7XG5cbkVKU09OLl9nZXRDb252ZXJ0ZXJzID0gKCkgPT4gYnVpbHRpbkNvbnZlcnRlcnM7XG5cbi8vIEVpdGhlciByZXR1cm4gdGhlIEpTT04tY29tcGF0aWJsZSB2ZXJzaW9uIG9mIHRoZSBhcmd1bWVudCwgb3IgdW5kZWZpbmVkIChpZlxuLy8gdGhlIGl0ZW0gaXNuJ3QgaXRzZWxmIHJlcGxhY2VhYmxlLCBidXQgbWF5YmUgc29tZSBmaWVsZHMgaW4gaXQgYXJlKVxuY29uc3QgdG9KU09OVmFsdWVIZWxwZXIgPSBpdGVtID0+IHtcbiAgZm9yIChsZXQgaSA9IDA7IGkgPCBidWlsdGluQ29udmVydGVycy5sZW5ndGg7IGkrKykge1xuICAgIGNvbnN0IGNvbnZlcnRlciA9IGJ1aWx0aW5Db252ZXJ0ZXJzW2ldO1xuICAgIGlmIChjb252ZXJ0ZXIubWF0Y2hPYmplY3QoaXRlbSkpIHtcbiAgICAgIHJldHVybiBjb252ZXJ0ZXIudG9KU09OVmFsdWUoaXRlbSk7XG4gICAgfVxuICB9XG4gIHJldHVybiB1bmRlZmluZWQ7XG59O1xuXG4vLyBmb3IgYm90aCBhcnJheXMgYW5kIG9iamVjdHMsIGluLXBsYWNlIG1vZGlmaWNhdGlvbi5cbmNvbnN0IGFkanVzdFR5cGVzVG9KU09OVmFsdWUgPSBvYmogPT4ge1xuICAvLyBJcyBpdCBhbiBhdG9tIHRoYXQgd2UgbmVlZCB0byBhZGp1c3Q/XG4gIGlmIChvYmogPT09IG51bGwpIHtcbiAgICByZXR1cm4gbnVsbDtcbiAgfVxuXG4gIGNvbnN0IG1heWJlQ2hhbmdlZCA9IHRvSlNPTlZhbHVlSGVscGVyKG9iaik7XG4gIGlmIChtYXliZUNoYW5nZWQgIT09IHVuZGVmaW5lZCkge1xuICAgIHJldHVybiBtYXliZUNoYW5nZWQ7XG4gIH1cblxuICAvLyBPdGhlciBhdG9tcyBhcmUgdW5jaGFuZ2VkLlxuICBpZiAoIWlzT2JqZWN0KG9iaikpIHtcbiAgICByZXR1cm4gb2JqO1xuICB9XG5cbiAgLy8gSXRlcmF0ZSBvdmVyIGFycmF5IG9yIG9iamVjdCBzdHJ1Y3R1cmUuXG4gIGtleXNPZihvYmopLmZvckVhY2goa2V5ID0+IHtcbiAgICBjb25zdCB2YWx1ZSA9IG9ialtrZXldO1xuICAgIGlmICghaXNPYmplY3QodmFsdWUpICYmIHZhbHVlICE9PSB1bmRlZmluZWQgJiZcbiAgICAgICAgIWlzSW5mT3JOYU4odmFsdWUpKSB7XG4gICAgICByZXR1cm47IC8vIGNvbnRpbnVlXG4gICAgfVxuXG4gICAgY29uc3QgY2hhbmdlZCA9IHRvSlNPTlZhbHVlSGVscGVyKHZhbHVlKTtcbiAgICBpZiAoY2hhbmdlZCkge1xuICAgICAgb2JqW2tleV0gPSBjaGFuZ2VkO1xuICAgICAgcmV0dXJuOyAvLyBvbiB0byB0aGUgbmV4dCBrZXlcbiAgICB9XG4gICAgLy8gaWYgd2UgZ2V0IGhlcmUsIHZhbHVlIGlzIGFuIG9iamVjdCBidXQgbm90IGFkanVzdGFibGVcbiAgICAvLyBhdCB0aGlzIGxldmVsLiAgcmVjdXJzZS5cbiAgICBhZGp1c3RUeXBlc1RvSlNPTlZhbHVlKHZhbHVlKTtcbiAgfSk7XG4gIHJldHVybiBvYmo7XG59O1xuXG5FSlNPTi5fYWRqdXN0VHlwZXNUb0pTT05WYWx1ZSA9IGFkanVzdFR5cGVzVG9KU09OVmFsdWU7XG5cbi8qKlxuICogQHN1bW1hcnkgU2VyaWFsaXplIGFuIEVKU09OLWNvbXBhdGlibGUgdmFsdWUgaW50byBpdHMgcGxhaW4gSlNPTlxuICogICAgICAgICAgcmVwcmVzZW50YXRpb24uXG4gKiBAbG9jdXMgQW55d2hlcmVcbiAqIEBwYXJhbSB7RUpTT059IHZhbCBBIHZhbHVlIHRvIHNlcmlhbGl6ZSB0byBwbGFpbiBKU09OLlxuICovXG5FSlNPTi50b0pTT05WYWx1ZSA9IGl0ZW0gPT4ge1xuICBjb25zdCBjaGFuZ2VkID0gdG9KU09OVmFsdWVIZWxwZXIoaXRlbSk7XG4gIGlmIChjaGFuZ2VkICE9PSB1bmRlZmluZWQpIHtcbiAgICByZXR1cm4gY2hhbmdlZDtcbiAgfVxuXG4gIGxldCBuZXdJdGVtID0gaXRlbTtcbiAgaWYgKGlzT2JqZWN0KGl0ZW0pKSB7XG4gICAgbmV3SXRlbSA9IEVKU09OLmNsb25lKGl0ZW0pO1xuICAgIGFkanVzdFR5cGVzVG9KU09OVmFsdWUobmV3SXRlbSk7XG4gIH1cbiAgcmV0dXJuIG5ld0l0ZW07XG59O1xuXG4vLyBFaXRoZXIgcmV0dXJuIHRoZSBhcmd1bWVudCBjaGFuZ2VkIHRvIGhhdmUgdGhlIG5vbi1qc29uXG4vLyByZXAgb2YgaXRzZWxmICh0aGUgT2JqZWN0IHZlcnNpb24pIG9yIHRoZSBhcmd1bWVudCBpdHNlbGYuXG4vLyBET0VTIE5PVCBSRUNVUlNFLiAgRm9yIGFjdHVhbGx5IGdldHRpbmcgdGhlIGZ1bGx5LWNoYW5nZWQgdmFsdWUsIHVzZVxuLy8gRUpTT04uZnJvbUpTT05WYWx1ZVxuY29uc3QgZnJvbUpTT05WYWx1ZUhlbHBlciA9IHZhbHVlID0+IHtcbiAgaWYgKGlzT2JqZWN0KHZhbHVlKSAmJiB2YWx1ZSAhPT0gbnVsbCkge1xuICAgIGNvbnN0IGtleXMgPSBrZXlzT2YodmFsdWUpO1xuICAgIGlmIChrZXlzLmxlbmd0aCA8PSAyXG4gICAgICAgICYmIGtleXMuZXZlcnkoayA9PiB0eXBlb2YgayA9PT0gJ3N0cmluZycgJiYgay5zdWJzdHIoMCwgMSkgPT09ICckJykpIHtcbiAgICAgIGZvciAobGV0IGkgPSAwOyBpIDwgYnVpbHRpbkNvbnZlcnRlcnMubGVuZ3RoOyBpKyspIHtcbiAgICAgICAgY29uc3QgY29udmVydGVyID0gYnVpbHRpbkNvbnZlcnRlcnNbaV07XG4gICAgICAgIGlmIChjb252ZXJ0ZXIubWF0Y2hKU09OVmFsdWUodmFsdWUpKSB7XG4gICAgICAgICAgcmV0dXJuIGNvbnZlcnRlci5mcm9tSlNPTlZhbHVlKHZhbHVlKTtcbiAgICAgICAgfVxuICAgICAgfVxuICAgIH1cbiAgfVxuICByZXR1cm4gdmFsdWU7XG59O1xuXG4vLyBmb3IgYm90aCBhcnJheXMgYW5kIG9iamVjdHMuIFRyaWVzIGl0cyBiZXN0IHRvIGp1c3Rcbi8vIHVzZSB0aGUgb2JqZWN0IHlvdSBoYW5kIGl0LCBidXQgbWF5IHJldHVybiBzb21ldGhpbmdcbi8vIGRpZmZlcmVudCBpZiB0aGUgb2JqZWN0IHlvdSBoYW5kIGl0IGl0c2VsZiBuZWVkcyBjaGFuZ2luZy5cbmNvbnN0IGFkanVzdFR5cGVzRnJvbUpTT05WYWx1ZSA9IG9iaiA9PiB7XG4gIGlmIChvYmogPT09IG51bGwpIHtcbiAgICByZXR1cm4gbnVsbDtcbiAgfVxuXG4gIGNvbnN0IG1heWJlQ2hhbmdlZCA9IGZyb21KU09OVmFsdWVIZWxwZXIob2JqKTtcbiAgaWYgKG1heWJlQ2hhbmdlZCAhPT0gb2JqKSB7XG4gICAgcmV0dXJuIG1heWJlQ2hhbmdlZDtcbiAgfVxuXG4gIC8vIE90aGVyIGF0b21zIGFyZSB1bmNoYW5nZWQuXG4gIGlmICghaXNPYmplY3Qob2JqKSkge1xuICAgIHJldHVybiBvYmo7XG4gIH1cblxuICBrZXlzT2Yob2JqKS5mb3JFYWNoKGtleSA9PiB7XG4gICAgY29uc3QgdmFsdWUgPSBvYmpba2V5XTtcbiAgICBpZiAoaXNPYmplY3QodmFsdWUpKSB7XG4gICAgICBjb25zdCBjaGFuZ2VkID0gZnJvbUpTT05WYWx1ZUhlbHBlcih2YWx1ZSk7XG4gICAgICBpZiAodmFsdWUgIT09IGNoYW5nZWQpIHtcbiAgICAgICAgb2JqW2tleV0gPSBjaGFuZ2VkO1xuICAgICAgICByZXR1cm47XG4gICAgICB9XG4gICAgICAvLyBpZiB3ZSBnZXQgaGVyZSwgdmFsdWUgaXMgYW4gb2JqZWN0IGJ1dCBub3QgYWRqdXN0YWJsZVxuICAgICAgLy8gYXQgdGhpcyBsZXZlbC4gIHJlY3Vyc2UuXG4gICAgICBhZGp1c3RUeXBlc0Zyb21KU09OVmFsdWUodmFsdWUpO1xuICAgIH1cbiAgfSk7XG4gIHJldHVybiBvYmo7XG59O1xuXG5FSlNPTi5fYWRqdXN0VHlwZXNGcm9tSlNPTlZhbHVlID0gYWRqdXN0VHlwZXNGcm9tSlNPTlZhbHVlO1xuXG4vKipcbiAqIEBzdW1tYXJ5IERlc2VyaWFsaXplIGFuIEVKU09OIHZhbHVlIGZyb20gaXRzIHBsYWluIEpTT04gcmVwcmVzZW50YXRpb24uXG4gKiBAbG9jdXMgQW55d2hlcmVcbiAqIEBwYXJhbSB7SlNPTkNvbXBhdGlibGV9IHZhbCBBIHZhbHVlIHRvIGRlc2VyaWFsaXplIGludG8gRUpTT04uXG4gKi9cbkVKU09OLmZyb21KU09OVmFsdWUgPSBpdGVtID0+IHtcbiAgbGV0IGNoYW5nZWQgPSBmcm9tSlNPTlZhbHVlSGVscGVyKGl0ZW0pO1xuICBpZiAoY2hhbmdlZCA9PT0gaXRlbSAmJiBpc09iamVjdChpdGVtKSkge1xuICAgIGNoYW5nZWQgPSBFSlNPTi5jbG9uZShpdGVtKTtcbiAgICBhZGp1c3RUeXBlc0Zyb21KU09OVmFsdWUoY2hhbmdlZCk7XG4gIH1cbiAgcmV0dXJuIGNoYW5nZWQ7XG59O1xuXG4vKipcbiAqIEBzdW1tYXJ5IFNlcmlhbGl6ZSBhIHZhbHVlIHRvIGEgc3RyaW5nLiBGb3IgRUpTT04gdmFsdWVzLCB0aGUgc2VyaWFsaXphdGlvblxuICogICAgICAgICAgZnVsbHkgcmVwcmVzZW50cyB0aGUgdmFsdWUuIEZvciBub24tRUpTT04gdmFsdWVzLCBzZXJpYWxpemVzIHRoZVxuICogICAgICAgICAgc2FtZSB3YXkgYXMgYEpTT04uc3RyaW5naWZ5YC5cbiAqIEBsb2N1cyBBbnl3aGVyZVxuICogQHBhcmFtIHtFSlNPTn0gdmFsIEEgdmFsdWUgdG8gc3RyaW5naWZ5LlxuICogQHBhcmFtIHtPYmplY3R9IFtvcHRpb25zXVxuICogQHBhcmFtIHtCb29sZWFuIHwgSW50ZWdlciB8IFN0cmluZ30gb3B0aW9ucy5pbmRlbnQgSW5kZW50cyBvYmplY3RzIGFuZFxuICogYXJyYXlzIGZvciBlYXN5IHJlYWRhYmlsaXR5LiAgV2hlbiBgdHJ1ZWAsIGluZGVudHMgYnkgMiBzcGFjZXM7IHdoZW4gYW5cbiAqIGludGVnZXIsIGluZGVudHMgYnkgdGhhdCBudW1iZXIgb2Ygc3BhY2VzOyBhbmQgd2hlbiBhIHN0cmluZywgdXNlcyB0aGVcbiAqIHN0cmluZyBhcyB0aGUgaW5kZW50YXRpb24gcGF0dGVybi5cbiAqIEBwYXJhbSB7Qm9vbGVhbn0gb3B0aW9ucy5jYW5vbmljYWwgV2hlbiBgdHJ1ZWAsIHN0cmluZ2lmaWVzIGtleXMgaW4gYW5cbiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgb2JqZWN0IGluIHNvcnRlZCBvcmRlci5cbiAqL1xuRUpTT04uc3RyaW5naWZ5ID0gaGFuZGxlRXJyb3IoKGl0ZW0sIG9wdGlvbnMpID0+IHtcbiAgbGV0IHNlcmlhbGl6ZWQ7XG4gIGNvbnN0IGpzb24gPSBFSlNPTi50b0pTT05WYWx1ZShpdGVtKTtcbiAgaWYgKG9wdGlvbnMgJiYgKG9wdGlvbnMuY2Fub25pY2FsIHx8IG9wdGlvbnMuaW5kZW50KSkge1xuICAgIGltcG9ydCBjYW5vbmljYWxTdHJpbmdpZnkgZnJvbSAnLi9zdHJpbmdpZnknO1xuICAgIHNlcmlhbGl6ZWQgPSBjYW5vbmljYWxTdHJpbmdpZnkoanNvbiwgb3B0aW9ucyk7XG4gIH0gZWxzZSB7XG4gICAgc2VyaWFsaXplZCA9IEpTT04uc3RyaW5naWZ5KGpzb24pO1xuICB9XG4gIHJldHVybiBzZXJpYWxpemVkO1xufSk7XG5cbi8qKlxuICogQHN1bW1hcnkgUGFyc2UgYSBzdHJpbmcgaW50byBhbiBFSlNPTiB2YWx1ZS4gVGhyb3dzIGFuIGVycm9yIGlmIHRoZSBzdHJpbmdcbiAqICAgICAgICAgIGlzIG5vdCB2YWxpZCBFSlNPTi5cbiAqIEBsb2N1cyBBbnl3aGVyZVxuICogQHBhcmFtIHtTdHJpbmd9IHN0ciBBIHN0cmluZyB0byBwYXJzZSBpbnRvIGFuIEVKU09OIHZhbHVlLlxuICovXG5FSlNPTi5wYXJzZSA9IGl0ZW0gPT4ge1xuICBpZiAodHlwZW9mIGl0ZW0gIT09ICdzdHJpbmcnKSB7XG4gICAgdGhyb3cgbmV3IEVycm9yKCdFSlNPTi5wYXJzZSBhcmd1bWVudCBzaG91bGQgYmUgYSBzdHJpbmcnKTtcbiAgfVxuICByZXR1cm4gRUpTT04uZnJvbUpTT05WYWx1ZShKU09OLnBhcnNlKGl0ZW0pKTtcbn07XG5cbi8qKlxuICogQHN1bW1hcnkgUmV0dXJucyB0cnVlIGlmIGB4YCBpcyBhIGJ1ZmZlciBvZiBiaW5hcnkgZGF0YSwgYXMgcmV0dXJuZWQgZnJvbVxuICogICAgICAgICAgW2BFSlNPTi5uZXdCaW5hcnlgXSgjZWpzb25fbmV3X2JpbmFyeSkuXG4gKiBAcGFyYW0ge09iamVjdH0geCBUaGUgdmFyaWFibGUgdG8gY2hlY2suXG4gKiBAbG9jdXMgQW55d2hlcmVcbiAqL1xuRUpTT04uaXNCaW5hcnkgPSBvYmogPT4ge1xuICByZXR1cm4gISEoKHR5cGVvZiBVaW50OEFycmF5ICE9PSAndW5kZWZpbmVkJyAmJiBvYmogaW5zdGFuY2VvZiBVaW50OEFycmF5KSB8fFxuICAgIChvYmogJiYgb2JqLiRVaW50OEFycmF5UG9seWZpbGwpKTtcbn07XG5cbi8qKlxuICogQHN1bW1hcnkgUmV0dXJuIHRydWUgaWYgYGFgIGFuZCBgYmAgYXJlIGVxdWFsIHRvIGVhY2ggb3RoZXIuICBSZXR1cm4gZmFsc2VcbiAqICAgICAgICAgIG90aGVyd2lzZS4gIFVzZXMgdGhlIGBlcXVhbHNgIG1ldGhvZCBvbiBgYWAgaWYgcHJlc2VudCwgb3RoZXJ3aXNlXG4gKiAgICAgICAgICBwZXJmb3JtcyBhIGRlZXAgY29tcGFyaXNvbi5cbiAqIEBsb2N1cyBBbnl3aGVyZVxuICogQHBhcmFtIHtFSlNPTn0gYVxuICogQHBhcmFtIHtFSlNPTn0gYlxuICogQHBhcmFtIHtPYmplY3R9IFtvcHRpb25zXVxuICogQHBhcmFtIHtCb29sZWFufSBvcHRpb25zLmtleU9yZGVyU2Vuc2l0aXZlIENvbXBhcmUgaW4ga2V5IHNlbnNpdGl2ZSBvcmRlcixcbiAqIGlmIHN1cHBvcnRlZCBieSB0aGUgSmF2YVNjcmlwdCBpbXBsZW1lbnRhdGlvbi4gIEZvciBleGFtcGxlLCBge2E6IDEsIGI6IDJ9YFxuICogaXMgZXF1YWwgdG8gYHtiOiAyLCBhOiAxfWAgb25seSB3aGVuIGBrZXlPcmRlclNlbnNpdGl2ZWAgaXMgYGZhbHNlYC4gIFRoZVxuICogZGVmYXVsdCBpcyBgZmFsc2VgLlxuICovXG5FSlNPTi5lcXVhbHMgPSAoYSwgYiwgb3B0aW9ucykgPT4ge1xuICBsZXQgaTtcbiAgY29uc3Qga2V5T3JkZXJTZW5zaXRpdmUgPSAhIShvcHRpb25zICYmIG9wdGlvbnMua2V5T3JkZXJTZW5zaXRpdmUpO1xuICBpZiAoYSA9PT0gYikge1xuICAgIHJldHVybiB0cnVlO1xuICB9XG5cbiAgLy8gVGhpcyBkaWZmZXJzIGZyb20gdGhlIElFRUUgc3BlYyBmb3IgTmFOIGVxdWFsaXR5LCBiL2Mgd2UgZG9uJ3Qgd2FudFxuICAvLyBhbnl0aGluZyBldmVyIHdpdGggYSBOYU4gdG8gYmUgcG9pc29uZWQgZnJvbSBiZWNvbWluZyBlcXVhbCB0byBhbnl0aGluZy5cbiAgaWYgKE51bWJlci5pc05hTihhKSAmJiBOdW1iZXIuaXNOYU4oYikpIHtcbiAgICByZXR1cm4gdHJ1ZTtcbiAgfVxuXG4gIC8vIGlmIGVpdGhlciBvbmUgaXMgZmFsc3ksIHRoZXknZCBoYXZlIHRvIGJlID09PSB0byBiZSBlcXVhbFxuICBpZiAoIWEgfHwgIWIpIHtcbiAgICByZXR1cm4gZmFsc2U7XG4gIH1cblxuICBpZiAoIShpc09iamVjdChhKSAmJiBpc09iamVjdChiKSkpIHtcbiAgICByZXR1cm4gZmFsc2U7XG4gIH1cblxuICBpZiAoYSBpbnN0YW5jZW9mIERhdGUgJiYgYiBpbnN0YW5jZW9mIERhdGUpIHtcbiAgICByZXR1cm4gYS52YWx1ZU9mKCkgPT09IGIudmFsdWVPZigpO1xuICB9XG5cbiAgaWYgKEVKU09OLmlzQmluYXJ5KGEpICYmIEVKU09OLmlzQmluYXJ5KGIpKSB7XG4gICAgaWYgKGEubGVuZ3RoICE9PSBiLmxlbmd0aCkge1xuICAgICAgcmV0dXJuIGZhbHNlO1xuICAgIH1cbiAgICBmb3IgKGkgPSAwOyBpIDwgYS5sZW5ndGg7IGkrKykge1xuICAgICAgaWYgKGFbaV0gIT09IGJbaV0pIHtcbiAgICAgICAgcmV0dXJuIGZhbHNlO1xuICAgICAgfVxuICAgIH1cbiAgICByZXR1cm4gdHJ1ZTtcbiAgfVxuXG4gIGlmIChpc0Z1bmN0aW9uKGEuZXF1YWxzKSkge1xuICAgIHJldHVybiBhLmVxdWFscyhiLCBvcHRpb25zKTtcbiAgfVxuXG4gIGlmIChpc0Z1bmN0aW9uKGIuZXF1YWxzKSkge1xuICAgIHJldHVybiBiLmVxdWFscyhhLCBvcHRpb25zKTtcbiAgfVxuXG4gIC8vIEFycmF5LmlzQXJyYXkgd29ya3MgYWNyb3NzIGlmcmFtZXMgd2hpbGUgaW5zdGFuY2VvZiB3b24ndFxuICBjb25zdCBhSXNBcnJheSA9IEFycmF5LmlzQXJyYXkoYSk7XG4gIGNvbnN0IGJJc0FycmF5ID0gQXJyYXkuaXNBcnJheShiKTtcblxuICAvLyBpZiBub3QgYm90aCBvciBub25lIGFyZSBhcnJheSB0aGV5IGFyZSBub3QgZXF1YWxcbiAgaWYgKGFJc0FycmF5ICE9PSBiSXNBcnJheSkge1xuICAgIHJldHVybiBmYWxzZTtcbiAgfVxuXG4gIGlmIChhSXNBcnJheSAmJiBiSXNBcnJheSkge1xuICAgIGlmIChhLmxlbmd0aCAhPT0gYi5sZW5ndGgpIHtcbiAgICAgIHJldHVybiBmYWxzZTtcbiAgICB9XG4gICAgZm9yIChpID0gMDsgaSA8IGEubGVuZ3RoOyBpKyspIHtcbiAgICAgIGlmICghRUpTT04uZXF1YWxzKGFbaV0sIGJbaV0sIG9wdGlvbnMpKSB7XG4gICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgIH1cbiAgICB9XG4gICAgcmV0dXJuIHRydWU7XG4gIH1cblxuICAvLyBmYWxsYmFjayBmb3IgY3VzdG9tIHR5cGVzIHRoYXQgZG9uJ3QgaW1wbGVtZW50IHRoZWlyIG93biBlcXVhbHNcbiAgc3dpdGNoIChFSlNPTi5faXNDdXN0b21UeXBlKGEpICsgRUpTT04uX2lzQ3VzdG9tVHlwZShiKSkge1xuICAgIGNhc2UgMTogcmV0dXJuIGZhbHNlO1xuICAgIGNhc2UgMjogcmV0dXJuIEVKU09OLmVxdWFscyhFSlNPTi50b0pTT05WYWx1ZShhKSwgRUpTT04udG9KU09OVmFsdWUoYikpO1xuICAgIGRlZmF1bHQ6IC8vIERvIG5vdGhpbmdcbiAgfVxuXG4gIC8vIGZhbGwgYmFjayB0byBzdHJ1Y3R1cmFsIGVxdWFsaXR5IG9mIG9iamVjdHNcbiAgbGV0IHJldDtcbiAgY29uc3QgYUtleXMgPSBrZXlzT2YoYSk7XG4gIGNvbnN0IGJLZXlzID0ga2V5c09mKGIpO1xuICBpZiAoa2V5T3JkZXJTZW5zaXRpdmUpIHtcbiAgICBpID0gMDtcbiAgICByZXQgPSBhS2V5cy5ldmVyeShrZXkgPT4ge1xuICAgICAgaWYgKGkgPj0gYktleXMubGVuZ3RoKSB7XG4gICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgIH1cbiAgICAgIGlmIChrZXkgIT09IGJLZXlzW2ldKSB7XG4gICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgIH1cbiAgICAgIGlmICghRUpTT04uZXF1YWxzKGFba2V5XSwgYltiS2V5c1tpXV0sIG9wdGlvbnMpKSB7XG4gICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgIH1cbiAgICAgIGkrKztcbiAgICAgIHJldHVybiB0cnVlO1xuICAgIH0pO1xuICB9IGVsc2Uge1xuICAgIGkgPSAwO1xuICAgIHJldCA9IGFLZXlzLmV2ZXJ5KGtleSA9PiB7XG4gICAgICBpZiAoIWhhc093bihiLCBrZXkpKSB7XG4gICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgIH1cbiAgICAgIGlmICghRUpTT04uZXF1YWxzKGFba2V5XSwgYltrZXldLCBvcHRpb25zKSkge1xuICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICB9XG4gICAgICBpKys7XG4gICAgICByZXR1cm4gdHJ1ZTtcbiAgICB9KTtcbiAgfVxuICByZXR1cm4gcmV0ICYmIGkgPT09IGJLZXlzLmxlbmd0aDtcbn07XG5cbi8qKlxuICogQHN1bW1hcnkgUmV0dXJuIGEgZGVlcCBjb3B5IG9mIGB2YWxgLlxuICogQGxvY3VzIEFueXdoZXJlXG4gKiBAcGFyYW0ge0VKU09OfSB2YWwgQSB2YWx1ZSB0byBjb3B5LlxuICovXG5FSlNPTi5jbG9uZSA9IHYgPT4ge1xuICBsZXQgcmV0O1xuICBpZiAoIWlzT2JqZWN0KHYpKSB7XG4gICAgcmV0dXJuIHY7XG4gIH1cblxuICBpZiAodiA9PT0gbnVsbCkge1xuICAgIHJldHVybiBudWxsOyAvLyBudWxsIGhhcyB0eXBlb2YgXCJvYmplY3RcIlxuICB9XG5cbiAgaWYgKHYgaW5zdGFuY2VvZiBEYXRlKSB7XG4gICAgcmV0dXJuIG5ldyBEYXRlKHYuZ2V0VGltZSgpKTtcbiAgfVxuXG4gIC8vIFJlZ0V4cHMgYXJlIG5vdCByZWFsbHkgRUpTT04gZWxlbWVudHMgKGVnIHdlIGRvbid0IGRlZmluZSBhIHNlcmlhbGl6YXRpb25cbiAgLy8gZm9yIHRoZW0pLCBidXQgdGhleSdyZSBpbW11dGFibGUgYW55d2F5LCBzbyB3ZSBjYW4gc3VwcG9ydCB0aGVtIGluIGNsb25lLlxuICBpZiAodiBpbnN0YW5jZW9mIFJlZ0V4cCkge1xuICAgIHJldHVybiB2O1xuICB9XG5cbiAgaWYgKEVKU09OLmlzQmluYXJ5KHYpKSB7XG4gICAgcmV0ID0gRUpTT04ubmV3QmluYXJ5KHYubGVuZ3RoKTtcbiAgICBmb3IgKGxldCBpID0gMDsgaSA8IHYubGVuZ3RoOyBpKyspIHtcbiAgICAgIHJldFtpXSA9IHZbaV07XG4gICAgfVxuICAgIHJldHVybiByZXQ7XG4gIH1cblxuICBpZiAoQXJyYXkuaXNBcnJheSh2KSkge1xuICAgIHJldHVybiB2Lm1hcChFSlNPTi5jbG9uZSk7XG4gIH1cblxuICBpZiAoaXNBcmd1bWVudHModikpIHtcbiAgICByZXR1cm4gQXJyYXkuZnJvbSh2KS5tYXAoRUpTT04uY2xvbmUpO1xuICB9XG5cbiAgLy8gaGFuZGxlIGdlbmVyYWwgdXNlci1kZWZpbmVkIHR5cGVkIE9iamVjdHMgaWYgdGhleSBoYXZlIGEgY2xvbmUgbWV0aG9kXG4gIGlmIChpc0Z1bmN0aW9uKHYuY2xvbmUpKSB7XG4gICAgcmV0dXJuIHYuY2xvbmUoKTtcbiAgfVxuXG4gIC8vIGhhbmRsZSBvdGhlciBjdXN0b20gdHlwZXNcbiAgaWYgKEVKU09OLl9pc0N1c3RvbVR5cGUodikpIHtcbiAgICByZXR1cm4gRUpTT04uZnJvbUpTT05WYWx1ZShFSlNPTi5jbG9uZShFSlNPTi50b0pTT05WYWx1ZSh2KSksIHRydWUpO1xuICB9XG5cbiAgLy8gaGFuZGxlIG90aGVyIG9iamVjdHNcbiAgcmV0ID0ge307XG4gIGtleXNPZih2KS5mb3JFYWNoKChrZXkpID0+IHtcbiAgICByZXRba2V5XSA9IEVKU09OLmNsb25lKHZba2V5XSk7XG4gIH0pO1xuICByZXR1cm4gcmV0O1xufTtcblxuLyoqXG4gKiBAc3VtbWFyeSBBbGxvY2F0ZSBhIG5ldyBidWZmZXIgb2YgYmluYXJ5IGRhdGEgdGhhdCBFSlNPTiBjYW4gc2VyaWFsaXplLlxuICogQGxvY3VzIEFueXdoZXJlXG4gKiBAcGFyYW0ge051bWJlcn0gc2l6ZSBUaGUgbnVtYmVyIG9mIGJ5dGVzIG9mIGJpbmFyeSBkYXRhIHRvIGFsbG9jYXRlLlxuICovXG4vLyBFSlNPTi5uZXdCaW5hcnkgaXMgdGhlIHB1YmxpYyBkb2N1bWVudGVkIEFQSSBmb3IgdGhpcyBmdW5jdGlvbmFsaXR5LFxuLy8gYnV0IHRoZSBpbXBsZW1lbnRhdGlvbiBpcyBpbiB0aGUgJ2Jhc2U2NCcgcGFja2FnZSB0byBhdm9pZFxuLy8gaW50cm9kdWNpbmcgYSBjaXJjdWxhciBkZXBlbmRlbmN5LiAoSWYgdGhlIGltcGxlbWVudGF0aW9uIHdlcmUgaGVyZSxcbi8vIHRoZW4gJ2Jhc2U2NCcgd291bGQgaGF2ZSB0byB1c2UgRUpTT04ubmV3QmluYXJ5LCBhbmQgJ2Vqc29uJyB3b3VsZFxuLy8gYWxzbyBoYXZlIHRvIHVzZSAnYmFzZTY0Jy4pXG5FSlNPTi5uZXdCaW5hcnkgPSBCYXNlNjQubmV3QmluYXJ5O1xuXG5leHBvcnQgeyBFSlNPTiB9O1xuIiwiLy8gQmFzZWQgb24ganNvbjIuanMgZnJvbSBodHRwczovL2dpdGh1Yi5jb20vZG91Z2xhc2Nyb2NrZm9yZC9KU09OLWpzXG4vL1xuLy8gICAganNvbjIuanNcbi8vICAgIDIwMTItMTAtMDhcbi8vXG4vLyAgICBQdWJsaWMgRG9tYWluLlxuLy9cbi8vICAgIE5PIFdBUlJBTlRZIEVYUFJFU1NFRCBPUiBJTVBMSUVELiBVU0UgQVQgWU9VUiBPV04gUklTSy5cblxuZnVuY3Rpb24gcXVvdGUoc3RyaW5nKSB7XG4gIHJldHVybiBKU09OLnN0cmluZ2lmeShzdHJpbmcpO1xufVxuXG5jb25zdCBzdHIgPSAoa2V5LCBob2xkZXIsIHNpbmdsZUluZGVudCwgb3V0ZXJJbmRlbnQsIGNhbm9uaWNhbCkgPT4ge1xuICBjb25zdCB2YWx1ZSA9IGhvbGRlcltrZXldO1xuXG4gIC8vIFdoYXQgaGFwcGVucyBuZXh0IGRlcGVuZHMgb24gdGhlIHZhbHVlJ3MgdHlwZS5cbiAgc3dpdGNoICh0eXBlb2YgdmFsdWUpIHtcbiAgY2FzZSAnc3RyaW5nJzpcbiAgICByZXR1cm4gcXVvdGUodmFsdWUpO1xuICBjYXNlICdudW1iZXInOlxuICAgIC8vIEpTT04gbnVtYmVycyBtdXN0IGJlIGZpbml0ZS4gRW5jb2RlIG5vbi1maW5pdGUgbnVtYmVycyBhcyBudWxsLlxuICAgIHJldHVybiBpc0Zpbml0ZSh2YWx1ZSkgPyBTdHJpbmcodmFsdWUpIDogJ251bGwnO1xuICBjYXNlICdib29sZWFuJzpcbiAgICByZXR1cm4gU3RyaW5nKHZhbHVlKTtcbiAgLy8gSWYgdGhlIHR5cGUgaXMgJ29iamVjdCcsIHdlIG1pZ2h0IGJlIGRlYWxpbmcgd2l0aCBhbiBvYmplY3Qgb3IgYW4gYXJyYXkgb3JcbiAgLy8gbnVsbC5cbiAgY2FzZSAnb2JqZWN0Jzoge1xuICAgIC8vIER1ZSB0byBhIHNwZWNpZmljYXRpb24gYmx1bmRlciBpbiBFQ01BU2NyaXB0LCB0eXBlb2YgbnVsbCBpcyAnb2JqZWN0JyxcbiAgICAvLyBzbyB3YXRjaCBvdXQgZm9yIHRoYXQgY2FzZS5cbiAgICBpZiAoIXZhbHVlKSB7XG4gICAgICByZXR1cm4gJ251bGwnO1xuICAgIH1cbiAgICAvLyBNYWtlIGFuIGFycmF5IHRvIGhvbGQgdGhlIHBhcnRpYWwgcmVzdWx0cyBvZiBzdHJpbmdpZnlpbmcgdGhpcyBvYmplY3RcbiAgICAvLyB2YWx1ZS5cbiAgICBjb25zdCBpbm5lckluZGVudCA9IG91dGVySW5kZW50ICsgc2luZ2xlSW5kZW50O1xuICAgIGNvbnN0IHBhcnRpYWwgPSBbXTtcbiAgICBsZXQgdjtcblxuICAgIC8vIElzIHRoZSB2YWx1ZSBhbiBhcnJheT9cbiAgICBpZiAoQXJyYXkuaXNBcnJheSh2YWx1ZSkgfHwgKHt9KS5oYXNPd25Qcm9wZXJ0eS5jYWxsKHZhbHVlLCAnY2FsbGVlJykpIHtcbiAgICAgIC8vIFRoZSB2YWx1ZSBpcyBhbiBhcnJheS4gU3RyaW5naWZ5IGV2ZXJ5IGVsZW1lbnQuIFVzZSBudWxsIGFzIGFcbiAgICAgIC8vIHBsYWNlaG9sZGVyIGZvciBub24tSlNPTiB2YWx1ZXMuXG4gICAgICBjb25zdCBsZW5ndGggPSB2YWx1ZS5sZW5ndGg7XG4gICAgICBmb3IgKGxldCBpID0gMDsgaSA8IGxlbmd0aDsgaSArPSAxKSB7XG4gICAgICAgIHBhcnRpYWxbaV0gPVxuICAgICAgICAgIHN0cihpLCB2YWx1ZSwgc2luZ2xlSW5kZW50LCBpbm5lckluZGVudCwgY2Fub25pY2FsKSB8fCAnbnVsbCc7XG4gICAgICB9XG5cbiAgICAgIC8vIEpvaW4gYWxsIG9mIHRoZSBlbGVtZW50cyB0b2dldGhlciwgc2VwYXJhdGVkIHdpdGggY29tbWFzLCBhbmQgd3JhcFxuICAgICAgLy8gdGhlbSBpbiBicmFja2V0cy5cbiAgICAgIGlmIChwYXJ0aWFsLmxlbmd0aCA9PT0gMCkge1xuICAgICAgICB2ID0gJ1tdJztcbiAgICAgIH0gZWxzZSBpZiAoaW5uZXJJbmRlbnQpIHtcbiAgICAgICAgdiA9ICdbXFxuJyArXG4gICAgICAgICAgaW5uZXJJbmRlbnQgK1xuICAgICAgICAgIHBhcnRpYWwuam9pbignLFxcbicgK1xuICAgICAgICAgIGlubmVySW5kZW50KSArXG4gICAgICAgICAgJ1xcbicgK1xuICAgICAgICAgIG91dGVySW5kZW50ICtcbiAgICAgICAgICAnXSc7XG4gICAgICB9IGVsc2Uge1xuICAgICAgICB2ID0gJ1snICsgcGFydGlhbC5qb2luKCcsJykgKyAnXSc7XG4gICAgICB9XG4gICAgICByZXR1cm4gdjtcbiAgICB9XG5cbiAgICAvLyBJdGVyYXRlIHRocm91Z2ggYWxsIG9mIHRoZSBrZXlzIGluIHRoZSBvYmplY3QuXG4gICAgbGV0IGtleXMgPSBPYmplY3Qua2V5cyh2YWx1ZSk7XG4gICAgaWYgKGNhbm9uaWNhbCkge1xuICAgICAga2V5cyA9IGtleXMuc29ydCgpO1xuICAgIH1cbiAgICBrZXlzLmZvckVhY2goayA9PiB7XG4gICAgICB2ID0gc3RyKGssIHZhbHVlLCBzaW5nbGVJbmRlbnQsIGlubmVySW5kZW50LCBjYW5vbmljYWwpO1xuICAgICAgaWYgKHYpIHtcbiAgICAgICAgcGFydGlhbC5wdXNoKHF1b3RlKGspICsgKGlubmVySW5kZW50ID8gJzogJyA6ICc6JykgKyB2KTtcbiAgICAgIH1cbiAgICB9KTtcblxuICAgIC8vIEpvaW4gYWxsIG9mIHRoZSBtZW1iZXIgdGV4dHMgdG9nZXRoZXIsIHNlcGFyYXRlZCB3aXRoIGNvbW1hcyxcbiAgICAvLyBhbmQgd3JhcCB0aGVtIGluIGJyYWNlcy5cbiAgICBpZiAocGFydGlhbC5sZW5ndGggPT09IDApIHtcbiAgICAgIHYgPSAne30nO1xuICAgIH0gZWxzZSBpZiAoaW5uZXJJbmRlbnQpIHtcbiAgICAgIHYgPSAne1xcbicgK1xuICAgICAgICBpbm5lckluZGVudCArXG4gICAgICAgIHBhcnRpYWwuam9pbignLFxcbicgK1xuICAgICAgICBpbm5lckluZGVudCkgK1xuICAgICAgICAnXFxuJyArXG4gICAgICAgIG91dGVySW5kZW50ICtcbiAgICAgICAgJ30nO1xuICAgIH0gZWxzZSB7XG4gICAgICB2ID0gJ3snICsgcGFydGlhbC5qb2luKCcsJykgKyAnfSc7XG4gICAgfVxuICAgIHJldHVybiB2O1xuICB9XG5cbiAgZGVmYXVsdDogLy8gRG8gbm90aGluZ1xuICB9XG59O1xuXG4vLyBJZiB0aGUgSlNPTiBvYmplY3QgZG9lcyBub3QgeWV0IGhhdmUgYSBzdHJpbmdpZnkgbWV0aG9kLCBnaXZlIGl0IG9uZS5cbmNvbnN0IGNhbm9uaWNhbFN0cmluZ2lmeSA9ICh2YWx1ZSwgb3B0aW9ucykgPT4ge1xuICAvLyBNYWtlIGEgZmFrZSByb290IG9iamVjdCBjb250YWluaW5nIG91ciB2YWx1ZSB1bmRlciB0aGUga2V5IG9mICcnLlxuICAvLyBSZXR1cm4gdGhlIHJlc3VsdCBvZiBzdHJpbmdpZnlpbmcgdGhlIHZhbHVlLlxuICBjb25zdCBhbGxPcHRpb25zID0gT2JqZWN0LmFzc2lnbih7XG4gICAgaW5kZW50OiAnJyxcbiAgICBjYW5vbmljYWw6IGZhbHNlLFxuICB9LCBvcHRpb25zKTtcbiAgaWYgKGFsbE9wdGlvbnMuaW5kZW50ID09PSB0cnVlKSB7XG4gICAgYWxsT3B0aW9ucy5pbmRlbnQgPSAnICAnO1xuICB9IGVsc2UgaWYgKHR5cGVvZiBhbGxPcHRpb25zLmluZGVudCA9PT0gJ251bWJlcicpIHtcbiAgICBsZXQgbmV3SW5kZW50ID0gJyc7XG4gICAgZm9yIChsZXQgaSA9IDA7IGkgPCBhbGxPcHRpb25zLmluZGVudDsgaSsrKSB7XG4gICAgICBuZXdJbmRlbnQgKz0gJyAnO1xuICAgIH1cbiAgICBhbGxPcHRpb25zLmluZGVudCA9IG5ld0luZGVudDtcbiAgfVxuICByZXR1cm4gc3RyKCcnLCB7Jyc6IHZhbHVlfSwgYWxsT3B0aW9ucy5pbmRlbnQsICcnLCBhbGxPcHRpb25zLmNhbm9uaWNhbCk7XG59O1xuXG5leHBvcnQgZGVmYXVsdCBjYW5vbmljYWxTdHJpbmdpZnk7XG4iLCJleHBvcnQgY29uc3QgaXNGdW5jdGlvbiA9IChmbikgPT4gdHlwZW9mIGZuID09PSAnZnVuY3Rpb24nO1xuXG5leHBvcnQgY29uc3QgaXNPYmplY3QgPSAoZm4pID0+IHR5cGVvZiBmbiA9PT0gJ29iamVjdCc7XG5cbmV4cG9ydCBjb25zdCBrZXlzT2YgPSAob2JqKSA9PiBPYmplY3Qua2V5cyhvYmopO1xuXG5leHBvcnQgY29uc3QgbGVuZ3RoT2YgPSAob2JqKSA9PiBPYmplY3Qua2V5cyhvYmopLmxlbmd0aDtcblxuZXhwb3J0IGNvbnN0IGhhc093biA9IChvYmosIHByb3ApID0+IE9iamVjdC5wcm90b3R5cGUuaGFzT3duUHJvcGVydHkuY2FsbChvYmosIHByb3ApO1xuXG5leHBvcnQgY29uc3QgY29udmVydE1hcFRvT2JqZWN0ID0gKG1hcCkgPT4gQXJyYXkuZnJvbShtYXApLnJlZHVjZSgoYWNjLCBba2V5LCB2YWx1ZV0pID0+IHtcbiAgLy8gcmVhc3NpZ24gdG8gbm90IGNyZWF0ZSBuZXcgb2JqZWN0XG4gIGFjY1trZXldID0gdmFsdWU7XG4gIHJldHVybiBhY2M7XG59LCB7fSk7XG5cbmV4cG9ydCBjb25zdCBpc0FyZ3VtZW50cyA9IG9iaiA9PiBvYmogIT0gbnVsbCAmJiBoYXNPd24ob2JqLCAnY2FsbGVlJyk7XG5cbmV4cG9ydCBjb25zdCBpc0luZk9yTmFOID1cbiAgb2JqID0+IE51bWJlci5pc05hTihvYmopIHx8IG9iaiA9PT0gSW5maW5pdHkgfHwgb2JqID09PSAtSW5maW5pdHk7XG5cbmV4cG9ydCBjb25zdCBjaGVja0Vycm9yID0ge1xuICBtYXhTdGFjazogKG1zZ0Vycm9yKSA9PiBuZXcgUmVnRXhwKCdNYXhpbXVtIGNhbGwgc3RhY2sgc2l6ZSBleGNlZWRlZCcsICdnJykudGVzdChtc2dFcnJvciksXG59O1xuXG5leHBvcnQgY29uc3QgaGFuZGxlRXJyb3IgPSAoZm4pID0+IGZ1bmN0aW9uKCkge1xuICB0cnkge1xuICAgIHJldHVybiBmbi5hcHBseSh0aGlzLCBhcmd1bWVudHMpO1xuICB9IGNhdGNoIChlcnJvcikge1xuICAgIGNvbnN0IGlzTWF4U3RhY2sgPSBjaGVja0Vycm9yLm1heFN0YWNrKGVycm9yLm1lc3NhZ2UpO1xuICAgIGlmIChpc01heFN0YWNrKSB7XG4gICAgICB0aHJvdyBuZXcgRXJyb3IoJ0NvbnZlcnRpbmcgY2lyY3VsYXIgc3RydWN0dXJlIHRvIEpTT04nKVxuICAgIH1cbiAgICB0aHJvdyBlcnJvcjtcbiAgfVxufTtcbiJdfQ==
