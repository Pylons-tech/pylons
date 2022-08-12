"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = getLastPartOfKey;

/**
 * Returns the ending of key, after stripping out the beginning
 * ancestorKey and any array placeholders
 *
 * getLastPartOfKey('a.b.c', 'a') returns 'b.c'
 * getLastPartOfKey('a.b.$.c', 'a.b') returns 'c'
 */
function getLastPartOfKey(key, ancestorKey) {
  var lastPart = '';
  var startString = "".concat(ancestorKey, ".");

  if (key.indexOf(startString) === 0) {
    lastPart = key.replace(startString, '');
    if (lastPart.startsWith('$.')) lastPart = lastPart.slice(2);
  }

  return lastPart;
}

module.exports = exports.default;
module.exports.default = exports.default;