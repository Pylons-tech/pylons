"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = doStringChecks;

var _SimpleSchema = require("../../SimpleSchema");

function doStringChecks(def, keyValue) {
  // Is it a String?
  if (typeof keyValue !== 'string') {
    return {
      type: _SimpleSchema.SimpleSchema.ErrorTypes.EXPECTED_TYPE,
      dataType: 'String'
    };
  } // Is the string too long?


  if (def.max !== null && def.max < keyValue.length) {
    return {
      type: _SimpleSchema.SimpleSchema.ErrorTypes.MAX_STRING,
      max: def.max
    };
  } // Is the string too short?


  if (def.min !== null && def.min > keyValue.length) {
    return {
      type: _SimpleSchema.SimpleSchema.ErrorTypes.MIN_STRING,
      min: def.min
    };
  } // Does the string match the regular expression?


  if ((def.skipRegExCheckForEmptyStrings !== true || keyValue !== '') && def.regEx instanceof RegExp && !def.regEx.test(keyValue)) {
    return {
      type: _SimpleSchema.SimpleSchema.ErrorTypes.FAILED_REGULAR_EXPRESSION,
      regExp: def.regEx.toString()
    };
  } // If regEx is an array of regular expressions, does the string match all of them?


  if (Array.isArray(def.regEx)) {
    var regExError;
    def.regEx.every(function (re) {
      if (!re.test(keyValue)) {
        regExError = {
          type: _SimpleSchema.SimpleSchema.ErrorTypes.FAILED_REGULAR_EXPRESSION,
          regExp: re.toString()
        };
        return false;
      }

      return true;
    });
    if (regExError) return regExError;
  }
}

module.exports = exports.default;
module.exports.default = exports.default;