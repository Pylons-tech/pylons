"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;

var _mongoObject = _interopRequireDefault(require("mongo-object"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); enumerableOnly && (symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; })), keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = null != arguments[i] ? arguments[i] : {}; i % 2 ? ownKeys(Object(source), !0).forEach(function (key) { _defineProperty(target, key, source[key]); }) : Object.getOwnPropertyDescriptors ? Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)) : ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

/**
 * Clones a schema object, expanding shorthand as it does it.
 */
function expandShorthand(schema) {
  var schemaClone = {};
  Object.keys(schema).forEach(function (key) {
    var definition = schema[key]; // CASE 1: Not shorthand. Just clone

    if (_mongoObject.default.isBasicObject(definition)) {
      schemaClone[key] = _objectSpread({}, definition);
      return;
    } // CASE 2: The definition is an array of some type


    if (Array.isArray(definition)) {
      if (Array.isArray(definition[0])) {
        throw new Error("Array shorthand may only be used to one level of depth (".concat(key, ")"));
      }

      var type = definition[0];
      schemaClone[key] = {
        type: Array
      }; // Also add the item key definition

      var itemKey = "".concat(key, ".$");

      if (schema[itemKey]) {
        throw new Error("Array shorthand used for ".concat(key, " field but ").concat(key, ".$ key is already in the schema"));
      }

      if (type instanceof RegExp) {
        schemaClone[itemKey] = {
          type: String,
          regEx: type
        };
      } else {
        schemaClone[itemKey] = {
          type: type
        };
      }

      return;
    } // CASE 3: The definition is a regular expression


    if (definition instanceof RegExp) {
      schemaClone[key] = {
        type: String,
        regEx: definition
      };
      return;
    } // CASE 4: The definition is something, a type


    schemaClone[key] = {
      type: definition
    };
  });
  return schemaClone;
}

var _default = expandShorthand;
exports.default = _default;
module.exports = exports.default;
module.exports.default = exports.default;