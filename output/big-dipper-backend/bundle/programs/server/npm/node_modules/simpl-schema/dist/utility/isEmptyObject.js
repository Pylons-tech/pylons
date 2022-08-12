"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = isEmptyObject;

/**
 * @summary Determines whether the object has any "own" properties
 * @param {Object} obj Object to test
 * @return {Boolean} True if it has no "own" properties
 */
function isEmptyObject(obj) {
  /* eslint-disable no-restricted-syntax */
  for (var key in obj) {
    if (Object.prototype.hasOwnProperty.call(obj, key)) {
      return false;
    }
  }
  /* eslint-enable no-restricted-syntax */


  return true;
}

module.exports = exports.default;
module.exports.default = exports.default;