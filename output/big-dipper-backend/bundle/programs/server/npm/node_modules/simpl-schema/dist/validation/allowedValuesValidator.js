"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = allowedValuesValidator;

var _SimpleSchema = require("../SimpleSchema");

function allowedValuesValidator() {
  if (!this.valueShouldBeChecked) return;
  var allowedValues = this.definition.allowedValues;
  if (!allowedValues) return;
  var isAllowed; // set defined in scope and allowedValues is its instance

  if (typeof Set === 'function' && allowedValues instanceof Set) {
    isAllowed = allowedValues.has(this.value);
  } else {
    isAllowed = allowedValues.includes(this.value);
  }

  return isAllowed ? true : _SimpleSchema.SimpleSchema.ErrorTypes.VALUE_NOT_ALLOWED;
}

module.exports = exports.default;
module.exports.default = exports.default;