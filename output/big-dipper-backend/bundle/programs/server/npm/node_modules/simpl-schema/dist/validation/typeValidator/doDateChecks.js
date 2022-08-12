"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = doDateChecks;

var _SimpleSchema = require("../../SimpleSchema");

var _utility = require("../../utility");

function doDateChecks(def, keyValue) {
  // Is it an invalid date?
  if (isNaN(keyValue.getTime())) return {
    type: _SimpleSchema.SimpleSchema.ErrorTypes.BAD_DATE
  }; // Is it earlier than the minimum date?

  if (def.min && typeof def.min.getTime === 'function' && def.min.getTime() > keyValue.getTime()) {
    return {
      type: _SimpleSchema.SimpleSchema.ErrorTypes.MIN_DATE,
      min: (0, _utility.dateToDateString)(def.min)
    };
  } // Is it later than the maximum date?


  if (def.max && typeof def.max.getTime === 'function' && def.max.getTime() < keyValue.getTime()) {
    return {
      type: _SimpleSchema.SimpleSchema.ErrorTypes.MAX_DATE,
      max: (0, _utility.dateToDateString)(def.max)
    };
  }
}

module.exports = exports.default;
module.exports.default = exports.default;