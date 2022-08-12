"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;

var _regExp = _interopRequireDefault(require("./regExp"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var regExpMessages = [{
  exp: _regExp.default.Email,
  msg: 'must be a valid email address'
}, {
  exp: _regExp.default.EmailWithTLD,
  msg: 'must be a valid email address'
}, {
  exp: _regExp.default.Domain,
  msg: 'must be a valid domain'
}, {
  exp: _regExp.default.WeakDomain,
  msg: 'must be a valid domain'
}, {
  exp: _regExp.default.IP,
  msg: 'must be a valid IPv4 or IPv6 address'
}, {
  exp: _regExp.default.IPv4,
  msg: 'must be a valid IPv4 address'
}, {
  exp: _regExp.default.IPv6,
  msg: 'must be a valid IPv6 address'
}, {
  exp: _regExp.default.Url,
  msg: 'must be a valid URL'
}, {
  exp: _regExp.default.Id,
  msg: 'must be a valid alphanumeric ID'
}, {
  exp: _regExp.default.ZipCode,
  msg: 'must be a valid ZIP code'
}, {
  exp: _regExp.default.Phone,
  msg: 'must be a valid phone number'
}];
var defaultMessages = {
  initialLanguage: 'en',
  messages: {
    en: {
      required: '{{{label}}} is required',
      minString: '{{{label}}} must be at least {{min}} characters',
      maxString: '{{{label}}} cannot exceed {{max}} characters',
      minNumber: '{{{label}}} must be at least {{min}}',
      maxNumber: '{{{label}}} cannot exceed {{max}}',
      minNumberExclusive: '{{{label}}} must be greater than {{min}}',
      maxNumberExclusive: '{{{label}}} must be less than {{max}}',
      minDate: '{{{label}}} must be on or after {{min}}',
      maxDate: '{{{label}}} cannot be after {{max}}',
      badDate: '{{{label}}} is not a valid date',
      minCount: 'You must specify at least {{minCount}} values',
      maxCount: 'You cannot specify more than {{maxCount}} values',
      noDecimal: '{{{label}}} must be an integer',
      notAllowed: '{{{value}}} is not an allowed value',
      expectedType: '{{{label}}} must be of type {{dataType}}',
      regEx: function regEx(_ref) {
        var label = _ref.label,
            regExp = _ref.regExp;
        // See if there's one where exp matches this expression
        var msgObj;

        if (regExp) {
          msgObj = regExpMessages.find(function (o) {
            return o.exp && o.exp.toString() === regExp;
          });
        }

        var regExpMessage = msgObj ? msgObj.msg : 'failed regular expression validation';
        return "".concat(label, " ").concat(regExpMessage);
      },
      keyNotInSchema: '{{name}} is not allowed by the schema'
    }
  }
};
var _default = defaultMessages;
exports.default = _default;
module.exports = exports.default;
module.exports.default = exports.default;