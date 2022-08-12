"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.SimpleSchema = void 0;
Object.defineProperty(exports, "ValidationContext", {
  enumerable: true,
  get: function get() {
    return _ValidationContext.default;
  }
});
exports.schemaDefinitionOptions = void 0;

var _clone = _interopRequireDefault(require("clone"));

var _messageBox = _interopRequireDefault(require("message-box"));

var _mongoObject = _interopRequireDefault(require("mongo-object"));

var _humanize = _interopRequireDefault(require("./humanize"));

var _ValidationContext = _interopRequireDefault(require("./ValidationContext"));

var _SimpleSchemaGroup = _interopRequireDefault(require("./SimpleSchemaGroup"));

var _regExp = _interopRequireDefault(require("./regExp"));

var _clean2 = _interopRequireDefault(require("./clean"));

var _expandShorthand = _interopRequireDefault(require("./expandShorthand"));

var _utility = require("./utility");

var _defaultMessages = _interopRequireDefault(require("./defaultMessages"));

var _excluded = ["type"];

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _construct(Parent, args, Class) { if (_isNativeReflectConstruct()) { _construct = Reflect.construct; } else { _construct = function _construct(Parent, args, Class) { var a = [null]; a.push.apply(a, args); var Constructor = Function.bind.apply(Parent, a); var instance = new Constructor(); if (Class) _setPrototypeOf(instance, Class.prototype); return instance; }; } return _construct.apply(null, arguments); }

function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _iterableToArrayLimit(arr, i) { var _i = arr == null ? null : typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]; if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function _createForOfIteratorHelper(o, allowArrayLike) { var it = typeof Symbol !== "undefined" && o[Symbol.iterator] || o["@@iterator"]; if (!it) { if (Array.isArray(o) || (it = _unsupportedIterableToArray(o)) || allowArrayLike && o && typeof o.length === "number") { if (it) o = it; var i = 0; var F = function F() {}; return { s: F, n: function n() { if (i >= o.length) return { done: true }; return { done: false, value: o[i++] }; }, e: function e(_e2) { throw _e2; }, f: F }; } throw new TypeError("Invalid attempt to iterate non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); } var normalCompletion = true, didErr = false, err; return { s: function s() { it = it.call(o); }, n: function n() { var step = it.next(); normalCompletion = step.done; return step; }, e: function e(_e3) { didErr = true; err = _e3; }, f: function f() { try { if (!normalCompletion && it.return != null) it.return(); } finally { if (didErr) throw err; } } }; }

function _objectWithoutProperties(source, excluded) { if (source == null) return {}; var target = _objectWithoutPropertiesLoose(source, excluded); var key, i; if (Object.getOwnPropertySymbols) { var sourceSymbolKeys = Object.getOwnPropertySymbols(source); for (i = 0; i < sourceSymbolKeys.length; i++) { key = sourceSymbolKeys[i]; if (excluded.indexOf(key) >= 0) continue; if (!Object.prototype.propertyIsEnumerable.call(source, key)) continue; target[key] = source[key]; } } return target; }

function _objectWithoutPropertiesLoose(source, excluded) { if (source == null) return {}; var target = {}; var sourceKeys = Object.keys(source); var key, i; for (i = 0; i < sourceKeys.length; i++) { key = sourceKeys[i]; if (excluded.indexOf(key) >= 0) continue; target[key] = source[key]; } return target; }

function _toConsumableArray(arr) { return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _unsupportedIterableToArray(arr) || _nonIterableSpread(); }

function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _iterableToArray(iter) { if (typeof Symbol !== "undefined" && iter[Symbol.iterator] != null || iter["@@iterator"] != null) return Array.from(iter); }

function _arrayWithoutHoles(arr) { if (Array.isArray(arr)) return _arrayLikeToArray(arr); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); enumerableOnly && (symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; })), keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = null != arguments[i] ? arguments[i] : {}; i % 2 ? ownKeys(Object(source), !0).forEach(function (key) { _defineProperty(target, key, source[key]); }) : Object.getOwnPropertyDescriptors ? Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)) : ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } return target; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

// Exported for tests
var schemaDefinitionOptions = ['autoValue', 'defaultValue', 'label', 'optional', 'required', 'type'];
exports.schemaDefinitionOptions = schemaDefinitionOptions;
var oneOfProps = ['allowedValues', 'blackbox', 'custom', 'exclusiveMax', 'exclusiveMin', 'max', 'maxCount', 'min', 'minCount', 'regEx', 'skipRegExCheckForEmptyStrings', 'trim', 'type'];
var propsThatCanBeFunction = ['allowedValues', 'exclusiveMax', 'exclusiveMin', 'label', 'max', 'maxCount', 'min', 'minCount', 'optional', 'regEx', 'skipRegExCheckForEmptyStrings'];

var SimpleSchema = /*#__PURE__*/function () {
  function SimpleSchema() {
    var schema = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};
    var options = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : {};

    _classCallCheck(this, SimpleSchema);

    _defineProperty(this, "pick", getPickOrOmit('pick'));

    _defineProperty(this, "omit", getPickOrOmit('omit'));

    // Stash the options object
    this._constructorOptions = _objectSpread(_objectSpread({}, SimpleSchema._constructorOptionDefaults), options);
    delete this._constructorOptions.clean; // stored separately below
    // Schema-level defaults for cleaning

    this._cleanOptions = _objectSpread(_objectSpread({}, SimpleSchema._constructorOptionDefaults.clean), options.clean || {}); // Custom validators for this instance

    this._validators = [];
    this._docValidators = []; // Named validation contexts

    this._validationContexts = {}; // Clone, expanding shorthand, and store the schema object in this._schema

    this._schema = {};
    this._depsLabels = {};
    this.extend(schema); // Clone raw definition and save if keepRawDefinition is active

    this._rawDefinition = this._constructorOptions.keepRawDefinition ? schema : null; // Define default validation error messages

    this.messageBox = new _messageBox.default((0, _clone.default)(_defaultMessages.default));
    this.version = SimpleSchema.version;
  }
  /**
  /* @returns {Object} The entire raw schema definition passed in the constructor
  */


  _createClass(SimpleSchema, [{
    key: "rawDefinition",
    get: function get() {
      return this._rawDefinition;
    }
  }, {
    key: "forEachAncestorSimpleSchema",
    value: function forEachAncestorSimpleSchema(key, func) {
      var _this = this;

      var genericKey = _mongoObject.default.makeKeyGeneric(key);

      (0, _utility.forEachKeyAncestor)(genericKey, function (ancestor) {
        var def = _this._schema[ancestor];
        if (!def) return;
        def.type.definitions.forEach(function (typeDef) {
          if (SimpleSchema.isSimpleSchema(typeDef.type)) {
            func(typeDef.type, ancestor, genericKey.slice(ancestor.length + 1));
          }
        });
      });
    }
    /**
     * Returns whether the obj is a SimpleSchema object.
     * @param {Object} [obj] An object to test
     * @returns {Boolean} True if the given object appears to be a SimpleSchema instance
     */

  }, {
    key: "reactiveLabelDependency",
    value:
    /**
     * For Meteor apps, add a reactive dependency on the label
     * for a key.
     */
    function reactiveLabelDependency(key) {
      var tracker = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : this._constructorOptions.tracker;
      if (!key || !tracker) return;

      var genericKey = _mongoObject.default.makeKeyGeneric(key); // If in this schema


      if (this._schema[genericKey]) {
        if (!this._depsLabels[genericKey]) {
          this._depsLabels[genericKey] = new tracker.Dependency();
        }

        this._depsLabels[genericKey].depend();

        return;
      } // If in subschema


      this.forEachAncestorSimpleSchema(key, function (simpleSchema, ancestor, subSchemaKey) {
        // Pass tracker down so that we get reactivity even if the subschema
        // didn't have tracker option set
        simpleSchema.reactiveLabelDependency(subSchemaKey, tracker);
      });
    }
    /**
     * @param {String} key One specific or generic key for which to get the schema.
     * @returns {[SimpleSchema, String]} Returns a 2-tuple.
     *
     *   First item: The SimpleSchema instance that actually defines the given key.
     *
     *   For example, if you have several nested objects, each their own SimpleSchema
     *   instance, and you pass in 'outerObj.innerObj.innerestObj.name' as the key, you'll
     *   get back the SimpleSchema instance for `outerObj.innerObj.innerestObj` key.
     *
     *   But if you pass in 'outerObj.innerObj.innerestObj.name' as the key and that key is
     *   defined in the main schema without use of subschemas, then you'll get back the main schema.
     *
     *   Second item: The part of the key that is in the found schema.
     *
     *   Always returns a tuple (array) but the values may be `null`.
     */

  }, {
    key: "nearestSimpleSchemaInstance",
    value: function nearestSimpleSchemaInstance(key) {
      if (!key) return [null, null];

      var genericKey = _mongoObject.default.makeKeyGeneric(key);

      if (this._schema[genericKey]) return [this, genericKey]; // If not defined in this schema, see if it's defined in a subschema

      var innerKey;
      var nearestSimpleSchemaInstance;
      this.forEachAncestorSimpleSchema(key, function (simpleSchema, ancestor, subSchemaKey) {
        if (!nearestSimpleSchemaInstance && simpleSchema._schema[subSchemaKey]) {
          nearestSimpleSchemaInstance = simpleSchema;
          innerKey = subSchemaKey;
        }
      });
      return innerKey ? [nearestSimpleSchemaInstance, innerKey] : [null, null];
    }
    /**
     * @param {String} [key] One specific or generic key for which to get the schema.
     * @returns {Object} The entire schema object or just the definition for one key.
     *
     * Note that this returns the raw, unevaluated definition object. Use `getDefinition`
     * if you want the evaluated definition, where any properties that are functions
     * have been run to produce a result.
     */

  }, {
    key: "schema",
    value: function schema(key) {
      if (!key) return this._schema;

      var genericKey = _mongoObject.default.makeKeyGeneric(key);

      var keySchema = this._schema[genericKey]; // If not defined in this schema, see if it's defined in a subschema

      if (!keySchema) {
        var found = false;
        this.forEachAncestorSimpleSchema(key, function (simpleSchema, ancestor, subSchemaKey) {
          if (!found) keySchema = simpleSchema.schema(subSchemaKey);
          if (keySchema) found = true;
        });
      }

      return keySchema;
    }
    /**
     * @returns {Object} The entire schema object with subschemas merged. This is the
     * equivalent of what schema() returned in SimpleSchema < 2.0
     *
     * Note that this returns the raw, unevaluated definition object. Use `getDefinition`
     * if you want the evaluated definition, where any properties that are functions
     * have been run to produce a result.
     */

  }, {
    key: "mergedSchema",
    value: function mergedSchema() {
      var _this2 = this;

      var mergedSchema = {};

      this._schemaKeys.forEach(function (key) {
        var keySchema = _this2._schema[key];
        mergedSchema[key] = keySchema;
        keySchema.type.definitions.forEach(function (typeDef) {
          if (!SimpleSchema.isSimpleSchema(typeDef.type)) return;
          var childSchema = typeDef.type.mergedSchema();
          Object.keys(childSchema).forEach(function (subKey) {
            mergedSchema["".concat(key, ".").concat(subKey)] = childSchema[subKey];
          });
        });
      });

      return mergedSchema;
    }
    /**
     * Returns the evaluated definition for one key in the schema
     *
     * @param {String} key Generic or specific schema key
     * @param {Array(String)} [propList] Array of schema properties you need; performance optimization
     * @param {Object} [functionContext] The context to use when evaluating schema options that are functions
     * @returns {Object} The schema definition for the requested key
     */

  }, {
    key: "getDefinition",
    value: function getDefinition(key, propList) {
      var _this3 = this;

      var functionContext = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : {};
      var defs = this.schema(key);
      if (!defs) return;

      var getPropIterator = function getPropIterator(obj, newObj) {
        return function (prop) {
          if (Array.isArray(propList) && !propList.includes(prop)) return;
          var val = obj[prop]; // For any options that support specifying a function, evaluate the functions

          if (propsThatCanBeFunction.indexOf(prop) > -1 && typeof val === 'function') {
            newObj[prop] = val.call(_objectSpread({
              key: key
            }, functionContext)); // Inflect label if undefined

            if (prop === 'label' && typeof newObj[prop] !== 'string') newObj[prop] = inflectedLabel(key, _this3._constructorOptions.humanizeAutoLabels);
          } else {
            newObj[prop] = val;
          }
        };
      };

      var result = {};
      Object.keys(defs).forEach(getPropIterator(defs, result)); // Resolve all the types and convert to a normal array to make it easier
      // to use.

      if (defs.type) {
        result.type = defs.type.definitions.map(function (typeDef) {
          var newTypeDef = {};
          Object.keys(typeDef).forEach(getPropIterator(typeDef, newTypeDef));
          return newTypeDef;
        });
      }

      return result;
    }
    /**
     * Returns a string identifying the best guess data type for a key. For keys
     * that allow multiple types, the first type is used. This can be useful for
     * building forms.
     *
     * @param {String} key Generic or specific schema key
     * @returns {String} A type string. One of:
     *  string, number, boolean, date, object, stringArray, numberArray, booleanArray,
     *  dateArray, objectArray
     */

  }, {
    key: "getQuickTypeForKey",
    value: function getQuickTypeForKey(key) {
      var type;
      var fieldSchema = this.schema(key);
      if (!fieldSchema) return;
      var fieldType = fieldSchema.type.singleType;

      if (fieldType === String) {
        type = 'string';
      } else if (fieldType === Number || fieldType === SimpleSchema.Integer) {
        type = 'number';
      } else if (fieldType === Boolean) {
        type = 'boolean';
      } else if (fieldType === Date) {
        type = 'date';
      } else if (fieldType === Array) {
        var arrayItemFieldSchema = this.schema("".concat(key, ".$"));
        if (!arrayItemFieldSchema) return;
        var arrayItemFieldType = arrayItemFieldSchema.type.singleType;

        if (arrayItemFieldType === String) {
          type = 'stringArray';
        } else if (arrayItemFieldType === Number || arrayItemFieldType === SimpleSchema.Integer) {
          type = 'numberArray';
        } else if (arrayItemFieldType === Boolean) {
          type = 'booleanArray';
        } else if (arrayItemFieldType === Date) {
          type = 'dateArray';
        } else if (arrayItemFieldType === Object || SimpleSchema.isSimpleSchema(arrayItemFieldType)) {
          type = 'objectArray';
        }
      } else if (fieldType === Object) {
        type = 'object';
      }

      return type;
    }
    /**
     * Given a key that is an Object, returns a new SimpleSchema instance scoped to that object.
     *
     * @param {String} key Generic or specific schema key
     */

  }, {
    key: "getObjectSchema",
    value: function getObjectSchema(key) {
      var newSchemaDef = {};

      var genericKey = _mongoObject.default.makeKeyGeneric(key);

      var searchString = "".concat(genericKey, ".");
      var mergedSchema = this.mergedSchema();
      Object.keys(mergedSchema).forEach(function (k) {
        if (k.indexOf(searchString) === 0) {
          newSchemaDef[k.slice(searchString.length)] = mergedSchema[k];
        }
      });
      return this._copyWithSchema(newSchemaDef);
    } // Returns an array of all the autovalue functions, including those in subschemas all the
    // way down the schema tree

  }, {
    key: "autoValueFunctions",
    value: function autoValueFunctions() {
      var _this4 = this;

      var result = [].concat(this._autoValues);

      this._schemaKeys.forEach(function (key) {
        _this4._schema[key].type.definitions.forEach(function (typeDef) {
          if (!SimpleSchema.isSimpleSchema(typeDef.type)) return;
          result = result.concat(typeDef.type.autoValueFunctions().map(function (_ref) {
            var func = _ref.func,
                fieldName = _ref.fieldName,
                closestSubschemaFieldName = _ref.closestSubschemaFieldName;
            return {
              func: func,
              fieldName: "".concat(key, ".").concat(fieldName),
              closestSubschemaFieldName: closestSubschemaFieldName.length ? "".concat(key, ".").concat(closestSubschemaFieldName) : key
            };
          }));
        });
      });

      return result;
    } // Returns an array of all the blackbox keys, including those in subschemas

  }, {
    key: "blackboxKeys",
    value: function blackboxKeys() {
      var _this5 = this;

      var blackboxKeys = new Set(this._blackboxKeys);

      this._schemaKeys.forEach(function (key) {
        _this5._schema[key].type.definitions.forEach(function (typeDef) {
          if (!SimpleSchema.isSimpleSchema(typeDef.type)) return;
          typeDef.type.blackboxKeys().forEach(function (blackboxKey) {
            blackboxKeys.add("".concat(key, ".").concat(blackboxKey));
          });
        });
      });

      return Array.from(blackboxKeys);
    } // Check if the key is a nested dot-syntax key inside of a blackbox object

  }, {
    key: "keyIsInBlackBox",
    value: function keyIsInBlackBox(key) {
      var _this6 = this;

      var isInBlackBox = false;
      (0, _utility.forEachKeyAncestor)(_mongoObject.default.makeKeyGeneric(key), function (ancestor, remainder) {
        if (_this6._blackboxKeys.has(ancestor)) {
          isInBlackBox = true;
        } else {
          var testKeySchema = _this6.schema(ancestor);

          if (testKeySchema) {
            testKeySchema.type.definitions.forEach(function (typeDef) {
              if (!SimpleSchema.isSimpleSchema(typeDef.type)) return;
              if (typeDef.type.keyIsInBlackBox(remainder)) isInBlackBox = true;
            });
          }
        }
      });
      return isInBlackBox;
    } // Returns true if key is explicitly allowed by the schema or implied
    // by other explicitly allowed keys.
    // The key string should have $ in place of any numeric array positions.

  }, {
    key: "allowsKey",
    value: function allowsKey(key) {
      var _this7 = this;

      // Loop through all keys in the schema
      return this._schemaKeys.some(function (loopKey) {
        // If the schema key is the test key, it's allowed.
        if (loopKey === key) return true;

        var fieldSchema = _this7.schema(loopKey);

        var compare1 = key.slice(0, loopKey.length + 2);
        var compare2 = compare1.slice(0, -1); // Blackbox and subschema checks are needed only if key starts with
        // loopKey + a dot

        if (compare2 !== "".concat(loopKey, ".")) return false; // Black box handling

        if (_this7._blackboxKeys.has(loopKey)) {
          // If the test key is the black box key + ".$", then the test
          // key is NOT allowed because black box keys are by definition
          // only for objects, and not for arrays.
          return compare1 !== "".concat(loopKey, ".$");
        } // Subschemas


        var allowed = false;
        var subKey = key.slice(loopKey.length + 1);
        fieldSchema.type.definitions.forEach(function (typeDef) {
          if (!SimpleSchema.isSimpleSchema(typeDef.type)) return;
          if (typeDef.type.allowsKey(subKey)) allowed = true;
        });
        return allowed;
      });
    }
    /**
     * Returns all the child keys for the object identified by the generic prefix,
     * or all the top level keys if no prefix is supplied.
     *
     * @param {String} [keyPrefix] The Object-type generic key for which to get child keys. Omit for
     *   top-level Object-type keys
     * @returns {[[Type]]} [[Description]]
     */

  }, {
    key: "objectKeys",
    value: function objectKeys(keyPrefix) {
      if (!keyPrefix) return this._firstLevelSchemaKeys;
      var objectKeys = [];

      var setObjectKeys = function setObjectKeys(curSchema, schemaParentKey) {
        Object.keys(curSchema).forEach(function (fieldName) {
          var definition = curSchema[fieldName];
          fieldName = schemaParentKey ? "".concat(schemaParentKey, ".").concat(fieldName) : fieldName;

          if (fieldName.indexOf('.') > -1 && fieldName.slice(-2) !== '.$') {
            var parentKey = fieldName.slice(0, fieldName.lastIndexOf('.'));
            var parentKeyWithDot = "".concat(parentKey, ".");
            objectKeys[parentKeyWithDot] = objectKeys[parentKeyWithDot] || [];
            objectKeys[parentKeyWithDot].push(fieldName.slice(fieldName.lastIndexOf('.') + 1));
          } // If the current field is a nested SimpleSchema,
          // iterate over the child fields and cache their properties as well


          definition.type.definitions.forEach(function (_ref2) {
            var type = _ref2.type;

            if (SimpleSchema.isSimpleSchema(type)) {
              setObjectKeys(type._schema, fieldName);
            }
          });
        });
      };

      setObjectKeys(this._schema);
      return objectKeys["".concat(keyPrefix, ".")] || [];
    }
    /**
     * Copies this schema into a new instance with the same validators, messages,
     * and options, but with different keys as defined in `schema` argument
     *
     * @param {Object} schema
     * @returns The new SimpleSchema instance (chainable)
     */

  }, {
    key: "_copyWithSchema",
    value: function _copyWithSchema(schema) {
      var cl = new SimpleSchema(schema, _objectSpread({}, this._constructorOptions));
      cl._cleanOptions = this._cleanOptions;
      cl.messageBox = this.messageBox.clone();
      return cl;
    }
    /**
     * Clones this schema into a new instance with the same schema keys, validators,
     * and options.
     *
     * @returns The new SimpleSchema instance (chainable)
     */

  }, {
    key: "clone",
    value: function clone() {
      return this._copyWithSchema(this._schema);
    }
    /**
     * Extends (mutates) this schema with another schema, key by key.
     *
     * @param {SimpleSchema|Object} schema
     * @returns The SimpleSchema instance (chainable)
     */

  }, {
    key: "extend",
    value: function extend() {
      var _this8 = this;

      var schema = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};
      if (Array.isArray(schema)) throw new Error('You may not pass an array of schemas to the SimpleSchema constructor or to extend()');
      var schemaObj;

      if (SimpleSchema.isSimpleSchema(schema)) {
        schemaObj = schema._schema;
        this._validators = this._validators.concat(schema._validators);
        this._docValidators = this._docValidators.concat(schema._docValidators);
        Object.assign(this._cleanOptions, schema._cleanOptions);
        Object.assign(this._constructorOptions, schema._constructorOptions);
      } else {
        schemaObj = (0, _expandShorthand.default)(schema);
      }

      var schemaKeys = Object.keys(schemaObj);
      var combinedKeys = new Set([].concat(_toConsumableArray(Object.keys(this._schema)), _toConsumableArray(schemaKeys))); // Update all of the information cached on the instance

      schemaKeys.forEach(function (fieldName) {
        var definition = standardizeDefinition(schemaObj[fieldName]); // Merge/extend with any existing definition

        if (_this8._schema[fieldName]) {
          if (!Object.prototype.hasOwnProperty.call(_this8._schema, fieldName)) {
            // fieldName is actually a method from Object itself!
            throw new Error("".concat(fieldName, " key is actually the name of a method on Object, please rename it"));
          }

          var type = definition.type,
              definitionWithoutType = _objectWithoutProperties(definition, _excluded); // eslint-disable-line no-unused-vars


          _this8._schema[fieldName] = _objectSpread(_objectSpread({}, _this8._schema[fieldName]), definitionWithoutType);
          if (definition.type) _this8._schema[fieldName].type.extend(definition.type);
        } else {
          _this8._schema[fieldName] = definition;
        }

        checkAndScrubDefinition(fieldName, _this8._schema[fieldName], _this8._constructorOptions, combinedKeys);
      });
      checkSchemaOverlap(this._schema); // Set/Reset all of these

      this._schemaKeys = Object.keys(this._schema);
      this._autoValues = [];
      this._blackboxKeys = new Set();
      this._firstLevelSchemaKeys = []; // Update all of the information cached on the instance

      this._schemaKeys.forEach(function (fieldName) {
        // Make sure parent has a definition in the schema. No implied objects!
        if (fieldName.indexOf('.') > -1) {
          var parentFieldName = fieldName.slice(0, fieldName.lastIndexOf('.'));
          if (!Object.prototype.hasOwnProperty.call(_this8._schema, parentFieldName)) throw new Error("\"".concat(fieldName, "\" is in the schema but \"").concat(parentFieldName, "\" is not"));
        }

        var definition = _this8._schema[fieldName]; // Keep list of all top level keys

        if (fieldName.indexOf('.') === -1) _this8._firstLevelSchemaKeys.push(fieldName); // Keep list of all blackbox keys for passing to MongoObject constructor
        // XXX For now if any oneOf type is blackbox, then the whole field is.

        /* eslint-disable no-restricted-syntax */

        var _iterator = _createForOfIteratorHelper(definition.type.definitions),
            _step;

        try {
          for (_iterator.s(); !(_step = _iterator.n()).done;) {
            var oneOfDef = _step.value;

            // XXX If the type is SS.Any, also consider it a blackbox
            if (oneOfDef.blackbox === true || oneOfDef.type === SimpleSchema.Any) {
              _this8._blackboxKeys.add(fieldName);

              break;
            }
          }
          /* eslint-enable no-restricted-syntax */
          // Keep list of autoValue functions

        } catch (err) {
          _iterator.e(err);
        } finally {
          _iterator.f();
        }

        if (typeof definition.autoValue === 'function') {
          _this8._autoValues.push({
            closestSubschemaFieldName: '',
            fieldName: fieldName,
            func: definition.autoValue
          });
        }
      });

      return this;
    }
  }, {
    key: "getAllowedValuesForKey",
    value: function getAllowedValuesForKey(key) {
      // For array fields, `allowedValues` is on the array item definition
      if (this.allowsKey("".concat(key, ".$"))) {
        key = "".concat(key, ".$");
      }

      var allowedValues = this.get(key, 'allowedValues');

      if (Array.isArray(allowedValues) || allowedValues instanceof Set) {
        return _toConsumableArray(allowedValues);
      }

      return null;
    }
  }, {
    key: "newContext",
    value: function newContext() {
      return new _ValidationContext.default(this);
    }
  }, {
    key: "namedContext",
    value: function namedContext(name) {
      if (typeof name !== 'string') name = 'default';

      if (!this._validationContexts[name]) {
        this._validationContexts[name] = new _ValidationContext.default(this, name);
      }

      return this._validationContexts[name];
    }
  }, {
    key: "addValidator",
    value: function addValidator(func) {
      this._validators.push(func);
    }
  }, {
    key: "addDocValidator",
    value: function addDocValidator(func) {
      this._docValidators.push(func);
    }
    /**
     * @param obj {Object|Object[]} Object or array of objects to validate.
     * @param [options] {Object} Same options object that ValidationContext#validate takes
     *
     * Throws an Error with name `ClientError` and `details` property containing the errors.
     */

  }, {
    key: "validate",
    value: function validate(obj) {
      var _this9 = this;

      var options = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : {};
      // For Meteor apps, `check` option can be passed to silence audit-argument-checks
      var check = options.check || this._constructorOptions.check;

      if (typeof check === 'function') {
        // Call check but ignore the error
        try {
          check(obj);
        } catch (e) {
          /* ignore error */
        }
      } // obj can be an array, in which case we validate each object in it and
      // throw as soon as one has an error


      var objects = Array.isArray(obj) ? obj : [obj];
      objects.forEach(function (oneObj) {
        var validationContext = _this9.newContext();

        var isValid = validationContext.validate(oneObj, options);
        if (isValid) return;
        var errors = validationContext.validationErrors(); // In order for the message at the top of the stack trace to be useful,
        // we set it to the first validation error message.

        var message = _this9.messageForError(errors[0]);

        var error = new Error(message);
        error.errorType = 'ClientError';
        error.name = 'ClientError';
        error.error = 'validation-error'; // Add meaningful error messages for each validation error.
        // Useful for display messages when using 'mdg:validated-method'.

        error.details = errors.map(function (errorDetail) {
          return _objectSpread(_objectSpread({}, errorDetail), {}, {
            message: _this9.messageForError(errorDetail)
          });
        }); // The primary use for the validationErrorTransform is to convert the
        // vanilla Error into a Meteor.Error until DDP is able to pass
        // vanilla errors back to the client.

        if (typeof SimpleSchema.validationErrorTransform === 'function') {
          throw SimpleSchema.validationErrorTransform(error);
        } else {
          throw error;
        }
      });
    }
    /**
     * @param obj {Object} Object to validate.
     * @param [options] {Object} Same options object that ValidationContext#validate takes
     *
     * Returns a Promise that resolves with the errors
     */

  }, {
    key: "validateAndReturnErrorsPromise",
    value: function validateAndReturnErrorsPromise(obj, options) {
      var _this10 = this;

      var validationContext = this.newContext();
      var isValid = validationContext.validate(obj, options);
      if (isValid) return Promise.resolve([]); // Add the `message` prop

      var errors = validationContext.validationErrors().map(function (errorDetail) {
        return _objectSpread(_objectSpread({}, errorDetail), {}, {
          message: _this10.messageForError(errorDetail)
        });
      });
      return Promise.resolve(errors);
    }
  }, {
    key: "validator",
    value: function validator() {
      var _this11 = this;

      var options = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};
      return function (obj) {
        var optionsClone = _objectSpread({}, options);

        if (options.clean === true) {
          // Do this here and pass into both functions for better performance
          optionsClone.mongoObject = new _mongoObject.default(obj, _this11.blackboxKeys());

          _this11.clean(obj, optionsClone);
        }

        if (options.returnErrorsPromise) {
          return _this11.validateAndReturnErrorsPromise(obj, optionsClone);
        }

        return _this11.validate(obj, optionsClone);
      };
    }
  }, {
    key: "getFormValidator",
    value: function getFormValidator() {
      var options = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};
      return this.validator(_objectSpread(_objectSpread({}, options), {}, {
        returnErrorsPromise: true
      }));
    }
  }, {
    key: "clean",
    value: function clean() {
      for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
        args[_key] = arguments[_key];
      }

      return _clean2.default.apply(void 0, [this].concat(args));
    }
    /**
     * Change schema labels on the fly, causing mySchema.label computation
     * to rerun. Useful when the user changes the language.
     *
     * @param {Object} labels A dictionary of all the new label values, by schema key.
     */

  }, {
    key: "labels",
    value: function labels(_labels) {
      var _this12 = this;

      Object.keys(_labels).forEach(function (key) {
        var label = _labels[key];
        if (typeof label !== 'string' && typeof label !== 'function') return;

        var _this12$nearestSimple = _this12.nearestSimpleSchemaInstance(key),
            _this12$nearestSimple2 = _slicedToArray(_this12$nearestSimple, 2),
            schemaInstance = _this12$nearestSimple2[0],
            innerKey = _this12$nearestSimple2[1];

        if (!schemaInstance) return;
        schemaInstance._schema[innerKey].label = label;
        schemaInstance._depsLabels[innerKey] && schemaInstance._depsLabels[innerKey].changed();
      });
    }
    /**
     * Gets a field's label or all field labels reactively.
     *
     * @param {String} [key] The schema key, specific or generic.
     *   Omit this argument to get a dictionary of all labels.
     * @returns {String} The label
     */

  }, {
    key: "label",
    value: function label(key) {
      var _this13 = this;

      // Get all labels
      if (key === null || key === undefined) {
        var result = {};

        this._schemaKeys.forEach(function (schemaKey) {
          result[schemaKey] = _this13.label(schemaKey);
        });

        return result;
      } // Get label for one field


      var label = this.get(key, 'label');
      if (label) this.reactiveLabelDependency(key);
      return label || null;
    }
    /**
     * Gets a field's property
     *
     * @param {String} key The schema key, specific or generic.
     * @param {String} prop Name of the property to get for that schema key
     * @param {Object} [functionContext] The `this` context to use if prop is a function
     * @returns {any} The property value
     */

  }, {
    key: "get",
    value: function get(key, prop, functionContext) {
      var def = this.getDefinition(key, ['type', prop], functionContext);
      if (!def) return undefined;

      if (schemaDefinitionOptions.includes(prop)) {
        return def[prop];
      }

      return (def.type.find(function (props) {
        return props[prop];
      }) || {})[prop];
    } // shorthand for getting defaultValue

  }, {
    key: "defaultValue",
    value: function defaultValue(key) {
      return this.get(key, 'defaultValue');
    } // Returns a string message for the given error type and key. Passes through
    // to message-box pkg.

  }, {
    key: "messageForError",
    value: function messageForError(errorInfo) {
      var name = errorInfo.name;
      return this.messageBox.message(errorInfo, {
        context: {
          key: name,
          // backward compatibility
          // The call to this.label() establishes a reactive dependency, too
          label: this.label(name)
        }
      });
    }
    /**
     * @method SimpleSchema#pick
     * @param {[fields]} The list of fields to pick to instantiate the subschema
     * @returns {SimpleSchema} The subschema
     */

  }], [{
    key: "isSimpleSchema",
    value: function isSimpleSchema(obj) {
      return obj && (obj instanceof SimpleSchema || obj._schema);
    }
  }, {
    key: "extendOptions",
    value: // If you need to allow properties other than those listed above, call this from your app or package
    function extendOptions(options) {
      // For backwards compatibility we still take an object here, but we only care about the names
      if (!Array.isArray(options)) options = Object.keys(options);
      options.forEach(function (option) {
        schemaDefinitionOptions.push(option);
      });
    }
  }, {
    key: "defineValidationErrorTransform",
    value: function defineValidationErrorTransform(transform) {
      if (typeof transform !== 'function') {
        throw new Error('SimpleSchema.defineValidationErrorTransform must be passed a function that accepts an Error and returns an Error');
      }

      SimpleSchema.validationErrorTransform = transform;
    }
  }, {
    key: "validate",
    value: function validate(obj, schema, options) {
      // Allow passing just the schema object
      if (!SimpleSchema.isSimpleSchema(schema)) {
        schema = new SimpleSchema(schema);
      }

      return schema.validate(obj, options);
    }
  }, {
    key: "oneOf",
    value: function oneOf() {
      for (var _len2 = arguments.length, definitions = new Array(_len2), _key2 = 0; _key2 < _len2; _key2++) {
        definitions[_key2] = arguments[_key2];
      }

      return _construct(_SimpleSchemaGroup.default, definitions);
    }
  }, {
    key: "addValidator",
    value: function addValidator(func) {
      SimpleSchema._validators.push(func);
    }
  }, {
    key: "addDocValidator",
    value: function addDocValidator(func) {
      SimpleSchema._docValidators.push(func);
    } // Global constructor options

  }, {
    key: "constructorOptionDefaults",
    value:
    /**
     * @summary Get/set default values for SimpleSchema constructor options
     */
    function constructorOptionDefaults(options) {
      if (!options) return SimpleSchema._constructorOptionDefaults;
      SimpleSchema._constructorOptionDefaults = _objectSpread(_objectSpread(_objectSpread({}, SimpleSchema._constructorOptionDefaults), options), {}, {
        clean: _objectSpread(_objectSpread({}, SimpleSchema._constructorOptionDefaults.clean), options.clean || {})
      });
    }
  }]);

  return SimpleSchema;
}();
/*
 * PRIVATE
 */
// Throws an error if any fields are `type` SimpleSchema but then also
// have subfields defined outside of that.


exports.SimpleSchema = SimpleSchema;

_defineProperty(SimpleSchema, "version", 2);

_defineProperty(SimpleSchema, "Any", '___Any___');

_defineProperty(SimpleSchema, "RegEx", _regExp.default);

_defineProperty(SimpleSchema, "_validators", []);

_defineProperty(SimpleSchema, "_docValidators", []);

_defineProperty(SimpleSchema, "_constructorOptionDefaults", {
  clean: {
    autoConvert: true,
    extendAutoValueContext: {},
    filter: true,
    getAutoValues: true,
    removeEmptyStrings: true,
    removeNullsFromArrays: false,
    trimStrings: true
  },
  humanizeAutoLabels: true,
  requiredByDefault: true
});

_defineProperty(SimpleSchema, "ErrorTypes", {
  REQUIRED: 'required',
  MIN_STRING: 'minString',
  MAX_STRING: 'maxString',
  MIN_NUMBER: 'minNumber',
  MAX_NUMBER: 'maxNumber',
  MIN_NUMBER_EXCLUSIVE: 'minNumberExclusive',
  MAX_NUMBER_EXCLUSIVE: 'maxNumberExclusive',
  MIN_DATE: 'minDate',
  MAX_DATE: 'maxDate',
  BAD_DATE: 'badDate',
  MIN_COUNT: 'minCount',
  MAX_COUNT: 'maxCount',
  MUST_BE_INTEGER: 'noDecimal',
  VALUE_NOT_ALLOWED: 'notAllowed',
  EXPECTED_TYPE: 'expectedType',
  FAILED_REGULAR_EXPRESSION: 'regEx',
  KEY_NOT_IN_SCHEMA: 'keyNotInSchema'
});

_defineProperty(SimpleSchema, "Integer", 'SimpleSchema.Integer');

_defineProperty(SimpleSchema, "_makeGeneric", _mongoObject.default.makeKeyGeneric);

_defineProperty(SimpleSchema, "ValidationContext", _ValidationContext.default);

_defineProperty(SimpleSchema, "setDefaultMessages", function (messages) {
  (0, _utility.merge)(_defaultMessages.default, messages);
});

function checkSchemaOverlap(schema) {
  Object.keys(schema).forEach(function (key) {
    var val = schema[key];
    if (!val.type) throw new Error("".concat(key, " key is missing \"type\""));
    val.type.definitions.forEach(function (def) {
      if (!SimpleSchema.isSimpleSchema(def.type)) return;
      Object.keys(def.type._schema).forEach(function (subKey) {
        var newKey = "".concat(key, ".").concat(subKey);

        if (Object.prototype.hasOwnProperty.call(schema, newKey)) {
          throw new Error("The type for \"".concat(key, "\" is set to a SimpleSchema instance that defines \"").concat(key, ".").concat(subKey, "\", but the parent SimpleSchema instance also tries to define \"").concat(key, ".").concat(subKey, "\""));
        }
      });
    });
  });
}
/**
 * @param {String} fieldName The full generic schema key
 * @param {Boolean} shouldHumanize Humanize it
 * @returns {String} A label based on the key
 */


function inflectedLabel(fieldName, shouldHumanize) {
  var pieces = fieldName.split('.');
  var label;

  do {
    label = pieces.pop();
  } while (label === '$' && pieces.length);

  return shouldHumanize ? (0, _humanize.default)(label) : label;
}

function getDefaultAutoValueFunction(defaultValue) {
  return function defaultAutoValueFunction() {
    if (this.isSet) return;
    if (this.operator === null) return defaultValue; // Handle the case when pulling an object from an array the object contains a field
    // which has a defaultValue. We don't want the default value to be returned in this case

    if (this.operator === '$pull') return; // Handle the case where we are $pushing an object into an array of objects and we
    // want any fields missing from that object to be added if they have default values

    if (this.operator === '$push') return defaultValue; // If parent is set, we should update this position instead of $setOnInsert

    if (this.parentField().isSet) return defaultValue; // Make sure the default value is added on upsert insert

    if (this.isUpsert) return {
      $setOnInsert: defaultValue
    };
  };
} // Mutates def into standardized object with SimpleSchemaGroup type


function standardizeDefinition(def) {
  var standardizedDef = Object.keys(def).reduce(function (newDef, prop) {
    if (!oneOfProps.includes(prop)) {
      newDef[prop] = def[prop];
    }

    return newDef;
  }, {}); // Internally, all definition types are stored as groups for simplicity of access.
  // If we are extending, there may not actually be def.type, but it's okay because
  // it will be added later when the two SimpleSchemaGroups are merged.

  if (def.type && def.type instanceof _SimpleSchemaGroup.default) {
    standardizedDef.type = def.type.clone();
  } else {
    var groupProps = Object.keys(def).reduce(function (newDef, prop) {
      if (oneOfProps.includes(prop)) {
        newDef[prop] = def[prop];
      }

      return newDef;
    }, {});
    standardizedDef.type = new _SimpleSchemaGroup.default(groupProps);
  }

  return standardizedDef;
}
/**
 * @summary Checks and mutates definition. Clone it first.
 *   Throws errors if any problems are found.
 * @param {String} fieldName Name of field / key
 * @param {Object} definition Field definition
 * @param {Object} options Options
 * @param {Set} allKeys Set of all field names / keys in entire schema
 * @return {undefined} Void
 */


function checkAndScrubDefinition(fieldName, definition, options, allKeys) {
  if (!definition.type) throw new Error("".concat(fieldName, " key is missing \"type\"")); // Validate the field definition

  Object.keys(definition).forEach(function (key) {
    if (schemaDefinitionOptions.indexOf(key) === -1) {
      throw new Error("Invalid definition for ".concat(fieldName, " field: \"").concat(key, "\" is not a supported property"));
    }
  }); // Make sure the `type`s are OK

  var couldBeArray = false;
  definition.type.definitions.forEach(function (_ref3) {
    var type = _ref3.type;
    if (!type) throw new Error("Invalid definition for ".concat(fieldName, " field: \"type\" option is required"));

    if (Array.isArray(type)) {
      throw new Error("Invalid definition for ".concat(fieldName, " field: \"type\" may not be an array. Change it to Array."));
    }

    if (type.constructor === Object && (0, _utility.isEmptyObject)(type)) {
      throw new Error("Invalid definition for ".concat(fieldName, " field: \"type\" may not be an object. Change it to Object"));
    }

    if (type === Array) couldBeArray = true;

    if (SimpleSchema.isSimpleSchema(type)) {
      Object.keys(type._schema).forEach(function (subKey) {
        var newKey = "".concat(fieldName, ".").concat(subKey);

        if (allKeys.has(newKey)) {
          throw new Error("The type for \"".concat(fieldName, "\" is set to a SimpleSchema instance that defines \"").concat(newKey, "\", but the parent SimpleSchema instance also tries to define \"").concat(newKey, "\""));
        }
      });
    }
  }); // If at least one of the possible types is Array, then make sure we have a
  // definition for the array items, too.

  if (couldBeArray && !allKeys.has("".concat(fieldName, ".$"))) {
    throw new Error("\"".concat(fieldName, "\" is Array type but the schema does not include a \"").concat(fieldName, ".$\" definition for the array items\""));
  } // defaultValue -> autoValue
  // We support defaultValue shortcut by converting it immediately into an
  // autoValue.


  if ('defaultValue' in definition) {
    if ('autoValue' in definition && !definition.autoValue.isDefault) {
      console.warn("SimpleSchema: Found both autoValue and defaultValue options for \"".concat(fieldName, "\". Ignoring defaultValue."));
    } else {
      if (fieldName.endsWith('.$')) {
        throw new Error('An array item field (one that ends with ".$") cannot have defaultValue.');
      }

      definition.autoValue = getDefaultAutoValueFunction(definition.defaultValue);
      definition.autoValue.isDefault = true;
    }
  } // REQUIREDNESS


  if (fieldName.endsWith('.$')) {
    definition.optional = true;
  } else if (!Object.prototype.hasOwnProperty.call(definition, 'optional')) {
    if (Object.prototype.hasOwnProperty.call(definition, 'required')) {
      if (typeof definition.required === 'function') {
        // Save a reference to the `required` fn because
        // we are going to delete it from `definition` below
        var requiredFn = definition.required;

        definition.optional = function optional() {
          for (var _len3 = arguments.length, args = new Array(_len3), _key3 = 0; _key3 < _len3; _key3++) {
            args[_key3] = arguments[_key3];
          }

          return !requiredFn.apply(this, args);
        };
      } else {
        definition.optional = !definition.required;
      }
    } else {
      definition.optional = options.requiredByDefault === false;
    }
  }

  delete definition.required; // LABELS

  if (!Object.prototype.hasOwnProperty.call(definition, 'label')) {
    if (options.defaultLabel) {
      definition.label = options.defaultLabel;
    } else if (SimpleSchema.defaultLabel) {
      definition.label = SimpleSchema.defaultLabel;
    } else {
      definition.label = inflectedLabel(fieldName, options.humanizeAutoLabels);
    }
  }
}

function getPickOrOmit(type) {
  return function pickOrOmit() {
    var _this14 = this;

    for (var _len4 = arguments.length, args = new Array(_len4), _key4 = 0; _key4 < _len4; _key4++) {
      args[_key4] = arguments[_key4];
    }

    // If they are picking/omitting an object or array field, we need to also include everything under it
    var newSchema = {};

    this._schemaKeys.forEach(function (key) {
      // Pick/omit it if it IS in the array of keys they want OR if it
      // STARTS WITH something that is in the array plus a period
      var includeIt = args.some(function (wantedField) {
        return key === wantedField || key.indexOf("".concat(wantedField, ".")) === 0;
      });

      if (includeIt && type === 'pick' || !includeIt && type === 'omit') {
        newSchema[key] = _this14._schema[key];
      }
    });

    return this._copyWithSchema(newSchema);
  };
}