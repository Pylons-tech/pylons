"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = forEachKeyAncestor;

/**
 * Run loopFunc for each ancestor key in a dot-delimited key. For example,
 * if key is "a.b.c", loopFunc will be called first with ('a.b', 'c') and then with ('a', 'b.c')
 */
function forEachKeyAncestor(key, loopFunc) {
  var lastDot; // Iterate the dot-syntax hierarchy

  var ancestor = key;

  do {
    lastDot = ancestor.lastIndexOf('.');

    if (lastDot !== -1) {
      ancestor = ancestor.slice(0, lastDot);
      var remainder = key.slice(ancestor.length + 1);
      loopFunc(ancestor, remainder); // Remove last path component
    }
  } while (lastDot !== -1);
}

module.exports = exports.default;
module.exports.default = exports.default;