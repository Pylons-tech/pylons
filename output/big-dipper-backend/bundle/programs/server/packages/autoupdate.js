(function () {

/* Imports */
var Meteor = Package.meteor.Meteor;
var global = Package.meteor.global;
var meteorEnv = Package.meteor.meteorEnv;
var WebApp = Package.webapp.WebApp;
var WebAppInternals = Package.webapp.WebAppInternals;
var main = Package.webapp.main;
var check = Package.check.check;
var Match = Package.check.Match;
var ECMAScript = Package.ecmascript.ECMAScript;
var DDP = Package['ddp-client'].DDP;
var DDPServer = Package['ddp-server'].DDPServer;
var meteorInstall = Package.modules.meteorInstall;
var Promise = Package.promise.Promise;

/* Package-scope variables */
var Autoupdate;

var require = meteorInstall({"node_modules":{"meteor":{"autoupdate":{"autoupdate_server.js":function module(require,exports,module){

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                  //
// packages/autoupdate/autoupdate_server.js                                                                         //
//                                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                    //
!function (module1) {
  let _objectSpread;

  module1.link("@babel/runtime/helpers/objectSpread2", {
    default(v) {
      _objectSpread = v;
    }

  }, 0);
  module1.export({
    Autoupdate: () => Autoupdate
  });
  let ClientVersions;
  module1.link("./client_versions.js", {
    ClientVersions(v) {
      ClientVersions = v;
    }

  }, 0);
  let onMessage;
  module1.link("meteor/inter-process-messaging", {
    onMessage(v) {
      onMessage = v;
    }

  }, 1);

  var Future = Npm.require("fibers/future");

  const Autoupdate = __meteor_runtime_config__.autoupdate = {
    // Map from client architectures (web.browser, web.browser.legacy,
    // web.cordova) to version fields { version, versionRefreshable,
    // versionNonRefreshable, refreshable } that will be stored in
    // ClientVersions documents (whose IDs are client architectures). This
    // data gets serialized into the boilerplate because it's stored in
    // __meteor_runtime_config__.autoupdate.versions.
    versions: {}
  };
  // Stores acceptable client versions.
  const clientVersions = new ClientVersions(); // The client hash includes __meteor_runtime_config__, so wait until
  // all packages have loaded and have had a chance to populate the
  // runtime config before using the client hash as our default auto
  // update version id.
  // Note: Tests allow people to override Autoupdate.autoupdateVersion before
  // startup.

  Autoupdate.autoupdateVersion = null;
  Autoupdate.autoupdateVersionRefreshable = null;
  Autoupdate.autoupdateVersionCordova = null;
  Autoupdate.appId = __meteor_runtime_config__.appId = process.env.APP_ID;
  var syncQueue = new Meteor._SynchronousQueue();

  function updateVersions(shouldReloadClientProgram) {
    // Step 1: load the current client program on the server
    if (shouldReloadClientProgram) {
      WebAppInternals.reloadClientPrograms();
    }

    const {
      // If the AUTOUPDATE_VERSION environment variable is defined, it takes
      // precedence, but Autoupdate.autoupdateVersion is still supported as
      // a fallback. In most cases neither of these values will be defined.
      AUTOUPDATE_VERSION = Autoupdate.autoupdateVersion
    } = process.env; // Step 2: update __meteor_runtime_config__.autoupdate.versions.

    const clientArchs = Object.keys(WebApp.clientPrograms);
    clientArchs.forEach(arch => {
      Autoupdate.versions[arch] = {
        version: AUTOUPDATE_VERSION || WebApp.calculateClientHash(arch),
        versionRefreshable: AUTOUPDATE_VERSION || WebApp.calculateClientHashRefreshable(arch),
        versionNonRefreshable: AUTOUPDATE_VERSION || WebApp.calculateClientHashNonRefreshable(arch),
        versionReplaceable: AUTOUPDATE_VERSION || WebApp.calculateClientHashReplaceable(arch),
        versionHmr: WebApp.clientPrograms[arch].hmrVersion
      };
    }); // Step 3: form the new client boilerplate which contains the updated
    // assets and __meteor_runtime_config__.

    if (shouldReloadClientProgram) {
      WebAppInternals.generateBoilerplate();
    } // Step 4: update the ClientVersions collection.
    // We use `onListening` here because we need to use
    // `WebApp.getRefreshableAssets`, which is only set after
    // `WebApp.generateBoilerplate` is called by `main` in webapp.


    WebApp.onListening(() => {
      clientArchs.forEach(arch => {
        const payload = _objectSpread(_objectSpread({}, Autoupdate.versions[arch]), {}, {
          assets: WebApp.getRefreshableAssets(arch)
        });

        clientVersions.set(arch, payload);
      });
    });
  }

  Meteor.publish("meteor_autoupdate_clientVersions", function (appId) {
    // `null` happens when a client doesn't have an appId and passes
    // `undefined` to `Meteor.subscribe`. `undefined` is translated to
    // `null` as JSON doesn't have `undefined.
    check(appId, Match.OneOf(String, undefined, null)); // Don't notify clients using wrong appId such as mobile apps built with a
    // different server but pointing at the same local url

    if (Autoupdate.appId && appId && Autoupdate.appId !== appId) return [];
    const stop = clientVersions.watch((version, isNew) => {
      (isNew ? this.added : this.changed).call(this, "meteor_autoupdate_clientVersions", version._id, version);
    });
    this.onStop(() => stop());
    this.ready();
  }, {
    is_auto: true
  });
  Meteor.startup(function () {
    updateVersions(false); // Force any connected clients that are still looking for these older
    // document IDs to reload.

    ["version", "version-refreshable", "version-cordova"].forEach(_id => {
      clientVersions.set(_id, {
        version: "outdated"
      });
    });
  });
  var fut = new Future(); // We only want 'refresh' to trigger 'updateVersions' AFTER onListen,
  // so we add a queued task that waits for onListen before 'refresh' can queue
  // tasks. Note that the `onListening` callbacks do not fire until after
  // Meteor.startup, so there is no concern that the 'updateVersions' calls from
  // 'refresh' will overlap with the `updateVersions` call from Meteor.startup.

  syncQueue.queueTask(function () {
    fut.wait();
  });
  WebApp.onListening(function () {
    fut.return();
  });

  function enqueueVersionsRefresh() {
    syncQueue.queueTask(function () {
      updateVersions(true);
    });
  } // Listen for messages pertaining to the client-refresh topic.


  onMessage("client-refresh", enqueueVersionsRefresh); // Another way to tell the process to refresh: send SIGHUP signal

  process.on('SIGHUP', Meteor.bindEnvironment(function () {
    enqueueVersionsRefresh();
  }, "handling SIGHUP signal for refresh"));
}.call(this, module);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"client_versions.js":function module(require,exports,module){

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                  //
// packages/autoupdate/client_versions.js                                                                           //
//                                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                    //
let _objectSpread;

module.link("@babel/runtime/helpers/objectSpread2", {
  default(v) {
    _objectSpread = v;
  }

}, 0);
module.export({
  ClientVersions: () => ClientVersions
});
let Tracker;
module.link("meteor/tracker", {
  Tracker(v) {
    Tracker = v;
  }

}, 0);

class ClientVersions {
  constructor() {
    this._versions = new Map();
    this._watchCallbacks = new Set();
  } // Creates a Livedata store for use with `Meteor.connection.registerStore`.
  // After the store is registered, document updates reported by Livedata are
  // merged with the documents in this `ClientVersions` instance.


  createStore() {
    return {
      update: _ref => {
        let {
          id,
          msg,
          fields
        } = _ref;

        if (msg === "added" || msg === "changed") {
          this.set(id, fields);
        }
      }
    };
  }

  hasVersions() {
    return this._versions.size > 0;
  }

  get(id) {
    return this._versions.get(id);
  } // Adds or updates a version document and invokes registered callbacks for the
  // added/updated document. If a document with the given ID already exists, its
  // fields are merged with `fields`.


  set(id, fields) {
    let version = this._versions.get(id);

    let isNew = false;

    if (version) {
      Object.assign(version, fields);
    } else {
      version = _objectSpread({
        _id: id
      }, fields);
      isNew = true;

      this._versions.set(id, version);
    }

    this._watchCallbacks.forEach(_ref2 => {
      let {
        fn,
        filter
      } = _ref2;

      if (!filter || filter === version._id) {
        fn(version, isNew);
      }
    });
  } // Registers a callback that will be invoked when a version document is added
  // or changed. Calling the function returned by `watch` removes the callback.
  // If `skipInitial` is true, the callback isn't be invoked for existing
  // documents. If `filter` is set, the callback is only invoked for documents
  // with ID `filter`.


  watch(fn) {
    let {
      skipInitial,
      filter
    } = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : {};

    if (!skipInitial) {
      const resolved = Promise.resolve();

      this._versions.forEach(version => {
        if (!filter || filter === version._id) {
          resolved.then(() => fn(version, true));
        }
      });
    }

    const callback = {
      fn,
      filter
    };

    this._watchCallbacks.add(callback);

    return () => this._watchCallbacks.delete(callback);
  } // A reactive data source for `Autoupdate.newClientAvailable`.


  newClientAvailable(id, fields, currentVersion) {
    function isNewVersion(version) {
      return version._id === id && fields.some(field => version[field] !== currentVersion[field]);
    }

    const dependency = new Tracker.Dependency();
    const version = this.get(id);
    dependency.depend();
    const stop = this.watch(version => {
      if (isNewVersion(version)) {
        dependency.changed();
        stop();
      }
    }, {
      skipInitial: true
    });
    return !!version && isNewVersion(version);
  }

}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}}}}},{
  "extensions": [
    ".js",
    ".json"
  ]
});

var exports = require("/node_modules/meteor/autoupdate/autoupdate_server.js");

/* Exports */
Package._define("autoupdate", exports, {
  Autoupdate: Autoupdate
});

})();

//# sourceURL=meteor://💻app/packages/autoupdate.js
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvYXV0b3VwZGF0ZS9hdXRvdXBkYXRlX3NlcnZlci5qcyIsIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvYXV0b3VwZGF0ZS9jbGllbnRfdmVyc2lvbnMuanMiXSwibmFtZXMiOlsiX29iamVjdFNwcmVhZCIsIm1vZHVsZTEiLCJsaW5rIiwiZGVmYXVsdCIsInYiLCJleHBvcnQiLCJBdXRvdXBkYXRlIiwiQ2xpZW50VmVyc2lvbnMiLCJvbk1lc3NhZ2UiLCJGdXR1cmUiLCJOcG0iLCJyZXF1aXJlIiwiX19tZXRlb3JfcnVudGltZV9jb25maWdfXyIsImF1dG91cGRhdGUiLCJ2ZXJzaW9ucyIsImNsaWVudFZlcnNpb25zIiwiYXV0b3VwZGF0ZVZlcnNpb24iLCJhdXRvdXBkYXRlVmVyc2lvblJlZnJlc2hhYmxlIiwiYXV0b3VwZGF0ZVZlcnNpb25Db3Jkb3ZhIiwiYXBwSWQiLCJwcm9jZXNzIiwiZW52IiwiQVBQX0lEIiwic3luY1F1ZXVlIiwiTWV0ZW9yIiwiX1N5bmNocm9ub3VzUXVldWUiLCJ1cGRhdGVWZXJzaW9ucyIsInNob3VsZFJlbG9hZENsaWVudFByb2dyYW0iLCJXZWJBcHBJbnRlcm5hbHMiLCJyZWxvYWRDbGllbnRQcm9ncmFtcyIsIkFVVE9VUERBVEVfVkVSU0lPTiIsImNsaWVudEFyY2hzIiwiT2JqZWN0Iiwia2V5cyIsIldlYkFwcCIsImNsaWVudFByb2dyYW1zIiwiZm9yRWFjaCIsImFyY2giLCJ2ZXJzaW9uIiwiY2FsY3VsYXRlQ2xpZW50SGFzaCIsInZlcnNpb25SZWZyZXNoYWJsZSIsImNhbGN1bGF0ZUNsaWVudEhhc2hSZWZyZXNoYWJsZSIsInZlcnNpb25Ob25SZWZyZXNoYWJsZSIsImNhbGN1bGF0ZUNsaWVudEhhc2hOb25SZWZyZXNoYWJsZSIsInZlcnNpb25SZXBsYWNlYWJsZSIsImNhbGN1bGF0ZUNsaWVudEhhc2hSZXBsYWNlYWJsZSIsInZlcnNpb25IbXIiLCJobXJWZXJzaW9uIiwiZ2VuZXJhdGVCb2lsZXJwbGF0ZSIsIm9uTGlzdGVuaW5nIiwicGF5bG9hZCIsImFzc2V0cyIsImdldFJlZnJlc2hhYmxlQXNzZXRzIiwic2V0IiwicHVibGlzaCIsImNoZWNrIiwiTWF0Y2giLCJPbmVPZiIsIlN0cmluZyIsInVuZGVmaW5lZCIsInN0b3AiLCJ3YXRjaCIsImlzTmV3IiwiYWRkZWQiLCJjaGFuZ2VkIiwiY2FsbCIsIl9pZCIsIm9uU3RvcCIsInJlYWR5IiwiaXNfYXV0byIsInN0YXJ0dXAiLCJmdXQiLCJxdWV1ZVRhc2siLCJ3YWl0IiwicmV0dXJuIiwiZW5xdWV1ZVZlcnNpb25zUmVmcmVzaCIsIm9uIiwiYmluZEVudmlyb25tZW50IiwibW9kdWxlIiwiVHJhY2tlciIsImNvbnN0cnVjdG9yIiwiX3ZlcnNpb25zIiwiTWFwIiwiX3dhdGNoQ2FsbGJhY2tzIiwiU2V0IiwiY3JlYXRlU3RvcmUiLCJ1cGRhdGUiLCJpZCIsIm1zZyIsImZpZWxkcyIsImhhc1ZlcnNpb25zIiwic2l6ZSIsImdldCIsImFzc2lnbiIsImZuIiwiZmlsdGVyIiwic2tpcEluaXRpYWwiLCJyZXNvbHZlZCIsIlByb21pc2UiLCJyZXNvbHZlIiwidGhlbiIsImNhbGxiYWNrIiwiYWRkIiwiZGVsZXRlIiwibmV3Q2xpZW50QXZhaWxhYmxlIiwiY3VycmVudFZlcnNpb24iLCJpc05ld1ZlcnNpb24iLCJzb21lIiwiZmllbGQiLCJkZXBlbmRlbmN5IiwiRGVwZW5kZW5jeSIsImRlcGVuZCJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7QUFBQSxNQUFJQSxhQUFKOztBQUFrQkMsU0FBTyxDQUFDQyxJQUFSLENBQWEsc0NBQWIsRUFBb0Q7QUFBQ0MsV0FBTyxDQUFDQyxDQUFELEVBQUc7QUFBQ0osbUJBQWEsR0FBQ0ksQ0FBZDtBQUFnQjs7QUFBNUIsR0FBcEQsRUFBa0YsQ0FBbEY7QUFBbEJILFNBQU8sQ0FBQ0ksTUFBUixDQUFlO0FBQUNDLGNBQVUsRUFBQyxNQUFJQTtBQUFoQixH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Q0FBeEQsQ0FGRjtBQUlEOztBQUVELFVBQU1DLFVBQVUsR0FBRyxJQUFJOUIsT0FBTyxDQUFDK0IsVUFBWixFQUFuQjtBQUNBLFVBQU14RSxPQUFPLEdBQUcsS0FBS3NELEdBQUwsQ0FBU0wsRUFBVCxDQUFoQjtBQUVBc0IsY0FBVSxDQUFDRSxNQUFYO0FBRUEsVUFBTW5ELElBQUksR0FBRyxLQUFLQyxLQUFMLENBQ1Z2QixPQUFELElBQWE7QUFDWCxVQUFJb0UsWUFBWSxDQUFDcEUsT0FBRCxDQUFoQixFQUEyQjtBQUN6QnVFLGtCQUFVLENBQUM3QyxPQUFYO0FBQ0FKLFlBQUk7QUFDTDtBQUNGLEtBTlUsRUFPWDtBQUFFb0MsaUJBQVcsRUFBRTtBQUFmLEtBUFcsQ0FBYjtBQVVBLFdBQU8sQ0FBQyxDQUFFMUQsT0FBSCxJQUFjb0UsWUFBWSxDQUFDcEUsT0FBRCxDQUFqQztBQUNEOztBQXBHeUIsQyIsImZpbGUiOiIvcGFja2FnZXMvYXV0b3VwZGF0ZS5qcyIsInNvdXJjZXNDb250ZW50IjpbIi8vIFB1Ymxpc2ggdGhlIGN1cnJlbnQgY2xpZW50IHZlcnNpb25zIGZvciBlYWNoIGNsaWVudCBhcmNoaXRlY3R1cmVcbi8vICh3ZWIuYnJvd3Nlciwgd2ViLmJyb3dzZXIubGVnYWN5LCB3ZWIuY29yZG92YSkuIFdoZW4gYSBjbGllbnQgb2JzZXJ2ZXNcbi8vIGEgY2hhbmdlIGluIHRoZSB2ZXJzaW9ucyBhc3NvY2lhdGVkIHdpdGggaXRzIGNsaWVudCBhcmNoaXRlY3R1cmUsXG4vLyBpdCB3aWxsIHJlZnJlc2ggaXRzZWxmLCBlaXRoZXIgYnkgc3dhcHBpbmcgb3V0IENTUyBhc3NldHMgb3IgYnlcbi8vIHJlbG9hZGluZyB0aGUgcGFnZS4gQ2hhbmdlcyB0byB0aGUgcmVwbGFjZWFibGUgdmVyc2lvbiBhcmUgaWdub3JlZFxuLy8gYW5kIGhhbmRsZWQgYnkgdGhlIGhvdC1tb2R1bGUtcmVwbGFjZW1lbnQgcGFja2FnZS5cbi8vXG4vLyBUaGVyZSBhcmUgZm91ciB2ZXJzaW9ucyBmb3IgYW55IGdpdmVuIGNsaWVudCBhcmNoaXRlY3R1cmU6IGB2ZXJzaW9uYCxcbi8vIGB2ZXJzaW9uUmVmcmVzaGFibGVgLCBgdmVyc2lvbk5vblJlZnJlc2hhYmxlYCwgYW5kXG4vLyBgdmVyc2lvblJlcGxhY2VhYmxlYC4gVGhlIHJlZnJlc2hhYmxlIHZlcnNpb24gaXMgYSBoYXNoIG9mIGp1c3QgdGhlXG4vLyBjbGllbnQgcmVzb3VyY2VzIHRoYXQgYXJlIHJlZnJlc2hhYmxlLCBzdWNoIGFzIENTUy4gVGhlIHJlcGxhY2VhYmxlXG4vLyB2ZXJzaW9uIGlzIGEgaGFzaCBvZiBmaWxlcyB0aGF0IGNhbiBiZSB1cGRhdGVkIHdpdGggSE1SLiBUaGVcbi8vIG5vbi1yZWZyZXNoYWJsZSB2ZXJzaW9uIGlzIGEgaGFzaCBvZiB0aGUgcmVzdCBvZiB0aGUgY2xpZW50IGFzc2V0cyxcbi8vIGV4Y2x1ZGluZyB0aGUgcmVmcmVzaGFibGUgb25lczogSFRNTCwgSlMgdGhhdCBpcyBub3QgcmVwbGFjZWFibGUsIGFuZFxuLy8gc3RhdGljIGZpbGVzIGluIHRoZSBgcHVibGljYCBkaXJlY3RvcnkuIFRoZSBgdmVyc2lvbmAgdmVyc2lvbiBpcyBhXG4vLyBjb21iaW5lZCBoYXNoIG9mIGV2ZXJ5dGhpbmcuXG4vL1xuLy8gSWYgdGhlIGVudmlyb25tZW50IHZhcmlhYmxlIGBBVVRPVVBEQVRFX1ZFUlNJT05gIGlzIHNldCwgaXQgd2lsbCBiZVxuLy8gdXNlZCBpbiBwbGFjZSBvZiBhbGwgY2xpZW50IHZlcnNpb25zLiBZb3UgY2FuIHVzZSB0aGlzIHZhcmlhYmxlIHRvXG4vLyBjb250cm9sIHdoZW4gdGhlIGNsaWVudCByZWxvYWRzLiBGb3IgZXhhbXBsZSwgaWYgeW91IHdhbnQgdG8gZm9yY2UgYVxuLy8gcmVsb2FkIG9ubHkgYWZ0ZXIgbWFqb3IgY2hhbmdlcywgdXNlIGEgY3VzdG9tIEFVVE9VUERBVEVfVkVSU0lPTiBhbmRcbi8vIGNoYW5nZSBpdCBvbmx5IHdoZW4gc29tZXRoaW5nIHdvcnRoIHB1c2hpbmcgdG8gY2xpZW50cyBoYXBwZW5zLlxuLy9cbi8vIFRoZSBzZXJ2ZXIgcHVibGlzaGVzIGEgYG1ldGVvcl9hdXRvdXBkYXRlX2NsaWVudFZlcnNpb25zYCBjb2xsZWN0aW9uLlxuLy8gVGhlIElEIG9mIGVhY2ggZG9jdW1lbnQgaXMgdGhlIGNsaWVudCBhcmNoaXRlY3R1cmUsIGFuZCB0aGUgZmllbGRzIG9mXG4vLyB0aGUgZG9jdW1lbnQgYXJlIHRoZSB2ZXJzaW9ucyBkZXNjcmliZWQgYWJvdmUuXG5cbmltcG9ydCB7IENsaWVudFZlcnNpb25zIH0gZnJvbSBcIi4vY2xpZW50X3ZlcnNpb25zLmpzXCI7XG52YXIgRnV0dXJlID0gTnBtLnJlcXVpcmUoXCJmaWJlcnMvZnV0dXJlXCIpO1xuXG5leHBvcnQgY29uc3QgQXV0b3VwZGF0ZSA9IF9fbWV0ZW9yX3J1bnRpbWVfY29uZmlnX18uYXV0b3VwZGF0ZSA9IHtcbiAgLy8gTWFwIGZyb20gY2xpZW50IGFyY2hpdGVjdHVyZXMgKHdlYi5icm93c2VyLCB3ZWIuYnJvd3Nlci5sZWdhY3ksXG4gIC8vIHdlYi5jb3Jkb3ZhKSB0byB2ZXJzaW9uIGZpZWxkcyB7IHZlcnNpb24sIHZlcnNpb25SZWZyZXNoYWJsZSxcbiAgLy8gdmVyc2lvbk5vblJlZnJlc2hhYmxlLCByZWZyZXNoYWJsZSB9IHRoYXQgd2lsbCBiZSBzdG9yZWQgaW5cbiAgLy8gQ2xpZW50VmVyc2lvbnMgZG9jdW1lbnRzICh3aG9zZSBJRHMgYXJlIGNsaWVudCBhcmNoaXRlY3R1cmVzKS4gVGhpc1xuICAvLyBkYXRhIGdldHMgc2VyaWFsaXplZCBpbnRvIHRoZSBib2lsZXJwbGF0ZSBiZWNhdXNlIGl0J3Mgc3RvcmVkIGluXG4gIC8vIF9fbWV0ZW9yX3J1bnRpbWVfY29uZmlnX18uYXV0b3VwZGF0ZS52ZXJzaW9ucy5cbiAgdmVyc2lvbnM6IHt9XG59O1xuXG4vLyBTdG9yZXMgYWNjZXB0YWJsZSBjbGllbnQgdmVyc2lvbnMuXG5jb25zdCBjbGllbnRWZXJzaW9ucyA9IG5ldyBDbGllbnRWZXJzaW9ucygpO1xuXG4vLyBUaGUgY2xpZW50IGhhc2ggaW5jbHVkZXMgX19tZXRlb3JfcnVudGltZV9jb25maWdfXywgc28gd2FpdCB1bnRpbFxuLy8gYWxsIHBhY2thZ2VzIGhhdmUgbG9hZGVkIGFuZCBoYXZlIGhhZCBhIGNoYW5jZSB0byBwb3B1bGF0ZSB0aGVcbi8vIHJ1bnRpbWUgY29uZmlnIGJlZm9yZSB1c2luZyB0aGUgY2xpZW50IGhhc2ggYXMgb3VyIGRlZmF1bHQgYXV0b1xuLy8gdXBkYXRlIHZlcnNpb24gaWQuXG5cbi8vIE5vdGU6IFRlc3RzIGFsbG93IHBlb3BsZSB0byBvdmVycmlkZSBBdXRvdXBkYXRlLmF1dG91cGRhdGVWZXJzaW9uIGJlZm9yZVxuLy8gc3RhcnR1cC5cbkF1dG91cGRhdGUuYXV0b3VwZGF0ZVZlcnNpb24gPSBudWxsO1xuQXV0b3VwZGF0ZS5hdXRvdXBkYXRlVmVyc2lvblJlZnJlc2hhYmxlID0gbnVsbDtcbkF1dG91cGRhdGUuYXV0b3VwZGF0ZVZlcnNpb25Db3Jkb3ZhID0gbnVsbDtcbkF1dG91cGRhdGUuYXBwSWQgPSBfX21ldGVvcl9ydW50aW1lX2NvbmZpZ19fLmFwcElkID0gcHJvY2Vzcy5lbnYuQVBQX0lEO1xuXG52YXIgc3luY1F1ZXVlID0gbmV3IE1ldGVvci5fU3luY2hyb25vdXNRdWV1ZSgpO1xuXG5mdW5jdGlvbiB1cGRhdGVWZXJzaW9ucyhzaG91bGRSZWxvYWRDbGllbnRQcm9ncmFtKSB7XG4gIC8vIFN0ZXAgMTogbG9hZCB0aGUgY3VycmVudCBjbGllbnQgcHJvZ3JhbSBvbiB0aGUgc2VydmVyXG4gIGlmIChzaG91bGRSZWxvYWRDbGllbnRQcm9ncmFtKSB7XG4gICAgV2ViQXBwSW50ZXJuYWxzLnJlbG9hZENsaWVudFByb2dyYW1zKCk7XG4gIH1cblxuICBjb25zdCB7XG4gICAgLy8gSWYgdGhlIEFVVE9VUERBVEVfVkVSU0lPTiBlbnZpcm9ubWVudCB2YXJpYWJsZSBpcyBkZWZpbmVkLCBpdCB0YWtlc1xuICAgIC8vIHByZWNlZGVuY2UsIGJ1dCBBdXRvdXBkYXRlLmF1dG91cGRhdGVWZXJzaW9uIGlzIHN0aWxsIHN1cHBvcnRlZCBhc1xuICAgIC8vIGEgZmFsbGJhY2suIEluIG1vc3QgY2FzZXMgbmVpdGhlciBvZiB0aGVzZSB2YWx1ZXMgd2lsbCBiZSBkZWZpbmVkLlxuICAgIEFVVE9VUERBVEVfVkVSU0lPTiA9IEF1dG91cGRhdGUuYXV0b3VwZGF0ZVZlcnNpb25cbiAgfSA9IHByb2Nlc3MuZW52O1xuXG4gIC8vIFN0ZXAgMjogdXBkYXRlIF9fbWV0ZW9yX3J1bnRpbWVfY29uZmlnX18uYXV0b3VwZGF0ZS52ZXJzaW9ucy5cbiAgY29uc3QgY2xpZW50QXJjaHMgPSBPYmplY3Qua2V5cyhXZWJBcHAuY2xpZW50UHJvZ3JhbXMpO1xuICBjbGllbnRBcmNocy5mb3JFYWNoKGFyY2ggPT4ge1xuICAgIEF1dG91cGRhdGUudmVyc2lvbnNbYXJjaF0gPSB7XG4gICAgICB2ZXJzaW9uOiBBVVRPVVBEQVRFX1ZFUlNJT04gfHxcbiAgICAgICAgV2ViQXBwLmNhbGN1bGF0ZUNsaWVudEhhc2goYXJjaCksXG4gICAgICB2ZXJzaW9uUmVmcmVzaGFibGU6IEFVVE9VUERBVEVfVkVSU0lPTiB8fFxuICAgICAgICBXZWJBcHAuY2FsY3VsYXRlQ2xpZW50SGFzaFJlZnJlc2hhYmxlKGFyY2gpLFxuICAgICAgdmVyc2lvbk5vblJlZnJlc2hhYmxlOiBBVVRPVVBEQVRFX1ZFUlNJT04gfHxcbiAgICAgICAgV2ViQXBwLmNhbGN1bGF0ZUNsaWVudEhhc2hOb25SZWZyZXNoYWJsZShhcmNoKSxcbiAgICAgIHZlcnNpb25SZXBsYWNlYWJsZTogQVVUT1VQREFURV9WRVJTSU9OIHx8XG4gICAgICAgIFdlYkFwcC5jYWxjdWxhdGVDbGllbnRIYXNoUmVwbGFjZWFibGUoYXJjaCksXG4gICAgICB2ZXJzaW9uSG1yOiBXZWJBcHAuY2xpZW50UHJvZ3JhbXNbYXJjaF0uaG1yVmVyc2lvblxuICAgIH07XG4gIH0pO1xuXG4gIC8vIFN0ZXAgMzogZm9ybSB0aGUgbmV3IGNsaWVudCBib2lsZXJwbGF0ZSB3aGljaCBjb250YWlucyB0aGUgdXBkYXRlZFxuICAvLyBhc3NldHMgYW5kIF9fbWV0ZW9yX3J1bnRpbWVfY29uZmlnX18uXG4gIGlmIChzaG91bGRSZWxvYWRDbGllbnRQcm9ncmFtKSB7XG4gICAgV2ViQXBwSW50ZXJuYWxzLmdlbmVyYXRlQm9pbGVycGxhdGUoKTtcbiAgfVxuXG4gIC8vIFN0ZXAgNDogdXBkYXRlIHRoZSBDbGllbnRWZXJzaW9ucyBjb2xsZWN0aW9uLlxuICAvLyBXZSB1c2UgYG9uTGlzdGVuaW5nYCBoZXJlIGJlY2F1c2Ugd2UgbmVlZCB0byB1c2VcbiAgLy8gYFdlYkFwcC5nZXRSZWZyZXNoYWJsZUFzc2V0c2AsIHdoaWNoIGlzIG9ubHkgc2V0IGFmdGVyXG4gIC8vIGBXZWJBcHAuZ2VuZXJhdGVCb2lsZXJwbGF0ZWAgaXMgY2FsbGVkIGJ5IGBtYWluYCBpbiB3ZWJhcHAuXG4gIFdlYkFwcC5vbkxpc3RlbmluZygoKSA9PiB7XG4gICAgY2xpZW50QXJjaHMuZm9yRWFjaChhcmNoID0+IHtcbiAgICAgIGNvbnN0IHBheWxvYWQgPSB7XG4gICAgICAgIC4uLkF1dG91cGRhdGUudmVyc2lvbnNbYXJjaF0sXG4gICAgICAgIGFzc2V0czogV2ViQXBwLmdldFJlZnJlc2hhYmxlQXNzZXRzKGFyY2gpLFxuICAgICAgfTtcblxuICAgICAgY2xpZW50VmVyc2lvbnMuc2V0KGFyY2gsIHBheWxvYWQpO1xuICAgIH0pO1xuICB9KTtcbn1cblxuTWV0ZW9yLnB1Ymxpc2goXG4gIFwibWV0ZW9yX2F1dG91cGRhdGVfY2xpZW50VmVyc2lvbnNcIixcbiAgZnVuY3Rpb24gKGFwcElkKSB7XG4gICAgLy8gYG51bGxgIGhhcHBlbnMgd2hlbiBhIGNsaWVudCBkb2Vzbid0IGhhdmUgYW4gYXBwSWQgYW5kIHBhc3Nlc1xuICAgIC8vIGB1bmRlZmluZWRgIHRvIGBNZXRlb3Iuc3Vic2NyaWJlYC4gYHVuZGVmaW5lZGAgaXMgdHJhbnNsYXRlZCB0b1xuICAgIC8vIGBudWxsYCBhcyBKU09OIGRvZXNuJ3QgaGF2ZSBgdW5kZWZpbmVkLlxuICAgIGNoZWNrKGFwcElkLCBNYXRjaC5PbmVPZihTdHJpbmcsIHVuZGVmaW5lZCwgbnVsbCkpO1xuXG4gICAgLy8gRG9uJ3Qgbm90aWZ5IGNsaWVudHMgdXNpbmcgd3JvbmcgYXBwSWQgc3VjaCBhcyBtb2JpbGUgYXBwcyBidWlsdCB3aXRoIGFcbiAgICAvLyBkaWZmZXJlbnQgc2VydmVyIGJ1dCBwb2ludGluZyBhdCB0aGUgc2FtZSBsb2NhbCB1cmxcbiAgICBpZiAoQXV0b3VwZGF0ZS5hcHBJZCAmJiBhcHBJZCAmJiBBdXRvdXBkYXRlLmFwcElkICE9PSBhcHBJZClcbiAgICAgIHJldHVybiBbXTtcblxuICAgIGNvbnN0IHN0b3AgPSBjbGllbnRWZXJzaW9ucy53YXRjaCgodmVyc2lvbiwgaXNOZXcpID0+IHtcbiAgICAgIChpc05ldyA/IHRoaXMuYWRkZWQgOiB0aGlzLmNoYW5nZWQpXG4gICAgICAgIC5jYWxsKHRoaXMsIFwibWV0ZW9yX2F1dG91cGRhdGVfY2xpZW50VmVyc2lvbnNcIiwgdmVyc2lvbi5faWQsIHZlcnNpb24pO1xuICAgIH0pO1xuXG4gICAgdGhpcy5vblN0b3AoKCkgPT4gc3RvcCgpKTtcbiAgICB0aGlzLnJlYWR5KCk7XG4gIH0sXG4gIHtpc19hdXRvOiB0cnVlfVxuKTtcblxuTWV0ZW9yLnN0YXJ0dXAoZnVuY3Rpb24gKCkge1xuICB1cGRhdGVWZXJzaW9ucyhmYWxzZSk7XG5cbiAgLy8gRm9yY2UgYW55IGNvbm5lY3RlZCBjbGllbnRzIHRoYXQgYXJlIHN0aWxsIGxvb2tpbmcgZm9yIHRoZXNlIG9sZGVyXG4gIC8vIGRvY3VtZW50IElEcyB0byByZWxvYWQuXG4gIFtcInZlcnNpb25cIixcbiAgIFwidmVyc2lvbi1yZWZyZXNoYWJsZVwiLFxuICAgXCJ2ZXJzaW9uLWNvcmRvdmFcIixcbiAgXS5mb3JFYWNoKF9pZCA9PiB7XG4gICAgY2xpZW50VmVyc2lvbnMuc2V0KF9pZCwge1xuICAgICAgdmVyc2lvbjogXCJvdXRkYXRlZFwiXG4gICAgfSk7XG4gIH0pO1xufSk7XG5cbnZhciBmdXQgPSBuZXcgRnV0dXJlKCk7XG5cbi8vIFdlIG9ubHkgd2FudCAncmVmcmVzaCcgdG8gdHJpZ2dlciAndXBkYXRlVmVyc2lvbnMnIEFGVEVSIG9uTGlzdGVuLFxuLy8gc28gd2UgYWRkIGEgcXVldWVkIHRhc2sgdGhhdCB3YWl0cyBmb3Igb25MaXN0ZW4gYmVmb3JlICdyZWZyZXNoJyBjYW4gcXVldWVcbi8vIHRhc2tzLiBOb3RlIHRoYXQgdGhlIGBvbkxpc3RlbmluZ2AgY2FsbGJhY2tzIGRvIG5vdCBmaXJlIHVudGlsIGFmdGVyXG4vLyBNZXRlb3Iuc3RhcnR1cCwgc28gdGhlcmUgaXMgbm8gY29uY2VybiB0aGF0IHRoZSAndXBkYXRlVmVyc2lvbnMnIGNhbGxzIGZyb21cbi8vICdyZWZyZXNoJyB3aWxsIG92ZXJsYXAgd2l0aCB0aGUgYHVwZGF0ZVZlcnNpb25zYCBjYWxsIGZyb20gTWV0ZW9yLnN0YXJ0dXAuXG5cbnN5bmNRdWV1ZS5xdWV1ZVRhc2soZnVuY3Rpb24gKCkge1xuICBmdXQud2FpdCgpO1xufSk7XG5cbldlYkFwcC5vbkxpc3RlbmluZyhmdW5jdGlvbiAoKSB7XG4gIGZ1dC5yZXR1cm4oKTtcbn0pO1xuXG5mdW5jdGlvbiBlbnF1ZXVlVmVyc2lvbnNSZWZyZXNoKCkge1xuICBzeW5jUXVldWUucXVldWVUYXNrKGZ1bmN0aW9uICgpIHtcbiAgICB1cGRhdGVWZXJzaW9ucyh0cnVlKTtcbiAgfSk7XG59XG5cbi8vIExpc3RlbiBmb3IgbWVzc2FnZXMgcGVydGFpbmluZyB0byB0aGUgY2xpZW50LXJlZnJlc2ggdG9waWMuXG5pbXBvcnQgeyBvbk1lc3NhZ2UgfSBmcm9tIFwibWV0ZW9yL2ludGVyLXByb2Nlc3MtbWVzc2FnaW5nXCI7XG5vbk1lc3NhZ2UoXCJjbGllbnQtcmVmcmVzaFwiLCBlbnF1ZXVlVmVyc2lvbnNSZWZyZXNoKTtcblxuLy8gQW5vdGhlciB3YXkgdG8gdGVsbCB0aGUgcHJvY2VzcyB0byByZWZyZXNoOiBzZW5kIFNJR0hVUCBzaWduYWxcbnByb2Nlc3Mub24oJ1NJR0hVUCcsIE1ldGVvci5iaW5kRW52aXJvbm1lbnQoZnVuY3Rpb24gKCkge1xuICBlbnF1ZXVlVmVyc2lvbnNSZWZyZXNoKCk7XG59LCBcImhhbmRsaW5nIFNJR0hVUCBzaWduYWwgZm9yIHJlZnJlc2hcIikpO1xuIiwiaW1wb3J0IHsgVHJhY2tlciB9IGZyb20gXCJtZXRlb3IvdHJhY2tlclwiO1xuXG5leHBvcnQgY2xhc3MgQ2xpZW50VmVyc2lvbnMge1xuICBjb25zdHJ1Y3RvcigpIHtcbiAgICB0aGlzLl92ZXJzaW9ucyA9IG5ldyBNYXAoKTtcbiAgICB0aGlzLl93YXRjaENhbGxiYWNrcyA9IG5ldyBTZXQoKTtcbiAgfVxuXG4gIC8vIENyZWF0ZXMgYSBMaXZlZGF0YSBzdG9yZSBmb3IgdXNlIHdpdGggYE1ldGVvci5jb25uZWN0aW9uLnJlZ2lzdGVyU3RvcmVgLlxuICAvLyBBZnRlciB0aGUgc3RvcmUgaXMgcmVnaXN0ZXJlZCwgZG9jdW1lbnQgdXBkYXRlcyByZXBvcnRlZCBieSBMaXZlZGF0YSBhcmVcbiAgLy8gbWVyZ2VkIHdpdGggdGhlIGRvY3VtZW50cyBpbiB0aGlzIGBDbGllbnRWZXJzaW9uc2AgaW5zdGFuY2UuXG4gIGNyZWF0ZVN0b3JlKCkge1xuICAgIHJldHVybiB7XG4gICAgICB1cGRhdGU6ICh7IGlkLCBtc2csIGZpZWxkcyB9KSA9PiB7XG4gICAgICAgIGlmIChtc2cgPT09IFwiYWRkZWRcIiB8fCBtc2cgPT09IFwiY2hhbmdlZFwiKSB7XG4gICAgICAgICAgdGhpcy5zZXQoaWQsIGZpZWxkcyk7XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICB9O1xuICB9XG5cbiAgaGFzVmVyc2lvbnMoKSB7XG4gICAgcmV0dXJuIHRoaXMuX3ZlcnNpb25zLnNpemUgPiAwO1xuICB9XG5cbiAgZ2V0KGlkKSB7XG4gICAgcmV0dXJuIHRoaXMuX3ZlcnNpb25zLmdldChpZCk7XG4gIH1cblxuICAvLyBBZGRzIG9yIHVwZGF0ZXMgYSB2ZXJzaW9uIGRvY3VtZW50IGFuZCBpbnZva2VzIHJlZ2lzdGVyZWQgY2FsbGJhY2tzIGZvciB0aGVcbiAgLy8gYWRkZWQvdXBkYXRlZCBkb2N1bWVudC4gSWYgYSBkb2N1bWVudCB3aXRoIHRoZSBnaXZlbiBJRCBhbHJlYWR5IGV4aXN0cywgaXRzXG4gIC8vIGZpZWxkcyBhcmUgbWVyZ2VkIHdpdGggYGZpZWxkc2AuXG4gIHNldChpZCwgZmllbGRzKSB7XG4gICAgbGV0IHZlcnNpb24gPSB0aGlzLl92ZXJzaW9ucy5nZXQoaWQpO1xuICAgIGxldCBpc05ldyA9IGZhbHNlO1xuXG4gICAgaWYgKHZlcnNpb24pIHtcbiAgICAgIE9iamVjdC5hc3NpZ24odmVyc2lvbiwgZmllbGRzKTtcbiAgICB9IGVsc2Uge1xuICAgICAgdmVyc2lvbiA9IHtcbiAgICAgICAgX2lkOiBpZCxcbiAgICAgICAgLi4uZmllbGRzXG4gICAgICB9O1xuXG4gICAgICBpc05ldyA9IHRydWU7XG4gICAgICB0aGlzLl92ZXJzaW9ucy5zZXQoaWQsIHZlcnNpb24pO1xuICAgIH1cblxuICAgIHRoaXMuX3dhdGNoQ2FsbGJhY2tzLmZvckVhY2goKHsgZm4sIGZpbHRlciB9KSA9PiB7XG4gICAgICBpZiAoISBmaWx0ZXIgfHwgZmlsdGVyID09PSB2ZXJzaW9uLl9pZCkge1xuICAgICAgICBmbih2ZXJzaW9uLCBpc05ldyk7XG4gICAgICB9XG4gICAgfSk7XG4gIH1cblxuICAvLyBSZWdpc3RlcnMgYSBjYWxsYmFjayB0aGF0IHdpbGwgYmUgaW52b2tlZCB3aGVuIGEgdmVyc2lvbiBkb2N1bWVudCBpcyBhZGRlZFxuICAvLyBvciBjaGFuZ2VkLiBDYWxsaW5nIHRoZSBmdW5jdGlvbiByZXR1cm5lZCBieSBgd2F0Y2hgIHJlbW92ZXMgdGhlIGNhbGxiYWNrLlxuICAvLyBJZiBgc2tpcEluaXRpYWxgIGlzIHRydWUsIHRoZSBjYWxsYmFjayBpc24ndCBiZSBpbnZva2VkIGZvciBleGlzdGluZ1xuICAvLyBkb2N1bWVudHMuIElmIGBmaWx0ZXJgIGlzIHNldCwgdGhlIGNhbGxiYWNrIGlzIG9ubHkgaW52b2tlZCBmb3IgZG9jdW1lbnRzXG4gIC8vIHdpdGggSUQgYGZpbHRlcmAuXG4gIHdhdGNoKGZuLCB7IHNraXBJbml0aWFsLCBmaWx0ZXIgfSA9IHt9KSB7XG4gICAgaWYgKCEgc2tpcEluaXRpYWwpIHtcbiAgICAgIGNvbnN0IHJlc29sdmVkID0gUHJvbWlzZS5yZXNvbHZlKCk7XG5cbiAgICAgIHRoaXMuX3ZlcnNpb25zLmZvckVhY2goKHZlcnNpb24pID0+IHtcbiAgICAgICAgaWYgKCEgZmlsdGVyIHx8IGZpbHRlciA9PT0gdmVyc2lvbi5faWQpIHtcbiAgICAgICAgICByZXNvbHZlZC50aGVuKCgpID0+IGZuKHZlcnNpb24sIHRydWUpKTtcbiAgICAgICAgfVxuICAgICAgfSk7XG4gICAgfVxuXG4gICAgY29uc3QgY2FsbGJhY2sgPSB7IGZuLCBmaWx0ZXIgfTtcbiAgICB0aGlzLl93YXRjaENhbGxiYWNrcy5hZGQoY2FsbGJhY2spO1xuXG4gICAgcmV0dXJuICgpID0+IHRoaXMuX3dhdGNoQ2FsbGJhY2tzLmRlbGV0ZShjYWxsYmFjayk7XG4gIH1cblxuICAvLyBBIHJlYWN0aXZlIGRhdGEgc291cmNlIGZvciBgQXV0b3VwZGF0ZS5uZXdDbGllbnRBdmFpbGFibGVgLlxuICBuZXdDbGllbnRBdmFpbGFibGUoaWQsIGZpZWxkcywgY3VycmVudFZlcnNpb24pIHtcbiAgICBmdW5jdGlvbiBpc05ld1ZlcnNpb24odmVyc2lvbikge1xuICAgICAgcmV0dXJuIChcbiAgICAgICAgdmVyc2lvbi5faWQgPT09IGlkICYmXG4gICAgICAgIGZpZWxkcy5zb21lKChmaWVsZCkgPT4gdmVyc2lvbltmaWVsZF0gIT09IGN1cnJlbnRWZXJzaW9uW2ZpZWxkXSlcbiAgICAgICk7XG4gICAgfVxuXG4gICAgY29uc3QgZGVwZW5kZW5jeSA9IG5ldyBUcmFja2VyLkRlcGVuZGVuY3koKTtcbiAgICBjb25zdCB2ZXJzaW9uID0gdGhpcy5nZXQoaWQpO1xuXG4gICAgZGVwZW5kZW5jeS5kZXBlbmQoKTtcblxuICAgIGNvbnN0IHN0b3AgPSB0aGlzLndhdGNoKFxuICAgICAgKHZlcnNpb24pID0+IHtcbiAgICAgICAgaWYgKGlzTmV3VmVyc2lvbih2ZXJzaW9uKSkge1xuICAgICAgICAgIGRlcGVuZGVuY3kuY2hhbmdlZCgpO1xuICAgICAgICAgIHN0b3AoKTtcbiAgICAgICAgfVxuICAgICAgfSxcbiAgICAgIHsgc2tpcEluaXRpYWw6IHRydWUgfVxuICAgICk7XG5cbiAgICByZXR1cm4gISEgdmVyc2lvbiAmJiBpc05ld1ZlcnNpb24odmVyc2lvbik7XG4gIH1cbn1cbiJdfQ==
