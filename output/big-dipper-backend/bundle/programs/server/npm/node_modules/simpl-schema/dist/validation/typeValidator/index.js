"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = typeValidator;

var _SimpleSchema = require("../../SimpleSchema");

var _doDateChecks = _interopRequireDefault(require("./doDateChecks"));

var _doNumberChecks = _interopRequireDefault(require("./doNumberChecks"));

var _doStringChecks = _interopRequireDefault(require("./doStringChecks"));

var _doArrayChecks = _interopRequireDefault(require("./doArrayChecks"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function typeValidator() {
  if (!this.valueShouldBeChecked) return;
  var def = this.definition;
  var expectedType = def.type;
  var keyValue = this.value;
  var op = this.operator;
  if (expectedType === String) return (0, _doStringChecks.default)(def, keyValue);
  if (expectedType === Number) return (0, _doNumberChecks.default)(def, keyValue, op, false);
  if (expectedType === _SimpleSchema.SimpleSchema.Integer) return (0, _doNumberChecks.default)(def, keyValue, op, true);

  if (expectedType === Boolean) {
    // Is it a boolean?
    if (typeof keyValue === 'boolean') return;
    return {
      type: _SimpleSchema.SimpleSchema.ErrorTypes.EXPECTED_TYPE,
      dataType: 'Boolean'
    };
  }

  if (expectedType === Object || _SimpleSchema.SimpleSchema.isSimpleSchema(expectedType)) {
    // Is it an object?
    if (keyValue === Object(keyValue) && typeof keyValue[Symbol.iterator] !== 'function' && !(keyValue instanceof Date)) return;
    return {
      type: _SimpleSchema.SimpleSchema.ErrorTypes.EXPECTED_TYPE,
      dataType: 'Object'
    };
  }

  if (expectedType === Array) return (0, _doArrayChecks.default)(def, keyValue);

  if (expectedType instanceof Function) {
    // Generic constructor checks
    if (!(keyValue instanceof expectedType)) {
      // https://docs.mongodb.com/manual/reference/operator/update/currentDate/
      var dateTypeIsOkay = expectedType === Date && op === '$currentDate' && (keyValue === true || JSON.stringify(keyValue) === '{"$type":"date"}');

      if (expectedType !== Date || !dateTypeIsOkay) {
        return {
          type: _SimpleSchema.SimpleSchema.ErrorTypes.EXPECTED_TYPE,
          dataType: expectedType.name
        };
      }
    } // Date checks


    if (expectedType === Date) {
      // https://docs.mongodb.com/manual/reference/operator/update/currentDate/
      if (op === '$currentDate') {
        return (0, _doDateChecks.default)(def, new Date());
      }

      return (0, _doDateChecks.default)(def, keyValue);
    }
  }
}

module.exports = exports.default;
module.exports.default = exports.default;