"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = looksLikeModifier;

/**
 * Returns true if any of the keys of obj start with a $
 */
function looksLikeModifier(obj) {
  return !!Object.keys(obj || {}).find(function (key) {
    return key.substring(0, 1) === '$';
  });
}

module.exports = exports.default;
module.exports.default = exports.default;