(function () {

/* Imports */
var Meteor = Package.meteor.Meteor;
var global = Package.meteor.global;
var meteorEnv = Package.meteor.meteorEnv;
var ECMAScript = Package.ecmascript.ECMAScript;
var LocalCollection = Package.minimongo.LocalCollection;
var Minimongo = Package.minimongo.Minimongo;
var check = Package.check.check;
var Match = Package.check.Match;
var EJSON = Package.ejson.EJSON;
var DDP = Package['ddp-client'].DDP;
var DDPServer = Package['ddp-server'].DDPServer;
var meteorInstall = Package.modules.meteorInstall;
var Promise = Package.promise.Promise;

/* Package-scope variables */
var AllowDeny;

var require = meteorInstall({"node_modules":{"meteor":{"allow-deny":{"allow-deny.js":function module(){

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
// packages/allow-deny/allow-deny.js                                                                                  //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                      //
///
/// Remote methods and access control.
///
const hasOwn = Object.prototype.hasOwnProperty; // Restrict default mutators on collection. allow() and deny() take the
// same options:
//
// options.insert {Function(userId, doc)}
//   return true to allow/deny adding this document
//
// options.update {Function(userId, docs, fields, modifier)}
//   return true to allow/deny updating these documents.
//   `fields` is passed as an array of fields that are to be modified
//
// options.remove {Function(userId, docs)}
//   return true to allow/deny removing these documents
//
// options.fetch {Array}
//   Fields to fetch for these validators. If any call to allow or deny
//   does not have this option then all fields are loaded.
//
// allow and deny can be called multiple times. The validators are
// evaluated as follows:
// - If neither deny() nor allow() has been called on the collection,
//   then the request is allowed if and only if the "insecure" smart
//   package is in use.
// - Otherwise, if any deny() function returns true, the request is denied.
// - Otherwise, if any allow() function returns true, the request is allowed.
// - Otherwise, the request is denied.
//
// Meteor may call your deny() and allow() functions in any order, and may not
// call all of them if it is able to make a decision without calling them all
// (so don't include side effects).

AllowDeny = {
  CollectionPrototype: {}
}; // In the `mongo` package, we will extend Mongo.Collection.prototype with these
// methods

const CollectionPrototype = AllowDeny.CollectionPrototype;
/**
 * @summary Allow users to write directly to this collection from client code, subject to limitations you define.
 * @locus Server
 * @method allow
 * @memberOf Mongo.Collection
 * @instance
 * @param {Object} options
 * @param {Function} options.insert,update,remove Functions that look at a proposed modification to the database and return true if it should be allowed.
 * @param {String[]} options.fetch Optional performance enhancement. Limits the fields that will be fetched from the database for inspection by your `update` and `remove` functions.
 * @param {Function} options.transform Overrides `transform` on the  [`Collection`](#collections).  Pass `null` to disable transformation.
 */

CollectionPrototype.allow = function (options) {
  addValidator(this, 'allow', options);
};
/**
 * @summary Override `allow` rules.
 * @locus Server
 * @method deny
 * @memberOf Mongo.Collection
 * @instance
 * @param {Object} options
 * @param {Function} options.insert,update,remove Functions that look at a proposed modification to the database and return true if it should be denied, even if an [allow](#allow) rule says otherwise.
 * @param {String[]} options.fetch Optional performance enhancement. Limits the fields that will be fetched from the database for inspection by your `update` and `remove` functions.
 * @param {Function} options.transform Overrides `transform` on the  [`Collection`](#collections).  Pass `null` to disable transformation.
 */


CollectionPrototype.deny = function (options) {
  addValidator(this, 'deny', options);
};

CollectionPrototype._defineMutationMethods = function (options) {
  const self = this;
  options = options || {}; // set to true once we call any allow or deny methods. If true, use
  // allow/deny semantics. If false, use insecure mode semantics.

  self._restricted = false; // Insecure mode (default to allowing writes). Defaults to 'undefined' which
  // means insecure iff the insecure package is loaded. This property can be
  // overriden by tests or packages wishing to change insecure mode behavior of
  // their collections.

  self._insecure = undefined;
  self._validators = {
    insert: {
      allow: [],
      deny: []
    },
    update: {
      allow: [],
      deny: []
    },
    remove: {
      allow: [],
      deny: []
    },
    upsert: {
      allow: [],
      deny: []
    },
    // dummy arrays; can't set these!
    fetch: [],
    fetchAllFields: false
  };
  if (!self._name) return; // anonymous collection
  // XXX Think about method namespacing. Maybe methods should be
  // "Meteor:Mongo:insert/NAME"?

  self._prefix = '/' + self._name + '/'; // Mutation Methods
  // Minimongo on the server gets no stubs; instead, by default
  // it wait()s until its result is ready, yielding.
  // This matches the behavior of macromongo on the server better.
  // XXX see #MeteorServerNull

  if (self._connection && (self._connection === Meteor.server || Meteor.isClient)) {
    const m = {};
    ['insert', 'update', 'remove'].forEach(method => {
      const methodName = self._prefix + method;

      if (options.useExisting) {
        const handlerPropName = Meteor.isClient ? '_methodHandlers' : 'method_handlers'; // Do not try to create additional methods if this has already been called.
        // (Otherwise the .methods() call below will throw an error.)

        if (self._connection[handlerPropName] && typeof self._connection[handlerPropName][methodName] === 'function') return;
      }

      m[methodName] = function
        /* ... */
      () {
        // All the methods do their own validation, instead of using check().
        check(arguments, [Match.Any]);
        const args = Array.from(arguments);

        try {
          // For an insert, if the client didn't specify an _id, generate one
          // now; because this uses DDP.randomStream, it will be consistent with
          // what the client generated. We generate it now rather than later so
          // that if (eg) an allow/deny rule does an insert to the same
          // collection (not that it really should), the generated _id will
          // still be the first use of the stream and will be consistent.
          //
          // However, we don't actually stick the _id onto the document yet,
          // because we want allow/deny rules to be able to differentiate
          // between arbitrary client-specified _id fields and merely
          // client-controlled-via-randomSeed fields.
          let generatedId = null;

          if (method === "insert" && !hasOwn.call(args[0], '_id')) {
            generatedId = self._makeNewID();
          }

          if (this.isSimulation) {
            // In a client simulation, you can do any mutation (even with a
            // complex selector).
            if (generatedId !== null) args[0]._id = generatedId;
            return self._collection[method].apply(self._collection, args);
          } // This is the server receiving a method call from the client.
          // We don't allow arbitrary selectors in mutations from the client: only
          // single-ID selectors.


          if (method !== 'insert') throwIfSelectorIsNotId(args[0], method);

          if (self._restricted) {
            // short circuit if there is no way it will pass.
            if (self._validators[method].allow.length === 0) {
              throw new Meteor.Error(403, "Access denied. No allow validators set on restricted " + "collection for method '" + method + "'.");
            }

            const validatedMethodName = '_validated' + method.charAt(0).toUpperCase() + method.slice(1);
            args.unshift(this.userId);
            method === 'insert' && args.push(generatedId);
            return self[validatedMethodName].apply(self, args);
          } else if (self._isInsecure()) {
            if (generatedId !== null) args[0]._id = generatedId; // In insecure mode, allow any mutation (with a simple selector).
            // XXX This is kind of bogus.  Instead of blindly passing whatever
            //     we get from the network to this function, we should actually
            //     know the correct arguments for the function and pass just
            //     them.  For example, if you have an extraneous extra null
            //     argument and this is Mongo on the server, the .wrapAsync'd
            //     functions like update will get confused and pass the
            //     "fut.resolver()" in the wrong slot, where _update will never
            //     invoke it. Bam, broken DDP connection.  Probably should just
            //     take this whole method and write it three times, invoking
            //     helpers for the common code.

            return self._collection[method].apply(self._collection, args);
          } else {
            // In secure mode, if we haven't called allow or deny, then nothing
            // is permitted.
            throw new Meteor.Error(403, "Access denied");
          }
        } catch (e) {
          if (e.name === 'MongoError' || // for old versions of MongoDB (probably not necessary but it's here just in case)
          e.name === 'BulkWriteError' || // for newer versions of MongoDB (https://docs.mongodb.com/drivers/node/current/whats-new/#bulkwriteerror---mongobulkwriteerror)
          e.name === 'MongoBulkWriteError' || e.name === 'MinimongoError') {
            throw new Meteor.Error(409, e.toString());
          } else {
            throw e;
          }
        }
      };
    });

    self._connection.methods(m);
  }
};

CollectionPrototype._updateFetch = function (fields) {
  const self = this;

  if (!self._validators.fetchAllFields) {
    if (fields) {
      const union = Object.create(null);

      const add = names => names && names.forEach(name => union[name] = 1);

      add(self._validators.fetch);
      add(fields);
      self._validators.fetch = Object.keys(union);
    } else {
      self._validators.fetchAllFields = true; // clear fetch just to make sure we don't accidentally read it

      self._validators.fetch = null;
    }
  }
};

CollectionPrototype._isInsecure = function () {
  const self = this;
  if (self._insecure === undefined) return !!Package.insecure;
  return self._insecure;
};

CollectionPrototype._validatedInsert = function (userId, doc, generatedId) {
  const self = this; // call user validators.
  // Any deny returns true means denied.

  if (self._validators.insert.deny.some(validator => {
    return validator(userId, docToValidate(validator, doc, generatedId));
  })) {
    throw new Meteor.Error(403, "Access denied");
  } // Any allow returns true means proceed. Throw error if they all fail.


  if (self._validators.insert.allow.every(validator => {
    return !validator(userId, docToValidate(validator, doc, generatedId));
  })) {
    throw new Meteor.Error(403, "Access denied");
  } // If we generated an ID above, insert it now: after the validation, but
  // before actually inserting.


  if (generatedId !== null) doc._id = generatedId;

  self._collection.insert.call(self._collection, doc);
}; // Simulate a mongo `update` operation while validating that the access
// control rules set by calls to `allow/deny` are satisfied. If all
// pass, rewrite the mongo operation to use $in to set the list of
// document ids to change ##ValidatedChange


CollectionPrototype._validatedUpdate = function (userId, selector, mutator, options) {
  const self = this;
  check(mutator, Object);
  options = Object.assign(Object.create(null), options);
  if (!LocalCollection._selectorIsIdPerhapsAsObject(selector)) throw new Error("validated update should be of a single ID"); // We don't support upserts because they don't fit nicely into allow/deny
  // rules.

  if (options.upsert) throw new Meteor.Error(403, "Access denied. Upserts not " + "allowed in a restricted collection.");
  const noReplaceError = "Access denied. In a restricted collection you can only" + " update documents, not replace them. Use a Mongo update operator, such " + "as '$set'.";
  const mutatorKeys = Object.keys(mutator); // compute modified fields

  const modifiedFields = {};

  if (mutatorKeys.length === 0) {
    throw new Meteor.Error(403, noReplaceError);
  }

  mutatorKeys.forEach(op => {
    const params = mutator[op];

    if (op.charAt(0) !== '$') {
      throw new Meteor.Error(403, noReplaceError);
    } else if (!hasOwn.call(ALLOWED_UPDATE_OPERATIONS, op)) {
      throw new Meteor.Error(403, "Access denied. Operator " + op + " not allowed in a restricted collection.");
    } else {
      Object.keys(params).forEach(field => {
        // treat dotted fields as if they are replacing their
        // top-level part
        if (field.indexOf('.') !== -1) field = field.substring(0, field.indexOf('.')); // record the field we are trying to change

        modifiedFields[field] = true;
      });
    }
  });
  const fields = Object.keys(modifiedFields);
  const findOptions = {
    transform: null
  };

  if (!self._validators.fetchAllFields) {
    findOptions.fields = {};

    self._validators.fetch.forEach(fieldName => {
      findOptions.fields[fieldName] = 1;
    });
  }

  const doc = self._collection.findOne(selector, findOptions);

  if (!doc) // none satisfied!
    return 0; // call user validators.
  // Any deny returns true means denied.

  if (self._validators.update.deny.some(validator => {
    const factoriedDoc = transformDoc(validator, doc);
    return validator(userId, factoriedDoc, fields, mutator);
  })) {
    throw new Meteor.Error(403, "Access denied");
  } // Any allow returns true means proceed. Throw error if they all fail.


  if (self._validators.update.allow.every(validator => {
    const factoriedDoc = transformDoc(validator, doc);
    return !validator(userId, factoriedDoc, fields, mutator);
  })) {
    throw new Meteor.Error(403, "Access denied");
  }

  options._forbidReplace = true; // Back when we supported arbitrary client-provided selectors, we actually
  // rewrote the selector to include an _id clause before passing to Mongo to
  // avoid races, but since selector is guaranteed to already just be an ID, we
  // don't have to any more.

  return self._collection.update.call(self._collection, selector, mutator, options);
}; // Only allow these operations in validated updates. Specifically
// whitelist operations, rather than blacklist, so new complex
// operations that are added aren't automatically allowed. A complex
// operation is one that does more than just modify its target
// field. For now this contains all update operations except '$rename'.
// http://docs.mongodb.org/manual/reference/operators/#update


const ALLOWED_UPDATE_OPERATIONS = {
  $inc: 1,
  $set: 1,
  $unset: 1,
  $addToSet: 1,
  $pop: 1,
  $pullAll: 1,
  $pull: 1,
  $pushAll: 1,
  $push: 1,
  $bit: 1
}; // Simulate a mongo `remove` operation while validating access control
// rules. See #ValidatedChange

CollectionPrototype._validatedRemove = function (userId, selector) {
  const self = this;
  const findOptions = {
    transform: null
  };

  if (!self._validators.fetchAllFields) {
    findOptions.fields = {};

    self._validators.fetch.forEach(fieldName => {
      findOptions.fields[fieldName] = 1;
    });
  }

  const doc = self._collection.findOne(selector, findOptions);

  if (!doc) return 0; // call user validators.
  // Any deny returns true means denied.

  if (self._validators.remove.deny.some(validator => {
    return validator(userId, transformDoc(validator, doc));
  })) {
    throw new Meteor.Error(403, "Access denied");
  } // Any allow returns true means proceed. Throw error if they all fail.


  if (self._validators.remove.allow.every(validator => {
    return !validator(userId, transformDoc(validator, doc));
  })) {
    throw new Meteor.Error(403, "Access denied");
  } // Back when we supported arbitrary client-provided selectors, we actually
  // rewrote the selector to {_id: {$in: [ids that we found]}} before passing to
  // Mongo to avoid races, but since selector is guaranteed to already just be
  // an ID, we don't have to any more.


  return self._collection.remove.call(self._collection, selector);
};

CollectionPrototype._callMutatorMethod = function _callMutatorMethod(name, args, callback) {
  if (Meteor.isClient && !callback && !alreadyInSimulation()) {
    // Client can't block, so it can't report errors by exception,
    // only by callback. If they forget the callback, give them a
    // default one that logs the error, so they aren't totally
    // baffled if their writes don't work because their database is
    // down.
    // Don't give a default callback in simulation, because inside stubs we
    // want to return the results from the local collection immediately and
    // not force a callback.
    callback = function (err) {
      if (err) Meteor._debug(name + " failed", err);
    };
  } // For two out of three mutator methods, the first argument is a selector


  const firstArgIsSelector = name === "update" || name === "remove";

  if (firstArgIsSelector && !alreadyInSimulation()) {
    // If we're about to actually send an RPC, we should throw an error if
    // this is a non-ID selector, because the mutation methods only allow
    // single-ID selectors. (If we don't throw here, we'll see flicker.)
    throwIfSelectorIsNotId(args[0], name);
  }

  const mutatorMethodName = this._prefix + name;
  return this._connection.apply(mutatorMethodName, args, {
    returnStubValue: true
  }, callback);
};

function transformDoc(validator, doc) {
  if (validator.transform) return validator.transform(doc);
  return doc;
}

function docToValidate(validator, doc, generatedId) {
  let ret = doc;

  if (validator.transform) {
    ret = EJSON.clone(doc); // If you set a server-side transform on your collection, then you don't get
    // to tell the difference between "client specified the ID" and "server
    // generated the ID", because transforms expect to get _id.  If you want to
    // do that check, you can do it with a specific
    // `C.allow({insert: f, transform: null})` validator.

    if (generatedId !== null) {
      ret._id = generatedId;
    }

    ret = validator.transform(ret);
  }

  return ret;
}

function addValidator(collection, allowOrDeny, options) {
  // validate keys
  const validKeysRegEx = /^(?:insert|update|remove|fetch|transform)$/;
  Object.keys(options).forEach(key => {
    if (!validKeysRegEx.test(key)) throw new Error(allowOrDeny + ": Invalid key: " + key);
  });
  collection._restricted = true;
  ['insert', 'update', 'remove'].forEach(name => {
    if (hasOwn.call(options, name)) {
      if (!(options[name] instanceof Function)) {
        throw new Error(allowOrDeny + ": Value for `" + name + "` must be a function");
      } // If the transform is specified at all (including as 'null') in this
      // call, then take that; otherwise, take the transform from the
      // collection.


      if (options.transform === undefined) {
        options[name].transform = collection._transform; // already wrapped
      } else {
        options[name].transform = LocalCollection.wrapTransform(options.transform);
      }

      collection._validators[name][allowOrDeny].push(options[name]);
    }
  }); // Only update the fetch fields if we're passed things that affect
  // fetching. This way allow({}) and allow({insert: f}) don't result in
  // setting fetchAllFields

  if (options.update || options.remove || options.fetch) {
    if (options.fetch && !(options.fetch instanceof Array)) {
      throw new Error(allowOrDeny + ": Value for `fetch` must be an array");
    }

    collection._updateFetch(options.fetch);
  }
}

function throwIfSelectorIsNotId(selector, methodName) {
  if (!LocalCollection._selectorIsIdPerhapsAsObject(selector)) {
    throw new Meteor.Error(403, "Not permitted. Untrusted code may only " + methodName + " documents by ID.");
  }
}

; // Determine if we are in a DDP method simulation

function alreadyInSimulation() {
  var CurrentInvocation = DDP._CurrentMethodInvocation || // For backwards compatibility, as explained in this issue:
  // https://github.com/meteor/meteor/issues/8947
  DDP._CurrentInvocation;
  const enclosing = CurrentInvocation.get();
  return enclosing && enclosing.isSimulation;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}}}}},{
  "extensions": [
    ".js",
    ".json"
  ]
});

require("/node_modules/meteor/allow-deny/allow-deny.js");

/* Exports */
Package._define("allow-deny", {
  AllowDeny: AllowDeny
});

})();

//# sourceURL=meteor://💻app/packages/allow-deny.js
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvYWxsb3ctZGVueS9hbGxvdy1kZW55LmpzIl0sIm5hbWVzIjpbImhhc093biIsIk9iamVjdCIsInByb3RvdHlwZSIsImhhc093blByb3BlcnR5IiwiQWxsb3dEZW55IiwiQ29sbGVjdGlvblByb3RvdHlwZSIsImFsbG93Iiwib3B0aW9ucyIsImFkZFZhbGlkYXRvciIsImRlbnkiLCJfZGVmaW5lTXV0YXRpb25NZXRob2RzIiwic2VsZiIsIl9yZXN0cmljdGVkIiwiX2luc2VjdXJlIiwidW5kZWZpbmVkIiwiX3ZhbGlkYXRvcnMiLCJpbnNlcnQiLCJ1cGRhdGUiLCJyZW1vdmUiLCJ1cHNlcnQiLCJmZXRjaCIsImZldGNoQWxsRmllbGRzIiwiX25hbWUiLCJfcHJlZml4IiwiX2Nvbm5lY3Rpb24iLCJNZXRlb3IiLCJzZXJ2ZXIiLCJpc0NsaWVudCIsIm0iLCJmb3JFYWNoIiwibWV0aG9kIiwibWV0aG9kTmFtZSIsInVzZUV4aXN0aW5nIiwiaGFuZGxlclByb3BOYW1lIiwiY2hlY2siLCJhcmd1bWVudHMiLCJNYXRjaCIsIkFueSIsImFyZ3MiLCJBcnJheSIsImZyb20iLCJnZW5lcmF0ZWRJZCIsImNhbGwiLCJfbWFrZU5ld0lEIiwiaXNTaW11bGF0aW9uIiwiX2lkIiwiX2NvbGxlY3Rpb24iLCJhcHBseSIsInRocm93SWZTZWxlY3RvcklzTm90SWQiLCJsZW5ndGgiLCJFcnJvciIsInZhbGlkYXRlZE1ldGhvZE5hbWUiLCJjaGFyQXQiLCJ0b1VwcGVyQ2FzZSIsInNsaWNlIiwidW5zaGlmdCIsInVzZXJJZCIsInB1c2giLCJfaXNJbnNlY3VyZSIsImUiLCJuYW1lIiwidG9TdHJpbmciLCJtZXRob2RzIiwiX3VwZGF0ZUZldGNoIiwiZmllbGRzIiwidW5pb24iLCJjcmVhdGUiLCJhZGQiLCJuYW1lcyIsImtleXMiLCJQYWNrYWdlIiwiaW5zZWN1cmUiLCJfdmFsaWRhdGVkSW5zZXJ0IiwiZG9jIiwic29tZSIsInZhbGlkYXRvciIsImRvY1RvVmFsaWRhdGUiLCJldmVyeSIsIl92YWxpZGF0ZWRVcGRhdGUiLCJzZWxlY3RvciIsIm11dGF0b3IiLCJhc3NpZ24iLCJMb2NhbENvbGxlY3Rpb24iLCJfc2VsZWN0b3JJc0lkUGVyaGFwc0FzT2JqZWN0Iiwibm9SZXBsYWNlRXJyb3IiLCJtdXRhdG9yS2V5cyIsIm1vZGlmaWVkRmllbGRzIiwib3AiLCJwYXJhbXMiLCJBTExPV0VEX1VQREFURV9PUEVSQVRJT05TIiwiZmllbGQiLCJpbmRleE9mIiwic3Vic3RyaW5nIiwiZmluZE9wdGlvbnMiLCJ0cmFuc2Zvcm0iLCJmaWVsZE5hbWUiLCJmaW5kT25lIiwiZmFjdG9yaWVkRG9jIiwidHJhbnNmb3JtRG9jIiwiX2ZvcmJpZFJlcGxhY2UiLCIkaW5jIiwiJHNldCIsIiR1bnNldCIsIiRhZGRUb1NldCIsIiRwb3AiLCIkcHVsbEFsbCIsIiRwdWxsIiwiJHB1c2hBbGwiLCIkcHVzaCIsIiRiaXQiLCJfdmFsaWRhdGVkUmVtb3ZlIiwiX2NhbGxNdXRhdG9yTWV0aG9kIiwiY2FsbGJhY2siLCJhbHJlYWR5SW5TaW11bGF0aW9uIiwiZXJyIiwiX2RlYnVnIiwiZmlyc3RBcmdJc1NlbGVjdG9yIiwibXV0YXRvck1ldGhvZE5hbWUiLCJyZXR1cm5TdHViVmFsdWUiLCJyZXQiLCJFSlNPTiIsImNsb25lIiwiY29sbGVjdGlvbiIsImFsbG93T3JEZW55IiwidmFsaWRLZXlzUmVnRXgiLCJrZXkiLCJ0ZXN0IiwiRnVuY3Rpb24iLCJfdHJhbnNmb3JtIiwid3JhcFRyYW5zZm9ybSIsIkN1cnJlbnRJbnZvY2F0aW9uIiwiRERQIiwiX0N1cnJlbnRNZXRob2RJbnZvY2F0aW9uIiwiX0N1cnJlbnRJbnZvY2F0aW9uIiwiZW5jbG9zaW5nIiwiZ2V0Il0sIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7O0FBQUE7QUFDQTtBQUNBO0FBRUEsTUFBTUEsTUFBTSxHQUFHQyxNQUFNLENBQUNDLFNBQVAsQ0FBaUJDLGNBQWhDLEMs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QkFKTjtBQU1BLFFBQU1DLFNBQVMsR0FBR0osaUJBQWlCLENBQUNLLEdBQWxCLEVBQWxCO0FBQ0EsU0FBT0QsU0FBUyxJQUFJQSxTQUFTLENBQUMxRixZQUE5QjtBQUNELEMiLCJmaWxlIjoiL3BhY2thZ2VzL2FsbG93LWRlbnkuanMiLCJzb3VyY2VzQ29udGVudCI6WyIvLy9cbi8vLyBSZW1vdGUgbWV0aG9kcyBhbmQgYWNjZXNzIGNvbnRyb2wuXG4vLy9cblxuY29uc3QgaGFzT3duID0gT2JqZWN0LnByb3RvdHlwZS5oYXNPd25Qcm9wZXJ0eTtcblxuLy8gUmVzdHJpY3QgZGVmYXVsdCBtdXRhdG9ycyBvbiBjb2xsZWN0aW9uLiBhbGxvdygpIGFuZCBkZW55KCkgdGFrZSB0aGVcbi8vIHNhbWUgb3B0aW9uczpcbi8vXG4vLyBvcHRpb25zLmluc2VydCB7RnVuY3Rpb24odXNlcklkLCBkb2MpfVxuLy8gICByZXR1cm4gdHJ1ZSB0byBhbGxvdy9kZW55IGFkZGluZyB0aGlzIGRvY3VtZW50XG4vL1xuLy8gb3B0aW9ucy51cGRhdGUge0Z1bmN0aW9uKHVzZXJJZCwgZG9jcywgZmllbGRzLCBtb2RpZmllcil9XG4vLyAgIHJldHVybiB0cnVlIHRvIGFsbG93L2RlbnkgdXBkYXRpbmcgdGhlc2UgZG9jdW1lbnRzLlxuLy8gICBgZmllbGRzYCBpcyBwYXNzZWQgYXMgYW4gYXJyYXkgb2YgZmllbGRzIHRoYXQgYXJlIHRvIGJlIG1vZGlmaWVkXG4vL1xuLy8gb3B0aW9ucy5yZW1vdmUge0Z1bmN0aW9uKHVzZXJJZCwgZG9jcyl9XG4vLyAgIHJldHVybiB0cnVlIHRvIGFsbG93L2RlbnkgcmVtb3ZpbmcgdGhlc2UgZG9jdW1lbnRzXG4vL1xuLy8gb3B0aW9ucy5mZXRjaCB7QXJyYXl9XG4vLyAgIEZpZWxkcyB0byBmZXRjaCBmb3IgdGhlc2UgdmFsaWRhdG9ycy4gSWYgYW55IGNhbGwgdG8gYWxsb3cgb3IgZGVueVxuLy8gICBkb2VzIG5vdCBoYXZlIHRoaXMgb3B0aW9uIHRoZW4gYWxsIGZpZWxkcyBhcmUgbG9hZGVkLlxuLy9cbi8vIGFsbG93IGFuZCBkZW55IGNhbiBiZSBjYWxsZWQgbXVsdGlwbGUgdGltZXMuIFRoZSB2YWxpZGF0b3JzIGFyZVxuLy8gZXZhbHVhdGVkIGFzIGZvbGxvd3M6XG4vLyAtIElmIG5laXRoZXIgZGVueSgpIG5vciBhbGxvdygpIGhhcyBiZWVuIGNhbGxlZCBvbiB0aGUgY29sbGVjdGlvbixcbi8vICAgdGhlbiB0aGUgcmVxdWVzdCBpcyBhbGxvd2VkIGlmIGFuZCBvbmx5IGlmIHRoZSBcImluc2VjdXJlXCIgc21hcnRcbi8vICAgcGFja2FnZSBpcyBpbiB1c2UuXG4vLyAtIE90aGVyd2lzZSwgaWYgYW55IGRlbnkoKSBmdW5jdGlvbiByZXR1cm5zIHRydWUsIHRoZSByZXF1ZXN0IGlzIGRlbmllZC5cbi8vIC0gT3RoZXJ3aXNlLCBpZiBhbnkgYWxsb3coKSBmdW5jdGlvbiByZXR1cm5zIHRydWUsIHRoZSByZXF1ZXN0IGlzIGFsbG93ZWQuXG4vLyAtIE90aGVyd2lzZSwgdGhlIHJlcXVlc3QgaXMgZGVuaWVkLlxuLy9cbi8vIE1ldGVvciBtYXkgY2FsbCB5b3VyIGRlbnkoKSBhbmQgYWxsb3coKSBmdW5jdGlvbnMgaW4gYW55IG9yZGVyLCBhbmQgbWF5IG5vdFxuLy8gY2FsbCBhbGwgb2YgdGhlbSBpZiBpdCBpcyBhYmxlIHRvIG1ha2UgYSBkZWNpc2lvbiB3aXRob3V0IGNhbGxpbmcgdGhlbSBhbGxcbi8vIChzbyBkb24ndCBpbmNsdWRlIHNpZGUgZWZmZWN0cykuXG5cbkFsbG93RGVueSA9IHtcbiAgQ29sbGVjdGlvblByb3RvdHlwZToge31cbn07XG5cbi8vIEluIHRoZSBgbW9uZ29gIHBhY2thZ2UsIHdlIHdpbGwgZXh0ZW5kIE1vbmdvLkNvbGxlY3Rpb24ucHJvdG90eXBlIHdpdGggdGhlc2Vcbi8vIG1ldGhvZHNcbmNvbnN0IENvbGxlY3Rpb25Qcm90b3R5cGUgPSBBbGxvd0RlbnkuQ29sbGVjdGlvblByb3RvdHlwZTtcblxuLyoqXG4gKiBAc3VtbWFyeSBBbGxvdyB1c2VycyB0byB3cml0ZSBkaXJlY3RseSB0byB0aGlzIGNvbGxlY3Rpb24gZnJvbSBjbGllbnQgY29kZSwgc3ViamVjdCB0byBsaW1pdGF0aW9ucyB5b3UgZGVmaW5lLlxuICogQGxvY3VzIFNlcnZlclxuICogQG1ldGhvZCBhbGxvd1xuICogQG1lbWJlck9mIE1vbmdvLkNvbGxlY3Rpb25cbiAqIEBpbnN0YW5jZVxuICogQHBhcmFtIHtPYmplY3R9IG9wdGlvbnNcbiAqIEBwYXJhbSB7RnVuY3Rpb259IG9wdGlvbnMuaW5zZXJ0LHVwZGF0ZSxyZW1vdmUgRnVuY3Rpb25zIHRoYXQgbG9vayBhdCBhIHByb3Bvc2VkIG1vZGlmaWNhdGlvbiB0byB0aGUgZGF0YWJhc2UgYW5kIHJldHVybiB0cnVlIGlmIGl0IHNob3VsZCBiZSBhbGxvd2VkLlxuICogQHBhcmFtIHtTdHJpbmdbXX0gb3B0aW9ucy5mZXRjaCBPcHRpb25hbCBwZXJmb3JtYW5jZSBlbmhhbmNlbWVudC4gTGltaXRzIHRoZSBmaWVsZHMgdGhhdCB3aWxsIGJlIGZldGNoZWQgZnJvbSB0aGUgZGF0YWJhc2UgZm9yIGluc3BlY3Rpb24gYnkgeW91ciBgdXBkYXRlYCBhbmQgYHJlbW92ZWAgZnVuY3Rpb25zLlxuICogQHBhcmFtIHtGdW5jdGlvbn0gb3B0aW9ucy50cmFuc2Zvcm0gT3ZlcnJpZGVzIGB0cmFuc2Zvcm1gIG9uIHRoZSAgW2BDb2xsZWN0aW9uYF0oI2NvbGxlY3Rpb25zKS4gIFBhc3MgYG51bGxgIHRvIGRpc2FibGUgdHJhbnNmb3JtYXRpb24uXG4gKi9cbkNvbGxlY3Rpb25Qcm90b3R5cGUuYWxsb3cgPSBmdW5jdGlvbihvcHRpb25zKSB7XG4gIGFkZFZhbGlkYXRvcih0aGlzLCAnYWxsb3cnLCBvcHRpb25zKTtcbn07XG5cbi8qKlxuICogQHN1bW1hcnkgT3ZlcnJpZGUgYGFsbG93YCBydWxlcy5cbiAqIEBsb2N1cyBTZXJ2ZXJcbiAqIEBtZXRob2QgZGVueVxuICogQG1lbWJlck9mIE1vbmdvLkNvbGxlY3Rpb25cbiAqIEBpbnN0YW5jZVxuICogQHBhcmFtIHtPYmplY3R9IG9wdGlvbnNcbiAqIEBwYXJhbSB7RnVuY3Rpb259IG9wdGlvbnMuaW5zZXJ0LHVwZGF0ZSxyZW1vdmUgRnVuY3Rpb25zIHRoYXQgbG9vayBhdCBhIHByb3Bvc2VkIG1vZGlmaWNhdGlvbiB0byB0aGUgZGF0YWJhc2UgYW5kIHJldHVybiB0cnVlIGlmIGl0IHNob3VsZCBiZSBkZW5pZWQsIGV2ZW4gaWYgYW4gW2FsbG93XSgjYWxsb3cpIHJ1bGUgc2F5cyBvdGhlcndpc2UuXG4gKiBAcGFyYW0ge1N0cmluZ1tdfSBvcHRpb25zLmZldGNoIE9wdGlvbmFsIHBlcmZvcm1hbmNlIGVuaGFuY2VtZW50LiBMaW1pdHMgdGhlIGZpZWxkcyB0aGF0IHdpbGwgYmUgZmV0Y2hlZCBmcm9tIHRoZSBkYXRhYmFzZSBmb3IgaW5zcGVjdGlvbiBieSB5b3VyIGB1cGRhdGVgIGFuZCBgcmVtb3ZlYCBmdW5jdGlvbnMuXG4gKiBAcGFyYW0ge0Z1bmN0aW9ufSBvcHRpb25zLnRyYW5zZm9ybSBPdmVycmlkZXMgYHRyYW5zZm9ybWAgb24gdGhlICBbYENvbGxlY3Rpb25gXSgjY29sbGVjdGlvbnMpLiAgUGFzcyBgbnVsbGAgdG8gZGlzYWJsZSB0cmFuc2Zvcm1hdGlvbi5cbiAqL1xuQ29sbGVjdGlvblByb3RvdHlwZS5kZW55ID0gZnVuY3Rpb24ob3B0aW9ucykge1xuICBhZGRWYWxpZGF0b3IodGhpcywgJ2RlbnknLCBvcHRpb25zKTtcbn07XG5cbkNvbGxlY3Rpb25Qcm90b3R5cGUuX2RlZmluZU11dGF0aW9uTWV0aG9kcyA9IGZ1bmN0aW9uKG9wdGlvbnMpIHtcbiAgY29uc3Qgc2VsZiA9IHRoaXM7XG4gIG9wdGlvbnMgPSBvcHRpb25zIHx8IHt9O1xuXG4gIC8vIHNldCB0byB0cnVlIG9uY2Ugd2UgY2FsbCBhbnkgYWxsb3cgb3IgZGVueSBtZXRob2RzLiBJZiB0cnVlLCB1c2VcbiAgLy8gYWxsb3cvZGVueSBzZW1hbnRpY3MuIElmIGZhbHNlLCB1c2UgaW5zZWN1cmUgbW9kZSBzZW1hbnRpY3MuXG4gIHNlbGYuX3Jlc3RyaWN0ZWQgPSBmYWxzZTtcblxuICAvLyBJbnNlY3VyZSBtb2RlIChkZWZhdWx0IHRvIGFsbG93aW5nIHdyaXRlcykuIERlZmF1bHRzIHRvICd1bmRlZmluZWQnIHdoaWNoXG4gIC8vIG1lYW5zIGluc2VjdXJlIGlmZiB0aGUgaW5zZWN1cmUgcGFja2FnZSBpcyBsb2FkZWQuIFRoaXMgcHJvcGVydHkgY2FuIGJlXG4gIC8vIG92ZXJyaWRlbiBieSB0ZXN0cyBvciBwYWNrYWdlcyB3aXNoaW5nIHRvIGNoYW5nZSBpbnNlY3VyZSBtb2RlIGJlaGF2aW9yIG9mXG4gIC8vIHRoZWlyIGNvbGxlY3Rpb25zLlxuICBzZWxmLl9pbnNlY3VyZSA9IHVuZGVmaW5lZDtcblxuICBzZWxmLl92YWxpZGF0b3JzID0ge1xuICAgIGluc2VydDoge2FsbG93OiBbXSwgZGVueTogW119LFxuICAgIHVwZGF0ZToge2FsbG93OiBbXSwgZGVueTogW119LFxuICAgIHJlbW92ZToge2FsbG93OiBbXSwgZGVueTogW119LFxuICAgIHVwc2VydDoge2FsbG93OiBbXSwgZGVueTogW119LCAvLyBkdW1teSBhcnJheXM7IGNhbid0IHNldCB0aGVzZSFcbiAgICBmZXRjaDogW10sXG4gICAgZmV0Y2hBbGxGaWVsZHM6IGZhbHNlXG4gIH07XG5cbiAgaWYgKCFzZWxmLl9uYW1lKVxuICAgIHJldHVybjsgLy8gYW5vbnltb3VzIGNvbGxlY3Rpb25cblxuICAvLyBYWFggVGhpbmsgYWJvdXQgbWV0aG9kIG5hbWVzcGFjaW5nLiBNYXliZSBtZXRob2RzIHNob3VsZCBiZVxuICAvLyBcIk1ldGVvcjpNb25nbzppbnNlcnQvTkFNRVwiP1xuICBzZWxmLl9wcmVmaXggPSAnLycgKyBzZWxmLl9uYW1lICsgJy8nO1xuXG4gIC8vIE11dGF0aW9uIE1ldGhvZHNcbiAgLy8gTWluaW1vbmdvIG9uIHRoZSBzZXJ2ZXIgZ2V0cyBubyBzdHViczsgaW5zdGVhZCwgYnkgZGVmYXVsdFxuICAvLyBpdCB3YWl0KClzIHVudGlsIGl0cyByZXN1bHQgaXMgcmVhZHksIHlpZWxkaW5nLlxuICAvLyBUaGlzIG1hdGNoZXMgdGhlIGJlaGF2aW9yIG9mIG1hY3JvbW9uZ28gb24gdGhlIHNlcnZlciBiZXR0ZXIuXG4gIC8vIFhYWCBzZWUgI01ldGVvclNlcnZlck51bGxcbiAgaWYgKHNlbGYuX2Nvbm5lY3Rpb24gJiYgKHNlbGYuX2Nvbm5lY3Rpb24gPT09IE1ldGVvci5zZXJ2ZXIgfHwgTWV0ZW9yLmlzQ2xpZW50KSkge1xuICAgIGNvbnN0IG0gPSB7fTtcblxuICAgIFsnaW5zZXJ0JywgJ3VwZGF0ZScsICdyZW1vdmUnXS5mb3JFYWNoKChtZXRob2QpID0+IHtcbiAgICAgIGNvbnN0IG1ldGhvZE5hbWUgPSBzZWxmLl9wcmVmaXggKyBtZXRob2Q7XG5cbiAgICAgIGlmIChvcHRpb25zLnVzZUV4aXN0aW5nKSB7XG4gICAgICAgIGNvbnN0IGhhbmRsZXJQcm9wTmFtZSA9IE1ldGVvci5pc0NsaWVudCA/ICdfbWV0aG9kSGFuZGxlcnMnIDogJ21ldGhvZF9oYW5kbGVycyc7XG4gICAgICAgIC8vIERvIG5vdCB0cnkgdG8gY3JlYXRlIGFkZGl0aW9uYWwgbWV0aG9kcyBpZiB0aGlzIGhhcyBhbHJlYWR5IGJlZW4gY2FsbGVkLlxuICAgICAgICAvLyAoT3RoZXJ3aXNlIHRoZSAubWV0aG9kcygpIGNhbGwgYmVsb3cgd2lsbCB0aHJvdyBhbiBlcnJvci4pXG4gICAgICAgIGlmIChzZWxmLl9jb25uZWN0aW9uW2hhbmRsZXJQcm9wTmFtZV0gJiZcbiAgICAgICAgICB0eXBlb2Ygc2VsZi5fY29ubmVjdGlvbltoYW5kbGVyUHJvcE5hbWVdW21ldGhvZE5hbWVdID09PSAnZnVuY3Rpb24nKSByZXR1cm47XG4gICAgICB9XG5cbiAgICAgIG1bbWV0aG9kTmFtZV0gPSBmdW5jdGlvbiAoLyogLi4uICovKSB7XG4gICAgICAgIC8vIEFsbCB0aGUgbWV0aG9kcyBkbyB0aGVpciBvd24gdmFsaWRhdGlvbiwgaW5zdGVhZCBvZiB1c2luZyBjaGVjaygpLlxuICAgICAgICBjaGVjayhhcmd1bWVudHMsIFtNYXRjaC5BbnldKTtcbiAgICAgICAgY29uc3QgYXJncyA9IEFycmF5LmZyb20oYXJndW1lbnRzKTtcbiAgICAgICAgdHJ5IHtcbiAgICAgICAgICAvLyBGb3IgYW4gaW5zZXJ0LCBpZiB0aGUgY2xpZW50IGRpZG4ndCBzcGVjaWZ5IGFuIF9pZCwgZ2VuZXJhdGUgb25lXG4gICAgICAgICAgLy8gbm93OyBiZWNhdXNlIHRoaXMgdXNlcyBERFAucmFuZG9tU3RyZWFtLCBpdCB3aWxsIGJlIGNvbnNpc3RlbnQgd2l0aFxuICAgICAgICAgIC8vIHdoYXQgdGhlIGNsaWVudCBnZW5lcmF0ZWQuIFdlIGdlbmVyYXRlIGl0IG5vdyByYXRoZXIgdGhhbiBsYXRlciBzb1xuICAgICAgICAgIC8vIHRoYXQgaWYgKGVnKSBhbiBhbGxvdy9kZW55IHJ1bGUgZG9lcyBhbiBpbnNlcnQgdG8gdGhlIHNhbWVcbiAgICAgICAgICAvLyBjb2xsZWN0aW9uIChub3QgdGhhdCBpdCByZWFsbHkgc2hvdWxkKSwgdGhlIGdlbmVyYXRlZCBfaWQgd2lsbFxuICAgICAgICAgIC8vIHN0aWxsIGJlIHRoZSBmaXJzdCB1c2Ugb2YgdGhlIHN0cmVhbSBhbmQgd2lsbCBiZSBjb25zaXN0ZW50LlxuICAgICAgICAgIC8vXG4gICAgICAgICAgLy8gSG93ZXZlciwgd2UgZG9uJ3QgYWN0dWFsbHkgc3RpY2sgdGhlIF9pZCBvbnRvIHRoZSBkb2N1bWVudCB5ZXQsXG4gICAgICAgICAgLy8gYmVjYXVzZSB3ZSB3YW50IGFsbG93L2RlbnkgcnVsZXMgdG8gYmUgYWJsZSB0byBkaWZmZXJlbnRpYXRlXG4gICAgICAgICAgLy8gYmV0d2VlbiBhcmJpdHJhcnkgY2xpZW50LXNwZWNpZmllZCBfaWQgZmllbGRzIGFuZCBtZXJlbHlcbiAgICAgICAgICAvLyBjbGllbnQtY29udHJvbGxlZC12aWEtcmFuZG9tU2VlZCBmaWVsZHMuXG4gICAgICAgICAgbGV0IGdlbmVyYXRlZElkID0gbnVsbDtcbiAgICAgICAgICBpZiAobWV0aG9kID09PSBcImluc2VydFwiICYmICFoYXNPd24uY2FsbChhcmdzWzBdLCAnX2lkJykpIHtcbiAgICAgICAgICAgIGdlbmVyYXRlZElkID0gc2VsZi5fbWFrZU5ld0lEKCk7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgaWYgKHRoaXMuaXNTaW11bGF0aW9uKSB7XG4gICAgICAgICAgICAvLyBJbiBhIGNsaWVudCBzaW11bGF0aW9uLCB5b3UgY2FuIGRvIGFueSBtdXRhdGlvbiAoZXZlbiB3aXRoIGFcbiAgICAgICAgICAgIC8vIGNvbXBsZXggc2VsZWN0b3IpLlxuICAgICAgICAgICAgaWYgKGdlbmVyYXRlZElkICE9PSBudWxsKVxuICAgICAgICAgICAgICBhcmdzWzBdLl9pZCA9IGdlbmVyYXRlZElkO1xuICAgICAgICAgICAgcmV0dXJuIHNlbGYuX2NvbGxlY3Rpb25bbWV0aG9kXS5hcHBseShcbiAgICAgICAgICAgICAgc2VsZi5fY29sbGVjdGlvbiwgYXJncyk7XG4gICAgICAgICAgfVxuXG4gICAgICAgICAgLy8gVGhpcyBpcyB0aGUgc2VydmVyIHJlY2VpdmluZyBhIG1ldGhvZCBjYWxsIGZyb20gdGhlIGNsaWVudC5cblxuICAgICAgICAgIC8vIFdlIGRvbid0IGFsbG93IGFyYml0cmFyeSBzZWxlY3RvcnMgaW4gbXV0YXRpb25zIGZyb20gdGhlIGNsaWVudDogb25seVxuICAgICAgICAgIC8vIHNpbmdsZS1JRCBzZWxlY3RvcnMuXG4gICAgICAgICAgaWYgKG1ldGhvZCAhPT0gJ2luc2VydCcpXG4gICAgICAgICAgICB0aHJvd0lmU2VsZWN0b3JJc05vdElkKGFyZ3NbMF0sIG1ldGhvZCk7XG5cbiAgICAgICAgICBpZiAoc2VsZi5fcmVzdHJpY3RlZCkge1xuICAgICAgICAgICAgLy8gc2hvcnQgY2lyY3VpdCBpZiB0aGVyZSBpcyBubyB3YXkgaXQgd2lsbCBwYXNzLlxuICAgICAgICAgICAgaWYgKHNlbGYuX3ZhbGlkYXRvcnNbbWV0aG9kXS5hbGxvdy5sZW5ndGggPT09IDApIHtcbiAgICAgICAgICAgICAgdGhyb3cgbmV3IE1ldGVvci5FcnJvcihcbiAgICAgICAgICAgICAgICA0MDMsIFwiQWNjZXNzIGRlbmllZC4gTm8gYWxsb3cgdmFsaWRhdG9ycyBzZXQgb24gcmVzdHJpY3RlZCBcIiArXG4gICAgICAgICAgICAgICAgICBcImNvbGxlY3Rpb24gZm9yIG1ldGhvZCAnXCIgKyBtZXRob2QgKyBcIicuXCIpO1xuICAgICAgICAgICAgfVxuXG4gICAgICAgICAgICBjb25zdCB2YWxpZGF0ZWRNZXRob2ROYW1lID1cbiAgICAgICAgICAgICAgICAgICdfdmFsaWRhdGVkJyArIG1ldGhvZC5jaGFyQXQoMCkudG9VcHBlckNhc2UoKSArIG1ldGhvZC5zbGljZSgxKTtcbiAgICAgICAgICAgIGFyZ3MudW5zaGlmdCh0aGlzLnVzZXJJZCk7XG4gICAgICAgICAgICBtZXRob2QgPT09ICdpbnNlcnQnICYmIGFyZ3MucHVzaChnZW5lcmF0ZWRJZCk7XG4gICAgICAgICAgICByZXR1cm4gc2VsZlt2YWxpZGF0ZWRNZXRob2ROYW1lXS5hcHBseShzZWxmLCBhcmdzKTtcbiAgICAgICAgICB9IGVsc2UgaWYgKHNlbGYuX2lzSW5zZWN1cmUoKSkge1xuICAgICAgICAgICAgaWYgKGdlbmVyYXRlZElkICE9PSBudWxsKVxuICAgICAgICAgICAgICBhcmdzWzBdLl9pZCA9IGdlbmVyYXRlZElkO1xuICAgICAgICAgICAgLy8gSW4gaW5zZWN1cmUgbW9kZSwgYWxsb3cgYW55IG11dGF0aW9uICh3aXRoIGEgc2ltcGxlIHNlbGVjdG9yKS5cbiAgICAgICAgICAgIC8vIFhYWCBUaGlzIGlzIGtpbmQgb2YgYm9ndXMuICBJbnN0ZWFkIG9mIGJsaW5kbHkgcGFzc2luZyB3aGF0ZXZlclxuICAgICAgICAgICAgLy8gICAgIHdlIGdldCBmcm9tIHRoZSBuZXR3b3JrIHRvIHRoaXMgZnVuY3Rpb24sIHdlIHNob3VsZCBhY3R1YWxseVxuICAgICAgICAgICAgLy8gICAgIGtub3cgdGhlIGNvcnJlY3QgYXJndW1lbnRzIGZvciB0aGUgZnVuY3Rpb24gYW5kIHBhc3MganVzdFxuICAgICAgICAgICAgLy8gICAgIHRoZW0uICBGb3IgZXhhbXBsZSwgaWYgeW91IGhhdmUgYW4gZXh0cmFuZW91cyBleHRyYSBudWxsXG4gICAgICAgICAgICAvLyAgICAgYXJndW1lbnQgYW5kIHRoaXMgaXMgTW9uZ28gb24gdGhlIHNlcnZlciwgdGhlIC53cmFwQXN5bmMnZFxuICAgICAgICAgICAgLy8gICAgIGZ1bmN0aW9ucyBsaWtlIHVwZGF0ZSB3aWxsIGdldCBjb25mdXNlZCBhbmQgcGFzcyB0aGVcbiAgICAgICAgICAgIC8vICAgICBcImZ1dC5yZXNvbHZlcigpXCIgaW4gdGhlIHdyb25nIHNsb3QsIHdoZXJlIF91cGRhdGUgd2lsbCBuZXZlclxuICAgICAgICAgICAgLy8gICAgIGludm9rZSBpdC4gQmFtLCBicm9rZW4gRERQIGNvbm5lY3Rpb24uICBQcm9iYWJseSBzaG91bGQganVzdFxuICAgICAgICAgICAgLy8gICAgIHRha2UgdGhpcyB3aG9sZSBtZXRob2QgYW5kIHdyaXRlIGl0IHRocmVlIHRpbWVzLCBpbnZva2luZ1xuICAgICAgICAgICAgLy8gICAgIGhlbHBlcnMgZm9yIHRoZSBjb21tb24gY29kZS5cbiAgICAgICAgICAgIHJldHVybiBzZWxmLl9jb2xsZWN0aW9uW21ldGhvZF0uYXBwbHkoc2VsZi5fY29sbGVjdGlvbiwgYXJncyk7XG4gICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgIC8vIEluIHNlY3VyZSBtb2RlLCBpZiB3ZSBoYXZlbid0IGNhbGxlZCBhbGxvdyBvciBkZW55LCB0aGVuIG5vdGhpbmdcbiAgICAgICAgICAgIC8vIGlzIHBlcm1pdHRlZC5cbiAgICAgICAgICAgIHRocm93IG5ldyBNZXRlb3IuRXJyb3IoNDAzLCBcIkFjY2VzcyBkZW5pZWRcIik7XG4gICAgICAgICAgfVxuICAgICAgICB9IGNhdGNoIChlKSB7XG4gICAgICAgICAgaWYgKFxuICAgICAgICAgICAgZS5uYW1lID09PSAnTW9uZ29FcnJvcicgfHxcbiAgICAgICAgICAgIC8vIGZvciBvbGQgdmVyc2lvbnMgb2YgTW9uZ29EQiAocHJvYmFibHkgbm90IG5lY2Vzc2FyeSBidXQgaXQncyBoZXJlIGp1c3QgaW4gY2FzZSlcbiAgICAgICAgICAgIGUubmFtZSA9PT0gJ0J1bGtXcml0ZUVycm9yJyB8fFxuICAgICAgICAgICAgLy8gZm9yIG5ld2VyIHZlcnNpb25zIG9mIE1vbmdvREIgKGh0dHBzOi8vZG9jcy5tb25nb2RiLmNvbS9kcml2ZXJzL25vZGUvY3VycmVudC93aGF0cy1uZXcvI2J1bGt3cml0ZWVycm9yLS0tbW9uZ29idWxrd3JpdGVlcnJvcilcbiAgICAgICAgICAgIGUubmFtZSA9PT0gJ01vbmdvQnVsa1dyaXRlRXJyb3InIHx8XG4gICAgICAgICAgICBlLm5hbWUgPT09ICdNaW5pbW9uZ29FcnJvcidcbiAgICAgICAgICApIHtcbiAgICAgICAgICAgIHRocm93IG5ldyBNZXRlb3IuRXJyb3IoNDA5LCBlLnRvU3RyaW5nKCkpO1xuICAgICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgICB0aHJvdyBlO1xuICAgICAgICAgIH1cbiAgICAgICAgfVxuICAgICAgfTtcbiAgICB9KTtcblxuICAgIHNlbGYuX2Nvbm5lY3Rpb24ubWV0aG9kcyhtKTtcbiAgfVxufTtcblxuQ29sbGVjdGlvblByb3RvdHlwZS5fdXBkYXRlRmV0Y2ggPSBmdW5jdGlvbiAoZmllbGRzKSB7XG4gIGNvbnN0IHNlbGYgPSB0aGlzO1xuXG4gIGlmICghc2VsZi5fdmFsaWRhdG9ycy5mZXRjaEFsbEZpZWxkcykge1xuICAgIGlmIChmaWVsZHMpIHtcbiAgICAgIGNvbnN0IHVuaW9uID0gT2JqZWN0LmNyZWF0ZShudWxsKTtcbiAgICAgIGNvbnN0IGFkZCA9IG5hbWVzID0+IG5hbWVzICYmIG5hbWVzLmZvckVhY2gobmFtZSA9PiB1bmlvbltuYW1lXSA9IDEpO1xuICAgICAgYWRkKHNlbGYuX3ZhbGlkYXRvcnMuZmV0Y2gpO1xuICAgICAgYWRkKGZpZWxkcyk7XG4gICAgICBzZWxmLl92YWxpZGF0b3JzLmZldGNoID0gT2JqZWN0LmtleXModW5pb24pO1xuICAgIH0gZWxzZSB7XG4gICAgICBzZWxmLl92YWxpZGF0b3JzLmZldGNoQWxsRmllbGRzID0gdHJ1ZTtcbiAgICAgIC8vIGNsZWFyIGZldGNoIGp1c3QgdG8gbWFrZSBzdXJlIHdlIGRvbid0IGFjY2lkZW50YWxseSByZWFkIGl0XG4gICAgICBzZWxmLl92YWxpZGF0b3JzLmZldGNoID0gbnVsbDtcbiAgICB9XG4gIH1cbn07XG5cbkNvbGxlY3Rpb25Qcm90b3R5cGUuX2lzSW5zZWN1cmUgPSBmdW5jdGlvbiAoKSB7XG4gIGNvbnN0IHNlbGYgPSB0aGlzO1xuICBpZiAoc2VsZi5faW5zZWN1cmUgPT09IHVuZGVmaW5lZClcbiAgICByZXR1cm4gISFQYWNrYWdlLmluc2VjdXJlO1xuICByZXR1cm4gc2VsZi5faW5zZWN1cmU7XG59O1xuXG5Db2xsZWN0aW9uUHJvdG90eXBlLl92YWxpZGF0ZWRJbnNlcnQgPSBmdW5jdGlvbiAodXNlcklkLCBkb2MsXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBnZW5lcmF0ZWRJZCkge1xuICBjb25zdCBzZWxmID0gdGhpcztcblxuICAvLyBjYWxsIHVzZXIgdmFsaWRhdG9ycy5cbiAgLy8gQW55IGRlbnkgcmV0dXJucyB0cnVlIG1lYW5zIGRlbmllZC5cbiAgaWYgKHNlbGYuX3ZhbGlkYXRvcnMuaW5zZXJ0LmRlbnkuc29tZSgodmFsaWRhdG9yKSA9PiB7XG4gICAgcmV0dXJuIHZhbGlkYXRvcih1c2VySWQsIGRvY1RvVmFsaWRhdGUodmFsaWRhdG9yLCBkb2MsIGdlbmVyYXRlZElkKSk7XG4gIH0pKSB7XG4gICAgdGhyb3cgbmV3IE1ldGVvci5FcnJvcig0MDMsIFwiQWNjZXNzIGRlbmllZFwiKTtcbiAgfVxuICAvLyBBbnkgYWxsb3cgcmV0dXJucyB0cnVlIG1lYW5zIHByb2NlZWQuIFRocm93IGVycm9yIGlmIHRoZXkgYWxsIGZhaWwuXG4gIGlmIChzZWxmLl92YWxpZGF0b3JzLmluc2VydC5hbGxvdy5ldmVyeSgodmFsaWRhdG9yKSA9PiB7XG4gICAgcmV0dXJuICF2YWxpZGF0b3IodXNlcklkLCBkb2NUb1ZhbGlkYXRlKHZhbGlkYXRvciwgZG9jLCBnZW5lcmF0ZWRJZCkpO1xuICB9KSkge1xuICAgIHRocm93IG5ldyBNZXRlb3IuRXJyb3IoNDAzLCBcIkFjY2VzcyBkZW5pZWRcIik7XG4gIH1cblxuICAvLyBJZiB3ZSBnZW5lcmF0ZWQgYW4gSUQgYWJvdmUsIGluc2VydCBpdCBub3c6IGFmdGVyIHRoZSB2YWxpZGF0aW9uLCBidXRcbiAgLy8gYmVmb3JlIGFjdHVhbGx5IGluc2VydGluZy5cbiAgaWYgKGdlbmVyYXRlZElkICE9PSBudWxsKVxuICAgIGRvYy5faWQgPSBnZW5lcmF0ZWRJZDtcblxuICBzZWxmLl9jb2xsZWN0aW9uLmluc2VydC5jYWxsKHNlbGYuX2NvbGxlY3Rpb24sIGRvYyk7XG59O1xuXG4vLyBTaW11bGF0ZSBhIG1vbmdvIGB1cGRhdGVgIG9wZXJhdGlvbiB3aGlsZSB2YWxpZGF0aW5nIHRoYXQgdGhlIGFjY2Vzc1xuLy8gY29udHJvbCBydWxlcyBzZXQgYnkgY2FsbHMgdG8gYGFsbG93L2RlbnlgIGFyZSBzYXRpc2ZpZWQuIElmIGFsbFxuLy8gcGFzcywgcmV3cml0ZSB0aGUgbW9uZ28gb3BlcmF0aW9uIHRvIHVzZSAkaW4gdG8gc2V0IHRoZSBsaXN0IG9mXG4vLyBkb2N1bWVudCBpZHMgdG8gY2hhbmdlICMjVmFsaWRhdGVkQ2hhbmdlXG5Db2xsZWN0aW9uUHJvdG90eXBlLl92YWxpZGF0ZWRVcGRhdGUgPSBmdW5jdGlvbihcbiAgICB1c2VySWQsIHNlbGVjdG9yLCBtdXRhdG9yLCBvcHRpb25zKSB7XG4gIGNvbnN0IHNlbGYgPSB0aGlzO1xuXG4gIGNoZWNrKG11dGF0b3IsIE9iamVjdCk7XG5cbiAgb3B0aW9ucyA9IE9iamVjdC5hc3NpZ24oT2JqZWN0LmNyZWF0ZShudWxsKSwgb3B0aW9ucyk7XG5cbiAgaWYgKCFMb2NhbENvbGxlY3Rpb24uX3NlbGVjdG9ySXNJZFBlcmhhcHNBc09iamVjdChzZWxlY3RvcikpXG4gICAgdGhyb3cgbmV3IEVycm9yKFwidmFsaWRhdGVkIHVwZGF0ZSBzaG91bGQgYmUgb2YgYSBzaW5nbGUgSURcIik7XG5cbiAgLy8gV2UgZG9uJ3Qgc3VwcG9ydCB1cHNlcnRzIGJlY2F1c2UgdGhleSBkb24ndCBmaXQgbmljZWx5IGludG8gYWxsb3cvZGVueVxuICAvLyBydWxlcy5cbiAgaWYgKG9wdGlvbnMudXBzZXJ0KVxuICAgIHRocm93IG5ldyBNZXRlb3IuRXJyb3IoNDAzLCBcIkFjY2VzcyBkZW5pZWQuIFVwc2VydHMgbm90IFwiICtcbiAgICAgICAgICAgICAgICAgICAgICAgICAgIFwiYWxsb3dlZCBpbiBhIHJlc3RyaWN0ZWQgY29sbGVjdGlvbi5cIik7XG5cbiAgY29uc3Qgbm9SZXBsYWNlRXJyb3IgPSBcIkFjY2VzcyBkZW5pZWQuIEluIGEgcmVzdHJpY3RlZCBjb2xsZWN0aW9uIHlvdSBjYW4gb25seVwiICtcbiAgICAgICAgXCIgdXBkYXRlIGRvY3VtZW50cywgbm90IHJlcGxhY2UgdGhlbS4gVXNlIGEgTW9uZ28gdXBkYXRlIG9wZXJhdG9yLCBzdWNoIFwiICtcbiAgICAgICAgXCJhcyAnJHNldCcuXCI7XG5cbiAgY29uc3QgbXV0YXRvcktleXMgPSBPYmplY3Qua2V5cyhtdXRhdG9yKTtcblxuICAvLyBjb21wdXRlIG1vZGlmaWVkIGZpZWxkc1xuICBjb25zdCBtb2RpZmllZEZpZWxkcyA9IHt9O1xuXG4gIGlmIChtdXRhdG9yS2V5cy5sZW5ndGggPT09IDApIHtcbiAgICB0aHJvdyBuZXcgTWV0ZW9yLkVycm9yKDQwMywgbm9SZXBsYWNlRXJyb3IpO1xuICB9XG4gIG11dGF0b3JLZXlzLmZvckVhY2goKG9wKSA9PiB7XG4gICAgY29uc3QgcGFyYW1zID0gbXV0YXRvcltvcF07XG4gICAgaWYgKG9wLmNoYXJBdCgwKSAhPT0gJyQnKSB7XG4gICAgICB0aHJvdyBuZXcgTWV0ZW9yLkVycm9yKDQwMywgbm9SZXBsYWNlRXJyb3IpO1xuICAgIH0gZWxzZSBpZiAoIWhhc093bi5jYWxsKEFMTE9XRURfVVBEQVRFX09QRVJBVElPTlMsIG9wKSkge1xuICAgICAgdGhyb3cgbmV3IE1ldGVvci5FcnJvcihcbiAgICAgICAgNDAzLCBcIkFjY2VzcyBkZW5pZWQuIE9wZXJhdG9yIFwiICsgb3AgKyBcIiBub3QgYWxsb3dlZCBpbiBhIHJlc3RyaWN0ZWQgY29sbGVjdGlvbi5cIik7XG4gICAgfSBlbHNlIHtcbiAgICAgIE9iamVjdC5rZXlzKHBhcmFtcykuZm9yRWFjaCgoZmllbGQpID0+IHtcbiAgICAgICAgLy8gdHJlYXQgZG90dGVkIGZpZWxkcyBhcyBpZiB0aGV5IGFyZSByZXBsYWNpbmcgdGhlaXJcbiAgICAgICAgLy8gdG9wLWxldmVsIHBhcnRcbiAgICAgICAgaWYgKGZpZWxkLmluZGV4T2YoJy4nKSAhPT0gLTEpXG4gICAgICAgICAgZmllbGQgPSBmaWVsZC5zdWJzdHJpbmcoMCwgZmllbGQuaW5kZXhPZignLicpKTtcblxuICAgICAgICAvLyByZWNvcmQgdGhlIGZpZWxkIHdlIGFyZSB0cnlpbmcgdG8gY2hhbmdlXG4gICAgICAgIG1vZGlmaWVkRmllbGRzW2ZpZWxkXSA9IHRydWU7XG4gICAgICB9KTtcbiAgICB9XG4gIH0pO1xuXG4gIGNvbnN0IGZpZWxkcyA9IE9iamVjdC5rZXlzKG1vZGlmaWVkRmllbGRzKTtcblxuICBjb25zdCBmaW5kT3B0aW9ucyA9IHt0cmFuc2Zvcm06IG51bGx9O1xuICBpZiAoIXNlbGYuX3ZhbGlkYXRvcnMuZmV0Y2hBbGxGaWVsZHMpIHtcbiAgICBmaW5kT3B0aW9ucy5maWVsZHMgPSB7fTtcbiAgICBzZWxmLl92YWxpZGF0b3JzLmZldGNoLmZvckVhY2goKGZpZWxkTmFtZSkgPT4ge1xuICAgICAgZmluZE9wdGlvbnMuZmllbGRzW2ZpZWxkTmFtZV0gPSAxO1xuICAgIH0pO1xuICB9XG5cbiAgY29uc3QgZG9jID0gc2VsZi5fY29sbGVjdGlvbi5maW5kT25lKHNlbGVjdG9yLCBmaW5kT3B0aW9ucyk7XG4gIGlmICghZG9jKSAgLy8gbm9uZSBzYXRpc2ZpZWQhXG4gICAgcmV0dXJuIDA7XG5cbiAgLy8gY2FsbCB1c2VyIHZhbGlkYXRvcnMuXG4gIC8vIEFueSBkZW55IHJldHVybnMgdHJ1ZSBtZWFucyBkZW5pZWQuXG4gIGlmIChzZWxmLl92YWxpZGF0b3JzLnVwZGF0ZS5kZW55LnNvbWUoKHZhbGlkYXRvcikgPT4ge1xuICAgIGNvbnN0IGZhY3RvcmllZERvYyA9IHRyYW5zZm9ybURvYyh2YWxpZGF0b3IsIGRvYyk7XG4gICAgcmV0dXJuIHZhbGlkYXRvcih1c2VySWQsXG4gICAgICAgICAgICAgICAgICAgICBmYWN0b3JpZWREb2MsXG4gICAgICAgICAgICAgICAgICAgICBmaWVsZHMsXG4gICAgICAgICAgICAgICAgICAgICBtdXRhdG9yKTtcbiAgfSkpIHtcbiAgICB0aHJvdyBuZXcgTWV0ZW9yLkVycm9yKDQwMywgXCJBY2Nlc3MgZGVuaWVkXCIpO1xuICB9XG4gIC8vIEFueSBhbGxvdyByZXR1cm5zIHRydWUgbWVhbnMgcHJvY2VlZC4gVGhyb3cgZXJyb3IgaWYgdGhleSBhbGwgZmFpbC5cbiAgaWYgKHNlbGYuX3ZhbGlkYXRvcnMudXBkYXRlLmFsbG93LmV2ZXJ5KCh2YWxpZGF0b3IpID0+IHtcbiAgICBjb25zdCBmYWN0b3JpZWREb2MgPSB0cmFuc2Zvcm1Eb2ModmFsaWRhdG9yLCBkb2MpO1xuICAgIHJldHVybiAhdmFsaWRhdG9yKHVzZXJJZCxcbiAgICAgICAgICAgICAgICAgICAgICBmYWN0b3JpZWREb2MsXG4gICAgICAgICAgICAgICAgICAgICAgZmllbGRzLFxuICAgICAgICAgICAgICAgICAgICAgIG11dGF0b3IpO1xuICB9KSkge1xuICAgIHRocm93IG5ldyBNZXRlb3IuRXJyb3IoNDAzLCBcIkFjY2VzcyBkZW5pZWRcIik7XG4gIH1cblxuICBvcHRpb25zLl9mb3JiaWRSZXBsYWNlID0gdHJ1ZTtcblxuICAvLyBCYWNrIHdoZW4gd2Ugc3VwcG9ydGVkIGFyYml0cmFyeSBjbGllbnQtcHJvdmlkZWQgc2VsZWN0b3JzLCB3ZSBhY3R1YWxseVxuICAvLyByZXdyb3RlIHRoZSBzZWxlY3RvciB0byBpbmNsdWRlIGFuIF9pZCBjbGF1c2UgYmVmb3JlIHBhc3NpbmcgdG8gTW9uZ28gdG9cbiAgLy8gYXZvaWQgcmFjZXMsIGJ1dCBzaW5jZSBzZWxlY3RvciBpcyBndWFyYW50ZWVkIHRvIGFscmVhZHkganVzdCBiZSBhbiBJRCwgd2VcbiAgLy8gZG9uJ3QgaGF2ZSB0byBhbnkgbW9yZS5cblxuICByZXR1cm4gc2VsZi5fY29sbGVjdGlvbi51cGRhdGUuY2FsbChcbiAgICBzZWxmLl9jb2xsZWN0aW9uLCBzZWxlY3RvciwgbXV0YXRvciwgb3B0aW9ucyk7XG59O1xuXG4vLyBPbmx5IGFsbG93IHRoZXNlIG9wZXJhdGlvbnMgaW4gdmFsaWRhdGVkIHVwZGF0ZXMuIFNwZWNpZmljYWxseVxuLy8gd2hpdGVsaXN0IG9wZXJhdGlvbnMsIHJhdGhlciB0aGFuIGJsYWNrbGlzdCwgc28gbmV3IGNvbXBsZXhcbi8vIG9wZXJhdGlvbnMgdGhhdCBhcmUgYWRkZWQgYXJlbid0IGF1dG9tYXRpY2FsbHkgYWxsb3dlZC4gQSBjb21wbGV4XG4vLyBvcGVyYXRpb24gaXMgb25lIHRoYXQgZG9lcyBtb3JlIHRoYW4ganVzdCBtb2RpZnkgaXRzIHRhcmdldFxuLy8gZmllbGQuIEZvciBub3cgdGhpcyBjb250YWlucyBhbGwgdXBkYXRlIG9wZXJhdGlvbnMgZXhjZXB0ICckcmVuYW1lJy5cbi8vIGh0dHA6Ly9kb2NzLm1vbmdvZGIub3JnL21hbnVhbC9yZWZlcmVuY2Uvb3BlcmF0b3JzLyN1cGRhdGVcbmNvbnN0IEFMTE9XRURfVVBEQVRFX09QRVJBVElPTlMgPSB7XG4gICRpbmM6MSwgJHNldDoxLCAkdW5zZXQ6MSwgJGFkZFRvU2V0OjEsICRwb3A6MSwgJHB1bGxBbGw6MSwgJHB1bGw6MSxcbiAgJHB1c2hBbGw6MSwgJHB1c2g6MSwgJGJpdDoxXG59O1xuXG4vLyBTaW11bGF0ZSBhIG1vbmdvIGByZW1vdmVgIG9wZXJhdGlvbiB3aGlsZSB2YWxpZGF0aW5nIGFjY2VzcyBjb250cm9sXG4vLyBydWxlcy4gU2VlICNWYWxpZGF0ZWRDaGFuZ2VcbkNvbGxlY3Rpb25Qcm90b3R5cGUuX3ZhbGlkYXRlZFJlbW92ZSA9IGZ1bmN0aW9uKHVzZXJJZCwgc2VsZWN0b3IpIHtcbiAgY29uc3Qgc2VsZiA9IHRoaXM7XG5cbiAgY29uc3QgZmluZE9wdGlvbnMgPSB7dHJhbnNmb3JtOiBudWxsfTtcbiAgaWYgKCFzZWxmLl92YWxpZGF0b3JzLmZldGNoQWxsRmllbGRzKSB7XG4gICAgZmluZE9wdGlvbnMuZmllbGRzID0ge307XG4gICAgc2VsZi5fdmFsaWRhdG9ycy5mZXRjaC5mb3JFYWNoKChmaWVsZE5hbWUpID0+IHtcbiAgICAgIGZpbmRPcHRpb25zLmZpZWxkc1tmaWVsZE5hbWVdID0gMTtcbiAgICB9KTtcbiAgfVxuXG4gIGNvbnN0IGRvYyA9IHNlbGYuX2NvbGxlY3Rpb24uZmluZE9uZShzZWxlY3RvciwgZmluZE9wdGlvbnMpO1xuICBpZiAoIWRvYylcbiAgICByZXR1cm4gMDtcblxuICAvLyBjYWxsIHVzZXIgdmFsaWRhdG9ycy5cbiAgLy8gQW55IGRlbnkgcmV0dXJucyB0cnVlIG1lYW5zIGRlbmllZC5cbiAgaWYgKHNlbGYuX3ZhbGlkYXRvcnMucmVtb3ZlLmRlbnkuc29tZSgodmFsaWRhdG9yKSA9PiB7XG4gICAgcmV0dXJuIHZhbGlkYXRvcih1c2VySWQsIHRyYW5zZm9ybURvYyh2YWxpZGF0b3IsIGRvYykpO1xuICB9KSkge1xuICAgIHRocm93IG5ldyBNZXRlb3IuRXJyb3IoNDAzLCBcIkFjY2VzcyBkZW5pZWRcIik7XG4gIH1cbiAgLy8gQW55IGFsbG93IHJldHVybnMgdHJ1ZSBtZWFucyBwcm9jZWVkLiBUaHJvdyBlcnJvciBpZiB0aGV5IGFsbCBmYWlsLlxuICBpZiAoc2VsZi5fdmFsaWRhdG9ycy5yZW1vdmUuYWxsb3cuZXZlcnkoKHZhbGlkYXRvcikgPT4ge1xuICAgIHJldHVybiAhdmFsaWRhdG9yKHVzZXJJZCwgdHJhbnNmb3JtRG9jKHZhbGlkYXRvciwgZG9jKSk7XG4gIH0pKSB7XG4gICAgdGhyb3cgbmV3IE1ldGVvci5FcnJvcig0MDMsIFwiQWNjZXNzIGRlbmllZFwiKTtcbiAgfVxuXG4gIC8vIEJhY2sgd2hlbiB3ZSBzdXBwb3J0ZWQgYXJiaXRyYXJ5IGNsaWVudC1wcm92aWRlZCBzZWxlY3RvcnMsIHdlIGFjdHVhbGx5XG4gIC8vIHJld3JvdGUgdGhlIHNlbGVjdG9yIHRvIHtfaWQ6IHskaW46IFtpZHMgdGhhdCB3ZSBmb3VuZF19fSBiZWZvcmUgcGFzc2luZyB0b1xuICAvLyBNb25nbyB0byBhdm9pZCByYWNlcywgYnV0IHNpbmNlIHNlbGVjdG9yIGlzIGd1YXJhbnRlZWQgdG8gYWxyZWFkeSBqdXN0IGJlXG4gIC8vIGFuIElELCB3ZSBkb24ndCBoYXZlIHRvIGFueSBtb3JlLlxuXG4gIHJldHVybiBzZWxmLl9jb2xsZWN0aW9uLnJlbW92ZS5jYWxsKHNlbGYuX2NvbGxlY3Rpb24sIHNlbGVjdG9yKTtcbn07XG5cbkNvbGxlY3Rpb25Qcm90b3R5cGUuX2NhbGxNdXRhdG9yTWV0aG9kID0gZnVuY3Rpb24gX2NhbGxNdXRhdG9yTWV0aG9kKG5hbWUsIGFyZ3MsIGNhbGxiYWNrKSB7XG4gIGlmIChNZXRlb3IuaXNDbGllbnQgJiYgIWNhbGxiYWNrICYmICFhbHJlYWR5SW5TaW11bGF0aW9uKCkpIHtcbiAgICAvLyBDbGllbnQgY2FuJ3QgYmxvY2ssIHNvIGl0IGNhbid0IHJlcG9ydCBlcnJvcnMgYnkgZXhjZXB0aW9uLFxuICAgIC8vIG9ubHkgYnkgY2FsbGJhY2suIElmIHRoZXkgZm9yZ2V0IHRoZSBjYWxsYmFjaywgZ2l2ZSB0aGVtIGFcbiAgICAvLyBkZWZhdWx0IG9uZSB0aGF0IGxvZ3MgdGhlIGVycm9yLCBzbyB0aGV5IGFyZW4ndCB0b3RhbGx5XG4gICAgLy8gYmFmZmxlZCBpZiB0aGVpciB3cml0ZXMgZG9uJ3Qgd29yayBiZWNhdXNlIHRoZWlyIGRhdGFiYXNlIGlzXG4gICAgLy8gZG93bi5cbiAgICAvLyBEb24ndCBnaXZlIGEgZGVmYXVsdCBjYWxsYmFjayBpbiBzaW11bGF0aW9uLCBiZWNhdXNlIGluc2lkZSBzdHVicyB3ZVxuICAgIC8vIHdhbnQgdG8gcmV0dXJuIHRoZSByZXN1bHRzIGZyb20gdGhlIGxvY2FsIGNvbGxlY3Rpb24gaW1tZWRpYXRlbHkgYW5kXG4gICAgLy8gbm90IGZvcmNlIGEgY2FsbGJhY2suXG4gICAgY2FsbGJhY2sgPSBmdW5jdGlvbiAoZXJyKSB7XG4gICAgICBpZiAoZXJyKVxuICAgICAgICBNZXRlb3IuX2RlYnVnKG5hbWUgKyBcIiBmYWlsZWRcIiwgZXJyKTtcbiAgICB9O1xuICB9XG5cbiAgLy8gRm9yIHR3byBvdXQgb2YgdGhyZWUgbXV0YXRvciBtZXRob2RzLCB0aGUgZmlyc3QgYXJndW1lbnQgaXMgYSBzZWxlY3RvclxuICBjb25zdCBmaXJzdEFyZ0lzU2VsZWN0b3IgPSBuYW1lID09PSBcInVwZGF0ZVwiIHx8IG5hbWUgPT09IFwicmVtb3ZlXCI7XG4gIGlmIChmaXJzdEFyZ0lzU2VsZWN0b3IgJiYgIWFscmVhZHlJblNpbXVsYXRpb24oKSkge1xuICAgIC8vIElmIHdlJ3JlIGFib3V0IHRvIGFjdHVhbGx5IHNlbmQgYW4gUlBDLCB3ZSBzaG91bGQgdGhyb3cgYW4gZXJyb3IgaWZcbiAgICAvLyB0aGlzIGlzIGEgbm9uLUlEIHNlbGVjdG9yLCBiZWNhdXNlIHRoZSBtdXRhdGlvbiBtZXRob2RzIG9ubHkgYWxsb3dcbiAgICAvLyBzaW5nbGUtSUQgc2VsZWN0b3JzLiAoSWYgd2UgZG9uJ3QgdGhyb3cgaGVyZSwgd2UnbGwgc2VlIGZsaWNrZXIuKVxuICAgIHRocm93SWZTZWxlY3RvcklzTm90SWQoYXJnc1swXSwgbmFtZSk7XG4gIH1cblxuICBjb25zdCBtdXRhdG9yTWV0aG9kTmFtZSA9IHRoaXMuX3ByZWZpeCArIG5hbWU7XG4gIHJldHVybiB0aGlzLl9jb25uZWN0aW9uLmFwcGx5KFxuICAgIG11dGF0b3JNZXRob2ROYW1lLCBhcmdzLCB7IHJldHVyblN0dWJWYWx1ZTogdHJ1ZSB9LCBjYWxsYmFjayk7XG59XG5cbmZ1bmN0aW9uIHRyYW5zZm9ybURvYyh2YWxpZGF0b3IsIGRvYykge1xuICBpZiAodmFsaWRhdG9yLnRyYW5zZm9ybSlcbiAgICByZXR1cm4gdmFsaWRhdG9yLnRyYW5zZm9ybShkb2MpO1xuICByZXR1cm4gZG9jO1xufVxuXG5mdW5jdGlvbiBkb2NUb1ZhbGlkYXRlKHZhbGlkYXRvciwgZG9jLCBnZW5lcmF0ZWRJZCkge1xuICBsZXQgcmV0ID0gZG9jO1xuICBpZiAodmFsaWRhdG9yLnRyYW5zZm9ybSkge1xuICAgIHJldCA9IEVKU09OLmNsb25lKGRvYyk7XG4gICAgLy8gSWYgeW91IHNldCBhIHNlcnZlci1zaWRlIHRyYW5zZm9ybSBvbiB5b3VyIGNvbGxlY3Rpb24sIHRoZW4geW91IGRvbid0IGdldFxuICAgIC8vIHRvIHRlbGwgdGhlIGRpZmZlcmVuY2UgYmV0d2VlbiBcImNsaWVudCBzcGVjaWZpZWQgdGhlIElEXCIgYW5kIFwic2VydmVyXG4gICAgLy8gZ2VuZXJhdGVkIHRoZSBJRFwiLCBiZWNhdXNlIHRyYW5zZm9ybXMgZXhwZWN0IHRvIGdldCBfaWQuICBJZiB5b3Ugd2FudCB0b1xuICAgIC8vIGRvIHRoYXQgY2hlY2ssIHlvdSBjYW4gZG8gaXQgd2l0aCBhIHNwZWNpZmljXG4gICAgLy8gYEMuYWxsb3coe2luc2VydDogZiwgdHJhbnNmb3JtOiBudWxsfSlgIHZhbGlkYXRvci5cbiAgICBpZiAoZ2VuZXJhdGVkSWQgIT09IG51bGwpIHtcbiAgICAgIHJldC5faWQgPSBnZW5lcmF0ZWRJZDtcbiAgICB9XG4gICAgcmV0ID0gdmFsaWRhdG9yLnRyYW5zZm9ybShyZXQpO1xuICB9XG4gIHJldHVybiByZXQ7XG59XG5cbmZ1bmN0aW9uIGFkZFZhbGlkYXRvcihjb2xsZWN0aW9uLCBhbGxvd09yRGVueSwgb3B0aW9ucykge1xuICAvLyB2YWxpZGF0ZSBrZXlzXG4gIGNvbnN0IHZhbGlkS2V5c1JlZ0V4ID0gL14oPzppbnNlcnR8dXBkYXRlfHJlbW92ZXxmZXRjaHx0cmFuc2Zvcm0pJC87XG4gIE9iamVjdC5rZXlzKG9wdGlvbnMpLmZvckVhY2goKGtleSkgPT4ge1xuICAgIGlmICghdmFsaWRLZXlzUmVnRXgudGVzdChrZXkpKVxuICAgICAgdGhyb3cgbmV3IEVycm9yKGFsbG93T3JEZW55ICsgXCI6IEludmFsaWQga2V5OiBcIiArIGtleSk7XG4gIH0pO1xuXG4gIGNvbGxlY3Rpb24uX3Jlc3RyaWN0ZWQgPSB0cnVlO1xuXG4gIFsnaW5zZXJ0JywgJ3VwZGF0ZScsICdyZW1vdmUnXS5mb3JFYWNoKChuYW1lKSA9PiB7XG4gICAgaWYgKGhhc093bi5jYWxsKG9wdGlvbnMsIG5hbWUpKSB7XG4gICAgICBpZiAoIShvcHRpb25zW25hbWVdIGluc3RhbmNlb2YgRnVuY3Rpb24pKSB7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcihhbGxvd09yRGVueSArIFwiOiBWYWx1ZSBmb3IgYFwiICsgbmFtZSArIFwiYCBtdXN0IGJlIGEgZnVuY3Rpb25cIik7XG4gICAgICB9XG5cbiAgICAgIC8vIElmIHRoZSB0cmFuc2Zvcm0gaXMgc3BlY2lmaWVkIGF0IGFsbCAoaW5jbHVkaW5nIGFzICdudWxsJykgaW4gdGhpc1xuICAgICAgLy8gY2FsbCwgdGhlbiB0YWtlIHRoYXQ7IG90aGVyd2lzZSwgdGFrZSB0aGUgdHJhbnNmb3JtIGZyb20gdGhlXG4gICAgICAvLyBjb2xsZWN0aW9uLlxuICAgICAgaWYgKG9wdGlvbnMudHJhbnNmb3JtID09PSB1bmRlZmluZWQpIHtcbiAgICAgICAgb3B0aW9uc1tuYW1lXS50cmFuc2Zvcm0gPSBjb2xsZWN0aW9uLl90cmFuc2Zvcm07ICAvLyBhbHJlYWR5IHdyYXBwZWRcbiAgICAgIH0gZWxzZSB7XG4gICAgICAgIG9wdGlvbnNbbmFtZV0udHJhbnNmb3JtID0gTG9jYWxDb2xsZWN0aW9uLndyYXBUcmFuc2Zvcm0oXG4gICAgICAgICAgb3B0aW9ucy50cmFuc2Zvcm0pO1xuICAgICAgfVxuXG4gICAgICBjb2xsZWN0aW9uLl92YWxpZGF0b3JzW25hbWVdW2FsbG93T3JEZW55XS5wdXNoKG9wdGlvbnNbbmFtZV0pO1xuICAgIH1cbiAgfSk7XG5cbiAgLy8gT25seSB1cGRhdGUgdGhlIGZldGNoIGZpZWxkcyBpZiB3ZSdyZSBwYXNzZWQgdGhpbmdzIHRoYXQgYWZmZWN0XG4gIC8vIGZldGNoaW5nLiBUaGlzIHdheSBhbGxvdyh7fSkgYW5kIGFsbG93KHtpbnNlcnQ6IGZ9KSBkb24ndCByZXN1bHQgaW5cbiAgLy8gc2V0dGluZyBmZXRjaEFsbEZpZWxkc1xuICBpZiAob3B0aW9ucy51cGRhdGUgfHwgb3B0aW9ucy5yZW1vdmUgfHwgb3B0aW9ucy5mZXRjaCkge1xuICAgIGlmIChvcHRpb25zLmZldGNoICYmICEob3B0aW9ucy5mZXRjaCBpbnN0YW5jZW9mIEFycmF5KSkge1xuICAgICAgdGhyb3cgbmV3IEVycm9yKGFsbG93T3JEZW55ICsgXCI6IFZhbHVlIGZvciBgZmV0Y2hgIG11c3QgYmUgYW4gYXJyYXlcIik7XG4gICAgfVxuICAgIGNvbGxlY3Rpb24uX3VwZGF0ZUZldGNoKG9wdGlvbnMuZmV0Y2gpO1xuICB9XG59XG5cbmZ1bmN0aW9uIHRocm93SWZTZWxlY3RvcklzTm90SWQoc2VsZWN0b3IsIG1ldGhvZE5hbWUpIHtcbiAgaWYgKCFMb2NhbENvbGxlY3Rpb24uX3NlbGVjdG9ySXNJZFBlcmhhcHNBc09iamVjdChzZWxlY3RvcikpIHtcbiAgICB0aHJvdyBuZXcgTWV0ZW9yLkVycm9yKFxuICAgICAgNDAzLCBcIk5vdCBwZXJtaXR0ZWQuIFVudHJ1c3RlZCBjb2RlIG1heSBvbmx5IFwiICsgbWV0aG9kTmFtZSArXG4gICAgICAgIFwiIGRvY3VtZW50cyBieSBJRC5cIik7XG4gIH1cbn07XG5cbi8vIERldGVybWluZSBpZiB3ZSBhcmUgaW4gYSBERFAgbWV0aG9kIHNpbXVsYXRpb25cbmZ1bmN0aW9uIGFscmVhZHlJblNpbXVsYXRpb24oKSB7XG4gIHZhciBDdXJyZW50SW52b2NhdGlvbiA9XG4gICAgRERQLl9DdXJyZW50TWV0aG9kSW52b2NhdGlvbiB8fFxuICAgIC8vIEZvciBiYWNrd2FyZHMgY29tcGF0aWJpbGl0eSwgYXMgZXhwbGFpbmVkIGluIHRoaXMgaXNzdWU6XG4gICAgLy8gaHR0cHM6Ly9naXRodWIuY29tL21ldGVvci9tZXRlb3IvaXNzdWVzLzg5NDdcbiAgICBERFAuX0N1cnJlbnRJbnZvY2F0aW9uO1xuXG4gIGNvbnN0IGVuY2xvc2luZyA9IEN1cnJlbnRJbnZvY2F0aW9uLmdldCgpO1xuICByZXR1cm4gZW5jbG9zaW5nICYmIGVuY2xvc2luZy5pc1NpbXVsYXRpb247XG59XG4iXX0=
