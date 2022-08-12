"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = getPositionsForAutoValue;

var _mongoObject = _interopRequireDefault(require("mongo-object"));

var _utility = require("../utility");

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

/**
 * A position is a place in the object where this field exists.
 * If no arrays are involved, then every field/key has at most 1 position.
 * If arrays are involved, then a field could have potentially unlimited positions.
 *
 * For example, the key 'a.b.$.c` would have these positions:
 *   `a[b][0][c]`
 *   `a[b][1][c]`
 *   `a[b][2][c]`
 *
 * For this object:
 * {
 *   a: {
 *     b: [
 *       { c: 1 },
 *       { c: 1 },
 *       { c: 1 },
 *     ],
 *   },
 * }
 *
 * To make matters more complicated, we want to include not only the existing positions
 * but also the positions that might exist due to their parent object existing or their
 * parent object being auto-created by a MongoDB modifier that implies it.
 */
function getPositionsForAutoValue(_ref) {
  var fieldName = _ref.fieldName,
      isModifier = _ref.isModifier,
      mongoObject = _ref.mongoObject;
  // Positions for this field
  var positions = mongoObject.getPositionsInfoForGenericKey(fieldName); // If the field is an object and will be created by MongoDB,
  // we don't need (and can't have) a value for it

  if (isModifier && mongoObject.getPositionsThatCreateGenericKey(fieldName).length > 0) {
    return positions;
  } // For simple top-level fields, just add an undefined would-be position
  // if there isn't a real position.


  if (fieldName.indexOf('.') === -1 && positions.length === 0) {
    positions.push({
      key: fieldName,
      value: undefined,
      operator: isModifier ? '$set' : null,
      position: isModifier ? "$set[".concat(fieldName, "]") : fieldName
    });
    return positions;
  }

  var parentPath = (0, _utility.getParentOfKey)(fieldName);
  var lastPart = (0, _utility.getLastPartOfKey)(fieldName, parentPath);
  var lastPartWithBraces = lastPart.replace(/\./g, '][');
  var parentPositions = mongoObject.getPositionsInfoForGenericKey(parentPath);

  if (parentPositions.length) {
    parentPositions.forEach(function (info) {
      var childPosition = "".concat(info.position, "[").concat(lastPartWithBraces, "]");

      if (!positions.find(function (i) {
        return i.position === childPosition;
      })) {
        positions.push({
          key: "".concat(info.key, ".").concat(lastPart),
          value: undefined,
          operator: info.operator,
          position: childPosition
        });
      }
    });
  } else if (parentPath.slice(-2) !== '.$') {
    // positions that will create parentPath
    mongoObject.getPositionsThatCreateGenericKey(parentPath).forEach(function (info) {
      var operator = info.operator,
          position = info.position;
      var wouldBePosition;

      if (operator) {
        var next = position.slice(position.indexOf('[') + 1, position.indexOf(']'));
        var nextPieces = next.split('.');
        var newPieces = [];
        var newKey;

        while (nextPieces.length && newKey !== parentPath) {
          newPieces.push(nextPieces.shift());
          newKey = newPieces.join('.');
        }

        newKey = "".concat(newKey, ".").concat(fieldName.slice(newKey.length + 1));
        wouldBePosition = "$set[".concat(newKey, "]");
      } else {
        var lastPart2 = (0, _utility.getLastPartOfKey)(fieldName, parentPath);
        var lastPartWithBraces2 = lastPart2.replace(/\./g, '][');
        wouldBePosition = "".concat(position.slice(0, position.lastIndexOf('[')), "[").concat(lastPartWithBraces2, "]");
      }

      if (!positions.find(function (i) {
        return i.position === wouldBePosition;
      })) {
        positions.push({
          key: _mongoObject.default._positionToKey(wouldBePosition),
          value: undefined,
          operator: operator ? '$set' : null,
          position: wouldBePosition
        });
      }
    });
  }

  return positions;
}

module.exports = exports.default;
module.exports.default = exports.default;