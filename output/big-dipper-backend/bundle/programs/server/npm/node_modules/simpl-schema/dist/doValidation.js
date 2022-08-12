"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;

var _mongoObject = _interopRequireDefault(require("mongo-object"));

var _SimpleSchema = require("./SimpleSchema");

var _utility = require("./utility");

var _typeValidator = _interopRequireDefault(require("./validation/typeValidator"));

var _requiredValidator = _interopRequireDefault(require("./validation/requiredValidator"));

var _allowedValuesValidator = _interopRequireDefault(require("./validation/allowedValuesValidator"));

var _excluded = ["type"];

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _toConsumableArray(arr) { return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _unsupportedIterableToArray(arr) || _nonIterableSpread(); }

function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _iterableToArray(iter) { if (typeof Symbol !== "undefined" && iter[Symbol.iterator] != null || iter["@@iterator"] != null) return Array.from(iter); }

function _arrayWithoutHoles(arr) { if (Array.isArray(arr)) return _arrayLikeToArray(arr); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _objectWithoutProperties(source, excluded) { if (source == null) return {}; var target = _objectWithoutPropertiesLoose(source, excluded); var key, i; if (Object.getOwnPropertySymbols) { var sourceSymbolKeys = Object.getOwnPropertySymbols(source); for (i = 0; i < sourceSymbolKeys.length; i++) { key = sourceSymbolKeys[i]; if (excluded.indexOf(key) >= 0) continue; if (!Object.prototype.propertyIsEnumerable.call(source, key)) continue; target[key] = source[key]; } } return target; }

function _objectWithoutPropertiesLoose(source, excluded) { if (source == null) return {}; var target = {}; var sourceKeys = Object.keys(source); var key, i; for (i = 0; i < sourceKeys.length; i++) { key = sourceKeys[i]; if (excluded.indexOf(key) >= 0) continue; target[key] = source[key]; } return target; }

function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); enumerableOnly && (symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; })), keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = null != arguments[i] ? arguments[i] : {}; i % 2 ? ownKeys(Object(source), !0).forEach(function (key) { _defineProperty(target, key, source[key]); }) : Object.getOwnPropertyDescriptors ? Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)) : ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

function _typeof(obj) { "@babel/helpers - typeof"; return _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (obj) { return typeof obj; } : function (obj) { return obj && "function" == typeof Symbol && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }, _typeof(obj); }

function shouldCheck(key) {
  if (key === '$pushAll') throw new Error('$pushAll is not supported; use $push + $each');
  return ['$pull', '$pullAll', '$pop', '$slice'].indexOf(key) === -1;
}

function doValidation(_ref) {
  var extendedCustomContext = _ref.extendedCustomContext,
      ignoreTypes = _ref.ignoreTypes,
      isModifier = _ref.isModifier,
      isUpsert = _ref.isUpsert,
      keysToValidate = _ref.keysToValidate,
      mongoObject = _ref.mongoObject,
      obj = _ref.obj,
      schema = _ref.schema,
      validationContext = _ref.validationContext;

  // First do some basic checks of the object, and throw errors if necessary
  if (!obj || _typeof(obj) !== 'object' && typeof obj !== 'function') {
    throw new Error('The first argument of validate() must be an object');
  }

  if (!isModifier && (0, _utility.looksLikeModifier)(obj)) {
    throw new Error('When the validation object contains mongo operators, you must set the modifier option to true');
  }

  function getFieldInfo(key) {
    // Create mongoObject if necessary, cache for speed
    if (!mongoObject) mongoObject = new _mongoObject.default(obj, schema.blackboxKeys());
    var keyInfo = mongoObject.getInfoForKey(key) || {};
    return {
      isSet: keyInfo.value !== undefined,
      value: keyInfo.value,
      operator: keyInfo.operator || null
    };
  }

  var validationErrors = []; // Validation function called for each affected key

  function validate(val, affectedKey, affectedKeyGeneric, def, op, isInArrayItemObject, isInSubObject) {
    // Get the schema for this key, marking invalid if there isn't one.
    if (!def) {
      // We don't need KEY_NOT_IN_SCHEMA error for $unset and we also don't need to continue
      if (op === '$unset' || op === '$currentDate' && affectedKey.endsWith('.$type')) return;
      validationErrors.push({
        name: affectedKey,
        type: _SimpleSchema.SimpleSchema.ErrorTypes.KEY_NOT_IN_SCHEMA,
        value: val
      });
      return;
    } // For $rename, make sure that the new name is allowed by the schema


    if (op === '$rename' && !schema.allowsKey(val)) {
      validationErrors.push({
        name: val,
        type: _SimpleSchema.SimpleSchema.ErrorTypes.KEY_NOT_IN_SCHEMA,
        value: null
      });
      return;
    } // Prepare the context object for the validator functions


    var fieldParentNameWithEndDot = (0, _utility.getParentOfKey)(affectedKey, true);
    var fieldParentName = fieldParentNameWithEndDot.slice(0, -1);
    var fieldValidationErrors = [];

    var validatorContext = _objectSpread({
      addValidationErrors: function addValidationErrors(errors) {
        errors.forEach(function (error) {
          return fieldValidationErrors.push(error);
        });
      },
      field: function field(fName) {
        return getFieldInfo(fName);
      },
      genericKey: affectedKeyGeneric,
      isInArrayItemObject: isInArrayItemObject,
      isInSubObject: isInSubObject,
      isModifier: isModifier,
      isSet: val !== undefined,
      key: affectedKey,
      obj: obj,
      operator: op,
      parentField: function parentField() {
        return getFieldInfo(fieldParentName);
      },
      siblingField: function siblingField(fName) {
        return getFieldInfo(fieldParentNameWithEndDot + fName);
      },
      validationContext: validationContext,
      value: val,
      // Value checks are not necessary for null or undefined values, except
      // for non-optional null array items, or for $unset or $rename values
      valueShouldBeChecked: op !== '$unset' && op !== '$rename' && (val !== undefined && val !== null || affectedKeyGeneric.slice(-2) === '.$' && val === null && !def.optional)
    }, extendedCustomContext || {});

    var builtInValidators = [_requiredValidator.default, _typeValidator.default, _allowedValuesValidator.default];
    var validators = builtInValidators.concat(schema._validators).concat(_SimpleSchema.SimpleSchema._validators); // Loop through each of the definitions in the SimpleSchemaGroup.
    // If any return true, we're valid.

    var fieldIsValid = def.type.some(function (typeDef) {
      // If the type is SimpleSchema.Any, then it is valid:
      if (typeDef === _SimpleSchema.SimpleSchema.Any) return true;

      var type = def.type,
          definitionWithoutType = _objectWithoutProperties(def, _excluded); // eslint-disable-line no-unused-vars


      var finalValidatorContext = _objectSpread(_objectSpread({}, validatorContext), {}, {
        // Take outer definition props like "optional" and "label"
        // and add them to inner props like "type" and "min"
        definition: _objectSpread(_objectSpread({}, definitionWithoutType), typeDef)
      }); // Add custom field validators to the list after the built-in
      // validators but before the schema and global validators.


      var fieldValidators = validators.slice(0);

      if (typeof typeDef.custom === 'function') {
        fieldValidators.splice(builtInValidators.length, 0, typeDef.custom);
      } // We use _.every just so that we don't continue running more validator
      // functions after the first one returns false or an error string.


      return fieldValidators.every(function (validator) {
        var result = validator.call(finalValidatorContext); // If the validator returns a string, assume it is the
        // error type.

        if (typeof result === 'string') {
          fieldValidationErrors.push({
            name: affectedKey,
            type: result,
            value: val
          });
          return false;
        } // If the validator returns an object, assume it is an
        // error object.


        if (_typeof(result) === 'object' && result !== null) {
          fieldValidationErrors.push(_objectSpread({
            name: affectedKey,
            value: val
          }, result));
          return false;
        } // If the validator returns false, assume they already
        // called this.addValidationErrors within the function


        if (result === false) return false; // Any other return value we assume means it was valid

        return true;
      });
    });

    if (!fieldIsValid) {
      validationErrors = validationErrors.concat(fieldValidationErrors);
    }
  } // The recursive function


  function checkObj(_ref2) {
    var val = _ref2.val,
        affectedKey = _ref2.affectedKey,
        operator = _ref2.operator,
        _ref2$isInArrayItemOb = _ref2.isInArrayItemObject,
        isInArrayItemObject = _ref2$isInArrayItemOb === void 0 ? false : _ref2$isInArrayItemOb,
        _ref2$isInSubObject = _ref2.isInSubObject,
        isInSubObject = _ref2$isInSubObject === void 0 ? false : _ref2$isInSubObject;
    var affectedKeyGeneric;
    var def;

    if (affectedKey) {
      // When we hit a blackbox key, we don't progress any further
      if (schema.keyIsInBlackBox(affectedKey)) return; // Make a generic version of the affected key, and use that
      // to get the schema for this key.

      affectedKeyGeneric = _mongoObject.default.makeKeyGeneric(affectedKey);
      var shouldValidateKey = !keysToValidate || keysToValidate.some(function (keyToValidate) {
        return keyToValidate === affectedKey || keyToValidate === affectedKeyGeneric || affectedKey.startsWith("".concat(keyToValidate, ".")) || affectedKeyGeneric.startsWith("".concat(keyToValidate, "."));
      }); // Prepare the context object for the rule functions

      var fieldParentNameWithEndDot = (0, _utility.getParentOfKey)(affectedKey, true);
      var fieldParentName = fieldParentNameWithEndDot.slice(0, -1);

      var functionsContext = _objectSpread({
        field: function field(fName) {
          return getFieldInfo(fName);
        },
        genericKey: affectedKeyGeneric,
        isInArrayItemObject: isInArrayItemObject,
        isInSubObject: isInSubObject,
        isModifier: isModifier,
        isSet: val !== undefined,
        key: affectedKey,
        obj: obj,
        operator: operator,
        parentField: function parentField() {
          return getFieldInfo(fieldParentName);
        },
        siblingField: function siblingField(fName) {
          return getFieldInfo(fieldParentNameWithEndDot + fName);
        },
        validationContext: validationContext,
        value: val
      }, extendedCustomContext || {}); // Perform validation for this key


      def = schema.getDefinition(affectedKey, null, functionsContext);

      if (shouldValidateKey) {
        validate(val, affectedKey, affectedKeyGeneric, def, operator, isInArrayItemObject, isInSubObject);
      }
    } // If affectedKeyGeneric is undefined due to this being the first run of this
    // function, objectKeys will return the top-level keys.


    var childKeys = schema.objectKeys(affectedKeyGeneric); // Temporarily convert missing objects to empty objects
    // so that the looping code will be called and required
    // descendent keys can be validated.

    if ((val === undefined || val === null) && (!def || !def.optional && childKeys && childKeys.length > 0)) {
      val = {};
    } // Loop through arrays


    if (Array.isArray(val)) {
      val.forEach(function (v, i) {
        checkObj({
          val: v,
          affectedKey: "".concat(affectedKey, ".").concat(i),
          operator: operator
        });
      });
    } else if ((0, _utility.isObjectWeShouldTraverse)(val) && (!def || !schema._blackboxKeys.has(affectedKey))) {
      // Loop through object keys
      // Get list of present keys
      var presentKeys = Object.keys(val); // If this object is within an array, make sure we check for
      // required as if it's not a modifier

      isInArrayItemObject = affectedKeyGeneric && affectedKeyGeneric.slice(-2) === '.$';
      var checkedKeys = []; // Check all present keys plus all keys defined by the schema.
      // This allows us to detect extra keys not allowed by the schema plus
      // any missing required keys, and to run any custom functions for other keys.

      /* eslint-disable no-restricted-syntax */

      for (var _i = 0, _arr = [].concat(_toConsumableArray(presentKeys), _toConsumableArray(childKeys)); _i < _arr.length; _i++) {
        var key = _arr[_i];
        // `childKeys` and `presentKeys` may contain the same keys, so make
        // sure we run only once per unique key
        if (checkedKeys.indexOf(key) !== -1) continue;
        checkedKeys.push(key);
        checkObj({
          val: val[key],
          affectedKey: (0, _utility.appendAffectedKey)(affectedKey, key),
          operator: operator,
          isInArrayItemObject: isInArrayItemObject,
          isInSubObject: true
        });
      }
      /* eslint-enable no-restricted-syntax */

    }
  }

  function checkModifier(mod) {
    // Loop through operators
    Object.keys(mod).forEach(function (op) {
      var opObj = mod[op]; // If non-operators are mixed in, throw error

      if (op.slice(0, 1) !== '$') {
        throw new Error("Expected '".concat(op, "' to be a modifier operator like '$set'"));
      }

      if (shouldCheck(op)) {
        // For an upsert, missing props would not be set if an insert is performed,
        // so we check them all with undefined value to force any 'required' checks to fail
        if (isUpsert && (op === '$set' || op === '$setOnInsert')) {
          var presentKeys = Object.keys(opObj);
          schema.objectKeys().forEach(function (schemaKey) {
            if (!presentKeys.includes(schemaKey)) {
              checkObj({
                val: undefined,
                affectedKey: schemaKey,
                operator: op
              });
            }
          });
        } // Don't use forEach here because it will not properly handle an
        // object that has a property named `length`


        Object.keys(opObj).forEach(function (k) {
          var v = opObj[k];

          if (op === '$push' || op === '$addToSet') {
            if (_typeof(v) === 'object' && '$each' in v) {
              v = v.$each;
            } else {
              k = "".concat(k, ".0");
            }
          }

          checkObj({
            val: v,
            affectedKey: k,
            operator: op
          });
        });
      }
    });
  } // Kick off the validation


  if (isModifier) {
    checkModifier(obj);
  } else {
    checkObj({
      val: obj
    });
  } // Custom whole-doc validators


  var docValidators = schema._docValidators.concat(_SimpleSchema.SimpleSchema._docValidators);

  var docValidatorContext = _objectSpread({
    ignoreTypes: ignoreTypes,
    isModifier: isModifier,
    isUpsert: isUpsert,
    keysToValidate: keysToValidate,
    mongoObject: mongoObject,
    obj: obj,
    schema: schema,
    validationContext: validationContext
  }, extendedCustomContext || {});

  docValidators.forEach(function (func) {
    var errors = func.call(docValidatorContext, obj);
    if (!Array.isArray(errors)) throw new Error('Custom doc validator must return an array of error objects');
    if (errors.length) validationErrors = validationErrors.concat(errors);
  });
  var addedFieldNames = [];
  validationErrors = validationErrors.filter(function (errObj) {
    // Remove error types the user doesn't care about
    if (ignoreTypes.includes(errObj.type)) return false; // Make sure there is only one error per fieldName

    if (addedFieldNames.includes(errObj.name)) return false;
    addedFieldNames.push(errObj.name);
    return true;
  });
  return validationErrors;
}

var _default = doValidation;
exports.default = _default;
module.exports = exports.default;
module.exports.default = exports.default;