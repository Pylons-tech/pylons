"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = appendAffectedKey;

function appendAffectedKey(affectedKey, key) {
  if (key === '$each') return affectedKey;
  return affectedKey ? "".concat(affectedKey, ".").concat(key) : key;
}

module.exports = exports.default;
module.exports.default = exports.default;