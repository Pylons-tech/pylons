"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = getKeysWithValueInObj;

/**
 * Returns an array of keys that are in obj, have a value
 * other than null or undefined, and start with matchKey
 * plus a dot.
 */
function getKeysWithValueInObj(obj, matchKey) {
  var keysWithValue = [];

  var keyAdjust = function keyAdjust(k) {
    return k.slice(0, matchKey.length + 1);
  };

  var matchKeyPlusDot = "".concat(matchKey, ".");
  Object.keys(obj || {}).forEach(function (key) {
    var val = obj[key];
    if (val === undefined || val === null) return;

    if (keyAdjust(key) === matchKeyPlusDot) {
      keysWithValue.push(key);
    }
  });
  return keysWithValue;
}

module.exports = exports.default;
module.exports.default = exports.default;