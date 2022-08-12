"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = merge;

/**
 * We have relatively simple deep merging requirements in this package.
 * We are only ever merging messages config, so we know the structure,
 * we know there are no arrays, and we know there are no constructors
 * or weirdly defined properties.
 *
 * Thus, we can write a very simplistic deep merge function to avoid
 * pulling in a large dependency.
 */
function merge(destination) {
  for (var _len = arguments.length, sources = new Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
    sources[_key - 1] = arguments[_key];
  }

  sources.forEach(function (source) {
    Object.keys(source).forEach(function (prop) {
      if (source[prop] && source[prop].constructor && source[prop].constructor === Object) {
        if (!destination[prop] || !destination[prop].constructor || destination[prop].constructor !== Object) {
          destination[prop] = {};
        }

        merge(destination[prop], source[prop]);
      } else {
        destination[prop] = source[prop];
      }
    });
  });
  return destination;
}