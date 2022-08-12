(function () {

/* Imports */
var Meteor = Package.meteor.Meteor;
var global = Package.meteor.global;
var meteorEnv = Package.meteor.meteorEnv;
var check = Package.check.check;
var Match = Package.check.Match;
var Random = Package.random.Random;
var EJSON = Package.ejson.EJSON;
var _ = Package.underscore._;
var Retry = Package.retry.Retry;
var MongoID = Package['mongo-id'].MongoID;
var DiffSequence = Package['diff-sequence'].DiffSequence;
var ECMAScript = Package.ecmascript.ECMAScript;
var DDPCommon = Package['ddp-common'].DDPCommon;
var DDP = Package['ddp-client'].DDP;
var WebApp = Package.webapp.WebApp;
var WebAppInternals = Package.webapp.WebAppInternals;
var main = Package.webapp.main;
var RoutePolicy = Package.routepolicy.RoutePolicy;
var Hook = Package['callback-hook'].Hook;
var meteorInstall = Package.modules.meteorInstall;
var Promise = Package.promise.Promise;

/* Package-scope variables */
var StreamServer, DDPServer, id, Server;

var require = meteorInstall({"node_modules":{"meteor":{"ddp-server":{"stream_server.js":function module(require){

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
// packages/ddp-server/stream_server.js                                                                               //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                      //
// By default, we use the permessage-deflate extension with default
// configuration. If $SERVER_WEBSOCKET_COMPRESSION is set, then it must be valid
// JSON. If it represents a falsey value, then we do not use permessage-deflate
// at all; otherwise, the JSON value is used as an argument to deflate's
// configure method; see
// https://github.com/faye/permessage-deflate-node/blob/master/README.md
//
// (We do this in an _.once instead of at startup, because we don't want to
// crash the tool during isopacket load if your JSON doesn't parse. This is only
// a problem because the tool has to load the DDP server code just in order to
// be a DDP client; see https://github.com/meteor/meteor/issues/3452 .)
var websocketExtensions = _.once(function () {
  var extensions = [];
  var websocketCompressionConfig = process.env.SERVER_WEBSOCKET_COMPRESSION ? JSON.parse(process.env.SERVER_WEBSOCKET_COMPRESSION) : {};

  if (websocketCompressionConfig) {
    extensions.push(Npm.require('permessage-deflate').configure(websocketCompressionConfig));
  }

  return extensions;
});

var pathPrefix = __meteor_runtime_config__.ROOT_URL_PATH_PREFIX || "";

StreamServer = function () {
  var self = this;
  self.registration_callbacks = [];
  self.open_sockets = []; // Because we are installing directly onto WebApp.httpServer instead of using
  // WebApp.app, we have to process the path prefix ourselves.

  self.prefix = pathPrefix + '/sockjs';
  RoutePolicy.declare(self.prefix + '/', 'network'); // set up sockjs

  var sockjs = Npm.require('sockjs');

  var serverOptions = {
    prefix: self.prefix,
    log: function () {},
    // this is the default, but we code it explicitly because we depend
    // on it in stream_client:HEARTBEAT_TIMEOUT
    heartbeat_delay: 45000,
    // The default disconnect_delay is 5 seconds, but if the server ends up CPU
    // bound for that much time, SockJS might not notice that the user has
    // reconnected because the timer (of disconnect_delay ms) can fire before
    // SockJS processes the new connection. Eventually we'll fix this by not
    // combining CPU-heavy processing with SockJS termination (eg a proxy which
    // converts to Unix sockets) but for now, raise the delay.
    disconnect_delay: 60 * 1000,
    // Set the USE_JSESSIONID environment variable to enable setting the
    // JSESSIONID cookie. This is useful for setting up proxies with
    // session affinity.
    jsessionid: !!process.env.USE_JSESSIONID
  }; // If you know your server environment (eg, proxies) will prevent websockets
  // from ever working, set $DISABLE_WEBSOCKETS and SockJS clients (ie,
  // browsers) will not waste time attempting to use them.
  // (Your server will still have a /websocket endpoint.)

  if (process.env.DISABLE_WEBSOCKETS) {
    serverOptions.websocket = false;
  } else {
    serverOptions.faye_server_options = {
      extensions: websocketExtensions()
    };
  }

  self.server = sockjs.createServer(serverOptions); // Install the sockjs handlers, but we want to keep around our own particular
  // request handler that adjusts idle timeouts while we have an outstanding
  // request.  This compensates for the fact that sockjs removes all listeners
  // for "request" to add its own.

  WebApp.httpServer.removeListener('request', WebApp._timeoutAdjustmentRequestCallback);
  self.server.installHandlers(WebApp.httpServer);
  WebApp.httpServer.addListener('request', WebApp._timeoutAdjustmentRequestCallback); // Support the /websocket endpoint

  self._redirectWebsocketEndpoint();

  self.server.on('connection', function (socket) {
    // sockjs sometimes passes us null instead of a socket object
    // so we need to guard against that. see:
    // https://github.com/sockjs/sockjs-node/issues/121
    // https://github.com/meteor/meteor/issues/10468
    if (!socket) return; // We want to make sure that if a client connects to us and does the initial
    // Websocket handshake but never gets to the DDP handshake, that we
    // eventually kill the socket.  Once the DDP handshake happens, DDP
    // heartbeating will work. And before the Websocket handshake, the timeouts
    // we set at the server level in webapp_server.js will work. But
    // faye-websocket calls setTimeout(0) on any socket it takes over, so there
    // is an "in between" state where this doesn't happen.  We work around this
    // by explicitly setting the socket timeout to a relatively large time here,
    // and setting it back to zero when we set up the heartbeat in
    // livedata_server.js.

    socket.setWebsocketTimeout = function (timeout) {
      if ((socket.protocol === 'websocket' || socket.protocol === 'websocket-raw') && socket._session.recv) {
        socket._session.recv.connection.setTimeout(timeout);
      }
    };

    socket.setWebsocketTimeout(45 * 1000);

    socket.send = function (data) {
      socket.write(data);
    };

    socket.on('close', function () {
      self.open_sockets = _.without(self.open_sockets, socket);
    });
    self.open_sockets.push(socket); // only to send a message after connection on tests, useful for
    // socket-stream-client/server-tests.js

    if (process.env.TEST_METADATA && process.env.TEST_METADATA !== "{}") {
      socket.send(JSON.stringify({
        testMessageOnConnect: true
      }));
    } // call all our callbacks when we get a new socket. they will do the
    // work of setting up handlers and such for specific messages.


    _.each(self.registration_callbacks, function (callback) {
      callback(socket);
    });
  });
};

Object.assign(StreamServer.prototype, {
  // call my callback when a new socket connects.
  // also call it for all current connections.
  register: function (callback) {
    var self = this;
    self.registration_callbacks.push(callback);

    _.each(self.all_sockets(), function (socket) {
      callback(socket);
    });
  },
  // get a list of all sockets
  all_sockets: function () {
    var self = this;
    return _.values(self.open_sockets);
  },
  // Redirect /websocket to /sockjs/websocket in order to not expose
  // sockjs to clients that want to use raw websockets
  _redirectWebsocketEndpoint: function () {
    var self = this; // Unfortunately we can't use a connect middleware here since
    // sockjs installs itself prior to all existing listeners
    // (meaning prior to any connect middlewares) so we need to take
    // an approach similar to overshadowListeners in
    // https://github.com/sockjs/sockjs-node/blob/cf820c55af6a9953e16558555a31decea554f70e/src/utils.coffee

    ['request', 'upgrade'].forEach(event => {
      var httpServer = WebApp.httpServer;
      var oldHttpServerListeners = httpServer.listeners(event).slice(0);
      httpServer.removeAllListeners(event); // request and upgrade have different arguments passed but
      // we only care about the first one which is always request

      var newListener = function (request
      /*, moreArguments */
      ) {
        // Store arguments for use within the closure below
        var args = arguments; // TODO replace with url package

        var url = Npm.require('url'); // Rewrite /websocket and /websocket/ urls to /sockjs/websocket while
        // preserving query string.


        var parsedUrl = url.parse(request.url);

        if (parsedUrl.pathname === pathPrefix + '/websocket' || parsedUrl.pathname === pathPrefix + '/websocket/') {
          parsedUrl.pathname = self.prefix + '/websocket';
          request.url = url.format(parsedUrl);
        }

        _.each(oldHttpServerListeners, function (oldListener) {
          oldListener.apply(httpServer, args);
        });
      };

      httpServer.addListener(event, newListener);
    });
  }
});
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"livedata_server.js":function module(require,exports,module){

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
// packages/ddp-server/livedata_server.js                                                                             //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                      //
let _objectSpread;

module.link("@babel/runtime/helpers/objectSpread2", {
  default(v) {
    _objectSpread = v;
  }

}, 0);
DDPServer = {};

var Fiber = Npm.require('fibers'); // Publication strategies define how we handle data from published cursors at the collection level
// This allows someone to:
// - Choose a trade-off between client-server bandwidth and server memory usage
// - Implement special (non-mongo) collections like volatile message queues


const publicationStrategies = {
  // SERVER_MERGE is the default strategy.
  // When using this strategy, the server maintains a copy of all data a connection is subscribed to.
  // This allows us to only send deltas over multiple publications.
  SERVER_MERGE: {
    useCollectionView: true,
    doAccountingForCollection: true
  },
  // The NO_MERGE_NO_HISTORY strategy results in the server sending all publication data
  // directly to the client. It does not remember what it has previously sent
  // to it will not trigger removed messages when a subscription is stopped.
  // This should only be chosen for special use cases like send-and-forget queues.
  NO_MERGE_NO_HISTORY: {
    useCollectionView: false,
    doAccountingForCollection: false
  },
  // NO_MERGE is similar to NO_MERGE_NO_HISTORY but the server will remember the IDs it has
  // sent to the client so it can remove them when a subscription is stopped.
  // This strategy can be used when a collection is only used in a single publication.
  NO_MERGE: {
    useCollectionView: false,
    doAccountingForCollection: true
  }
};
DDPServer.publicationStrategies = publicationStrategies; // This file contains classes:
// * Session - The server's connection to a single DDP client
// * Subscription - A single subscription for a single client
// * Server - An entire server that may talk to > 1 client. A DDP endpoint.
//
// Session and Subscription are file scope. For now, until we freeze
// the interface, Server is package scope (in the future it should be
// exported).
// Represents a single document in a SessionCollectionView

var SessionDocumentView = function () {
  var self = this;
  self.existsIn = new Set(); // set of subscriptionHandle

  self.dataByKey = new Map(); // key-> [ {subscriptionHandle, value} by precedence]
};

DDPServer._SessionDocumentView = SessionDocumentView;

_.extend(SessionDocumentView.prototype, {
  getFields: function () {
    var self = this;
    var ret = {};
    self.dataByKey.forEach(function (precedenceList, key) {
      ret[key] = precedenceList[0].value;
    });
    return ret;
  },
  clearField: function (subscriptionHandle, key, changeCollector) {
    var self = this; // Publish API ignores _id if present in fields

    if (key === "_id") return;
    var precedenceList = self.dataByKey.get(key); // It's okay to clear fields that didn't exist. No need to throw
    // an error.

    if (!precedenceList) return;
    var removedValue = undefined;

    for (var i = 0; i < precedenceList.length; i++) {
      var precedence = precedenceList[i];

      if (precedence.subscriptionHandle === subscriptionHandle) {
        // The view's value can only change if this subscription is the one that
        // used to have precedence.
        if (i === 0) removedValue = precedence.value;
        precedenceList.splice(i, 1);
        break;
      }
    }

    if (precedenceList.length === 0) {
      self.dataByKey.delete(key);
      changeCollector[key] = undefined;
    } else if (removedValue !== undefined && !EJSON.equals(removedValue, precedenceList[0].value)) {
      changeCollector[key] = precedenceList[0].value;
    }
  },
  changeField: function (subscriptionHandle, key, value, changeCollector, isAdd) {
    var self = this; // Publish API ignores _id if present in fields

    if (key === "_id") return; // Don't share state with the data passed in by the user.

    value = EJSON.clone(value);

    if (!self.dataByKey.has(key)) {
      self.dataByKey.set(key, [{
        subscriptionHandle: subscriptionHandle,
        value: value
      }]);
      changeCollector[key] = value;
      return;
    }

    var precedenceList = self.dataByKey.get(key);
    var elt;

    if (!isAdd) {
      elt = precedenceList.find(function (precedence) {
        return precedence.subscriptionHandle === subscriptionHandle;
      });
    }

    if (elt) {
      if (elt === precedenceList[0] && !EJSON.equals(value, elt.value)) {
        // this subscription is changing the value of this field.
        changeCollector[key] = value;
      }

      elt.value = value;
    } else {
      // this subscription is newly caring about this field
      precedenceList.push({
        subscriptionHandle: subscriptionHandle,
        value: value
      });
    }
  }
});
/**
 * Represents a client's view of a single collection
 * @param {String} collectionName Name of the collection it represents
 * @param {Object.<String, Function>} sessionCallbacks The callbacks for added, changed, removed
 * @class SessionCollectionView
 */


var SessionCollectionView = function (collectionName, sessionCallbacks) {
  var self = this;
  self.collectionName = collectionName;
  self.documents = new Map();
  self.callbacks = sessionCallbacks;
};

DDPServer._SessionCollectionView = SessionCollectionView;
Object.assign(SessionCollectionView.prototype, {
  isEmpty: function () {
    var self = this;
    return self.documents.size === 0;
  },
  diff: function (previous) {
    var self = this;
    DiffSequence.diffMaps(previous.documents, self.documents, {
      both: _.bind(self.diffDocument, self),
      rightOnly: function (id, nowDV) {
        self.callbacks.added(self.collectionName, id, nowDV.getFields());
      },
      leftOnly: function (id, prevDV) {
        self.callbacks.removed(self.collectionName, id);
      }
    });
  },
  diffDocument: function (id, prevDV, nowDV) {
    var self = this;
    var fields = {};
    DiffSequence.diffObjects(prevDV.getFields(), nowDV.getFields(), {
      both: function (key, prev, now) {
        if (!EJSON.equals(prev, now)) fields[key] = now;
      },
      rightOnly: function (key, now) {
        fields[key] = now;
      },
      leftOnly: function (key, prev) {
        fields[key] = undefined;
      }
    });
    self.callbacks.changed(self.collectionName, id, fields);
  },
  added: function (subscriptionHandle, id, fields) {
    var self = this;
    var docView = self.documents.get(id);
    var added = false;

    if (!docView) {
      added = true;
      docView = new SessionDocumentView();
      self.documents.set(id, docView);
    }

    docView.existsIn.add(subscriptionHandle);
    var changeCollector = {};

    _.each(fields, function (value, key) {
      docView.changeField(subscriptionHandle, key, value, changeCollector, true);
    });

    if (added) self.callbacks.added(self.collectionName, id, changeCollector);else self.callbacks.changed(self.collectionName, id, changeCollector);
  },
  changed: function (subscriptionHandle, id, changed) {
    var self = this;
    var changedResult = {};
    var docView = self.documents.get(id);
    if (!docView) throw new Error("Could not find element with id " + id + " to change");

    _.each(changed, function (value, key) {
      if (value === undefined) docView.clearField(subscriptionHandle, key, changedResult);else docView.changeField(subscriptionHandle, key, value, changedResult);
    });

    self.callbacks.changed(self.collectionName, id, changedResult);
  },
  removed: function (subscriptionHandle, id) {
    var self = this;
    var docView = self.documents.get(id);

    if (!docView) {
      var err = new Error("Removed nonexistent document " + id);
      throw err;
    }

    docView.existsIn.delete(subscriptionHandle);

    if (docView.existsIn.size === 0) {
      // it is gone from everyone
      self.callbacks.removed(self.collectionName, id);
      self.documents.delete(id);
    } else {
      var changed = {}; // remove this subscription from every precedence list
      // and record the changes

      docView.dataByKey.forEach(function (precedenceList, key) {
        docView.clearField(subscriptionHandle, key, changed);
      });
      self.callbacks.changed(self.collectionName, id, changed);
    }
  }
});
/******************************************************************************/

/* Session                                                                    */

/******************************************************************************/

var Session = function (server, version, socket, options) {
  var self = this;
  self.id = Random.id();
  self.server = server;
  self.version = version;
  self.initialized = false;
  self.socket = socket; // Set to null when the session is destroyed. Multiple places below
  // use this to determine if the session is alive or not.

  self.inQueue = new Meteor._DoubleEndedQueue();
  self.blocked = false;
  self.workerRunning = false;
  self.cachedUnblock = null; // Sub objects for active subscriptions

  self._namedSubs = new Map();
  self._universalSubs = [];
  self.userId = null;
  self.collectionViews = new Map(); // Set this to false to not send messages when collectionViews are
  // modified. This is done when rerunning subs in _setUserId and those messages
  // are calculated via a diff instead.

  self._isSending = true; // If this is true, don't start a newly-created universal publisher on this
  // session. The session will take care of starting it when appropriate.

  self._dontStartNewUniversalSubs = false; // When we are rerunning subscriptions, any ready messages
  // we want to buffer up for when we are done rerunning subscriptions

  self._pendingReady = []; // List of callbacks to call when this connection is closed.

  self._closeCallbacks = []; // XXX HACK: If a sockjs connection, save off the URL. This is
  // temporary and will go away in the near future.

  self._socketUrl = socket.url; // Allow tests to disable responding to pings.

  self._respondToPings = options.respondToPings; // This object is the public interface to the session. In the public
  // API, it is called the `connection` object.  Internally we call it
  // a `connectionHandle` to avoid ambiguity.

  self.connectionHandle = {
    id: self.id,
    close: function () {
      self.close();
    },
    onClose: function (fn) {
      var cb = Meteor.bindEnvironment(fn, "connection onClose callback");

      if (self.inQueue) {
        self._closeCallbacks.push(cb);
      } else {
        // if we're already closed, call the callback.
        Meteor.defer(cb);
      }
    },
    clientAddress: self._clientAddress(),
    httpHeaders: self.socket.headers
  };
  self.send({
    msg: 'connected',
    session: self.id
  }); // On initial connect, spin up all the universal publishers.

  Fiber(function () {
    self.startUniversalSubs();
  }).run();

  if (version !== 'pre1' && options.heartbeatInterval !== 0) {
    // We no longer need the low level timeout because we have heartbeats.
    socket.setWebsocketTimeout(0);
    self.heartbeat = new DDPCommon.Heartbeat({
      heartbeatInterval: options.heartbeatInterval,
      heartbeatTimeout: options.heartbeatTimeout,
      onTimeout: function () {
        self.close();
      },
      sendPing: function () {
        self.send({
          msg: 'ping'
        });
      }
    });
    self.heartbeat.start();
  }

  Package['facts-base'] && Package['facts-base'].Facts.incrementServerFact("livedata", "sessions", 1);
};

Object.assign(Session.prototype, {
  sendReady: function (subscriptionIds) {
    var self = this;
    if (self._isSending) self.send({
      msg: "ready",
      subs: subscriptionIds
    });else {
      _.each(subscriptionIds, function (subscriptionId) {
        self._pendingReady.push(subscriptionId);
      });
    }
  },

  _canSend(collectionName) {
    return this._isSending || !this.server.getPublicationStrategy(collectionName).useCollectionView;
  },

  sendAdded(collectionName, id, fields) {
    if (this._canSend(collectionName)) this.send({
      msg: "added",
      collection: collectionName,
      id,
      fields
    });
  },

  sendChanged(collectionName, id, fields) {
    if (_.isEmpty(fields)) return;

    if (this._canSend(collectionName)) {
      this.send({
        msg: "changed",
        collection: collectionName,
        id,
        fields
      });
    }
  },

  sendRemoved(collectionName, id) {
    if (this._canSend(collectionName)) this.send({
      msg: "removed",
      collection: collectionName,
      id
    });
  },

  getSendCallbacks: function () {
    var self = this;
    return {
      added: _.bind(self.sendAdded, self),
      changed: _.bind(self.sendChanged, self),
      removed: _.bind(self.sendRemoved, self)
    };
  },
  getCollectionView: function (collectionName) {
    var self = this;
    var ret = self.collectionViews.get(collectionName);

    if (!ret) {
      ret = new SessionCollectionView(collectionName, self.getSendCallbacks());
      self.collectionViews.set(collectionName, ret);
    }

    return ret;
  },

  added(subscriptionHandle, collectionName, id, fields) {
    if (this.server.getPublicationStrategy(collectionName).useCollectionView) {
      const view = this.getCollectionView(collectionName);
      view.added(subscriptionHandle, id, fields);
    } else {
      this.sendAdded(collectionName, id, fields);
    }
  },

  removed(subscriptionHandle, collectionName, id) {
    if (this.server.getPublicationStrategy(collectionName).useCollectionView) {
      const view = this.getCollectionView(collectionName);
      view.removed(subscriptionHandle, id);

      if (view.isEmpty()) {
        this.collectionViews.delete(collectionName);
      }
    } else {
      this.sendRemoved(collectionName, id);
    }
  },

  changed(subscriptionHandle, collectionName, id, fields) {
    if (this.server.getPublicationStrategy(collectionName).useCollectionView) {
      const view = this.getCollectionView(collectionName);
      view.changed(subscriptionHandle, id, fields);
    } else {
      this.sendChanged(collectionName, id, fields);
    }
  },

  startUniversalSubs: function () {
    var self = this; // Make a shallow copy of the set of universal handlers and start them. If
    // additional universal publishers start while we're running them (due to
    // yielding), they will run separately as part of Server.publish.

    var handlers = _.clone(self.server.universal_publish_handlers);

    _.each(handlers, function (handler) {
      self._startSubscription(handler);
    });
  },
  // Destroy this session and unregister it at the server.
  close: function () {
    var self = this; // Destroy this session, even if it's not registered at the
    // server. Stop all processing and tear everything down. If a socket
    // was attached, close it.
    // Already destroyed.

    if (!self.inQueue) return; // Drop the merge box data immediately.

    self.inQueue = null;
    self.collectionViews = new Map();

    if (self.heartbeat) {
      self.heartbeat.stop();
      self.heartbeat = null;
    }

    if (self.socket) {
      self.socket.close();
      self.socket._meteorSession = null;
    }

    Package['facts-base'] && Package['facts-base'].Facts.incrementServerFact("livedata", "sessions", -1);
    Meteor.defer(function () {
      // Stop callbacks can yield, so we defer this on close.
      // sub._isDeactivated() detects that we set inQueue to null and
      // treats it as semi-deactivated (it will ignore incoming callbacks, etc).
      self._deactivateAllSubscriptions(); // Defer calling the close callbacks, so that the caller closing
      // the session isn't waiting for all the callbacks to complete.


      _.each(self._closeCallbacks, function (callback) {
        callback();
      });
    }); // Unregister the session.

    self.server._removeSession(self);
  },
  // Send a message (doing nothing if no socket is connected right now).
  // It should be a JSON object (it will be stringified).
  send: function (msg) {
    var self = this;

    if (self.socket) {
      if (Meteor._printSentDDP) Meteor._debug("Sent DDP", DDPCommon.stringifyDDP(msg));
      self.socket.send(DDPCommon.stringifyDDP(msg));
    }
  },
  // Send a connection error.
  sendError: function (reason, offendingMessage) {
    var self = this;
    var msg = {
      msg: 'error',
      reason: reason
    };
    if (offendingMessage) msg.offendingMessage = offendingMessage;
    self.send(msg);
  },
  // Process 'msg' as an incoming message. As a guard against
  // race conditions during reconnection, ignore the message if
  // 'socket' is not the currently connected socket.
  //
  // We run the messages from the client one at a time, in the order
  // given by the client. The message handler is passed an idempotent
  // function 'unblock' which it may call to allow other messages to
  // begin running in parallel in another fiber (for example, a method
  // that wants to yield). Otherwise, it is automatically unblocked
  // when it returns.
  //
  // Actually, we don't have to 'totally order' the messages in this
  // way, but it's the easiest thing that's correct. (unsub needs to
  // be ordered against sub, methods need to be ordered against each
  // other).
  processMessage: function (msg_in) {
    var self = this;
    if (!self.inQueue) // we have been destroyed.
      return; // Respond to ping and pong messages immediately without queuing.
    // If the negotiated DDP version is "pre1" which didn't support
    // pings, preserve the "pre1" behavior of responding with a "bad
    // request" for the unknown messages.
    //
    // Fibers are needed because heartbeats use Meteor.setTimeout, which
    // needs a Fiber. We could actually use regular setTimeout and avoid
    // these new fibers, but it is easier to just make everything use
    // Meteor.setTimeout and not think too hard.
    //
    // Any message counts as receiving a pong, as it demonstrates that
    // the client is still alive.

    if (self.heartbeat) {
      Fiber(function () {
        self.heartbeat.messageReceived();
      }).run();
    }

    if (self.version !== 'pre1' && msg_in.msg === 'ping') {
      if (self._respondToPings) self.send({
        msg: "pong",
        id: msg_in.id
      });
      return;
    }

    if (self.version !== 'pre1' && msg_in.msg === 'pong') {
      // Since everything is a pong, there is nothing to do
      return;
    }

    self.inQueue.push(msg_in);
    if (self.workerRunning) return;
    self.workerRunning = true;

    var processNext = function () {
      var msg = self.inQueue && self.inQueue.shift();

      if (!msg) {
        self.workerRunning = false;
        return;
      }

      Fiber(function () {
        var blocked = true;

        var unblock = function () {
          if (!blocked) return; // idempotent

          blocked = false;
          processNext();
        };

        self.server.onMessageHook.each(function (callback) {
          callback(msg, self);
          return true;
        });
        if (_.has(self.protocol_handlers, msg.msg)) self.protocol_handlers[msg.msg].call(self, msg, unblock);else self.sendError('Bad request', msg);
        unblock(); // in case the handler didn't already do it
      }).run();
    };

    processNext();
  },
  protocol_handlers: {
    sub: function (msg, unblock) {
      var self = this; // cacheUnblock temporarly, so we can capture it later
      // we will use unblock in current eventLoop, so this is safe

      self.cachedUnblock = unblock; // reject malformed messages

      if (typeof msg.id !== "string" || typeof msg.name !== "string" || 'params' in msg && !(msg.params instanceof Array)) {
        self.sendError("Malformed subscription", msg);
        return;
      }

      if (!self.server.publish_handlers[msg.name]) {
        self.send({
          msg: 'nosub',
          id: msg.id,
          error: new Meteor.Error(404, "Subscription '".concat(msg.name, "' not found"))
        });
        return;
      }

      if (self._namedSubs.has(msg.id)) // subs are idempotent, or rather, they are ignored if a sub
        // with that id already exists. this is important during
        // reconnect.
        return; // XXX It'd be much better if we had generic hooks where any package can
      // hook into subscription handling, but in the mean while we special case
      // ddp-rate-limiter package. This is also done for weak requirements to
      // add the ddp-rate-limiter package in case we don't have Accounts. A
      // user trying to use the ddp-rate-limiter must explicitly require it.

      if (Package['ddp-rate-limiter']) {
        var DDPRateLimiter = Package['ddp-rate-limiter'].DDPRateLimiter;
        var rateLimiterInput = {
          userId: self.userId,
          clientAddress: self.connectionHandle.clientAddress,
          type: "subscription",
          name: msg.name,
          connectionId: self.id
        };

        DDPRateLimiter._increment(rateLimiterInput);

        var rateLimitResult = DDPRateLimiter._check(rateLimiterInput);

        if (!rateLimitResult.allowed) {
          self.send({
            msg: 'nosub',
            id: msg.id,
            error: new Meteor.Error('too-many-requests', DDPRateLimiter.getErrorMessage(rateLimitResult), {
              timeToReset: rateLimitResult.timeToReset
            })
          });
          return;
        }
      }

      var handler = self.server.publish_handlers[msg.name];

      self._startSubscription(handler, msg.id, msg.params, msg.name); // cleaning cached unblock


      self.cachedUnblock = null;
    },
    unsub: function (msg) {
      var self = this;

      self._stopSubscription(msg.id);
    },
    method: function (msg, unblock) {
      var self = this; // Reject malformed messages.
      // For now, we silently ignore unknown attributes,
      // for forwards compatibility.

      if (typeof msg.id !== "string" || typeof msg.method !== "string" || 'params' in msg && !(msg.params instanceof Array) || 'randomSeed' in msg && typeof msg.randomSeed !== "string") {
        self.sendError("Malformed method invocation", msg);
        return;
      }

      var randomSeed = msg.randomSeed || null; // Set up to mark the method as satisfied once all observers
      // (and subscriptions) have reacted to any writes that were
      // done.

      var fence = new DDPServer._WriteFence();
      fence.onAllCommitted(function () {
        // Retire the fence so that future writes are allowed.
        // This means that callbacks like timers are free to use
        // the fence, and if they fire before it's armed (for
        // example, because the method waits for them) their
        // writes will be included in the fence.
        fence.retire();
        self.send({
          msg: 'updated',
          methods: [msg.id]
        });
      }); // Find the handler

      var handler = self.server.method_handlers[msg.method];

      if (!handler) {
        self.send({
          msg: 'result',
          id: msg.id,
          error: new Meteor.Error(404, "Method '".concat(msg.method, "' not found"))
        });
        fence.arm();
        return;
      }

      var setUserId = function (userId) {
        self._setUserId(userId);
      };

      var invocation = new DDPCommon.MethodInvocation({
        isSimulation: false,
        userId: self.userId,
        setUserId: setUserId,
        unblock: unblock,
        connection: self.connectionHandle,
        randomSeed: randomSeed
      });
      const promise = new Promise((resolve, reject) => {
        // XXX It'd be better if we could hook into method handlers better but
        // for now, we need to check if the ddp-rate-limiter exists since we
        // have a weak requirement for the ddp-rate-limiter package to be added
        // to our application.
        if (Package['ddp-rate-limiter']) {
          var DDPRateLimiter = Package['ddp-rate-limiter'].DDPRateLimiter;
          var rateLimiterInput = {
            userId: self.userId,
            clientAddress: self.connectionHandle.clientAddress,
            type: "method",
            name: msg.method,
            connectionId: self.id
          };

          DDPRateLimiter._increment(rateLimiterInput);

          var rateLimitResult = DDPRateLimiter._check(rateLimiterInput);

          if (!rateLimitResult.allowed) {
            reject(new Meteor.Error("too-many-requests", DDPRateLimiter.getErrorMessage(rateLimitResult), {
              timeToReset: rateLimitResult.timeToReset
            }));
            return;
          }
        }

        resolve(DDPServer._CurrentWriteFence.withValue(fence, () => DDP._CurrentMethodInvocation.withValue(invocation, () => maybeAuditArgumentChecks(handler, invocation, msg.params, "call to '" + msg.method + "'"))));
      });

      function finish() {
        fence.arm();
        unblock();
      }

      const payload = {
        msg: "result",
        id: msg.id
      };
      promise.then(result => {
        finish();

        if (result !== undefined) {
          payload.result = result;
        }

        self.send(payload);
      }, exception => {
        finish();
        payload.error = wrapInternalException(exception, "while invoking method '".concat(msg.method, "'"));
        self.send(payload);
      });
    }
  },
  _eachSub: function (f) {
    var self = this;

    self._namedSubs.forEach(f);

    self._universalSubs.forEach(f);
  },
  _diffCollectionViews: function (beforeCVs) {
    var self = this;
    DiffSequence.diffMaps(beforeCVs, self.collectionViews, {
      both: function (collectionName, leftValue, rightValue) {
        rightValue.diff(leftValue);
      },
      rightOnly: function (collectionName, rightValue) {
        rightValue.documents.forEach(function (docView, id) {
          self.sendAdded(collectionName, id, docView.getFields());
        });
      },
      leftOnly: function (collectionName, leftValue) {
        leftValue.documents.forEach(function (doc, id) {
          self.sendRemoved(collectionName, id);
        });
      }
    });
  },
  // Sets the current user id in all appropriate contexts and reruns
  // all subscriptions
  _setUserId: function (userId) {
    var self = this;
    if (userId !== null && typeof userId !== "string") throw new Error("setUserId must be called on string or null, not " + typeof userId); // Prevent newly-created universal subscriptions from being added to our
    // session. They will be found below when we call startUniversalSubs.
    //
    // (We don't have to worry about named subscriptions, because we only add
    // them when we process a 'sub' message. We are currently processing a
    // 'method' message, and the method did not unblock, because it is illegal
    // to call setUserId after unblock. Thus we cannot be concurrently adding a
    // new named subscription).

    self._dontStartNewUniversalSubs = true; // Prevent current subs from updating our collectionViews and call their
    // stop callbacks. This may yield.

    self._eachSub(function (sub) {
      sub._deactivate();
    }); // All subs should now be deactivated. Stop sending messages to the client,
    // save the state of the published collections, reset to an empty view, and
    // update the userId.


    self._isSending = false;
    var beforeCVs = self.collectionViews;
    self.collectionViews = new Map();
    self.userId = userId; // _setUserId is normally called from a Meteor method with
    // DDP._CurrentMethodInvocation set. But DDP._CurrentMethodInvocation is not
    // expected to be set inside a publish function, so we temporary unset it.
    // Inside a publish function DDP._CurrentPublicationInvocation is set.

    DDP._CurrentMethodInvocation.withValue(undefined, function () {
      // Save the old named subs, and reset to having no subscriptions.
      var oldNamedSubs = self._namedSubs;
      self._namedSubs = new Map();
      self._universalSubs = [];
      oldNamedSubs.forEach(function (sub, subscriptionId) {
        var newSub = sub._recreate();

        self._namedSubs.set(subscriptionId, newSub); // nb: if the handler throws or calls this.error(), it will in fact
        // immediately send its 'nosub'. This is OK, though.


        newSub._runHandler();
      }); // Allow newly-created universal subs to be started on our connection in
      // parallel with the ones we're spinning up here, and spin up universal
      // subs.

      self._dontStartNewUniversalSubs = false;
      self.startUniversalSubs();
    }); // Start sending messages again, beginning with the diff from the previous
    // state of the world to the current state. No yields are allowed during
    // this diff, so that other changes cannot interleave.


    Meteor._noYieldsAllowed(function () {
      self._isSending = true;

      self._diffCollectionViews(beforeCVs);

      if (!_.isEmpty(self._pendingReady)) {
        self.sendReady(self._pendingReady);
        self._pendingReady = [];
      }
    });
  },
  _startSubscription: function (handler, subId, params, name) {
    var self = this;
    var sub = new Subscription(self, handler, subId, params, name);
    let unblockHander = self.cachedUnblock; // _startSubscription may call from a lot places
    // so cachedUnblock might be null in somecases
    // assign the cachedUnblock

    sub.unblock = unblockHander || (() => {});

    if (subId) self._namedSubs.set(subId, sub);else self._universalSubs.push(sub);

    sub._runHandler();
  },
  // Tear down specified subscription
  _stopSubscription: function (subId, error) {
    var self = this;
    var subName = null;

    if (subId) {
      var maybeSub = self._namedSubs.get(subId);

      if (maybeSub) {
        subName = maybeSub._name;

        maybeSub._removeAllDocuments();

        maybeSub._deactivate();

        self._namedSubs.delete(subId);
      }
    }

    var response = {
      msg: 'nosub',
      id: subId
    };

    if (error) {
      response.error = wrapInternalException(error, subName ? "from sub " + subName + " id " + subId : "from sub id " + subId);
    }

    self.send(response);
  },
  // Tear down all subscriptions. Note that this does NOT send removed or nosub
  // messages, since we assume the client is gone.
  _deactivateAllSubscriptions: function () {
    var self = this;

    self._namedSubs.forEach(function (sub, id) {
      sub._deactivate();
    });

    self._namedSubs = new Map();

    self._universalSubs.forEach(function (sub) {
      sub._deactivate();
    });

    self._universalSubs = [];
  },
  // Determine the remote client's IP address, based on the
  // HTTP_FORWARDED_COUNT environment variable representing how many
  // proxies the server is behind.
  _clientAddress: function () {
    var self = this; // For the reported client address for a connection to be correct,
    // the developer must set the HTTP_FORWARDED_COUNT environment
    // variable to an integer representing the number of hops they
    // expect in the `x-forwarded-for` header. E.g., set to "1" if the
    // server is behind one proxy.
    //
    // This could be computed once at startup instead of every time.

    var httpForwardedCount = parseInt(process.env['HTTP_FORWARDED_COUNT']) || 0;
    if (httpForwardedCount === 0) return self.socket.remoteAddress;
    var forwardedFor = self.socket.headers["x-forwarded-for"];
    if (!_.isString(forwardedFor)) return null;
    forwardedFor = forwardedFor.trim().split(/\s*,\s*/); // Typically the first value in the `x-forwarded-for` header is
    // the original IP address of the client connecting to the first
    // proxy.  However, the end user can easily spoof the header, in
    // which case the first value(s) will be the fake IP address from
    // the user pretending to be a proxy reporting the original IP
    // address value.  By counting HTTP_FORWARDED_COUNT back from the
    // end of the list, we ensure that we get the IP address being
    // reported by *our* first proxy.

    if (httpForwardedCount < 0 || httpForwardedCount > forwardedFor.length) return null;
    return forwardedFor[forwardedFor.length - httpForwardedCount];
  }
});
/******************************************************************************/

/* Subscription                                                               */

/******************************************************************************/
// Ctor for a sub handle: the input to each publish function
// Instance name is this because it's usually referred to as this inside a
// publish

/**
 * @summary The server's side of a subscription
 * @class Subscription
 * @instanceName this
 * @showInstanceName true
 */

var Subscription = function (session, handler, subscriptionId, params, name) {
  var self = this;
  self._session = session; // type is Session

  /**
   * @summary Access inside the publish function. The incoming [connection](#meteor_onconnection) for this subscription.
   * @locus Server
   * @name  connection
   * @memberOf Subscription
   * @instance
   */

  self.connection = session.connectionHandle; // public API object

  self._handler = handler; // My subscription ID (generated by client, undefined for universal subs).

  self._subscriptionId = subscriptionId; // Undefined for universal subs

  self._name = name;
  self._params = params || []; // Only named subscriptions have IDs, but we need some sort of string
  // internally to keep track of all subscriptions inside
  // SessionDocumentViews. We use this subscriptionHandle for that.

  if (self._subscriptionId) {
    self._subscriptionHandle = 'N' + self._subscriptionId;
  } else {
    self._subscriptionHandle = 'U' + Random.id();
  } // Has _deactivate been called?


  self._deactivated = false; // Stop callbacks to g/c this sub.  called w/ zero arguments.

  self._stopCallbacks = []; // The set of (collection, documentid) that this subscription has
  // an opinion about.

  self._documents = new Map(); // Remember if we are ready.

  self._ready = false; // Part of the public API: the user of this sub.

  /**
   * @summary Access inside the publish function. The id of the logged-in user, or `null` if no user is logged in.
   * @locus Server
   * @memberOf Subscription
   * @name  userId
   * @instance
   */

  self.userId = session.userId; // For now, the id filter is going to default to
  // the to/from DDP methods on MongoID, to
  // specifically deal with mongo/minimongo ObjectIds.
  // Later, you will be able to make this be "raw"
  // if you want to publish a collection that you know
  // just has strings for keys and no funny business, to
  // a DDP consumer that isn't minimongo.

  self._idFilter = {
    idStringify: MongoID.idStringify,
    idParse: MongoID.idParse
  };
  Package['facts-base'] && Package['facts-base'].Facts.incrementServerFact("livedata", "subscriptions", 1);
};

Object.assign(Subscription.prototype, {
  _runHandler: function () {
    // XXX should we unblock() here? Either before running the publish
    // function, or before running _publishCursor.
    //
    // Right now, each publish function blocks all future publishes and
    // methods waiting on data from Mongo (or whatever else the function
    // blocks on). This probably slows page load in common cases.
    if (!this.unblock) {
      this.unblock = () => {};
    }

    const self = this;
    let resultOrThenable = null;

    try {
      resultOrThenable = DDP._CurrentPublicationInvocation.withValue(self, () => maybeAuditArgumentChecks(self._handler, self, EJSON.clone(self._params), // It's OK that this would look weird for universal subscriptions,
      // because they have no arguments so there can never be an
      // audit-argument-checks failure.
      "publisher '" + self._name + "'"));
    } catch (e) {
      self.error(e);
      return;
    } // Did the handler call this.error or this.stop?


    if (self._isDeactivated()) return; // Both conventional and async publish handler functions are supported.
    // If an object is returned with a then() function, it is either a promise
    // or thenable and will be resolved asynchronously.

    const isThenable = resultOrThenable && typeof resultOrThenable.then === 'function';

    if (isThenable) {
      Promise.resolve(resultOrThenable).then(function () {
        return self._publishHandlerResult.bind(self)(...arguments);
      }, e => self.error(e));
    } else {
      self._publishHandlerResult(resultOrThenable);
    }
  },
  _publishHandlerResult: function (res) {
    // SPECIAL CASE: Instead of writing their own callbacks that invoke
    // this.added/changed/ready/etc, the user can just return a collection
    // cursor or array of cursors from the publish function; we call their
    // _publishCursor method which starts observing the cursor and publishes the
    // results. Note that _publishCursor does NOT call ready().
    //
    // XXX This uses an undocumented interface which only the Mongo cursor
    // interface publishes. Should we make this interface public and encourage
    // users to implement it themselves? Arguably, it's unnecessary; users can
    // already write their own functions like
    //   var publishMyReactiveThingy = function (name, handler) {
    //     Meteor.publish(name, function () {
    //       var reactiveThingy = handler();
    //       reactiveThingy.publishMe();
    //     });
    //   };
    var self = this;

    var isCursor = function (c) {
      return c && c._publishCursor;
    };

    if (isCursor(res)) {
      try {
        res._publishCursor(self);
      } catch (e) {
        self.error(e);
        return;
      } // _publishCursor only returns after the initial added callbacks have run.
      // mark subscription as ready.


      self.ready();
    } else if (_.isArray(res)) {
      // Check all the elements are cursors
      if (!_.all(res, isCursor)) {
        self.error(new Error("Publish function returned an array of non-Cursors"));
        return;
      } // Find duplicate collection names
      // XXX we should support overlapping cursors, but that would require the
      // merge box to allow overlap within a subscription


      var collectionNames = {};

      for (var i = 0; i < res.length; ++i) {
        var collectionName = res[i]._getCollectionName();

        if (_.has(collectionNames, collectionName)) {
          self.error(new Error("Publish function returned multiple cursors for collection " + collectionName));
          return;
        }

        collectionNames[collectionName] = true;
      }

      ;

      try {
        _.each(res, function (cur) {
          cur._publishCursor(self);
        });
      } catch (e) {
        self.error(e);
        return;
      }

      self.ready();
    } else if (res) {
      // Truthy values other than cursors or arrays are probably a
      // user mistake (possible returning a Mongo document via, say,
      // `coll.findOne()`).
      self.error(new Error("Publish function can only return a Cursor or " + "an array of Cursors"));
    }
  },
  // This calls all stop callbacks and prevents the handler from updating any
  // SessionCollectionViews further. It's used when the user unsubscribes or
  // disconnects, as well as during setUserId re-runs. It does *NOT* send
  // removed messages for the published objects; if that is necessary, call
  // _removeAllDocuments first.
  _deactivate: function () {
    var self = this;
    if (self._deactivated) return;
    self._deactivated = true;

    self._callStopCallbacks();

    Package['facts-base'] && Package['facts-base'].Facts.incrementServerFact("livedata", "subscriptions", -1);
  },
  _callStopCallbacks: function () {
    var self = this; // Tell listeners, so they can clean up

    var callbacks = self._stopCallbacks;
    self._stopCallbacks = [];

    _.each(callbacks, function (callback) {
      callback();
    });
  },
  // Send remove messages for every document.
  _removeAllDocuments: function () {
    var self = this;

    Meteor._noYieldsAllowed(function () {
      self._documents.forEach(function (collectionDocs, collectionName) {
        collectionDocs.forEach(function (strId) {
          self.removed(collectionName, self._idFilter.idParse(strId));
        });
      });
    });
  },
  // Returns a new Subscription for the same session with the same
  // initial creation parameters. This isn't a clone: it doesn't have
  // the same _documents cache, stopped state or callbacks; may have a
  // different _subscriptionHandle, and gets its userId from the
  // session, not from this object.
  _recreate: function () {
    var self = this;
    return new Subscription(self._session, self._handler, self._subscriptionId, self._params, self._name);
  },

  /**
   * @summary Call inside the publish function.  Stops this client's subscription, triggering a call on the client to the `onStop` callback passed to [`Meteor.subscribe`](#meteor_subscribe), if any. If `error` is not a [`Meteor.Error`](#meteor_error), it will be [sanitized](#meteor_error).
   * @locus Server
   * @param {Error} error The error to pass to the client.
   * @instance
   * @memberOf Subscription
   */
  error: function (error) {
    var self = this;
    if (self._isDeactivated()) return;

    self._session._stopSubscription(self._subscriptionId, error);
  },
  // Note that while our DDP client will notice that you've called stop() on the
  // server (and clean up its _subscriptions table) we don't actually provide a
  // mechanism for an app to notice this (the subscribe onError callback only
  // triggers if there is an error).

  /**
   * @summary Call inside the publish function.  Stops this client's subscription and invokes the client's `onStop` callback with no error.
   * @locus Server
   * @instance
   * @memberOf Subscription
   */
  stop: function () {
    var self = this;
    if (self._isDeactivated()) return;

    self._session._stopSubscription(self._subscriptionId);
  },

  /**
   * @summary Call inside the publish function.  Registers a callback function to run when the subscription is stopped.
   * @locus Server
   * @memberOf Subscription
   * @instance
   * @param {Function} func The callback function
   */
  onStop: function (callback) {
    var self = this;
    callback = Meteor.bindEnvironment(callback, 'onStop callback', self);
    if (self._isDeactivated()) callback();else self._stopCallbacks.push(callback);
  },
  // This returns true if the sub has been deactivated, *OR* if the session was
  // destroyed but the deferred call to _deactivateAllSubscriptions hasn't
  // happened yet.
  _isDeactivated: function () {
    var self = this;
    return self._deactivated || self._session.inQueue === null;
  },

  /**
   * @summary Call inside the publish function.  Informs the subscriber that a document has been added to the record set.
   * @locus Server
   * @memberOf Subscription
   * @instance
   * @param {String} collection The name of the collection that contains the new document.
   * @param {String} id The new document's ID.
   * @param {Object} fields The fields in the new document.  If `_id` is present it is ignored.
   */
  added(collectionName, id, fields) {
    if (this._isDeactivated()) return;
    id = this._idFilter.idStringify(id);

    if (this._session.server.getPublicationStrategy(collectionName).doAccountingForCollection) {
      let ids = this._documents.get(collectionName);

      if (ids == null) {
        ids = new Set();

        this._documents.set(collectionName, ids);
      }

      ids.add(id);
    }

    this._session.added(this._subscriptionHandle, collectionName, id, fields);
  },

  /**
   * @summary Call inside the publish function.  Informs the subscriber that a document in the record set has been modified.
   * @locus Server
   * @memberOf Subscription
   * @instance
   * @param {String} collection The name of the collection that contains the changed document.
   * @param {String} id The changed document's ID.
   * @param {Object} fields The fields in the document that have changed, together with their new values.  If a field is not present in `fields` it was left unchanged; if it is present in `fields` and has a value of `undefined` it was removed from the document.  If `_id` is present it is ignored.
   */
  changed(collectionName, id, fields) {
    if (this._isDeactivated()) return;
    id = this._idFilter.idStringify(id);

    this._session.changed(this._subscriptionHandle, collectionName, id, fields);
  },

  /**
   * @summary Call inside the publish function.  Informs the subscriber that a document has been removed from the record set.
   * @locus Server
   * @memberOf Subscription
   * @instance
   * @param {String} collection The name of the collection that the document has been removed from.
   * @param {String} id The ID of the document that has been removed.
   */
  removed(collectionName, id) {
    if (this._isDeactivated()) return;
    id = this._idFilter.idStringify(id);

    if (this._session.server.getPublicationStrategy(collectionName).doAccountingForCollection) {
      // We don't bother to delete sets of things in a collection if the
      // collection is empty.  It could break _removeAllDocuments.
      this._documents.get(collectionName).delete(id);
    }

    this._session.removed(this._subscriptionHandle, collectionName, id);
  },

  /**
   * @summary Call inside the publish function.  Informs the subscriber that an initial, complete snapshot of the record set has been sent.  This will trigger a call on the client to the `onReady` callback passed to  [`Meteor.subscribe`](#meteor_subscribe), if any.
   * @locus Server
   * @memberOf Subscription
   * @instance
   */
  ready: function () {
    var self = this;
    if (self._isDeactivated()) return;
    if (!self._subscriptionId) return; // Unnecessary but ignored for universal sub

    if (!self._ready) {
      self._session.sendReady([self._subscriptionId]);

      self._ready = true;
    }
  }
});
/******************************************************************************/

/* Server                                                                     */

/******************************************************************************/

Server = function () {
  let options = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};
  var self = this; // The default heartbeat interval is 30 seconds on the server and 35
  // seconds on the client.  Since the client doesn't need to send a
  // ping as long as it is receiving pings, this means that pings
  // normally go from the server to the client.
  //
  // Note: Troposphere depends on the ability to mutate
  // Meteor.server.options.heartbeatTimeout! This is a hack, but it's life.

  self.options = _objectSpread({
    heartbeatInterval: 15000,
    heartbeatTimeout: 15000,
    // For testing, allow responding to pings to be disabled.
    respondToPings: true,
    defaultPublicationStrategy: publicationStrategies.SERVER_MERGE
  }, options); // Map of callbacks to call when a new connection comes in to the
  // server and completes DDP version negotiation. Use an object instead
  // of an array so we can safely remove one from the list while
  // iterating over it.

  self.onConnectionHook = new Hook({
    debugPrintExceptions: "onConnection callback"
  }); // Map of callbacks to call when a new message comes in.

  self.onMessageHook = new Hook({
    debugPrintExceptions: "onMessage callback"
  });
  self.publish_handlers = {};
  self.universal_publish_handlers = [];
  self.method_handlers = {};
  self._publicationStrategies = {};
  self.sessions = new Map(); // map from id to session

  self.stream_server = new StreamServer();
  self.stream_server.register(function (socket) {
    // socket implements the SockJSConnection interface
    socket._meteorSession = null;

    var sendError = function (reason, offendingMessage) {
      var msg = {
        msg: 'error',
        reason: reason
      };
      if (offendingMessage) msg.offendingMessage = offendingMessage;
      socket.send(DDPCommon.stringifyDDP(msg));
    };

    socket.on('data', function (raw_msg) {
      if (Meteor._printReceivedDDP) {
        Meteor._debug("Received DDP", raw_msg);
      }

      try {
        try {
          var msg = DDPCommon.parseDDP(raw_msg);
        } catch (err) {
          sendError('Parse error');
          return;
        }

        if (msg === null || !msg.msg) {
          sendError('Bad request', msg);
          return;
        }

        if (msg.msg === 'connect') {
          if (socket._meteorSession) {
            sendError("Already connected", msg);
            return;
          }

          Fiber(function () {
            self._handleConnect(socket, msg);
          }).run();
          return;
        }

        if (!socket._meteorSession) {
          sendError('Must connect first', msg);
          return;
        }

        socket._meteorSession.processMessage(msg);
      } catch (e) {
        // XXX print stack nicely
        Meteor._debug("Internal exception while processing message", msg, e);
      }
    });
    socket.on('close', function () {
      if (socket._meteorSession) {
        Fiber(function () {
          socket._meteorSession.close();
        }).run();
      }
    });
  });
};

Object.assign(Server.prototype, {
  /**
   * @summary Register a callback to be called when a new DDP connection is made to the server.
   * @locus Server
   * @param {function} callback The function to call when a new DDP connection is established.
   * @memberOf Meteor
   * @importFromPackage meteor
   */
  onConnection: function (fn) {
    var self = this;
    return self.onConnectionHook.register(fn);
  },

  /**
   * @summary Set publication strategy for the given publication. Publications strategies are available from `DDPServer.publicationStrategies`. You call this method from `Meteor.server`, like `Meteor.server.setPublicationStrategy()`
   * @locus Server
   * @alias setPublicationStrategy
   * @param publicationName {String}
   * @param strategy {{useCollectionView: boolean, doAccountingForCollection: boolean}}
   * @memberOf Meteor.server
   * @importFromPackage meteor
   */
  setPublicationStrategy(publicationName, strategy) {
    if (!Object.values(publicationStrategies).includes(strategy)) {
      throw new Error("Invalid merge strategy: ".concat(strategy, " \n        for collection ").concat(publicationName));
    }

    this._publicationStrategies[publicationName] = strategy;
  },

  /**
   * @summary Gets the publication strategy for the requested publication. You call this method from `Meteor.server`, like `Meteor.server.getPublicationStrategy()`
   * @locus Server
   * @alias getPublicationStrategy
   * @param publicationName {String}
   * @memberOf Meteor.server
   * @importFromPackage meteor
   * @return {{useCollectionView: boolean, doAccountingForCollection: boolean}}
   */
  getPublicationStrategy(publicationName) {
    return this._publicationStrategies[publicationName] || this.options.defaultPublicationStrategy;
  },

  /**
   * @summary Register a callback to be called when a new DDP message is received.
   * @locus Server
   * @param {function} callback The function to call when a new DDP message is received.
   * @memberOf Meteor
   * @importFromPackage meteor
   */
  onMessage: function (fn) {
    var self = this;
    return self.onMessageHook.register(fn);
  },
  _handleConnect: function (socket, msg) {
    var self = this; // The connect message must specify a version and an array of supported
    // versions, and it must claim to support what it is proposing.

    if (!(typeof msg.version === 'string' && _.isArray(msg.support) && _.all(msg.support, _.isString) && _.contains(msg.support, msg.version))) {
      socket.send(DDPCommon.stringifyDDP({
        msg: 'failed',
        version: DDPCommon.SUPPORTED_DDP_VERSIONS[0]
      }));
      socket.close();
      return;
    } // In the future, handle session resumption: something like:
    //  socket._meteorSession = self.sessions[msg.session]


    var version = calculateVersion(msg.support, DDPCommon.SUPPORTED_DDP_VERSIONS);

    if (msg.version !== version) {
      // The best version to use (according to the client's stated preferences)
      // is not the one the client is trying to use. Inform them about the best
      // version to use.
      socket.send(DDPCommon.stringifyDDP({
        msg: 'failed',
        version: version
      }));
      socket.close();
      return;
    } // Yay, version matches! Create a new session.
    // Note: Troposphere depends on the ability to mutate
    // Meteor.server.options.heartbeatTimeout! This is a hack, but it's life.


    socket._meteorSession = new Session(self, version, socket, self.options);
    self.sessions.set(socket._meteorSession.id, socket._meteorSession);
    self.onConnectionHook.each(function (callback) {
      if (socket._meteorSession) callback(socket._meteorSession.connectionHandle);
      return true;
    });
  },

  /**
   * Register a publish handler function.
   *
   * @param name {String} identifier for query
   * @param handler {Function} publish handler
   * @param options {Object}
   *
   * Server will call handler function on each new subscription,
   * either when receiving DDP sub message for a named subscription, or on
   * DDP connect for a universal subscription.
   *
   * If name is null, this will be a subscription that is
   * automatically established and permanently on for all connected
   * client, instead of a subscription that can be turned on and off
   * with subscribe().
   *
   * options to contain:
   *  - (mostly internal) is_auto: true if generated automatically
   *    from an autopublish hook. this is for cosmetic purposes only
   *    (it lets us determine whether to print a warning suggesting
   *    that you turn off autopublish).
   */

  /**
   * @summary Publish a record set.
   * @memberOf Meteor
   * @importFromPackage meteor
   * @locus Server
   * @param {String|Object} name If String, name of the record set.  If Object, publications Dictionary of publish functions by name.  If `null`, the set has no name, and the record set is automatically sent to all connected clients.
   * @param {Function} func Function called on the server each time a client subscribes.  Inside the function, `this` is the publish handler object, described below.  If the client passed arguments to `subscribe`, the function is called with the same arguments.
   */
  publish: function (name, handler, options) {
    var self = this;

    if (!_.isObject(name)) {
      options = options || {};

      if (name && name in self.publish_handlers) {
        Meteor._debug("Ignoring duplicate publish named '" + name + "'");

        return;
      }

      if (Package.autopublish && !options.is_auto) {
        // They have autopublish on, yet they're trying to manually
        // pick stuff to publish. They probably should turn off
        // autopublish. (This check isn't perfect -- if you create a
        // publish before you turn on autopublish, it won't catch
        // it, but this will definitely handle the simple case where
        // you've added the autopublish package to your app, and are
        // calling publish from your app code).
        if (!self.warned_about_autopublish) {
          self.warned_about_autopublish = true;

          Meteor._debug("** You've set up some data subscriptions with Meteor.publish(), but\n" + "** you still have autopublish turned on. Because autopublish is still\n" + "** on, your Meteor.publish() calls won't have much effect. All data\n" + "** will still be sent to all clients.\n" + "**\n" + "** Turn off autopublish by removing the autopublish package:\n" + "**\n" + "**   $ meteor remove autopublish\n" + "**\n" + "** .. and make sure you have Meteor.publish() and Meteor.subscribe() calls\n" + "** for each collection that you want clients to see.\n");
        }
      }

      if (name) self.publish_handlers[name] = handler;else {
        self.universal_publish_handlers.push(handler); // Spin up the new publisher on any existing session too. Run each
        // session's subscription in a new Fiber, so that there's no change for
        // self.sessions to change while we're running this loop.

        self.sessions.forEach(function (session) {
          if (!session._dontStartNewUniversalSubs) {
            Fiber(function () {
              session._startSubscription(handler);
            }).run();
          }
        });
      }
    } else {
      _.each(name, function (value, key) {
        self.publish(key, value, {});
      });
    }
  },
  _removeSession: function (session) {
    var self = this;
    self.sessions.delete(session.id);
  },

  /**
   * @summary Defines functions that can be invoked over the network by clients.
   * @locus Anywhere
   * @param {Object} methods Dictionary whose keys are method names and values are functions.
   * @memberOf Meteor
   * @importFromPackage meteor
   */
  methods: function (methods) {
    var self = this;

    _.each(methods, function (func, name) {
      if (typeof func !== 'function') throw new Error("Method '" + name + "' must be a function");
      if (self.method_handlers[name]) throw new Error("A method named '" + name + "' is already defined");
      self.method_handlers[name] = func;
    });
  },
  call: function (name) {
    for (var _len = arguments.length, args = new Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
      args[_key - 1] = arguments[_key];
    }

    if (args.length && typeof args[args.length - 1] === "function") {
      // If it's a function, the last argument is the result callback, not
      // a parameter to the remote method.
      var callback = args.pop();
    }

    return this.apply(name, args, callback);
  },
  // A version of the call method that always returns a Promise.
  callAsync: function (name) {
    for (var _len2 = arguments.length, args = new Array(_len2 > 1 ? _len2 - 1 : 0), _key2 = 1; _key2 < _len2; _key2++) {
      args[_key2 - 1] = arguments[_key2];
    }

    return this.applyAsync(name, args);
  },
  apply: function (name, args, options, callback) {
    // We were passed 3 arguments. They may be either (name, args, options)
    // or (name, args, callback)
    if (!callback && typeof options === 'function') {
      callback = options;
      options = {};
    } else {
      options = options || {};
    }

    const promise = this.applyAsync(name, args, options); // Return the result in whichever way the caller asked for it. Note that we
    // do NOT block on the write fence in an analogous way to how the client
    // blocks on the relevant data being visible, so you are NOT guaranteed that
    // cursor observe callbacks have fired when your callback is invoked. (We
    // can change this if there's a real use case).

    if (callback) {
      promise.then(result => callback(undefined, result), exception => callback(exception));
    } else {
      return promise.await();
    }
  },
  // @param options {Optional Object}
  applyAsync: function (name, args, options) {
    // Run the handler
    var handler = this.method_handlers[name];

    if (!handler) {
      return Promise.reject(new Meteor.Error(404, "Method '".concat(name, "' not found")));
    } // If this is a method call from within another method or publish function,
    // get the user state from the outer method or publish function, otherwise
    // don't allow setUserId to be called


    var userId = null;

    var setUserId = function () {
      throw new Error("Can't call setUserId on a server initiated method call");
    };

    var connection = null;

    var currentMethodInvocation = DDP._CurrentMethodInvocation.get();

    var currentPublicationInvocation = DDP._CurrentPublicationInvocation.get();

    var randomSeed = null;

    if (currentMethodInvocation) {
      userId = currentMethodInvocation.userId;

      setUserId = function (userId) {
        currentMethodInvocation.setUserId(userId);
      };

      connection = currentMethodInvocation.connection;
      randomSeed = DDPCommon.makeRpcSeed(currentMethodInvocation, name);
    } else if (currentPublicationInvocation) {
      userId = currentPublicationInvocation.userId;

      setUserId = function (userId) {
        currentPublicationInvocation._session._setUserId(userId);
      };

      connection = currentPublicationInvocation.connection;
    }

    var invocation = new DDPCommon.MethodInvocation({
      isSimulation: false,
      userId,
      setUserId,
      connection,
      randomSeed
    });
    return new Promise(resolve => resolve(DDP._CurrentMethodInvocation.withValue(invocation, () => maybeAuditArgumentChecks(handler, invocation, EJSON.clone(args), "internal call to '" + name + "'")))).then(EJSON.clone);
  },
  _urlForSession: function (sessionId) {
    var self = this;
    var session = self.sessions.get(sessionId);
    if (session) return session._socketUrl;else return null;
  }
});

var calculateVersion = function (clientSupportedVersions, serverSupportedVersions) {
  var correctVersion = _.find(clientSupportedVersions, function (version) {
    return _.contains(serverSupportedVersions, version);
  });

  if (!correctVersion) {
    correctVersion = serverSupportedVersions[0];
  }

  return correctVersion;
};

DDPServer._calculateVersion = calculateVersion; // "blind" exceptions other than those that were deliberately thrown to signal
// errors to the client

var wrapInternalException = function (exception, context) {
  if (!exception) return exception; // To allow packages to throw errors intended for the client but not have to
  // depend on the Meteor.Error class, `isClientSafe` can be set to true on any
  // error before it is thrown.

  if (exception.isClientSafe) {
    if (!(exception instanceof Meteor.Error)) {
      const originalMessage = exception.message;
      exception = new Meteor.Error(exception.error, exception.reason, exception.details);
      exception.message = originalMessage;
    }

    return exception;
  } // Tests can set the '_expectedByTest' flag on an exception so it won't go to
  // the server log.


  if (!exception._expectedByTest) {
    Meteor._debug("Exception " + context, exception.stack);

    if (exception.sanitizedError) {
      Meteor._debug("Sanitized and reported to the client as:", exception.sanitizedError);

      Meteor._debug();
    }
  } // Did the error contain more details that could have been useful if caught in
  // server code (or if thrown from non-client-originated code), but also
  // provided a "sanitized" version with more context than 500 Internal server
  // error? Use that.


  if (exception.sanitizedError) {
    if (exception.sanitizedError.isClientSafe) return exception.sanitizedError;

    Meteor._debug("Exception " + context + " provides a sanitizedError that " + "does not have isClientSafe property set; ignoring");
  }

  return new Meteor.Error(500, "Internal server error");
}; // Audit argument checks, if the audit-argument-checks package exists (it is a
// weak dependency of this package).


var maybeAuditArgumentChecks = function (f, context, args, description) {
  args = args || [];

  if (Package['audit-argument-checks']) {
    return Match._failIfArgumentsAreNotAllChecked(f, context, args, description);
  }

  return f.apply(context, args);
};
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"writefence.js":function module(require){

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
// packages/ddp-server/writefence.js                                                                                  //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                      //
var Future = Npm.require('fibers/future'); // A write fence collects a group of writes, and provides a callback
// when all of the writes are fully committed and propagated (all
// observers have been notified of the write and acknowledged it.)
//


DDPServer._WriteFence = function () {
  var self = this;
  self.armed = false;
  self.fired = false;
  self.retired = false;
  self.outstanding_writes = 0;
  self.before_fire_callbacks = [];
  self.completion_callbacks = [];
}; // The current write fence. When there is a current write fence, code
// that writes to databases should register their writes with it using
// beginWrite().
//


DDPServer._CurrentWriteFence = new Meteor.EnvironmentVariable();

_.extend(DDPServer._WriteFence.prototype, {
  // Start tracking a write, and return an object to represent it. The
  // object has a single method, committed(). This method should be
  // called when the write is fully committed and propagated. You can
  // continue to add writes to the WriteFence up until it is triggered
  // (calls its callbacks because all writes have committed.)
  beginWrite: function () {
    var self = this;
    if (self.retired) return {
      committed: function () {}
    };
    if (self.fired) throw new Error("fence has already activated -- too late to add writes");
    self.outstanding_writes++;
    var committed = false;
    return {
      committed: function () {
        if (committed) throw new Error("committed called twice on the same write");
        committed = true;
        self.outstanding_writes--;

        self._maybeFire();
      }
    };
  },
  // Arm the fence. Once the fence is armed, and there are no more
  // uncommitted writes, it will activate.
  arm: function () {
    var self = this;
    if (self === DDPServer._CurrentWriteFence.get()) throw Error("Can't arm the current fence");
    self.armed = true;

    self._maybeFire();
  },
  // Register a function to be called once before firing the fence.
  // Callback function can add new writes to the fence, in which case
  // it won't fire until those writes are done as well.
  onBeforeFire: function (func) {
    var self = this;
    if (self.fired) throw new Error("fence has already activated -- too late to " + "add a callback");
    self.before_fire_callbacks.push(func);
  },
  // Register a function to be called when the fence fires.
  onAllCommitted: function (func) {
    var self = this;
    if (self.fired) throw new Error("fence has already activated -- too late to " + "add a callback");
    self.completion_callbacks.push(func);
  },
  // Convenience function. Arms the fence, then blocks until it fires.
  armAndWait: function () {
    var self = this;
    var future = new Future();
    self.onAllCommitted(function () {
      future['return']();
    });
    self.arm();
    future.wait();
  },
  _maybeFire: function () {
    var self = this;
    if (self.fired) throw new Error("write fence already activated?");

    if (self.armed && !self.outstanding_writes) {
      function invokeCallback(func) {
        try {
          func(self);
        } catch (err) {
          Meteor._debug("exception in write fence callback", err);
        }
      }

      self.outstanding_writes++;

      while (self.before_fire_callbacks.length > 0) {
        var callbacks = self.before_fire_callbacks;
        self.before_fire_callbacks = [];

        _.each(callbacks, invokeCallback);
      }

      self.outstanding_writes--;

      if (!self.outstanding_writes) {
        self.fired = true;
        var callbacks = self.completion_callbacks;
        self.completion_callbacks = [];

        _.each(callbacks, invokeCallback);
      }
    }
  },
  // Deactivate this fence so that adding more writes has no effect.
  // The fence must have already fired.
  retire: function () {
    var self = this;
    if (!self.fired) throw new Error("Can't retire a fence that hasn't fired.");
    self.retired = true;
  }
});
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"crossbar.js":function module(){

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
// packages/ddp-server/crossbar.js                                                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                      //
// A "crossbar" is a class that provides structured notification registration.
// See _match for the definition of how a notification matches a trigger.
// All notifications and triggers must have a string key named 'collection'.
DDPServer._Crossbar = function (options) {
  var self = this;
  options = options || {};
  self.nextId = 1; // map from collection name (string) -> listener id -> object. each object has
  // keys 'trigger', 'callback'.  As a hack, the empty string means "no
  // collection".

  self.listenersByCollection = {};
  self.listenersByCollectionCount = {};
  self.factPackage = options.factPackage || "livedata";
  self.factName = options.factName || null;
};

_.extend(DDPServer._Crossbar.prototype, {
  // msg is a trigger or a notification
  _collectionForMessage: function (msg) {
    var self = this;

    if (!_.has(msg, 'collection')) {
      return '';
    } else if (typeof msg.collection === 'string') {
      if (msg.collection === '') throw Error("Message has empty collection!");
      return msg.collection;
    } else {
      throw Error("Message has non-string collection!");
    }
  },
  // Listen for notification that match 'trigger'. A notification
  // matches if it has the key-value pairs in trigger as a
  // subset. When a notification matches, call 'callback', passing
  // the actual notification.
  //
  // Returns a listen handle, which is an object with a method
  // stop(). Call stop() to stop listening.
  //
  // XXX It should be legal to call fire() from inside a listen()
  // callback?
  listen: function (trigger, callback) {
    var self = this;
    var id = self.nextId++;

    var collection = self._collectionForMessage(trigger);

    var record = {
      trigger: EJSON.clone(trigger),
      callback: callback
    };

    if (!_.has(self.listenersByCollection, collection)) {
      self.listenersByCollection[collection] = {};
      self.listenersByCollectionCount[collection] = 0;
    }

    self.listenersByCollection[collection][id] = record;
    self.listenersByCollectionCount[collection]++;

    if (self.factName && Package['facts-base']) {
      Package['facts-base'].Facts.incrementServerFact(self.factPackage, self.factName, 1);
    }

    return {
      stop: function () {
        if (self.factName && Package['facts-base']) {
          Package['facts-base'].Facts.incrementServerFact(self.factPackage, self.factName, -1);
        }

        delete self.listenersByCollection[collection][id];
        self.listenersByCollectionCount[collection]--;

        if (self.listenersByCollectionCount[collection] === 0) {
          delete self.listenersByCollection[collection];
          delete self.listenersByCollectionCount[collection];
        }
      }
    };
  },
  // Fire the provided 'notification' (an object whose attribute
  // values are all JSON-compatibile) -- inform all matching listeners
  // (registered with listen()).
  //
  // If fire() is called inside a write fence, then each of the
  // listener callbacks will be called inside the write fence as well.
  //
  // The listeners may be invoked in parallel, rather than serially.
  fire: function (notification) {
    var self = this;

    var collection = self._collectionForMessage(notification);

    if (!_.has(self.listenersByCollection, collection)) {
      return;
    }

    var listenersForCollection = self.listenersByCollection[collection];
    var callbackIds = [];

    _.each(listenersForCollection, function (l, id) {
      if (self._matches(notification, l.trigger)) {
        callbackIds.push(id);
      }
    }); // Listener callbacks can yield, so we need to first find all the ones that
    // match in a single iteration over self.listenersByCollection (which can't
    // be mutated during this iteration), and then invoke the matching
    // callbacks, checking before each call to ensure they haven't stopped.
    // Note that we don't have to check that
    // self.listenersByCollection[collection] still === listenersForCollection,
    // because the only way that stops being true is if listenersForCollection
    // first gets reduced down to the empty object (and then never gets
    // increased again).


    _.each(callbackIds, function (id) {
      if (_.has(listenersForCollection, id)) {
        listenersForCollection[id].callback(notification);
      }
    });
  },
  // A notification matches a trigger if all keys that exist in both are equal.
  //
  // Examples:
  //  N:{collection: "C"} matches T:{collection: "C"}
  //    (a non-targeted write to a collection matches a
  //     non-targeted query)
  //  N:{collection: "C", id: "X"} matches T:{collection: "C"}
  //    (a targeted write to a collection matches a non-targeted query)
  //  N:{collection: "C"} matches T:{collection: "C", id: "X"}
  //    (a non-targeted write to a collection matches a
  //     targeted query)
  //  N:{collection: "C", id: "X"} matches T:{collection: "C", id: "X"}
  //    (a targeted write to a collection matches a targeted query targeted
  //     at the same document)
  //  N:{collection: "C", id: "X"} does not match T:{collection: "C", id: "Y"}
  //    (a targeted write to a collection does not match a targeted query
  //     targeted at a different document)
  _matches: function (notification, trigger) {
    // Most notifications that use the crossbar have a string `collection` and
    // maybe an `id` that is a string or ObjectID. We're already dividing up
    // triggers by collection, but let's fast-track "nope, different ID" (and
    // avoid the overly generic EJSON.equals). This makes a noticeable
    // performance difference; see https://github.com/meteor/meteor/pull/3697
    if (typeof notification.id === 'string' && typeof trigger.id === 'string' && notification.id !== trigger.id) {
      return false;
    }

    if (notification.id instanceof MongoID.ObjectID && trigger.id instanceof MongoID.ObjectID && !notification.id.equals(trigger.id)) {
      return false;
    }

    return _.all(trigger, function (triggerValue, key) {
      return !_.has(notification, key) || EJSON.equals(triggerValue, notification[key]);
    });
  }
}); // The "invalidation crossbar" is a specific instance used by the DDP server to
// implement write fence notifications. Listener callbacks on this crossbar
// should call beginWrite on the current write fence before they return, if they
// want to delay the write fence from firing (ie, the DDP method-data-updated
// message from being sent).


DDPServer._InvalidationCrossbar = new DDPServer._Crossbar({
  factName: "invalidation-crossbar-listeners"
});
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"server_convenience.js":function module(){

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
// packages/ddp-server/server_convenience.js                                                                          //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                      //
if (process.env.DDP_DEFAULT_CONNECTION_URL) {
  __meteor_runtime_config__.DDP_DEFAULT_CONNECTION_URL = process.env.DDP_DEFAULT_CONNECTION_URL;
}

Meteor.server = new Server();

Meteor.refresh = function (notification) {
  DDPServer._InvalidationCrossbar.fire(notification);
}; // Proxy the public methods of Meteor.server so they can
// be called directly on Meteor.


_.each(['publish', 'methods', 'call', 'apply', 'onConnection', 'onMessage'], function (name) {
  Meteor[name] = _.bind(Meteor.server[name], Meteor.server);
});
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}}}}},{
  "extensions": [
    ".js",
    ".json"
  ]
});

require("/node_modules/meteor/ddp-server/stream_server.js");
require("/node_modules/meteor/ddp-server/livedata_server.js");
require("/node_modules/meteor/ddp-server/writefence.js");
require("/node_modules/meteor/ddp-server/crossbar.js");
require("/node_modules/meteor/ddp-server/server_convenience.js");

/* Exports */
Package._define("ddp-server", {
  DDPServer: DDPServer
});

})();

//# sourceURL=meteor://💻app/packages/ddp-server.js
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvZGRwLXNlcnZlci9zdHJlYW1fc2VydmVyLmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9wYWNrYWdlcy9kZHAtc2VydmVyL2xpdmVkYXRhX3NlcnZlci5qcyIsIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvZGRwLXNlcnZlci93cml0ZWZlbmNlLmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9wYWNrYWdlcy9kZHAtc2VydmVyL2Nyb3NzYmFyLmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9wYWNrYWdlcy9kZHAtc2VydmVyL3NlcnZlcl9jb252ZW5pZW5jZS5qcyJdLCJuYW1lcyI6WyJ3ZWJzb2NrZXRFeHRlbnNpb25zIiwiXyIsIm9uY2UiLCJleHRlbnNpb25zIiwid2Vic29ja2V0Q29tcHJlc3Npb25Db25maWciLCJwcm9jZXNzIiwiZW52IiwiU0VSVkVSX1dFQlNPQ0tFVF9DT01QUkVTU0lPTiIsIkpTT04iLCJwYXJzZSIsInB1c2giLCJOcG0iLCJyZXF1aXJlIiwiY29uZmlndXJlIiwicGF0aFByZWZpeCIsIl9fbWV0ZW9yX3J1bnRpbWVfY29uZmlnX18iLCJST09UX1VSTF9QQVRIX1BSRUZJWCIsIlN0cmVhbVNlcnZlciIsInNlbGYiLCJyZWdpc3RyYXRpb25fY2FsbGJhY2tzIiwib3Blbl9zb2NrZXRzIiwicHJlZml4IiwiUm91dGVQb2xpY3kiLCJkZWNsYXJlIiwic29ja2pzIiwic2VydmVyT3B0aW9ucyIsImxvZyIsImhlYXJ0YmVhdF9kZWxheSIsImRpc2Nvbm5lY3RfZGVsYXkiLCJqc2Vzc2lvbmlkIiwiVVNFX0pTRVNTSU9OSUQiLCJESVNBQkxFX1dFQlNPQ0tFVFMiLCJ3ZWJzb2NrZXQiLCJmYXllX3NlcnZlcl9vcHRpb25zIiwic2VydmVyIiwiY3JlYXRlU2VydmVyIiwiV2ViQXBwIiwiaHR0cFNlcnZlciIsInJlbW92ZUxpc3RlbmVyIiwiX3RpbWVvdXRBZGp1c3RtZW50UmVxdWVzdENhbGxiYWNrIiwiaW5zdGFsbEhhbmRsZXJzIiwiYWRkTGlzdGVuZXIiLCJfcmVkaXJlY3RXZWJzb2NrZXRFbmRwb2ludCIsIm9uIiwic29ja2V0Iiwic2V0V2Vic29ja2V0VGltZW91dCIsInRpbWVvdXQiLCJwcm90b2NvbCIsIl9zZXNzaW9uIiwicmVjdiIsImNvbm5lY3Rpb24iLCJzZXRUaW1lb3V0Iiwic2VuZCIsImRhdGEiLCJ3cml0ZSIsIndpdGhvdXQiLCJURVNUX01FVEFEQVRBIiwic3RyaW5naWZ5IiwidGVzdE1lc3NhZ2VPbkNvbm5lY3QiLCJlYWNoIiwiY2FsbGJhY2siLCJPYmplY3QiLCJhc3NpZ24iLCJwcm90b3R5cGUiLCJyZWdpc3RlciIsImFsbF9zb2NrZXRzIiwidmFsdWVzIiwiZm9yRWFjaCIsImV2ZW50Iiwib2xkSHR0cFNlcnZlckxpc3RlbmVycyIsImxpc3RlbmVycyIsInNsaWNlIiwicmVtb3ZlQWxsTGlzdGVuZXJzIiwibmV3TGlzdGVuZXIiLCJyZXF1ZXN0IiwiYXJncyIsImFyZ3VtZW50cyIsInVybCIsInBhcnNlZFVybCIsInBhdGhuYW1lIiwiZm9ybWF0Iiwib2xkTGlzdGVuZXIiLCJhcHBseSIsIl9vYmplY3RTcHJlYWQiLCJtb2R1bGUiLCJsaW5rIiwiZGVmYXVsdCIsInYiLCJERFBTZXJ2ZXIiLCJGaWJlciIsInB1YmxpY2F0aW9uU3RyYXRlZ2llcyIsIlNFUlZFUl9NRVJHRSIsInVzZUNvbGxlY3Rpb25WaWV3IiwiZG9BY2NvdW50aW5nRm9yQ29sbGVjdGlvbiIsIk5PX01FUkdFX05PX0hJU1RPUlkiLCJOT19NRVJHRSIsIlNlc3Npb25Eb2N1bWVudFZpZXciLCJleGlzdHNJbiIsIlNldCIsImRhdGFCeUtleSIsIk1hcCIsIl9TZXNzaW9uRG9jdW1lbnRWaWV3IiwiZXh0ZW5kIiwiZ2V0RmllbGRzIiwicmV0IiwicHJlY2VkZW5jZUxpc3QiLCJrZXkiLCJ2YWx1ZSIsImNsZWFyRmllbGQiLCJzdWJzY3JpcHRpb25IYW5kbGUiLCJjaGFuZ2VDb2xsZWN0b3IiLCJnZXQiLCJyZW1vdmVkVmFsdWUiLCJ1bmRlZmluZWQiLCJpIiwibGVuZ3RoIiwicHJlY2VkZW5jZSIsInNwbGljZSIsImRlbGV0ZSIsIkVKU09OIiwiZXF1YWxzIiwiY2hhbmdlRmllbGQiLCJpc0FkZCIsImNsb25lIiwiaGFzIiwic2V0IiwiZWx0IiwiZmluZCIsIlNlc3Npb25Db2xsZWN0aW9uVmlldyIsImNvbGxlY3Rpb25OYW1lIiwic2Vzc2lvbkNhbGxiYWNrcyIsImRvY3VtZW50cyIsImNhbGxiYWNrcyIsIl9TZXNzaW9uQ29sbGVjdGlvblZpZXciLCJpc0VtcHR5Iiwic2l6ZSIsImRpZmYiLCJwcmV2aW91cyIsIkRpZmZTZXF1ZW5jZSIsImRpZmZNYXBzIiwiYm90aCIsImJpbmQiLCJkaWZmRG9jdW1lbnQiLCJyaWdodE9ubHkiLCJpZCIsIm5vd0RWIiwiYWRkZWQiLCJsZWZ0T25seSIsInByZXZEViIsInJlbW92ZWQiLCJmaWVsZHMiLCJkaWZmT2JqZWN0cyIsInByZXYiLCJub3ciLCJjaGFuZ2VkIiwiZG9jVmlldyIsImFkZCIsImNoYW5nZWRSZXN1bHQiLCJFcnJvciIsImVyciIsIlNlc3Npb24iLCJ2ZXJzaW9uIiwib3B0aW9ucyIsIlJhbmRvbSIsImluaXRpYWxpemVkIiwiaW5RdWV1ZSIsIk1ldGVvciIsIl9Eb3VibGVFbmRlZFF1ZXVlIiwiYmxvY2tlZCIsIndvcmtlclJ1bm5pbmciLCJjYWNoZWRVbmJsb2NrIiwiX25hbWVkU3VicyIsIl91bml2ZXJzYWxTdWJzIiwidXNlcklkIiwiY29sbGVjdGlvblZpZXdzIiwiX2lzU2VuZGluZyIsIl9kb250U3RhcnROZXdVbml2ZXJzYWxTdWJzIiwiX3BlbmRpbmdSZWFkeSIsIl9jbG9zZUNhbGxiYWNrcyIsIl9zb2NrZXRVcmwiLCJfcmVzcG9uZFRvUGluZ3MiLCJyZXNwb25kVG9QaW5ncyIsImNvbm5lY3Rpb25IYW5kbGUiLCJjbG9zZSIsIm9uQ2xvc2UiLCJmbiIsImNiIiwiYmluZEVudmlyb25tZW50IiwiZGVmZXIiLCJjbGllbnRBZGRyZXNzIiwiX2NsaWVudEFkZHJlc3MiLCJodHRwSGVhZGVycyIsImhlYWRlcnMiLCJtc2ciLCJzZXNzaW9uIiwic3RhcnRVbml2ZXJzYWxTdWJzIiwicnVuIiwiaGVhcnRiZWF0SW50ZXJ2YWwiLCJoZWFydGJlYXQiLCJERFBDb21tb24iLCJIZWFydGJlYXQiLCJoZWFydGJlYXRUaW1lb3V0Iiwib25UaW1lb3V0Iiwic2VuZFBpbmciLCJzdGFydCIsIlBhY2thZ2UiLCJGYWN0cyIsImluY3JlbWVudFNlcnZlckZhY3QiLCJzZW5kUmVhZHkiLCJzdWJzY3JpcHRpb25JZHMiLCJzdWJzIiwic3Vic2NyaXB0aW9uSWQiLCJfY2FuU2VuZCIsImdldFB1YmxpY2F0aW9uU3RyYXRlZ3kiLCJzZW5kQWRkZWQiLCJjb2xsZWN0aW9uIiwic2VuZENoYW5nZWQiLCJzZW5kUmVtb3ZlZCIsImdldFNlbmRDYWxsYmFja3MiLCJnZXRDb2xsZWN0aW9uVmlldyIsInZpZXciLCJoYW5kbGVycyIsInVuaXZlcnNhbF9wdWJsaXNoX2hhbmRsZXJzIiwiaGFuZGxlciIsIl9zdGFydFN1YnNjcmlwdGlvbiIsInN0b3AiLCJfbWV0ZW9yU2Vzc2lvbiIsIl9kZWFjdGl2YXRlQWxsU3Vic2NyaXB0aW9ucyIsIl9yZW1vdmVTZXNzaW9uIiwiX3ByaW50U2VudEREUCIsIl9kZWJ1ZyIsInN0cmluZ2lmeUREUCIsInNlbmRFcnJvciIsInJlYXNvbiIsIm9mZmVuZGluZ01lc3NhZ2UiLCJwcm9jZXNzTWVzc2FnZSIsIm1zZ19pbiIsIm1lc3NhZ2VSZWNlaXZlZCIsInByb2Nlc3NOZXh0Iiwic2hpZnQiLCJ1bmJsb2NrIiwib25NZXNzYWdlSG9vayIsInByb3RvY29sX2hhbmRsZXJzIiwiY2FsbCIsInN1YiIsIm5hbWUiLCJwYXJhbXMiLCJBcnJheSIsInB1Ymxpc2hfaGFuZGxlcnMiLCJlcnJvciIsIkREUFJhdGVMaW1pdGVyIiwicmF0ZUxpbWl0ZXJJbnB1dCIsInR5cGUiLCJjb25uZWN0aW9uSWQiLCJfaW5jcmVtZW50IiwicmF0ZUxpbWl0UmVzdWx0IiwiX2NoZWNrIiwiYWxsb3dlZCIsImdldEVycm9yTWVzc2FnZSIsInRpbWVUb1Jlc2V0IiwidW5zdWIiLCJfc3RvcFN1YnNjcmlwdGlvbiIsIm1ldGhvZCIsInJhbmRvbVNlZWQiLCJmZW5jZSIsIl9Xcml0ZUZlbmNlIiwib25BbGxDb21taXR0ZWQiLCJyZXRpcmUiLCJtZXRob2RzIiwibWV0aG9kX2hhbmRsZXJzIiwiYXJtIiwic2V0VXNlcklkIiwiX3NldFVzZXJJZCIsImludm9jYXRpb24iLCJNZXRob2RJbnZvY2F0aW9uIiwiaXNTaW11bGF0aW9uIiwicHJvbWlzZSIsIlByb21pc2UiLCJyZXNvbHZlIiwicmVqZWN0IiwiX0N1cnJlbnRXcml0ZUZlbmNlIiwid2l0aFZhbHVlIiwiRERQIiwiX0N1cnJlbnRNZXRob2RJbnZvY2F0aW9uIiwibWF5YmVBdWRpdEFyZ3VtZW50Q2hlY2tzIiwiZmluaXNoIiwicGF5bG9hZCIsInRoZW4iLCJyZXN1bHQiLCJleGNlcHRpb24iLCJ3cmFwSW50ZXJuYWxFeGNlcHRpb24iLCJfZWFjaFN1YiIsImYiLCJfZGlmZkNvbGxlY3Rpb25WaWV3cyIsImJlZm9yZUNWcyIsImxlZnRWYWx1ZSIsInJpZ2h0VmFsdWUiLCJkb2MiLCJfZGVhY3RpdmF0ZSIsIm9sZE5hbWVkU3VicyIsIm5ld1N1YiIsIl9yZWNyZWF0ZSIsIl9ydW5IYW5kbGVyIiwiX25vWWllbGRzQWxsb3dlZCIsInN1YklkIiwiU3Vic2NyaXB0aW9uIiwidW5ibG9ja0hhbmRlciIsInN1Yk5hbWUiLCJtYXliZVN1YiIsIl9uYW1lIiwiX3JlbW92ZUFsbERvY3VtZW50cyIsInJlc3BvbnNlIiwiaHR0cEZvcndhcmRlZENvdW50IiwicGFyc2VJbnQiLCJyZW1vdGVBZGRyZXNzIiwiZm9yd2FyZGVkRm9yIiwiaXNTdHJpbmciLCJ0cmltIiwic3BsaXQiLCJfaGFuZGxlciIsIl9zdWJzY3JpcHRpb25JZCIsIl9wYXJhbXMiLCJfc3Vic2NyaXB0aW9uSGFuZGxlIiwiX2RlYWN0aXZhdGVkIiwiX3N0b3BDYWxsYmFja3MiLCJfZG9jdW1lbnRzIiwiX3JlYWR5IiwiX2lkRmlsdGVyIiwiaWRTdHJpbmdpZnkiLCJNb25nb0lEIiwiaWRQYXJzZSIsInJlc3VsdE9yVGhlbmFibGUiLCJfQ3VycmVudFB1YmxpY2F0aW9uSW52b2NhdGlvbiIsImUiLCJfaXNEZWFjdGl2YXRlZCIsImlzVGhlbmFibGUiLCJfcHVibGlzaEhhbmRsZXJSZXN1bHQiLCJyZXMiLCJpc0N1cnNvciIsImMiLCJfcHVibGlzaEN1cnNvciIsInJlYWR5IiwiaXNBcnJheSIsImFsbCIsImNvbGxlY3Rpb25OYW1lcyIsIl9nZXRDb2xsZWN0aW9uTmFtZSIsImN1ciIsIl9jYWxsU3RvcENhbGxiYWNrcyIsImNvbGxlY3Rpb25Eb2NzIiwic3RySWQiLCJvblN0b3AiLCJpZHMiLCJTZXJ2ZXIiLCJkZWZhdWx0UHVibGljYXRpb25TdHJhdGVneSIsIm9uQ29ubmVjdGlvbkhvb2siLCJIb29rIiwiZGVidWdQcmludEV4Y2VwdGlvbnMiLCJfcHVibGljYXRpb25TdHJhdGVnaWVzIiwic2Vzc2lvbnMiLCJzdHJlYW1fc2VydmVyIiwicmF3X21zZyIsIl9wcmludFJlY2VpdmVkRERQIiwicGFyc2VERFAiLCJfaGFuZGxlQ29ubmVjdCIsIm9uQ29ubmVjdGlvbiIsInNldFB1YmxpY2F0aW9uU3RyYXRlZ3kiLCJwdWJsaWNhdGlvbk5hbWUiLCJzdHJhdGVneSIsImluY2x1ZGVzIiwib25NZXNzYWdlIiwic3VwcG9ydCIsImNvbnRhaW5zIiwiU1VQUE9SVEVEX0REUF9WRVJTSU9OUyIsImNhbGN1bGF0ZVZlcnNpb24iLCJwdWJsaXNoIiwiaXNPYmplY3QiLCJhdXRvcHVibGlzaCIsImlzX2F1dG8iLCJ3YXJuZWRfYWJvdXRfYXV0b3B1Ymxpc2giLCJmdW5jIiwicG9wIiwiY2FsbEFzeW5jIiwiYXBwbHlBc3luYyIsImF3YWl0IiwiY3VycmVudE1ldGhvZEludm9jYXRpb24iLCJjdXJyZW50UHVibGljYXRpb25JbnZvY2F0aW9uIiwibWFrZVJwY1NlZWQiLCJfdXJsRm9yU2Vzc2lvbiIsInNlc3Npb25JZCIsImNsaWVudFN1cHBvcnRlZFZlcnNpb25zIiwic2VydmVyU3VwcG9ydGVkVmVyc2lvbnMiLCJjb3JyZWN0VmVyc2lvbiIsIl9jYWxjdWxhdGVWZXJzaW9uIiwiY29udGV4dCIsImlzQ2xpZW50U2FmZSIsIm9yaWdpbmFsTWVzc2FnZSIsIm1lc3NhZ2UiLCJkZXRhaWxzIiwiX2V4cGVjdGVkQnlUZXN0Iiwic3RhY2siLCJzYW5pdGl6ZWRFcnJvciIsImRlc2NyaXB0aW9uIiwiTWF0Y2giLCJfZmFpbElmQXJndW1lbnRzQXJlTm90QWxsQ2hlY2tlZCIsIkZ1dHVyZSIsImFybWVkIiwiZmlyZWQiLCJyZXRpcmVkIiwib3V0c3RhbmRpbmdfd3JpdGVzIiwiYmVmb3JlX2ZpcmVfY2FsbGJhY2tzIiwiY29tcGxldGlvbl9jYWxsYmFja3MiLCJFbnZpcm9ubWVudFZhcmlhYmxlIiwiYmVnaW5Xcml0ZSIsImNvbW1pdHRlZCIsIl9tYXliZUZpcmUiLCJvbkJlZm9yZUZpcmUiLCJhcm1BbmRXYWl0IiwiZnV0dXJlIiwid2FpdCIsImludm9rZUNhbGxiYWNrIiwiX0Nyb3NzYmFyIiwibmV4dElkIiwibGlzdGVuZXJzQnlDb2xsZWN0aW9uIiwibGlzdGVuZXJzQnlDb2xsZWN0aW9uQ291bnQiLCJmYWN0UGFja2FnZSIsImZhY3ROYW1lIiwiX2NvbGxlY3Rpb25Gb3JNZXNzYWdlIiwibGlzdGVuIiwidHJpZ2dlciIsInJlY29yZCIsImZpcmUiLCJub3RpZmljYXRpb24iLCJsaXN0ZW5lcnNGb3JDb2xsZWN0aW9uIiwiY2FsbGJhY2tJZHMiLCJsIiwiX21hdGNoZXMiLCJPYmplY3RJRCIsInRyaWdnZXJWYWx1ZSIsIl9JbnZhbGlkYXRpb25Dcm9zc2JhciIsIkREUF9ERUZBVUxUX0NPTk5FQ1RJT05fVVJMIiwicmVmcmVzaCJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7O0FBQUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFD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R0FBa0MsSUFBSTlWLFNBQVMsQ0FBQzRVLFNBQWQsQ0FBd0I7QUFDeERLLFVBQVEsRUFBRTtBQUQ4QyxDQUF4QixDQUFsQyxDOzs7Ozs7Ozs7OztBQ3BLQSxJQUFJcGEsT0FBTyxDQUFDQyxHQUFSLENBQVlpYiwwQkFBaEIsRUFBNEM7QUFDMUN4YSwyQkFBeUIsQ0FBQ3dhLDBCQUExQixHQUNFbGIsT0FBTyxDQUFDQyxHQUFSLENBQVlpYiwwQkFEZDtBQUVEOztBQUVEalIsTUFBTSxDQUFDcEksTUFBUCxHQUFnQixJQUFJOFQsTUFBSixFQUFoQjs7QUFFQTFMLE1BQU0sQ0FBQ2tSLE9BQVAsR0FBaUIsVUFBVVQsWUFBVixFQUF3QjtBQUN2Q3ZWLFdBQVMsQ0FBQzhWLHFCQUFWLENBQWdDUixJQUFoQyxDQUFxQ0MsWUFBckM7QUFDRCxDQUZELEMsQ0FJQTtBQUNBOzs7QUFDQTlhLENBQUMsQ0FBQzBELElBQUYsQ0FBTyxDQUFDLFNBQUQsRUFBWSxTQUFaLEVBQXVCLE1BQXZCLEVBQStCLE9BQS9CLEVBQXdDLGNBQXhDLEVBQXdELFdBQXhELENBQVAsRUFDTyxVQUFVMEwsSUFBVixFQUFnQjtBQUNkL0UsUUFBTSxDQUFDK0UsSUFBRCxDQUFOLEdBQWVwUCxDQUFDLENBQUM0SSxJQUFGLENBQU95QixNQUFNLENBQUNwSSxNQUFQLENBQWNtTixJQUFkLENBQVAsRUFBNEIvRSxNQUFNLENBQUNwSSxNQUFuQyxDQUFmO0FBQ0QsQ0FIUixFIiwiZmlsZSI6Ii9wYWNrYWdlcy9kZHAtc2VydmVyLmpzIiwic291cmNlc0NvbnRlbnQiOlsiLy8gQnkgZGVmYXVsdCwgd2UgdXNlIHRoZSBwZXJtZXNzYWdlLWRlZmxhdGUgZXh0ZW5zaW9uIHdpdGggZGVmYXVsdFxuLy8gY29uZmlndXJhdGlvbi4gSWYgJFNFUlZFUl9XRUJTT0NLRVRfQ09NUFJFU1NJT04gaXMgc2V0LCB0aGVuIGl0IG11c3QgYmUgdmFsaWRcbi8vIEpTT04uIElmIGl0IHJlcHJlc2VudHMgYSBmYWxzZXkgdmFsdWUsIHRoZW4gd2UgZG8gbm90IHVzZSBwZXJtZXNzYWdlLWRlZmxhdGVcbi8vIGF0IGFsbDsgb3RoZXJ3aXNlLCB0aGUgSlNPTiB2YWx1ZSBpcyB1c2VkIGFzIGFuIGFyZ3VtZW50IHRvIGRlZmxhdGUnc1xuLy8gY29uZmlndXJlIG1ldGhvZDsgc2VlXG4vLyBodHRwczovL2dpdGh1Yi5jb20vZmF5ZS9wZXJtZXNzYWdlLWRlZmxhdGUtbm9kZS9ibG9iL21hc3Rlci9SRUFETUUubWRcbi8vXG4vLyAoV2UgZG8gdGhpcyBpbiBhbiBfLm9uY2UgaW5zdGVhZCBvZiBhdCBzdGFydHVwLCBiZWNhdXNlIHdlIGRvbid0IHdhbnQgdG9cbi8vIGNyYXNoIHRoZSB0b29sIGR1cmluZyBpc29wYWNrZXQgbG9hZCBpZiB5b3VyIEpTT04gZG9lc24ndCBwYXJzZS4gVGhpcyBpcyBvbmx5XG4vLyBhIHByb2JsZW0gYmVjYXVzZSB0aGUgdG9vbCBoYXMgdG8gbG9hZCB0aGUgRERQIHNlcnZlciBjb2RlIGp1c3QgaW4gb3JkZXIgdG9cbi8vIGJlIGEgRERQIGNsaWVudDsgc2VlIGh0dHBzOi8vZ2l0aHViLmNvbS9tZXRlb3IvbWV0ZW9yL2lzc3Vlcy8zNDUyIC4pXG52YXIgd2Vic29ja2V0RXh0ZW5zaW9ucyA9IF8ub25jZShmdW5jdGlvbiAoKSB7XG4gIHZhciBleHRlbnNpb25zID0gW107XG5cbiAgdmFyIHdlYnNvY2tldENvbXByZXNzaW9uQ29uZmlnID0gcHJvY2Vzcy5lbnYuU0VSVkVSX1dFQlNPQ0tFVF9DT01QUkVTU0lPTlxuICAgICAgICA/IEpTT04ucGFyc2UocHJvY2Vzcy5lbnYuU0VSVkVSX1dFQlNPQ0tFVF9DT01QUkVTU0lPTikgOiB7fTtcbiAgaWYgKHdlYnNvY2tldENvbXByZXNzaW9uQ29uZmlnKSB7XG4gICAgZXh0ZW5zaW9ucy5wdXNoKE5wbS5yZXF1aXJlKCdwZXJtZXNzYWdlLWRlZmxhdGUnKS5jb25maWd1cmUoXG4gICAgICB3ZWJzb2NrZXRDb21wcmVzc2lvbkNvbmZpZ1xuICAgICkpO1xuICB9XG5cbiAgcmV0dXJuIGV4dGVuc2lvbnM7XG59KTtcblxudmFyIHBhdGhQcmVmaXggPSBfX21ldGVvcl9ydW50aW1lX2NvbmZpZ19fLlJPT1RfVVJMX1BBVEhfUFJFRklYIHx8ICBcIlwiO1xuXG5TdHJlYW1TZXJ2ZXIgPSBmdW5jdGlvbiAoKSB7XG4gIHZhciBzZWxmID0gdGhpcztcbiAgc2VsZi5yZWdpc3RyYXRpb25fY2FsbGJhY2tzID0gW107XG4gIHNlbGYub3Blbl9zb2NrZXRzID0gW107XG5cbiAgLy8gQmVjYXVzZSB3ZSBhcmUgaW5zdGFsbGluZyBkaXJlY3RseSBvbnRvIFdlYkFwcC5odHRwU2VydmVyIGluc3RlYWQgb2YgdXNpbmdcbiAgLy8gV2ViQXBwLmFwcCwgd2UgaGF2ZSB0byBwcm9jZXNzIHRoZSBwYXRoIHByZWZpeCBvdXJzZWx2ZXMuXG4gIHNlbGYucHJlZml4ID0gcGF0aFByZWZpeCArICcvc29ja2pzJztcbiAgUm91dGVQb2xpY3kuZGVjbGFyZShzZWxmLnByZWZpeCArICcvJywgJ25ldHdvcmsnKTtcblxuICAvLyBzZXQgdXAgc29ja2pzXG4gIHZhciBzb2NranMgPSBOcG0ucmVxdWlyZSgnc29ja2pzJyk7XG4gIHZhciBzZXJ2ZXJPcHRpb25zID0ge1xuICAgIHByZWZpeDogc2VsZi5wcmVmaXgsXG4gICAgbG9nOiBmdW5jdGlvbigpIHt9LFxuICAgIC8vIHRoaXMgaXMgdGhlIGRlZmF1bHQsIGJ1dCB3ZSBjb2RlIGl0IGV4cGxpY2l0bHkgYmVjYXVzZSB3ZSBkZXBlbmRcbiAgICAvLyBvbiBpdCBpbiBzdHJlYW1fY2xpZW50OkhFQVJUQkVBVF9USU1FT1VUXG4gICAgaGVhcnRiZWF0X2RlbGF5OiA0NTAwMCxcbiAgICAvLyBUaGUgZGVmYXVsdCBkaXNjb25uZWN0X2RlbGF5IGlzIDUgc2Vjb25kcywgYnV0IGlmIHRoZSBzZXJ2ZXIgZW5kcyB1cCBDUFVcbiAgICAvLyBib3VuZCBmb3IgdGhhdCBtdWNoIHRpbWUsIFNvY2tKUyBtaWdodCBub3Qgbm90aWNlIHRoYXQgdGhlIHVzZXIgaGFzXG4gICAgLy8gcmVjb25uZWN0ZWQgYmVjYXVzZSB0aGUgdGltZXIgKG9mIGRpc2Nvbm5lY3RfZGVsYXkgbXMpIGNhbiBmaXJlIGJlZm9yZVxuICAgIC8vIFNvY2tKUyBwcm9jZXNzZXMgdGhlIG5ldyBjb25uZWN0aW9uLiBFdmVudHVhbGx5IHdlJ2xsIGZpeCB0aGlzIGJ5IG5vdFxuICAgIC8vIGNvbWJpbmluZyBDUFUtaGVhdnkgcHJvY2Vzc2luZyB3aXRoIFNvY2tKUyB0ZXJtaW5hdGlvbiAoZWcgYSBwcm94eSB3aGljaFxuICAgIC8vIGNvbnZlcnRzIHRvIFVuaXggc29ja2V0cykgYnV0IGZvciBub3csIHJhaXNlIHRoZSBkZWxheS5cbiAgICBkaXNjb25uZWN0X2RlbGF5OiA2MCAqIDEwMDAsXG4gICAgLy8gU2V0IHRoZSBVU0VfSlNFU1NJT05JRCBlbnZpcm9ubWVudCB2YXJpYWJsZSB0byBlbmFibGUgc2V0dGluZyB0aGVcbiAgICAvLyBKU0VTU0lPTklEIGNvb2tpZS4gVGhpcyBpcyB1c2VmdWwgZm9yIHNldHRpbmcgdXAgcHJveGllcyB3aXRoXG4gICAgLy8gc2Vzc2lvbiBhZmZpbml0eS5cbiAgICBqc2Vzc2lvbmlkOiAhIXByb2Nlc3MuZW52LlVTRV9KU0VTU0lPTklEXG4gIH07XG5cbiAgLy8gSWYgeW91IGtub3cgeW91ciBzZXJ2ZXIgZW52aXJvbm1lbnQgKGVnLCBwcm94aWVzKSB3aWxsIHByZXZlbnQgd2Vic29ja2V0c1xuICAvLyBmcm9tIGV2ZXIgd29ya2luZywgc2V0ICRESVNBQkxFX1dFQlNPQ0tFVFMgYW5kIFNvY2tKUyBjbGllbnRzIChpZSxcbiAgLy8gYnJvd3NlcnMpIHdpbGwgbm90IHdhc3RlIHRpbWUgYXR0ZW1wdGluZyB0byB1c2UgdGhlbS5cbiAgLy8gKFlvdXIgc2VydmVyIHdpbGwgc3RpbGwgaGF2ZSBhIC93ZWJzb2NrZXQgZW5kcG9pbnQuKVxuICBpZiAocHJvY2Vzcy5lbnYuRElTQUJMRV9XRUJTT0NLRVRTKSB7XG4gICAgc2VydmVyT3B0aW9ucy53ZWJzb2NrZXQgPSBmYWxzZTtcbiAgfSBlbHNlIHtcbiAgICBzZXJ2ZXJPcHRpb25zLmZheWVfc2VydmVyX29wdGlvbnMgPSB7XG4gICAgICBleHRlbnNpb25zOiB3ZWJzb2NrZXRFeHRlbnNpb25zKClcbiAgICB9O1xuICB9XG5cbiAgc2VsZi5zZXJ2ZXIgPSBzb2NranMuY3JlYXRlU2VydmVyKHNlcnZlck9wdGlvbnMpO1xuXG4gIC8vIEluc3RhbGwgdGhlIHNvY2tqcyBoYW5kbGVycywgYnV0IHdlIHdhbnQgdG8ga2VlcCBhcm91bmQgb3VyIG93biBwYXJ0aWN1bGFyXG4gIC8vIHJlcXVlc3QgaGFuZGxlciB0aGF0IGFkanVzdHMgaWRsZSB0aW1lb3V0cyB3aGlsZSB3ZSBoYXZlIGFuIG91dHN0YW5kaW5nXG4gIC8vIHJlcXVlc3QuICBUaGlzIGNvbXBlbnNhdGVzIGZvciB0aGUgZmFjdCB0aGF0IHNvY2tqcyByZW1vdmVzIGFsbCBsaXN0ZW5lcnNcbiAgLy8gZm9yIFwicmVxdWVzdFwiIHRvIGFkZCBpdHMgb3duLlxuICBXZWJBcHAuaHR0cFNlcnZlci5yZW1vdmVMaXN0ZW5lcihcbiAgICAncmVxdWVzdCcsIFdlYkFwcC5fdGltZW91dEFkanVzdG1lbnRSZXF1ZXN0Q2FsbGJhY2spO1xuICBzZWxmLnNlcnZlci5pbnN0YWxsSGFuZGxlcnMoV2ViQXBwLmh0dHBTZXJ2ZXIpO1xuICBXZWJBcHAuaHR0cFNlcnZlci5hZGRMaXN0ZW5lcihcbiAgICAncmVxdWVzdCcsIFdlYkFwcC5fdGltZW91dEFkanVzdG1lbnRSZXF1ZXN0Q2FsbGJhY2spO1xuXG4gIC8vIFN1cHBvcnQgdGhlIC93ZWJzb2NrZXQgZW5kcG9pbnRcbiAgc2VsZi5fcmVkaXJlY3RXZWJzb2NrZXRFbmRwb2ludCgpO1xuXG4gIHNlbGYuc2VydmVyLm9uKCdjb25uZWN0aW9uJywgZnVuY3Rpb24gKHNvY2tldCkge1xuICAgIC8vIHNvY2tqcyBzb21ldGltZXMgcGFzc2VzIHVzIG51bGwgaW5zdGVhZCBvZiBhIHNvY2tldCBvYmplY3RcbiAgICAvLyBzbyB3ZSBuZWVkIHRvIGd1YXJkIGFnYWluc3QgdGhhdC4gc2VlOlxuICAgIC8vIGh0dHBzOi8vZ2l0aHViLmNvbS9zb2NranMvc29ja2pzLW5vZGUvaXNzdWVzLzEyMVxuICAgIC8vIGh0dHBzOi8vZ2l0aHViLmNvbS9tZXRlb3IvbWV0ZW9yL2lzc3Vlcy8xMDQ2OFxuICAgIGlmICghc29ja2V0KSByZXR1cm47XG5cbiAgICAvLyBXZSB3YW50IHRvIG1ha2Ugc3VyZSB0aGF0IGlmIGEgY2xpZW50IGNvbm5lY3RzIHRvIHVzIGFuZCBkb2VzIHRoZSBpbml0aWFsXG4gICAgLy8gV2Vic29ja2V0IGhhbmRzaGFrZSBidXQgbmV2ZXIgZ2V0cyB0byB0aGUgRERQIGhhbmRzaGFrZSwgdGhhdCB3ZVxuICAgIC8vIGV2ZW50dWFsbHkga2lsbCB0aGUgc29ja2V0LiAgT25jZSB0aGUgRERQIGhhbmRzaGFrZSBoYXBwZW5zLCBERFBcbiAgICAvLyBoZWFydGJlYXRpbmcgd2lsbCB3b3JrLiBBbmQgYmVmb3JlIHRoZSBXZWJzb2NrZXQgaGFuZHNoYWtlLCB0aGUgdGltZW91dHNcbiAgICAvLyB3ZSBzZXQgYXQgdGhlIHNlcnZlciBsZXZlbCBpbiB3ZWJhcHBfc2VydmVyLmpzIHdpbGwgd29yay4gQnV0XG4gICAgLy8gZmF5ZS13ZWJzb2NrZXQgY2FsbHMgc2V0VGltZW91dCgwKSBvbiBhbnkgc29ja2V0IGl0IHRha2VzIG92ZXIsIHNvIHRoZXJlXG4gICAgLy8gaXMgYW4gXCJpbiBiZXR3ZWVuXCIgc3RhdGUgd2hlcmUgdGhpcyBkb2Vzbid0IGhhcHBlbi4gIFdlIHdvcmsgYXJvdW5kIHRoaXNcbiAgICAvLyBieSBleHBsaWNpdGx5IHNldHRpbmcgdGhlIHNvY2tldCB0aW1lb3V0IHRvIGEgcmVsYXRpdmVseSBsYXJnZSB0aW1lIGhlcmUsXG4gICAgLy8gYW5kIHNldHRpbmcgaXQgYmFjayB0byB6ZXJvIHdoZW4gd2Ugc2V0IHVwIHRoZSBoZWFydGJlYXQgaW5cbiAgICAvLyBsaXZlZGF0YV9zZXJ2ZXIuanMuXG4gICAgc29ja2V0LnNldFdlYnNvY2tldFRpbWVvdXQgPSBmdW5jdGlvbiAodGltZW91dCkge1xuICAgICAgaWYgKChzb2NrZXQucHJvdG9jb2wgPT09ICd3ZWJzb2NrZXQnIHx8XG4gICAgICAgICAgIHNvY2tldC5wcm90b2NvbCA9PT0gJ3dlYnNvY2tldC1yYXcnKVxuICAgICAgICAgICYmIHNvY2tldC5fc2Vzc2lvbi5yZWN2KSB7XG4gICAgICAgIHNvY2tldC5fc2Vzc2lvbi5yZWN2LmNvbm5lY3Rpb24uc2V0VGltZW91dCh0aW1lb3V0KTtcbiAgICAgIH1cbiAgICB9O1xuICAgIHNvY2tldC5zZXRXZWJzb2NrZXRUaW1lb3V0KDQ1ICogMTAwMCk7XG5cbiAgICBzb2NrZXQuc2VuZCA9IGZ1bmN0aW9uIChkYXRhKSB7XG4gICAgICBzb2NrZXQud3JpdGUoZGF0YSk7XG4gICAgfTtcbiAgICBzb2NrZXQub24oJ2Nsb3NlJywgZnVuY3Rpb24gKCkge1xuICAgICAgc2VsZi5vcGVuX3NvY2tldHMgPSBfLndpdGhvdXQoc2VsZi5vcGVuX3NvY2tldHMsIHNvY2tldCk7XG4gICAgfSk7XG4gICAgc2VsZi5vcGVuX3NvY2tldHMucHVzaChzb2NrZXQpO1xuXG4gICAgLy8gb25seSB0byBzZW5kIGEgbWVzc2FnZSBhZnRlciBjb25uZWN0aW9uIG9uIHRlc3RzLCB1c2VmdWwgZm9yXG4gICAgLy8gc29ja2V0LXN0cmVhbS1jbGllbnQvc2VydmVyLXRlc3RzLmpzXG4gICAgaWYgKHByb2Nlc3MuZW52LlRFU1RfTUVUQURBVEEgJiYgcHJvY2Vzcy5lbnYuVEVTVF9NRVRBREFUQSAhPT0gXCJ7fVwiKSB7XG4gICAgICBzb2NrZXQuc2VuZChKU09OLnN0cmluZ2lmeSh7IHRlc3RNZXNzYWdlT25Db25uZWN0OiB0cnVlIH0pKTtcbiAgICB9XG5cbiAgICAvLyBjYWxsIGFsbCBvdXIgY2FsbGJhY2tzIHdoZW4gd2UgZ2V0IGEgbmV3IHNvY2tldC4gdGhleSB3aWxsIGRvIHRoZVxuICAgIC8vIHdvcmsgb2Ygc2V0dGluZyB1cCBoYW5kbGVycyBhbmQgc3VjaCBmb3Igc3BlY2lmaWMgbWVzc2FnZXMuXG4gICAgXy5lYWNoKHNlbGYucmVnaXN0cmF0aW9uX2NhbGxiYWNrcywgZnVuY3Rpb24gKGNhbGxiYWNrKSB7XG4gICAgICBjYWxsYmFjayhzb2NrZXQpO1xuICAgIH0pO1xuICB9KTtcblxufTtcblxuT2JqZWN0LmFzc2lnbihTdHJlYW1TZXJ2ZXIucHJvdG90eXBlLCB7XG4gIC8vIGNhbGwgbXkgY2FsbGJhY2sgd2hlbiBhIG5ldyBzb2NrZXQgY29ubmVjdHMuXG4gIC8vIGFsc28gY2FsbCBpdCBmb3IgYWxsIGN1cnJlbnQgY29ubmVjdGlvbnMuXG4gIHJlZ2lzdGVyOiBmdW5jdGlvbiAoY2FsbGJhY2spIHtcbiAgICB2YXIgc2VsZiA9IHRoaXM7XG4gICAgc2VsZi5yZWdpc3RyYXRpb25fY2FsbGJhY2tzLnB1c2goY2FsbGJhY2spO1xuICAgIF8uZWFjaChzZWxmLmFsbF9zb2NrZXRzKCksIGZ1bmN0aW9uIChzb2NrZXQpIHtcbiAgICAgIGNhbGxiYWNrKHNvY2tldCk7XG4gICAgfSk7XG4gIH0sXG5cbiAgLy8gZ2V0IGEgbGlzdCBvZiBhbGwgc29ja2V0c1xuICBhbGxfc29ja2V0czogZnVuY3Rpb24gKCkge1xuICAgIHZhciBzZWxmID0gdGhpcztcbiAgICByZXR1cm4gXy52YWx1ZXMoc2VsZi5vcGVuX3NvY2tldHMpO1xuICB9LFxuXG4gIC8vIFJlZGlyZWN0IC93ZWJzb2NrZXQgdG8gL3NvY2tqcy93ZWJzb2NrZXQgaW4gb3JkZXIgdG8gbm90IGV4cG9zZVxuICAvLyBzb2NranMgdG8gY2xpZW50cyB0aGF0IHdhbnQgdG8gdXNlIHJhdyB3ZWJzb2NrZXRzXG4gIF9yZWRpcmVjdFdlYnNvY2tldEVuZHBvaW50OiBmdW5jdGlvbigpIHtcbiAgICB2YXIgc2VsZiA9IHRoaXM7XG4gICAgLy8gVW5mb3J0dW5hdGVseSB3ZSBjYW4ndCB1c2UgYSBjb25uZWN0IG1pZGRsZXdhcmUgaGVyZSBzaW5jZVxuICAgIC8vIHNvY2tqcyBpbnN0YWxscyBpdHNlbGYgcHJpb3IgdG8gYWxsIGV4aXN0aW5nIGxpc3RlbmVyc1xuICAgIC8vIChtZWFuaW5nIHByaW9yIHRvIGFueSBjb25uZWN0IG1pZGRsZXdhcmVzKSBzbyB3ZSBuZWVkIHRvIHRha2VcbiAgICAvLyBhbiBhcHByb2FjaCBzaW1pbGFyIHRvIG92ZXJzaGFkb3dMaXN0ZW5lcnMgaW5cbiAgICAvLyBodHRwczovL2dpdGh1Yi5jb20vc29ja2pzL3NvY2tqcy1ub2RlL2Jsb2IvY2Y4MjBjNTVhZjZhOTk1M2UxNjU1ODU1NWEzMWRlY2VhNTU0ZjcwZS9zcmMvdXRpbHMuY29mZmVlXG4gICAgWydyZXF1ZXN0JywgJ3VwZ3JhZGUnXS5mb3JFYWNoKChldmVudCkgPT4ge1xuICAgICAgdmFyIGh0dHBTZXJ2ZXIgPSBXZWJBcHAuaHR0cFNlcnZlcjtcbiAgICAgIHZhciBvbGRIdHRwU2VydmVyTGlzdGVuZXJzID0gaHR0cFNlcnZlci5saXN0ZW5lcnMoZXZlbnQpLnNsaWNlKDApO1xuICAgICAgaHR0cFNlcnZlci5yZW1vdmVBbGxMaXN0ZW5lcnMoZXZlbnQpO1xuXG4gICAgICAvLyByZXF1ZXN0IGFuZCB1cGdyYWRlIGhhdmUgZGlmZmVyZW50IGFyZ3VtZW50cyBwYXNzZWQgYnV0XG4gICAgICAvLyB3ZSBvbmx5IGNhcmUgYWJvdXQgdGhlIGZpcnN0IG9uZSB3aGljaCBpcyBhbHdheXMgcmVxdWVzdFxuICAgICAgdmFyIG5ld0xpc3RlbmVyID0gZnVuY3Rpb24ocmVxdWVzdCAvKiwgbW9yZUFyZ3VtZW50cyAqLykge1xuICAgICAgICAvLyBTdG9yZSBhcmd1bWVudHMgZm9yIHVzZSB3aXRoaW4gdGhlIGNsb3N1cmUgYmVsb3dcbiAgICAgICAgdmFyIGFyZ3MgPSBhcmd1bWVudHM7XG5cbiAgICAgICAgLy8gVE9ETyByZXBsYWNlIHdpdGggdXJsIHBhY2thZ2VcbiAgICAgICAgdmFyIHVybCA9IE5wbS5yZXF1aXJlKCd1cmwnKTtcblxuICAgICAgICAvLyBSZXdyaXRlIC93ZWJzb2NrZXQgYW5kIC93ZWJzb2NrZXQvIHVybHMgdG8gL3NvY2tqcy93ZWJzb2NrZXQgd2hpbGVcbiAgICAgICAgLy8gcHJlc2VydmluZyBxdWVyeSBzdHJpbmcuXG4gICAgICAgIHZhciBwYXJzZWRVcmwgPSB1cmwucGFyc2UocmVxdWVzdC51cmwpO1xuICAgICAgICBpZiAocGFyc2VkVXJsLnBhdGhuYW1lID09PSBwYXRoUHJlZml4ICsgJy93ZWJzb2NrZXQnIHx8XG4gICAgICAgICAgICBwYXJzZWRVcmwucGF0aG5hbWUgPT09IHBhdGhQcmVmaXggKyAnL3dlYnNvY2tldC8nKSB7XG4gICAgICAgICAgcGFyc2VkVXJsLnBhdGhuYW1lID0gc2VsZi5wcmVmaXggKyAnL3dlYnNvY2tldCc7XG4gICAgICAgICAgcmVxdWVzdC51cmwgPSB1cmwuZm9ybWF0KHBhcnNlZFVybCk7XG4gICAgICAgIH1cbiAgICAgICAgXy5lYWNoKG9sZEh0dHBTZXJ2ZXJMaXN0ZW5lcnMsIGZ1bmN0aW9uKG9sZExpc3RlbmVyKSB7XG4gICAgICAgICAgb2xkTGlzdGVuZXIuYXBwbHkoaHR0cFNlcnZlciwgYXJncyk7XG4gICAgICAgIH0pO1xuICAgICAgfTtcbiAgICAgIGh0dHBTZXJ2ZXIuYWRkTGlzdGVuZXIoZXZlbnQsIG5ld0xpc3RlbmVyKTtcbiAgICB9KTtcbiAgfVxufSk7XG4iLCJERFBTZXJ2ZXIgPSB7fTtcblxudmFyIEZpYmVyID0gTnBtLnJlcXVpcmUoJ2ZpYmVycycpO1xuXG4vLyBQdWJsaWNhdGlvbiBzdHJhdGVnaWVzIGRlZmluZSBob3cgd2UgaGFuZGxlIGRhdGEgZnJvbSBwdWJsaXNoZWQgY3Vyc29ycyBhdCB0aGUgY29sbGVjdGlvbiBsZXZlbFxuLy8gVGhpcyBhbGxvd3Mgc29tZW9uZSB0bzpcbi8vIC0gQ2hvb3NlIGEgdHJhZGUtb2ZmIGJldHdlZW4gY2xpZW50LXNlcnZlciBiYW5kd2lkdGggYW5kIHNlcnZlciBtZW1vcnkgdXNhZ2Vcbi8vIC0gSW1wbGVtZW50IHNwZWNpYWwgKG5vbi1tb25nbykgY29sbGVjdGlvbnMgbGlrZSB2b2xhdGlsZSBtZXNzYWdlIHF1ZXVlc1xuY29uc3QgcHVibGljYXRpb25TdHJhdGVnaWVzID0ge1xuICAvLyBTRVJWRVJfTUVSR0UgaXMgdGhlIGRlZmF1bHQgc3RyYXRlZ3kuXG4gIC8vIFdoZW4gdXNpbmcgdGhpcyBzdHJhdGVneSwgdGhlIHNlcnZlciBtYWludGFpbnMgYSBjb3B5IG9mIGFsbCBkYXRhIGEgY29ubmVjdGlvbiBpcyBzdWJzY3JpYmVkIHRvLlxuICAvLyBUaGlzIGFsbG93cyB1cyB0byBvbmx5IHNlbmQgZGVsdGFzIG92ZXIgbXVsdGlwbGUgcHVibGljYXRpb25zLlxuICBTRVJWRVJfTUVSR0U6IHtcbiAgICB1c2VDb2xsZWN0aW9uVmlldzogdHJ1ZSxcbiAgICBkb0FjY291bnRpbmdGb3JDb2xsZWN0aW9uOiB0cnVlLFxuICB9LFxuICAvLyBUaGUgTk9fTUVSR0VfTk9fSElTVE9SWSBzdHJhdGVneSByZXN1bHRzIGluIHRoZSBzZXJ2ZXIgc2VuZGluZyBhbGwgcHVibGljYXRpb24gZGF0YVxuICAvLyBkaXJlY3RseSB0byB0aGUgY2xpZW50LiBJdCBkb2VzIG5vdCByZW1lbWJlciB3aGF0IGl0IGhhcyBwcmV2aW91c2x5IHNlbnRcbiAgLy8gdG8gaXQgd2lsbCBub3QgdHJpZ2dlciByZW1vdmVkIG1lc3NhZ2VzIHdoZW4gYSBzdWJzY3JpcHRpb24gaXMgc3RvcHBlZC5cbiAgLy8gVGhpcyBzaG91bGQgb25seSBiZSBjaG9zZW4gZm9yIHNwZWNpYWwgdXNlIGNhc2VzIGxpa2Ugc2VuZC1hbmQtZm9yZ2V0IHF1ZXVlcy5cbiAgTk9fTUVSR0VfTk9fSElTVE9SWToge1xuICAgIHVzZUNvbGxlY3Rpb25WaWV3OiBmYWxzZSxcbiAgICBkb0FjY291bnRpbmdGb3JDb2xsZWN0aW9uOiBmYWxzZSxcbiAgfSxcbiAgLy8gTk9fTUVSR0UgaXMgc2ltaWxhciB0byBOT19NRVJHRV9OT19ISVNUT1JZIGJ1dCB0aGUgc2VydmVyIHdpbGwgcmVtZW1iZXIgdGhlIElEcyBpdCBoYXNcbiAgLy8gc2VudCB0byB0aGUgY2xpZW50IHNvIGl0IGNhbiByZW1vdmUgdGhlbSB3aGVuIGEgc3Vic2NyaXB0aW9uIGlzIHN0b3BwZWQuXG4gIC8vIFRoaXMgc3RyYXRlZ3kgY2FuIGJlIHVzZWQgd2hlbiBhIGNvbGxlY3Rpb24gaXMgb25seSB1c2VkIGluIGEgc2luZ2xlIHB1YmxpY2F0aW9uLlxuICBOT19NRVJHRToge1xuICAgIHVzZUNvbGxlY3Rpb25WaWV3OiBmYWxzZSxcbiAgICBkb0FjY291bnRpbmdGb3JDb2xsZWN0aW9uOiB0cnVlLFxuICB9XG59O1xuXG5ERFBTZXJ2ZXIucHVibGljYXRpb25TdHJhdGVnaWVzID0gcHVibGljYXRpb25TdHJhdGVnaWVzO1xuXG4vLyBUaGlzIGZpbGUgY29udGFpbnMgY2xhc3Nlczpcbi8vICogU2Vzc2lvbiAtIFRoZSBzZXJ2ZXIncyBjb25uZWN0aW9uIHRvIGEgc2luZ2xlIEREUCBjbGllbnRcbi8vICogU3Vic2NyaXB0aW9uIC0gQSBzaW5nbGUgc3Vic2NyaXB0aW9uIGZvciBhIHNpbmdsZSBjbGllbnRcbi8vICogU2VydmVyIC0gQW4gZW50aXJlIHNlcnZlciB0aGF0IG1heSB0YWxrIHRvID4gMSBjbGllbnQuIEEgRERQIGVuZHBvaW50LlxuLy9cbi8vIFNlc3Npb24gYW5kIFN1YnNjcmlwdGlvbiBhcmUgZmlsZSBzY29wZS4gRm9yIG5vdywgdW50aWwgd2UgZnJlZXplXG4vLyB0aGUgaW50ZXJmYWNlLCBTZXJ2ZXIgaXMgcGFja2FnZSBzY29wZSAoaW4gdGhlIGZ1dHVyZSBpdCBzaG91bGQgYmVcbi8vIGV4cG9ydGVkKS5cblxuLy8gUmVwcmVzZW50cyBhIHNpbmdsZSBkb2N1bWVudCBpbiBhIFNlc3Npb25Db2xsZWN0aW9uVmlld1xudmFyIFNlc3Npb25Eb2N1bWVudFZpZXcgPSBmdW5jdGlvbiAoKSB7XG4gIHZhciBzZWxmID0gdGhpcztcbiAgc2VsZi5leGlzdHNJbiA9IG5ldyBTZXQoKTsgLy8gc2V0IG9mIHN1YnNjcmlwdGlvbkhhbmRsZVxuICBzZWxmLmRhdGFCeUtleSA9IG5ldyBNYXAoKTsgLy8ga2V5LT4gWyB7c3Vic2NyaXB0aW9uSGFuZGxlLCB2YWx1ZX0gYnkgcHJlY2VkZW5jZV1cbn07XG5cbkREUFNlcnZlci5fU2Vzc2lvbkRvY3VtZW50VmlldyA9IFNlc3Npb25Eb2N1bWVudFZpZXc7XG5cblxuXy5leHRlbmQoU2Vzc2lvbkRvY3VtZW50Vmlldy5wcm90b3R5cGUsIHtcblxuICBnZXRGaWVsZHM6IGZ1bmN0aW9uICgpIHtcbiAgICB2YXIgc2VsZiA9IHRoaXM7XG4gICAgdmFyIHJldCA9IHt9O1xuICAgIHNlbGYuZGF0YUJ5S2V5LmZvckVhY2goZnVuY3Rpb24gKHByZWNlZGVuY2VMaXN0LCBrZXkpIHtcbiAgICAgIHJldFtrZXldID0gcHJlY2VkZW5jZUxpc3RbMF0udmFsdWU7XG4gICAgfSk7XG4gICAgcmV0dXJuIHJldDtcbiAgfSxcblxuICBjbGVhckZpZWxkOiBmdW5jdGlvbiAoc3Vic2NyaXB0aW9uSGFuZGxlLCBrZXksIGNoYW5nZUNvbGxlY3Rvcikge1xuICAgIHZhciBzZWxmID0gdGhpcztcbiAgICAvLyBQdWJsaXNoIEFQSSBpZ25vcmVzIF9pZCBpZiBwcmVzZW50IGluIGZpZWxkc1xuICAgIGlmIChrZXkgPT09IFwiX2lkXCIpXG4gICAgICByZXR1cm47XG4gICAgdmFyIHByZWNlZGVuY2VMaXN0ID0gc2VsZi5kYXRhQnlLZXkuZ2V0KGtleSk7XG5cbiAgICAvLyBJdCdzIG9rYXkgdG8gY2xlYXIgZmllbGRzIHRoYXQgZGlkbid0IGV4aXN0LiBObyBuZWVkIHRvIHRocm93XG4gICAgLy8gYW4gZXJyb3IuXG4gICAgaWYgKCFwcmVjZWRlbmNlTGlzdClcbiAgICAgIHJldHVybjtcblxuICAgIHZhciByZW1vdmVkVmFsdWUgPSB1bmRlZmluZWQ7XG4gICAgZm9yICh2YXIgaSA9IDA7IGkgPCBwcmVjZWRlbmNlTGlzdC5sZW5ndGg7IGkrKykge1xuICAgICAgdmFyIHByZWNlZGVuY2UgPSBwcmVjZWRlbmNlTGlzdFtpXTtcbiAgICAgIGlmIChwcmVjZWRlbmNlLnN1YnNjcmlwdGlvbkhhbmRsZSA9PT0gc3Vic2NyaXB0aW9uSGFuZGxlKSB7XG4gICAgICAgIC8vIFRoZSB2aWV3J3MgdmFsdWUgY2FuIG9ubHkgY2hhbmdlIGlmIHRoaXMgc3Vic2NyaXB0aW9uIGlzIHRoZSBvbmUgdGhhdFxuICAgICAgICAvLyB1c2VkIHRvIGhhdmUgcHJlY2VkZW5jZS5cbiAgICAgICAgaWYgKGkgPT09IDApXG4gICAgICAgICAgcmVtb3ZlZFZhbHVlID0gcHJlY2VkZW5jZS52YWx1ZTtcbiAgICAgICAgcHJlY2VkZW5jZUxpc3Quc3BsaWNlKGksIDEpO1xuICAgICAgICBicmVhaztcbiAgICAgIH1cbiAgICB9XG4gICAgaWYgKHByZWNlZGVuY2VMaXN0Lmxlbmd0aCA9PT0gMCkge1xuICAgICAgc2VsZi5kYXRhQnlLZXkuZGVsZXRlKGtleSk7XG4gICAgICBjaGFuZ2VDb2xsZWN0b3Jba2V5XSA9IHVuZGVmaW5lZDtcbiAgICB9IGVsc2UgaWYgKHJlbW92ZWRWYWx1ZSAhPT0gdW5kZWZpbmVkICYmXG4gICAgICAgICAgICAgICAhRUpTT04uZXF1YWxzKHJlbW92ZWRWYWx1ZSwgcHJlY2VkZW5jZUxpc3RbMF0udmFsdWUpKSB7XG4gICAgICBjaGFuZ2VDb2xsZWN0b3Jba2V5XSA9IHByZWNlZGVuY2VMaXN0WzBdLnZhbHVlO1xuICAgIH1cbiAgfSxcblxuICBjaGFuZ2VGaWVsZDogZnVuY3Rpb24gKHN1YnNjcmlwdGlvbkhhbmRsZSwga2V5LCB2YWx1ZSxcbiAgICAgICAgICAgICAgICAgICAgICAgICBjaGFuZ2VDb2xsZWN0b3IsIGlzQWRkKSB7XG4gICAgdmFyIHNlbGYgPSB0aGlzO1xuICAgIC8vIFB1Ymxpc2ggQVBJIGlnbm9yZXMgX2lkIGlmIHByZXNlbnQgaW4gZmllbGRzXG4gICAgaWYgKGtleSA9PT0gXCJfaWRcIilcbiAgICAgIHJldHVybjtcblxuICAgIC8vIERvbid0IHNoYXJlIHN0YXRlIHdpdGggdGhlIGRhdGEgcGFzc2VkIGluIGJ5IHRoZSB1c2VyLlxuICAgIHZhbHVlID0gRUpTT04uY2xvbmUodmFsdWUpO1xuXG4gICAgaWYgKCFzZWxmLmRhdGFCeUtleS5oYXMoa2V5KSkge1xuICAgICAgc2VsZi5kYXRhQnlLZXkuc2V0KGtleSwgW3tzdWJzY3JpcHRpb25IYW5kbGU6IHN1YnNjcmlwdGlvbkhhbmRsZSxcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdmFsdWU6IHZhbHVlfV0pO1xuICAgICAgY2hhbmdlQ29sbGVjdG9yW2tleV0gPSB2YWx1ZTtcbiAgICAgIHJldHVybjtcbiAgICB9XG4gICAgdmFyIHByZWNlZGVuY2VMaXN0ID0gc2VsZi5kYXRhQnlLZXkuZ2V0KGtleSk7XG4gICAgdmFyIGVsdDtcbiAgICBpZiAoIWlzQWRkKSB7XG4gICAgICBlbHQgPSBwcmVjZWRlbmNlTGlzdC5maW5kKGZ1bmN0aW9uIChwcmVjZWRlbmNlKSB7XG4gICAgICAgICAgcmV0dXJuIHByZWNlZGVuY2Uuc3Vic2NyaXB0aW9uSGFuZGxlID09PSBzdWJzY3JpcHRpb25IYW5kbGU7XG4gICAgICB9KTtcbiAgICB9XG5cbiAgICBpZiAoZWx0KSB7XG4gICAgICBpZiAoZWx0ID09PSBwcmVjZWRlbmNlTGlzdFswXSAmJiAhRUpTT04uZXF1YWxzKHZhbHVlLCBlbHQudmFsdWUpKSB7XG4gICAgICAgIC8vIHRoaXMgc3Vic2NyaXB0aW9uIGlzIGNoYW5naW5nIHRoZSB2YWx1ZSBvZiB0aGlzIGZpZWxkLlxuICAgICAgICBjaGFuZ2VDb2xsZWN0b3Jba2V5XSA9IHZhbHVlO1xuICAgICAgfVxuICAgICAgZWx0LnZhbHVlID0gdmFsdWU7XG4gICAgfSBlbHNlIHtcbiAgICAgIC8vIHRoaXMgc3Vic2NyaXB0aW9uIGlzIG5ld2x5IGNhcmluZyBhYm91dCB0aGlzIGZpZWxkXG4gICAgICBwcmVjZWRlbmNlTGlzdC5wdXNoKHtzdWJzY3JpcHRpb25IYW5kbGU6IHN1YnNjcmlwdGlvbkhhbmRsZSwgdmFsdWU6IHZhbHVlfSk7XG4gICAgfVxuXG4gIH1cbn0pO1xuXG4vKipcbiAqIFJlcHJlc2VudHMgYSBjbGllbnQncyB2aWV3IG9mIGEgc2luZ2xlIGNvbGxlY3Rpb25cbiAqIEBwYXJhbSB7U3RyaW5nfSBjb2xsZWN0aW9uTmFtZSBOYW1lIG9mIHRoZSBjb2xsZWN0aW9uIGl0IHJlcHJlc2VudHNcbiAqIEBwYXJhbSB7T2JqZWN0LjxTdHJpbmcsIEZ1bmN0aW9uPn0gc2Vzc2lvbkNhbGxiYWNrcyBUaGUgY2FsbGJhY2tzIGZvciBhZGRlZCwgY2hhbmdlZCwgcmVtb3ZlZFxuICogQGNsYXNzIFNlc3Npb25Db2xsZWN0aW9uVmlld1xuICovXG52YXIgU2Vzc2lvbkNvbGxlY3Rpb25WaWV3ID0gZnVuY3Rpb24gKGNvbGxlY3Rpb25OYW1lLCBzZXNzaW9uQ2FsbGJhY2tzKSB7XG4gIHZhciBzZWxmID0gdGhpcztcbiAgc2VsZi5jb2xsZWN0aW9uTmFtZSA9IGNvbGxlY3Rpb25OYW1lO1xuICBzZWxmLmRvY3VtZW50cyA9IG5ldyBNYXAoKTtcbiAgc2VsZi5jYWxsYmFja3MgPSBzZXNzaW9uQ2FsbGJhY2tzO1xufTtcblxuRERQU2VydmVyLl9TZXNzaW9uQ29sbGVjdGlvblZpZXcgPSBTZXNzaW9uQ29sbGVjdGlvblZpZXc7XG5cblxuT2JqZWN0LmFzc2lnbihTZXNzaW9uQ29sbGVjdGlvblZpZXcucHJvdG90eXBlLCB7XG5cbiAgaXNFbXB0eTogZnVuY3Rpb24gKCkge1xuICAgIHZhciBzZWxmID0gdGhpcztcbiAgICByZXR1cm4gc2VsZi5kb2N1bWVudHMuc2l6ZSA9PT0gMDtcbiAgfSxcblxuICBkaWZmOiBmdW5jdGlvbiAocHJldmlvdXMpIHtcbiAgICB2YXIgc2VsZiA9IHRoaXM7XG4gICAgRGlmZlNlcXVlbmNlLmRpZmZNYXBzKHByZXZpb3VzLmRvY3VtZW50cywgc2VsZi5kb2N1bWVudHMsIHtcbiAgICAgIGJvdGg6IF8uYmluZChzZWxmLmRpZmZEb2N1bWVudCwgc2VsZiksXG5cbiAgICAgIHJpZ2h0T25seTogZnVuY3Rpb24gKGlkLCBub3dEVikge1xuICAgICAgICBzZWxmLmNhbGxiYWNrcy5hZGRlZChzZWxmLmNvbGxlY3Rpb25OYW1lLCBpZCwgbm93RFYuZ2V0RmllbGRzKCkpO1xuICAgICAgfSxcblxuICAgICAgbGVmdE9ubHk6IGZ1bmN0aW9uIChpZCwgcHJldkRWKSB7XG4gICAgICAgIHNlbGYuY2FsbGJhY2tzLnJlbW92ZWQoc2VsZi5jb2xsZWN0aW9uTmFtZSwgaWQpO1xuICAgICAgfVxuICAgIH0pO1xuICB9LFxuXG4gIGRpZmZEb2N1bWVudDogZnVuY3Rpb24gKGlkLCBwcmV2RFYsIG5vd0RWKSB7XG4gICAgdmFyIHNlbGYgPSB0aGlzO1xuICAgIHZhciBmaWVsZHMgPSB7fTtcbiAgICBEaWZmU2VxdWVuY2UuZGlmZk9iamVjdHMocHJldkRWLmdldEZpZWxkcygpLCBub3dEVi5nZXRGaWVsZHMoKSwge1xuICAgICAgYm90aDogZnVuY3Rpb24gKGtleSwgcHJldiwgbm93KSB7XG4gICAgICAgIGlmICghRUpTT04uZXF1YWxzKHByZXYsIG5vdykpXG4gICAgICAgICAgZmllbGRzW2tleV0gPSBub3c7XG4gICAgICB9LFxuICAgICAgcmlnaHRPbmx5OiBmdW5jdGlvbiAoa2V5LCBub3cpIHtcbiAgICAgICAgZmllbGRzW2tleV0gPSBub3c7XG4gICAgICB9LFxuICAgICAgbGVmdE9ubHk6IGZ1bmN0aW9uKGtleSwgcHJldikge1xuICAgICAgICBmaWVsZHNba2V5XSA9IHVuZGVmaW5lZDtcbiAgICAgIH1cbiAgICB9KTtcbiAgICBzZWxmLmNhbGxiYWNrcy5jaGFuZ2VkKHNlbGYuY29sbGVjdGlvbk5hbWUsIGlkLCBmaWVsZHMpO1xuICB9LFxuXG4gIGFkZGVkOiBmdW5jdGlvbiAoc3Vic2NyaXB0aW9uSGFuZGxlLCBpZCwgZmllbGRzKSB7XG4gICAgdmFyIHNlbGYgPSB0aGlzO1xuICAgIHZhciBkb2NWaWV3ID0gc2VsZi5kb2N1bWVudHMuZ2V0KGlkKTtcbiAgICB2YXIgYWRkZWQgPSBmYWxzZTtcbiAgICBpZiAoIWRvY1ZpZXcpIHtcbiAgICAgIGFkZGVkID0gdHJ1ZTtcbiAgICAgIGRvY1ZpZXcgPSBuZXcgU2Vzc2lvbkRvY3VtZW50VmlldygpO1xuICAgICAgc2VsZi5kb2N1bWVudHMuc2V0KGlkLCBkb2NWaWV3KTtcbiAgICB9XG4gICAgZG9jVmlldy5leGlzdHNJbi5hZGQoc3Vic2NyaXB0aW9uSGFuZGxlKTtcbiAgICB2YXIgY2hhbmdlQ29sbGVjdG9yID0ge307XG4gICAgXy5lYWNoKGZpZWxkcywgZnVuY3Rpb24gKHZhbHVlLCBrZXkpIHtcbiAgICAgIGRvY1ZpZXcuY2hhbmdlRmllbGQoXG4gICAgICAgIHN1YnNjcmlwdGlvbkhhbmRsZSwga2V5LCB2YWx1ZSwgY2hhbmdlQ29sbGVjdG9yLCB0cnVlKTtcbiAgICB9KTtcbiAgICBpZiAoYWRkZWQpXG4gICAgICBzZWxmLmNhbGxiYWNrcy5hZGRlZChzZWxmLmNvbGxlY3Rpb25OYW1lLCBpZCwgY2hhbmdlQ29sbGVjdG9yKTtcbiAgICBlbHNlXG4gICAgICBzZWxmLmNhbGxiYWNrcy5jaGFuZ2VkKHNlbGYuY29sbGVjdGlvbk5hbWUsIGlkLCBjaGFuZ2VDb2xsZWN0b3IpO1xuICB9LFxuXG4gIGNoYW5nZWQ6IGZ1bmN0aW9uIChzdWJzY3JpcHRpb25IYW5kbGUsIGlkLCBjaGFuZ2VkKSB7XG4gICAgdmFyIHNlbGYgPSB0aGlzO1xuICAgIHZhciBjaGFuZ2VkUmVzdWx0ID0ge307XG4gICAgdmFyIGRvY1ZpZXcgPSBzZWxmLmRvY3VtZW50cy5nZXQoaWQpO1xuICAgIGlmICghZG9jVmlldylcbiAgICAgIHRocm93IG5ldyBFcnJvcihcIkNvdWxkIG5vdCBmaW5kIGVsZW1lbnQgd2l0aCBpZCBcIiArIGlkICsgXCIgdG8gY2hhbmdlXCIpO1xuICAgIF8uZWFjaChjaGFuZ2VkLCBmdW5jdGlvbiAodmFsdWUsIGtleSkge1xuICAgICAgaWYgKHZhbHVlID09PSB1bmRlZmluZWQpXG4gICAgICAgIGRvY1ZpZXcuY2xlYXJGaWVsZChzdWJzY3JpcHRpb25IYW5kbGUsIGtleSwgY2hhbmdlZFJlc3VsdCk7XG4gICAgICBlbHNlXG4gICAgICAgIGRvY1ZpZXcuY2hhbmdlRmllbGQoc3Vic2NyaXB0aW9uSGFuZGxlLCBrZXksIHZhbHVlLCBjaGFuZ2VkUmVzdWx0KTtcbiAgICB9KTtcbiAgICBzZWxmLmNhbGxiYWNrcy5jaGFuZ2VkKHNlbGYuY29sbGVjdGlvbk5hbWUsIGlkLCBjaGFuZ2VkUmVzdWx0KTtcbiAgfSxcblxuICByZW1vdmVkOiBmdW5jdGlvbiAoc3Vic2NyaXB0aW9uSGFuZGxlLCBpZCkge1xuICAgIHZhciBzZWxmID0gdGhpcztcbiAgICB2YXIgZG9jVmlldyA9IHNlbGYuZG9jdW1lbnRzLmdldChpZCk7XG4gICAgaWYgKCFkb2NWaWV3KSB7XG4gICAgICB2YXIgZXJyID0gbmV3IEVycm9yKFwiUmVtb3ZlZCBub25leGlzdGVudCBkb2N1bWVudCBcIiArIGlkKTtcbiAgICAgIHRocm93IGVycjtcbiAgICB9XG4gICAgZG9jVmlldy5leGlzdHNJbi5kZWxldGUoc3Vic2NyaXB0aW9uSGFuZGxlKTtcbiAgICBpZiAoZG9jVmlldy5leGlzdHNJbi5zaXplID09PSAwKSB7XG4gICAgICAvLyBpdCBpcyBnb25lIGZyb20gZXZlcnlvbmVcbiAgICAgIHNlbGYuY2FsbGJhY2tzLnJlbW92ZWQoc2VsZi5jb2xsZWN0aW9uTmFtZSwgaWQpO1xuICAgICAgc2VsZi5kb2N1bWVudHMuZGVsZXRlKGlkKTtcbiAgICB9IGVsc2Uge1xuICAgICAgdmFyIGNoYW5nZWQgPSB7fTtcbiAgICAgIC8vIHJlbW92ZSB0aGlzIHN1YnNjcmlwdGlvbiBmcm9tIGV2ZXJ5IHByZWNlZGVuY2UgbGlzdFxuICAgICAgLy8gYW5kIHJlY29yZCB0aGUgY2hhbmdlc1xuICAgICAgZG9jVmlldy5kYXRhQnlLZXkuZm9yRWFjaChmdW5jdGlvbiAocHJlY2VkZW5jZUxpc3QsIGtleSkge1xuICAgICAgICBkb2NWaWV3LmNsZWFyRmllbGQoc3Vic2NyaXB0aW9uSGFuZGxlLCBrZXksIGNoYW5nZWQpO1xuICAgICAgfSk7XG5cbiAgICAgIHNlbGYuY2FsbGJhY2tzLmNoYW5nZWQoc2VsZi5jb2xsZWN0aW9uTmFtZSwgaWQsIGNoYW5nZWQpO1xuICAgIH1cbiAgfVxufSk7XG5cbi8qKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKiovXG4vKiBTZXNzaW9uICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqL1xuLyoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKi9cblxudmFyIFNlc3Npb24gPSBmdW5jdGlvbiAoc2VydmVyLCB2ZXJzaW9uLCBzb2NrZXQsIG9wdGlvbnMpIHtcbiAgdmFyIHNlbGYgPSB0aGlzO1xuICBzZWxmLmlkID0gUmFuZG9tLmlkKCk7XG5cbiAgc2VsZi5zZXJ2ZXIgPSBzZXJ2ZXI7XG4gIHNlbGYudmVyc2lvbiA9IHZlcnNpb247XG5cbiAgc2VsZi5pbml0aWFsaXplZCA9IGZhbHNlO1xuICBzZWxmLnNvY2tldCA9IHNvY2tldDtcblxuICAvLyBTZXQgdG8gbnVsbCB3aGVuIHRoZSBzZXNzaW9uIGlzIGRlc3Ryb3llZC4gTXVsdGlwbGUgcGxhY2VzIGJlbG93XG4gIC8vIHVzZSB0aGlzIHRvIGRldGVybWluZSBpZiB0aGUgc2Vzc2lvbiBpcyBhbGl2ZSBvciBub3QuXG4gIHNlbGYuaW5RdWV1ZSA9IG5ldyBNZXRlb3IuX0RvdWJsZUVuZGVkUXVldWUoKTtcblxuICBzZWxmLmJsb2NrZWQgPSBmYWxzZTtcbiAgc2VsZi53b3JrZXJSdW5uaW5nID0gZmFsc2U7XG5cbiAgc2VsZi5jYWNoZWRVbmJsb2NrID0gbnVsbDtcblxuICAvLyBTdWIgb2JqZWN0cyBmb3IgYWN0aXZlIHN1YnNjcmlwdGlvbnNcbiAgc2VsZi5fbmFtZWRTdWJzID0gbmV3IE1hcCgpO1xuICBzZWxmLl91bml2ZXJzYWxTdWJzID0gW107XG5cbiAgc2VsZi51c2VySWQgPSBudWxsO1xuXG4gIHNlbGYuY29sbGVjdGlvblZpZXdzID0gbmV3IE1hcCgpO1xuXG4gIC8vIFNldCB0aGlzIHRvIGZhbHNlIHRvIG5vdCBzZW5kIG1lc3NhZ2VzIHdoZW4gY29sbGVjdGlvblZpZXdzIGFyZVxuICAvLyBtb2RpZmllZC4gVGhpcyBpcyBkb25lIHdoZW4gcmVydW5uaW5nIHN1YnMgaW4gX3NldFVzZXJJZCBhbmQgdGhvc2UgbWVzc2FnZXNcbiAgLy8gYXJlIGNhbGN1bGF0ZWQgdmlhIGEgZGlmZiBpbnN0ZWFkLlxuICBzZWxmLl9pc1NlbmRpbmcgPSB0cnVlO1xuXG4gIC8vIElmIHRoaXMgaXMgdHJ1ZSwgZG9uJ3Qgc3RhcnQgYSBuZXdseS1jcmVhdGVkIHVuaXZlcnNhbCBwdWJsaXNoZXIgb24gdGhpc1xuICAvLyBzZXNzaW9uLiBUaGUgc2Vzc2lvbiB3aWxsIHRha2UgY2FyZSBvZiBzdGFydGluZyBpdCB3aGVuIGFwcHJvcHJpYXRlLlxuICBzZWxmLl9kb250U3RhcnROZXdVbml2ZXJzYWxTdWJzID0gZmFsc2U7XG5cbiAgLy8gV2hlbiB3ZSBhcmUgcmVydW5uaW5nIHN1YnNjcmlwdGlvbnMsIGFueSByZWFkeSBtZXNzYWdlc1xuICAvLyB3ZSB3YW50IHRvIGJ1ZmZlciB1cCBmb3Igd2hlbiB3ZSBhcmUgZG9uZSByZXJ1bm5pbmcgc3Vic2NyaXB0aW9uc1xuICBzZWxmLl9wZW5kaW5nUmVhZHkgPSBbXTtcblxuICAvLyBMaXN0IG9mIGNhbGxiYWNrcyB0byBjYWxsIHdoZW4gdGhpcyBjb25uZWN0aW9uIGlzIGNsb3NlZC5cbiAgc2VsZi5fY2xvc2VDYWxsYmFja3MgPSBbXTtcblxuXG4gIC8vIFhYWCBIQUNLOiBJZiBhIHNvY2tqcyBjb25uZWN0aW9uLCBzYXZlIG9mZiB0aGUgVVJMLiBUaGlzIGlzXG4gIC8vIHRlbXBvcmFyeSBhbmQgd2lsbCBnbyBhd2F5IGluIHRoZSBuZWFyIGZ1dHVyZS5cbiAgc2VsZi5fc29ja2V0VXJsID0gc29ja2V0LnVybDtcblxuICAvLyBBbGxvdyB0ZXN0cyB0byBkaXNhYmxlIHJlc3BvbmRpbmcgdG8gcGluZ3MuXG4gIHNlbGYuX3Jlc3BvbmRUb1BpbmdzID0gb3B0aW9ucy5yZXNwb25kVG9QaW5ncztcblxuICAvLyBUaGlzIG9iamVjdCBpcyB0aGUgcHVibGljIGludGVyZmFjZSB0byB0aGUgc2Vzc2lvbi4gSW4gdGhlIHB1YmxpY1xuICAvLyBBUEksIGl0IGlzIGNhbGxlZCB0aGUgYGNvbm5lY3Rpb25gIG9iamVjdC4gIEludGVybmFsbHkgd2UgY2FsbCBpdFxuICAvLyBhIGBjb25uZWN0aW9uSGFuZGxlYCB0byBhdm9pZCBhbWJpZ3VpdHkuXG4gIHNlbGYuY29ubmVjdGlvbkhhbmRsZSA9IHtcbiAgICBpZDogc2VsZi5pZCxcbiAgICBjbG9zZTogZnVuY3Rpb24gKCkge1xuICAgICAgc2VsZi5jbG9zZSgpO1xuICAgIH0sXG4gICAgb25DbG9zZTogZnVuY3Rpb24gKGZuKSB7XG4gICAgICB2YXIgY2IgPSBNZXRlb3IuYmluZEVudmlyb25tZW50KGZuLCBcImNvbm5lY3Rpb24gb25DbG9zZSBjYWxsYmFja1wiKTtcbiAgICAgIGlmIChzZWxmLmluUXVldWUpIHtcbiAgICAgICAgc2VsZi5fY2xvc2VDYWxsYmFja3MucHVzaChjYik7XG4gICAgICB9IGVsc2Uge1xuICAgICAgICAvLyBpZiB3ZSdyZSBhbHJlYWR5IGNsb3NlZCwgY2FsbCB0aGUgY2FsbGJhY2suXG4gICAgICAgIE1ldGVvci5kZWZlcihjYik7XG4gICAgICB9XG4gICAgfSxcbiAgICBjbGllbnRBZGRyZXNzOiBzZWxmLl9jbGllbnRBZGRyZXNzKCksXG4gICAgaHR0cEhlYWRlcnM6IHNlbGYuc29ja2V0LmhlYWRlcnNcbiAgfTtcblxuICBzZWxmLnNlbmQoeyBtc2c6ICdjb25uZWN0ZWQnLCBzZXNzaW9uOiBzZWxmLmlkIH0pO1xuXG4gIC8vIE9uIGluaXRpYWwgY29ubmVjdCwgc3BpbiB1cCBhbGwgdGhlIHVuaXZlcnNhbCBwdWJsaXNoZXJzLlxuICBGaWJlcihmdW5jdGlvbiAoKSB7XG4gICAgc2VsZi5zdGFydFVuaXZlcnNhbFN1YnMoKTtcbiAgfSkucnVuKCk7XG5cbiAgaWYgKHZlcnNpb24gIT09ICdwcmUxJyAmJiBvcHRpb25zLmhlYXJ0YmVhdEludGVydmFsICE9PSAwKSB7XG4gICAgLy8gV2Ugbm8gbG9uZ2VyIG5lZWQgdGhlIGxvdyBsZXZlbCB0aW1lb3V0IGJlY2F1c2Ugd2UgaGF2ZSBoZWFydGJlYXRzLlxuICAgIHNvY2tldC5zZXRXZWJzb2NrZXRUaW1lb3V0KDApO1xuXG4gICAgc2VsZi5oZWFydGJlYXQgPSBuZXcgRERQQ29tbW9uLkhlYXJ0YmVhdCh7XG4gICAgICBoZWFydGJlYXRJbnRlcnZhbDogb3B0aW9ucy5oZWFydGJlYXRJbnRlcnZhbCxcbiAgICAgIGhlYXJ0YmVhdFRpbWVvdXQ6IG9wdGlvbnMuaGVhcnRiZWF0VGltZW91dCxcbiAgICAgIG9uVGltZW91dDogZnVuY3Rpb24gKCkge1xuICAgICAgICBzZWxmLmNsb3NlKCk7XG4gICAgICB9LFxuICAgICAgc2VuZFBpbmc6IGZ1bmN0aW9uICgpIHtcbiAgICAgICAgc2VsZi5zZW5kKHttc2c6ICdwaW5nJ30pO1xuICAgICAgfVxuICAgIH0pO1xuICAgIHNlbGYuaGVhcnRiZWF0LnN0YXJ0KCk7XG4gIH1cblxuICBQYWNrYWdlWydmYWN0cy1iYXNlJ10gJiYgUGFja2FnZVsnZmFjdHMtYmFzZSddLkZhY3RzLmluY3JlbWVudFNlcnZlckZhY3QoXG4gICAgXCJsaXZlZGF0YVwiLCBcInNlc3Npb25zXCIsIDEpO1xufTtcblxuT2JqZWN0LmFzc2lnbihTZXNzaW9uLnByb3RvdHlwZSwge1xuXG4gIHNlbmRSZWFkeTogZnVuY3Rpb24gKHN1YnNjcmlwdGlvbklkcykge1xuICAgIHZhciBzZWxmID0gdGhpcztcbiAgICBpZiAoc2VsZi5faXNTZW5kaW5nKVxuICAgICAgc2VsZi5zZW5kKHttc2c6IFwicmVhZHlcIiwgc3Viczogc3Vic2NyaXB0aW9uSWRzfSk7XG4gICAgZWxzZSB7XG4gICAgICBfLmVhY2goc3Vic2NyaXB0aW9uSWRzLCBmdW5jdGlvbiAoc3Vic2NyaXB0aW9uSWQpIHtcbiAgICAgICAgc2VsZi5fcGVuZGluZ1JlYWR5LnB1c2goc3Vic2NyaXB0aW9uSWQpO1xuICAgICAgfSk7XG4gICAgfVxuICB9LFxuXG4gIF9jYW5TZW5kKGNvbGxlY3Rpb25OYW1lKSB7XG4gICAgcmV0dXJuIHRoaXMuX2lzU2VuZGluZyB8fCAhdGhpcy5zZXJ2ZXIuZ2V0UHVibGljYXRpb25TdHJhdGVneShjb2xsZWN0aW9uTmFtZSkudXNlQ29sbGVjdGlvblZpZXc7XG4gIH0sXG5cblxuICBzZW5kQWRkZWQoY29sbGVjdGlvbk5hbWUsIGlkLCBmaWVsZHMpIHtcbiAgICBpZiAodGhpcy5fY2FuU2VuZChjb2xsZWN0aW9uTmFtZSkpXG4gICAgICB0aGlzLnNlbmQoe21zZzogXCJhZGRlZFwiLCBjb2xsZWN0aW9uOiBjb2xsZWN0aW9uTmFtZSwgaWQsIGZpZWxkc30pO1xuICB9LFxuXG4gIHNlbmRDaGFuZ2VkKGNvbGxlY3Rpb25OYW1lLCBpZCwgZmllbGRzKSB7XG4gICAgaWYgKF8uaXNFbXB0eShmaWVsZHMpKVxuICAgICAgcmV0dXJuO1xuXG4gICAgaWYgKHRoaXMuX2NhblNlbmQoY29sbGVjdGlvbk5hbWUpKSB7XG4gICAgICB0aGlzLnNlbmQoe1xuICAgICAgICBtc2c6IFwiY2hhbmdlZFwiLFxuICAgICAgICBjb2xsZWN0aW9uOiBjb2xsZWN0aW9uTmFtZSxcbiAgICAgICAgaWQsXG4gICAgICAgIGZpZWxkc1xuICAgICAgfSk7XG4gICAgfVxuICB9LFxuXG4gIHNlbmRSZW1vdmVkKGNvbGxlY3Rpb25OYW1lLCBpZCkge1xuICAgIGlmICh0aGlzLl9jYW5TZW5kKGNvbGxlY3Rpb25OYW1lKSlcbiAgICAgIHRoaXMuc2VuZCh7bXNnOiBcInJlbW92ZWRcIiwgY29sbGVjdGlvbjogY29sbGVjdGlvbk5hbWUsIGlkfSk7XG4gIH0sXG5cbiAgZ2V0U2VuZENhbGxiYWNrczogZnVuY3Rpb24gKCkge1xuICAgIHZhciBzZWxmID0gdGhpcztcbiAgICByZXR1cm4ge1xuICAgICAgYWRkZWQ6IF8uYmluZChzZWxmLnNlbmRBZGRlZCwgc2VsZiksXG4gICAgICBjaGFuZ2VkOiBfLmJpbmQoc2VsZi5zZW5kQ2hhbmdlZCwgc2VsZiksXG4gICAgICByZW1vdmVkOiBfLmJpbmQoc2VsZi5zZW5kUmVtb3ZlZCwgc2VsZilcbiAgICB9O1xuICB9LFxuXG4gIGdldENvbGxlY3Rpb25WaWV3OiBmdW5jdGlvbiAoY29sbGVjdGlvbk5hbWUpIHtcbiAgICB2YXIgc2VsZiA9IHRoaXM7XG4gICAgdmFyIHJldCA9IHNlbGYuY29sbGVjdGlvblZpZXdzLmdldChjb2xsZWN0aW9uTmFtZSk7XG4gICAgaWYgKCFyZXQpIHtcbiAgICAgIHJldCA9IG5ldyBTZXNzaW9uQ29sbGVjdGlvblZpZXcoY29sbGVjdGlvbk5hbWUsXG4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc2VsZi5nZXRTZW5kQ2FsbGJhY2tzKCkpO1xuICAgICAgc2VsZi5jb2xsZWN0aW9uVmlld3Muc2V0KGNvbGxlY3Rpb25OYW1lLCByZXQpO1xuICAgIH1cbiAgICByZXR1cm4gcmV0O1xuICB9LFxuXG4gIGFkZGVkKHN1YnNjcmlwdGlvbkhhbmRsZSwgY29sbGVjdGlvbk5hbWUsIGlkLCBmaWVsZHMpIHtcbiAgICBpZiAodGhpcy5zZXJ2ZXIuZ2V0UHVibGljYXRpb25TdHJhdGVneShjb2xsZWN0aW9uTmFtZSkudXNlQ29sbGVjdGlvblZpZXcpIHtcbiAgICAgIGNvbnN0IHZpZXcgPSB0aGlzLmdldENvbGxlY3Rpb25WaWV3KGNvbGxlY3Rpb25OYW1lKTtcbiAgICAgIHZpZXcuYWRkZWQoc3Vic2NyaXB0aW9uSGFuZGxlLCBpZCwgZmllbGRzKTtcbiAgICB9IGVsc2Uge1xuICAgICAgdGhpcy5zZW5kQWRkZWQoY29sbGVjdGlvbk5hbWUsIGlkLCBmaWVsZHMpO1xuICAgIH1cbiAgfSxcblxuICByZW1vdmVkKHN1YnNjcmlwdGlvbkhhbmRsZSwgY29sbGVjdGlvbk5hbWUsIGlkKSB7XG4gICAgaWYgKHRoaXMuc2VydmVyLmdldFB1YmxpY2F0aW9uU3RyYXRlZ3koY29sbGVjdGlvbk5hbWUpLnVzZUNvbGxlY3Rpb25WaWV3KSB7XG4gICAgICBjb25zdCB2aWV3ID0gdGhpcy5nZXRDb2xsZWN0aW9uVmlldyhjb2xsZWN0aW9uTmFtZSk7XG4gICAgICB2aWV3LnJlbW92ZWQoc3Vic2NyaXB0aW9uSGFuZGxlLCBpZCk7XG4gICAgICBpZiAodmlldy5pc0VtcHR5KCkpIHtcbiAgICAgICAgIHRoaXMuY29sbGVjdGlvblZpZXdzLmRlbGV0ZShjb2xsZWN0aW9uTmFtZSk7XG4gICAgICB9XG4gICAgfSBlbHNlIHtcbiAgICAgIHRoaXMuc2VuZFJlbW92ZWQoY29sbGVjdGlvbk5hbWUsIGlkKTtcbiAgICB9XG4gIH0sXG5cbiAgY2hhbmdlZChzdWJzY3JpcHRpb25IYW5kbGUsIGNvbGxlY3Rpb25OYW1lLCBpZCwgZmllbGRzKSB7XG4gICAgaWYgKHRoaXMuc2VydmVyLmdldFB1YmxpY2F0aW9uU3RyYXRlZ3koY29sbGVjdGlvbk5hbWUpLnVzZUNvbGxlY3Rpb25WaWV3KSB7XG4gICAgICBjb25zdCB2aWV3ID0gdGhpcy5nZXRDb2xsZWN0aW9uVmlldyhjb2xsZWN0aW9uTmFtZSk7XG4gICAgICB2aWV3LmNoYW5nZWQoc3Vic2NyaXB0aW9uSGFuZGxlLCBpZCwgZmllbGRzKTtcbiAgICB9IGVsc2Uge1xuICAgICAgdGhpcy5zZW5kQ2hhbmdlZChjb2xsZWN0aW9uTmFtZSwgaWQsIGZpZWxkcyk7XG4gICAgfVxuICB9LFxuXG4gIHN0YXJ0VW5pdmVyc2FsU3ViczogZnVuY3Rpb24gKCkge1xuICAgIHZhciBzZWxmID0gdGhpcztcbiAgICAvLyBNYWtlIGEgc2hhbGxvdyBjb3B5IG9mIHRoZSBzZXQgb2YgdW5pdmVyc2FsIGhhbmRsZXJzIGFuZCBzdGFydCB0aGVtLiBJZlxuICAgIC8vIGFkZGl0aW9uYWwgdW5pdmVyc2FsIHB1Ymxpc2hlcnMgc3RhcnQgd2hpbGUgd2UncmUgcnVubmluZyB0aGVtIChkdWUgdG9cbiAgICAvLyB5aWVsZGluZyksIHRoZXkgd2lsbCBydW4gc2VwYXJhdGVseSBhcyBwYXJ0IG9mIFNlcnZlci5wdWJsaXNoLlxuICAgIHZhciBoYW5kbGVycyA9IF8uY2xvbmUoc2VsZi5zZXJ2ZXIudW5pdmVyc2FsX3B1Ymxpc2hfaGFuZGxlcnMpO1xuICAgIF8uZWFjaChoYW5kbGVycywgZnVuY3Rpb24gKGhhbmRsZXIpIHtcbiAgICAgIHNlbGYuX3N0YXJ0U3Vic2NyaXB0aW9uKGhhbmRsZXIpO1xuICAgIH0pO1xuICB9LFxuXG4gIC8vIERlc3Ryb3kgdGhpcyBzZXNzaW9uIGFuZCB1bnJlZ2lzdGVyIGl0IGF0IHRoZSBzZXJ2ZXIuXG4gIGNsb3NlOiBmdW5jdGlvbiAoKSB7XG4gICAgdmFyIHNlbGYgPSB0aGlzO1xuXG4gICAgLy8gRGVzdHJveSB0aGlzIHNlc3Npb24sIGV2ZW4gaWYgaXQncyBub3QgcmVnaXN0ZXJlZCBhdCB0aGVcbiAgICAvLyBzZXJ2ZXIuIFN0b3AgYWxsIHByb2Nlc3NpbmcgYW5kIHRlYXIgZXZlcnl0aGluZyBkb3duLiBJZiBhIHNvY2tldFxuICAgIC8vIHdhcyBhdHRhY2hlZCwgY2xvc2UgaXQuXG5cbiAgICAvLyBBbHJlYWR5IGRlc3Ryb3llZC5cbiAgICBpZiAoISBzZWxmLmluUXVldWUpXG4gICAgICByZXR1cm47XG5cbiAgICAvLyBEcm9wIHRoZSBtZXJnZSBib3ggZGF0YSBpbW1lZGlhdGVseS5cbiAgICBzZWxmLmluUXVldWUgPSBudWxsO1xuICAgIHNlbGYuY29sbGVjdGlvblZpZXdzID0gbmV3IE1hcCgpO1xuXG4gICAgaWYgKHNlbGYuaGVhcnRiZWF0KSB7XG4gICAgICBzZWxmLmhlYXJ0YmVhdC5zdG9wKCk7XG4gICAgICBzZWxmLmhlYXJ0YmVhdCA9IG51bGw7XG4gICAgfVxuXG4gICAgaWYgKHNlbGYuc29ja2V0KSB7XG4gICAgICBzZWxmLnNvY2tldC5jbG9zZSgpO1xuICAgICAgc2VsZi5zb2NrZXQuX21ldGVvclNlc3Npb24gPSBudWxsO1xuICAgIH1cblxuICAgIFBhY2thZ2VbJ2ZhY3RzLWJhc2UnXSAmJiBQYWNrYWdlWydmYWN0cy1iYXNlJ10uRmFjdHMuaW5jcmVtZW50U2VydmVyRmFjdChcbiAgICAgIFwibGl2ZWRhdGFcIiwgXCJzZXNzaW9uc1wiLCAtMSk7XG5cbiAgICBNZXRlb3IuZGVmZXIoZnVuY3Rpb24gKCkge1xuICAgICAgLy8gU3RvcCBjYWxsYmFja3MgY2FuIHlpZWxkLCBzbyB3ZSBkZWZlciB0aGlzIG9uIGNsb3NlLlxuICAgICAgLy8gc3ViLl9pc0RlYWN0aXZhdGVkKCkgZGV0ZWN0cyB0aGF0IHdlIHNldCBpblF1ZXVlIHRvIG51bGwgYW5kXG4gICAgICAvLyB0cmVhdHMgaXQgYXMgc2VtaS1kZWFjdGl2YXRlZCAoaXQgd2lsbCBpZ25vcmUgaW5jb21pbmcgY2FsbGJhY2tzLCBldGMpLlxuICAgICAgc2VsZi5fZGVhY3RpdmF0ZUFsbFN1YnNjcmlwdGlvbnMoKTtcblxuICAgICAgLy8gRGVmZXIgY2FsbGluZyB0aGUgY2xvc2UgY2FsbGJhY2tzLCBzbyB0aGF0IHRoZSBjYWxsZXIgY2xvc2luZ1xuICAgICAgLy8gdGhlIHNlc3Npb24gaXNuJ3Qgd2FpdGluZyBmb3IgYWxsIHRoZSBjYWxsYmFja3MgdG8gY29tcGxldGUuXG4gICAgICBfLmVhY2goc2VsZi5fY2xvc2VDYWxsYmFja3MsIGZ1bmN0aW9uIChjYWxsYmFjaykge1xuICAgICAgICBjYWxsYmFjaygpO1xuICAgICAgfSk7XG4gICAgfSk7XG5cbiAgICAvLyBVbnJlZ2lzdGVyIHRoZSBzZXNzaW9uLlxuICAgIHNlbGYuc2VydmVyLl9yZW1vdmVTZXNzaW9uKHNlbGYpO1xuICB9LFxuXG4gIC8vIFNlbmQgYSBtZXNzYWdlIChkb2luZyBub3RoaW5nIGlmIG5vIHNvY2tldCBpcyBjb25uZWN0ZWQgcmlnaHQgbm93KS5cbiAgLy8gSXQgc2hvdWxkIGJlIGEgSlNPTiBvYmplY3QgKGl0IHdpbGwgYmUgc3RyaW5naWZpZWQpLlxuICBzZW5kOiBmdW5jdGlvbiAobXNnKSB7XG4gICAgdmFyIHNlbGYgPSB0aGlzO1xuICAgIGlmIChzZWxmLnNvY2tldCkge1xuICAgICAgaWYgKE1ldGVvci5fcHJpbnRTZW50RERQKVxuICAgICAgICBNZXRlb3IuX2RlYnVnKFwiU2VudCBERFBcIiwgRERQQ29tbW9uLnN0cmluZ2lmeUREUChtc2cpKTtcbiAgICAgIHNlbGYuc29ja2V0LnNlbmQoRERQQ29tbW9uLnN0cmluZ2lmeUREUChtc2cpKTtcbiAgICB9XG4gIH0sXG5cbiAgLy8gU2VuZCBhIGNvbm5lY3Rpb24gZXJyb3IuXG4gIHNlbmRFcnJvcjogZnVuY3Rpb24gKHJlYXNvbiwgb2ZmZW5kaW5nTWVzc2FnZSkge1xuICAgIHZhciBzZWxmID0gdGhpcztcbiAgICB2YXIgbXNnID0ge21zZzogJ2Vycm9yJywgcmVhc29uOiByZWFzb259O1xuICAgIGlmIChvZmZlbmRpbmdNZXNzYWdlKVxuICAgICAgbXNnLm9mZmVuZGluZ01lc3NhZ2UgPSBvZmZlbmRpbmdNZXNzYWdlO1xuICAgIHNlbGYuc2VuZChtc2cpO1xuICB9LFxuXG4gIC8vIFByb2Nlc3MgJ21zZycgYXMgYW4gaW5jb21pbmcgbWVzc2FnZS4gQXMgYSBndWFyZCBhZ2FpbnN0XG4gIC8vIHJhY2UgY29uZGl0aW9ucyBkdXJpbmcgcmVjb25uZWN0aW9uLCBpZ25vcmUgdGhlIG1lc3NhZ2UgaWZcbiAgLy8gJ3NvY2tldCcgaXMgbm90IHRoZSBjdXJyZW50bHkgY29ubmVjdGVkIHNvY2tldC5cbiAgLy9cbiAgLy8gV2UgcnVuIHRoZSBtZXNzYWdlcyBmcm9tIHRoZSBjbGllbnQgb25lIGF0IGEgdGltZSwgaW4gdGhlIG9yZGVyXG4gIC8vIGdpdmVuIGJ5IHRoZSBjbGllbnQuIFRoZSBtZXNzYWdlIGhhbmRsZXIgaXMgcGFzc2VkIGFuIGlkZW1wb3RlbnRcbiAgLy8gZnVuY3Rpb24gJ3VuYmxvY2snIHdoaWNoIGl0IG1heSBjYWxsIHRvIGFsbG93IG90aGVyIG1lc3NhZ2VzIHRvXG4gIC8vIGJlZ2luIHJ1bm5pbmcgaW4gcGFyYWxsZWwgaW4gYW5vdGhlciBmaWJlciAoZm9yIGV4YW1wbGUsIGEgbWV0aG9kXG4gIC8vIHRoYXQgd2FudHMgdG8geWllbGQpLiBPdGhlcndpc2UsIGl0IGlzIGF1dG9tYXRpY2FsbHkgdW5ibG9ja2VkXG4gIC8vIHdoZW4gaXQgcmV0dXJucy5cbiAgLy9cbiAgLy8gQWN0dWFsbHksIHdlIGRvbid0IGhhdmUgdG8gJ3RvdGFsbHkgb3JkZXInIHRoZSBtZXNzYWdlcyBpbiB0aGlzXG4gIC8vIHdheSwgYnV0IGl0J3MgdGhlIGVhc2llc3QgdGhpbmcgdGhhdCdzIGNvcnJlY3QuICh1bnN1YiBuZWVkcyB0b1xuICAvLyBiZSBvcmRlcmVkIGFnYWluc3Qgc3ViLCBtZXRob2RzIG5lZWQgdG8gYmUgb3JkZXJlZCBhZ2FpbnN0IGVhY2hcbiAgLy8gb3RoZXIpLlxuICBwcm9jZXNzTWVzc2FnZTogZnVuY3Rpb24gKG1zZ19pbikge1xuICAgIHZhciBzZWxmID0gdGhpcztcbiAgICBpZiAoIXNlbGYuaW5RdWV1ZSkgLy8gd2UgaGF2ZSBiZWVuIGRlc3Ryb3llZC5cbiAgICAgIHJldHVybjtcblxuICAgIC8vIFJlc3BvbmQgdG8gcGluZyBhbmQgcG9uZyBtZXNzYWdlcyBpbW1lZGlhdGVseSB3aXRob3V0IHF1ZXVpbmcuXG4gICAgLy8gSWYgdGhlIG5lZ290aWF0ZWQgRERQIHZlcnNpb24gaXMgXCJwcmUxXCIgd2hpY2ggZGlkbid0IHN1cHBvcnRcbiAgICAvLyBwaW5ncywgcHJlc2VydmUgdGhlIFwicHJlMVwiIGJlaGF2aW9yIG9mIHJlc3BvbmRpbmcgd2l0aCBhIFwiYmFkXG4gICAgLy8gcmVxdWVzdFwiIGZvciB0aGUgdW5rbm93biBtZXNzYWdlcy5cbiAgICAvL1xuICAgIC8vIEZpYmVycyBhcmUgbmVlZGVkIGJlY2F1c2UgaGVhcnRiZWF0cyB1c2UgTWV0ZW9yLnNldFRpbWVvdXQsIHdoaWNoXG4gICAgLy8gbmVlZHMgYSBGaWJlci4gV2UgY291bGQgYWN0dWFsbHkgdXNlIHJlZ3VsYXIgc2V0VGltZW91dCBhbmQgYXZvaWRcbiAgICAvLyB0aGVzZSBuZXcgZmliZXJzLCBidXQgaXQgaXMgZWFzaWVyIHRvIGp1c3QgbWFrZSBldmVyeXRoaW5nIHVzZVxuICAgIC8vIE1ldGVvci5zZXRUaW1lb3V0IGFuZCBub3QgdGhpbmsgdG9vIGhhcmQuXG4gICAgLy9cbiAgICAvLyBBbnkgbWVzc2FnZSBjb3VudHMgYXMgcmVjZWl2aW5nIGEgcG9uZywgYXMgaXQgZGVtb25zdHJhdGVzIHRoYXRcbiAgICAvLyB0aGUgY2xpZW50IGlzIHN0aWxsIGFsaXZlLlxuICAgIGlmIChzZWxmLmhlYXJ0YmVhdCkge1xuICAgICAgRmliZXIoZnVuY3Rpb24gKCkge1xuICAgICAgICBzZWxmLmhlYXJ0YmVhdC5tZXNzYWdlUmVjZWl2ZWQoKTtcbiAgICAgIH0pLnJ1bigpO1xuICAgIH1cblxuICAgIGlmIChzZWxmLnZlcnNpb24gIT09ICdwcmUxJyAmJiBtc2dfaW4ubXNnID09PSAncGluZycpIHtcbiAgICAgIGlmIChzZWxmLl9yZXNwb25kVG9QaW5ncylcbiAgICAgICAgc2VsZi5zZW5kKHttc2c6IFwicG9uZ1wiLCBpZDogbXNnX2luLmlkfSk7XG4gICAgICByZXR1cm47XG4gICAgfVxuICAgIGlmIChzZWxmLnZlcnNpb24gIT09ICdwcmUxJyAmJiBtc2dfaW4ubXNnID09PSAncG9uZycpIHtcbiAgICAgIC8vIFNpbmNlIGV2ZXJ5dGhpbmcgaXMgYSBwb25nLCB0aGVyZSBpcyBub3RoaW5nIHRvIGRvXG4gICAgICByZXR1cm47XG4gICAgfVxuXG4gICAgc2VsZi5pblF1ZXVlLnB1c2gobXNnX2luKTtcbiAgICBpZiAoc2VsZi53b3JrZXJSdW5uaW5nKVxuICAgICAgcmV0dXJuO1xuICAgIHNlbGYud29ya2VyUnVubmluZyA9IHRydWU7XG5cbiAgICB2YXIgcHJvY2Vzc05leHQgPSBmdW5jdGlvbiAoKSB7XG4gICAgICB2YXIgbXNnID0gc2VsZi5pblF1ZXVlICYmIHNlbGYuaW5RdWV1ZS5zaGlmdCgpO1xuICAgICAgaWYgKCFtc2cpIHtcbiAgICAgICAgc2VsZi53b3JrZXJSdW5uaW5nID0gZmFsc2U7XG4gICAgICAgIHJldHVybjtcbiAgICAgIH1cblxuICAgICAgRmliZXIoZnVuY3Rpb24gKCkge1xuICAgICAgICB2YXIgYmxvY2tlZCA9IHRydWU7XG5cbiAgICAgICAgdmFyIHVuYmxvY2sgPSBmdW5jdGlvbiAoKSB7XG4gICAgICAgICAgaWYgKCFibG9ja2VkKVxuICAgICAgICAgICAgcmV0dXJuOyAvLyBpZGVtcG90ZW50XG4gICAgICAgICAgYmxvY2tlZCA9IGZhbHNlO1xuICAgICAgICAgIHByb2Nlc3NOZXh0KCk7XG4gICAgICAgIH07XG5cbiAgICAgICAgc2VsZi5zZXJ2ZXIub25NZXNzYWdlSG9vay5lYWNoKGZ1bmN0aW9uIChjYWxsYmFjaykge1xuICAgICAgICAgIGNhbGxiYWNrKG1zZywgc2VsZik7XG4gICAgICAgICAgcmV0dXJuIHRydWU7XG4gICAgICAgIH0pO1xuXG4gICAgICAgIGlmIChfLmhhcyhzZWxmLnByb3RvY29sX2hhbmRsZXJzLCBtc2cubXNnKSlcbiAgICAgICAgICBzZWxmLnByb3RvY29sX2hhbmRsZXJzW21zZy5tc2ddLmNhbGwoc2VsZiwgbXNnLCB1bmJsb2NrKTtcbiAgICAgICAgZWxzZVxuICAgICAgICAgIHNlbGYuc2VuZEVycm9yKCdCYWQgcmVxdWVzdCcsIG1zZyk7XG4gICAgICAgIHVuYmxvY2soKTsgLy8gaW4gY2FzZSB0aGUgaGFuZGxlciBkaWRuJ3QgYWxyZWFkeSBkbyBpdFxuICAgICAgfSkucnVuKCk7XG4gICAgfTtcblxuICAgIHByb2Nlc3NOZXh0KCk7XG4gIH0sXG5cbiAgcHJvdG9jb2xfaGFuZGxlcnM6IHtcbiAgICBzdWI6IGZ1bmN0aW9uIChtc2csIHVuYmxvY2spIHtcbiAgICAgIHZhciBzZWxmID0gdGhpcztcblxuICAgICAgLy8gY2FjaGVVbmJsb2NrIHRlbXBvcmFybHksIHNvIHdlIGNhbiBjYXB0dXJlIGl0IGxhdGVyXG4gICAgICAvLyB3ZSB3aWxsIHVzZSB1bmJsb2NrIGluIGN1cnJlbnQgZXZlbnRMb29wLCBzbyB0aGlzIGlzIHNhZmVcbiAgICAgIHNlbGYuY2FjaGVkVW5ibG9jayA9IHVuYmxvY2s7XG5cbiAgICAgIC8vIHJlamVjdCBtYWxmb3JtZWQgbWVzc2FnZXNcbiAgICAgIGlmICh0eXBlb2YgKG1zZy5pZCkgIT09IFwic3RyaW5nXCIgfHxcbiAgICAgICAgICB0eXBlb2YgKG1zZy5uYW1lKSAhPT0gXCJzdHJpbmdcIiB8fFxuICAgICAgICAgICgoJ3BhcmFtcycgaW4gbXNnKSAmJiAhKG1zZy5wYXJhbXMgaW5zdGFuY2VvZiBBcnJheSkpKSB7XG4gICAgICAgIHNlbGYuc2VuZEVycm9yKFwiTWFsZm9ybWVkIHN1YnNjcmlwdGlvblwiLCBtc2cpO1xuICAgICAgICByZXR1cm47XG4gICAgICB9XG5cbiAgICAgIGlmICghc2VsZi5zZXJ2ZXIucHVibGlzaF9oYW5kbGVyc1ttc2cubmFtZV0pIHtcbiAgICAgICAgc2VsZi5zZW5kKHtcbiAgICAgICAgICBtc2c6ICdub3N1YicsIGlkOiBtc2cuaWQsXG4gICAgICAgICAgZXJyb3I6IG5ldyBNZXRlb3IuRXJyb3IoNDA0LCBgU3Vic2NyaXB0aW9uICcke21zZy5uYW1lfScgbm90IGZvdW5kYCl9KTtcbiAgICAgICAgcmV0dXJuO1xuICAgICAgfVxuXG4gICAgICBpZiAoc2VsZi5fbmFtZWRTdWJzLmhhcyhtc2cuaWQpKVxuICAgICAgICAvLyBzdWJzIGFyZSBpZGVtcG90ZW50LCBvciByYXRoZXIsIHRoZXkgYXJlIGlnbm9yZWQgaWYgYSBzdWJcbiAgICAgICAgLy8gd2l0aCB0aGF0IGlkIGFscmVhZHkgZXhpc3RzLiB0aGlzIGlzIGltcG9ydGFudCBkdXJpbmdcbiAgICAgICAgLy8gcmVjb25uZWN0LlxuICAgICAgICByZXR1cm47XG5cbiAgICAgIC8vIFhYWCBJdCdkIGJlIG11Y2ggYmV0dGVyIGlmIHdlIGhhZCBnZW5lcmljIGhvb2tzIHdoZXJlIGFueSBwYWNrYWdlIGNhblxuICAgICAgLy8gaG9vayBpbnRvIHN1YnNjcmlwdGlvbiBoYW5kbGluZywgYnV0IGluIHRoZSBtZWFuIHdoaWxlIHdlIHNwZWNpYWwgY2FzZVxuICAgICAgLy8gZGRwLXJhdGUtbGltaXRlciBwYWNrYWdlLiBUaGlzIGlzIGFsc28gZG9uZSBmb3Igd2VhayByZXF1aXJlbWVudHMgdG9cbiAgICAgIC8vIGFkZCB0aGUgZGRwLXJhdGUtbGltaXRlciBwYWNrYWdlIGluIGNhc2Ugd2UgZG9uJ3QgaGF2ZSBBY2NvdW50cy4gQVxuICAgICAgLy8gdXNlciB0cnlpbmcgdG8gdXNlIHRoZSBkZHAtcmF0ZS1saW1pdGVyIG11c3QgZXhwbGljaXRseSByZXF1aXJlIGl0LlxuICAgICAgaWYgKFBhY2thZ2VbJ2RkcC1yYXRlLWxpbWl0ZXInXSkge1xuICAgICAgICB2YXIgRERQUmF0ZUxpbWl0ZXIgPSBQYWNrYWdlWydkZHAtcmF0ZS1saW1pdGVyJ10uRERQUmF0ZUxpbWl0ZXI7XG4gICAgICAgIHZhciByYXRlTGltaXRlcklucHV0ID0ge1xuICAgICAgICAgIHVzZXJJZDogc2VsZi51c2VySWQsXG4gICAgICAgICAgY2xpZW50QWRkcmVzczogc2VsZi5jb25uZWN0aW9uSGFuZGxlLmNsaWVudEFkZHJlc3MsXG4gICAgICAgICAgdHlwZTogXCJzdWJzY3JpcHRpb25cIixcbiAgICAgICAgICBuYW1lOiBtc2cubmFtZSxcbiAgICAgICAgICBjb25uZWN0aW9uSWQ6IHNlbGYuaWRcbiAgICAgICAgfTtcblxuICAgICAgICBERFBSYXRlTGltaXRlci5faW5jcmVtZW50KHJhdGVMaW1pdGVySW5wdXQpO1xuICAgICAgICB2YXIgcmF0ZUxpbWl0UmVzdWx0ID0gRERQUmF0ZUxpbWl0ZXIuX2NoZWNrKHJhdGVMaW1pdGVySW5wdXQpO1xuICAgICAgICBpZiAoIXJhdGVMaW1pdFJlc3VsdC5hbGxvd2VkKSB7XG4gICAgICAgICAgc2VsZi5zZW5kKHtcbiAgICAgICAgICAgIG1zZzogJ25vc3ViJywgaWQ6IG1zZy5pZCxcbiAgICAgICAgICAgIGVycm9yOiBuZXcgTWV0ZW9yLkVycm9yKFxuICAgICAgICAgICAgICAndG9vLW1hbnktcmVxdWVzdHMnLFxuICAgICAgICAgICAgICBERFBSYXRlTGltaXRlci5nZXRFcnJvck1lc3NhZ2UocmF0ZUxpbWl0UmVzdWx0KSxcbiAgICAgICAgICAgICAge3RpbWVUb1Jlc2V0OiByYXRlTGltaXRSZXN1bHQudGltZVRvUmVzZXR9KVxuICAgICAgICAgIH0pO1xuICAgICAgICAgIHJldHVybjtcbiAgICAgICAgfVxuICAgICAgfVxuXG4gICAgICB2YXIgaGFuZGxlciA9IHNlbGYuc2VydmVyLnB1Ymxpc2hfaGFuZGxlcnNbbXNnLm5hbWVdO1xuXG4gICAgICBzZWxmLl9zdGFydFN1YnNjcmlwdGlvbihoYW5kbGVyLCBtc2cuaWQsIG1zZy5wYXJhbXMsIG1zZy5uYW1lKTtcblxuICAgICAgLy8gY2xlYW5pbmcgY2FjaGVkIHVuYmxvY2tcbiAgICAgIHNlbGYuY2FjaGVkVW5ibG9jayA9IG51bGw7XG4gICAgfSxcblxuICAgIHVuc3ViOiBmdW5jdGlvbiAobXNnKSB7XG4gICAgICB2YXIgc2VsZiA9IHRoaXM7XG5cbiAgICAgIHNlbGYuX3N0b3BTdWJzY3JpcHRpb24obXNnLmlkKTtcbiAgICB9LFxuXG4gICAgbWV0aG9kOiBmdW5jdGlvbiAobXNnLCB1bmJsb2NrKSB7XG4gICAgICB2YXIgc2VsZiA9IHRoaXM7XG5cbiAgICAgIC8vIFJlamVjdCBtYWxmb3JtZWQgbWVzc2FnZXMuXG4gICAgICAvLyBGb3Igbm93LCB3ZSBzaWxlbnRseSBpZ25vcmUgdW5rbm93biBhdHRyaWJ1dGVzLFxuICAgICAgLy8gZm9yIGZvcndhcmRzIGNvbXBhdGliaWxpdHkuXG4gICAgICBpZiAodHlwZW9mIChtc2cuaWQpICE9PSBcInN0cmluZ1wiIHx8XG4gICAgICAgICAgdHlwZW9mIChtc2cubWV0aG9kKSAhPT0gXCJzdHJpbmdcIiB8fFxuICAgICAgICAgICgoJ3BhcmFtcycgaW4gbXNnKSAmJiAhKG1zZy5wYXJhbXMgaW5zdGFuY2VvZiBBcnJheSkpIHx8XG4gICAgICAgICAgKCgncmFuZG9tU2VlZCcgaW4gbXNnKSAmJiAodHlwZW9mIG1zZy5yYW5kb21TZWVkICE9PSBcInN0cmluZ1wiKSkpIHtcbiAgICAgICAgc2VsZi5zZW5kRXJyb3IoXCJNYWxmb3JtZWQgbWV0aG9kIGludm9jYXRpb25cIiwgbXNnKTtcbiAgICAgICAgcmV0dXJuO1xuICAgICAgfVxuXG4gICAgICB2YXIgcmFuZG9tU2VlZCA9IG1zZy5yYW5kb21TZWVkIHx8IG51bGw7XG5cbiAgICAgIC8vIFNldCB1cCB0byBtYXJrIHRoZSBtZXRob2QgYXMgc2F0aXNmaWVkIG9uY2UgYWxsIG9ic2VydmVyc1xuICAgICAgLy8gKGFuZCBzdWJzY3JpcHRpb25zKSBoYXZlIHJlYWN0ZWQgdG8gYW55IHdyaXRlcyB0aGF0IHdlcmVcbiAgICAgIC8vIGRvbmUuXG4gICAgICB2YXIgZmVuY2UgPSBuZXcgRERQU2VydmVyLl9Xcml0ZUZlbmNlO1xuICAgICAgZmVuY2Uub25BbGxDb21taXR0ZWQoZnVuY3Rpb24gKCkge1xuICAgICAgICAvLyBSZXRpcmUgdGhlIGZlbmNlIHNvIHRoYXQgZnV0dXJlIHdyaXRlcyBhcmUgYWxsb3dlZC5cbiAgICAgICAgLy8gVGhpcyBtZWFucyB0aGF0IGNhbGxiYWNrcyBsaWtlIHRpbWVycyBhcmUgZnJlZSB0byB1c2VcbiAgICAgICAgLy8gdGhlIGZlbmNlLCBhbmQgaWYgdGhleSBmaXJlIGJlZm9yZSBpdCdzIGFybWVkIChmb3JcbiAgICAgICAgLy8gZXhhbXBsZSwgYmVjYXVzZSB0aGUgbWV0aG9kIHdhaXRzIGZvciB0aGVtKSB0aGVpclxuICAgICAgICAvLyB3cml0ZXMgd2lsbCBiZSBpbmNsdWRlZCBpbiB0aGUgZmVuY2UuXG4gICAgICAgIGZlbmNlLnJldGlyZSgpO1xuICAgICAgICBzZWxmLnNlbmQoe1xuICAgICAgICAgIG1zZzogJ3VwZGF0ZWQnLCBtZXRob2RzOiBbbXNnLmlkXX0pO1xuICAgICAgfSk7XG5cbiAgICAgIC8vIEZpbmQgdGhlIGhhbmRsZXJcbiAgICAgIHZhciBoYW5kbGVyID0gc2VsZi5zZXJ2ZXIubWV0aG9kX2hhbmRsZXJzW21zZy5tZXRob2RdO1xuICAgICAgaWYgKCFoYW5kbGVyKSB7XG4gICAgICAgIHNlbGYuc2VuZCh7XG4gICAgICAgICAgbXNnOiAncmVzdWx0JywgaWQ6IG1zZy5pZCxcbiAgICAgICAgICBlcnJvcjogbmV3IE1ldGVvci5FcnJvcig0MDQsIGBNZXRob2QgJyR7bXNnLm1ldGhvZH0nIG5vdCBmb3VuZGApfSk7XG4gICAgICAgIGZlbmNlLmFybSgpO1xuICAgICAgICByZXR1cm47XG4gICAgICB9XG5cbiAgICAgIHZhciBzZXRVc2VySWQgPSBmdW5jdGlvbih1c2VySWQpIHtcbiAgICAgICAgc2VsZi5fc2V0VXNlcklkKHVzZXJJZCk7XG4gICAgICB9O1xuXG4gICAgICB2YXIgaW52b2NhdGlvbiA9IG5ldyBERFBDb21tb24uTWV0aG9kSW52b2NhdGlvbih7XG4gICAgICAgIGlzU2ltdWxhdGlvbjogZmFsc2UsXG4gICAgICAgIHVzZXJJZDogc2VsZi51c2VySWQsXG4gICAgICAgIHNldFVzZXJJZDogc2V0VXNlcklkLFxuICAgICAgICB1bmJsb2NrOiB1bmJsb2NrLFxuICAgICAgICBjb25uZWN0aW9uOiBzZWxmLmNvbm5lY3Rpb25IYW5kbGUsXG4gICAgICAgIHJhbmRvbVNlZWQ6IHJhbmRvbVNlZWRcbiAgICAgIH0pO1xuXG4gICAgICBjb25zdCBwcm9taXNlID0gbmV3IFByb21pc2UoKHJlc29sdmUsIHJlamVjdCkgPT4ge1xuICAgICAgICAvLyBYWFggSXQnZCBiZSBiZXR0ZXIgaWYgd2UgY291bGQgaG9vayBpbnRvIG1ldGhvZCBoYW5kbGVycyBiZXR0ZXIgYnV0XG4gICAgICAgIC8vIGZvciBub3csIHdlIG5lZWQgdG8gY2hlY2sgaWYgdGhlIGRkcC1yYXRlLWxpbWl0ZXIgZXhpc3RzIHNpbmNlIHdlXG4gICAgICAgIC8vIGhhdmUgYSB3ZWFrIHJlcXVpcmVtZW50IGZvciB0aGUgZGRwLXJhdGUtbGltaXRlciBwYWNrYWdlIHRvIGJlIGFkZGVkXG4gICAgICAgIC8vIHRvIG91ciBhcHBsaWNhdGlvbi5cbiAgICAgICAgaWYgKFBhY2thZ2VbJ2RkcC1yYXRlLWxpbWl0ZXInXSkge1xuICAgICAgICAgIHZhciBERFBSYXRlTGltaXRlciA9IFBhY2thZ2VbJ2RkcC1yYXRlLWxpbWl0ZXInXS5ERFBSYXRlTGltaXRlcjtcbiAgICAgICAgICB2YXIgcmF0ZUxpbWl0ZXJJbnB1dCA9IHtcbiAgICAgICAgICAgIHVzZXJJZDogc2VsZi51c2VySWQsXG4gICAgICAgICAgICBjbGllbnRBZGRyZXNzOiBzZWxmLmNvbm5lY3Rpb25IYW5kbGUuY2xpZW50QWRkcmVzcyxcbiAgICAgICAgICAgIHR5cGU6IFwibWV0aG9kXCIsXG4gICAgICAgICAgICBuYW1lOiBtc2cubWV0aG9kLFxuICAgICAgICAgICAgY29ubmVjdGlvbklkOiBzZWxmLmlkXG4gICAgICAgICAgfTtcbiAgICAgICAgICBERFBSYXRlTGltaXRlci5faW5jcmVtZW50KHJhdGVMaW1pdGVySW5wdXQpO1xuICAgICAgICAgIHZhciByYXRlTGltaXRSZXN1bHQgPSBERFBSYXRlTGltaXRlci5fY2hlY2socmF0ZUxpbWl0ZXJJbnB1dClcbiAgICAgICAgICBpZiAoIXJhdGVMaW1pdFJlc3VsdC5hbGxvd2VkKSB7XG4gICAgICAgICAgICByZWplY3QobmV3IE1ldGVvci5FcnJvcihcbiAgICAgICAgICAgICAgXCJ0b28tbWFueS1yZXF1ZXN0c1wiLFxuICAgICAgICAgICAgICBERFBSYXRlTGltaXRlci5nZXRFcnJvck1lc3NhZ2UocmF0ZUxpbWl0UmVzdWx0KSxcbiAgICAgICAgICAgICAge3RpbWVUb1Jlc2V0OiByYXRlTGltaXRSZXN1bHQudGltZVRvUmVzZXR9XG4gICAgICAgICAgICApKTtcbiAgICAgICAgICAgIHJldHVybjtcbiAgICAgICAgICB9XG4gICAgICAgIH1cblxuICAgICAgICByZXNvbHZlKEREUFNlcnZlci5fQ3VycmVudFdyaXRlRmVuY2Uud2l0aFZhbHVlKFxuICAgICAgICAgIGZlbmNlLFxuICAgICAgICAgICgpID0+IEREUC5fQ3VycmVudE1ldGhvZEludm9jYXRpb24ud2l0aFZhbHVlKFxuICAgICAgICAgICAgaW52b2NhdGlvbixcbiAgICAgICAgICAgICgpID0+IG1heWJlQXVkaXRBcmd1bWVudENoZWNrcyhcbiAgICAgICAgICAgICAgaGFuZGxlciwgaW52b2NhdGlvbiwgbXNnLnBhcmFtcyxcbiAgICAgICAgICAgICAgXCJjYWxsIHRvICdcIiArIG1zZy5tZXRob2QgKyBcIidcIlxuICAgICAgICAgICAgKVxuICAgICAgICAgIClcbiAgICAgICAgKSk7XG4gICAgICB9KTtcblxuICAgICAgZnVuY3Rpb24gZmluaXNoKCkge1xuICAgICAgICBmZW5jZS5hcm0oKTtcbiAgICAgICAgdW5ibG9jaygpO1xuICAgICAgfVxuXG4gICAgICBjb25zdCBwYXlsb2FkID0ge1xuICAgICAgICBtc2c6IFwicmVzdWx0XCIsXG4gICAgICAgIGlkOiBtc2cuaWRcbiAgICAgIH07XG5cbiAgICAgIHByb21pc2UudGhlbigocmVzdWx0KSA9PiB7XG4gICAgICAgIGZpbmlzaCgpO1xuICAgICAgICBpZiAocmVzdWx0ICE9PSB1bmRlZmluZWQpIHtcbiAgICAgICAgICBwYXlsb2FkLnJlc3VsdCA9IHJlc3VsdDtcbiAgICAgICAgfVxuICAgICAgICBzZWxmLnNlbmQocGF5bG9hZCk7XG4gICAgICB9LCAoZXhjZXB0aW9uKSA9PiB7XG4gICAgICAgIGZpbmlzaCgpO1xuICAgICAgICBwYXlsb2FkLmVycm9yID0gd3JhcEludGVybmFsRXhjZXB0aW9uKFxuICAgICAgICAgIGV4Y2VwdGlvbixcbiAgICAgICAgICBgd2hpbGUgaW52b2tpbmcgbWV0aG9kICcke21zZy5tZXRob2R9J2BcbiAgICAgICAgKTtcbiAgICAgICAgc2VsZi5zZW5kKHBheWxvYWQpO1xuICAgICAgfSk7XG4gICAgfVxuICB9LFxuXG4gIF9lYWNoU3ViOiBmdW5jdGlvbiAoZikge1xuICAgIHZhciBzZWxmID0gdGhpcztcbiAgICBzZWxmLl9uYW1lZFN1YnMuZm9yRWFjaChmKTtcbiAgICBzZWxmLl91bml2ZXJzYWxTdWJzLmZvckVhY2goZik7XG4gIH0sXG5cbiAgX2RpZmZDb2xsZWN0aW9uVmlld3M6IGZ1bmN0aW9uIChiZWZvcmVDVnMpIHtcbiAgICB2YXIgc2VsZiA9IHRoaXM7XG4gICAgRGlmZlNlcXVlbmNlLmRpZmZNYXBzKGJlZm9yZUNWcywgc2VsZi5jb2xsZWN0aW9uVmlld3MsIHtcbiAgICAgIGJvdGg6IGZ1bmN0aW9uIChjb2xsZWN0aW9uTmFtZSwgbGVmdFZhbHVlLCByaWdodFZhbHVlKSB7XG4gICAgICAgIHJpZ2h0VmFsdWUuZGlmZihsZWZ0VmFsdWUpO1xuICAgICAgfSxcbiAgICAgIHJpZ2h0T25seTogZnVuY3Rpb24gKGNvbGxlY3Rpb25OYW1lLCByaWdodFZhbHVlKSB7XG4gICAgICAgIHJpZ2h0VmFsdWUuZG9jdW1lbnRzLmZvckVhY2goZnVuY3Rpb24gKGRvY1ZpZXcsIGlkKSB7XG4gICAgICAgICAgc2VsZi5zZW5kQWRkZWQoY29sbGVjdGlvbk5hbWUsIGlkLCBkb2NWaWV3LmdldEZpZWxkcygpKTtcbiAgICAgICAgfSk7XG4gICAgICB9LFxuICAgICAgbGVmdE9ubHk6IGZ1bmN0aW9uIChjb2xsZWN0aW9uTmFtZSwgbGVmdFZhbHVlKSB7XG4gICAgICAgIGxlZnRWYWx1ZS5kb2N1bWVudHMuZm9yRWFjaChmdW5jdGlvbiAoZG9jLCBpZCkge1xuICAgICAgICAgIHNlbGYuc2VuZFJlbW92ZWQoY29sbGVjdGlvbk5hbWUsIGlkKTtcbiAgICAgICAgfSk7XG4gICAgICB9XG4gICAgfSk7XG4gIH0sXG5cbiAgLy8gU2V0cyB0aGUgY3VycmVudCB1c2VyIGlkIGluIGFsbCBhcHByb3ByaWF0ZSBjb250ZXh0cyBhbmQgcmVydW5zXG4gIC8vIGFsbCBzdWJzY3JpcHRpb25zXG4gIF9zZXRVc2VySWQ6IGZ1bmN0aW9uKHVzZXJJZCkge1xuICAgIHZhciBzZWxmID0gdGhpcztcblxuICAgIGlmICh1c2VySWQgIT09IG51bGwgJiYgdHlwZW9mIHVzZXJJZCAhPT0gXCJzdHJpbmdcIilcbiAgICAgIHRocm93IG5ldyBFcnJvcihcInNldFVzZXJJZCBtdXN0IGJlIGNhbGxlZCBvbiBzdHJpbmcgb3IgbnVsbCwgbm90IFwiICtcbiAgICAgICAgICAgICAgICAgICAgICB0eXBlb2YgdXNlcklkKTtcblxuICAgIC8vIFByZXZlbnQgbmV3bHktY3JlYXRlZCB1bml2ZXJzYWwgc3Vic2NyaXB0aW9ucyBmcm9tIGJlaW5nIGFkZGVkIHRvIG91clxuICAgIC8vIHNlc3Npb24uIFRoZXkgd2lsbCBiZSBmb3VuZCBiZWxvdyB3aGVuIHdlIGNhbGwgc3RhcnRVbml2ZXJzYWxTdWJzLlxuICAgIC8vXG4gICAgLy8gKFdlIGRvbid0IGhhdmUgdG8gd29ycnkgYWJvdXQgbmFtZWQgc3Vic2NyaXB0aW9ucywgYmVjYXVzZSB3ZSBvbmx5IGFkZFxuICAgIC8vIHRoZW0gd2hlbiB3ZSBwcm9jZXNzIGEgJ3N1YicgbWVzc2FnZS4gV2UgYXJlIGN1cnJlbnRseSBwcm9jZXNzaW5nIGFcbiAgICAvLyAnbWV0aG9kJyBtZXNzYWdlLCBhbmQgdGhlIG1ldGhvZCBkaWQgbm90IHVuYmxvY2ssIGJlY2F1c2UgaXQgaXMgaWxsZWdhbFxuICAgIC8vIHRvIGNhbGwgc2V0VXNlcklkIGFmdGVyIHVuYmxvY2suIFRodXMgd2UgY2Fubm90IGJlIGNvbmN1cnJlbnRseSBhZGRpbmcgYVxuICAgIC8vIG5ldyBuYW1lZCBzdWJzY3JpcHRpb24pLlxuICAgIHNlbGYuX2RvbnRTdGFydE5ld1VuaXZlcnNhbFN1YnMgPSB0cnVlO1xuXG4gICAgLy8gUHJldmVudCBjdXJyZW50IHN1YnMgZnJvbSB1cGRhdGluZyBvdXIgY29sbGVjdGlvblZpZXdzIGFuZCBjYWxsIHRoZWlyXG4gICAgLy8gc3RvcCBjYWxsYmFja3MuIFRoaXMgbWF5IHlpZWxkLlxuICAgIHNlbGYuX2VhY2hTdWIoZnVuY3Rpb24gKHN1Yikge1xuICAgICAgc3ViLl9kZWFjdGl2YXRlKCk7XG4gICAgfSk7XG5cbiAgICAvLyBBbGwgc3VicyBzaG91bGQgbm93IGJlIGRlYWN0aXZhdGVkLiBTdG9wIHNlbmRpbmcgbWVzc2FnZXMgdG8gdGhlIGNsaWVudCxcbiAgICAvLyBzYXZlIHRoZSBzdGF0ZSBvZiB0aGUgcHVibGlzaGVkIGNvbGxlY3Rpb25zLCByZXNldCB0byBhbiBlbXB0eSB2aWV3LCBhbmRcbiAgICAvLyB1cGRhdGUgdGhlIHVzZXJJZC5cbiAgICBzZWxmLl9pc1NlbmRpbmcgPSBmYWxzZTtcbiAgICB2YXIgYmVmb3JlQ1ZzID0gc2VsZi5jb2xsZWN0aW9uVmlld3M7XG4gICAgc2VsZi5jb2xsZWN0aW9uVmlld3MgPSBuZXcgTWFwKCk7XG4gICAgc2VsZi51c2VySWQgPSB1c2VySWQ7XG5cbiAgICAvLyBfc2V0VXNlcklkIGlzIG5vcm1hbGx5IGNhbGxlZCBmcm9tIGEgTWV0ZW9yIG1ldGhvZCB3aXRoXG4gICAgLy8gRERQLl9DdXJyZW50TWV0aG9kSW52b2NhdGlvbiBzZXQuIEJ1dCBERFAuX0N1cnJlbnRNZXRob2RJbnZvY2F0aW9uIGlzIG5vdFxuICAgIC8vIGV4cGVjdGVkIHRvIGJlIHNldCBpbnNpZGUgYSBwdWJsaXNoIGZ1bmN0aW9uLCBzbyB3ZSB0ZW1wb3JhcnkgdW5zZXQgaXQuXG4gICAgLy8gSW5zaWRlIGEgcHVibGlzaCBmdW5jdGlvbiBERFAuX0N1cnJlbnRQdWJsaWNhdGlvbkludm9jYXRpb24gaXMgc2V0LlxuICAgIEREUC5fQ3VycmVudE1ldGhvZEludm9jYXRpb24ud2l0aFZhbHVlKHVuZGVmaW5lZCwgZnVuY3Rpb24gKCkge1xuICAgICAgLy8gU2F2ZSB0aGUgb2xkIG5hbWVkIHN1YnMsIGFuZCByZXNldCB0byBoYXZpbmcgbm8gc3Vic2NyaXB0aW9ucy5cbiAgICAgIHZhciBvbGROYW1lZFN1YnMgPSBzZWxmLl9uYW1lZFN1YnM7XG4gICAgICBzZWxmLl9uYW1lZFN1YnMgPSBuZXcgTWFwKCk7XG4gICAgICBzZWxmLl91bml2ZXJzYWxTdWJzID0gW107XG5cbiAgICAgIG9sZE5hbWVkU3Vicy5mb3JFYWNoKGZ1bmN0aW9uIChzdWIsIHN1YnNjcmlwdGlvbklkKSB7XG4gICAgICAgIHZhciBuZXdTdWIgPSBzdWIuX3JlY3JlYXRlKCk7XG4gICAgICAgIHNlbGYuX25hbWVkU3Vicy5zZXQoc3Vic2NyaXB0aW9uSWQsIG5ld1N1Yik7XG4gICAgICAgIC8vIG5iOiBpZiB0aGUgaGFuZGxlciB0aHJvd3Mgb3IgY2FsbHMgdGhpcy5lcnJvcigpLCBpdCB3aWxsIGluIGZhY3RcbiAgICAgICAgLy8gaW1tZWRpYXRlbHkgc2VuZCBpdHMgJ25vc3ViJy4gVGhpcyBpcyBPSywgdGhvdWdoLlxuICAgICAgICBuZXdTdWIuX3J1bkhhbmRsZXIoKTtcbiAgICAgIH0pO1xuXG4gICAgICAvLyBBbGxvdyBuZXdseS1jcmVhdGVkIHVuaXZlcnNhbCBzdWJzIHRvIGJlIHN0YXJ0ZWQgb24gb3VyIGNvbm5lY3Rpb24gaW5cbiAgICAgIC8vIHBhcmFsbGVsIHdpdGggdGhlIG9uZXMgd2UncmUgc3Bpbm5pbmcgdXAgaGVyZSwgYW5kIHNwaW4gdXAgdW5pdmVyc2FsXG4gICAgICAvLyBzdWJzLlxuICAgICAgc2VsZi5fZG9udFN0YXJ0TmV3VW5pdmVyc2FsU3VicyA9IGZhbHNlO1xuICAgICAgc2VsZi5zdGFydFVuaXZlcnNhbFN1YnMoKTtcbiAgICB9KTtcblxuICAgIC8vIFN0YXJ0IHNlbmRpbmcgbWVzc2FnZXMgYWdhaW4sIGJlZ2lubmluZyB3aXRoIHRoZSBkaWZmIGZyb20gdGhlIHByZXZpb3VzXG4gICAgLy8gc3RhdGUgb2YgdGhlIHdvcmxkIHRvIHRoZSBjdXJyZW50IHN0YXRlLiBObyB5aWVsZHMgYXJlIGFsbG93ZWQgZHVyaW5nXG4gICAgLy8gdGhpcyBkaWZmLCBzbyB0aGF0IG90aGVyIGNoYW5nZXMgY2Fubm90IGludGVybGVhdmUuXG4gICAgTWV0ZW9yLl9ub1lpZWxkc0FsbG93ZWQoZnVuY3Rpb24gKCkge1xuICAgICAgc2VsZi5faXNTZW5kaW5nID0gdHJ1ZTtcbiAgICAgIHNlbGYuX2RpZmZDb2xsZWN0aW9uVmlld3MoYmVmb3JlQ1ZzKTtcbiAgICAgIGlmICghXy5pc0VtcHR5KHNlbGYuX3BlbmRpbmdSZWFkeSkpIHtcbiAgICAgICAgc2VsZi5zZW5kUmVhZHkoc2VsZi5fcGVuZGluZ1JlYWR5KTtcbiAgICAgICAgc2VsZi5fcGVuZGluZ1JlYWR5ID0gW107XG4gICAgICB9XG4gICAgfSk7XG4gIH0sXG5cbiAgX3N0YXJ0U3Vic2NyaXB0aW9uOiBmdW5jdGlvbiAoaGFuZGxlciwgc3ViSWQsIHBhcmFtcywgbmFtZSkge1xuICAgIHZhciBzZWxmID0gdGhpcztcblxuICAgIHZhciBzdWIgPSBuZXcgU3Vic2NyaXB0aW9uKFxuICAgICAgc2VsZiwgaGFuZGxlciwgc3ViSWQsIHBhcmFtcywgbmFtZSk7XG5cbiAgICBsZXQgdW5ibG9ja0hhbmRlciA9IHNlbGYuY2FjaGVkVW5ibG9jaztcbiAgICAvLyBfc3RhcnRTdWJzY3JpcHRpb24gbWF5IGNhbGwgZnJvbSBhIGxvdCBwbGFjZXNcbiAgICAvLyBzbyBjYWNoZWRVbmJsb2NrIG1pZ2h0IGJlIG51bGwgaW4gc29tZWNhc2VzXG4gICAgLy8gYXNzaWduIHRoZSBjYWNoZWRVbmJsb2NrXG4gICAgc3ViLnVuYmxvY2sgPSB1bmJsb2NrSGFuZGVyIHx8ICgoKSA9PiB7fSk7XG5cbiAgICBpZiAoc3ViSWQpXG4gICAgICBzZWxmLl9uYW1lZFN1YnMuc2V0KHN1YklkLCBzdWIpO1xuICAgIGVsc2VcbiAgICAgIHNlbGYuX3VuaXZlcnNhbFN1YnMucHVzaChzdWIpO1xuXG4gICAgc3ViLl9ydW5IYW5kbGVyKCk7XG4gIH0sXG5cbiAgLy8gVGVhciBkb3duIHNwZWNpZmllZCBzdWJzY3JpcHRpb25cbiAgX3N0b3BTdWJzY3JpcHRpb246IGZ1bmN0aW9uIChzdWJJZCwgZXJyb3IpIHtcbiAgICB2YXIgc2VsZiA9IHRoaXM7XG5cbiAgICB2YXIgc3ViTmFtZSA9IG51bGw7XG4gICAgaWYgKHN1YklkKSB7XG4gICAgICB2YXIgbWF5YmVTdWIgPSBzZWxmLl9uYW1lZFN1YnMuZ2V0KHN1YklkKTtcbiAgICAgIGlmIChtYXliZVN1Yikge1xuICAgICAgICBzdWJOYW1lID0gbWF5YmVTdWIuX25hbWU7XG4gICAgICAgIG1heWJlU3ViLl9yZW1vdmVBbGxEb2N1bWVudHMoKTtcbiAgICAgICAgbWF5YmVTdWIuX2RlYWN0aXZhdGUoKTtcbiAgICAgICAgc2VsZi5fbmFtZWRTdWJzLmRlbGV0ZShzdWJJZCk7XG4gICAgICB9XG4gICAgfVxuXG4gICAgdmFyIHJlc3BvbnNlID0ge21zZzogJ25vc3ViJywgaWQ6IHN1YklkfTtcblxuICAgIGlmIChlcnJvcikge1xuICAgICAgcmVzcG9uc2UuZXJyb3IgPSB3cmFwSW50ZXJuYWxFeGNlcHRpb24oXG4gICAgICAgIGVycm9yLFxuICAgICAgICBzdWJOYW1lID8gKFwiZnJvbSBzdWIgXCIgKyBzdWJOYW1lICsgXCIgaWQgXCIgKyBzdWJJZClcbiAgICAgICAgICA6IChcImZyb20gc3ViIGlkIFwiICsgc3ViSWQpKTtcbiAgICB9XG5cbiAgICBzZWxmLnNlbmQocmVzcG9uc2UpO1xuICB9LFxuXG4gIC8vIFRlYXIgZG93biBhbGwgc3Vic2NyaXB0aW9ucy4gTm90ZSB0aGF0IHRoaXMgZG9lcyBOT1Qgc2VuZCByZW1vdmVkIG9yIG5vc3ViXG4gIC8vIG1lc3NhZ2VzLCBzaW5jZSB3ZSBhc3N1bWUgdGhlIGNsaWVudCBpcyBnb25lLlxuICBfZGVhY3RpdmF0ZUFsbFN1YnNjcmlwdGlvbnM6IGZ1bmN0aW9uICgpIHtcbiAgICB2YXIgc2VsZiA9IHRoaXM7XG5cbiAgICBzZWxmLl9uYW1lZFN1YnMuZm9yRWFjaChmdW5jdGlvbiAoc3ViLCBpZCkge1xuICAgICAgc3ViLl9kZWFjdGl2YXRlKCk7XG4gICAgfSk7XG4gICAgc2VsZi5fbmFtZWRTdWJzID0gbmV3IE1hcCgpO1xuXG4gICAgc2VsZi5fdW5pdmVyc2FsU3Vicy5mb3JFYWNoKGZ1bmN0aW9uIChzdWIpIHtcbiAgICAgIHN1Yi5fZGVhY3RpdmF0ZSgpO1xuICAgIH0pO1xuICAgIHNlbGYuX3VuaXZlcnNhbFN1YnMgPSBbXTtcbiAgfSxcblxuICAvLyBEZXRlcm1pbmUgdGhlIHJlbW90ZSBjbGllbnQncyBJUCBhZGRyZXNzLCBiYXNlZCBvbiB0aGVcbiAgLy8gSFRUUF9GT1JXQVJERURfQ09VTlQgZW52aXJvbm1lbnQgdmFyaWFibGUgcmVwcmVzZW50aW5nIGhvdyBtYW55XG4gIC8vIHByb3hpZXMgdGhlIHNlcnZlciBpcyBiZWhpbmQuXG4gIF9jbGllbnRBZGRyZXNzOiBmdW5jdGlvbiAoKSB7XG4gICAgdmFyIHNlbGYgPSB0aGlzO1xuXG4gICAgLy8gRm9yIHRoZSByZXBvcnRlZCBjbGllbnQgYWRkcmVzcyBmb3IgYSBjb25uZWN0aW9uIHRvIGJlIGNvcnJlY3QsXG4gICAgLy8gdGhlIGRldmVsb3BlciBtdXN0IHNldCB0aGUgSFRUUF9GT1JXQVJERURfQ09VTlQgZW52aXJvbm1lbnRcbiAgICAvLyB2YXJpYWJsZSB0byBhbiBpbnRlZ2VyIHJlcHJlc2VudGluZyB0aGUgbnVtYmVyIG9mIGhvcHMgdGhleVxuICAgIC8vIGV4cGVjdCBpbiB0aGUgYHgtZm9yd2FyZGVkLWZvcmAgaGVhZGVyLiBFLmcuLCBzZXQgdG8gXCIxXCIgaWYgdGhlXG4gICAgLy8gc2VydmVyIGlzIGJlaGluZCBvbmUgcHJveHkuXG4gICAgLy9cbiAgICAvLyBUaGlzIGNvdWxkIGJlIGNvbXB1dGVkIG9uY2UgYXQgc3RhcnR1cCBpbnN0ZWFkIG9mIGV2ZXJ5IHRpbWUuXG4gICAgdmFyIGh0dHBGb3J3YXJkZWRDb3VudCA9IHBhcnNlSW50KHByb2Nlc3MuZW52WydIVFRQX0ZPUldBUkRFRF9DT1VOVCddKSB8fCAwO1xuXG4gICAgaWYgKGh0dHBGb3J3YXJkZWRDb3VudCA9PT0gMClcbiAgICAgIHJldHVybiBzZWxmLnNvY2tldC5yZW1vdGVBZGRyZXNzO1xuXG4gICAgdmFyIGZvcndhcmRlZEZvciA9IHNlbGYuc29ja2V0LmhlYWRlcnNbXCJ4LWZvcndhcmRlZC1mb3JcIl07XG4gICAgaWYgKCEgXy5pc1N0cmluZyhmb3J3YXJkZWRGb3IpKVxuICAgICAgcmV0dXJuIG51bGw7XG4gICAgZm9yd2FyZGVkRm9yID0gZm9yd2FyZGVkRm9yLnRyaW0oKS5zcGxpdCgvXFxzKixcXHMqLyk7XG5cbiAgICAvLyBUeXBpY2FsbHkgdGhlIGZpcnN0IHZhbHVlIGluIHRoZSBgeC1mb3J3YXJkZWQtZm9yYCBoZWFkZXIgaXNcbiAgICAvLyB0aGUgb3JpZ2luYWwgSVAgYWRkcmVzcyBvZiB0aGUgY2xpZW50IGNvbm5lY3RpbmcgdG8gdGhlIGZpcnN0XG4gICAgLy8gcHJveHkuICBIb3dldmVyLCB0aGUgZW5kIHVzZXIgY2FuIGVhc2lseSBzcG9vZiB0aGUgaGVhZGVyLCBpblxuICAgIC8vIHdoaWNoIGNhc2UgdGhlIGZpcnN0IHZhbHVlKHMpIHdpbGwgYmUgdGhlIGZha2UgSVAgYWRkcmVzcyBmcm9tXG4gICAgLy8gdGhlIHVzZXIgcHJldGVuZGluZyB0byBiZSBhIHByb3h5IHJlcG9ydGluZyB0aGUgb3JpZ2luYWwgSVBcbiAgICAvLyBhZGRyZXNzIHZhbHVlLiAgQnkgY291bnRpbmcgSFRUUF9GT1JXQVJERURfQ09VTlQgYmFjayBmcm9tIHRoZVxuICAgIC8vIGVuZCBvZiB0aGUgbGlzdCwgd2UgZW5zdXJlIHRoYXQgd2UgZ2V0IHRoZSBJUCBhZGRyZXNzIGJlaW5nXG4gICAgLy8gcmVwb3J0ZWQgYnkgKm91ciogZmlyc3QgcHJveHkuXG5cbiAgICBpZiAoaHR0cEZvcndhcmRlZENvdW50IDwgMCB8fCBodHRwRm9yd2FyZGVkQ291bnQgPiBmb3J3YXJkZWRGb3IubGVuZ3RoKVxuICAgICAgcmV0dXJuIG51bGw7XG5cbiAgICByZXR1cm4gZm9yd2FyZGVkRm9yW2ZvcndhcmRlZEZvci5sZW5ndGggLSBodHRwRm9yd2FyZGVkQ291bnRdO1xuICB9XG59KTtcblxuLyoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKi9cbi8qIFN1YnNjcmlwdGlvbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICovXG4vKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqL1xuXG4vLyBDdG9yIGZvciBhIHN1YiBoYW5kbGU6IHRoZSBpbnB1dCB0byBlYWNoIHB1Ymxpc2ggZnVuY3Rpb25cblxuLy8gSW5zdGFuY2UgbmFtZSBpcyB0aGlzIGJlY2F1c2UgaXQncyB1c3VhbGx5IHJlZmVycmVkIHRvIGFzIHRoaXMgaW5zaWRlIGFcbi8vIHB1Ymxpc2hcbi8qKlxuICogQHN1bW1hcnkgVGhlIHNlcnZlcidzIHNpZGUgb2YgYSBzdWJzY3JpcHRpb25cbiAqIEBjbGFzcyBTdWJzY3JpcHRpb25cbiAqIEBpbnN0YW5jZU5hbWUgdGhpc1xuICogQHNob3dJbnN0YW5jZU5hbWUgdHJ1ZVxuICovXG52YXIgU3Vic2NyaXB0aW9uID0gZnVuY3Rpb24gKFxuICAgIHNlc3Npb24sIGhhbmRsZXIsIHN1YnNjcmlwdGlvbklkLCBwYXJhbXMsIG5hbWUpIHtcbiAgdmFyIHNlbGYgPSB0aGlzO1xuICBzZWxmLl9zZXNzaW9uID0gc2Vzc2lvbjsgLy8gdHlwZSBpcyBTZXNzaW9uXG5cbiAgLyoqXG4gICAqIEBzdW1tYXJ5IEFjY2VzcyBpbnNpZGUgdGhlIHB1Ymxpc2ggZnVuY3Rpb24uIFRoZSBpbmNvbWluZyBbY29ubmVjdGlvbl0oI21ldGVvcl9vbmNvbm5lY3Rpb24pIGZvciB0aGlzIHN1YnNjcmlwdGlvbi5cbiAgICogQGxvY3VzIFNlcnZlclxuICAgKiBAbmFtZSAgY29ubmVjdGlvblxuICAgKiBAbWVtYmVyT2YgU3Vic2NyaXB0aW9uXG4gICAqIEBpbnN0YW5jZVxuICAgKi9cbiAgc2VsZi5jb25uZWN0aW9uID0gc2Vzc2lvbi5jb25uZWN0aW9uSGFuZGxlOyAvLyBwdWJsaWMgQVBJIG9iamVjdFxuXG4gIHNlbGYuX2hhbmRsZXIgPSBoYW5kbGVyO1xuXG4gIC8vIE15IHN1YnNjcmlwdGlvbiBJRCAoZ2VuZXJhdGVkIGJ5IGNsaWVudCwgdW5kZWZpbmVkIGZvciB1bml2ZXJzYWwgc3VicykuXG4gIHNlbGYuX3N1YnNjcmlwdGlvbklkID0gc3Vic2NyaXB0aW9uSWQ7XG4gIC8vIFVuZGVmaW5lZCBmb3IgdW5pdmVyc2FsIHN1YnNcbiAgc2VsZi5fbmFtZSA9IG5hbWU7XG5cbiAgc2VsZi5fcGFyYW1zID0gcGFyYW1zIHx8IFtdO1xuXG4gIC8vIE9ubHkgbmFtZWQgc3Vic2NyaXB0aW9ucyBoYXZlIElEcywgYnV0IHdlIG5lZWQgc29tZSBzb3J0IG9mIHN0cmluZ1xuICAvLyBpbnRlcm5hbGx5IHRvIGtlZXAgdHJhY2sgb2YgYWxsIHN1YnNjcmlwdGlvbnMgaW5zaWRlXG4gIC8vIFNlc3Npb25Eb2N1bWVudFZpZXdzLiBXZSB1c2UgdGhpcyBzdWJzY3JpcHRpb25IYW5kbGUgZm9yIHRoYXQuXG4gIGlmIChzZWxmLl9zdWJzY3JpcHRpb25JZCkge1xuICAgIHNlbGYuX3N1YnNjcmlwdGlvbkhhbmRsZSA9ICdOJyArIHNlbGYuX3N1YnNjcmlwdGlvbklkO1xuICB9IGVsc2Uge1xuICAgIHNlbGYuX3N1YnNjcmlwdGlvbkhhbmRsZSA9ICdVJyArIFJhbmRvbS5pZCgpO1xuICB9XG5cbiAgLy8gSGFzIF9kZWFjdGl2YXRlIGJlZW4gY2FsbGVkP1xuICBzZWxmLl9kZWFjdGl2YXRlZCA9IGZhbHNlO1xuXG4gIC8vIFN0b3AgY2FsbGJhY2tzIHRvIGcvYyB0aGlzIHN1Yi4gIGNhbGxlZCB3LyB6ZXJvIGFyZ3VtZW50cy5cbiAgc2VsZi5fc3RvcENhbGxiYWNrcyA9IFtdO1xuXG4gIC8vIFRoZSBzZXQgb2YgKGNvbGxlY3Rpb24sIGRvY3VtZW50aWQpIHRoYXQgdGhpcyBzdWJzY3JpcHRpb24gaGFzXG4gIC8vIGFuIG9waW5pb24gYWJvdXQuXG4gIHNlbGYuX2RvY3VtZW50cyA9IG5ldyBNYXAoKTtcblxuICAvLyBSZW1lbWJlciBpZiB3ZSBhcmUgcmVhZHkuXG4gIHNlbGYuX3JlYWR5ID0gZmFsc2U7XG5cbiAgLy8gUGFydCBvZiB0aGUgcHVibGljIEFQSTogdGhlIHVzZXIgb2YgdGhpcyBzdWIuXG5cbiAgLyoqXG4gICAqIEBzdW1tYXJ5IEFjY2VzcyBpbnNpZGUgdGhlIHB1Ymxpc2ggZnVuY3Rpb24uIFRoZSBpZCBvZiB0aGUgbG9nZ2VkLWluIHVzZXIsIG9yIGBudWxsYCBpZiBubyB1c2VyIGlzIGxvZ2dlZCBpbi5cbiAgICogQGxvY3VzIFNlcnZlclxuICAgKiBAbWVtYmVyT2YgU3Vic2NyaXB0aW9uXG4gICAqIEBuYW1lICB1c2VySWRcbiAgICogQGluc3RhbmNlXG4gICAqL1xuICBzZWxmLnVzZXJJZCA9IHNlc3Npb24udXNlcklkO1xuXG4gIC8vIEZvciBub3csIHRoZSBpZCBmaWx0ZXIgaXMgZ29pbmcgdG8gZGVmYXVsdCB0b1xuICAvLyB0aGUgdG8vZnJvbSBERFAgbWV0aG9kcyBvbiBNb25nb0lELCB0b1xuICAvLyBzcGVjaWZpY2FsbHkgZGVhbCB3aXRoIG1vbmdvL21pbmltb25nbyBPYmplY3RJZHMuXG5cbiAgLy8gTGF0ZXIsIHlvdSB3aWxsIGJlIGFibGUgdG8gbWFrZSB0aGlzIGJlIFwicmF3XCJcbiAgLy8gaWYgeW91IHdhbnQgdG8gcHVibGlzaCBhIGNvbGxlY3Rpb24gdGhhdCB5b3Uga25vd1xuICAvLyBqdXN0IGhhcyBzdHJpbmdzIGZvciBrZXlzIGFuZCBubyBmdW5ueSBidXNpbmVzcywgdG9cbiAgLy8gYSBERFAgY29uc3VtZXIgdGhhdCBpc24ndCBtaW5pbW9uZ28uXG5cbiAgc2VsZi5faWRGaWx0ZXIgPSB7XG4gICAgaWRTdHJpbmdpZnk6IE1vbmdvSUQuaWRTdHJpbmdpZnksXG4gICAgaWRQYXJzZTogTW9uZ29JRC5pZFBhcnNlXG4gIH07XG5cbiAgUGFja2FnZVsnZmFjdHMtYmFzZSddICYmIFBhY2thZ2VbJ2ZhY3RzLWJhc2UnXS5GYWN0cy5pbmNyZW1lbnRTZXJ2ZXJGYWN0KFxuICAgIFwibGl2ZWRhdGFcIiwgXCJzdWJzY3JpcHRpb25zXCIsIDEpO1xufTtcblxuT2JqZWN0LmFzc2lnbihTdWJzY3JpcHRpb24ucHJvdG90eXBlLCB7XG4gIF9ydW5IYW5kbGVyOiBmdW5jdGlvbigpIHtcbiAgICAvLyBYWFggc2hvdWxkIHdlIHVuYmxvY2soKSBoZXJlPyBFaXRoZXIgYmVmb3JlIHJ1bm5pbmcgdGhlIHB1Ymxpc2hcbiAgICAvLyBmdW5jdGlvbiwgb3IgYmVmb3JlIHJ1bm5pbmcgX3B1Ymxpc2hDdXJzb3IuXG4gICAgLy9cbiAgICAvLyBSaWdodCBub3csIGVhY2ggcHVibGlzaCBmdW5jdGlvbiBibG9ja3MgYWxsIGZ1dHVyZSBwdWJsaXNoZXMgYW5kXG4gICAgLy8gbWV0aG9kcyB3YWl0aW5nIG9uIGRhdGEgZnJvbSBNb25nbyAob3Igd2hhdGV2ZXIgZWxzZSB0aGUgZnVuY3Rpb25cbiAgICAvLyBibG9ja3Mgb24pLiBUaGlzIHByb2JhYmx5IHNsb3dzIHBhZ2UgbG9hZCBpbiBjb21tb24gY2FzZXMuXG5cbiAgICBpZiAoIXRoaXMudW5ibG9jaykge1xuICAgICAgdGhpcy51bmJsb2NrID0gKCkgPT4ge307XG4gICAgfVxuXG4gICAgY29uc3Qgc2VsZiA9IHRoaXM7XG4gICAgbGV0IHJlc3VsdE9yVGhlbmFibGUgPSBudWxsO1xuICAgIHRyeSB7XG4gICAgICByZXN1bHRPclRoZW5hYmxlID0gRERQLl9DdXJyZW50UHVibGljYXRpb25JbnZvY2F0aW9uLndpdGhWYWx1ZShzZWxmLCAoKSA9PlxuICAgICAgICBtYXliZUF1ZGl0QXJndW1lbnRDaGVja3MoXG4gICAgICAgICAgc2VsZi5faGFuZGxlcixcbiAgICAgICAgICBzZWxmLFxuICAgICAgICAgIEVKU09OLmNsb25lKHNlbGYuX3BhcmFtcyksXG4gICAgICAgICAgLy8gSXQncyBPSyB0aGF0IHRoaXMgd291bGQgbG9vayB3ZWlyZCBmb3IgdW5pdmVyc2FsIHN1YnNjcmlwdGlvbnMsXG4gICAgICAgICAgLy8gYmVjYXVzZSB0aGV5IGhhdmUgbm8gYXJndW1lbnRzIHNvIHRoZXJlIGNhbiBuZXZlciBiZSBhblxuICAgICAgICAgIC8vIGF1ZGl0LWFyZ3VtZW50LWNoZWNrcyBmYWlsdXJlLlxuICAgICAgICAgIFwicHVibGlzaGVyICdcIiArIHNlbGYuX25hbWUgKyBcIidcIlxuICAgICAgICApXG4gICAgICApO1xuICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgIHNlbGYuZXJyb3IoZSk7XG4gICAgICByZXR1cm47XG4gICAgfVxuXG4gICAgLy8gRGlkIHRoZSBoYW5kbGVyIGNhbGwgdGhpcy5lcnJvciBvciB0aGlzLnN0b3A/XG4gICAgaWYgKHNlbGYuX2lzRGVhY3RpdmF0ZWQoKSkgcmV0dXJuO1xuXG4gICAgLy8gQm90aCBjb252ZW50aW9uYWwgYW5kIGFzeW5jIHB1Ymxpc2ggaGFuZGxlciBmdW5jdGlvbnMgYXJlIHN1cHBvcnRlZC5cbiAgICAvLyBJZiBhbiBvYmplY3QgaXMgcmV0dXJuZWQgd2l0aCBhIHRoZW4oKSBmdW5jdGlvbiwgaXQgaXMgZWl0aGVyIGEgcHJvbWlzZVxuICAgIC8vIG9yIHRoZW5hYmxlIGFuZCB3aWxsIGJlIHJlc29sdmVkIGFzeW5jaHJvbm91c2x5LlxuICAgIGNvbnN0IGlzVGhlbmFibGUgPVxuICAgICAgcmVzdWx0T3JUaGVuYWJsZSAmJiB0eXBlb2YgcmVzdWx0T3JUaGVuYWJsZS50aGVuID09PSAnZnVuY3Rpb24nO1xuICAgIGlmIChpc1RoZW5hYmxlKSB7XG4gICAgICBQcm9taXNlLnJlc29sdmUocmVzdWx0T3JUaGVuYWJsZSkudGhlbihcbiAgICAgICAgKC4uLmFyZ3MpID0+IHNlbGYuX3B1Ymxpc2hIYW5kbGVyUmVzdWx0LmJpbmQoc2VsZikoLi4uYXJncyksXG4gICAgICAgIGUgPT4gc2VsZi5lcnJvcihlKVxuICAgICAgKTtcbiAgICB9IGVsc2Uge1xuICAgICAgc2VsZi5fcHVibGlzaEhhbmRsZXJSZXN1bHQocmVzdWx0T3JUaGVuYWJsZSk7XG4gICAgfVxuICB9LFxuXG4gIF9wdWJsaXNoSGFuZGxlclJlc3VsdDogZnVuY3Rpb24gKHJlcykge1xuICAgIC8vIFNQRUNJQUwgQ0FTRTogSW5zdGVhZCBvZiB3cml0aW5nIHRoZWlyIG93biBjYWxsYmFja3MgdGhhdCBpbnZva2VcbiAgICAvLyB0aGlzLmFkZGVkL2NoYW5nZWQvcmVhZHkvZXRjLCB0aGUgdXNlciBjYW4ganVzdCByZXR1cm4gYSBjb2xsZWN0aW9uXG4gICAgLy8gY3Vyc29yIG9yIGFycmF5IG9mIGN1cnNvcnMgZnJvbSB0aGUgcHVibGlzaCBmdW5jdGlvbjsgd2UgY2FsbCB0aGVpclxuICAgIC8vIF9wdWJsaXNoQ3Vyc29yIG1ldGhvZCB3aGljaCBzdGFydHMgb2JzZXJ2aW5nIHRoZSBjdXJzb3IgYW5kIHB1Ymxpc2hlcyB0aGVcbiAgICAvLyByZXN1bHRzLiBOb3RlIHRoYXQgX3B1Ymxpc2hDdXJzb3IgZG9lcyBOT1QgY2FsbCByZWFkeSgpLlxuICAgIC8vXG4gICAgLy8gWFhYIFRoaXMgdXNlcyBhbiB1bmRvY3VtZW50ZWQgaW50ZXJmYWNlIHdoaWNoIG9ubHkgdGhlIE1vbmdvIGN1cnNvclxuICAgIC8vIGludGVyZmFjZSBwdWJsaXNoZXMuIFNob3VsZCB3ZSBtYWtlIHRoaXMgaW50ZXJmYWNlIHB1YmxpYyBhbmQgZW5jb3VyYWdlXG4gICAgLy8gdXNlcnMgdG8gaW1wbGVtZW50IGl0IHRoZW1zZWx2ZXM/IEFyZ3VhYmx5LCBpdCdzIHVubmVjZXNzYXJ5OyB1c2VycyBjYW5cbiAgICAvLyBhbHJlYWR5IHdyaXRlIHRoZWlyIG93biBmdW5jdGlvbnMgbGlrZVxuICAgIC8vICAgdmFyIHB1Ymxpc2hNeVJlYWN0aXZlVGhpbmd5ID0gZnVuY3Rpb24gKG5hbWUsIGhhbmRsZXIpIHtcbiAgICAvLyAgICAgTWV0ZW9yLnB1Ymxpc2gobmFtZSwgZnVuY3Rpb24gKCkge1xuICAgIC8vICAgICAgIHZhciByZWFjdGl2ZVRoaW5neSA9IGhhbmRsZXIoKTtcbiAgICAvLyAgICAgICByZWFjdGl2ZVRoaW5neS5wdWJsaXNoTWUoKTtcbiAgICAvLyAgICAgfSk7XG4gICAgLy8gICB9O1xuXG4gICAgdmFyIHNlbGYgPSB0aGlzO1xuICAgIHZhciBpc0N1cnNvciA9IGZ1bmN0aW9uIChjKSB7XG4gICAgICByZXR1cm4gYyAmJiBjLl9wdWJsaXNoQ3Vyc29yO1xuICAgIH07XG4gICAgaWYgKGlzQ3Vyc29yKHJlcykpIHtcbiAgICAgIHRyeSB7XG4gICAgICAgIHJlcy5fcHVibGlzaEN1cnNvcihzZWxmKTtcbiAgICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgICAgc2VsZi5lcnJvcihlKTtcbiAgICAgICAgcmV0dXJuO1xuICAgICAgfVxuICAgICAgLy8gX3B1Ymxpc2hDdXJzb3Igb25seSByZXR1cm5zIGFmdGVyIHRoZSBpbml0aWFsIGFkZGVkIGNhbGxiYWNrcyBoYXZlIHJ1bi5cbiAgICAgIC8vIG1hcmsgc3Vic2NyaXB0aW9uIGFzIHJlYWR5LlxuICAgICAgc2VsZi5yZWFkeSgpO1xuICAgIH0gZWxzZSBpZiAoXy5pc0FycmF5KHJlcykpIHtcbiAgICAgIC8vIENoZWNrIGFsbCB0aGUgZWxlbWVudHMgYXJlIGN1cnNvcnNcbiAgICAgIGlmICghIF8uYWxsKHJlcywgaXNDdXJzb3IpKSB7XG4gICAgICAgIHNlbGYuZXJyb3IobmV3IEVycm9yKFwiUHVibGlzaCBmdW5jdGlvbiByZXR1cm5lZCBhbiBhcnJheSBvZiBub24tQ3Vyc29yc1wiKSk7XG4gICAgICAgIHJldHVybjtcbiAgICAgIH1cbiAgICAgIC8vIEZpbmQgZHVwbGljYXRlIGNvbGxlY3Rpb24gbmFtZXNcbiAgICAgIC8vIFhYWCB3ZSBzaG91bGQgc3VwcG9ydCBvdmVybGFwcGluZyBjdXJzb3JzLCBidXQgdGhhdCB3b3VsZCByZXF1aXJlIHRoZVxuICAgICAgLy8gbWVyZ2UgYm94IHRvIGFsbG93IG92ZXJsYXAgd2l0aGluIGEgc3Vic2NyaXB0aW9uXG4gICAgICB2YXIgY29sbGVjdGlvbk5hbWVzID0ge307XG4gICAgICBmb3IgKHZhciBpID0gMDsgaSA8IHJlcy5sZW5ndGg7ICsraSkge1xuICAgICAgICB2YXIgY29sbGVjdGlvbk5hbWUgPSByZXNbaV0uX2dldENvbGxlY3Rpb25OYW1lKCk7XG4gICAgICAgIGlmIChfLmhhcyhjb2xsZWN0aW9uTmFtZXMsIGNvbGxlY3Rpb25OYW1lKSkge1xuICAgICAgICAgIHNlbGYuZXJyb3IobmV3IEVycm9yKFxuICAgICAgICAgICAgXCJQdWJsaXNoIGZ1bmN0aW9uIHJldHVybmVkIG11bHRpcGxlIGN1cnNvcnMgZm9yIGNvbGxlY3Rpb24gXCIgK1xuICAgICAgICAgICAgICBjb2xsZWN0aW9uTmFtZSkpO1xuICAgICAgICAgIHJldHVybjtcbiAgICAgICAgfVxuICAgICAgICBjb2xsZWN0aW9uTmFtZXNbY29sbGVjdGlvbk5hbWVdID0gdHJ1ZTtcbiAgICAgIH07XG5cbiAgICAgIHRyeSB7XG4gICAgICAgIF8uZWFjaChyZXMsIGZ1bmN0aW9uIChjdXIpIHtcbiAgICAgICAgICBjdXIuX3B1Ymxpc2hDdXJzb3Ioc2VsZik7XG4gICAgICAgIH0pO1xuICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICBzZWxmLmVycm9yKGUpO1xuICAgICAgICByZXR1cm47XG4gICAgICB9XG4gICAgICBzZWxmLnJlYWR5KCk7XG4gICAgfSBlbHNlIGlmIChyZXMpIHtcbiAgICAgIC8vIFRydXRoeSB2YWx1ZXMgb3RoZXIgdGhhbiBjdXJzb3JzIG9yIGFycmF5cyBhcmUgcHJvYmFibHkgYVxuICAgICAgLy8gdXNlciBtaXN0YWtlIChwb3NzaWJsZSByZXR1cm5pbmcgYSBNb25nbyBkb2N1bWVudCB2aWEsIHNheSxcbiAgICAgIC8vIGBjb2xsLmZpbmRPbmUoKWApLlxuICAgICAgc2VsZi5lcnJvcihuZXcgRXJyb3IoXCJQdWJsaXNoIGZ1bmN0aW9uIGNhbiBvbmx5IHJldHVybiBhIEN1cnNvciBvciBcIlxuICAgICAgICAgICAgICAgICAgICAgICAgICAgKyBcImFuIGFycmF5IG9mIEN1cnNvcnNcIikpO1xuICAgIH1cbiAgfSxcblxuICAvLyBUaGlzIGNhbGxzIGFsbCBzdG9wIGNhbGxiYWNrcyBhbmQgcHJldmVudHMgdGhlIGhhbmRsZXIgZnJvbSB1cGRhdGluZyBhbnlcbiAgLy8gU2Vzc2lvbkNvbGxlY3Rpb25WaWV3cyBmdXJ0aGVyLiBJdCdzIHVzZWQgd2hlbiB0aGUgdXNlciB1bnN1YnNjcmliZXMgb3JcbiAgLy8gZGlzY29ubmVjdHMsIGFzIHdlbGwgYXMgZHVyaW5nIHNldFVzZXJJZCByZS1ydW5zLiBJdCBkb2VzICpOT1QqIHNlbmRcbiAgLy8gcmVtb3ZlZCBtZXNzYWdlcyBmb3IgdGhlIHB1Ymxpc2hlZCBvYmplY3RzOyBpZiB0aGF0IGlzIG5lY2Vzc2FyeSwgY2FsbFxuICAvLyBfcmVtb3ZlQWxsRG9jdW1lbnRzIGZpcnN0LlxuICBfZGVhY3RpdmF0ZTogZnVuY3Rpb24oKSB7XG4gICAgdmFyIHNlbGYgPSB0aGlzO1xuICAgIGlmIChzZWxmLl9kZWFjdGl2YXRlZClcbiAgICAgIHJldHVybjtcbiAgICBzZWxmLl9kZWFjdGl2YXRlZCA9IHRydWU7XG4gICAgc2VsZi5fY2FsbFN0b3BDYWxsYmFja3MoKTtcbiAgICBQYWNrYWdlWydmYWN0cy1iYXNlJ10gJiYgUGFja2FnZVsnZmFjdHMtYmFzZSddLkZhY3RzLmluY3JlbWVudFNlcnZlckZhY3QoXG4gICAgICBcImxpdmVkYXRhXCIsIFwic3Vic2NyaXB0aW9uc1wiLCAtMSk7XG4gIH0sXG5cbiAgX2NhbGxTdG9wQ2FsbGJhY2tzOiBmdW5jdGlvbiAoKSB7XG4gICAgdmFyIHNlbGYgPSB0aGlzO1xuICAgIC8vIFRlbGwgbGlzdGVuZXJzLCBzbyB0aGV5IGNhbiBjbGVhbiB1cFxuICAgIHZhciBjYWxsYmFja3MgPSBzZWxmLl9zdG9wQ2FsbGJhY2tzO1xuICAgIHNlbGYuX3N0b3BDYWxsYmFja3MgPSBbXTtcbiAgICBfLmVhY2goY2FsbGJhY2tzLCBmdW5jdGlvbiAoY2FsbGJhY2spIHtcbiAgICAgIGNhbGxiYWNrKCk7XG4gICAgfSk7XG4gIH0sXG5cbiAgLy8gU2VuZCByZW1vdmUgbWVzc2FnZXMgZm9yIGV2ZXJ5IGRvY3VtZW50LlxuICBfcmVtb3ZlQWxsRG9jdW1lbnRzOiBmdW5jdGlvbiAoKSB7XG4gICAgdmFyIHNlbGYgPSB0aGlzO1xuICAgIE1ldGVvci5fbm9ZaWVsZHNBbGxvd2VkKGZ1bmN0aW9uICgpIHtcbiAgICAgIHNlbGYuX2RvY3VtZW50cy5mb3JFYWNoKGZ1bmN0aW9uIChjb2xsZWN0aW9uRG9jcywgY29sbGVjdGlvbk5hbWUpIHtcbiAgICAgICAgY29sbGVjdGlvbkRvY3MuZm9yRWFjaChmdW5jdGlvbiAoc3RySWQpIHtcbiAgICAgICAgICBzZWxmLnJlbW92ZWQoY29sbGVjdGlvbk5hbWUsIHNlbGYuX2lkRmlsdGVyLmlkUGFyc2Uoc3RySWQpKTtcbiAgICAgICAgfSk7XG4gICAgICB9KTtcbiAgICB9KTtcbiAgfSxcblxuICAvLyBSZXR1cm5zIGEgbmV3IFN1YnNjcmlwdGlvbiBmb3IgdGhlIHNhbWUgc2Vzc2lvbiB3aXRoIHRoZSBzYW1lXG4gIC8vIGluaXRpYWwgY3JlYXRpb24gcGFyYW1ldGVycy4gVGhpcyBpc24ndCBhIGNsb25lOiBpdCBkb2Vzbid0IGhhdmVcbiAgLy8gdGhlIHNhbWUgX2RvY3VtZW50cyBjYWNoZSwgc3RvcHBlZCBzdGF0ZSBvciBjYWxsYmFja3M7IG1heSBoYXZlIGFcbiAgLy8gZGlmZmVyZW50IF9zdWJzY3JpcHRpb25IYW5kbGUsIGFuZCBnZXRzIGl0cyB1c2VySWQgZnJvbSB0aGVcbiAgLy8gc2Vzc2lvbiwgbm90IGZyb20gdGhpcyBvYmplY3QuXG4gIF9yZWNyZWF0ZTogZnVuY3Rpb24gKCkge1xuICAgIHZhciBzZWxmID0gdGhpcztcbiAgICByZXR1cm4gbmV3IFN1YnNjcmlwdGlvbihcbiAgICAgIHNlbGYuX3Nlc3Npb24sIHNlbGYuX2hhbmRsZXIsIHNlbGYuX3N1YnNjcmlwdGlvbklkLCBzZWxmLl9wYXJhbXMsXG4gICAgICBzZWxmLl9uYW1lKTtcbiAgfSxcblxuICAvKipcbiAgICogQHN1bW1hcnkgQ2FsbCBpbnNpZGUgdGhlIHB1Ymxpc2ggZnVuY3Rpb24uICBTdG9wcyB0aGlzIGNsaWVudCdzIHN1YnNjcmlwdGlvbiwgdHJpZ2dlcmluZyBhIGNhbGwgb24gdGhlIGNsaWVudCB0byB0aGUgYG9uU3RvcGAgY2FsbGJhY2sgcGFzc2VkIHRvIFtgTWV0ZW9yLnN1YnNjcmliZWBdKCNtZXRlb3Jfc3Vic2NyaWJlKSwgaWYgYW55LiBJZiBgZXJyb3JgIGlzIG5vdCBhIFtgTWV0ZW9yLkVycm9yYF0oI21ldGVvcl9lcnJvciksIGl0IHdpbGwgYmUgW3Nhbml0aXplZF0oI21ldGVvcl9lcnJvcikuXG4gICAqIEBsb2N1cyBTZXJ2ZXJcbiAgICogQHBhcmFtIHtFcnJvcn0gZXJyb3IgVGhlIGVycm9yIHRvIHBhc3MgdG8gdGhlIGNsaWVudC5cbiAgICogQGluc3RhbmNlXG4gICAqIEBtZW1iZXJPZiBTdWJzY3JpcHRpb25cbiAgICovXG4gIGVycm9yOiBmdW5jdGlvbiAoZXJyb3IpIHtcbiAgICB2YXIgc2VsZiA9IHRoaXM7XG4gICAgaWYgKHNlbGYuX2lzRGVhY3RpdmF0ZWQoKSlcbiAgICAgIHJldHVybjtcbiAgICBzZWxmLl9zZXNzaW9uLl9zdG9wU3Vic2NyaXB0aW9uKHNlbGYuX3N1YnNjcmlwdGlvbklkLCBlcnJvcik7XG4gIH0sXG5cbiAgLy8gTm90ZSB0aGF0IHdoaWxlIG91ciBERFAgY2xpZW50IHdpbGwgbm90aWNlIHRoYXQgeW91J3ZlIGNhbGxlZCBzdG9wKCkgb24gdGhlXG4gIC8vIHNlcnZlciAoYW5kIGNsZWFuIHVwIGl0cyBfc3Vic2NyaXB0aW9ucyB0YWJsZSkgd2UgZG9uJ3QgYWN0dWFsbHkgcHJvdmlkZSBhXG4gIC8vIG1lY2hhbmlzbSBmb3IgYW4gYXBwIHRvIG5vdGljZSB0aGlzICh0aGUgc3Vic2NyaWJlIG9uRXJyb3IgY2FsbGJhY2sgb25seVxuICAvLyB0cmlnZ2VycyBpZiB0aGVyZSBpcyBhbiBlcnJvcikuXG5cbiAgLyoqXG4gICAqIEBzdW1tYXJ5IENhbGwgaW5zaWRlIHRoZSBwdWJsaXNoIGZ1bmN0aW9uLiAgU3RvcHMgdGhpcyBjbGllbnQncyBzdWJzY3JpcHRpb24gYW5kIGludm9rZXMgdGhlIGNsaWVudCdzIGBvblN0b3BgIGNhbGxiYWNrIHdpdGggbm8gZXJyb3IuXG4gICAqIEBsb2N1cyBTZXJ2ZXJcbiAgICogQGluc3RhbmNlXG4gICAqIEBtZW1iZXJPZiBTdWJzY3JpcHRpb25cbiAgICovXG4gIHN0b3A6IGZ1bmN0aW9uICgpIHtcbiAgICB2YXIgc2VsZiA9IHRoaXM7XG4gICAgaWYgKHNlbGYuX2lzRGVhY3RpdmF0ZWQoKSlcbiAgICAgIHJldHVybjtcbiAgICBzZWxmLl9zZXNzaW9uLl9zdG9wU3Vic2NyaXB0aW9uKHNlbGYuX3N1YnNjcmlwdGlvbklkKTtcbiAgfSxcblxuICAvKipcbiAgICogQHN1bW1hcnkgQ2FsbCBpbnNpZGUgdGhlIHB1Ymxpc2ggZnVuY3Rpb24uICBSZWdpc3RlcnMgYSBjYWxsYmFjayBmdW5jdGlvbiB0byBydW4gd2hlbiB0aGUgc3Vic2NyaXB0aW9uIGlzIHN0b3BwZWQuXG4gICAqIEBsb2N1cyBTZXJ2ZXJcbiAgICogQG1lbWJlck9mIFN1YnNjcmlwdGlvblxuICAgKiBAaW5zdGFuY2VcbiAgICogQHBhcmFtIHtGdW5jdGlvbn0gZnVuYyBUaGUgY2FsbGJhY2sgZnVuY3Rpb25cbiAgICovXG4gIG9uU3RvcDogZnVuY3Rpb24gKGNhbGxiYWNrKSB7XG4gICAgdmFyIHNlbGYgPSB0aGlzO1xuICAgIGNhbGxiYWNrID0gTWV0ZW9yLmJpbmRFbnZpcm9ubWVudChjYWxsYmFjaywgJ29uU3RvcCBjYWxsYmFjaycsIHNlbGYpO1xuICAgIGlmIChzZWxmLl9pc0RlYWN0aXZhdGVkKCkpXG4gICAgICBjYWxsYmFjaygpO1xuICAgIGVsc2VcbiAgICAgIHNlbGYuX3N0b3BDYWxsYmFja3MucHVzaChjYWxsYmFjayk7XG4gIH0sXG5cbiAgLy8gVGhpcyByZXR1cm5zIHRydWUgaWYgdGhlIHN1YiBoYXMgYmVlbiBkZWFjdGl2YXRlZCwgKk9SKiBpZiB0aGUgc2Vzc2lvbiB3YXNcbiAgLy8gZGVzdHJveWVkIGJ1dCB0aGUgZGVmZXJyZWQgY2FsbCB0byBfZGVhY3RpdmF0ZUFsbFN1YnNjcmlwdGlvbnMgaGFzbid0XG4gIC8vIGhhcHBlbmVkIHlldC5cbiAgX2lzRGVhY3RpdmF0ZWQ6IGZ1bmN0aW9uICgpIHtcbiAgICB2YXIgc2VsZiA9IHRoaXM7XG4gICAgcmV0dXJuIHNlbGYuX2RlYWN0aXZhdGVkIHx8IHNlbGYuX3Nlc3Npb24uaW5RdWV1ZSA9PT0gbnVsbDtcbiAgfSxcblxuICAvKipcbiAgICogQHN1bW1hcnkgQ2FsbCBpbnNpZGUgdGhlIHB1Ymxpc2ggZnVuY3Rpb24uICBJbmZvcm1zIHRoZSBzdWJzY3JpYmVyIHRoYXQgYSBkb2N1bWVudCBoYXMgYmVlbiBhZGRlZCB0byB0aGUgcmVjb3JkIHNldC5cbiAgICogQGxvY3VzIFNlcnZlclxuICAgKiBAbWVtYmVyT2YgU3Vic2NyaXB0aW9uXG4gICAqIEBpbnN0YW5jZVxuICAgKiBAcGFyYW0ge1N0cmluZ30gY29sbGVjdGlvbiBUaGUgbmFtZSBvZiB0aGUgY29sbGVjdGlvbiB0aGF0IGNvbnRhaW5zIHRoZSBuZXcgZG9jdW1lbnQuXG4gICAqIEBwYXJhbSB7U3RyaW5nfSBpZCBUaGUgbmV3IGRvY3VtZW50J3MgSUQuXG4gICAqIEBwYXJhbSB7T2JqZWN0fSBmaWVsZHMgVGhlIGZpZWxkcyBpbiB0aGUgbmV3IGRvY3VtZW50LiAgSWYgYF9pZGAgaXMgcHJlc2VudCBpdCBpcyBpZ25vcmVkLlxuICAgKi9cbiAgYWRkZWQgKGNvbGxlY3Rpb25OYW1lLCBpZCwgZmllbGRzKSB7XG4gICAgaWYgKHRoaXMuX2lzRGVhY3RpdmF0ZWQoKSlcbiAgICAgIHJldHVybjtcbiAgICBpZCA9IHRoaXMuX2lkRmlsdGVyLmlkU3RyaW5naWZ5KGlkKTtcblxuICAgIGlmICh0aGlzLl9zZXNzaW9uLnNlcnZlci5nZXRQdWJsaWNhdGlvblN0cmF0ZWd5KGNvbGxlY3Rpb25OYW1lKS5kb0FjY291bnRpbmdGb3JDb2xsZWN0aW9uKSB7XG4gICAgICBsZXQgaWRzID0gdGhpcy5fZG9jdW1lbnRzLmdldChjb2xsZWN0aW9uTmFtZSk7XG4gICAgICBpZiAoaWRzID09IG51bGwpIHtcbiAgICAgICAgaWRzID0gbmV3IFNldCgpO1xuICAgICAgICB0aGlzLl9kb2N1bWVudHMuc2V0KGNvbGxlY3Rpb25OYW1lLCBpZHMpO1xuICAgICAgfVxuICAgICAgaWRzLmFkZChpZCk7XG4gICAgfVxuXG4gICAgdGhpcy5fc2Vzc2lvbi5hZGRlZCh0aGlzLl9zdWJzY3JpcHRpb25IYW5kbGUsIGNvbGxlY3Rpb25OYW1lLCBpZCwgZmllbGRzKTtcbiAgfSxcblxuICAvKipcbiAgICogQHN1bW1hcnkgQ2FsbCBpbnNpZGUgdGhlIHB1Ymxpc2ggZnVuY3Rpb24uICBJbmZvcm1zIHRoZSBzdWJzY3JpYmVyIHRoYXQgYSBkb2N1bWVudCBpbiB0aGUgcmVjb3JkIHNldCBoYXMgYmVlbiBtb2RpZmllZC5cbiAgICogQGxvY3VzIFNlcnZlclxuICAgKiBAbWVtYmVyT2YgU3Vic2NyaXB0aW9uXG4gICAqIEBpbnN0YW5jZVxuICAgKiBAcGFyYW0ge1N0cmluZ30gY29sbGVjdGlvbiBUaGUgbmFtZSBvZiB0aGUgY29sbGVjdGlvbiB0aGF0IGNvbnRhaW5zIHRoZSBjaGFuZ2VkIGRvY3VtZW50LlxuICAgKiBAcGFyYW0ge1N0cmluZ30gaWQgVGhlIGNoYW5nZWQgZG9jdW1lbnQncyBJRC5cbiAgICogQHBhcmFtIHtPYmplY3R9IGZpZWxkcyBUaGUgZmllbGRzIGluIHRoZSBkb2N1bWVudCB0aGF0IGhhdmUgY2hhbmdlZCwgdG9nZXRoZXIgd2l0aCB0aGVpciBuZXcgdmFsdWVzLiAgSWYgYSBmaWVsZCBpcyBub3QgcHJlc2VudCBpbiBgZmllbGRzYCBpdCB3YXMgbGVmdCB1bmNoYW5nZWQ7IGlmIGl0IGlzIHByZXNlbnQgaW4gYGZpZWxkc2AgYW5kIGhhcyBhIHZhbHVlIG9mIGB1bmRlZmluZWRgIGl0IHdhcyByZW1vdmVkIGZyb20gdGhlIGRvY3VtZW50LiAgSWYgYF9pZGAgaXMgcHJlc2VudCBpdCBpcyBpZ25vcmVkLlxuICAgKi9cbiAgY2hhbmdlZCAoY29sbGVjdGlvbk5hbWUsIGlkLCBmaWVsZHMpIHtcbiAgICBpZiAodGhpcy5faXNEZWFjdGl2YXRlZCgpKVxuICAgICAgcmV0dXJuO1xuICAgIGlkID0gdGhpcy5faWRGaWx0ZXIuaWRTdHJpbmdpZnkoaWQpO1xuICAgIHRoaXMuX3Nlc3Npb24uY2hhbmdlZCh0aGlzLl9zdWJzY3JpcHRpb25IYW5kbGUsIGNvbGxlY3Rpb25OYW1lLCBpZCwgZmllbGRzKTtcbiAgfSxcblxuICAvKipcbiAgICogQHN1bW1hcnkgQ2FsbCBpbnNpZGUgdGhlIHB1Ymxpc2ggZnVuY3Rpb24uICBJbmZvcm1zIHRoZSBzdWJzY3JpYmVyIHRoYXQgYSBkb2N1bWVudCBoYXMgYmVlbiByZW1vdmVkIGZyb20gdGhlIHJlY29yZCBzZXQuXG4gICAqIEBsb2N1cyBTZXJ2ZXJcbiAgICogQG1lbWJlck9mIFN1YnNjcmlwdGlvblxuICAgKiBAaW5zdGFuY2VcbiAgICogQHBhcmFtIHtTdHJpbmd9IGNvbGxlY3Rpb24gVGhlIG5hbWUgb2YgdGhlIGNvbGxlY3Rpb24gdGhhdCB0aGUgZG9jdW1lbnQgaGFzIGJlZW4gcmVtb3ZlZCBmcm9tLlxuICAgKiBAcGFyYW0ge1N0cmluZ30gaWQgVGhlIElEIG9mIHRoZSBkb2N1bWVudCB0aGF0IGhhcyBiZWVuIHJlbW92ZWQuXG4gICAqL1xuICByZW1vdmVkIChjb2xsZWN0aW9uTmFtZSwgaWQpIHtcbiAgICBpZiAodGhpcy5faXNEZWFjdGl2YXRlZCgpKVxuICAgICAgcmV0dXJuO1xuICAgIGlkID0gdGhpcy5faWRGaWx0ZXIuaWRTdHJpbmdpZnkoaWQpO1xuXG4gICAgaWYgKHRoaXMuX3Nlc3Npb24uc2VydmVyLmdldFB1YmxpY2F0aW9uU3RyYXRlZ3koY29sbGVjdGlvbk5hbWUpLmRvQWNjb3VudGluZ0ZvckNvbGxlY3Rpb24pIHtcbiAgICAgIC8vIFdlIGRvbid0IGJvdGhlciB0byBkZWxldGUgc2V0cyBvZiB0aGluZ3MgaW4gYSBjb2xsZWN0aW9uIGlmIHRoZVxuICAgICAgLy8gY29sbGVjdGlvbiBpcyBlbXB0eS4gIEl0IGNvdWxkIGJyZWFrIF9yZW1vdmVBbGxEb2N1bWVudHMuXG4gICAgICB0aGlzLl9kb2N1bWVudHMuZ2V0KGNvbGxlY3Rpb25OYW1lKS5kZWxldGUoaWQpO1xuICAgIH1cblxuICAgIHRoaXMuX3Nlc3Npb24ucmVtb3ZlZCh0aGlzLl9zdWJzY3JpcHRpb25IYW5kbGUsIGNvbGxlY3Rpb25OYW1lLCBpZCk7XG4gIH0sXG5cbiAgLyoqXG4gICAqIEBzdW1tYXJ5IENhbGwgaW5zaWRlIHRoZSBwdWJsaXNoIGZ1bmN0aW9uLiAgSW5mb3JtcyB0aGUgc3Vic2NyaWJlciB0aGF0IGFuIGluaXRpYWwsIGNvbXBsZXRlIHNuYXBzaG90IG9mIHRoZSByZWNvcmQgc2V0IGhhcyBiZWVuIHNlbnQuICBUaGlzIHdpbGwgdHJpZ2dlciBhIGNhbGwgb24gdGhlIGNsaWVudCB0byB0aGUgYG9uUmVhZHlgIGNhbGxiYWNrIHBhc3NlZCB0byAgW2BNZXRlb3Iuc3Vic2NyaWJlYF0oI21ldGVvcl9zdWJzY3JpYmUpLCBpZiBhbnkuXG4gICAqIEBsb2N1cyBTZXJ2ZXJcbiAgICogQG1lbWJlck9mIFN1YnNjcmlwdGlvblxuICAgKiBAaW5zdGFuY2VcbiAgICovXG4gIHJlYWR5OiBmdW5jdGlvbiAoKSB7XG4gICAgdmFyIHNlbGYgPSB0aGlzO1xuICAgIGlmIChzZWxmLl9pc0RlYWN0aXZhdGVkKCkpXG4gICAgICByZXR1cm47XG4gICAgaWYgKCFzZWxmLl9zdWJzY3JpcHRpb25JZClcbiAgICAgIHJldHVybjsgIC8vIFVubmVjZXNzYXJ5IGJ1dCBpZ25vcmVkIGZvciB1bml2ZXJzYWwgc3ViXG4gICAgaWYgKCFzZWxmLl9yZWFkeSkge1xuICAgICAgc2VsZi5fc2Vzc2lvbi5zZW5kUmVhZHkoW3NlbGYuX3N1YnNjcmlwdGlvbklkXSk7XG4gICAgICBzZWxmLl9yZWFkeSA9IHRydWU7XG4gICAgfVxuICB9XG59KTtcblxuLyoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKi9cbi8qIFNlcnZlciAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICovXG4vKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqL1xuXG5TZXJ2ZXIgPSBmdW5jdGlvbiAob3B0aW9ucyA9IHt9KSB7XG4gIHZhciBzZWxmID0gdGhpcztcblxuICAvLyBUaGUgZGVmYXVsdCBoZWFydGJlYXQgaW50ZXJ2YWwgaXMgMzAgc2Vjb25kcyBvbiB0aGUgc2VydmVyIGFuZCAzNVxuICAvLyBzZWNvbmRzIG9uIHRoZSBjbGllbnQuICBTaW5jZSB0aGUgY2xpZW50IGRvZXNuJ3QgbmVlZCB0byBzZW5kIGFcbiAgLy8gcGluZyBhcyBsb25nIGFzIGl0IGlzIHJlY2VpdmluZyBwaW5ncywgdGhpcyBtZWFucyB0aGF0IHBpbmdzXG4gIC8vIG5vcm1hbGx5IGdvIGZyb20gdGhlIHNlcnZlciB0byB0aGUgY2xpZW50LlxuICAvL1xuICAvLyBOb3RlOiBUcm9wb3NwaGVyZSBkZXBlbmRzIG9uIHRoZSBhYmlsaXR5IHRvIG11dGF0ZVxuICAvLyBNZXRlb3Iuc2VydmVyLm9wdGlvbnMuaGVhcnRiZWF0VGltZW91dCEgVGhpcyBpcyBhIGhhY2ssIGJ1dCBpdCdzIGxpZmUuXG4gIHNlbGYub3B0aW9ucyA9IHtcbiAgICBoZWFydGJlYXRJbnRlcnZhbDogMTUwMDAsXG4gICAgaGVhcnRiZWF0VGltZW91dDogMTUwMDAsXG4gICAgLy8gRm9yIHRlc3RpbmcsIGFsbG93IHJlc3BvbmRpbmcgdG8gcGluZ3MgdG8gYmUgZGlzYWJsZWQuXG4gICAgcmVzcG9uZFRvUGluZ3M6IHRydWUsXG4gICAgZGVmYXVsdFB1YmxpY2F0aW9uU3RyYXRlZ3k6IHB1YmxpY2F0aW9uU3RyYXRlZ2llcy5TRVJWRVJfTUVSR0UsXG4gICAgLi4ub3B0aW9ucyxcbiAgfTtcblxuICAvLyBNYXAgb2YgY2FsbGJhY2tzIHRvIGNhbGwgd2hlbiBhIG5ldyBjb25uZWN0aW9uIGNvbWVzIGluIHRvIHRoZVxuICAvLyBzZXJ2ZXIgYW5kIGNvbXBsZXRlcyBERFAgdmVyc2lvbiBuZWdvdGlhdGlvbi4gVXNlIGFuIG9iamVjdCBpbnN0ZWFkXG4gIC8vIG9mIGFuIGFycmF5IHNvIHdlIGNhbiBzYWZlbHkgcmVtb3ZlIG9uZSBmcm9tIHRoZSBsaXN0IHdoaWxlXG4gIC8vIGl0ZXJhdGluZyBvdmVyIGl0LlxuICBzZWxmLm9uQ29ubmVjdGlvbkhvb2sgPSBuZXcgSG9vayh7XG4gICAgZGVidWdQcmludEV4Y2VwdGlvbnM6IFwib25Db25uZWN0aW9uIGNhbGxiYWNrXCJcbiAgfSk7XG5cbiAgLy8gTWFwIG9mIGNhbGxiYWNrcyB0byBjYWxsIHdoZW4gYSBuZXcgbWVzc2FnZSBjb21lcyBpbi5cbiAgc2VsZi5vbk1lc3NhZ2VIb29rID0gbmV3IEhvb2soe1xuICAgIGRlYnVnUHJpbnRFeGNlcHRpb25zOiBcIm9uTWVzc2FnZSBjYWxsYmFja1wiXG4gIH0pO1xuXG4gIHNlbGYucHVibGlzaF9oYW5kbGVycyA9IHt9O1xuICBzZWxmLnVuaXZlcnNhbF9wdWJsaXNoX2hhbmRsZXJzID0gW107XG5cbiAgc2VsZi5tZXRob2RfaGFuZGxlcnMgPSB7fTtcblxuICBzZWxmLl9wdWJsaWNhdGlvblN0cmF0ZWdpZXMgPSB7fTtcblxuICBzZWxmLnNlc3Npb25zID0gbmV3IE1hcCgpOyAvLyBtYXAgZnJvbSBpZCB0byBzZXNzaW9uXG5cbiAgc2VsZi5zdHJlYW1fc2VydmVyID0gbmV3IFN0cmVhbVNlcnZlcjtcblxuICBzZWxmLnN0cmVhbV9zZXJ2ZXIucmVnaXN0ZXIoZnVuY3Rpb24gKHNvY2tldCkge1xuICAgIC8vIHNvY2tldCBpbXBsZW1lbnRzIHRoZSBTb2NrSlNDb25uZWN0aW9uIGludGVyZmFjZVxuICAgIHNvY2tldC5fbWV0ZW9yU2Vzc2lvbiA9IG51bGw7XG5cbiAgICB2YXIgc2VuZEVycm9yID0gZnVuY3Rpb24gKHJlYXNvbiwgb2ZmZW5kaW5nTWVzc2FnZSkge1xuICAgICAgdmFyIG1zZyA9IHttc2c6ICdlcnJvcicsIHJlYXNvbjogcmVhc29ufTtcbiAgICAgIGlmIChvZmZlbmRpbmdNZXNzYWdlKVxuICAgICAgICBtc2cub2ZmZW5kaW5nTWVzc2FnZSA9IG9mZmVuZGluZ01lc3NhZ2U7XG4gICAgICBzb2NrZXQuc2VuZChERFBDb21tb24uc3RyaW5naWZ5RERQKG1zZykpO1xuICAgIH07XG5cbiAgICBzb2NrZXQub24oJ2RhdGEnLCBmdW5jdGlvbiAocmF3X21zZykge1xuICAgICAgaWYgKE1ldGVvci5fcHJpbnRSZWNlaXZlZEREUCkge1xuICAgICAgICBNZXRlb3IuX2RlYnVnKFwiUmVjZWl2ZWQgRERQXCIsIHJhd19tc2cpO1xuICAgICAgfVxuICAgICAgdHJ5IHtcbiAgICAgICAgdHJ5IHtcbiAgICAgICAgICB2YXIgbXNnID0gRERQQ29tbW9uLnBhcnNlRERQKHJhd19tc2cpO1xuICAgICAgICB9IGNhdGNoIChlcnIpIHtcbiAgICAgICAgICBzZW5kRXJyb3IoJ1BhcnNlIGVycm9yJyk7XG4gICAgICAgICAgcmV0dXJuO1xuICAgICAgICB9XG4gICAgICAgIGlmIChtc2cgPT09IG51bGwgfHwgIW1zZy5tc2cpIHtcbiAgICAgICAgICBzZW5kRXJyb3IoJ0JhZCByZXF1ZXN0JywgbXNnKTtcbiAgICAgICAgICByZXR1cm47XG4gICAgICAgIH1cblxuICAgICAgICBpZiAobXNnLm1zZyA9PT0gJ2Nvbm5lY3QnKSB7XG4gICAgICAgICAgaWYgKHNvY2tldC5fbWV0ZW9yU2Vzc2lvbikge1xuICAgICAgICAgICAgc2VuZEVycm9yKFwiQWxyZWFkeSBjb25uZWN0ZWRcIiwgbXNnKTtcbiAgICAgICAgICAgIHJldHVybjtcbiAgICAgICAgICB9XG4gICAgICAgICAgRmliZXIoZnVuY3Rpb24gKCkge1xuICAgICAgICAgICAgc2VsZi5faGFuZGxlQ29ubmVjdChzb2NrZXQsIG1zZyk7XG4gICAgICAgICAgfSkucnVuKCk7XG4gICAgICAgICAgcmV0dXJuO1xuICAgICAgICB9XG5cbiAgICAgICAgaWYgKCFzb2NrZXQuX21ldGVvclNlc3Npb24pIHtcbiAgICAgICAgICBzZW5kRXJyb3IoJ011c3QgY29ubmVjdCBmaXJzdCcsIG1zZyk7XG4gICAgICAgICAgcmV0dXJuO1xuICAgICAgICB9XG4gICAgICAgIHNvY2tldC5fbWV0ZW9yU2Vzc2lvbi5wcm9jZXNzTWVzc2FnZShtc2cpO1xuICAgICAgfSBjYXRjaCAoZSkge1xuICAgICAgICAvLyBYWFggcHJpbnQgc3RhY2sgbmljZWx5XG4gICAgICAgIE1ldGVvci5fZGVidWcoXCJJbnRlcm5hbCBleGNlcHRpb24gd2hpbGUgcHJvY2Vzc2luZyBtZXNzYWdlXCIsIG1zZywgZSk7XG4gICAgICB9XG4gICAgfSk7XG5cbiAgICBzb2NrZXQub24oJ2Nsb3NlJywgZnVuY3Rpb24gKCkge1xuICAgICAgaWYgKHNvY2tldC5fbWV0ZW9yU2Vzc2lvbikge1xuICAgICAgICBGaWJlcihmdW5jdGlvbiAoKSB7XG4gICAgICAgICAgc29ja2V0Ll9tZXRlb3JTZXNzaW9uLmNsb3NlKCk7XG4gICAgICAgIH0pLnJ1bigpO1xuICAgICAgfVxuICAgIH0pO1xuICB9KTtcbn07XG5cbk9iamVjdC5hc3NpZ24oU2VydmVyLnByb3RvdHlwZSwge1xuXG4gIC8qKlxuICAgKiBAc3VtbWFyeSBSZWdpc3RlciBhIGNhbGxiYWNrIHRvIGJlIGNhbGxlZCB3aGVuIGEgbmV3IEREUCBjb25uZWN0aW9uIGlzIG1hZGUgdG8gdGhlIHNlcnZlci5cbiAgICogQGxvY3VzIFNlcnZlclxuICAgKiBAcGFyYW0ge2Z1bmN0aW9ufSBjYWxsYmFjayBUaGUgZnVuY3Rpb24gdG8gY2FsbCB3aGVuIGEgbmV3IEREUCBjb25uZWN0aW9uIGlzIGVzdGFibGlzaGVkLlxuICAgKiBAbWVtYmVyT2YgTWV0ZW9yXG4gICAqIEBpbXBvcnRGcm9tUGFja2FnZSBtZXRlb3JcbiAgICovXG4gIG9uQ29ubmVjdGlvbjogZnVuY3Rpb24gKGZuKSB7XG4gICAgdmFyIHNlbGYgPSB0aGlzO1xuICAgIHJldHVybiBzZWxmLm9uQ29ubmVjdGlvbkhvb2sucmVnaXN0ZXIoZm4pO1xuICB9LFxuXG4gIC8qKlxuICAgKiBAc3VtbWFyeSBTZXQgcHVibGljYXRpb24gc3RyYXRlZ3kgZm9yIHRoZSBnaXZlbiBwdWJsaWNhdGlvbi4gUHVibGljYXRpb25zIHN0cmF0ZWdpZXMgYXJlIGF2YWlsYWJsZSBmcm9tIGBERFBTZXJ2ZXIucHVibGljYXRpb25TdHJhdGVnaWVzYC4gWW91IGNhbGwgdGhpcyBtZXRob2QgZnJvbSBgTWV0ZW9yLnNlcnZlcmAsIGxpa2UgYE1ldGVvci5zZXJ2ZXIuc2V0UHVibGljYXRpb25TdHJhdGVneSgpYFxuICAgKiBAbG9jdXMgU2VydmVyXG4gICAqIEBhbGlhcyBzZXRQdWJsaWNhdGlvblN0cmF0ZWd5XG4gICAqIEBwYXJhbSBwdWJsaWNhdGlvbk5hbWUge1N0cmluZ31cbiAgICogQHBhcmFtIHN0cmF0ZWd5IHt7dXNlQ29sbGVjdGlvblZpZXc6IGJvb2xlYW4sIGRvQWNjb3VudGluZ0ZvckNvbGxlY3Rpb246IGJvb2xlYW59fVxuICAgKiBAbWVtYmVyT2YgTWV0ZW9yLnNlcnZlclxuICAgKiBAaW1wb3J0RnJvbVBhY2thZ2UgbWV0ZW9yXG4gICAqL1xuICBzZXRQdWJsaWNhdGlvblN0cmF0ZWd5KHB1YmxpY2F0aW9uTmFtZSwgc3RyYXRlZ3kpIHtcbiAgICBpZiAoIU9iamVjdC52YWx1ZXMocHVibGljYXRpb25TdHJhdGVnaWVzKS5pbmNsdWRlcyhzdHJhdGVneSkpIHtcbiAgICAgIHRocm93IG5ldyBFcnJvcihgSW52YWxpZCBtZXJnZSBzdHJhdGVneTogJHtzdHJhdGVneX0gXG4gICAgICAgIGZvciBjb2xsZWN0aW9uICR7cHVibGljYXRpb25OYW1lfWApO1xuICAgIH1cbiAgICB0aGlzLl9wdWJsaWNhdGlvblN0cmF0ZWdpZXNbcHVibGljYXRpb25OYW1lXSA9IHN0cmF0ZWd5O1xuICB9LFxuXG4gIC8qKlxuICAgKiBAc3VtbWFyeSBHZXRzIHRoZSBwdWJsaWNhdGlvbiBzdHJhdGVneSBmb3IgdGhlIHJlcXVlc3RlZCBwdWJsaWNhdGlvbi4gWW91IGNhbGwgdGhpcyBtZXRob2QgZnJvbSBgTWV0ZW9yLnNlcnZlcmAsIGxpa2UgYE1ldGVvci5zZXJ2ZXIuZ2V0UHVibGljYXRpb25TdHJhdGVneSgpYFxuICAgKiBAbG9jdXMgU2VydmVyXG4gICAqIEBhbGlhcyBnZXRQdWJsaWNhdGlvblN0cmF0ZWd5XG4gICAqIEBwYXJhbSBwdWJsaWNhdGlvbk5hbWUge1N0cmluZ31cbiAgICogQG1lbWJlck9mIE1ldGVvci5zZXJ2ZXJcbiAgICogQGltcG9ydEZyb21QYWNrYWdlIG1ldGVvclxuICAgKiBAcmV0dXJuIHt7dXNlQ29sbGVjdGlvblZpZXc6IGJvb2xlYW4sIGRvQWNjb3VudGluZ0ZvckNvbGxlY3Rpb246IGJvb2xlYW59fVxuICAgKi9cbiAgZ2V0UHVibGljYXRpb25TdHJhdGVneShwdWJsaWNhdGlvbk5hbWUpIHtcbiAgICByZXR1cm4gdGhpcy5fcHVibGljYXRpb25TdHJhdGVnaWVzW3B1YmxpY2F0aW9uTmFtZV1cbiAgICAgIHx8IHRoaXMub3B0aW9ucy5kZWZhdWx0UHVibGljYXRpb25TdHJhdGVneTtcbiAgfSxcblxuICAvKipcbiAgICogQHN1bW1hcnkgUmVnaXN0ZXIgYSBjYWxsYmFjayB0byBiZSBjYWxsZWQgd2hlbiBhIG5ldyBERFAgbWVzc2FnZSBpcyByZWNlaXZlZC5cbiAgICogQGxvY3VzIFNlcnZlclxuICAgKiBAcGFyYW0ge2Z1bmN0aW9ufSBjYWxsYmFjayBUaGUgZnVuY3Rpb24gdG8gY2FsbCB3aGVuIGEgbmV3IEREUCBtZXNzYWdlIGlzIHJlY2VpdmVkLlxuICAgKiBAbWVtYmVyT2YgTWV0ZW9yXG4gICAqIEBpbXBvcnRGcm9tUGFja2FnZSBtZXRlb3JcbiAgICovXG4gIG9uTWVzc2FnZTogZnVuY3Rpb24gKGZuKSB7XG4gICAgdmFyIHNlbGYgPSB0aGlzO1xuICAgIHJldHVybiBzZWxmLm9uTWVzc2FnZUhvb2sucmVnaXN0ZXIoZm4pO1xuICB9LFxuXG4gIF9oYW5kbGVDb25uZWN0OiBmdW5jdGlvbiAoc29ja2V0LCBtc2cpIHtcbiAgICB2YXIgc2VsZiA9IHRoaXM7XG5cbiAgICAvLyBUaGUgY29ubmVjdCBtZXNzYWdlIG11c3Qgc3BlY2lmeSBhIHZlcnNpb24gYW5kIGFuIGFycmF5IG9mIHN1cHBvcnRlZFxuICAgIC8vIHZlcnNpb25zLCBhbmQgaXQgbXVzdCBjbGFpbSB0byBzdXBwb3J0IHdoYXQgaXQgaXMgcHJvcG9zaW5nLlxuICAgIGlmICghKHR5cGVvZiAobXNnLnZlcnNpb24pID09PSAnc3RyaW5nJyAmJlxuICAgICAgICAgIF8uaXNBcnJheShtc2cuc3VwcG9ydCkgJiZcbiAgICAgICAgICBfLmFsbChtc2cuc3VwcG9ydCwgXy5pc1N0cmluZykgJiZcbiAgICAgICAgICBfLmNvbnRhaW5zKG1zZy5zdXBwb3J0LCBtc2cudmVyc2lvbikpKSB7XG4gICAgICBzb2NrZXQuc2VuZChERFBDb21tb24uc3RyaW5naWZ5RERQKHttc2c6ICdmYWlsZWQnLFxuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB2ZXJzaW9uOiBERFBDb21tb24uU1VQUE9SVEVEX0REUF9WRVJTSU9OU1swXX0pKTtcbiAgICAgIHNvY2tldC5jbG9zZSgpO1xuICAgICAgcmV0dXJuO1xuICAgIH1cblxuICAgIC8vIEluIHRoZSBmdXR1cmUsIGhhbmRsZSBzZXNzaW9uIHJlc3VtcHRpb246IHNvbWV0aGluZyBsaWtlOlxuICAgIC8vICBzb2NrZXQuX21ldGVvclNlc3Npb24gPSBzZWxmLnNlc3Npb25zW21zZy5zZXNzaW9uXVxuICAgIHZhciB2ZXJzaW9uID0gY2FsY3VsYXRlVmVyc2lvbihtc2cuc3VwcG9ydCwgRERQQ29tbW9uLlNVUFBPUlRFRF9ERFBfVkVSU0lPTlMpO1xuXG4gICAgaWYgKG1zZy52ZXJzaW9uICE9PSB2ZXJzaW9uKSB7XG4gICAgICAvLyBUaGUgYmVzdCB2ZXJzaW9uIHRvIHVzZSAoYWNjb3JkaW5nIHRvIHRoZSBjbGllbnQncyBzdGF0ZWQgcHJlZmVyZW5jZXMpXG4gICAgICAvLyBpcyBub3QgdGhlIG9uZSB0aGUgY2xpZW50IGlzIHRyeWluZyB0byB1c2UuIEluZm9ybSB0aGVtIGFib3V0IHRoZSBiZXN0XG4gICAgICAvLyB2ZXJzaW9uIHRvIHVzZS5cbiAgICAgIHNvY2tldC5zZW5kKEREUENvbW1vbi5zdHJpbmdpZnlERFAoe21zZzogJ2ZhaWxlZCcsIHZlcnNpb246IHZlcnNpb259KSk7XG4gICAgICBzb2NrZXQuY2xvc2UoKTtcbiAgICAgIHJldHVybjtcbiAgICB9XG5cbiAgICAvLyBZYXksIHZlcnNpb24gbWF0Y2hlcyEgQ3JlYXRlIGEgbmV3IHNlc3Npb24uXG4gICAgLy8gTm90ZTogVHJvcG9zcGhlcmUgZGVwZW5kcyBvbiB0aGUgYWJpbGl0eSB0byBtdXRhdGVcbiAgICAvLyBNZXRlb3Iuc2VydmVyLm9wdGlvbnMuaGVhcnRiZWF0VGltZW91dCEgVGhpcyBpcyBhIGhhY2ssIGJ1dCBpdCdzIGxpZmUuXG4gICAgc29ja2V0Ll9tZXRlb3JTZXNzaW9uID0gbmV3IFNlc3Npb24oc2VsZiwgdmVyc2lvbiwgc29ja2V0LCBzZWxmLm9wdGlvbnMpO1xuICAgIHNlbGYuc2Vzc2lvbnMuc2V0KHNvY2tldC5fbWV0ZW9yU2Vzc2lvbi5pZCwgc29ja2V0Ll9tZXRlb3JTZXNzaW9uKTtcbiAgICBzZWxmLm9uQ29ubmVjdGlvbkhvb2suZWFjaChmdW5jdGlvbiAoY2FsbGJhY2spIHtcbiAgICAgIGlmIChzb2NrZXQuX21ldGVvclNlc3Npb24pXG4gICAgICAgIGNhbGxiYWNrKHNvY2tldC5fbWV0ZW9yU2Vzc2lvbi5jb25uZWN0aW9uSGFuZGxlKTtcbiAgICAgIHJldHVybiB0cnVlO1xuICAgIH0pO1xuICB9LFxuICAvKipcbiAgICogUmVnaXN0ZXIgYSBwdWJsaXNoIGhhbmRsZXIgZnVuY3Rpb24uXG4gICAqXG4gICAqIEBwYXJhbSBuYW1lIHtTdHJpbmd9IGlkZW50aWZpZXIgZm9yIHF1ZXJ5XG4gICAqIEBwYXJhbSBoYW5kbGVyIHtGdW5jdGlvbn0gcHVibGlzaCBoYW5kbGVyXG4gICAqIEBwYXJhbSBvcHRpb25zIHtPYmplY3R9XG4gICAqXG4gICAqIFNlcnZlciB3aWxsIGNhbGwgaGFuZGxlciBmdW5jdGlvbiBvbiBlYWNoIG5ldyBzdWJzY3JpcHRpb24sXG4gICAqIGVpdGhlciB3aGVuIHJlY2VpdmluZyBERFAgc3ViIG1lc3NhZ2UgZm9yIGEgbmFtZWQgc3Vic2NyaXB0aW9uLCBvciBvblxuICAgKiBERFAgY29ubmVjdCBmb3IgYSB1bml2ZXJzYWwgc3Vic2NyaXB0aW9uLlxuICAgKlxuICAgKiBJZiBuYW1lIGlzIG51bGwsIHRoaXMgd2lsbCBiZSBhIHN1YnNjcmlwdGlvbiB0aGF0IGlzXG4gICAqIGF1dG9tYXRpY2FsbHkgZXN0YWJsaXNoZWQgYW5kIHBlcm1hbmVudGx5IG9uIGZvciBhbGwgY29ubmVjdGVkXG4gICAqIGNsaWVudCwgaW5zdGVhZCBvZiBhIHN1YnNjcmlwdGlvbiB0aGF0IGNhbiBiZSB0dXJuZWQgb24gYW5kIG9mZlxuICAgKiB3aXRoIHN1YnNjcmliZSgpLlxuICAgKlxuICAgKiBvcHRpb25zIHRvIGNvbnRhaW46XG4gICAqICAtIChtb3N0bHkgaW50ZXJuYWwpIGlzX2F1dG86IHRydWUgaWYgZ2VuZXJhdGVkIGF1dG9tYXRpY2FsbHlcbiAgICogICAgZnJvbSBhbiBhdXRvcHVibGlzaCBob29rLiB0aGlzIGlzIGZvciBjb3NtZXRpYyBwdXJwb3NlcyBvbmx5XG4gICAqICAgIChpdCBsZXRzIHVzIGRldGVybWluZSB3aGV0aGVyIHRvIHByaW50IGEgd2FybmluZyBzdWdnZXN0aW5nXG4gICAqICAgIHRoYXQgeW91IHR1cm4gb2ZmIGF1dG9wdWJsaXNoKS5cbiAgICovXG5cbiAgLyoqXG4gICAqIEBzdW1tYXJ5IFB1Ymxpc2ggYSByZWNvcmQgc2V0LlxuICAgKiBAbWVtYmVyT2YgTWV0ZW9yXG4gICAqIEBpbXBvcnRGcm9tUGFja2FnZSBtZXRlb3JcbiAgICogQGxvY3VzIFNlcnZlclxuICAgKiBAcGFyYW0ge1N0cmluZ3xPYmplY3R9IG5hbWUgSWYgU3RyaW5nLCBuYW1lIG9mIHRoZSByZWNvcmQgc2V0LiAgSWYgT2JqZWN0LCBwdWJsaWNhdGlvbnMgRGljdGlvbmFyeSBvZiBwdWJsaXNoIGZ1bmN0aW9ucyBieSBuYW1lLiAgSWYgYG51bGxgLCB0aGUgc2V0IGhhcyBubyBuYW1lLCBhbmQgdGhlIHJlY29yZCBzZXQgaXMgYXV0b21hdGljYWxseSBzZW50IHRvIGFsbCBjb25uZWN0ZWQgY2xpZW50cy5cbiAgICogQHBhcmFtIHtGdW5jdGlvbn0gZnVuYyBGdW5jdGlvbiBjYWxsZWQgb24gdGhlIHNlcnZlciBlYWNoIHRpbWUgYSBjbGllbnQgc3Vic2NyaWJlcy4gIEluc2lkZSB0aGUgZnVuY3Rpb24sIGB0aGlzYCBpcyB0aGUgcHVibGlzaCBoYW5kbGVyIG9iamVjdCwgZGVzY3JpYmVkIGJlbG93LiAgSWYgdGhlIGNsaWVudCBwYXNzZWQgYXJndW1lbnRzIHRvIGBzdWJzY3JpYmVgLCB0aGUgZnVuY3Rpb24gaXMgY2FsbGVkIHdpdGggdGhlIHNhbWUgYXJndW1lbnRzLlxuICAgKi9cbiAgcHVibGlzaDogZnVuY3Rpb24gKG5hbWUsIGhhbmRsZXIsIG9wdGlvbnMpIHtcbiAgICB2YXIgc2VsZiA9IHRoaXM7XG5cbiAgICBpZiAoISBfLmlzT2JqZWN0KG5hbWUpKSB7XG4gICAgICBvcHRpb25zID0gb3B0aW9ucyB8fCB7fTtcblxuICAgICAgaWYgKG5hbWUgJiYgbmFtZSBpbiBzZWxmLnB1Ymxpc2hfaGFuZGxlcnMpIHtcbiAgICAgICAgTWV0ZW9yLl9kZWJ1ZyhcIklnbm9yaW5nIGR1cGxpY2F0ZSBwdWJsaXNoIG5hbWVkICdcIiArIG5hbWUgKyBcIidcIik7XG4gICAgICAgIHJldHVybjtcbiAgICAgIH1cblxuICAgICAgaWYgKFBhY2thZ2UuYXV0b3B1Ymxpc2ggJiYgIW9wdGlvbnMuaXNfYXV0bykge1xuICAgICAgICAvLyBUaGV5IGhhdmUgYXV0b3B1Ymxpc2ggb24sIHlldCB0aGV5J3JlIHRyeWluZyB0byBtYW51YWxseVxuICAgICAgICAvLyBwaWNrIHN0dWZmIHRvIHB1Ymxpc2guIFRoZXkgcHJvYmFibHkgc2hvdWxkIHR1cm4gb2ZmXG4gICAgICAgIC8vIGF1dG9wdWJsaXNoLiAoVGhpcyBjaGVjayBpc24ndCBwZXJmZWN0IC0tIGlmIHlvdSBjcmVhdGUgYVxuICAgICAgICAvLyBwdWJsaXNoIGJlZm9yZSB5b3UgdHVybiBvbiBhdXRvcHVibGlzaCwgaXQgd29uJ3QgY2F0Y2hcbiAgICAgICAgLy8gaXQsIGJ1dCB0aGlzIHdpbGwgZGVmaW5pdGVseSBoYW5kbGUgdGhlIHNpbXBsZSBjYXNlIHdoZXJlXG4gICAgICAgIC8vIHlvdSd2ZSBhZGRlZCB0aGUgYXV0b3B1Ymxpc2ggcGFja2FnZSB0byB5b3VyIGFwcCwgYW5kIGFyZVxuICAgICAgICAvLyBjYWxsaW5nIHB1Ymxpc2ggZnJvbSB5b3VyIGFwcCBjb2RlKS5cbiAgICAgICAgaWYgKCFzZWxmLndhcm5lZF9hYm91dF9hdXRvcHVibGlzaCkge1xuICAgICAgICAgIHNlbGYud2FybmVkX2Fib3V0X2F1dG9wdWJsaXNoID0gdHJ1ZTtcbiAgICAgICAgICBNZXRlb3IuX2RlYnVnKFxuICAgIFwiKiogWW91J3ZlIHNldCB1cCBzb21lIGRhdGEgc3Vic2NyaXB0aW9ucyB3aXRoIE1ldGVvci5wdWJsaXNoKCksIGJ1dFxcblwiICtcbiAgICBcIioqIHlvdSBzdGlsbCBoYXZlIGF1dG9wdWJsaXNoIHR1cm5lZCBvbi4gQmVjYXVzZSBhdXRvcHVibGlzaCBpcyBzdGlsbFxcblwiICtcbiAgICBcIioqIG9uLCB5b3VyIE1ldGVvci5wdWJsaXNoKCkgY2FsbHMgd29uJ3QgaGF2ZSBtdWNoIGVmZmVjdC4gQWxsIGRhdGFcXG5cIiArXG4gICAgXCIqKiB3aWxsIHN0aWxsIGJlIHNlbnQgdG8gYWxsIGNsaWVudHMuXFxuXCIgK1xuICAgIFwiKipcXG5cIiArXG4gICAgXCIqKiBUdXJuIG9mZiBhdXRvcHVibGlzaCBieSByZW1vdmluZyB0aGUgYXV0b3B1Ymxpc2ggcGFja2FnZTpcXG5cIiArXG4gICAgXCIqKlxcblwiICtcbiAgICBcIioqICAgJCBtZXRlb3IgcmVtb3ZlIGF1dG9wdWJsaXNoXFxuXCIgK1xuICAgIFwiKipcXG5cIiArXG4gICAgXCIqKiAuLiBhbmQgbWFrZSBzdXJlIHlvdSBoYXZlIE1ldGVvci5wdWJsaXNoKCkgYW5kIE1ldGVvci5zdWJzY3JpYmUoKSBjYWxsc1xcblwiICtcbiAgICBcIioqIGZvciBlYWNoIGNvbGxlY3Rpb24gdGhhdCB5b3Ugd2FudCBjbGllbnRzIHRvIHNlZS5cXG5cIik7XG4gICAgICAgIH1cbiAgICAgIH1cblxuICAgICAgaWYgKG5hbWUpXG4gICAgICAgIHNlbGYucHVibGlzaF9oYW5kbGVyc1tuYW1lXSA9IGhhbmRsZXI7XG4gICAgICBlbHNlIHtcbiAgICAgICAgc2VsZi51bml2ZXJzYWxfcHVibGlzaF9oYW5kbGVycy5wdXNoKGhhbmRsZXIpO1xuICAgICAgICAvLyBTcGluIHVwIHRoZSBuZXcgcHVibGlzaGVyIG9uIGFueSBleGlzdGluZyBzZXNzaW9uIHRvby4gUnVuIGVhY2hcbiAgICAgICAgLy8gc2Vzc2lvbidzIHN1YnNjcmlwdGlvbiBpbiBhIG5ldyBGaWJlciwgc28gdGhhdCB0aGVyZSdzIG5vIGNoYW5nZSBmb3JcbiAgICAgICAgLy8gc2VsZi5zZXNzaW9ucyB0byBjaGFuZ2Ugd2hpbGUgd2UncmUgcnVubmluZyB0aGlzIGxvb3AuXG4gICAgICAgIHNlbGYuc2Vzc2lvbnMuZm9yRWFjaChmdW5jdGlvbiAoc2Vzc2lvbikge1xuICAgICAgICAgIGlmICghc2Vzc2lvbi5fZG9udFN0YXJ0TmV3VW5pdmVyc2FsU3Vicykge1xuICAgICAgICAgICAgRmliZXIoZnVuY3Rpb24oKSB7XG4gICAgICAgICAgICAgIHNlc3Npb24uX3N0YXJ0U3Vic2NyaXB0aW9uKGhhbmRsZXIpO1xuICAgICAgICAgICAgfSkucnVuKCk7XG4gICAgICAgICAgfVxuICAgICAgICB9KTtcbiAgICAgIH1cbiAgICB9XG4gICAgZWxzZXtcbiAgICAgIF8uZWFjaChuYW1lLCBmdW5jdGlvbih2YWx1ZSwga2V5KSB7XG4gICAgICAgIHNlbGYucHVibGlzaChrZXksIHZhbHVlLCB7fSk7XG4gICAgICB9KTtcbiAgICB9XG4gIH0sXG5cbiAgX3JlbW92ZVNlc3Npb246IGZ1bmN0aW9uIChzZXNzaW9uKSB7XG4gICAgdmFyIHNlbGYgPSB0aGlzO1xuICAgIHNlbGYuc2Vzc2lvbnMuZGVsZXRlKHNlc3Npb24uaWQpO1xuICB9LFxuXG4gIC8qKlxuICAgKiBAc3VtbWFyeSBEZWZpbmVzIGZ1bmN0aW9ucyB0aGF0IGNhbiBiZSBpbnZva2VkIG92ZXIgdGhlIG5ldHdvcmsgYnkgY2xpZW50cy5cbiAgICogQGxvY3VzIEFueXdoZXJlXG4gICAqIEBwYXJhbSB7T2JqZWN0fSBtZXRob2RzIERpY3Rpb25hcnkgd2hvc2Uga2V5cyBhcmUgbWV0aG9kIG5hbWVzIGFuZCB2YWx1ZXMgYXJlIGZ1bmN0aW9ucy5cbiAgICogQG1lbWJlck9mIE1ldGVvclxuICAgKiBAaW1wb3J0RnJvbVBhY2thZ2UgbWV0ZW9yXG4gICAqL1xuICBtZXRob2RzOiBmdW5jdGlvbiAobWV0aG9kcykge1xuICAgIHZhciBzZWxmID0gdGhpcztcbiAgICBfLmVhY2gobWV0aG9kcywgZnVuY3Rpb24gKGZ1bmMsIG5hbWUpIHtcbiAgICAgIGlmICh0eXBlb2YgZnVuYyAhPT0gJ2Z1bmN0aW9uJylcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKFwiTWV0aG9kICdcIiArIG5hbWUgKyBcIicgbXVzdCBiZSBhIGZ1bmN0aW9uXCIpO1xuICAgICAgaWYgKHNlbGYubWV0aG9kX2hhbmRsZXJzW25hbWVdKVxuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJBIG1ldGhvZCBuYW1lZCAnXCIgKyBuYW1lICsgXCInIGlzIGFscmVhZHkgZGVmaW5lZFwiKTtcbiAgICAgIHNlbGYubWV0aG9kX2hhbmRsZXJzW25hbWVdID0gZnVuYztcbiAgICB9KTtcbiAgfSxcblxuICBjYWxsOiBmdW5jdGlvbiAobmFtZSwgLi4uYXJncykge1xuICAgIGlmIChhcmdzLmxlbmd0aCAmJiB0eXBlb2YgYXJnc1thcmdzLmxlbmd0aCAtIDFdID09PSBcImZ1bmN0aW9uXCIpIHtcbiAgICAgIC8vIElmIGl0J3MgYSBmdW5jdGlvbiwgdGhlIGxhc3QgYXJndW1lbnQgaXMgdGhlIHJlc3VsdCBjYWxsYmFjaywgbm90XG4gICAgICAvLyBhIHBhcmFtZXRlciB0byB0aGUgcmVtb3RlIG1ldGhvZC5cbiAgICAgIHZhciBjYWxsYmFjayA9IGFyZ3MucG9wKCk7XG4gICAgfVxuXG4gICAgcmV0dXJuIHRoaXMuYXBwbHkobmFtZSwgYXJncywgY2FsbGJhY2spO1xuICB9LFxuXG4gIC8vIEEgdmVyc2lvbiBvZiB0aGUgY2FsbCBtZXRob2QgdGhhdCBhbHdheXMgcmV0dXJucyBhIFByb21pc2UuXG4gIGNhbGxBc3luYzogZnVuY3Rpb24gKG5hbWUsIC4uLmFyZ3MpIHtcbiAgICByZXR1cm4gdGhpcy5hcHBseUFzeW5jKG5hbWUsIGFyZ3MpO1xuICB9LFxuXG4gIGFwcGx5OiBmdW5jdGlvbiAobmFtZSwgYXJncywgb3B0aW9ucywgY2FsbGJhY2spIHtcbiAgICAvLyBXZSB3ZXJlIHBhc3NlZCAzIGFyZ3VtZW50cy4gVGhleSBtYXkgYmUgZWl0aGVyIChuYW1lLCBhcmdzLCBvcHRpb25zKVxuICAgIC8vIG9yIChuYW1lLCBhcmdzLCBjYWxsYmFjaylcbiAgICBpZiAoISBjYWxsYmFjayAmJiB0eXBlb2Ygb3B0aW9ucyA9PT0gJ2Z1bmN0aW9uJykge1xuICAgICAgY2FsbGJhY2sgPSBvcHRpb25zO1xuICAgICAgb3B0aW9ucyA9IHt9O1xuICAgIH0gZWxzZSB7XG4gICAgICBvcHRpb25zID0gb3B0aW9ucyB8fCB7fTtcbiAgICB9XG5cbiAgICBjb25zdCBwcm9taXNlID0gdGhpcy5hcHBseUFzeW5jKG5hbWUsIGFyZ3MsIG9wdGlvbnMpO1xuXG4gICAgLy8gUmV0dXJuIHRoZSByZXN1bHQgaW4gd2hpY2hldmVyIHdheSB0aGUgY2FsbGVyIGFza2VkIGZvciBpdC4gTm90ZSB0aGF0IHdlXG4gICAgLy8gZG8gTk9UIGJsb2NrIG9uIHRoZSB3cml0ZSBmZW5jZSBpbiBhbiBhbmFsb2dvdXMgd2F5IHRvIGhvdyB0aGUgY2xpZW50XG4gICAgLy8gYmxvY2tzIG9uIHRoZSByZWxldmFudCBkYXRhIGJlaW5nIHZpc2libGUsIHNvIHlvdSBhcmUgTk9UIGd1YXJhbnRlZWQgdGhhdFxuICAgIC8vIGN1cnNvciBvYnNlcnZlIGNhbGxiYWNrcyBoYXZlIGZpcmVkIHdoZW4geW91ciBjYWxsYmFjayBpcyBpbnZva2VkLiAoV2VcbiAgICAvLyBjYW4gY2hhbmdlIHRoaXMgaWYgdGhlcmUncyBhIHJlYWwgdXNlIGNhc2UpLlxuICAgIGlmIChjYWxsYmFjaykge1xuICAgICAgcHJvbWlzZS50aGVuKFxuICAgICAgICByZXN1bHQgPT4gY2FsbGJhY2sodW5kZWZpbmVkLCByZXN1bHQpLFxuICAgICAgICBleGNlcHRpb24gPT4gY2FsbGJhY2soZXhjZXB0aW9uKVxuICAgICAgKTtcbiAgICB9IGVsc2Uge1xuICAgICAgcmV0dXJuIHByb21pc2UuYXdhaXQoKTtcbiAgICB9XG4gIH0sXG5cbiAgLy8gQHBhcmFtIG9wdGlvbnMge09wdGlvbmFsIE9iamVjdH1cbiAgYXBwbHlBc3luYzogZnVuY3Rpb24gKG5hbWUsIGFyZ3MsIG9wdGlvbnMpIHtcbiAgICAvLyBSdW4gdGhlIGhhbmRsZXJcbiAgICB2YXIgaGFuZGxlciA9IHRoaXMubWV0aG9kX2hhbmRsZXJzW25hbWVdO1xuICAgIGlmICghIGhhbmRsZXIpIHtcbiAgICAgIHJldHVybiBQcm9taXNlLnJlamVjdChcbiAgICAgICAgbmV3IE1ldGVvci5FcnJvcig0MDQsIGBNZXRob2QgJyR7bmFtZX0nIG5vdCBmb3VuZGApXG4gICAgICApO1xuICAgIH1cblxuICAgIC8vIElmIHRoaXMgaXMgYSBtZXRob2QgY2FsbCBmcm9tIHdpdGhpbiBhbm90aGVyIG1ldGhvZCBvciBwdWJsaXNoIGZ1bmN0aW9uLFxuICAgIC8vIGdldCB0aGUgdXNlciBzdGF0ZSBmcm9tIHRoZSBvdXRlciBtZXRob2Qgb3IgcHVibGlzaCBmdW5jdGlvbiwgb3RoZXJ3aXNlXG4gICAgLy8gZG9uJ3QgYWxsb3cgc2V0VXNlcklkIHRvIGJlIGNhbGxlZFxuICAgIHZhciB1c2VySWQgPSBudWxsO1xuICAgIHZhciBzZXRVc2VySWQgPSBmdW5jdGlvbigpIHtcbiAgICAgIHRocm93IG5ldyBFcnJvcihcIkNhbid0IGNhbGwgc2V0VXNlcklkIG9uIGEgc2VydmVyIGluaXRpYXRlZCBtZXRob2QgY2FsbFwiKTtcbiAgICB9O1xuICAgIHZhciBjb25uZWN0aW9uID0gbnVsbDtcbiAgICB2YXIgY3VycmVudE1ldGhvZEludm9jYXRpb24gPSBERFAuX0N1cnJlbnRNZXRob2RJbnZvY2F0aW9uLmdldCgpO1xuICAgIHZhciBjdXJyZW50UHVibGljYXRpb25JbnZvY2F0aW9uID0gRERQLl9DdXJyZW50UHVibGljYXRpb25JbnZvY2F0aW9uLmdldCgpO1xuICAgIHZhciByYW5kb21TZWVkID0gbnVsbDtcbiAgICBpZiAoY3VycmVudE1ldGhvZEludm9jYXRpb24pIHtcbiAgICAgIHVzZXJJZCA9IGN1cnJlbnRNZXRob2RJbnZvY2F0aW9uLnVzZXJJZDtcbiAgICAgIHNldFVzZXJJZCA9IGZ1bmN0aW9uKHVzZXJJZCkge1xuICAgICAgICBjdXJyZW50TWV0aG9kSW52b2NhdGlvbi5zZXRVc2VySWQodXNlcklkKTtcbiAgICAgIH07XG4gICAgICBjb25uZWN0aW9uID0gY3VycmVudE1ldGhvZEludm9jYXRpb24uY29ubmVjdGlvbjtcbiAgICAgIHJhbmRvbVNlZWQgPSBERFBDb21tb24ubWFrZVJwY1NlZWQoY3VycmVudE1ldGhvZEludm9jYXRpb24sIG5hbWUpO1xuICAgIH0gZWxzZSBpZiAoY3VycmVudFB1YmxpY2F0aW9uSW52b2NhdGlvbikge1xuICAgICAgdXNlcklkID0gY3VycmVudFB1YmxpY2F0aW9uSW52b2NhdGlvbi51c2VySWQ7XG4gICAgICBzZXRVc2VySWQgPSBmdW5jdGlvbih1c2VySWQpIHtcbiAgICAgICAgY3VycmVudFB1YmxpY2F0aW9uSW52b2NhdGlvbi5fc2Vzc2lvbi5fc2V0VXNlcklkKHVzZXJJZCk7XG4gICAgICB9O1xuICAgICAgY29ubmVjdGlvbiA9IGN1cnJlbnRQdWJsaWNhdGlvbkludm9jYXRpb24uY29ubmVjdGlvbjtcbiAgICB9XG5cbiAgICB2YXIgaW52b2NhdGlvbiA9IG5ldyBERFBDb21tb24uTWV0aG9kSW52b2NhdGlvbih7XG4gICAgICBpc1NpbXVsYXRpb246IGZhbHNlLFxuICAgICAgdXNlcklkLFxuICAgICAgc2V0VXNlcklkLFxuICAgICAgY29ubmVjdGlvbixcbiAgICAgIHJhbmRvbVNlZWRcbiAgICB9KTtcblxuICAgIHJldHVybiBuZXcgUHJvbWlzZShyZXNvbHZlID0+IHJlc29sdmUoXG4gICAgICBERFAuX0N1cnJlbnRNZXRob2RJbnZvY2F0aW9uLndpdGhWYWx1ZShcbiAgICAgICAgaW52b2NhdGlvbixcbiAgICAgICAgKCkgPT4gbWF5YmVBdWRpdEFyZ3VtZW50Q2hlY2tzKFxuICAgICAgICAgIGhhbmRsZXIsIGludm9jYXRpb24sIEVKU09OLmNsb25lKGFyZ3MpLFxuICAgICAgICAgIFwiaW50ZXJuYWwgY2FsbCB0byAnXCIgKyBuYW1lICsgXCInXCJcbiAgICAgICAgKVxuICAgICAgKVxuICAgICkpLnRoZW4oRUpTT04uY2xvbmUpO1xuICB9LFxuXG4gIF91cmxGb3JTZXNzaW9uOiBmdW5jdGlvbiAoc2Vzc2lvbklkKSB7XG4gICAgdmFyIHNlbGYgPSB0aGlzO1xuICAgIHZhciBzZXNzaW9uID0gc2VsZi5zZXNzaW9ucy5nZXQoc2Vzc2lvbklkKTtcbiAgICBpZiAoc2Vzc2lvbilcbiAgICAgIHJldHVybiBzZXNzaW9uLl9zb2NrZXRVcmw7XG4gICAgZWxzZVxuICAgICAgcmV0dXJuIG51bGw7XG4gIH1cbn0pO1xuXG52YXIgY2FsY3VsYXRlVmVyc2lvbiA9IGZ1bmN0aW9uIChjbGllbnRTdXBwb3J0ZWRWZXJzaW9ucyxcbiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNlcnZlclN1cHBvcnRlZFZlcnNpb25zKSB7XG4gIHZhciBjb3JyZWN0VmVyc2lvbiA9IF8uZmluZChjbGllbnRTdXBwb3J0ZWRWZXJzaW9ucywgZnVuY3Rpb24gKHZlcnNpb24pIHtcbiAgICByZXR1cm4gXy5jb250YWlucyhzZXJ2ZXJTdXBwb3J0ZWRWZXJzaW9ucywgdmVyc2lvbik7XG4gIH0pO1xuICBpZiAoIWNvcnJlY3RWZXJzaW9uKSB7XG4gICAgY29ycmVjdFZlcnNpb24gPSBzZXJ2ZXJTdXBwb3J0ZWRWZXJzaW9uc1swXTtcbiAgfVxuICByZXR1cm4gY29ycmVjdFZlcnNpb247XG59O1xuXG5ERFBTZXJ2ZXIuX2NhbGN1bGF0ZVZlcnNpb24gPSBjYWxjdWxhdGVWZXJzaW9uO1xuXG5cbi8vIFwiYmxpbmRcIiBleGNlcHRpb25zIG90aGVyIHRoYW4gdGhvc2UgdGhhdCB3ZXJlIGRlbGliZXJhdGVseSB0aHJvd24gdG8gc2lnbmFsXG4vLyBlcnJvcnMgdG8gdGhlIGNsaWVudFxudmFyIHdyYXBJbnRlcm5hbEV4Y2VwdGlvbiA9IGZ1bmN0aW9uIChleGNlcHRpb24sIGNvbnRleHQpIHtcbiAgaWYgKCFleGNlcHRpb24pIHJldHVybiBleGNlcHRpb247XG5cbiAgLy8gVG8gYWxsb3cgcGFja2FnZXMgdG8gdGhyb3cgZXJyb3JzIGludGVuZGVkIGZvciB0aGUgY2xpZW50IGJ1dCBub3QgaGF2ZSB0b1xuICAvLyBkZXBlbmQgb24gdGhlIE1ldGVvci5FcnJvciBjbGFzcywgYGlzQ2xpZW50U2FmZWAgY2FuIGJlIHNldCB0byB0cnVlIG9uIGFueVxuICAvLyBlcnJvciBiZWZvcmUgaXQgaXMgdGhyb3duLlxuICBpZiAoZXhjZXB0aW9uLmlzQ2xpZW50U2FmZSkge1xuICAgIGlmICghKGV4Y2VwdGlvbiBpbnN0YW5jZW9mIE1ldGVvci5FcnJvcikpIHtcbiAgICAgIGNvbnN0IG9yaWdpbmFsTWVzc2FnZSA9IGV4Y2VwdGlvbi5tZXNzYWdlO1xuICAgICAgZXhjZXB0aW9uID0gbmV3IE1ldGVvci5FcnJvcihleGNlcHRpb24uZXJyb3IsIGV4Y2VwdGlvbi5yZWFzb24sIGV4Y2VwdGlvbi5kZXRhaWxzKTtcbiAgICAgIGV4Y2VwdGlvbi5tZXNzYWdlID0gb3JpZ2luYWxNZXNzYWdlO1xuICAgIH1cbiAgICByZXR1cm4gZXhjZXB0aW9uO1xuICB9XG5cbiAgLy8gVGVzdHMgY2FuIHNldCB0aGUgJ19leHBlY3RlZEJ5VGVzdCcgZmxhZyBvbiBhbiBleGNlcHRpb24gc28gaXQgd29uJ3QgZ28gdG9cbiAgLy8gdGhlIHNlcnZlciBsb2cuXG4gIGlmICghZXhjZXB0aW9uLl9leHBlY3RlZEJ5VGVzdCkge1xuICAgIE1ldGVvci5fZGVidWcoXCJFeGNlcHRpb24gXCIgKyBjb250ZXh0LCBleGNlcHRpb24uc3RhY2spO1xuICAgIGlmIChleGNlcHRpb24uc2FuaXRpemVkRXJyb3IpIHtcbiAgICAgIE1ldGVvci5fZGVidWcoXCJTYW5pdGl6ZWQgYW5kIHJlcG9ydGVkIHRvIHRoZSBjbGllbnQgYXM6XCIsIGV4Y2VwdGlvbi5zYW5pdGl6ZWRFcnJvcik7XG4gICAgICBNZXRlb3IuX2RlYnVnKCk7XG4gICAgfVxuICB9XG5cbiAgLy8gRGlkIHRoZSBlcnJvciBjb250YWluIG1vcmUgZGV0YWlscyB0aGF0IGNvdWxkIGhhdmUgYmVlbiB1c2VmdWwgaWYgY2F1Z2h0IGluXG4gIC8vIHNlcnZlciBjb2RlIChvciBpZiB0aHJvd24gZnJvbSBub24tY2xpZW50LW9yaWdpbmF0ZWQgY29kZSksIGJ1dCBhbHNvXG4gIC8vIHByb3ZpZGVkIGEgXCJzYW5pdGl6ZWRcIiB2ZXJzaW9uIHdpdGggbW9yZSBjb250ZXh0IHRoYW4gNTAwIEludGVybmFsIHNlcnZlclxuICAvLyBlcnJvcj8gVXNlIHRoYXQuXG4gIGlmIChleGNlcHRpb24uc2FuaXRpemVkRXJyb3IpIHtcbiAgICBpZiAoZXhjZXB0aW9uLnNhbml0aXplZEVycm9yLmlzQ2xpZW50U2FmZSlcbiAgICAgIHJldHVybiBleGNlcHRpb24uc2FuaXRpemVkRXJyb3I7XG4gICAgTWV0ZW9yLl9kZWJ1ZyhcIkV4Y2VwdGlvbiBcIiArIGNvbnRleHQgKyBcIiBwcm92aWRlcyBhIHNhbml0aXplZEVycm9yIHRoYXQgXCIgK1xuICAgICAgICAgICAgICAgICAgXCJkb2VzIG5vdCBoYXZlIGlzQ2xpZW50U2FmZSBwcm9wZXJ0eSBzZXQ7IGlnbm9yaW5nXCIpO1xuICB9XG5cbiAgcmV0dXJuIG5ldyBNZXRlb3IuRXJyb3IoNTAwLCBcIkludGVybmFsIHNlcnZlciBlcnJvclwiKTtcbn07XG5cblxuLy8gQXVkaXQgYXJndW1lbnQgY2hlY2tzLCBpZiB0aGUgYXVkaXQtYXJndW1lbnQtY2hlY2tzIHBhY2thZ2UgZXhpc3RzIChpdCBpcyBhXG4vLyB3ZWFrIGRlcGVuZGVuY3kgb2YgdGhpcyBwYWNrYWdlKS5cbnZhciBtYXliZUF1ZGl0QXJndW1lbnRDaGVja3MgPSBmdW5jdGlvbiAoZiwgY29udGV4dCwgYXJncywgZGVzY3JpcHRpb24pIHtcbiAgYXJncyA9IGFyZ3MgfHwgW107XG4gIGlmIChQYWNrYWdlWydhdWRpdC1hcmd1bWVudC1jaGVja3MnXSkge1xuICAgIHJldHVybiBNYXRjaC5fZmFpbElmQXJndW1lbnRzQXJlTm90QWxsQ2hlY2tlZChcbiAgICAgIGYsIGNvbnRleHQsIGFyZ3MsIGRlc2NyaXB0aW9uKTtcbiAgfVxuICByZXR1cm4gZi5hcHBseShjb250ZXh0LCBhcmdzKTtcbn07XG4iLCJ2YXIgRnV0dXJlID0gTnBtLnJlcXVpcmUoJ2ZpYmVycy9mdXR1cmUnKTtcblxuLy8gQSB3cml0ZSBmZW5jZSBjb2xsZWN0cyBhIGdyb3VwIG9mIHdyaXRlcywgYW5kIHByb3ZpZGVzIGEgY2FsbGJhY2tcbi8vIHdoZW4gYWxsIG9mIHRoZSB3cml0ZXMgYXJlIGZ1bGx5IGNvbW1pdHRlZCBhbmQgcHJvcGFnYXRlZCAoYWxsXG4vLyBvYnNlcnZlcnMgaGF2ZSBiZWVuIG5vdGlmaWVkIG9mIHRoZSB3cml0ZSBhbmQgYWNrbm93bGVkZ2VkIGl0Lilcbi8vXG5ERFBTZXJ2ZXIuX1dyaXRlRmVuY2UgPSBmdW5jdGlvbiAoKSB7XG4gIHZhciBzZWxmID0gdGhpcztcblxuICBzZWxmLmFybWVkID0gZmFsc2U7XG4gIHNlbGYuZmlyZWQgPSBmYWxzZTtcbiAgc2VsZi5yZXRpcmVkID0gZmFsc2U7XG4gIHNlbGYub3V0c3RhbmRpbmdfd3JpdGVzID0gMDtcbiAgc2VsZi5iZWZvcmVfZmlyZV9jYWxsYmFja3MgPSBbXTtcbiAgc2VsZi5jb21wbGV0aW9uX2NhbGxiYWNrcyA9IFtdO1xufTtcblxuLy8gVGhlIGN1cnJlbnQgd3JpdGUgZmVuY2UuIFdoZW4gdGhlcmUgaXMgYSBjdXJyZW50IHdyaXRlIGZlbmNlLCBjb2RlXG4vLyB0aGF0IHdyaXRlcyB0byBkYXRhYmFzZXMgc2hvdWxkIHJlZ2lzdGVyIHRoZWlyIHdyaXRlcyB3aXRoIGl0IHVzaW5nXG4vLyBiZWdpbldyaXRlKCkuXG4vL1xuRERQU2VydmVyLl9DdXJyZW50V3JpdGVGZW5jZSA9IG5ldyBNZXRlb3IuRW52aXJvbm1lbnRWYXJpYWJsZTtcblxuXy5leHRlbmQoRERQU2VydmVyLl9Xcml0ZUZlbmNlLnByb3RvdHlwZSwge1xuICAvLyBTdGFydCB0cmFja2luZyBhIHdyaXRlLCBhbmQgcmV0dXJuIGFuIG9iamVjdCB0byByZXByZXNlbnQgaXQuIFRoZVxuICAvLyBvYmplY3QgaGFzIGEgc2luZ2xlIG1ldGhvZCwgY29tbWl0dGVkKCkuIFRoaXMgbWV0aG9kIHNob3VsZCBiZVxuICAvLyBjYWxsZWQgd2hlbiB0aGUgd3JpdGUgaXMgZnVsbHkgY29tbWl0dGVkIGFuZCBwcm9wYWdhdGVkLiBZb3UgY2FuXG4gIC8vIGNvbnRpbnVlIHRvIGFkZCB3cml0ZXMgdG8gdGhlIFdyaXRlRmVuY2UgdXAgdW50aWwgaXQgaXMgdHJpZ2dlcmVkXG4gIC8vIChjYWxscyBpdHMgY2FsbGJhY2tzIGJlY2F1c2UgYWxsIHdyaXRlcyBoYXZlIGNvbW1pdHRlZC4pXG4gIGJlZ2luV3JpdGU6IGZ1bmN0aW9uICgpIHtcbiAgICB2YXIgc2VsZiA9IHRoaXM7XG5cbiAgICBpZiAoc2VsZi5yZXRpcmVkKVxuICAgICAgcmV0dXJuIHsgY29tbWl0dGVkOiBmdW5jdGlvbiAoKSB7fSB9O1xuXG4gICAgaWYgKHNlbGYuZmlyZWQpXG4gICAgICB0aHJvdyBuZXcgRXJyb3IoXCJmZW5jZSBoYXMgYWxyZWFkeSBhY3RpdmF0ZWQgLS0gdG9vIGxhdGUgdG8gYWRkIHdyaXRlc1wiKTtcblxuICAgIHNlbGYub3V0c3RhbmRpbmdfd3JpdGVzKys7XG4gICAgdmFyIGNvbW1pdHRlZCA9IGZhbHNlO1xuICAgIHJldHVybiB7XG4gICAgICBjb21taXR0ZWQ6IGZ1bmN0aW9uICgpIHtcbiAgICAgICAgaWYgKGNvbW1pdHRlZClcbiAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJjb21taXR0ZWQgY2FsbGVkIHR3aWNlIG9uIHRoZSBzYW1lIHdyaXRlXCIpO1xuICAgICAgICBjb21taXR0ZWQgPSB0cnVlO1xuICAgICAgICBzZWxmLm91dHN0YW5kaW5nX3dyaXRlcy0tO1xuICAgICAgICBzZWxmLl9tYXliZUZpcmUoKTtcbiAgICAgIH1cbiAgICB9O1xuICB9LFxuXG4gIC8vIEFybSB0aGUgZmVuY2UuIE9uY2UgdGhlIGZlbmNlIGlzIGFybWVkLCBhbmQgdGhlcmUgYXJlIG5vIG1vcmVcbiAgLy8gdW5jb21taXR0ZWQgd3JpdGVzLCBpdCB3aWxsIGFjdGl2YXRlLlxuICBhcm06IGZ1bmN0aW9uICgpIHtcbiAgICB2YXIgc2VsZiA9IHRoaXM7XG4gICAgaWYgKHNlbGYgPT09IEREUFNlcnZlci5fQ3VycmVudFdyaXRlRmVuY2UuZ2V0KCkpXG4gICAgICB0aHJvdyBFcnJvcihcIkNhbid0IGFybSB0aGUgY3VycmVudCBmZW5jZVwiKTtcbiAgICBzZWxmLmFybWVkID0gdHJ1ZTtcbiAgICBzZWxmLl9tYXliZUZpcmUoKTtcbiAgfSxcblxuICAvLyBSZWdpc3RlciBhIGZ1bmN0aW9uIHRvIGJlIGNhbGxlZCBvbmNlIGJlZm9yZSBmaXJpbmcgdGhlIGZlbmNlLlxuICAvLyBDYWxsYmFjayBmdW5jdGlvbiBjYW4gYWRkIG5ldyB3cml0ZXMgdG8gdGhlIGZlbmNlLCBpbiB3aGljaCBjYXNlXG4gIC8vIGl0IHdvbid0IGZpcmUgdW50aWwgdGhvc2Ugd3JpdGVzIGFyZSBkb25lIGFzIHdlbGwuXG4gIG9uQmVmb3JlRmlyZTogZnVuY3Rpb24gKGZ1bmMpIHtcbiAgICB2YXIgc2VsZiA9IHRoaXM7XG4gICAgaWYgKHNlbGYuZmlyZWQpXG4gICAgICB0aHJvdyBuZXcgRXJyb3IoXCJmZW5jZSBoYXMgYWxyZWFkeSBhY3RpdmF0ZWQgLS0gdG9vIGxhdGUgdG8gXCIgK1xuICAgICAgICAgICAgICAgICAgICAgIFwiYWRkIGEgY2FsbGJhY2tcIik7XG4gICAgc2VsZi5iZWZvcmVfZmlyZV9jYWxsYmFja3MucHVzaChmdW5jKTtcbiAgfSxcblxuICAvLyBSZWdpc3RlciBhIGZ1bmN0aW9uIHRvIGJlIGNhbGxlZCB3aGVuIHRoZSBmZW5jZSBmaXJlcy5cbiAgb25BbGxDb21taXR0ZWQ6IGZ1bmN0aW9uIChmdW5jKSB7XG4gICAgdmFyIHNlbGYgPSB0aGlzO1xuICAgIGlmIChzZWxmLmZpcmVkKVxuICAgICAgdGhyb3cgbmV3IEVycm9yKFwiZmVuY2UgaGFzIGFscmVhZHkgYWN0aXZhdGVkIC0tIHRvbyBsYXRlIHRvIFwiICtcbiAgICAgICAgICAgICAgICAgICAgICBcImFkZCBhIGNhbGxiYWNrXCIpO1xuICAgIHNlbGYuY29tcGxldGlvbl9jYWxsYmFja3MucHVzaChmdW5jKTtcbiAgfSxcblxuICAvLyBDb252ZW5pZW5jZSBmdW5jdGlvbi4gQXJtcyB0aGUgZmVuY2UsIHRoZW4gYmxvY2tzIHVudGlsIGl0IGZpcmVzLlxuICBhcm1BbmRXYWl0OiBmdW5jdGlvbiAoKSB7XG4gICAgdmFyIHNlbGYgPSB0aGlzO1xuICAgIHZhciBmdXR1cmUgPSBuZXcgRnV0dXJlO1xuICAgIHNlbGYub25BbGxDb21taXR0ZWQoZnVuY3Rpb24gKCkge1xuICAgICAgZnV0dXJlWydyZXR1cm4nXSgpO1xuICAgIH0pO1xuICAgIHNlbGYuYXJtKCk7XG4gICAgZnV0dXJlLndhaXQoKTtcbiAgfSxcblxuICBfbWF5YmVGaXJlOiBmdW5jdGlvbiAoKSB7XG4gICAgdmFyIHNlbGYgPSB0aGlzO1xuICAgIGlmIChzZWxmLmZpcmVkKVxuICAgICAgdGhyb3cgbmV3IEVycm9yKFwid3JpdGUgZmVuY2UgYWxyZWFkeSBhY3RpdmF0ZWQ/XCIpO1xuICAgIGlmIChzZWxmLmFybWVkICYmICFzZWxmLm91dHN0YW5kaW5nX3dyaXRlcykge1xuICAgICAgZnVuY3Rpb24gaW52b2tlQ2FsbGJhY2sgKGZ1bmMpIHtcbiAgICAgICAgdHJ5IHtcbiAgICAgICAgICBmdW5jKHNlbGYpO1xuICAgICAgICB9IGNhdGNoIChlcnIpIHtcbiAgICAgICAgICBNZXRlb3IuX2RlYnVnKFwiZXhjZXB0aW9uIGluIHdyaXRlIGZlbmNlIGNhbGxiYWNrXCIsIGVycik7XG4gICAgICAgIH1cbiAgICAgIH1cblxuICAgICAgc2VsZi5vdXRzdGFuZGluZ193cml0ZXMrKztcbiAgICAgIHdoaWxlIChzZWxmLmJlZm9yZV9maXJlX2NhbGxiYWNrcy5sZW5ndGggPiAwKSB7XG4gICAgICAgIHZhciBjYWxsYmFja3MgPSBzZWxmLmJlZm9yZV9maXJlX2NhbGxiYWNrcztcbiAgICAgICAgc2VsZi5iZWZvcmVfZmlyZV9jYWxsYmFja3MgPSBbXTtcbiAgICAgICAgXy5lYWNoKGNhbGxiYWNrcywgaW52b2tlQ2FsbGJhY2spO1xuICAgICAgfVxuICAgICAgc2VsZi5vdXRzdGFuZGluZ193cml0ZXMtLTtcblxuICAgICAgaWYgKCFzZWxmLm91dHN0YW5kaW5nX3dyaXRlcykge1xuICAgICAgICBzZWxmLmZpcmVkID0gdHJ1ZTtcbiAgICAgICAgdmFyIGNhbGxiYWNrcyA9IHNlbGYuY29tcGxldGlvbl9jYWxsYmFja3M7XG4gICAgICAgIHNlbGYuY29tcGxldGlvbl9jYWxsYmFja3MgPSBbXTtcbiAgICAgICAgXy5lYWNoKGNhbGxiYWNrcywgaW52b2tlQ2FsbGJhY2spO1xuICAgICAgfVxuICAgIH1cbiAgfSxcblxuICAvLyBEZWFjdGl2YXRlIHRoaXMgZmVuY2Ugc28gdGhhdCBhZGRpbmcgbW9yZSB3cml0ZXMgaGFzIG5vIGVmZmVjdC5cbiAgLy8gVGhlIGZlbmNlIG11c3QgaGF2ZSBhbHJlYWR5IGZpcmVkLlxuICByZXRpcmU6IGZ1bmN0aW9uICgpIHtcbiAgICB2YXIgc2VsZiA9IHRoaXM7XG4gICAgaWYgKCEgc2VsZi5maXJlZClcbiAgICAgIHRocm93IG5ldyBFcnJvcihcIkNhbid0IHJldGlyZSBhIGZlbmNlIHRoYXQgaGFzbid0IGZpcmVkLlwiKTtcbiAgICBzZWxmLnJldGlyZWQgPSB0cnVlO1xuICB9XG59KTtcbiIsIi8vIEEgXCJjcm9zc2JhclwiIGlzIGEgY2xhc3MgdGhhdCBwcm92aWRlcyBzdHJ1Y3R1cmVkIG5vdGlmaWNhdGlvbiByZWdpc3RyYXRpb24uXG4vLyBTZWUgX21hdGNoIGZvciB0aGUgZGVmaW5pdGlvbiBvZiBob3cgYSBub3RpZmljYXRpb24gbWF0Y2hlcyBhIHRyaWdnZXIuXG4vLyBBbGwgbm90aWZpY2F0aW9ucyBhbmQgdHJpZ2dlcnMgbXVzdCBoYXZlIGEgc3RyaW5nIGtleSBuYW1lZCAnY29sbGVjdGlvbicuXG5cbkREUFNlcnZlci5fQ3Jvc3NiYXIgPSBmdW5jdGlvbiAob3B0aW9ucykge1xuICB2YXIgc2VsZiA9IHRoaXM7XG4gIG9wdGlvbnMgPSBvcHRpb25zIHx8IHt9O1xuXG4gIHNlbGYubmV4dElkID0gMTtcbiAgLy8gbWFwIGZyb20gY29sbGVjdGlvbiBuYW1lIChzdHJpbmcpIC0+IGxpc3RlbmVyIGlkIC0+IG9iamVjdC4gZWFjaCBvYmplY3QgaGFzXG4gIC8vIGtleXMgJ3RyaWdnZXInLCAnY2FsbGJhY2snLiAgQXMgYSBoYWNrLCB0aGUgZW1wdHkgc3RyaW5nIG1lYW5zIFwibm9cbiAgLy8gY29sbGVjdGlvblwiLlxuICBzZWxmLmxpc3RlbmVyc0J5Q29sbGVjdGlvbiA9IHt9O1xuICBzZWxmLmxpc3RlbmVyc0J5Q29sbGVjdGlvbkNvdW50ID0ge307XG4gIHNlbGYuZmFjdFBhY2thZ2UgPSBvcHRpb25zLmZhY3RQYWNrYWdlIHx8IFwibGl2ZWRhdGFcIjtcbiAgc2VsZi5mYWN0TmFtZSA9IG9wdGlvbnMuZmFjdE5hbWUgfHwgbnVsbDtcbn07XG5cbl8uZXh0ZW5kKEREUFNlcnZlci5fQ3Jvc3NiYXIucHJvdG90eXBlLCB7XG4gIC8vIG1zZyBpcyBhIHRyaWdnZXIgb3IgYSBub3RpZmljYXRpb25cbiAgX2NvbGxlY3Rpb25Gb3JNZXNzYWdlOiBmdW5jdGlvbiAobXNnKSB7XG4gICAgdmFyIHNlbGYgPSB0aGlzO1xuICAgIGlmICghIF8uaGFzKG1zZywgJ2NvbGxlY3Rpb24nKSkge1xuICAgICAgcmV0dXJuICcnO1xuICAgIH0gZWxzZSBpZiAodHlwZW9mKG1zZy5jb2xsZWN0aW9uKSA9PT0gJ3N0cmluZycpIHtcbiAgICAgIGlmIChtc2cuY29sbGVjdGlvbiA9PT0gJycpXG4gICAgICAgIHRocm93IEVycm9yKFwiTWVzc2FnZSBoYXMgZW1wdHkgY29sbGVjdGlvbiFcIik7XG4gICAgICByZXR1cm4gbXNnLmNvbGxlY3Rpb247XG4gICAgfSBlbHNlIHtcbiAgICAgIHRocm93IEVycm9yKFwiTWVzc2FnZSBoYXMgbm9uLXN0cmluZyBjb2xsZWN0aW9uIVwiKTtcbiAgICB9XG4gIH0sXG5cbiAgLy8gTGlzdGVuIGZvciBub3RpZmljYXRpb24gdGhhdCBtYXRjaCAndHJpZ2dlcicuIEEgbm90aWZpY2F0aW9uXG4gIC8vIG1hdGNoZXMgaWYgaXQgaGFzIHRoZSBrZXktdmFsdWUgcGFpcnMgaW4gdHJpZ2dlciBhcyBhXG4gIC8vIHN1YnNldC4gV2hlbiBhIG5vdGlmaWNhdGlvbiBtYXRjaGVzLCBjYWxsICdjYWxsYmFjaycsIHBhc3NpbmdcbiAgLy8gdGhlIGFjdHVhbCBub3RpZmljYXRpb24uXG4gIC8vXG4gIC8vIFJldHVybnMgYSBsaXN0ZW4gaGFuZGxlLCB3aGljaCBpcyBhbiBvYmplY3Qgd2l0aCBhIG1ldGhvZFxuICAvLyBzdG9wKCkuIENhbGwgc3RvcCgpIHRvIHN0b3AgbGlzdGVuaW5nLlxuICAvL1xuICAvLyBYWFggSXQgc2hvdWxkIGJlIGxlZ2FsIHRvIGNhbGwgZmlyZSgpIGZyb20gaW5zaWRlIGEgbGlzdGVuKClcbiAgLy8gY2FsbGJhY2s/XG4gIGxpc3RlbjogZnVuY3Rpb24gKHRyaWdnZXIsIGNhbGxiYWNrKSB7XG4gICAgdmFyIHNlbGYgPSB0aGlzO1xuICAgIHZhciBpZCA9IHNlbGYubmV4dElkKys7XG5cbiAgICB2YXIgY29sbGVjdGlvbiA9IHNlbGYuX2NvbGxlY3Rpb25Gb3JNZXNzYWdlKHRyaWdnZXIpO1xuICAgIHZhciByZWNvcmQgPSB7dHJpZ2dlcjogRUpTT04uY2xvbmUodHJpZ2dlciksIGNhbGxiYWNrOiBjYWxsYmFja307XG4gICAgaWYgKCEgXy5oYXMoc2VsZi5saXN0ZW5lcnNCeUNvbGxlY3Rpb24sIGNvbGxlY3Rpb24pKSB7XG4gICAgICBzZWxmLmxpc3RlbmVyc0J5Q29sbGVjdGlvbltjb2xsZWN0aW9uXSA9IHt9O1xuICAgICAgc2VsZi5saXN0ZW5lcnNCeUNvbGxlY3Rpb25Db3VudFtjb2xsZWN0aW9uXSA9IDA7XG4gICAgfVxuICAgIHNlbGYubGlzdGVuZXJzQnlDb2xsZWN0aW9uW2NvbGxlY3Rpb25dW2lkXSA9IHJlY29yZDtcbiAgICBzZWxmLmxpc3RlbmVyc0J5Q29sbGVjdGlvbkNvdW50W2NvbGxlY3Rpb25dKys7XG5cbiAgICBpZiAoc2VsZi5mYWN0TmFtZSAmJiBQYWNrYWdlWydmYWN0cy1iYXNlJ10pIHtcbiAgICAgIFBhY2thZ2VbJ2ZhY3RzLWJhc2UnXS5GYWN0cy5pbmNyZW1lbnRTZXJ2ZXJGYWN0KFxuICAgICAgICBzZWxmLmZhY3RQYWNrYWdlLCBzZWxmLmZhY3ROYW1lLCAxKTtcbiAgICB9XG5cbiAgICByZXR1cm4ge1xuICAgICAgc3RvcDogZnVuY3Rpb24gKCkge1xuICAgICAgICBpZiAoc2VsZi5mYWN0TmFtZSAmJiBQYWNrYWdlWydmYWN0cy1iYXNlJ10pIHtcbiAgICAgICAgICBQYWNrYWdlWydmYWN0cy1iYXNlJ10uRmFjdHMuaW5jcmVtZW50U2VydmVyRmFjdChcbiAgICAgICAgICAgIHNlbGYuZmFjdFBhY2thZ2UsIHNlbGYuZmFjdE5hbWUsIC0xKTtcbiAgICAgICAgfVxuICAgICAgICBkZWxldGUgc2VsZi5saXN0ZW5lcnNCeUNvbGxlY3Rpb25bY29sbGVjdGlvbl1baWRdO1xuICAgICAgICBzZWxmLmxpc3RlbmVyc0J5Q29sbGVjdGlvbkNvdW50W2NvbGxlY3Rpb25dLS07XG4gICAgICAgIGlmIChzZWxmLmxpc3RlbmVyc0J5Q29sbGVjdGlvbkNvdW50W2NvbGxlY3Rpb25dID09PSAwKSB7XG4gICAgICAgICAgZGVsZXRlIHNlbGYubGlzdGVuZXJzQnlDb2xsZWN0aW9uW2NvbGxlY3Rpb25dO1xuICAgICAgICAgIGRlbGV0ZSBzZWxmLmxpc3RlbmVyc0J5Q29sbGVjdGlvbkNvdW50W2NvbGxlY3Rpb25dO1xuICAgICAgICB9XG4gICAgICB9XG4gICAgfTtcbiAgfSxcblxuICAvLyBGaXJlIHRoZSBwcm92aWRlZCAnbm90aWZpY2F0aW9uJyAoYW4gb2JqZWN0IHdob3NlIGF0dHJpYnV0ZVxuICAvLyB2YWx1ZXMgYXJlIGFsbCBKU09OLWNvbXBhdGliaWxlKSAtLSBpbmZvcm0gYWxsIG1hdGNoaW5nIGxpc3RlbmVyc1xuICAvLyAocmVnaXN0ZXJlZCB3aXRoIGxpc3RlbigpKS5cbiAgLy9cbiAgLy8gSWYgZmlyZSgpIGlzIGNhbGxlZCBpbnNpZGUgYSB3cml0ZSBmZW5jZSwgdGhlbiBlYWNoIG9mIHRoZVxuICAvLyBsaXN0ZW5lciBjYWxsYmFja3Mgd2lsbCBiZSBjYWxsZWQgaW5zaWRlIHRoZSB3cml0ZSBmZW5jZSBhcyB3ZWxsLlxuICAvL1xuICAvLyBUaGUgbGlzdGVuZXJzIG1heSBiZSBpbnZva2VkIGluIHBhcmFsbGVsLCByYXRoZXIgdGhhbiBzZXJpYWxseS5cbiAgZmlyZTogZnVuY3Rpb24gKG5vdGlmaWNhdGlvbikge1xuICAgIHZhciBzZWxmID0gdGhpcztcblxuICAgIHZhciBjb2xsZWN0aW9uID0gc2VsZi5fY29sbGVjdGlvbkZvck1lc3NhZ2Uobm90aWZpY2F0aW9uKTtcblxuICAgIGlmICghIF8uaGFzKHNlbGYubGlzdGVuZXJzQnlDb2xsZWN0aW9uLCBjb2xsZWN0aW9uKSkge1xuICAgICAgcmV0dXJuO1xuICAgIH1cblxuICAgIHZhciBsaXN0ZW5lcnNGb3JDb2xsZWN0aW9uID0gc2VsZi5saXN0ZW5lcnNCeUNvbGxlY3Rpb25bY29sbGVjdGlvbl07XG4gICAgdmFyIGNhbGxiYWNrSWRzID0gW107XG4gICAgXy5lYWNoKGxpc3RlbmVyc0ZvckNvbGxlY3Rpb24sIGZ1bmN0aW9uIChsLCBpZCkge1xuICAgICAgaWYgKHNlbGYuX21hdGNoZXMobm90aWZpY2F0aW9uLCBsLnRyaWdnZXIpKSB7XG4gICAgICAgIGNhbGxiYWNrSWRzLnB1c2goaWQpO1xuICAgICAgfVxuICAgIH0pO1xuXG4gICAgLy8gTGlzdGVuZXIgY2FsbGJhY2tzIGNhbiB5aWVsZCwgc28gd2UgbmVlZCB0byBmaXJzdCBmaW5kIGFsbCB0aGUgb25lcyB0aGF0XG4gICAgLy8gbWF0Y2ggaW4gYSBzaW5nbGUgaXRlcmF0aW9uIG92ZXIgc2VsZi5saXN0ZW5lcnNCeUNvbGxlY3Rpb24gKHdoaWNoIGNhbid0XG4gICAgLy8gYmUgbXV0YXRlZCBkdXJpbmcgdGhpcyBpdGVyYXRpb24pLCBhbmQgdGhlbiBpbnZva2UgdGhlIG1hdGNoaW5nXG4gICAgLy8gY2FsbGJhY2tzLCBjaGVja2luZyBiZWZvcmUgZWFjaCBjYWxsIHRvIGVuc3VyZSB0aGV5IGhhdmVuJ3Qgc3RvcHBlZC5cbiAgICAvLyBOb3RlIHRoYXQgd2UgZG9uJ3QgaGF2ZSB0byBjaGVjayB0aGF0XG4gICAgLy8gc2VsZi5saXN0ZW5lcnNCeUNvbGxlY3Rpb25bY29sbGVjdGlvbl0gc3RpbGwgPT09IGxpc3RlbmVyc0ZvckNvbGxlY3Rpb24sXG4gICAgLy8gYmVjYXVzZSB0aGUgb25seSB3YXkgdGhhdCBzdG9wcyBiZWluZyB0cnVlIGlzIGlmIGxpc3RlbmVyc0ZvckNvbGxlY3Rpb25cbiAgICAvLyBmaXJzdCBnZXRzIHJlZHVjZWQgZG93biB0byB0aGUgZW1wdHkgb2JqZWN0IChhbmQgdGhlbiBuZXZlciBnZXRzXG4gICAgLy8gaW5jcmVhc2VkIGFnYWluKS5cbiAgICBfLmVhY2goY2FsbGJhY2tJZHMsIGZ1bmN0aW9uIChpZCkge1xuICAgICAgaWYgKF8uaGFzKGxpc3RlbmVyc0ZvckNvbGxlY3Rpb24sIGlkKSkge1xuICAgICAgICBsaXN0ZW5lcnNGb3JDb2xsZWN0aW9uW2lkXS5jYWxsYmFjayhub3RpZmljYXRpb24pO1xuICAgICAgfVxuICAgIH0pO1xuICB9LFxuXG4gIC8vIEEgbm90aWZpY2F0aW9uIG1hdGNoZXMgYSB0cmlnZ2VyIGlmIGFsbCBrZXlzIHRoYXQgZXhpc3QgaW4gYm90aCBhcmUgZXF1YWwuXG4gIC8vXG4gIC8vIEV4YW1wbGVzOlxuICAvLyAgTjp7Y29sbGVjdGlvbjogXCJDXCJ9IG1hdGNoZXMgVDp7Y29sbGVjdGlvbjogXCJDXCJ9XG4gIC8vICAgIChhIG5vbi10YXJnZXRlZCB3cml0ZSB0byBhIGNvbGxlY3Rpb24gbWF0Y2hlcyBhXG4gIC8vICAgICBub24tdGFyZ2V0ZWQgcXVlcnkpXG4gIC8vICBOOntjb2xsZWN0aW9uOiBcIkNcIiwgaWQ6IFwiWFwifSBtYXRjaGVzIFQ6e2NvbGxlY3Rpb246IFwiQ1wifVxuICAvLyAgICAoYSB0YXJnZXRlZCB3cml0ZSB0byBhIGNvbGxlY3Rpb24gbWF0Y2hlcyBhIG5vbi10YXJnZXRlZCBxdWVyeSlcbiAgLy8gIE46e2NvbGxlY3Rpb246IFwiQ1wifSBtYXRjaGVzIFQ6e2NvbGxlY3Rpb246IFwiQ1wiLCBpZDogXCJYXCJ9XG4gIC8vICAgIChhIG5vbi10YXJnZXRlZCB3cml0ZSB0byBhIGNvbGxlY3Rpb24gbWF0Y2hlcyBhXG4gIC8vICAgICB0YXJnZXRlZCBxdWVyeSlcbiAgLy8gIE46e2NvbGxlY3Rpb246IFwiQ1wiLCBpZDogXCJYXCJ9IG1hdGNoZXMgVDp7Y29sbGVjdGlvbjogXCJDXCIsIGlkOiBcIlhcIn1cbiAgLy8gICAgKGEgdGFyZ2V0ZWQgd3JpdGUgdG8gYSBjb2xsZWN0aW9uIG1hdGNoZXMgYSB0YXJnZXRlZCBxdWVyeSB0YXJnZXRlZFxuICAvLyAgICAgYXQgdGhlIHNhbWUgZG9jdW1lbnQpXG4gIC8vICBOOntjb2xsZWN0aW9uOiBcIkNcIiwgaWQ6IFwiWFwifSBkb2VzIG5vdCBtYXRjaCBUOntjb2xsZWN0aW9uOiBcIkNcIiwgaWQ6IFwiWVwifVxuICAvLyAgICAoYSB0YXJnZXRlZCB3cml0ZSB0byBhIGNvbGxlY3Rpb24gZG9lcyBub3QgbWF0Y2ggYSB0YXJnZXRlZCBxdWVyeVxuICAvLyAgICAgdGFyZ2V0ZWQgYXQgYSBkaWZmZXJlbnQgZG9jdW1lbnQpXG4gIF9tYXRjaGVzOiBmdW5jdGlvbiAobm90aWZpY2F0aW9uLCB0cmlnZ2VyKSB7XG4gICAgLy8gTW9zdCBub3RpZmljYXRpb25zIHRoYXQgdXNlIHRoZSBjcm9zc2JhciBoYXZlIGEgc3RyaW5nIGBjb2xsZWN0aW9uYCBhbmRcbiAgICAvLyBtYXliZSBhbiBgaWRgIHRoYXQgaXMgYSBzdHJpbmcgb3IgT2JqZWN0SUQuIFdlJ3JlIGFscmVhZHkgZGl2aWRpbmcgdXBcbiAgICAvLyB0cmlnZ2VycyBieSBjb2xsZWN0aW9uLCBidXQgbGV0J3MgZmFzdC10cmFjayBcIm5vcGUsIGRpZmZlcmVudCBJRFwiIChhbmRcbiAgICAvLyBhdm9pZCB0aGUgb3Zlcmx5IGdlbmVyaWMgRUpTT04uZXF1YWxzKS4gVGhpcyBtYWtlcyBhIG5vdGljZWFibGVcbiAgICAvLyBwZXJmb3JtYW5jZSBkaWZmZXJlbmNlOyBzZWUgaHR0cHM6Ly9naXRodWIuY29tL21ldGVvci9tZXRlb3IvcHVsbC8zNjk3XG4gICAgaWYgKHR5cGVvZihub3RpZmljYXRpb24uaWQpID09PSAnc3RyaW5nJyAmJlxuICAgICAgICB0eXBlb2YodHJpZ2dlci5pZCkgPT09ICdzdHJpbmcnICYmXG4gICAgICAgIG5vdGlmaWNhdGlvbi5pZCAhPT0gdHJpZ2dlci5pZCkge1xuICAgICAgcmV0dXJuIGZhbHNlO1xuICAgIH1cbiAgICBpZiAobm90aWZpY2F0aW9uLmlkIGluc3RhbmNlb2YgTW9uZ29JRC5PYmplY3RJRCAmJlxuICAgICAgICB0cmlnZ2VyLmlkIGluc3RhbmNlb2YgTW9uZ29JRC5PYmplY3RJRCAmJlxuICAgICAgICAhIG5vdGlmaWNhdGlvbi5pZC5lcXVhbHModHJpZ2dlci5pZCkpIHtcbiAgICAgIHJldHVybiBmYWxzZTtcbiAgICB9XG5cbiAgICByZXR1cm4gXy5hbGwodHJpZ2dlciwgZnVuY3Rpb24gKHRyaWdnZXJWYWx1ZSwga2V5KSB7XG4gICAgICByZXR1cm4gIV8uaGFzKG5vdGlmaWNhdGlvbiwga2V5KSB8fFxuICAgICAgICBFSlNPTi5lcXVhbHModHJpZ2dlclZhbHVlLCBub3RpZmljYXRpb25ba2V5XSk7XG4gICAgfSk7XG4gIH1cbn0pO1xuXG4vLyBUaGUgXCJpbnZhbGlkYXRpb24gY3Jvc3NiYXJcIiBpcyBhIHNwZWNpZmljIGluc3RhbmNlIHVzZWQgYnkgdGhlIEREUCBzZXJ2ZXIgdG9cbi8vIGltcGxlbWVudCB3cml0ZSBmZW5jZSBub3RpZmljYXRpb25zLiBMaXN0ZW5lciBjYWxsYmFja3Mgb24gdGhpcyBjcm9zc2JhclxuLy8gc2hvdWxkIGNhbGwgYmVnaW5Xcml0ZSBvbiB0aGUgY3VycmVudCB3cml0ZSBmZW5jZSBiZWZvcmUgdGhleSByZXR1cm4sIGlmIHRoZXlcbi8vIHdhbnQgdG8gZGVsYXkgdGhlIHdyaXRlIGZlbmNlIGZyb20gZmlyaW5nIChpZSwgdGhlIEREUCBtZXRob2QtZGF0YS11cGRhdGVkXG4vLyBtZXNzYWdlIGZyb20gYmVpbmcgc2VudCkuXG5ERFBTZXJ2ZXIuX0ludmFsaWRhdGlvbkNyb3NzYmFyID0gbmV3IEREUFNlcnZlci5fQ3Jvc3NiYXIoe1xuICBmYWN0TmFtZTogXCJpbnZhbGlkYXRpb24tY3Jvc3NiYXItbGlzdGVuZXJzXCJcbn0pO1xuIiwiaWYgKHByb2Nlc3MuZW52LkREUF9ERUZBVUxUX0NPTk5FQ1RJT05fVVJMKSB7XG4gIF9fbWV0ZW9yX3J1bnRpbWVfY29uZmlnX18uRERQX0RFRkFVTFRfQ09OTkVDVElPTl9VUkwgPVxuICAgIHByb2Nlc3MuZW52LkREUF9ERUZBVUxUX0NPTk5FQ1RJT05fVVJMO1xufVxuXG5NZXRlb3Iuc2VydmVyID0gbmV3IFNlcnZlcjtcblxuTWV0ZW9yLnJlZnJlc2ggPSBmdW5jdGlvbiAobm90aWZpY2F0aW9uKSB7XG4gIEREUFNlcnZlci5fSW52YWxpZGF0aW9uQ3Jvc3NiYXIuZmlyZShub3RpZmljYXRpb24pO1xufTtcblxuLy8gUHJveHkgdGhlIHB1YmxpYyBtZXRob2RzIG9mIE1ldGVvci5zZXJ2ZXIgc28gdGhleSBjYW5cbi8vIGJlIGNhbGxlZCBkaXJlY3RseSBvbiBNZXRlb3IuXG5fLmVhY2goWydwdWJsaXNoJywgJ21ldGhvZHMnLCAnY2FsbCcsICdhcHBseScsICdvbkNvbm5lY3Rpb24nLCAnb25NZXNzYWdlJ10sXG4gICAgICAgZnVuY3Rpb24gKG5hbWUpIHtcbiAgICAgICAgIE1ldGVvcltuYW1lXSA9IF8uYmluZChNZXRlb3Iuc2VydmVyW25hbWVdLCBNZXRlb3Iuc2VydmVyKTtcbiAgICAgICB9KTtcbiJdfQ==
