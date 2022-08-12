"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;

var _clone = _interopRequireDefault(require("clone"));

var _utility = require("../utility");

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _typeof(obj) { "@babel/helpers - typeof"; return _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (obj) { return typeof obj; } : function (obj) { return obj && "function" == typeof Symbol && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }, _typeof(obj); }

function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); enumerableOnly && (symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; })), keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = null != arguments[i] ? arguments[i] : {}; i % 2 ? ownKeys(Object(source), !0).forEach(function (key) { _defineProperty(target, key, source[key]); }) : Object.getOwnPropertyDescriptors ? Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)) : ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }

function getFieldInfo(mongoObject, key) {
  var keyInfo = mongoObject.getInfoForKey(key) || {};
  return {
    isSet: keyInfo.value !== undefined,
    value: keyInfo.value,
    operator: keyInfo.operator || null
  };
}

var AutoValueRunner = /*#__PURE__*/function () {
  function AutoValueRunner(options) {
    _classCallCheck(this, AutoValueRunner);

    this.options = options;
    this.doneKeys = [];
  }

  _createClass(AutoValueRunner, [{
    key: "runForPosition",
    value: function runForPosition(_ref) {
      var affectedKey = _ref.key,
          operator = _ref.operator,
          position = _ref.position,
          value = _ref.value;
      var _this$options = this.options,
          closestSubschemaFieldName = _this$options.closestSubschemaFieldName,
          extendedAutoValueContext = _this$options.extendedAutoValueContext,
          func = _this$options.func,
          isModifier = _this$options.isModifier,
          isUpsert = _this$options.isUpsert,
          mongoObject = _this$options.mongoObject; // If already called for this key, skip it

      if (this.doneKeys.includes(affectedKey)) return;
      var fieldParentName = (0, _utility.getParentOfKey)(affectedKey, true);
      var parentFieldInfo = getFieldInfo(mongoObject, fieldParentName.slice(0, -1));
      var doUnset = false;

      if (Array.isArray(parentFieldInfo.value)) {
        if (isNaN(affectedKey.split('.').slice(-1).pop())) {
          // parent is an array, but the key to be set is not an integer (see issue #80)
          return;
        }
      }

      var autoValue = func.call(_objectSpread({
        closestSubschemaFieldName: closestSubschemaFieldName.length ? closestSubschemaFieldName : null,
        field: function field(fName) {
          return getFieldInfo(mongoObject, closestSubschemaFieldName + fName);
        },
        isModifier: isModifier,
        isUpsert: isUpsert,
        isSet: value !== undefined,
        key: affectedKey,
        operator: operator,
        parentField: function parentField() {
          return parentFieldInfo;
        },
        siblingField: function siblingField(fName) {
          return getFieldInfo(mongoObject, fieldParentName + fName);
        },
        unset: function unset() {
          doUnset = true;
        },
        value: value
      }, extendedAutoValueContext || {}), mongoObject.getObject()); // Update tracking of which keys we've run autovalue for

      this.doneKeys.push(affectedKey);
      if (doUnset && position) mongoObject.removeValueForPosition(position);
      if (autoValue === undefined) return; // If the user's auto value is of the pseudo-modifier format, parse it
      // into operator and value.

      if (isModifier) {
        var op;
        var newValue;

        if (autoValue && _typeof(autoValue) === 'object') {
          var avOperator = Object.keys(autoValue).find(function (avProp) {
            return avProp.substring(0, 1) === '$';
          });

          if (avOperator) {
            op = avOperator;
            newValue = autoValue[avOperator];
          }
        } // Add $set for updates and upserts if necessary. Keep this
        // above the "if (op)" block below since we might change op
        // in this line.


        if (!op && position.slice(0, 1) !== '$') {
          op = '$set';
          newValue = autoValue;
        }

        if (op) {
          // Update/change value
          mongoObject.removeValueForPosition(position);
          mongoObject.setValueForPosition("".concat(op, "[").concat(affectedKey, "]"), (0, _clone.default)(newValue));
          return;
        }
      } // Update/change value. Cloning is necessary in case it's an object, because
      // if we later set some keys within it, they'd be set on the original object, too.


      mongoObject.setValueForPosition(position, (0, _clone.default)(autoValue));
    }
  }]);

  return AutoValueRunner;
}();

exports.default = AutoValueRunner;
module.exports = exports.default;
module.exports.default = exports.default;