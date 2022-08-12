"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;
exports.sortAutoValueFunctions = sortAutoValueFunctions;

var _getPositionsForAutoValue = _interopRequireDefault(require("./getPositionsForAutoValue"));

var _AutoValueRunner = _interopRequireDefault(require("./AutoValueRunner"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

/**
 * @method sortAutoValueFunctions
 * @private
 * @param {Array} autoValueFunctions - Array of objects to be sorted
 * @returns {Array} Sorted array
 *
 * Stable sort of the autoValueFunctions (preserves order at the same field depth).
 */
function sortAutoValueFunctions(autoValueFunctions) {
  var defaultFieldOrder = autoValueFunctions.reduce(function (acc, _ref, index) {
    var fieldName = _ref.fieldName;
    acc[fieldName] = index;
    return acc;
  }, {}); // Sort by how many dots each field name has, asc, such that we can auto-create
  // objects and arrays before we run the autoValues for properties within them.
  // Fields of the same level (same number of dots) preserve should order from the original array.

  return autoValueFunctions.sort(function (a, b) {
    var depthDiff = a.fieldName.split('.').length - b.fieldName.split('.').length;
    return depthDiff === 0 ? defaultFieldOrder[a.fieldName] - defaultFieldOrder[b.fieldName] : depthDiff;
  });
}
/**
 * @method setAutoValues
 * @private
 * @param {Array} autoValueFunctions - An array of objects with func, fieldName, and closestSubschemaFieldName props
 * @param {MongoObject} mongoObject
 * @param {Boolean} [isModifier=false] - Is it a modifier doc?
 * @param {Object} [extendedAutoValueContext] - Object that will be added to the context when calling each autoValue function
 * @returns {undefined}
 *
 * Updates doc with automatic values from autoValue functions or default
 * values from defaultValue. Modifies the referenced object in place.
 */


function setAutoValues(autoValueFunctions, mongoObject, isModifier, isUpsert, extendedAutoValueContext) {
  var sortedAutoValueFunctions = sortAutoValueFunctions(autoValueFunctions);
  sortedAutoValueFunctions.forEach(function (_ref2) {
    var func = _ref2.func,
        fieldName = _ref2.fieldName,
        closestSubschemaFieldName = _ref2.closestSubschemaFieldName;
    var avRunner = new _AutoValueRunner.default({
      closestSubschemaFieldName: closestSubschemaFieldName,
      extendedAutoValueContext: extendedAutoValueContext,
      func: func,
      isModifier: isModifier,
      isUpsert: isUpsert,
      mongoObject: mongoObject
    });
    var positions = (0, _getPositionsForAutoValue.default)({
      fieldName: fieldName,
      isModifier: isModifier,
      mongoObject: mongoObject
    }); // Run the autoValue function once for each place in the object that
    // has a value or that potentially should.

    positions.forEach(avRunner.runForPosition.bind(avRunner));
  });
}

var _default = setAutoValues;
exports.default = _default;