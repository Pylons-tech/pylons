"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = getParentOfKey;

/**
 * Returns the parent of a key. For example, returns 'a.b' when passed 'a.b.c'.
 * If no parent, returns an empty string. If withEndDot is true, the return
 * value will have a dot appended when it isn't an empty string.
 */
function getParentOfKey(key, withEndDot) {
  var lastDot = key.lastIndexOf('.');
  return lastDot === -1 ? '' : key.slice(0, lastDot + Number(!!withEndDot));
}

module.exports = exports.default;
module.exports.default = exports.default;