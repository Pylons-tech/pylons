(function () {

/* Imports */
var Meteor = Package.meteor.Meteor;
var global = Package.meteor.global;
var meteorEnv = Package.meteor.meteorEnv;
var check = Package.check.check;
var Match = Package.check.Match;
var ECMAScript = Package.ecmascript.ECMAScript;
var meteorInstall = Package.modules.meteorInstall;
var _ = Package.underscore._;
var Promise = Package.promise.Promise;

/* Package-scope variables */
var enableDebugLogging, publishComposite;

var require = meteorInstall({"node_modules":{"meteor":{"reywood:publish-composite":{"lib":{"publish_composite.js":function module(require,exports,module){

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                        //
// packages/reywood_publish-composite/lib/publish_composite.js                                            //
//                                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                          //
module.export({
  enableDebugLogging: () => enableDebugLogging,
  publishComposite: () => publishComposite
});
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let Publication;
module.link("./publication", {
  default(v) {
    Publication = v;
  }

}, 1);
let Subscription;
module.link("./subscription", {
  default(v) {
    Subscription = v;
  }

}, 2);
let debugLog, enableDebugLogging;
module.link("./logging", {
  debugLog(v) {
    debugLog = v;
  },

  enableDebugLogging(v) {
    enableDebugLogging = v;
  }

}, 3);

function publishComposite(name, options) {
  return Meteor.publish(name, function publish() {
    const subscription = new Subscription(this);

    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    const instanceOptions = prepareOptions.call(this, options, args);
    const publications = [];
    instanceOptions.forEach(opt => {
      const pub = new Publication(subscription, opt);
      pub.publish();
      publications.push(pub);
    });
    this.onStop(() => {
      publications.forEach(pub => pub.unpublish());
    });
    debugLog('Meteor.publish', 'ready');
    this.ready();
  });
} // For backwards compatibility


Meteor.publishComposite = publishComposite;

function prepareOptions(options, args) {
  let preparedOptions = options;

  if (typeof preparedOptions === 'function') {
    preparedOptions = preparedOptions.apply(this, args);
  }

  if (!preparedOptions) {
    return [];
  }

  if (!Array.isArray(preparedOptions)) {
    preparedOptions = [preparedOptions];
  }

  return preparedOptions;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"doc_ref_counter.js":function module(require,exports,module){

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                        //
// packages/reywood_publish-composite/lib/doc_ref_counter.js                                              //
//                                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                          //
class DocumentRefCounter {
  constructor(observer) {
    this.heap = {};
    this.observer = observer;
  }

  increment(collectionName, docId) {
    const key = "".concat(collectionName, ":").concat(docId.valueOf());

    if (!this.heap[key]) {
      this.heap[key] = 0;
    }

    this.heap[key] += 1;
  }

  decrement(collectionName, docId) {
    const key = "".concat(collectionName, ":").concat(docId.valueOf());

    if (this.heap[key]) {
      this.heap[key] -= 1;
      this.observer.onChange(collectionName, docId, this.heap[key]);
    }
  }

}

module.exportDefault(DocumentRefCounter);
////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"logging.js":function module(require,exports,module){

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                        //
// packages/reywood_publish-composite/lib/logging.js                                                      //
//                                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                          //
module.export({
  debugLog: () => debugLog,
  enableDebugLogging: () => enableDebugLogging
});

/* eslint-disable no-console */
let debugLoggingEnabled = false;

function debugLog(source, message) {
  if (!debugLoggingEnabled) {
    return;
  }

  let paddedSource = source;

  while (paddedSource.length < 35) {
    paddedSource += ' ';
  }

  console.log("[".concat(paddedSource, "] ").concat(message));
}

function enableDebugLogging() {
  debugLoggingEnabled = true;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"publication.js":function module(require,exports,module){

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                        //
// packages/reywood_publish-composite/lib/publication.js                                                  //
//                                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                          //
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let Match, check;
module.link("meteor/check", {
  Match(v) {
    Match = v;
  },

  check(v) {
    check = v;
  }

}, 1);

let _;

module.link("meteor/underscore", {
  _(v) {
    _ = v;
  }

}, 2);
let debugLog;
module.link("./logging", {
  debugLog(v) {
    debugLog = v;
  }

}, 3);
let PublishedDocumentList;
module.link("./published_document_list", {
  default(v) {
    PublishedDocumentList = v;
  }

}, 4);

class Publication {
  constructor(subscription, options, args) {
    check(options, {
      find: Function,
      children: Match.Optional(Match.OneOf([Object], Function)),
      collectionName: Match.Optional(String)
    });
    this.subscription = subscription;
    this.options = options;
    this.args = args || [];
    this.childrenOptions = options.children || [];
    this.publishedDocs = new PublishedDocumentList();
    this.collectionName = options.collectionName;
  }

  publish() {
    this.cursor = this._getCursor();

    if (!this.cursor) {
      return;
    }

    const collectionName = this._getCollectionName(); // Use Meteor.bindEnvironment to make sure the callbacks are run with the same
    // environmentVariables as when publishing the "parent".
    // It's only needed when publish is being recursively run.


    this.observeHandle = this.cursor.observe({
      added: Meteor.bindEnvironment(doc => {
        const alreadyPublished = this.publishedDocs.has(doc._id);

        if (alreadyPublished) {
          debugLog('Publication.observeHandle.added', "".concat(collectionName, ":").concat(doc._id, " already published"));
          this.publishedDocs.unflagForRemoval(doc._id);

          this._republishChildrenOf(doc);

          this.subscription.changed(collectionName, doc._id, doc);
        } else {
          this.publishedDocs.add(collectionName, doc._id);

          this._publishChildrenOf(doc);

          this.subscription.added(collectionName, doc);
        }
      }),
      changed: Meteor.bindEnvironment(newDoc => {
        debugLog('Publication.observeHandle.changed', "".concat(collectionName, ":").concat(newDoc._id));

        this._republishChildrenOf(newDoc);
      }),
      removed: doc => {
        debugLog('Publication.observeHandle.removed', "".concat(collectionName, ":").concat(doc._id));

        this._removeDoc(collectionName, doc._id);
      }
    });
    this.observeChangesHandle = this.cursor.observeChanges({
      changed: (id, fields) => {
        debugLog('Publication.observeChangesHandle.changed', "".concat(collectionName, ":").concat(id));
        this.subscription.changed(collectionName, id, fields);
      }
    });
  }

  unpublish() {
    debugLog('Publication.unpublish', this._getCollectionName());

    this._stopObservingCursor();

    this._unpublishAllDocuments();
  }

  _republish() {
    this._stopObservingCursor();

    this.publishedDocs.flagAllForRemoval();
    debugLog('Publication._republish', 'run .publish again');
    this.publish();
    debugLog('Publication._republish', 'unpublish docs from old cursor');

    this._removeFlaggedDocs();
  }

  _getCursor() {
    return this.options.find.apply(this.subscription.meteorSub, this.args);
  }

  _getCollectionName() {
    return this.collectionName || this.cursor && this.cursor._getCollectionName();
  }

  _publishChildrenOf(doc) {
    const children = _.isFunction(this.childrenOptions) ? this.childrenOptions(doc, ...this.args) : this.childrenOptions;

    _.each(children, function createChildPublication(options) {
      const pub = new Publication(this.subscription, options, [doc].concat(this.args));
      this.publishedDocs.addChildPub(doc._id, pub);
      pub.publish();
    }, this);
  }

  _republishChildrenOf(doc) {
    this.publishedDocs.eachChildPub(doc._id, publication => {
      publication.args[0] = doc;

      publication._republish();
    });
  }

  _unpublishAllDocuments() {
    this.publishedDocs.eachDocument(doc => {
      this._removeDoc(doc.collectionName, doc.docId);
    }, this);
  }

  _stopObservingCursor() {
    debugLog('Publication._stopObservingCursor', 'stop observing cursor');

    if (this.observeHandle) {
      this.observeHandle.stop();
      delete this.observeHandle;
    }

    if (this.observeChangesHandle) {
      this.observeChangesHandle.stop();
      delete this.observeChangesHandle;
    }
  }

  _removeFlaggedDocs() {
    this.publishedDocs.eachDocument(doc => {
      if (doc.isFlaggedForRemoval()) {
        this._removeDoc(doc.collectionName, doc.docId);
      }
    }, this);
  }

  _removeDoc(collectionName, docId) {
    this.subscription.removed(collectionName, docId);

    this._unpublishChildrenOf(docId);

    this.publishedDocs.remove(docId);
  }

  _unpublishChildrenOf(docId) {
    debugLog('Publication._unpublishChildrenOf', "unpublishing children of ".concat(this._getCollectionName(), ":").concat(docId));
    this.publishedDocs.eachChildPub(docId, publication => {
      publication.unpublish();
    });
  }

}

module.exportDefault(Publication);
////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"subscription.js":function module(require,exports,module){

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                        //
// packages/reywood_publish-composite/lib/subscription.js                                                 //
//                                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                          //
let _;

module.link("meteor/underscore", {
  _(v) {
    _ = v;
  }

}, 0);
let DocumentRefCounter;
module.link("./doc_ref_counter", {
  default(v) {
    DocumentRefCounter = v;
  }

}, 1);
let debugLog;
module.link("./logging", {
  debugLog(v) {
    debugLog = v;
  }

}, 2);

class Subscription {
  constructor(meteorSub) {
    this.meteorSub = meteorSub;
    this.docHash = {};
    this.refCounter = new DocumentRefCounter({
      onChange: (collectionName, docId, refCount) => {
        debugLog('Subscription.refCounter.onChange', "".concat(collectionName, ":").concat(docId.valueOf(), " ").concat(refCount));

        if (refCount <= 0) {
          meteorSub.removed(collectionName, docId);

          this._removeDocHash(collectionName, docId);
        }
      }
    });
  }

  added(collectionName, doc) {
    this.refCounter.increment(collectionName, doc._id);

    if (this._hasDocChanged(collectionName, doc._id, doc)) {
      debugLog('Subscription.added', "".concat(collectionName, ":").concat(doc._id));
      this.meteorSub.added(collectionName, doc._id, doc);

      this._addDocHash(collectionName, doc);
    }
  }

  changed(collectionName, id, changes) {
    if (this._shouldSendChanges(collectionName, id, changes)) {
      debugLog('Subscription.changed', "".concat(collectionName, ":").concat(id));
      this.meteorSub.changed(collectionName, id, changes);

      this._updateDocHash(collectionName, id, changes);
    }
  }

  removed(collectionName, id) {
    debugLog('Subscription.removed', "".concat(collectionName, ":").concat(id.valueOf()));
    this.refCounter.decrement(collectionName, id);
  }

  _addDocHash(collectionName, doc) {
    this.docHash[buildHashKey(collectionName, doc._id)] = doc;
  }

  _updateDocHash(collectionName, id, changes) {
    const key = buildHashKey(collectionName, id);
    const existingDoc = this.docHash[key] || {};
    this.docHash[key] = _.extend(existingDoc, changes);
  }

  _shouldSendChanges(collectionName, id, changes) {
    return this._isDocPublished(collectionName, id) && this._hasDocChanged(collectionName, id, changes);
  }

  _isDocPublished(collectionName, id) {
    const key = buildHashKey(collectionName, id);
    return !!this.docHash[key];
  }

  _hasDocChanged(collectionName, id, doc) {
    const existingDoc = this.docHash[buildHashKey(collectionName, id)];

    if (!existingDoc) {
      return true;
    }

    return _.any(_.keys(doc), key => !_.isEqual(doc[key], existingDoc[key]));
  }

  _removeDocHash(collectionName, id) {
    const key = buildHashKey(collectionName, id);
    delete this.docHash[key];
  }

}

function buildHashKey(collectionName, id) {
  return "".concat(collectionName, "::").concat(id.valueOf());
}

module.exportDefault(Subscription);
////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"published_document.js":function module(require,exports,module){

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                        //
// packages/reywood_publish-composite/lib/published_document.js                                           //
//                                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                          //
class PublishedDocument {
  constructor(collectionName, docId) {
    this.collectionName = collectionName;
    this.docId = docId;
    this.childPublications = [];
    this._isFlaggedForRemoval = false;
  }

  addChildPub(childPublication) {
    this.childPublications.push(childPublication);
  }

  eachChildPub(callback) {
    this.childPublications.forEach(callback);
  }

  isFlaggedForRemoval() {
    return this._isFlaggedForRemoval;
  }

  unflagForRemoval() {
    this._isFlaggedForRemoval = false;
  }

  flagForRemoval() {
    this._isFlaggedForRemoval = true;
  }

}

module.exportDefault(PublishedDocument);
////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"published_document_list.js":function module(require,exports,module){

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                        //
// packages/reywood_publish-composite/lib/published_document_list.js                                      //
//                                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                          //
let _;

module.link("meteor/underscore", {
  _(v) {
    _ = v;
  }

}, 0);
let PublishedDocument;
module.link("./published_document", {
  default(v) {
    PublishedDocument = v;
  }

}, 1);

class PublishedDocumentList {
  constructor() {
    this.documents = {};
  }

  add(collectionName, docId) {
    const key = valueOfId(docId);

    if (!this.documents[key]) {
      this.documents[key] = new PublishedDocument(collectionName, docId);
    }
  }

  addChildPub(docId, publication) {
    if (!publication) {
      return;
    }

    const key = valueOfId(docId);
    const doc = this.documents[key];

    if (typeof doc === 'undefined') {
      throw new Error("Doc not found in list: ".concat(key));
    }

    this.documents[key].addChildPub(publication);
  }

  get(docId) {
    const key = valueOfId(docId);
    return this.documents[key];
  }

  remove(docId) {
    const key = valueOfId(docId);
    delete this.documents[key];
  }

  has(docId) {
    return !!this.get(docId);
  }

  eachDocument(callback, context) {
    _.each(this.documents, function execCallbackOnDoc(doc) {
      callback.call(this, doc);
    }, context || this);
  }

  eachChildPub(docId, callback) {
    const doc = this.get(docId);

    if (doc) {
      doc.eachChildPub(callback);
    }
  }

  getIds() {
    const docIds = [];
    this.eachDocument(doc => {
      docIds.push(doc.docId);
    });
    return docIds;
  }

  unflagForRemoval(docId) {
    const doc = this.get(docId);

    if (doc) {
      doc.unflagForRemoval();
    }
  }

  flagAllForRemoval() {
    this.eachDocument(doc => {
      doc.flagForRemoval();
    });
  }

}

function valueOfId(docId) {
  if (docId === null) {
    throw new Error('Document ID is null');
  }

  if (typeof docId === 'undefined') {
    throw new Error('Document ID is undefined');
  }

  return docId.valueOf();
}

module.exportDefault(PublishedDocumentList);
////////////////////////////////////////////////////////////////////////////////////////////////////////////

}}}}}},{
  "extensions": [
    ".js",
    ".json"
  ]
});

var exports = require("/node_modules/meteor/reywood:publish-composite/lib/publish_composite.js");
require("/node_modules/meteor/reywood:publish-composite/lib/doc_ref_counter.js");
require("/node_modules/meteor/reywood:publish-composite/lib/logging.js");
require("/node_modules/meteor/reywood:publish-composite/lib/publication.js");
require("/node_modules/meteor/reywood:publish-composite/lib/subscription.js");

/* Exports */
Package._define("reywood:publish-composite", exports, {
  enableDebugLogging: enableDebugLogging,
  publishComposite: publishComposite
});

})();

//# sourceURL=meteor://💻app/packages/reywood_publish-composite.js
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvcmV5d29vZDpwdWJsaXNoLWNvbXBvc2l0ZS9saWIvcHVibGlzaF9jb21wb3NpdGUuanMiLCJtZXRlb3I6Ly/wn5K7YXBwL3BhY2thZ2VzL3JleXdvb2Q6cHVibGlzaC1jb21wb3NpdGUvbGliL2RvY19yZWZfY291bnRlci5qcyIsIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvcmV5d29vZDpwdWJsaXNoLWNvbXBvc2l0ZS9saWIvbG9nZ2luZy5qcyIsIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvcmV5d29vZDpwdWJsaXNoLWNvbXBvc2l0ZS9saWIvcHVibGljYXRpb24uanMiLCJtZXRlb3I6Ly/wn5K7YXBwL3BhY2thZ2VzL3JleXdvb2Q6cHVibGlzaC1jb21wb3NpdGUvbGliL3N1YnNjcmlwdGlvbi5qcyIsIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvcmV5d29vZDpwdWJsaXNoLWNvbXBvc2l0ZS9saWIvcHVibGlzaGVkX2RvY3VtZW50LmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9wYWNrYWdlcy9yZXl3b29kOnB1Ymxpc2gtY29tcG9zaXRlL2xpYi9wdWJsaXNoZWRfZG9jdW1lbnRfbGlzdC5qcyJdLCJuYW1lcyI6WyJtb2R1bGUiLCJleHBvcnQiLCJlbmFibGVEZWJ1Z0xvZ2dpbmciLCJwdWJsaXNoQ29tcG9zaXRlIiwiTWV0ZW9yIiwibGluayIsInYiLCJQdWJsaWNhdGlvbiIsImRlZmF1bHQiLCJTdWJzY3JpcHRpb24iLCJkZWJ1Z0xvZyIsIm5hbWUiLCJvcHRpb25zIiwicHVibGlzaCIsInN1YnNjcmlwdGlvbiIsImFyZ3MiLCJpbnN0YW5jZU9wdGlvbnMiLCJwcmVwYXJlT3B0aW9ucyIsImNhbGwiLCJwdWJsaWNhdGlvbnMiLCJmb3JFYWNoIiwib3B0IiwicHViIiwicHVzaCIsIm9uU3RvcCIsInVucHVibGlzaCIsInJlYWR5IiwicHJlcGFyZWRPcHRpb25zIiwiYXBwbHkiLCJBcnJheSIsImlzQXJyYXkiLCJEb2N1bWVudFJlZkNvdW50ZXIiLCJjb25zdHJ1Y3RvciIsIm9ic2VydmVyIiwiaGVhcCIsImluY3JlbWVudCIsImNvbGxlY3Rpb25OYW1lIiwiZG9jSWQiLCJrZXkiLCJ2YWx1ZU9mIiwiZGVjcmVtZW50Iiwib25DaGFuZ2UiLCJleHBvcnREZWZhdWx0IiwiZGVidWdMb2dnaW5nRW5hYmxlZCIsInNvdXJjZSIsIm1lc3NhZ2UiLCJwYWRkZWRTb3VyY2UiLCJsZW5ndGgiLCJjb25zb2xlIiwibG9nIiwiTWF0Y2giLCJjaGVjayIsIl8iLCJQdWJsaXNoZWREb2N1bWVudExpc3QiLCJmaW5kIiwiRnVuY3Rpb24iLCJjaGlsZHJlbiIsIk9wdGlvbmFsIiwiT25lT2YiLCJPYmplY3QiLCJTdHJpbmciLCJjaGlsZHJlbk9wdGlvbnMiLCJwdWJsaXNoZWREb2NzIiwiY3Vyc29yIiwiX2dldEN1cnNvciIsIl9nZXRDb2xsZWN0aW9uTmFtZSIsIm9ic2VydmVIYW5kbGUiLCJvYnNlcnZlIiwiYWRkZWQiLCJiaW5kRW52aXJvbm1lbnQiLCJkb2MiLCJhbHJlYWR5UHVibGlzaGVkIiwiaGFzIiwiX2lkIiwidW5mbGFnRm9yUmVtb3ZhbCIsIl9yZXB1Ymxpc2hDaGlsZHJlbk9mIiwiY2hhbmdlZCIsImFkZCIsIl9wdWJsaXNoQ2hpbGRyZW5PZiIsIm5ld0RvYyIsInJlbW92ZWQiLCJfcmVtb3ZlRG9jIiwib2JzZXJ2ZUNoYW5nZXNIYW5kbGUiLCJvYnNlcnZlQ2hhbmdlcyIsImlkIiwiZmllbGRzIiwiX3N0b3BPYnNlcnZpbmdDdXJzb3IiLCJfdW5wdWJsaXNoQWxsRG9jdW1lbnRzIiwiX3JlcHVibGlzaCIsImZsYWdBbGxGb3JSZW1vdmFsIiwiX3JlbW92ZUZsYWdnZWREb2NzIiwibWV0ZW9yU3ViIiwiaXNGdW5jdGlvbiIsImVhY2giLCJjcmVhdGVDaGlsZFB1YmxpY2F0aW9uIiwiY29uY2F0IiwiYWRkQ2hpbGRQdWIiLCJlYWNoQ2hpbGRQdWIiLCJwdWJsaWNhdGlvbiIsImVhY2hEb2N1bWVudCIsInN0b3AiLCJpc0ZsYWdnZWRGb3JSZW1vdmFsIiwiX3VucHVibGlzaENoaWxkcmVuT2YiLCJyZW1vdmUiLCJkb2NIYXNoIiwicmVmQ291bnRlciIsInJlZkNvdW50IiwiX3JlbW92ZURvY0hhc2giLCJfaGFzRG9jQ2hhbmdlZCIsIl9hZGREb2NIYXNoIiwiY2hhbmdlcyIsIl9zaG91bGRTZW5kQ2hhbmdlcyIsIl91cGRhdGVEb2NIYXNoIiwiYnVpbGRIYXNoS2V5IiwiZXhpc3RpbmdEb2MiLCJleHRlbmQiLCJfaXNEb2NQdWJsaXNoZWQiLCJhbnkiLCJrZXlzIiwiaXNFcXVhbCIsIlB1Ymxpc2hlZERvY3VtZW50IiwiY2hpbGRQdWJsaWNhdGlvbnMiLCJfaXNGbGFnZ2VkRm9yUmVtb3ZhbCIsImNoaWxkUHVibGljYXRpb24iLCJjYWxsYmFjayIsImZsYWdGb3JSZW1vdmFsIiwiZG9jdW1lbnRzIiwidmFsdWVPZklkIiwiRXJyb3IiLCJnZXQiLCJjb250ZXh0IiwiZXhlY0NhbGxiYWNrT25Eb2MiLCJnZXRJZHMiLCJkb2NJZHMiXSwibWFwcGluZ3MiOiI7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OztBQUFBQSxNQUFNLENBQUNDLE1BQVAsQ0FBYztBQUFDQyxvQkFBa0IsRUFBQyxNQUFJQSxrQkFBeEI7QUFBMkNDLGtCQUFnQixFQUFDLE1BQUlBO0FBQWhFLENBQWQ7QUFBaUcsSUFBSUMsTUFBSjtBQUFXSixNQUFNLENBQUNLLElBQVAsQ0FBWSxlQUFaLEVBQTRCO0FBQUNELFFBQU0sQ0FBQ0UsQ0FBRCxFQUFHO0FBQUNGLFVBQU0sR0FBQ0UsQ0FBUDtBQUFTOztBQUFwQixDQUE1QixFQUFrRCxDQUFsRDtBQUFxRCxJQUFJQyxXQUFKO0FBQWdCUCxNQUFNLENBQUNLLElBQVAsQ0FBWSxlQUFaLEVBQTRCO0FBQUNHLFNBQU8sQ0FBQ0YsQ0FBRCxFQUFHO0FBQUNDLGVBQVcsR0FBQ0QsQ0FBWjtBQUFjOztBQUExQixDQUE1QixFQUF3RCxDQUF4RDtBQUEyRCxJQUFJRyxZQUFKO0FBQWlCVCxNQUFNLENBQUNLLElBQVAsQ0FBWSxnQkFBWixFQUE2QjtBQUFDRyxTQUFPLENBQUNGLENBQUQsRUFBRztBQUFDRyxnQkFBWSxHQUFDSCxDQUFiO0FBQWU7O0FBQTNCLENBQTdCLEVBQTBELENBQTFEO0FBQTZELElBQUlJLFFBQUosRUFBYVIsa0JBQWI7QUFBZ0NGLE1BQU0sQ0FBQ0ssSUFBUCxDQUFZLFdBQVosRUFBd0I7QUFBQ0ssVUFBUSxDQUFDSixDQUFELEVBQUc7QUFBQ0ksWUFBUSxHQUFDSixDQUFUO0FBQVcsR0FBeEI7O0FBQXlCSixvQkFBa0IsQ0FBQ0ksQ0FBRCxFQUFHO0FBQUNKLHNCQUFrQixHQUFDSSxDQUFuQjtBQUFxQjs7QUFBcEUsQ0FBeEIsRUFBOEYsQ0FBOUY7O0FBTzFWLFNBQVNILGdCQUFULENBQTBCUSxJQUExQixFQUFnQ0MsT0FBaEMsRUFBeUM7QUFDckMsU0FBT1IsTUFBTSxDQUFDUyxPQUFQLENBQWVGLElBQWYsRUFBcUIsU0FBU0UsT0FBVCxHQUEwQjtBQUNsRCxVQUFNQyxZQUFZLEdBQUcsSUFBSUwsWUFBSixDQUFpQixJQUFqQixDQUFyQjs7QUFEa0Qsc0NBQU5NLElBQU07QUFBTkEsVUFBTTtBQUFBOztBQUVsRCxVQUFNQyxlQUFlLEdBQUdDLGNBQWMsQ0FBQ0MsSUFBZixDQUFvQixJQUFwQixFQUEwQk4sT0FBMUIsRUFBbUNHLElBQW5DLENBQXhCO0FBQ0EsVUFBTUksWUFBWSxHQUFHLEVBQXJCO0FBRUFILG1CQUFlLENBQUNJLE9BQWhCLENBQXlCQyxHQUFELElBQVM7QUFDN0IsWUFBTUMsR0FBRyxHQUFHLElBQUlmLFdBQUosQ0FBZ0JPLFlBQWhCLEVBQThCTyxHQUE5QixDQUFaO0FBQ0FDLFNBQUcsQ0FBQ1QsT0FBSjtBQUNBTSxrQkFBWSxDQUFDSSxJQUFiLENBQWtCRCxHQUFsQjtBQUNILEtBSkQ7QUFNQSxTQUFLRSxNQUFMLENBQVksTUFBTTtBQUNkTCxrQkFBWSxDQUFDQyxPQUFiLENBQXFCRSxHQUFHLElBQUlBLEdBQUcsQ0FBQ0csU0FBSixFQUE1QjtBQUNILEtBRkQ7QUFJQWYsWUFBUSxDQUFDLGdCQUFELEVBQW1CLE9BQW5CLENBQVI7QUFDQSxTQUFLZ0IsS0FBTDtBQUNILEdBakJNLENBQVA7QUFrQkgsQyxDQUVEOzs7QUFDQXRCLE1BQU0sQ0FBQ0QsZ0JBQVAsR0FBMEJBLGdCQUExQjs7QUFFQSxTQUFTYyxjQUFULENBQXdCTCxPQUF4QixFQUFpQ0csSUFBakMsRUFBdUM7QUFDbkMsTUFBSVksZUFBZSxHQUFHZixPQUF0Qjs7QUFFQSxNQUFJLE9BQU9lLGVBQVAsS0FBMkIsVUFBL0IsRUFBMkM7QUFDdkNBLG1CQUFlLEdBQUdBLGVBQWUsQ0FBQ0MsS0FBaEIsQ0FBc0IsSUFBdEIsRUFBNEJiLElBQTVCLENBQWxCO0FBQ0g7O0FBRUQsTUFBSSxDQUFDWSxlQUFMLEVBQXNCO0FBQ2xCLFdBQU8sRUFBUDtBQUNIOztBQUVELE1BQUksQ0FBQ0UsS0FBSyxDQUFDQyxPQUFOLENBQWNILGVBQWQsQ0FBTCxFQUFxQztBQUNqQ0EsbUJBQWUsR0FBRyxDQUFDQSxlQUFELENBQWxCO0FBQ0g7O0FBRUQsU0FBT0EsZUFBUDtBQUNILEM7Ozs7Ozs7Ozs7O0FDL0NELE1BQU1JLGtCQUFOLENBQXlCO0FBQ3JCQyxhQUFXLENBQUNDLFFBQUQsRUFBVztBQUNsQixTQUFLQyxJQUFMLEdBQVksRUFBWjtBQUNBLFNBQUtELFFBQUwsR0FBZ0JBLFFBQWhCO0FBQ0g7O0FBRURFLFdBQVMsQ0FBQ0MsY0FBRCxFQUFpQkMsS0FBakIsRUFBd0I7QUFDN0IsVUFBTUMsR0FBRyxhQUFNRixjQUFOLGNBQXdCQyxLQUFLLENBQUNFLE9BQU4sRUFBeEIsQ0FBVDs7QUFDQSxRQUFJLENBQUMsS0FBS0wsSUFBTCxDQUFVSSxHQUFWLENBQUwsRUFBcUI7QUFDakIsV0FBS0osSUFBTCxDQUFVSSxHQUFWLElBQWlCLENBQWpCO0FBQ0g7O0FBQ0QsU0FBS0osSUFBTCxDQUFVSSxHQUFWLEtBQWtCLENBQWxCO0FBQ0g7O0FBRURFLFdBQVMsQ0FBQ0osY0FBRCxFQUFpQkMsS0FBakIsRUFBd0I7QUFDN0IsVUFBTUMsR0FBRyxhQUFNRixjQUFOLGNBQXdCQyxLQUFLLENBQUNFLE9BQU4sRUFBeEIsQ0FBVDs7QUFDQSxRQUFJLEtBQUtMLElBQUwsQ0FBVUksR0FBVixDQUFKLEVBQW9CO0FBQ2hCLFdBQUtKLElBQUwsQ0FBVUksR0FBVixLQUFrQixDQUFsQjtBQUVBLFdBQUtMLFFBQUwsQ0FBY1EsUUFBZCxDQUF1QkwsY0FBdkIsRUFBdUNDLEtBQXZDLEVBQThDLEtBQUtILElBQUwsQ0FBVUksR0FBVixDQUE5QztBQUNIO0FBQ0o7O0FBckJvQjs7QUFBekJ0QyxNQUFNLENBQUMwQyxhQUFQLENBd0JlWCxrQkF4QmYsRTs7Ozs7Ozs7Ozs7QUNBQS9CLE1BQU0sQ0FBQ0MsTUFBUCxDQUFjO0FBQUNTLFVBQVEsRUFBQyxNQUFJQSxRQUFkO0FBQXVCUixvQkFBa0IsRUFBQyxNQUFJQTtBQUE5QyxDQUFkOztBQUFBO0FBRUEsSUFBSXlDLG1CQUFtQixHQUFHLEtBQTFCOztBQUVBLFNBQVNqQyxRQUFULENBQWtCa0MsTUFBbEIsRUFBMEJDLE9BQTFCLEVBQW1DO0FBQy9CLE1BQUksQ0FBQ0YsbUJBQUwsRUFBMEI7QUFBRTtBQUFTOztBQUNyQyxNQUFJRyxZQUFZLEdBQUdGLE1BQW5COztBQUNBLFNBQU9FLFlBQVksQ0FBQ0MsTUFBYixHQUFzQixFQUE3QixFQUFpQztBQUFFRCxnQkFBWSxJQUFJLEdBQWhCO0FBQXNCOztBQUN6REUsU0FBTyxDQUFDQyxHQUFSLFlBQWdCSCxZQUFoQixlQUFpQ0QsT0FBakM7QUFDSDs7QUFFRCxTQUFTM0Msa0JBQVQsR0FBOEI7QUFDMUJ5QyxxQkFBbUIsR0FBRyxJQUF0QjtBQUNILEM7Ozs7Ozs7Ozs7O0FDYkQsSUFBSXZDLE1BQUo7QUFBV0osTUFBTSxDQUFDSyxJQUFQLENBQVksZUFBWixFQUE0QjtBQUFDRCxRQUFNLENBQUNFLENBQUQsRUFBRztBQUFDRixVQUFNLEdBQUNFLENBQVA7QUFBUzs7QUFBcEIsQ0FBNUIsRUFBa0QsQ0FBbEQ7QUFBcUQsSUFBSTRDLEtBQUosRUFBVUMsS0FBVjtBQUFnQm5ELE1BQU0sQ0FBQ0ssSUFBUCxDQUFZLGNBQVosRUFBMkI7QUFBQzZDLE9BQUssQ0FBQzVDLENBQUQsRUFBRztBQUFDNEMsU0FBSyxHQUFDNUMsQ0FBTjtBQUFRLEdBQWxCOztBQUFtQjZDLE9BQUssQ0FBQzdDLENBQUQsRUFBRztBQUFDNkMsU0FBSyxHQUFDN0MsQ0FBTjtBQUFROztBQUFwQyxDQUEzQixFQUFpRSxDQUFqRTs7QUFBb0UsSUFBSThDLENBQUo7O0FBQU1wRCxNQUFNLENBQUNLLElBQVAsQ0FBWSxtQkFBWixFQUFnQztBQUFDK0MsR0FBQyxDQUFDOUMsQ0FBRCxFQUFHO0FBQUM4QyxLQUFDLEdBQUM5QyxDQUFGO0FBQUk7O0FBQVYsQ0FBaEMsRUFBNEMsQ0FBNUM7QUFBK0MsSUFBSUksUUFBSjtBQUFhVixNQUFNLENBQUNLLElBQVAsQ0FBWSxXQUFaLEVBQXdCO0FBQUNLLFVBQVEsQ0FBQ0osQ0FBRCxFQUFHO0FBQUNJLFlBQVEsR0FBQ0osQ0FBVDtBQUFXOztBQUF4QixDQUF4QixFQUFrRCxDQUFsRDtBQUFxRCxJQUFJK0MscUJBQUo7QUFBMEJyRCxNQUFNLENBQUNLLElBQVAsQ0FBWSwyQkFBWixFQUF3QztBQUFDRyxTQUFPLENBQUNGLENBQUQsRUFBRztBQUFDK0MseUJBQXFCLEdBQUMvQyxDQUF0QjtBQUF3Qjs7QUFBcEMsQ0FBeEMsRUFBOEUsQ0FBOUU7O0FBUXJTLE1BQU1DLFdBQU4sQ0FBa0I7QUFDZHlCLGFBQVcsQ0FBQ2xCLFlBQUQsRUFBZUYsT0FBZixFQUF3QkcsSUFBeEIsRUFBOEI7QUFDckNvQyxTQUFLLENBQUN2QyxPQUFELEVBQVU7QUFDWDBDLFVBQUksRUFBRUMsUUFESztBQUVYQyxjQUFRLEVBQUVOLEtBQUssQ0FBQ08sUUFBTixDQUFlUCxLQUFLLENBQUNRLEtBQU4sQ0FBWSxDQUFDQyxNQUFELENBQVosRUFBc0JKLFFBQXRCLENBQWYsQ0FGQztBQUdYbkIsb0JBQWMsRUFBRWMsS0FBSyxDQUFDTyxRQUFOLENBQWVHLE1BQWY7QUFITCxLQUFWLENBQUw7QUFNQSxTQUFLOUMsWUFBTCxHQUFvQkEsWUFBcEI7QUFDQSxTQUFLRixPQUFMLEdBQWVBLE9BQWY7QUFDQSxTQUFLRyxJQUFMLEdBQVlBLElBQUksSUFBSSxFQUFwQjtBQUNBLFNBQUs4QyxlQUFMLEdBQXVCakQsT0FBTyxDQUFDNEMsUUFBUixJQUFvQixFQUEzQztBQUNBLFNBQUtNLGFBQUwsR0FBcUIsSUFBSVQscUJBQUosRUFBckI7QUFDQSxTQUFLakIsY0FBTCxHQUFzQnhCLE9BQU8sQ0FBQ3dCLGNBQTlCO0FBQ0g7O0FBRUR2QixTQUFPLEdBQUc7QUFDTixTQUFLa0QsTUFBTCxHQUFjLEtBQUtDLFVBQUwsRUFBZDs7QUFDQSxRQUFJLENBQUMsS0FBS0QsTUFBVixFQUFrQjtBQUFFO0FBQVM7O0FBRTdCLFVBQU0zQixjQUFjLEdBQUcsS0FBSzZCLGtCQUFMLEVBQXZCLENBSk0sQ0FNTjtBQUNBO0FBQ0E7OztBQUNBLFNBQUtDLGFBQUwsR0FBcUIsS0FBS0gsTUFBTCxDQUFZSSxPQUFaLENBQW9CO0FBQ3JDQyxXQUFLLEVBQUVoRSxNQUFNLENBQUNpRSxlQUFQLENBQXdCQyxHQUFELElBQVM7QUFDbkMsY0FBTUMsZ0JBQWdCLEdBQUcsS0FBS1QsYUFBTCxDQUFtQlUsR0FBbkIsQ0FBdUJGLEdBQUcsQ0FBQ0csR0FBM0IsQ0FBekI7O0FBRUEsWUFBSUYsZ0JBQUosRUFBc0I7QUFDbEI3RCxrQkFBUSxDQUFDLGlDQUFELFlBQXVDMEIsY0FBdkMsY0FBeURrQyxHQUFHLENBQUNHLEdBQTdELHdCQUFSO0FBQ0EsZUFBS1gsYUFBTCxDQUFtQlksZ0JBQW5CLENBQW9DSixHQUFHLENBQUNHLEdBQXhDOztBQUNBLGVBQUtFLG9CQUFMLENBQTBCTCxHQUExQjs7QUFDQSxlQUFLeEQsWUFBTCxDQUFrQjhELE9BQWxCLENBQTBCeEMsY0FBMUIsRUFBMENrQyxHQUFHLENBQUNHLEdBQTlDLEVBQW1ESCxHQUFuRDtBQUNILFNBTEQsTUFLTztBQUNILGVBQUtSLGFBQUwsQ0FBbUJlLEdBQW5CLENBQXVCekMsY0FBdkIsRUFBdUNrQyxHQUFHLENBQUNHLEdBQTNDOztBQUNBLGVBQUtLLGtCQUFMLENBQXdCUixHQUF4Qjs7QUFDQSxlQUFLeEQsWUFBTCxDQUFrQnNELEtBQWxCLENBQXdCaEMsY0FBeEIsRUFBd0NrQyxHQUF4QztBQUNIO0FBQ0osT0FiTSxDQUQ4QjtBQWVyQ00sYUFBTyxFQUFFeEUsTUFBTSxDQUFDaUUsZUFBUCxDQUF3QlUsTUFBRCxJQUFZO0FBQ3hDckUsZ0JBQVEsQ0FBQyxtQ0FBRCxZQUF5QzBCLGNBQXpDLGNBQTJEMkMsTUFBTSxDQUFDTixHQUFsRSxFQUFSOztBQUNBLGFBQUtFLG9CQUFMLENBQTBCSSxNQUExQjtBQUNILE9BSFEsQ0FmNEI7QUFtQnJDQyxhQUFPLEVBQUdWLEdBQUQsSUFBUztBQUNkNUQsZ0JBQVEsQ0FBQyxtQ0FBRCxZQUF5QzBCLGNBQXpDLGNBQTJEa0MsR0FBRyxDQUFDRyxHQUEvRCxFQUFSOztBQUNBLGFBQUtRLFVBQUwsQ0FBZ0I3QyxjQUFoQixFQUFnQ2tDLEdBQUcsQ0FBQ0csR0FBcEM7QUFDSDtBQXRCb0MsS0FBcEIsQ0FBckI7QUF5QkEsU0FBS1Msb0JBQUwsR0FBNEIsS0FBS25CLE1BQUwsQ0FBWW9CLGNBQVosQ0FBMkI7QUFDbkRQLGFBQU8sRUFBRSxDQUFDUSxFQUFELEVBQUtDLE1BQUwsS0FBZ0I7QUFDckIzRSxnQkFBUSxDQUFDLDBDQUFELFlBQWdEMEIsY0FBaEQsY0FBa0VnRCxFQUFsRSxFQUFSO0FBQ0EsYUFBS3RFLFlBQUwsQ0FBa0I4RCxPQUFsQixDQUEwQnhDLGNBQTFCLEVBQTBDZ0QsRUFBMUMsRUFBOENDLE1BQTlDO0FBQ0g7QUFKa0QsS0FBM0IsQ0FBNUI7QUFNSDs7QUFFRDVELFdBQVMsR0FBRztBQUNSZixZQUFRLENBQUMsdUJBQUQsRUFBMEIsS0FBS3VELGtCQUFMLEVBQTFCLENBQVI7O0FBQ0EsU0FBS3FCLG9CQUFMOztBQUNBLFNBQUtDLHNCQUFMO0FBQ0g7O0FBRURDLFlBQVUsR0FBRztBQUNULFNBQUtGLG9CQUFMOztBQUVBLFNBQUt4QixhQUFMLENBQW1CMkIsaUJBQW5CO0FBRUEvRSxZQUFRLENBQUMsd0JBQUQsRUFBMkIsb0JBQTNCLENBQVI7QUFDQSxTQUFLRyxPQUFMO0FBRUFILFlBQVEsQ0FBQyx3QkFBRCxFQUEyQixnQ0FBM0IsQ0FBUjs7QUFDQSxTQUFLZ0Ysa0JBQUw7QUFDSDs7QUFFRDFCLFlBQVUsR0FBRztBQUNULFdBQU8sS0FBS3BELE9BQUwsQ0FBYTBDLElBQWIsQ0FBa0IxQixLQUFsQixDQUF3QixLQUFLZCxZQUFMLENBQWtCNkUsU0FBMUMsRUFBcUQsS0FBSzVFLElBQTFELENBQVA7QUFDSDs7QUFFRGtELG9CQUFrQixHQUFHO0FBQ2pCLFdBQU8sS0FBSzdCLGNBQUwsSUFBd0IsS0FBSzJCLE1BQUwsSUFBZSxLQUFLQSxNQUFMLENBQVlFLGtCQUFaLEVBQTlDO0FBQ0g7O0FBRURhLG9CQUFrQixDQUFDUixHQUFELEVBQU07QUFDcEIsVUFBTWQsUUFBUSxHQUFHSixDQUFDLENBQUN3QyxVQUFGLENBQWEsS0FBSy9CLGVBQWxCLElBQ2pCLEtBQUtBLGVBQUwsQ0FBcUJTLEdBQXJCLEVBQTBCLEdBQUcsS0FBS3ZELElBQWxDLENBRGlCLEdBQ3lCLEtBQUs4QyxlQUQvQzs7QUFFQVQsS0FBQyxDQUFDeUMsSUFBRixDQUFPckMsUUFBUCxFQUFpQixTQUFTc0Msc0JBQVQsQ0FBZ0NsRixPQUFoQyxFQUF5QztBQUN0RCxZQUFNVSxHQUFHLEdBQUcsSUFBSWYsV0FBSixDQUFnQixLQUFLTyxZQUFyQixFQUFtQ0YsT0FBbkMsRUFBNEMsQ0FBQzBELEdBQUQsRUFBTXlCLE1BQU4sQ0FBYSxLQUFLaEYsSUFBbEIsQ0FBNUMsQ0FBWjtBQUNBLFdBQUsrQyxhQUFMLENBQW1Ca0MsV0FBbkIsQ0FBK0IxQixHQUFHLENBQUNHLEdBQW5DLEVBQXdDbkQsR0FBeEM7QUFDQUEsU0FBRyxDQUFDVCxPQUFKO0FBQ0gsS0FKRCxFQUlHLElBSkg7QUFLSDs7QUFFRDhELHNCQUFvQixDQUFDTCxHQUFELEVBQU07QUFDdEIsU0FBS1IsYUFBTCxDQUFtQm1DLFlBQW5CLENBQWdDM0IsR0FBRyxDQUFDRyxHQUFwQyxFQUEwQ3lCLFdBQUQsSUFBaUI7QUFDdERBLGlCQUFXLENBQUNuRixJQUFaLENBQWlCLENBQWpCLElBQXNCdUQsR0FBdEI7O0FBQ0E0QixpQkFBVyxDQUFDVixVQUFaO0FBQ0gsS0FIRDtBQUlIOztBQUVERCx3QkFBc0IsR0FBRztBQUNyQixTQUFLekIsYUFBTCxDQUFtQnFDLFlBQW5CLENBQWlDN0IsR0FBRCxJQUFTO0FBQ3JDLFdBQUtXLFVBQUwsQ0FBZ0JYLEdBQUcsQ0FBQ2xDLGNBQXBCLEVBQW9Da0MsR0FBRyxDQUFDakMsS0FBeEM7QUFDSCxLQUZELEVBRUcsSUFGSDtBQUdIOztBQUVEaUQsc0JBQW9CLEdBQUc7QUFDbkI1RSxZQUFRLENBQUMsa0NBQUQsRUFBcUMsdUJBQXJDLENBQVI7O0FBRUEsUUFBSSxLQUFLd0QsYUFBVCxFQUF3QjtBQUNwQixXQUFLQSxhQUFMLENBQW1Ca0MsSUFBbkI7QUFDQSxhQUFPLEtBQUtsQyxhQUFaO0FBQ0g7O0FBRUQsUUFBSSxLQUFLZ0Isb0JBQVQsRUFBK0I7QUFDM0IsV0FBS0Esb0JBQUwsQ0FBMEJrQixJQUExQjtBQUNBLGFBQU8sS0FBS2xCLG9CQUFaO0FBQ0g7QUFDSjs7QUFFRFEsb0JBQWtCLEdBQUc7QUFDakIsU0FBSzVCLGFBQUwsQ0FBbUJxQyxZQUFuQixDQUFpQzdCLEdBQUQsSUFBUztBQUNyQyxVQUFJQSxHQUFHLENBQUMrQixtQkFBSixFQUFKLEVBQStCO0FBQzNCLGFBQUtwQixVQUFMLENBQWdCWCxHQUFHLENBQUNsQyxjQUFwQixFQUFvQ2tDLEdBQUcsQ0FBQ2pDLEtBQXhDO0FBQ0g7QUFDSixLQUpELEVBSUcsSUFKSDtBQUtIOztBQUVENEMsWUFBVSxDQUFDN0MsY0FBRCxFQUFpQkMsS0FBakIsRUFBd0I7QUFDOUIsU0FBS3ZCLFlBQUwsQ0FBa0JrRSxPQUFsQixDQUEwQjVDLGNBQTFCLEVBQTBDQyxLQUExQzs7QUFDQSxTQUFLaUUsb0JBQUwsQ0FBMEJqRSxLQUExQjs7QUFDQSxTQUFLeUIsYUFBTCxDQUFtQnlDLE1BQW5CLENBQTBCbEUsS0FBMUI7QUFDSDs7QUFFRGlFLHNCQUFvQixDQUFDakUsS0FBRCxFQUFRO0FBQ3hCM0IsWUFBUSxDQUFDLGtDQUFELHFDQUFpRSxLQUFLdUQsa0JBQUwsRUFBakUsY0FBOEY1QixLQUE5RixFQUFSO0FBRUEsU0FBS3lCLGFBQUwsQ0FBbUJtQyxZQUFuQixDQUFnQzVELEtBQWhDLEVBQXdDNkQsV0FBRCxJQUFpQjtBQUNwREEsaUJBQVcsQ0FBQ3pFLFNBQVo7QUFDSCxLQUZEO0FBR0g7O0FBN0lhOztBQVJsQnpCLE1BQU0sQ0FBQzBDLGFBQVAsQ0F3SmVuQyxXQXhKZixFOzs7Ozs7Ozs7OztBQ0FBLElBQUk2QyxDQUFKOztBQUFNcEQsTUFBTSxDQUFDSyxJQUFQLENBQVksbUJBQVosRUFBZ0M7QUFBQytDLEdBQUMsQ0FBQzlDLENBQUQsRUFBRztBQUFDOEMsS0FBQyxHQUFDOUMsQ0FBRjtBQUFJOztBQUFWLENBQWhDLEVBQTRDLENBQTVDO0FBQStDLElBQUl5QixrQkFBSjtBQUF1Qi9CLE1BQU0sQ0FBQ0ssSUFBUCxDQUFZLG1CQUFaLEVBQWdDO0FBQUNHLFNBQU8sQ0FBQ0YsQ0FBRCxFQUFHO0FBQUN5QixzQkFBa0IsR0FBQ3pCLENBQW5CO0FBQXFCOztBQUFqQyxDQUFoQyxFQUFtRSxDQUFuRTtBQUFzRSxJQUFJSSxRQUFKO0FBQWFWLE1BQU0sQ0FBQ0ssSUFBUCxDQUFZLFdBQVosRUFBd0I7QUFBQ0ssVUFBUSxDQUFDSixDQUFELEVBQUc7QUFBQ0ksWUFBUSxHQUFDSixDQUFUO0FBQVc7O0FBQXhCLENBQXhCLEVBQWtELENBQWxEOztBQU0vSixNQUFNRyxZQUFOLENBQW1CO0FBQ2Z1QixhQUFXLENBQUMyRCxTQUFELEVBQVk7QUFDbkIsU0FBS0EsU0FBTCxHQUFpQkEsU0FBakI7QUFDQSxTQUFLYSxPQUFMLEdBQWUsRUFBZjtBQUNBLFNBQUtDLFVBQUwsR0FBa0IsSUFBSTFFLGtCQUFKLENBQXVCO0FBQ3JDVSxjQUFRLEVBQUUsQ0FBQ0wsY0FBRCxFQUFpQkMsS0FBakIsRUFBd0JxRSxRQUF4QixLQUFxQztBQUMzQ2hHLGdCQUFRLENBQUMsa0NBQUQsWUFBd0MwQixjQUF4QyxjQUEwREMsS0FBSyxDQUFDRSxPQUFOLEVBQTFELGNBQTZFbUUsUUFBN0UsRUFBUjs7QUFDQSxZQUFJQSxRQUFRLElBQUksQ0FBaEIsRUFBbUI7QUFDZmYsbUJBQVMsQ0FBQ1gsT0FBVixDQUFrQjVDLGNBQWxCLEVBQWtDQyxLQUFsQzs7QUFDQSxlQUFLc0UsY0FBTCxDQUFvQnZFLGNBQXBCLEVBQW9DQyxLQUFwQztBQUNIO0FBQ0o7QUFQb0MsS0FBdkIsQ0FBbEI7QUFTSDs7QUFFRCtCLE9BQUssQ0FBQ2hDLGNBQUQsRUFBaUJrQyxHQUFqQixFQUFzQjtBQUN2QixTQUFLbUMsVUFBTCxDQUFnQnRFLFNBQWhCLENBQTBCQyxjQUExQixFQUEwQ2tDLEdBQUcsQ0FBQ0csR0FBOUM7O0FBRUEsUUFBSSxLQUFLbUMsY0FBTCxDQUFvQnhFLGNBQXBCLEVBQW9Da0MsR0FBRyxDQUFDRyxHQUF4QyxFQUE2Q0gsR0FBN0MsQ0FBSixFQUF1RDtBQUNuRDVELGNBQVEsQ0FBQyxvQkFBRCxZQUEwQjBCLGNBQTFCLGNBQTRDa0MsR0FBRyxDQUFDRyxHQUFoRCxFQUFSO0FBQ0EsV0FBS2tCLFNBQUwsQ0FBZXZCLEtBQWYsQ0FBcUJoQyxjQUFyQixFQUFxQ2tDLEdBQUcsQ0FBQ0csR0FBekMsRUFBOENILEdBQTlDOztBQUNBLFdBQUt1QyxXQUFMLENBQWlCekUsY0FBakIsRUFBaUNrQyxHQUFqQztBQUNIO0FBQ0o7O0FBRURNLFNBQU8sQ0FBQ3hDLGNBQUQsRUFBaUJnRCxFQUFqQixFQUFxQjBCLE9BQXJCLEVBQThCO0FBQ2pDLFFBQUksS0FBS0Msa0JBQUwsQ0FBd0IzRSxjQUF4QixFQUF3Q2dELEVBQXhDLEVBQTRDMEIsT0FBNUMsQ0FBSixFQUEwRDtBQUN0RHBHLGNBQVEsQ0FBQyxzQkFBRCxZQUE0QjBCLGNBQTVCLGNBQThDZ0QsRUFBOUMsRUFBUjtBQUNBLFdBQUtPLFNBQUwsQ0FBZWYsT0FBZixDQUF1QnhDLGNBQXZCLEVBQXVDZ0QsRUFBdkMsRUFBMkMwQixPQUEzQzs7QUFDQSxXQUFLRSxjQUFMLENBQW9CNUUsY0FBcEIsRUFBb0NnRCxFQUFwQyxFQUF3QzBCLE9BQXhDO0FBQ0g7QUFDSjs7QUFFRDlCLFNBQU8sQ0FBQzVDLGNBQUQsRUFBaUJnRCxFQUFqQixFQUFxQjtBQUN4QjFFLFlBQVEsQ0FBQyxzQkFBRCxZQUE0QjBCLGNBQTVCLGNBQThDZ0QsRUFBRSxDQUFDN0MsT0FBSCxFQUE5QyxFQUFSO0FBQ0EsU0FBS2tFLFVBQUwsQ0FBZ0JqRSxTQUFoQixDQUEwQkosY0FBMUIsRUFBMENnRCxFQUExQztBQUNIOztBQUVEeUIsYUFBVyxDQUFDekUsY0FBRCxFQUFpQmtDLEdBQWpCLEVBQXNCO0FBQzdCLFNBQUtrQyxPQUFMLENBQWFTLFlBQVksQ0FBQzdFLGNBQUQsRUFBaUJrQyxHQUFHLENBQUNHLEdBQXJCLENBQXpCLElBQXNESCxHQUF0RDtBQUNIOztBQUVEMEMsZ0JBQWMsQ0FBQzVFLGNBQUQsRUFBaUJnRCxFQUFqQixFQUFxQjBCLE9BQXJCLEVBQThCO0FBQ3hDLFVBQU14RSxHQUFHLEdBQUcyRSxZQUFZLENBQUM3RSxjQUFELEVBQWlCZ0QsRUFBakIsQ0FBeEI7QUFDQSxVQUFNOEIsV0FBVyxHQUFHLEtBQUtWLE9BQUwsQ0FBYWxFLEdBQWIsS0FBcUIsRUFBekM7QUFDQSxTQUFLa0UsT0FBTCxDQUFhbEUsR0FBYixJQUFvQmMsQ0FBQyxDQUFDK0QsTUFBRixDQUFTRCxXQUFULEVBQXNCSixPQUF0QixDQUFwQjtBQUNIOztBQUVEQyxvQkFBa0IsQ0FBQzNFLGNBQUQsRUFBaUJnRCxFQUFqQixFQUFxQjBCLE9BQXJCLEVBQThCO0FBQzVDLFdBQU8sS0FBS00sZUFBTCxDQUFxQmhGLGNBQXJCLEVBQXFDZ0QsRUFBckMsS0FDSCxLQUFLd0IsY0FBTCxDQUFvQnhFLGNBQXBCLEVBQW9DZ0QsRUFBcEMsRUFBd0MwQixPQUF4QyxDQURKO0FBRUg7O0FBRURNLGlCQUFlLENBQUNoRixjQUFELEVBQWlCZ0QsRUFBakIsRUFBcUI7QUFDaEMsVUFBTTlDLEdBQUcsR0FBRzJFLFlBQVksQ0FBQzdFLGNBQUQsRUFBaUJnRCxFQUFqQixDQUF4QjtBQUNBLFdBQU8sQ0FBQyxDQUFDLEtBQUtvQixPQUFMLENBQWFsRSxHQUFiLENBQVQ7QUFDSDs7QUFFRHNFLGdCQUFjLENBQUN4RSxjQUFELEVBQWlCZ0QsRUFBakIsRUFBcUJkLEdBQXJCLEVBQTBCO0FBQ3BDLFVBQU00QyxXQUFXLEdBQUcsS0FBS1YsT0FBTCxDQUFhUyxZQUFZLENBQUM3RSxjQUFELEVBQWlCZ0QsRUFBakIsQ0FBekIsQ0FBcEI7O0FBRUEsUUFBSSxDQUFDOEIsV0FBTCxFQUFrQjtBQUFFLGFBQU8sSUFBUDtBQUFjOztBQUVsQyxXQUFPOUQsQ0FBQyxDQUFDaUUsR0FBRixDQUFNakUsQ0FBQyxDQUFDa0UsSUFBRixDQUFPaEQsR0FBUCxDQUFOLEVBQW1CaEMsR0FBRyxJQUFJLENBQUNjLENBQUMsQ0FBQ21FLE9BQUYsQ0FBVWpELEdBQUcsQ0FBQ2hDLEdBQUQsQ0FBYixFQUFvQjRFLFdBQVcsQ0FBQzVFLEdBQUQsQ0FBL0IsQ0FBM0IsQ0FBUDtBQUNIOztBQUVEcUUsZ0JBQWMsQ0FBQ3ZFLGNBQUQsRUFBaUJnRCxFQUFqQixFQUFxQjtBQUMvQixVQUFNOUMsR0FBRyxHQUFHMkUsWUFBWSxDQUFDN0UsY0FBRCxFQUFpQmdELEVBQWpCLENBQXhCO0FBQ0EsV0FBTyxLQUFLb0IsT0FBTCxDQUFhbEUsR0FBYixDQUFQO0FBQ0g7O0FBckVjOztBQXdFbkIsU0FBUzJFLFlBQVQsQ0FBc0I3RSxjQUF0QixFQUFzQ2dELEVBQXRDLEVBQTBDO0FBQ3RDLG1CQUFVaEQsY0FBVixlQUE2QmdELEVBQUUsQ0FBQzdDLE9BQUgsRUFBN0I7QUFDSDs7QUFoRkR2QyxNQUFNLENBQUMwQyxhQUFQLENBa0ZlakMsWUFsRmYsRTs7Ozs7Ozs7Ozs7QUNBQSxNQUFNK0csaUJBQU4sQ0FBd0I7QUFDcEJ4RixhQUFXLENBQUNJLGNBQUQsRUFBaUJDLEtBQWpCLEVBQXdCO0FBQy9CLFNBQUtELGNBQUwsR0FBc0JBLGNBQXRCO0FBQ0EsU0FBS0MsS0FBTCxHQUFhQSxLQUFiO0FBQ0EsU0FBS29GLGlCQUFMLEdBQXlCLEVBQXpCO0FBQ0EsU0FBS0Msb0JBQUwsR0FBNEIsS0FBNUI7QUFDSDs7QUFFRDFCLGFBQVcsQ0FBQzJCLGdCQUFELEVBQW1CO0FBQzFCLFNBQUtGLGlCQUFMLENBQXVCbEcsSUFBdkIsQ0FBNEJvRyxnQkFBNUI7QUFDSDs7QUFFRDFCLGNBQVksQ0FBQzJCLFFBQUQsRUFBVztBQUNuQixTQUFLSCxpQkFBTCxDQUF1QnJHLE9BQXZCLENBQStCd0csUUFBL0I7QUFDSDs7QUFFRHZCLHFCQUFtQixHQUFHO0FBQ2xCLFdBQU8sS0FBS3FCLG9CQUFaO0FBQ0g7O0FBRURoRCxrQkFBZ0IsR0FBRztBQUNmLFNBQUtnRCxvQkFBTCxHQUE0QixLQUE1QjtBQUNIOztBQUVERyxnQkFBYyxHQUFHO0FBQ2IsU0FBS0gsb0JBQUwsR0FBNEIsSUFBNUI7QUFDSDs7QUExQm1COztBQUF4QjFILE1BQU0sQ0FBQzBDLGFBQVAsQ0E2QmU4RSxpQkE3QmYsRTs7Ozs7Ozs7Ozs7QUNBQSxJQUFJcEUsQ0FBSjs7QUFBTXBELE1BQU0sQ0FBQ0ssSUFBUCxDQUFZLG1CQUFaLEVBQWdDO0FBQUMrQyxHQUFDLENBQUM5QyxDQUFELEVBQUc7QUFBQzhDLEtBQUMsR0FBQzlDLENBQUY7QUFBSTs7QUFBVixDQUFoQyxFQUE0QyxDQUE1QztBQUErQyxJQUFJa0gsaUJBQUo7QUFBc0J4SCxNQUFNLENBQUNLLElBQVAsQ0FBWSxzQkFBWixFQUFtQztBQUFDRyxTQUFPLENBQUNGLENBQUQsRUFBRztBQUFDa0gscUJBQWlCLEdBQUNsSCxDQUFsQjtBQUFvQjs7QUFBaEMsQ0FBbkMsRUFBcUUsQ0FBckU7O0FBSzNFLE1BQU0rQyxxQkFBTixDQUE0QjtBQUN4QnJCLGFBQVcsR0FBRztBQUNWLFNBQUs4RixTQUFMLEdBQWlCLEVBQWpCO0FBQ0g7O0FBRURqRCxLQUFHLENBQUN6QyxjQUFELEVBQWlCQyxLQUFqQixFQUF3QjtBQUN2QixVQUFNQyxHQUFHLEdBQUd5RixTQUFTLENBQUMxRixLQUFELENBQXJCOztBQUVBLFFBQUksQ0FBQyxLQUFLeUYsU0FBTCxDQUFleEYsR0FBZixDQUFMLEVBQTBCO0FBQ3RCLFdBQUt3RixTQUFMLENBQWV4RixHQUFmLElBQXNCLElBQUlrRixpQkFBSixDQUFzQnBGLGNBQXRCLEVBQXNDQyxLQUF0QyxDQUF0QjtBQUNIO0FBQ0o7O0FBRUQyRCxhQUFXLENBQUMzRCxLQUFELEVBQVE2RCxXQUFSLEVBQXFCO0FBQzVCLFFBQUksQ0FBQ0EsV0FBTCxFQUFrQjtBQUFFO0FBQVM7O0FBRTdCLFVBQU01RCxHQUFHLEdBQUd5RixTQUFTLENBQUMxRixLQUFELENBQXJCO0FBQ0EsVUFBTWlDLEdBQUcsR0FBRyxLQUFLd0QsU0FBTCxDQUFleEYsR0FBZixDQUFaOztBQUVBLFFBQUksT0FBT2dDLEdBQVAsS0FBZSxXQUFuQixFQUFnQztBQUM1QixZQUFNLElBQUkwRCxLQUFKLGtDQUFvQzFGLEdBQXBDLEVBQU47QUFDSDs7QUFFRCxTQUFLd0YsU0FBTCxDQUFleEYsR0FBZixFQUFvQjBELFdBQXBCLENBQWdDRSxXQUFoQztBQUNIOztBQUVEK0IsS0FBRyxDQUFDNUYsS0FBRCxFQUFRO0FBQ1AsVUFBTUMsR0FBRyxHQUFHeUYsU0FBUyxDQUFDMUYsS0FBRCxDQUFyQjtBQUNBLFdBQU8sS0FBS3lGLFNBQUwsQ0FBZXhGLEdBQWYsQ0FBUDtBQUNIOztBQUVEaUUsUUFBTSxDQUFDbEUsS0FBRCxFQUFRO0FBQ1YsVUFBTUMsR0FBRyxHQUFHeUYsU0FBUyxDQUFDMUYsS0FBRCxDQUFyQjtBQUNBLFdBQU8sS0FBS3lGLFNBQUwsQ0FBZXhGLEdBQWYsQ0FBUDtBQUNIOztBQUVEa0MsS0FBRyxDQUFDbkMsS0FBRCxFQUFRO0FBQ1AsV0FBTyxDQUFDLENBQUMsS0FBSzRGLEdBQUwsQ0FBUzVGLEtBQVQsQ0FBVDtBQUNIOztBQUVEOEQsY0FBWSxDQUFDeUIsUUFBRCxFQUFXTSxPQUFYLEVBQW9CO0FBQzVCOUUsS0FBQyxDQUFDeUMsSUFBRixDQUFPLEtBQUtpQyxTQUFaLEVBQXVCLFNBQVNLLGlCQUFULENBQTJCN0QsR0FBM0IsRUFBZ0M7QUFDbkRzRCxjQUFRLENBQUMxRyxJQUFULENBQWMsSUFBZCxFQUFvQm9ELEdBQXBCO0FBQ0gsS0FGRCxFQUVHNEQsT0FBTyxJQUFJLElBRmQ7QUFHSDs7QUFFRGpDLGNBQVksQ0FBQzVELEtBQUQsRUFBUXVGLFFBQVIsRUFBa0I7QUFDMUIsVUFBTXRELEdBQUcsR0FBRyxLQUFLMkQsR0FBTCxDQUFTNUYsS0FBVCxDQUFaOztBQUVBLFFBQUlpQyxHQUFKLEVBQVM7QUFDTEEsU0FBRyxDQUFDMkIsWUFBSixDQUFpQjJCLFFBQWpCO0FBQ0g7QUFDSjs7QUFFRFEsUUFBTSxHQUFHO0FBQ0wsVUFBTUMsTUFBTSxHQUFHLEVBQWY7QUFFQSxTQUFLbEMsWUFBTCxDQUFtQjdCLEdBQUQsSUFBUztBQUN2QitELFlBQU0sQ0FBQzlHLElBQVAsQ0FBWStDLEdBQUcsQ0FBQ2pDLEtBQWhCO0FBQ0gsS0FGRDtBQUlBLFdBQU9nRyxNQUFQO0FBQ0g7O0FBRUQzRCxrQkFBZ0IsQ0FBQ3JDLEtBQUQsRUFBUTtBQUNwQixVQUFNaUMsR0FBRyxHQUFHLEtBQUsyRCxHQUFMLENBQVM1RixLQUFULENBQVo7O0FBRUEsUUFBSWlDLEdBQUosRUFBUztBQUNMQSxTQUFHLENBQUNJLGdCQUFKO0FBQ0g7QUFDSjs7QUFFRGUsbUJBQWlCLEdBQUc7QUFDaEIsU0FBS1UsWUFBTCxDQUFtQjdCLEdBQUQsSUFBUztBQUN2QkEsU0FBRyxDQUFDdUQsY0FBSjtBQUNILEtBRkQ7QUFHSDs7QUE1RXVCOztBQStFNUIsU0FBU0UsU0FBVCxDQUFtQjFGLEtBQW5CLEVBQTBCO0FBQ3RCLE1BQUlBLEtBQUssS0FBSyxJQUFkLEVBQW9CO0FBQ2hCLFVBQU0sSUFBSTJGLEtBQUosQ0FBVSxxQkFBVixDQUFOO0FBQ0g7O0FBQ0QsTUFBSSxPQUFPM0YsS0FBUCxLQUFpQixXQUFyQixFQUFrQztBQUM5QixVQUFNLElBQUkyRixLQUFKLENBQVUsMEJBQVYsQ0FBTjtBQUNIOztBQUNELFNBQU8zRixLQUFLLENBQUNFLE9BQU4sRUFBUDtBQUNIOztBQTVGRHZDLE1BQU0sQ0FBQzBDLGFBQVAsQ0E4RmVXLHFCQTlGZixFIiwiZmlsZSI6Ii9wYWNrYWdlcy9yZXl3b29kX3B1Ymxpc2gtY29tcG9zaXRlLmpzIiwic291cmNlc0NvbnRlbnQiOlsiaW1wb3J0IHsgTWV0ZW9yIH0gZnJvbSAnbWV0ZW9yL21ldGVvcic7XG5cbmltcG9ydCBQdWJsaWNhdGlvbiBmcm9tICcuL3B1YmxpY2F0aW9uJztcbmltcG9ydCBTdWJzY3JpcHRpb24gZnJvbSAnLi9zdWJzY3JpcHRpb24nO1xuaW1wb3J0IHsgZGVidWdMb2csIGVuYWJsZURlYnVnTG9nZ2luZyB9IGZyb20gJy4vbG9nZ2luZyc7XG5cblxuZnVuY3Rpb24gcHVibGlzaENvbXBvc2l0ZShuYW1lLCBvcHRpb25zKSB7XG4gICAgcmV0dXJuIE1ldGVvci5wdWJsaXNoKG5hbWUsIGZ1bmN0aW9uIHB1Ymxpc2goLi4uYXJncykge1xuICAgICAgICBjb25zdCBzdWJzY3JpcHRpb24gPSBuZXcgU3Vic2NyaXB0aW9uKHRoaXMpO1xuICAgICAgICBjb25zdCBpbnN0YW5jZU9wdGlvbnMgPSBwcmVwYXJlT3B0aW9ucy5jYWxsKHRoaXMsIG9wdGlvbnMsIGFyZ3MpO1xuICAgICAgICBjb25zdCBwdWJsaWNhdGlvbnMgPSBbXTtcblxuICAgICAgICBpbnN0YW5jZU9wdGlvbnMuZm9yRWFjaCgob3B0KSA9PiB7XG4gICAgICAgICAgICBjb25zdCBwdWIgPSBuZXcgUHVibGljYXRpb24oc3Vic2NyaXB0aW9uLCBvcHQpO1xuICAgICAgICAgICAgcHViLnB1Ymxpc2goKTtcbiAgICAgICAgICAgIHB1YmxpY2F0aW9ucy5wdXNoKHB1Yik7XG4gICAgICAgIH0pO1xuXG4gICAgICAgIHRoaXMub25TdG9wKCgpID0+IHtcbiAgICAgICAgICAgIHB1YmxpY2F0aW9ucy5mb3JFYWNoKHB1YiA9PiBwdWIudW5wdWJsaXNoKCkpO1xuICAgICAgICB9KTtcblxuICAgICAgICBkZWJ1Z0xvZygnTWV0ZW9yLnB1Ymxpc2gnLCAncmVhZHknKTtcbiAgICAgICAgdGhpcy5yZWFkeSgpO1xuICAgIH0pO1xufVxuXG4vLyBGb3IgYmFja3dhcmRzIGNvbXBhdGliaWxpdHlcbk1ldGVvci5wdWJsaXNoQ29tcG9zaXRlID0gcHVibGlzaENvbXBvc2l0ZTtcblxuZnVuY3Rpb24gcHJlcGFyZU9wdGlvbnMob3B0aW9ucywgYXJncykge1xuICAgIGxldCBwcmVwYXJlZE9wdGlvbnMgPSBvcHRpb25zO1xuXG4gICAgaWYgKHR5cGVvZiBwcmVwYXJlZE9wdGlvbnMgPT09ICdmdW5jdGlvbicpIHtcbiAgICAgICAgcHJlcGFyZWRPcHRpb25zID0gcHJlcGFyZWRPcHRpb25zLmFwcGx5KHRoaXMsIGFyZ3MpO1xuICAgIH1cblxuICAgIGlmICghcHJlcGFyZWRPcHRpb25zKSB7XG4gICAgICAgIHJldHVybiBbXTtcbiAgICB9XG5cbiAgICBpZiAoIUFycmF5LmlzQXJyYXkocHJlcGFyZWRPcHRpb25zKSkge1xuICAgICAgICBwcmVwYXJlZE9wdGlvbnMgPSBbcHJlcGFyZWRPcHRpb25zXTtcbiAgICB9XG5cbiAgICByZXR1cm4gcHJlcGFyZWRPcHRpb25zO1xufVxuXG5cbmV4cG9ydCB7XG4gICAgZW5hYmxlRGVidWdMb2dnaW5nLFxuICAgIHB1Ymxpc2hDb21wb3NpdGUsXG59O1xuIiwiY2xhc3MgRG9jdW1lbnRSZWZDb3VudGVyIHtcbiAgICBjb25zdHJ1Y3RvcihvYnNlcnZlcikge1xuICAgICAgICB0aGlzLmhlYXAgPSB7fTtcbiAgICAgICAgdGhpcy5vYnNlcnZlciA9IG9ic2VydmVyO1xuICAgIH1cblxuICAgIGluY3JlbWVudChjb2xsZWN0aW9uTmFtZSwgZG9jSWQpIHtcbiAgICAgICAgY29uc3Qga2V5ID0gYCR7Y29sbGVjdGlvbk5hbWV9OiR7ZG9jSWQudmFsdWVPZigpfWA7XG4gICAgICAgIGlmICghdGhpcy5oZWFwW2tleV0pIHtcbiAgICAgICAgICAgIHRoaXMuaGVhcFtrZXldID0gMDtcbiAgICAgICAgfVxuICAgICAgICB0aGlzLmhlYXBba2V5XSArPSAxO1xuICAgIH1cblxuICAgIGRlY3JlbWVudChjb2xsZWN0aW9uTmFtZSwgZG9jSWQpIHtcbiAgICAgICAgY29uc3Qga2V5ID0gYCR7Y29sbGVjdGlvbk5hbWV9OiR7ZG9jSWQudmFsdWVPZigpfWA7XG4gICAgICAgIGlmICh0aGlzLmhlYXBba2V5XSkge1xuICAgICAgICAgICAgdGhpcy5oZWFwW2tleV0gLT0gMTtcblxuICAgICAgICAgICAgdGhpcy5vYnNlcnZlci5vbkNoYW5nZShjb2xsZWN0aW9uTmFtZSwgZG9jSWQsIHRoaXMuaGVhcFtrZXldKTtcbiAgICAgICAgfVxuICAgIH1cbn1cblxuZXhwb3J0IGRlZmF1bHQgRG9jdW1lbnRSZWZDb3VudGVyO1xuIiwiLyogZXNsaW50LWRpc2FibGUgbm8tY29uc29sZSAqL1xuXG5sZXQgZGVidWdMb2dnaW5nRW5hYmxlZCA9IGZhbHNlO1xuXG5mdW5jdGlvbiBkZWJ1Z0xvZyhzb3VyY2UsIG1lc3NhZ2UpIHtcbiAgICBpZiAoIWRlYnVnTG9nZ2luZ0VuYWJsZWQpIHsgcmV0dXJuOyB9XG4gICAgbGV0IHBhZGRlZFNvdXJjZSA9IHNvdXJjZTtcbiAgICB3aGlsZSAocGFkZGVkU291cmNlLmxlbmd0aCA8IDM1KSB7IHBhZGRlZFNvdXJjZSArPSAnICc7IH1cbiAgICBjb25zb2xlLmxvZyhgWyR7cGFkZGVkU291cmNlfV0gJHttZXNzYWdlfWApO1xufVxuXG5mdW5jdGlvbiBlbmFibGVEZWJ1Z0xvZ2dpbmcoKSB7XG4gICAgZGVidWdMb2dnaW5nRW5hYmxlZCA9IHRydWU7XG59XG5cbmV4cG9ydCB7XG4gICAgZGVidWdMb2csXG4gICAgZW5hYmxlRGVidWdMb2dnaW5nLFxufTtcbiIsImltcG9ydCB7IE1ldGVvciB9IGZyb20gJ21ldGVvci9tZXRlb3InO1xuaW1wb3J0IHsgTWF0Y2gsIGNoZWNrIH0gZnJvbSAnbWV0ZW9yL2NoZWNrJztcbmltcG9ydCB7IF8gfSBmcm9tICdtZXRlb3IvdW5kZXJzY29yZSc7XG5cbmltcG9ydCB7IGRlYnVnTG9nIH0gZnJvbSAnLi9sb2dnaW5nJztcbmltcG9ydCBQdWJsaXNoZWREb2N1bWVudExpc3QgZnJvbSAnLi9wdWJsaXNoZWRfZG9jdW1lbnRfbGlzdCc7XG5cblxuY2xhc3MgUHVibGljYXRpb24ge1xuICAgIGNvbnN0cnVjdG9yKHN1YnNjcmlwdGlvbiwgb3B0aW9ucywgYXJncykge1xuICAgICAgICBjaGVjayhvcHRpb25zLCB7XG4gICAgICAgICAgICBmaW5kOiBGdW5jdGlvbixcbiAgICAgICAgICAgIGNoaWxkcmVuOiBNYXRjaC5PcHRpb25hbChNYXRjaC5PbmVPZihbT2JqZWN0XSwgRnVuY3Rpb24pKSxcbiAgICAgICAgICAgIGNvbGxlY3Rpb25OYW1lOiBNYXRjaC5PcHRpb25hbChTdHJpbmcpLFxuICAgICAgICB9KTtcblxuICAgICAgICB0aGlzLnN1YnNjcmlwdGlvbiA9IHN1YnNjcmlwdGlvbjtcbiAgICAgICAgdGhpcy5vcHRpb25zID0gb3B0aW9ucztcbiAgICAgICAgdGhpcy5hcmdzID0gYXJncyB8fCBbXTtcbiAgICAgICAgdGhpcy5jaGlsZHJlbk9wdGlvbnMgPSBvcHRpb25zLmNoaWxkcmVuIHx8IFtdO1xuICAgICAgICB0aGlzLnB1Ymxpc2hlZERvY3MgPSBuZXcgUHVibGlzaGVkRG9jdW1lbnRMaXN0KCk7XG4gICAgICAgIHRoaXMuY29sbGVjdGlvbk5hbWUgPSBvcHRpb25zLmNvbGxlY3Rpb25OYW1lO1xuICAgIH1cblxuICAgIHB1Ymxpc2goKSB7XG4gICAgICAgIHRoaXMuY3Vyc29yID0gdGhpcy5fZ2V0Q3Vyc29yKCk7XG4gICAgICAgIGlmICghdGhpcy5jdXJzb3IpIHsgcmV0dXJuOyB9XG5cbiAgICAgICAgY29uc3QgY29sbGVjdGlvbk5hbWUgPSB0aGlzLl9nZXRDb2xsZWN0aW9uTmFtZSgpO1xuXG4gICAgICAgIC8vIFVzZSBNZXRlb3IuYmluZEVudmlyb25tZW50IHRvIG1ha2Ugc3VyZSB0aGUgY2FsbGJhY2tzIGFyZSBydW4gd2l0aCB0aGUgc2FtZVxuICAgICAgICAvLyBlbnZpcm9ubWVudFZhcmlhYmxlcyBhcyB3aGVuIHB1Ymxpc2hpbmcgdGhlIFwicGFyZW50XCIuXG4gICAgICAgIC8vIEl0J3Mgb25seSBuZWVkZWQgd2hlbiBwdWJsaXNoIGlzIGJlaW5nIHJlY3Vyc2l2ZWx5IHJ1bi5cbiAgICAgICAgdGhpcy5vYnNlcnZlSGFuZGxlID0gdGhpcy5jdXJzb3Iub2JzZXJ2ZSh7XG4gICAgICAgICAgICBhZGRlZDogTWV0ZW9yLmJpbmRFbnZpcm9ubWVudCgoZG9jKSA9PiB7XG4gICAgICAgICAgICAgICAgY29uc3QgYWxyZWFkeVB1Ymxpc2hlZCA9IHRoaXMucHVibGlzaGVkRG9jcy5oYXMoZG9jLl9pZCk7XG5cbiAgICAgICAgICAgICAgICBpZiAoYWxyZWFkeVB1Ymxpc2hlZCkge1xuICAgICAgICAgICAgICAgICAgICBkZWJ1Z0xvZygnUHVibGljYXRpb24ub2JzZXJ2ZUhhbmRsZS5hZGRlZCcsIGAke2NvbGxlY3Rpb25OYW1lfToke2RvYy5faWR9IGFscmVhZHkgcHVibGlzaGVkYCk7XG4gICAgICAgICAgICAgICAgICAgIHRoaXMucHVibGlzaGVkRG9jcy51bmZsYWdGb3JSZW1vdmFsKGRvYy5faWQpO1xuICAgICAgICAgICAgICAgICAgICB0aGlzLl9yZXB1Ymxpc2hDaGlsZHJlbk9mKGRvYyk7XG4gICAgICAgICAgICAgICAgICAgIHRoaXMuc3Vic2NyaXB0aW9uLmNoYW5nZWQoY29sbGVjdGlvbk5hbWUsIGRvYy5faWQsIGRvYyk7XG4gICAgICAgICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgICAgICAgICAgdGhpcy5wdWJsaXNoZWREb2NzLmFkZChjb2xsZWN0aW9uTmFtZSwgZG9jLl9pZCk7XG4gICAgICAgICAgICAgICAgICAgIHRoaXMuX3B1Ymxpc2hDaGlsZHJlbk9mKGRvYyk7XG4gICAgICAgICAgICAgICAgICAgIHRoaXMuc3Vic2NyaXB0aW9uLmFkZGVkKGNvbGxlY3Rpb25OYW1lLCBkb2MpO1xuICAgICAgICAgICAgICAgIH1cbiAgICAgICAgICAgIH0pLFxuICAgICAgICAgICAgY2hhbmdlZDogTWV0ZW9yLmJpbmRFbnZpcm9ubWVudCgobmV3RG9jKSA9PiB7XG4gICAgICAgICAgICAgICAgZGVidWdMb2coJ1B1YmxpY2F0aW9uLm9ic2VydmVIYW5kbGUuY2hhbmdlZCcsIGAke2NvbGxlY3Rpb25OYW1lfToke25ld0RvYy5faWR9YCk7XG4gICAgICAgICAgICAgICAgdGhpcy5fcmVwdWJsaXNoQ2hpbGRyZW5PZihuZXdEb2MpO1xuICAgICAgICAgICAgfSksXG4gICAgICAgICAgICByZW1vdmVkOiAoZG9jKSA9PiB7XG4gICAgICAgICAgICAgICAgZGVidWdMb2coJ1B1YmxpY2F0aW9uLm9ic2VydmVIYW5kbGUucmVtb3ZlZCcsIGAke2NvbGxlY3Rpb25OYW1lfToke2RvYy5faWR9YCk7XG4gICAgICAgICAgICAgICAgdGhpcy5fcmVtb3ZlRG9jKGNvbGxlY3Rpb25OYW1lLCBkb2MuX2lkKTtcbiAgICAgICAgICAgIH0sXG4gICAgICAgIH0pO1xuXG4gICAgICAgIHRoaXMub2JzZXJ2ZUNoYW5nZXNIYW5kbGUgPSB0aGlzLmN1cnNvci5vYnNlcnZlQ2hhbmdlcyh7XG4gICAgICAgICAgICBjaGFuZ2VkOiAoaWQsIGZpZWxkcykgPT4ge1xuICAgICAgICAgICAgICAgIGRlYnVnTG9nKCdQdWJsaWNhdGlvbi5vYnNlcnZlQ2hhbmdlc0hhbmRsZS5jaGFuZ2VkJywgYCR7Y29sbGVjdGlvbk5hbWV9OiR7aWR9YCk7XG4gICAgICAgICAgICAgICAgdGhpcy5zdWJzY3JpcHRpb24uY2hhbmdlZChjb2xsZWN0aW9uTmFtZSwgaWQsIGZpZWxkcyk7XG4gICAgICAgICAgICB9LFxuICAgICAgICB9KTtcbiAgICB9XG5cbiAgICB1bnB1Ymxpc2goKSB7XG4gICAgICAgIGRlYnVnTG9nKCdQdWJsaWNhdGlvbi51bnB1Ymxpc2gnLCB0aGlzLl9nZXRDb2xsZWN0aW9uTmFtZSgpKTtcbiAgICAgICAgdGhpcy5fc3RvcE9ic2VydmluZ0N1cnNvcigpO1xuICAgICAgICB0aGlzLl91bnB1Ymxpc2hBbGxEb2N1bWVudHMoKTtcbiAgICB9XG5cbiAgICBfcmVwdWJsaXNoKCkge1xuICAgICAgICB0aGlzLl9zdG9wT2JzZXJ2aW5nQ3Vyc29yKCk7XG5cbiAgICAgICAgdGhpcy5wdWJsaXNoZWREb2NzLmZsYWdBbGxGb3JSZW1vdmFsKCk7XG5cbiAgICAgICAgZGVidWdMb2coJ1B1YmxpY2F0aW9uLl9yZXB1Ymxpc2gnLCAncnVuIC5wdWJsaXNoIGFnYWluJyk7XG4gICAgICAgIHRoaXMucHVibGlzaCgpO1xuXG4gICAgICAgIGRlYnVnTG9nKCdQdWJsaWNhdGlvbi5fcmVwdWJsaXNoJywgJ3VucHVibGlzaCBkb2NzIGZyb20gb2xkIGN1cnNvcicpO1xuICAgICAgICB0aGlzLl9yZW1vdmVGbGFnZ2VkRG9jcygpO1xuICAgIH1cblxuICAgIF9nZXRDdXJzb3IoKSB7XG4gICAgICAgIHJldHVybiB0aGlzLm9wdGlvbnMuZmluZC5hcHBseSh0aGlzLnN1YnNjcmlwdGlvbi5tZXRlb3JTdWIsIHRoaXMuYXJncyk7XG4gICAgfVxuXG4gICAgX2dldENvbGxlY3Rpb25OYW1lKCkge1xuICAgICAgICByZXR1cm4gdGhpcy5jb2xsZWN0aW9uTmFtZSB8fCAodGhpcy5jdXJzb3IgJiYgdGhpcy5jdXJzb3IuX2dldENvbGxlY3Rpb25OYW1lKCkpO1xuICAgIH1cblxuICAgIF9wdWJsaXNoQ2hpbGRyZW5PZihkb2MpIHtcbiAgICAgICAgY29uc3QgY2hpbGRyZW4gPSBfLmlzRnVuY3Rpb24odGhpcy5jaGlsZHJlbk9wdGlvbnMpID9cbiAgICAgICAgdGhpcy5jaGlsZHJlbk9wdGlvbnMoZG9jLCAuLi50aGlzLmFyZ3MpIDogdGhpcy5jaGlsZHJlbk9wdGlvbnM7XG4gICAgICAgIF8uZWFjaChjaGlsZHJlbiwgZnVuY3Rpb24gY3JlYXRlQ2hpbGRQdWJsaWNhdGlvbihvcHRpb25zKSB7XG4gICAgICAgICAgICBjb25zdCBwdWIgPSBuZXcgUHVibGljYXRpb24odGhpcy5zdWJzY3JpcHRpb24sIG9wdGlvbnMsIFtkb2NdLmNvbmNhdCh0aGlzLmFyZ3MpKTtcbiAgICAgICAgICAgIHRoaXMucHVibGlzaGVkRG9jcy5hZGRDaGlsZFB1Yihkb2MuX2lkLCBwdWIpO1xuICAgICAgICAgICAgcHViLnB1Ymxpc2goKTtcbiAgICAgICAgfSwgdGhpcyk7XG4gICAgfVxuXG4gICAgX3JlcHVibGlzaENoaWxkcmVuT2YoZG9jKSB7XG4gICAgICAgIHRoaXMucHVibGlzaGVkRG9jcy5lYWNoQ2hpbGRQdWIoZG9jLl9pZCwgKHB1YmxpY2F0aW9uKSA9PiB7XG4gICAgICAgICAgICBwdWJsaWNhdGlvbi5hcmdzWzBdID0gZG9jO1xuICAgICAgICAgICAgcHVibGljYXRpb24uX3JlcHVibGlzaCgpO1xuICAgICAgICB9KTtcbiAgICB9XG5cbiAgICBfdW5wdWJsaXNoQWxsRG9jdW1lbnRzKCkge1xuICAgICAgICB0aGlzLnB1Ymxpc2hlZERvY3MuZWFjaERvY3VtZW50KChkb2MpID0+IHtcbiAgICAgICAgICAgIHRoaXMuX3JlbW92ZURvYyhkb2MuY29sbGVjdGlvbk5hbWUsIGRvYy5kb2NJZCk7XG4gICAgICAgIH0sIHRoaXMpO1xuICAgIH1cblxuICAgIF9zdG9wT2JzZXJ2aW5nQ3Vyc29yKCkge1xuICAgICAgICBkZWJ1Z0xvZygnUHVibGljYXRpb24uX3N0b3BPYnNlcnZpbmdDdXJzb3InLCAnc3RvcCBvYnNlcnZpbmcgY3Vyc29yJyk7XG5cbiAgICAgICAgaWYgKHRoaXMub2JzZXJ2ZUhhbmRsZSkge1xuICAgICAgICAgICAgdGhpcy5vYnNlcnZlSGFuZGxlLnN0b3AoKTtcbiAgICAgICAgICAgIGRlbGV0ZSB0aGlzLm9ic2VydmVIYW5kbGU7XG4gICAgICAgIH1cblxuICAgICAgICBpZiAodGhpcy5vYnNlcnZlQ2hhbmdlc0hhbmRsZSkge1xuICAgICAgICAgICAgdGhpcy5vYnNlcnZlQ2hhbmdlc0hhbmRsZS5zdG9wKCk7XG4gICAgICAgICAgICBkZWxldGUgdGhpcy5vYnNlcnZlQ2hhbmdlc0hhbmRsZTtcbiAgICAgICAgfVxuICAgIH1cblxuICAgIF9yZW1vdmVGbGFnZ2VkRG9jcygpIHtcbiAgICAgICAgdGhpcy5wdWJsaXNoZWREb2NzLmVhY2hEb2N1bWVudCgoZG9jKSA9PiB7XG4gICAgICAgICAgICBpZiAoZG9jLmlzRmxhZ2dlZEZvclJlbW92YWwoKSkge1xuICAgICAgICAgICAgICAgIHRoaXMuX3JlbW92ZURvYyhkb2MuY29sbGVjdGlvbk5hbWUsIGRvYy5kb2NJZCk7XG4gICAgICAgICAgICB9XG4gICAgICAgIH0sIHRoaXMpO1xuICAgIH1cblxuICAgIF9yZW1vdmVEb2MoY29sbGVjdGlvbk5hbWUsIGRvY0lkKSB7XG4gICAgICAgIHRoaXMuc3Vic2NyaXB0aW9uLnJlbW92ZWQoY29sbGVjdGlvbk5hbWUsIGRvY0lkKTtcbiAgICAgICAgdGhpcy5fdW5wdWJsaXNoQ2hpbGRyZW5PZihkb2NJZCk7XG4gICAgICAgIHRoaXMucHVibGlzaGVkRG9jcy5yZW1vdmUoZG9jSWQpO1xuICAgIH1cblxuICAgIF91bnB1Ymxpc2hDaGlsZHJlbk9mKGRvY0lkKSB7XG4gICAgICAgIGRlYnVnTG9nKCdQdWJsaWNhdGlvbi5fdW5wdWJsaXNoQ2hpbGRyZW5PZicsIGB1bnB1Ymxpc2hpbmcgY2hpbGRyZW4gb2YgJHt0aGlzLl9nZXRDb2xsZWN0aW9uTmFtZSgpfToke2RvY0lkfWApO1xuXG4gICAgICAgIHRoaXMucHVibGlzaGVkRG9jcy5lYWNoQ2hpbGRQdWIoZG9jSWQsIChwdWJsaWNhdGlvbikgPT4ge1xuICAgICAgICAgICAgcHVibGljYXRpb24udW5wdWJsaXNoKCk7XG4gICAgICAgIH0pO1xuICAgIH1cbn1cblxuZXhwb3J0IGRlZmF1bHQgUHVibGljYXRpb247XG4iLCJpbXBvcnQgeyBfIH0gZnJvbSAnbWV0ZW9yL3VuZGVyc2NvcmUnO1xuXG5pbXBvcnQgRG9jdW1lbnRSZWZDb3VudGVyIGZyb20gJy4vZG9jX3JlZl9jb3VudGVyJztcbmltcG9ydCB7IGRlYnVnTG9nIH0gZnJvbSAnLi9sb2dnaW5nJztcblxuXG5jbGFzcyBTdWJzY3JpcHRpb24ge1xuICAgIGNvbnN0cnVjdG9yKG1ldGVvclN1Yikge1xuICAgICAgICB0aGlzLm1ldGVvclN1YiA9IG1ldGVvclN1YjtcbiAgICAgICAgdGhpcy5kb2NIYXNoID0ge307XG4gICAgICAgIHRoaXMucmVmQ291bnRlciA9IG5ldyBEb2N1bWVudFJlZkNvdW50ZXIoe1xuICAgICAgICAgICAgb25DaGFuZ2U6IChjb2xsZWN0aW9uTmFtZSwgZG9jSWQsIHJlZkNvdW50KSA9PiB7XG4gICAgICAgICAgICAgICAgZGVidWdMb2coJ1N1YnNjcmlwdGlvbi5yZWZDb3VudGVyLm9uQ2hhbmdlJywgYCR7Y29sbGVjdGlvbk5hbWV9OiR7ZG9jSWQudmFsdWVPZigpfSAke3JlZkNvdW50fWApO1xuICAgICAgICAgICAgICAgIGlmIChyZWZDb3VudCA8PSAwKSB7XG4gICAgICAgICAgICAgICAgICAgIG1ldGVvclN1Yi5yZW1vdmVkKGNvbGxlY3Rpb25OYW1lLCBkb2NJZCk7XG4gICAgICAgICAgICAgICAgICAgIHRoaXMuX3JlbW92ZURvY0hhc2goY29sbGVjdGlvbk5hbWUsIGRvY0lkKTtcbiAgICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9LFxuICAgICAgICB9KTtcbiAgICB9XG5cbiAgICBhZGRlZChjb2xsZWN0aW9uTmFtZSwgZG9jKSB7XG4gICAgICAgIHRoaXMucmVmQ291bnRlci5pbmNyZW1lbnQoY29sbGVjdGlvbk5hbWUsIGRvYy5faWQpO1xuXG4gICAgICAgIGlmICh0aGlzLl9oYXNEb2NDaGFuZ2VkKGNvbGxlY3Rpb25OYW1lLCBkb2MuX2lkLCBkb2MpKSB7XG4gICAgICAgICAgICBkZWJ1Z0xvZygnU3Vic2NyaXB0aW9uLmFkZGVkJywgYCR7Y29sbGVjdGlvbk5hbWV9OiR7ZG9jLl9pZH1gKTtcbiAgICAgICAgICAgIHRoaXMubWV0ZW9yU3ViLmFkZGVkKGNvbGxlY3Rpb25OYW1lLCBkb2MuX2lkLCBkb2MpO1xuICAgICAgICAgICAgdGhpcy5fYWRkRG9jSGFzaChjb2xsZWN0aW9uTmFtZSwgZG9jKTtcbiAgICAgICAgfVxuICAgIH1cblxuICAgIGNoYW5nZWQoY29sbGVjdGlvbk5hbWUsIGlkLCBjaGFuZ2VzKSB7XG4gICAgICAgIGlmICh0aGlzLl9zaG91bGRTZW5kQ2hhbmdlcyhjb2xsZWN0aW9uTmFtZSwgaWQsIGNoYW5nZXMpKSB7XG4gICAgICAgICAgICBkZWJ1Z0xvZygnU3Vic2NyaXB0aW9uLmNoYW5nZWQnLCBgJHtjb2xsZWN0aW9uTmFtZX06JHtpZH1gKTtcbiAgICAgICAgICAgIHRoaXMubWV0ZW9yU3ViLmNoYW5nZWQoY29sbGVjdGlvbk5hbWUsIGlkLCBjaGFuZ2VzKTtcbiAgICAgICAgICAgIHRoaXMuX3VwZGF0ZURvY0hhc2goY29sbGVjdGlvbk5hbWUsIGlkLCBjaGFuZ2VzKTtcbiAgICAgICAgfVxuICAgIH1cblxuICAgIHJlbW92ZWQoY29sbGVjdGlvbk5hbWUsIGlkKSB7XG4gICAgICAgIGRlYnVnTG9nKCdTdWJzY3JpcHRpb24ucmVtb3ZlZCcsIGAke2NvbGxlY3Rpb25OYW1lfToke2lkLnZhbHVlT2YoKX1gKTtcbiAgICAgICAgdGhpcy5yZWZDb3VudGVyLmRlY3JlbWVudChjb2xsZWN0aW9uTmFtZSwgaWQpO1xuICAgIH1cblxuICAgIF9hZGREb2NIYXNoKGNvbGxlY3Rpb25OYW1lLCBkb2MpIHtcbiAgICAgICAgdGhpcy5kb2NIYXNoW2J1aWxkSGFzaEtleShjb2xsZWN0aW9uTmFtZSwgZG9jLl9pZCldID0gZG9jO1xuICAgIH1cblxuICAgIF91cGRhdGVEb2NIYXNoKGNvbGxlY3Rpb25OYW1lLCBpZCwgY2hhbmdlcykge1xuICAgICAgICBjb25zdCBrZXkgPSBidWlsZEhhc2hLZXkoY29sbGVjdGlvbk5hbWUsIGlkKTtcbiAgICAgICAgY29uc3QgZXhpc3RpbmdEb2MgPSB0aGlzLmRvY0hhc2hba2V5XSB8fCB7fTtcbiAgICAgICAgdGhpcy5kb2NIYXNoW2tleV0gPSBfLmV4dGVuZChleGlzdGluZ0RvYywgY2hhbmdlcyk7XG4gICAgfVxuXG4gICAgX3Nob3VsZFNlbmRDaGFuZ2VzKGNvbGxlY3Rpb25OYW1lLCBpZCwgY2hhbmdlcykge1xuICAgICAgICByZXR1cm4gdGhpcy5faXNEb2NQdWJsaXNoZWQoY29sbGVjdGlvbk5hbWUsIGlkKSAmJlxuICAgICAgICAgICAgdGhpcy5faGFzRG9jQ2hhbmdlZChjb2xsZWN0aW9uTmFtZSwgaWQsIGNoYW5nZXMpO1xuICAgIH1cblxuICAgIF9pc0RvY1B1Ymxpc2hlZChjb2xsZWN0aW9uTmFtZSwgaWQpIHtcbiAgICAgICAgY29uc3Qga2V5ID0gYnVpbGRIYXNoS2V5KGNvbGxlY3Rpb25OYW1lLCBpZCk7XG4gICAgICAgIHJldHVybiAhIXRoaXMuZG9jSGFzaFtrZXldO1xuICAgIH1cblxuICAgIF9oYXNEb2NDaGFuZ2VkKGNvbGxlY3Rpb25OYW1lLCBpZCwgZG9jKSB7XG4gICAgICAgIGNvbnN0IGV4aXN0aW5nRG9jID0gdGhpcy5kb2NIYXNoW2J1aWxkSGFzaEtleShjb2xsZWN0aW9uTmFtZSwgaWQpXTtcblxuICAgICAgICBpZiAoIWV4aXN0aW5nRG9jKSB7IHJldHVybiB0cnVlOyB9XG5cbiAgICAgICAgcmV0dXJuIF8uYW55KF8ua2V5cyhkb2MpLCBrZXkgPT4gIV8uaXNFcXVhbChkb2Nba2V5XSwgZXhpc3RpbmdEb2Nba2V5XSkpO1xuICAgIH1cblxuICAgIF9yZW1vdmVEb2NIYXNoKGNvbGxlY3Rpb25OYW1lLCBpZCkge1xuICAgICAgICBjb25zdCBrZXkgPSBidWlsZEhhc2hLZXkoY29sbGVjdGlvbk5hbWUsIGlkKTtcbiAgICAgICAgZGVsZXRlIHRoaXMuZG9jSGFzaFtrZXldO1xuICAgIH1cbn1cblxuZnVuY3Rpb24gYnVpbGRIYXNoS2V5KGNvbGxlY3Rpb25OYW1lLCBpZCkge1xuICAgIHJldHVybiBgJHtjb2xsZWN0aW9uTmFtZX06OiR7aWQudmFsdWVPZigpfWA7XG59XG5cbmV4cG9ydCBkZWZhdWx0IFN1YnNjcmlwdGlvbjtcbiIsImNsYXNzIFB1Ymxpc2hlZERvY3VtZW50IHtcbiAgICBjb25zdHJ1Y3Rvcihjb2xsZWN0aW9uTmFtZSwgZG9jSWQpIHtcbiAgICAgICAgdGhpcy5jb2xsZWN0aW9uTmFtZSA9IGNvbGxlY3Rpb25OYW1lO1xuICAgICAgICB0aGlzLmRvY0lkID0gZG9jSWQ7XG4gICAgICAgIHRoaXMuY2hpbGRQdWJsaWNhdGlvbnMgPSBbXTtcbiAgICAgICAgdGhpcy5faXNGbGFnZ2VkRm9yUmVtb3ZhbCA9IGZhbHNlO1xuICAgIH1cblxuICAgIGFkZENoaWxkUHViKGNoaWxkUHVibGljYXRpb24pIHtcbiAgICAgICAgdGhpcy5jaGlsZFB1YmxpY2F0aW9ucy5wdXNoKGNoaWxkUHVibGljYXRpb24pO1xuICAgIH1cblxuICAgIGVhY2hDaGlsZFB1YihjYWxsYmFjaykge1xuICAgICAgICB0aGlzLmNoaWxkUHVibGljYXRpb25zLmZvckVhY2goY2FsbGJhY2spO1xuICAgIH1cblxuICAgIGlzRmxhZ2dlZEZvclJlbW92YWwoKSB7XG4gICAgICAgIHJldHVybiB0aGlzLl9pc0ZsYWdnZWRGb3JSZW1vdmFsO1xuICAgIH1cblxuICAgIHVuZmxhZ0ZvclJlbW92YWwoKSB7XG4gICAgICAgIHRoaXMuX2lzRmxhZ2dlZEZvclJlbW92YWwgPSBmYWxzZTtcbiAgICB9XG5cbiAgICBmbGFnRm9yUmVtb3ZhbCgpIHtcbiAgICAgICAgdGhpcy5faXNGbGFnZ2VkRm9yUmVtb3ZhbCA9IHRydWU7XG4gICAgfVxufVxuXG5leHBvcnQgZGVmYXVsdCBQdWJsaXNoZWREb2N1bWVudDtcbiIsImltcG9ydCB7IF8gfSBmcm9tICdtZXRlb3IvdW5kZXJzY29yZSc7XG5cbmltcG9ydCBQdWJsaXNoZWREb2N1bWVudCBmcm9tICcuL3B1Ymxpc2hlZF9kb2N1bWVudCc7XG5cblxuY2xhc3MgUHVibGlzaGVkRG9jdW1lbnRMaXN0IHtcbiAgICBjb25zdHJ1Y3RvcigpIHtcbiAgICAgICAgdGhpcy5kb2N1bWVudHMgPSB7fTtcbiAgICB9XG5cbiAgICBhZGQoY29sbGVjdGlvbk5hbWUsIGRvY0lkKSB7XG4gICAgICAgIGNvbnN0IGtleSA9IHZhbHVlT2ZJZChkb2NJZCk7XG5cbiAgICAgICAgaWYgKCF0aGlzLmRvY3VtZW50c1trZXldKSB7XG4gICAgICAgICAgICB0aGlzLmRvY3VtZW50c1trZXldID0gbmV3IFB1Ymxpc2hlZERvY3VtZW50KGNvbGxlY3Rpb25OYW1lLCBkb2NJZCk7XG4gICAgICAgIH1cbiAgICB9XG5cbiAgICBhZGRDaGlsZFB1Yihkb2NJZCwgcHVibGljYXRpb24pIHtcbiAgICAgICAgaWYgKCFwdWJsaWNhdGlvbikgeyByZXR1cm47IH1cblxuICAgICAgICBjb25zdCBrZXkgPSB2YWx1ZU9mSWQoZG9jSWQpO1xuICAgICAgICBjb25zdCBkb2MgPSB0aGlzLmRvY3VtZW50c1trZXldO1xuXG4gICAgICAgIGlmICh0eXBlb2YgZG9jID09PSAndW5kZWZpbmVkJykge1xuICAgICAgICAgICAgdGhyb3cgbmV3IEVycm9yKGBEb2Mgbm90IGZvdW5kIGluIGxpc3Q6ICR7a2V5fWApO1xuICAgICAgICB9XG5cbiAgICAgICAgdGhpcy5kb2N1bWVudHNba2V5XS5hZGRDaGlsZFB1YihwdWJsaWNhdGlvbik7XG4gICAgfVxuXG4gICAgZ2V0KGRvY0lkKSB7XG4gICAgICAgIGNvbnN0IGtleSA9IHZhbHVlT2ZJZChkb2NJZCk7XG4gICAgICAgIHJldHVybiB0aGlzLmRvY3VtZW50c1trZXldO1xuICAgIH1cblxuICAgIHJlbW92ZShkb2NJZCkge1xuICAgICAgICBjb25zdCBrZXkgPSB2YWx1ZU9mSWQoZG9jSWQpO1xuICAgICAgICBkZWxldGUgdGhpcy5kb2N1bWVudHNba2V5XTtcbiAgICB9XG5cbiAgICBoYXMoZG9jSWQpIHtcbiAgICAgICAgcmV0dXJuICEhdGhpcy5nZXQoZG9jSWQpO1xuICAgIH1cblxuICAgIGVhY2hEb2N1bWVudChjYWxsYmFjaywgY29udGV4dCkge1xuICAgICAgICBfLmVhY2godGhpcy5kb2N1bWVudHMsIGZ1bmN0aW9uIGV4ZWNDYWxsYmFja09uRG9jKGRvYykge1xuICAgICAgICAgICAgY2FsbGJhY2suY2FsbCh0aGlzLCBkb2MpO1xuICAgICAgICB9LCBjb250ZXh0IHx8IHRoaXMpO1xuICAgIH1cblxuICAgIGVhY2hDaGlsZFB1Yihkb2NJZCwgY2FsbGJhY2spIHtcbiAgICAgICAgY29uc3QgZG9jID0gdGhpcy5nZXQoZG9jSWQpO1xuXG4gICAgICAgIGlmIChkb2MpIHtcbiAgICAgICAgICAgIGRvYy5lYWNoQ2hpbGRQdWIoY2FsbGJhY2spO1xuICAgICAgICB9XG4gICAgfVxuXG4gICAgZ2V0SWRzKCkge1xuICAgICAgICBjb25zdCBkb2NJZHMgPSBbXTtcblxuICAgICAgICB0aGlzLmVhY2hEb2N1bWVudCgoZG9jKSA9PiB7XG4gICAgICAgICAgICBkb2NJZHMucHVzaChkb2MuZG9jSWQpO1xuICAgICAgICB9KTtcblxuICAgICAgICByZXR1cm4gZG9jSWRzO1xuICAgIH1cblxuICAgIHVuZmxhZ0ZvclJlbW92YWwoZG9jSWQpIHtcbiAgICAgICAgY29uc3QgZG9jID0gdGhpcy5nZXQoZG9jSWQpO1xuXG4gICAgICAgIGlmIChkb2MpIHtcbiAgICAgICAgICAgIGRvYy51bmZsYWdGb3JSZW1vdmFsKCk7XG4gICAgICAgIH1cbiAgICB9XG5cbiAgICBmbGFnQWxsRm9yUmVtb3ZhbCgpIHtcbiAgICAgICAgdGhpcy5lYWNoRG9jdW1lbnQoKGRvYykgPT4ge1xuICAgICAgICAgICAgZG9jLmZsYWdGb3JSZW1vdmFsKCk7XG4gICAgICAgIH0pO1xuICAgIH1cbn1cblxuZnVuY3Rpb24gdmFsdWVPZklkKGRvY0lkKSB7XG4gICAgaWYgKGRvY0lkID09PSBudWxsKSB7XG4gICAgICAgIHRocm93IG5ldyBFcnJvcignRG9jdW1lbnQgSUQgaXMgbnVsbCcpO1xuICAgIH1cbiAgICBpZiAodHlwZW9mIGRvY0lkID09PSAndW5kZWZpbmVkJykge1xuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoJ0RvY3VtZW50IElEIGlzIHVuZGVmaW5lZCcpO1xuICAgIH1cbiAgICByZXR1cm4gZG9jSWQudmFsdWVPZigpO1xufVxuXG5leHBvcnQgZGVmYXVsdCBQdWJsaXNoZWREb2N1bWVudExpc3Q7XG4iXX0=
