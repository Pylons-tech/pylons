"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.SUGGESTED_EVALUATE = exports.DEFAULT_ESCAPE = exports.DEFAULT_INTERPOLATE = undefined;

var _lodash = require("lodash.template");

var _lodash2 = _interopRequireDefault(_lodash);

var _merge = require("./merge");

var _merge2 = _interopRequireDefault(_merge);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

// Default lodash templates regexs
// https://regex101.com/r/ce27tA/5
var DEFAULT_INTERPOLATE = exports.DEFAULT_INTERPOLATE = /{{{([^{}#][\s\S]+?)}}}/g; // https://regex101.com/r/8sRC8b/8

var DEFAULT_ESCAPE = exports.DEFAULT_ESCAPE = /{{([^{}#][\s\S]+?)}}/g; // https://regex101.com/r/ndDqxg/4

var SUGGESTED_EVALUATE = exports.SUGGESTED_EVALUATE = /{{#([^{}].*?)}}/g;

var MessageBox = /*#__PURE__*/function () {
  function MessageBox() {
    var _ref = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {},
        escape = _ref.escape,
        evaluate = _ref.evaluate,
        initialLanguage = _ref.initialLanguage,
        interpolate = _ref.interpolate,
        messages = _ref.messages,
        tracker = _ref.tracker;

    _classCallCheck(this, MessageBox);

    this.language = initialLanguage || MessageBox.language || 'en';
    this.messageList = messages || {};

    if (tracker) {
      this.tracker = tracker;
      this.trackerDep = new tracker.Dependency();
    } // Template options


    this.interpolate = interpolate || MessageBox.interpolate || DEFAULT_INTERPOLATE;
    this.evaluate = evaluate || MessageBox.evaluate;
    this.escape = escape || MessageBox.escape || DEFAULT_ESCAPE;
  }

  _createClass(MessageBox, [{
    key: "clone",
    value: function clone() {
      var copy = new MessageBox({
        escape: this.escape,
        evaluate: this.evaluate,
        initialLanguage: this.language,
        interpolate: this.interpolate,
        tracker: this.tracker
      });
      copy.messages(this.messageList);
      return copy;
    }
  }, {
    key: "getMessages",
    value: function getMessages(language) {
      if (!language) {
        language = this.language;
        if (this.trackerDep) this.trackerDep.depend();
      }

      var globalMessages = MessageBox.messages[language];
      var messages = this.messageList[language];

      if (messages) {
        if (globalMessages) messages = (0, _merge2.default)({}, globalMessages, messages);
      } else {
        messages = globalMessages;
      }

      if (!messages) throw new Error("No messages found for language \"".concat(language, "\""));
      return {
        messages: messages,
        language: language
      };
    }
  }, {
    key: "message",
    value: function message(errorInfo) {
      var _ref2 = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : {},
          context = _ref2.context,
          language = _ref2.language;

      // Error objects can optionally include a preformatted message,
      // in which case we use that.
      if (errorInfo.message) return errorInfo.message;
      var fieldName = errorInfo.name;
      var genericName = MessageBox.makeNameGeneric(fieldName);

      var _this$getMessages = this.getMessages(language),
          messages = _this$getMessages.messages;

      var message = messages[errorInfo.type];

      var fullContext = _objectSpread({
        genericName: genericName
      }, context, {}, errorInfo);

      if (message && _typeof(message) === 'object') message = message[genericName] || message._default; // eslint-disable-line no-underscore-dangle

      if (typeof message === 'string') {
        message = (0, _lodash2.default)(message, {
          interpolate: this.interpolate,
          evaluate: this.evaluate,
          escape: this.escape
        });
      }

      if (typeof message !== 'function') return "".concat(fieldName, " is invalid");
      return message(fullContext);
    }
  }, {
    key: "messages",
    value: function messages(_messages) {
      (0, _merge2.default)(this.messageList, _messages);
    }
  }, {
    key: "setLanguage",
    value: function setLanguage(language) {
      this.language = language;
      if (this.trackerDep) this.trackerDep.changed();
    }
  }], [{
    key: "makeNameGeneric",
    value: function makeNameGeneric(name) {
      if (typeof name !== 'string') return null;
      return name.replace(/\.[0-9]+(?=\.|$)/g, '.$');
    }
  }, {
    key: "defaults",
    value: function defaults() {
      var _ref3 = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {},
          escape = _ref3.escape,
          evaluate = _ref3.evaluate,
          initialLanguage = _ref3.initialLanguage,
          interpolate = _ref3.interpolate,
          messages = _ref3.messages;

      if (typeof initialLanguage === 'string') MessageBox.language = initialLanguage;
      if (interpolate instanceof RegExp) MessageBox.interpolate = interpolate;
      if (evaluate instanceof RegExp) MessageBox.evaluate = evaluate;
      if (escape instanceof RegExp) MessageBox.escape = escape;

      if (messages) {
        if (!MessageBox.messages) MessageBox.messages = {};
        (0, _merge2.default)(MessageBox.messages, messages);
      }
    }
  }]);

  return MessageBox;
}();

_defineProperty(MessageBox, "messages", {});

exports.default = MessageBox;