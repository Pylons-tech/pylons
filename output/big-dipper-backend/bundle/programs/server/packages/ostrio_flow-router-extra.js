(function () {

/* Imports */
var Meteor = Package.meteor.Meteor;
var global = Package.meteor.global;
var meteorEnv = Package.meteor.meteorEnv;
var meteorInstall = Package.modules.meteorInstall;
var ECMAScript = Package.ecmascript.ECMAScript;
var Promise = Package.promise.Promise;
var Tracker = Package.tracker.Tracker;
var Deps = Package.tracker.Deps;
var ReactiveDict = Package['reactive-dict'].ReactiveDict;
var ReactiveVar = Package['reactive-var'].ReactiveVar;
var EJSON = Package.ejson.EJSON;
var check = Package.check.check;
var Match = Package.check.Match;

var require = meteorInstall({"node_modules":{"meteor":{"ostrio:flow-router-extra":{"server":{"_init.js":function module(require,exports,module){

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
// packages/ostrio_flow-router-extra/server/_init.js                                                //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                    //
module.export({
  FlowRouter: () => FlowRouter,
  Router: () => Router,
  Route: () => Route,
  Group: () => Group,
  Triggers: () => Triggers,
  BlazeRenderer: () => BlazeRenderer
});
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
let Router;
module.link("./router.js", {
  default(v) {
    Router = v;
  }

}, 1);
let Route;
module.link("./route.js", {
  default(v) {
    Route = v;
  }

}, 2);
let Group;
module.link("./group.js", {
  default(v) {
    Group = v;
  }

}, 3);
module.link("./plugins/fast-render.js");

if (Package['meteorhacks:inject-data']) {
  Meteor._debug('`meteorhacks:inject-data` is deprecated, please remove it and install its successor - `communitypackages:inject-data`');

  Meteor._debug('meteor remove meteorhacks:inject-data');

  Meteor._debug('meteor add communitypackages:inject-data');
}

if (Package['meteorhacks:fast-render']) {
  Meteor._debug('`meteorhacks:fast-render` is deprecated, please remove it and install its successor - `communitypackages:fast-render`');

  Meteor._debug('meteor remove meteorhacks:fast-render');

  Meteor._debug('meteor add communitypackages:fast-render');
}

if (Package['staringatlights:inject-data']) {
  Meteor._debug('`staringatlights:inject-data` is deprecated, please remove it and install its successor - `communitypackages:inject-data`');

  Meteor._debug('meteor remove staringatlights:inject-data');

  Meteor._debug('meteor add communitypackages:inject-data');
}

if (Package['staringatlights:fast-render']) {
  Meteor._debug('`staringatlights:fast-render` is deprecated, please remove it and install its successor - `communitypackages:fast-render`');

  Meteor._debug('meteor remove staringatlights:fast-render');

  Meteor._debug('meteor add communitypackages:fast-render');
}

const Triggers = {};
const BlazeRenderer = {};
const FlowRouter = new Router();
FlowRouter.Router = Router;
FlowRouter.Route = Route;
//////////////////////////////////////////////////////////////////////////////////////////////////////

},"group.js":function module(require,exports,module){

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
// packages/ostrio_flow-router-extra/server/group.js                                                //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                    //
let _helpers;

module.link("./../lib/_helpers.js", {
  _helpers(v) {
    _helpers = v;
  }

}, 0);

const makeTrigger = trigger => {
  if (_helpers.isFunction(trigger)) {
    return [trigger];
  } else if (!_helpers.isArray(trigger)) {
    return [];
  }

  return trigger;
};

const makeTriggers = (_base, _triggers) => {
  if (!_base && !_triggers) {
    return [];
  }

  return makeTrigger(_base).concat(makeTrigger(_triggers));
};

class Group {
  constructor(router) {
    let options = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : {};
    let parent = arguments.length > 2 ? arguments[2] : undefined;

    if (options.prefix && !/^\//.test(options.prefix)) {
      throw new Error('group\'s prefix must start with "/"');
    }

    this._router = router;
    this.prefix = options.prefix || '';
    this.name = options.name;
    this.options = options;
    this._triggersEnter = makeTriggers(options.triggersEnter, this._triggersEnter);
    this._triggersExit = makeTriggers(this._triggersExit, options.triggersExit);
    this._subscriptions = options.subscriptions || Function.prototype;
    this.parent = parent;

    if (this.parent) {
      this.prefix = parent.prefix + this.prefix;
      this._triggersEnter = makeTriggers(parent._triggersEnter, this._triggersEnter);
      this._triggersExit = makeTriggers(this._triggersExit, parent._triggersExit);
    }
  }

  route(_pathDef) {
    let options = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : {};

    let _group = arguments.length > 2 ? arguments[2] : undefined;

    if (!/^\//.test(_pathDef)) {
      throw new Error('route\'s path must start with "/"');
    }

    const group = _group || this;
    const pathDef = this.prefix + _pathDef;
    options.triggersEnter = makeTriggers(this._triggersEnter, options.triggersEnter);
    options.triggersExit = makeTriggers(options.triggersExit, this._triggersExit);
    return this._router.route(pathDef, _helpers.extend(_helpers.omit(this.options, ['triggersEnter', 'triggersExit', 'subscriptions', 'prefix', 'waitOn', 'name', 'title', 'titlePrefix', 'link', 'script', 'meta']), options), group);
  }

  group(options) {
    return new Group(this._router, options, this);
  }

}

module.exportDefault(Group);
//////////////////////////////////////////////////////////////////////////////////////////////////////

},"route.js":function module(require,exports,module){

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
// packages/ostrio_flow-router-extra/server/route.js                                                //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                    //
class Route {
  constructor(router, pathDef) {
    let options = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : {};
    this.options = options;
    this.name = options.name;
    this.pathDef = pathDef; // Route.path is deprecated and will be removed in 3.0

    this.path = pathDef;
    this.action = options.action || Function.prototype;
    this.subscriptions = options.subscriptions || Function.prototype;
    this._subsMap = {};
  }

  register(name, sub) {
    this._subsMap[name] = sub;
  }

  subscription(name) {
    return this._subsMap[name];
  }

  middleware() {// ?
  }

}

module.exportDefault(Route);
//////////////////////////////////////////////////////////////////////////////////////////////////////

},"router.js":function module(require,exports,module){

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
// packages/ostrio_flow-router-extra/server/router.js                                               //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                    //
let page;
module.link("page", {
  default(v) {
    page = v;
  }

}, 0);
let Route;
module.link("./route.js", {
  default(v) {
    Route = v;
  }

}, 1);
let Group;
module.link("./group.js", {
  default(v) {
    Group = v;
  }

}, 2);
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 3);

let _helpers;

module.link("../lib/_helpers.js", {
  _helpers(v) {
    _helpers = v;
  }

}, 4);

const qs = require('qs');

class Router {
  constructor() {
    this.pathRegExp = /(:[\w\(\)\\\+\*\.\?\[\]\-]+)+/g;
    this._routes = [];
    this._routesMap = {};
    this._current = {};
    this._specialChars = ['/', '%', '+'];

    this._encodeParam = param => {
      const paramArr = param.split('');
      let _param = '';

      for (let i = 0; i < paramArr.length; i++) {
        if (this._specialChars.includes(paramArr[i])) {
          _param += encodeURIComponent(encodeURIComponent(paramArr[i]));
        } else {
          try {
            _param += encodeURIComponent(paramArr[i]);
          } catch (e) {
            _param += paramArr[i];
          }
        }
      }

      return _param;
    };

    this.subscriptions = Function.prototype; // holds onRoute callbacks

    this._onRouteCallbacks = [];
    this.triggers = {
      enter() {// client only
      },

      exit() {// client only
      }

    };
  }

  matchPath(path) {
    const params = {};

    const route = this._routes.find(r => {
      const pageRoute = new page.Route(r.pathDef);
      return pageRoute.match(path, params);
    });

    if (!route) {
      return null;
    }

    return {
      params: _helpers.clone(params),
      route: _helpers.clone(route)
    };
  }

  setCurrent(current) {
    this._current = current;
  }

  route(pathDef) {
    let options = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : {};

    if (!/^\/.*/.test(pathDef) && pathDef !== '*') {
      throw new Error('route\'s path must start with "/"');
    }

    const route = new Route(this, pathDef, options);

    this._routes.push(route);

    if (options.name) {
      this._routesMap[options.name] = route;
    }

    this._triggerRouteRegister(route);

    return route;
  }

  group(options) {
    return new Group(this, options);
  }

  path(_pathDef) {
    let fields = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : {};
    let queryParams = arguments.length > 2 ? arguments[2] : undefined;
    let pathDef = _pathDef;

    if (this._routesMap[pathDef]) {
      pathDef = this._routesMap[pathDef].path;
    }

    let path = pathDef.replace(this.pathRegExp, _key => {
      const firstRegexpChar = _key.indexOf('('); // get the content behind : and (\\d+/)


      let key = _key.substring(1, firstRegexpChar > 0 ? firstRegexpChar : undefined); // remove +?*


      key = key.replace(/[\+\*\?]+/g, '');

      if (fields[key]) {
        return this._encodeParam("".concat(fields[key]));
      }

      return '';
    });
    path = path.replace(/\/\/+/g, '/'); // Replace multiple slashes with single slash
    // remove trailing slash
    // but keep the root slash if it's the only one

    path = path.match(/^\/{1}$/) ? path : path.replace(/\/$/, '');
    const strQueryParams = qs.stringify(queryParams || {});

    if (strQueryParams) {
      path += "?".concat(strQueryParams);
    }

    return path;
  }

  onRouteRegister(cb) {
    this._onRouteCallbacks.push(cb);
  }

  _triggerRouteRegister(currentRoute) {
    // We should only need to send a safe set of fields on the route
    // object.
    // This is not to hide what's inside the route object, but to show
    // these are the public APIs
    const routePublicApi = _helpers.pick(currentRoute, ['name', 'pathDef', 'path']);

    routePublicApi.options = _helpers.omit(currentRoute.options, ['triggersEnter', 'triggersExit', 'action', 'subscriptions', 'name']);

    this._onRouteCallbacks.forEach(cb => {
      cb(routePublicApi);
    });
  }

  go() {// client only
  }

  current() {
    // client only
    return this._current;
  }

  middleware() {// client only
  }

  getState() {// client only
  }

  getAllStates() {// client only
  }

  getRouteName() {
    return this._current.route ? this._current.route.name : undefined;
  }

  getQueryParam(key) {
    return this._current.query ? this._current.queryParams[key] : undefined;
  }

  setState() {// client only
  }

  setParams() {}

  removeState() {// client only
  }

  clearStates() {// client only
  }

  ready() {// client only
  }

  initialize() {// client only
  }

  wait() {// client only
  }

  url() {
    // We need to remove the leading base path, or "/", as it will be inserted
    // automatically by `Meteor.absoluteUrl` as documented in:
    // http://docs.meteor.com/#/full/meteor_absoluteurl
    return Meteor.absoluteUrl(this.path.apply(this, arguments).replace(new RegExp('^' + ('/' + (this._basePath || '') + '/').replace(/\/\/+/g, '/')), ''));
  }

}

module.exportDefault(Router);
//////////////////////////////////////////////////////////////////////////////////////////////////////

},"plugins":{"fast-render.js":function module(require,exports,module){

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
// packages/ostrio_flow-router-extra/server/plugins/fast-render.js                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                    //
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);

let _helpers;

module.link("./../../lib/_helpers.js", {
  _helpers(v) {
    _helpers = v;
  }

}, 1);
let FlowRouter;
module.link("../_init.js", {
  FlowRouter(v) {
    FlowRouter = v;
  }

}, 2);

if (!Package['communitypackages:fast-render']) {
  return;
}

const FastRender = Package['communitypackages:fast-render'].FastRender;

const setupFastRender = () => {
  FlowRouter._routes.forEach(route => {
    if (route.pathDef === '*') {
      return;
    }

    FastRender.route(route.pathDef, function (routeParams, path) {
      // anyone using Meteor.subscribe for something else?
      const meteorSubscribe = Meteor.subscribe;

      Meteor.subscribe = function () {
        return Array.from(arguments);
      };

      route._subsMap = {};
      FlowRouter.subscriptions.call(route, path);

      if (route.subscriptions) {
        route.subscriptions(_helpers.omit(routeParams, ['query']), routeParams.query);
      }

      Object.keys(route._subsMap).forEach(key => {
        this.subscribe.apply(this, route._subsMap[key]);
      }); // restore Meteor.subscribe, ... on server side

      Meteor.subscribe = meteorSubscribe;
    });
  });
}; // hack to run after everything else on startup


Meteor.startup(() => {
  Meteor.startup(() => {
    setupFastRender();
  });
});
//////////////////////////////////////////////////////////////////////////////////////////////////////

}}},"lib":{"_helpers.js":function module(require,exports,module){

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
// packages/ostrio_flow-router-extra/lib/_helpers.js                                                //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                    //
module.export({
  _helpers: () => _helpers
});
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
const _helpers = {
  isEmpty(obj) {
    // 1
    if (obj == null) {
      return true;
    }

    if (this.isArray(obj) || this.isString(obj) || this.isArguments(obj)) {
      return obj.length === 0;
    }

    return Object.keys(obj).length === 0;
  },

  isObject(obj) {
    const type = typeof obj;
    return type === 'function' || type === 'object' && !!obj;
  },

  omit(obj, keys) {
    // 10
    if (!this.isObject(obj)) {
      Meteor._debug('[ostrio:flow-router-extra] [_helpers.omit] First argument must be an Object');

      return obj;
    }

    if (!this.isArray(keys)) {
      Meteor._debug('[ostrio:flow-router-extra] [_helpers.omit] Second argument must be an Array');

      return obj;
    }

    const copy = this.clone(obj);
    keys.forEach(key => {
      delete copy[key];
    });
    return copy;
  },

  pick(obj, keys) {
    // 2
    if (!this.isObject(obj)) {
      Meteor._debug('[ostrio:flow-router-extra] [_helpers.omit] First argument must be an Object');

      return obj;
    }

    if (!this.isArray(keys)) {
      Meteor._debug('[ostrio:flow-router-extra] [_helpers.omit] Second argument must be an Array');

      return obj;
    }

    const picked = {};
    keys.forEach(key => {
      picked[key] = obj[key];
    });
    return picked;
  },

  isArray(obj) {
    return Array.isArray(obj);
  },

  extend() {
    for (var _len = arguments.length, objs = new Array(_len), _key = 0; _key < _len; _key++) {
      objs[_key] = arguments[_key];
    }

    // 4
    return Object.assign({}, ...objs);
  },

  clone(obj) {
    if (!this.isObject(obj)) return obj;
    return this.isArray(obj) ? obj.slice() : this.extend(obj);
  }

};
['Arguments', 'Function', 'String', 'RegExp'].forEach(name => {
  _helpers['is' + name] = function (obj) {
    return Object.prototype.toString.call(obj) === '[object ' + name + ']';
  };
});
//////////////////////////////////////////////////////////////////////////////////////////////////////

}},"node_modules":{"page":{"package.json":function module(require,exports,module){

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
// node_modules/meteor/ostrio_flow-router-extra/node_modules/page/package.json                      //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                    //
module.exports = {
  "name": "page",
  "version": "1.9.0",
  "main": "index.js"
};

//////////////////////////////////////////////////////////////////////////////////////////////////////

},"index.js":function module(require,exports,module){

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
// node_modules/meteor/ostrio_flow-router-extra/node_modules/page/index.js                          //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                    //
module.useNode();
//////////////////////////////////////////////////////////////////////////////////////////////////////

}},"qs":{"package.json":function module(require,exports,module){

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
// node_modules/meteor/ostrio_flow-router-extra/node_modules/qs/package.json                        //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                    //
module.exports = {
  "name": "qs",
  "version": "6.10.5",
  "main": "lib/index.js"
};

//////////////////////////////////////////////////////////////////////////////////////////////////////

},"lib":{"index.js":function module(require,exports,module){

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
// node_modules/meteor/ostrio_flow-router-extra/node_modules/qs/lib/index.js                        //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                    //
module.useNode();
//////////////////////////////////////////////////////////////////////////////////////////////////////

}}}}}}}},{
  "extensions": [
    ".js",
    ".json"
  ]
});

var exports = require("/node_modules/meteor/ostrio:flow-router-extra/server/_init.js");

/* Exports */
Package._define("ostrio:flow-router-extra", exports);

})();

//# sourceURL=meteor://💻app/packages/ostrio_flow-router-extra.js
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvb3N0cmlvOmZsb3ctcm91dGVyLWV4dHJhL3NlcnZlci9faW5pdC5qcyIsIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvb3N0cmlvOmZsb3ctcm91dGVyLWV4dHJhL3NlcnZlci9ncm91cC5qcyIsIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvb3N0cmlvOmZsb3ctcm91dGVyLWV4dHJhL3NlcnZlci9yb3V0ZS5qcyIsIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvb3N0cmlvOmZsb3ctcm91dGVyLWV4dHJhL3NlcnZlci9yb3V0ZXIuanMiLCJtZXRlb3I6Ly/wn5K7YXBwL3BhY2thZ2VzL29zdHJpbzpmbG93LXJvdXRlci1leHRyYS9zZXJ2ZXIvcGx1Z2lucy9mYXN0LXJlbmRlci5qcyIsIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvb3N0cmlvOmZsb3ctcm91dGVyLWV4dHJhL2xpYi9faGVscGVycy5qcyJdLCJuYW1lcyI6WyJtb2R1bGUiLCJleHBvcnQiLCJGbG93Um91dGVyIiwiUm91dGVyIiwiUm91dGUiLCJHcm91cCIsIlRyaWdnZXJzIiwiQmxhemVSZW5kZXJlciIsIk1ldGVvciIsImxpbmsiLCJ2IiwiZGVmYXVsdCIsIlBhY2thZ2UiLCJfZGVidWciLCJfaGVscGVycyIsIm1ha2VUcmlnZ2VyIiwidHJpZ2dlciIsImlzRnVuY3Rpb24iLCJpc0FycmF5IiwibWFrZVRyaWdnZXJzIiwiX2Jhc2UiLCJfdHJpZ2dlcnMiLCJjb25jYXQiLCJjb25zdHJ1Y3RvciIsInJvdXRlciIsIm9wdGlvbnMiLCJwYXJlbnQiLCJwcmVmaXgiLCJ0ZXN0IiwiRXJyb3IiLCJfcm91dGVyIiwibmFtZSIsIl90cmlnZ2Vyc0VudGVyIiwidHJpZ2dlcnNFbnRlciIsIl90cmlnZ2Vyc0V4aXQiLCJ0cmlnZ2Vyc0V4aXQiLCJfc3Vic2NyaXB0aW9ucyIsInN1YnNjcmlwdGlvbnMiLCJGdW5jdGlvbiIsInByb3RvdHlwZSIsInJvdXRlIiwiX3BhdGhEZWYiLCJfZ3JvdXAiLCJncm91cCIsInBhdGhEZWYiLCJleHRlbmQiLCJvbWl0IiwiZXhwb3J0RGVmYXVsdCIsInBhdGgiLCJhY3Rpb24iLCJfc3Vic01hcCIsInJlZ2lzdGVyIiwic3ViIiwic3Vic2NyaXB0aW9uIiwibWlkZGxld2FyZSIsInBhZ2UiLCJxcyIsInJlcXVpcmUiLCJwYXRoUmVnRXhwIiwiX3JvdXRlcyIsIl9yb3V0ZXNNYXAiLCJfY3VycmVudCIsIl9zcGVjaWFsQ2hhcnMiLCJfZW5jb2RlUGFyYW0iLCJwYXJhbSIsInBhcmFtQXJyIiwic3BsaXQiLCJfcGFyYW0iLCJpIiwibGVuZ3RoIiwiaW5jbHVkZXMiLCJlbmNvZGVVUklDb21wb25lbnQiLCJlIiwiX29uUm91dGVDYWxsYmFja3MiLCJ0cmlnZ2VycyIsImVudGVyIiwiZXhpdCIsIm1hdGNoUGF0aCIsInBhcmFtcyIsImZpbmQiLCJyIiwicGFnZVJvdXRlIiwibWF0Y2giLCJjbG9uZSIsInNldEN1cnJlbnQiLCJjdXJyZW50IiwicHVzaCIsIl90cmlnZ2VyUm91dGVSZWdpc3RlciIsImZpZWxkcyIsInF1ZXJ5UGFyYW1zIiwicmVwbGFjZSIsIl9rZXkiLCJmaXJzdFJlZ2V4cENoYXIiLCJpbmRleE9mIiwia2V5Iiwic3Vic3RyaW5nIiwidW5kZWZpbmVkIiwic3RyUXVlcnlQYXJhbXMiLCJzdHJpbmdpZnkiLCJvblJvdXRlUmVnaXN0ZXIiLCJjYiIsImN1cnJlbnRSb3V0ZSIsInJvdXRlUHVibGljQXBpIiwicGljayIsImZvckVhY2giLCJnbyIsImdldFN0YXRlIiwiZ2V0QWxsU3RhdGVzIiwiZ2V0Um91dGVOYW1lIiwiZ2V0UXVlcnlQYXJhbSIsInF1ZXJ5Iiwic2V0U3RhdGUiLCJzZXRQYXJhbXMiLCJyZW1vdmVTdGF0ZSIsImNsZWFyU3RhdGVzIiwicmVhZHkiLCJpbml0aWFsaXplIiwid2FpdCIsInVybCIsImFic29sdXRlVXJsIiwiYXBwbHkiLCJhcmd1bWVudHMiLCJSZWdFeHAiLCJfYmFzZVBhdGgiLCJGYXN0UmVuZGVyIiwic2V0dXBGYXN0UmVuZGVyIiwicm91dGVQYXJhbXMiLCJtZXRlb3JTdWJzY3JpYmUiLCJzdWJzY3JpYmUiLCJBcnJheSIsImZyb20iLCJjYWxsIiwiT2JqZWN0Iiwia2V5cyIsInN0YXJ0dXAiLCJpc0VtcHR5Iiwib2JqIiwiaXNTdHJpbmciLCJpc0FyZ3VtZW50cyIsImlzT2JqZWN0IiwidHlwZSIsImNvcHkiLCJwaWNrZWQiLCJvYmpzIiwiYXNzaWduIiwic2xpY2UiLCJ0b1N0cmluZyJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OztBQUFBQSxNQUFNLENBQUNDLE1BQVAsQ0FBYztBQUFDQyxZQUFVLEVBQUMsTUFBSUEsVUFBaEI7QUFBMkJDLFFBQU0sRUFBQyxNQUFJQSxNQUF0QztBQUE2Q0MsT0FBSyxFQUFDLE1BQUlBLEtBQXZEO0FBQTZEQyxPQUFLLEVBQUMsTUFBSUEsS0FBdkU7QUFBNkVDLFVBQVEsRUFBQyxNQUFJQSxRQUExRjtBQUFtR0MsZUFBYSxFQUFDLE1BQUlBO0FBQXJILENBQWQ7QUFBbUosSUFBSUMsTUFBSjtBQUFXUixNQUFNLENBQUNTLElBQVAsQ0FBWSxlQUFaLEVBQTRCO0FBQUNELFFBQU0sQ0FBQ0UsQ0FBRCxFQUFHO0FBQUNGLFVBQU0sR0FBQ0UsQ0FBUDtBQUFTOztBQUFwQixDQUE1QixFQUFrRCxDQUFsRDtBQUFxRCxJQUFJUCxNQUFKO0FBQVdILE1BQU0sQ0FBQ1MsSUFBUCxDQUFZLGFBQVosRUFBMEI7QUFBQ0UsU0FBTyxDQUFDRCxDQUFELEVBQUc7QUFBQ1AsVUFBTSxHQUFDTyxDQUFQO0FBQVM7O0FBQXJCLENBQTFCLEVBQWlELENBQWpEO0FBQW9ELElBQUlOLEtBQUo7QUFBVUosTUFBTSxDQUFDUyxJQUFQLENBQVksWUFBWixFQUF5QjtBQUFDRSxTQUFPLENBQUNELENBQUQsRUFBRztBQUFDTixTQUFLLEdBQUNNLENBQU47QUFBUTs7QUFBcEIsQ0FBekIsRUFBK0MsQ0FBL0M7QUFBa0QsSUFBSUwsS0FBSjtB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QUNyQyxXQUFPSixNQUFNLENBQUM3RixTQUFQLENBQWlCMkcsUUFBakIsQ0FBMEJmLElBQTFCLENBQStCSyxHQUEvQixNQUF3QyxhQUFhekcsSUFBYixHQUFvQixHQUFuRTtBQUNELEdBRkQ7QUFHRCxDQUpELEUiLCJmaWxlIjoiL3BhY2thZ2VzL29zdHJpb19mbG93LXJvdXRlci1leHRyYS5qcyIsInNvdXJjZXNDb250ZW50IjpbImltcG9ydCB7IE1ldGVvciB9IGZyb20gJ21ldGVvci9tZXRlb3InO1xuXG5pbXBvcnQgUm91dGVyIGZyb20gJy4vcm91dGVyLmpzJztcbmltcG9ydCBSb3V0ZSBmcm9tICcuL3JvdXRlLmpzJztcbmltcG9ydCBHcm91cCBmcm9tICcuL2dyb3VwLmpzJztcblxuaW1wb3J0ICcuL3BsdWdpbnMvZmFzdC1yZW5kZXIuanMnO1xuXG5pZiAoUGFja2FnZVsnbWV0ZW9yaGFja3M6aW5qZWN0LWRhdGEnXSkge1xuICBNZXRlb3IuX2RlYnVnKCdgbWV0ZW9yaGFja3M6aW5qZWN0LWRhdGFgIGlzIGRlcHJlY2F0ZWQsIHBsZWFzZSByZW1vdmUgaXQgYW5kIGluc3RhbGwgaXRzIHN1Y2Nlc3NvciAtIGBjb21tdW5pdHlwYWNrYWdlczppbmplY3QtZGF0YWAnKTtcbiAgTWV0ZW9yLl9kZWJ1ZygnbWV0ZW9yIHJlbW92ZSBtZXRlb3JoYWNrczppbmplY3QtZGF0YScpO1xuICBNZXRlb3IuX2RlYnVnKCdtZXRlb3IgYWRkIGNvbW11bml0eXBhY2thZ2VzOmluamVjdC1kYXRhJyk7XG59XG5cbmlmIChQYWNrYWdlWydtZXRlb3JoYWNrczpmYXN0LXJlbmRlciddKSB7XG4gIE1ldGVvci5fZGVidWcoJ2BtZXRlb3JoYWNrczpmYXN0LXJlbmRlcmAgaXMgZGVwcmVjYXRlZCwgcGxlYXNlIHJlbW92ZSBpdCBhbmQgaW5zdGFsbCBpdHMgc3VjY2Vzc29yIC0gYGNvbW11bml0eXBhY2thZ2VzOmZhc3QtcmVuZGVyYCcpO1xuICBNZXRlb3IuX2RlYnVnKCdtZXRlb3IgcmVtb3ZlIG1ldGVvcmhhY2tzOmZhc3QtcmVuZGVyJyk7XG4gIE1ldGVvci5fZGVidWcoJ21ldGVvciBhZGQgY29tbXVuaXR5cGFja2FnZXM6ZmFzdC1yZW5kZXInKTtcbn1cblxuaWYgKFBhY2thZ2VbJ3N0YXJpbmdhdGxpZ2h0czppbmplY3QtZGF0YSddKSB7XG4gIE1ldGVvci5fZGVidWcoJ2BzdGFyaW5nYXRsaWdodHM6aW5qZWN0LWRhdGFgIGlzIGRlcHJlY2F0ZWQsIHBsZWFzZSByZW1vdmUgaXQgYW5kIGluc3RhbGwgaXRzIHN1Y2Nlc3NvciAtIGBjb21tdW5pdHlwYWNrYWdlczppbmplY3QtZGF0YWAnKTtcbiAgTWV0ZW9yLl9kZWJ1ZygnbWV0ZW9yIHJlbW92ZSBzdGFyaW5nYXRsaWdodHM6aW5qZWN0LWRhdGEnKTtcbiAgTWV0ZW9yLl9kZWJ1ZygnbWV0ZW9yIGFkZCBjb21tdW5pdHlwYWNrYWdlczppbmplY3QtZGF0YScpO1xufVxuXG5pZiAoUGFja2FnZVsnc3RhcmluZ2F0bGlnaHRzOmZhc3QtcmVuZGVyJ10pIHtcbiAgTWV0ZW9yLl9kZWJ1ZygnYHN0YXJpbmdhdGxpZ2h0czpmYXN0LXJlbmRlcmAgaXMgZGVwcmVjYXRlZCwgcGxlYXNlIHJlbW92ZSBpdCBhbmQgaW5zdGFsbCBpdHMgc3VjY2Vzc29yIC0gYGNvbW11bml0eXBhY2thZ2VzOmZhc3QtcmVuZGVyYCcpO1xuICBNZXRlb3IuX2RlYnVnKCdtZXRlb3IgcmVtb3ZlIHN0YXJpbmdhdGxpZ2h0czpmYXN0LXJlbmRlcicpO1xuICBNZXRlb3IuX2RlYnVnKCdtZXRlb3IgYWRkIGNvbW11bml0eXBhY2thZ2VzOmZhc3QtcmVuZGVyJyk7XG59XG5cbmNvbnN0IFRyaWdnZXJzID0ge307XG5jb25zdCBCbGF6ZVJlbmRlcmVyID0ge307XG5cbmNvbnN0IEZsb3dSb3V0ZXIgPSBuZXcgUm91dGVyKCk7XG5GbG93Um91dGVyLlJvdXRlciA9IFJvdXRlcjtcbkZsb3dSb3V0ZXIuUm91dGUgPSBSb3V0ZTtcblxuZXhwb3J0IHsgRmxvd1JvdXRlciwgUm91dGVyLCBSb3V0ZSwgR3JvdXAsIFRyaWdnZXJzLCBCbGF6ZVJlbmRlcmVyIH07XG4iLCJpbXBvcnQgeyBfaGVscGVycyB9IGZyb20gJy4vLi4vbGliL19oZWxwZXJzLmpzJztcblxuY29uc3QgbWFrZVRyaWdnZXIgPSAodHJpZ2dlcikgPT4ge1xuICBpZiAoX2hlbHBlcnMuaXNGdW5jdGlvbih0cmlnZ2VyKSkge1xuICAgIHJldHVybiBbdHJpZ2dlcl07XG4gIH0gZWxzZSBpZiAoIV9oZWxwZXJzLmlzQXJyYXkodHJpZ2dlcikpIHtcbiAgICByZXR1cm4gW107XG4gIH1cblxuICByZXR1cm4gdHJpZ2dlcjtcbn07XG5cbmNvbnN0IG1ha2VUcmlnZ2VycyA9IChfYmFzZSwgX3RyaWdnZXJzKSA9PiB7XG4gIGlmICgoIV9iYXNlICYmICFfdHJpZ2dlcnMpKSB7XG4gICAgcmV0dXJuIFtdO1xuICB9XG4gIHJldHVybiBtYWtlVHJpZ2dlcihfYmFzZSkuY29uY2F0KG1ha2VUcmlnZ2VyKF90cmlnZ2VycykpO1xufTtcblxuY2xhc3MgR3JvdXAge1xuICBjb25zdHJ1Y3Rvcihyb3V0ZXIsIG9wdGlvbnMgPSB7fSwgcGFyZW50KSB7XG4gICAgaWYgKG9wdGlvbnMucHJlZml4ICYmICEvXlxcLy8udGVzdChvcHRpb25zLnByZWZpeCkpIHtcbiAgICAgIHRocm93IG5ldyBFcnJvcignZ3JvdXBcXCdzIHByZWZpeCBtdXN0IHN0YXJ0IHdpdGggXCIvXCInKTtcbiAgICB9XG5cbiAgICB0aGlzLl9yb3V0ZXIgPSByb3V0ZXI7XG4gICAgdGhpcy5wcmVmaXggPSBvcHRpb25zLnByZWZpeCB8fCAnJztcbiAgICB0aGlzLm5hbWUgPSBvcHRpb25zLm5hbWU7XG4gICAgdGhpcy5vcHRpb25zID0gb3B0aW9ucztcblxuICAgIHRoaXMuX3RyaWdnZXJzRW50ZXIgPSBtYWtlVHJpZ2dlcnMob3B0aW9ucy50cmlnZ2Vyc0VudGVyLCB0aGlzLl90cmlnZ2Vyc0VudGVyKTtcbiAgICB0aGlzLl90cmlnZ2Vyc0V4aXQgID0gbWFrZVRyaWdnZXJzKHRoaXMuX3RyaWdnZXJzRXhpdCwgb3B0aW9ucy50cmlnZ2Vyc0V4aXQpO1xuXG4gICAgdGhpcy5fc3Vic2NyaXB0aW9ucyA9IG9wdGlvbnMuc3Vic2NyaXB0aW9ucyB8fCBGdW5jdGlvbi5wcm90b3R5cGU7XG5cbiAgICB0aGlzLnBhcmVudCA9IHBhcmVudDtcbiAgICBpZiAodGhpcy5wYXJlbnQpIHtcbiAgICAgIHRoaXMucHJlZml4ID0gcGFyZW50LnByZWZpeCArIHRoaXMucHJlZml4O1xuICAgICAgdGhpcy5fdHJpZ2dlcnNFbnRlciA9IG1ha2VUcmlnZ2VycyhwYXJlbnQuX3RyaWdnZXJzRW50ZXIsIHRoaXMuX3RyaWdnZXJzRW50ZXIpO1xuICAgICAgdGhpcy5fdHJpZ2dlcnNFeGl0ICA9IG1ha2VUcmlnZ2Vycyh0aGlzLl90cmlnZ2Vyc0V4aXQsIHBhcmVudC5fdHJpZ2dlcnNFeGl0KTtcbiAgICB9XG4gIH1cblxuICByb3V0ZShfcGF0aERlZiwgb3B0aW9ucyA9IHt9LCBfZ3JvdXApIHtcbiAgICBpZiAoIS9eXFwvLy50ZXN0KF9wYXRoRGVmKSkge1xuICAgICAgdGhyb3cgbmV3IEVycm9yKCdyb3V0ZVxcJ3MgcGF0aCBtdXN0IHN0YXJ0IHdpdGggXCIvXCInKTtcbiAgICB9XG5cbiAgICBjb25zdCBncm91cCAgID0gX2dyb3VwIHx8IHRoaXM7XG4gICAgY29uc3QgcGF0aERlZiA9IHRoaXMucHJlZml4ICsgX3BhdGhEZWY7XG5cbiAgICBvcHRpb25zLnRyaWdnZXJzRW50ZXIgPSBtYWtlVHJpZ2dlcnModGhpcy5fdHJpZ2dlcnNFbnRlciwgb3B0aW9ucy50cmlnZ2Vyc0VudGVyKTtcbiAgICBvcHRpb25zLnRyaWdnZXJzRXhpdCAgPSBtYWtlVHJpZ2dlcnMob3B0aW9ucy50cmlnZ2Vyc0V4aXQsIHRoaXMuX3RyaWdnZXJzRXhpdCk7XG5cbiAgICByZXR1cm4gdGhpcy5fcm91dGVyLnJvdXRlKHBhdGhEZWYsIF9oZWxwZXJzLmV4dGVuZChfaGVscGVycy5vbWl0KHRoaXMub3B0aW9ucywgWyd0cmlnZ2Vyc0VudGVyJywgJ3RyaWdnZXJzRXhpdCcsICdzdWJzY3JpcHRpb25zJywgJ3ByZWZpeCcsICd3YWl0T24nLCAnbmFtZScsICd0aXRsZScsICd0aXRsZVByZWZpeCcsICdsaW5rJywgJ3NjcmlwdCcsICdtZXRhJ10pLCBvcHRpb25zKSwgZ3JvdXApO1xuICB9XG5cbiAgZ3JvdXAob3B0aW9ucykge1xuICAgIHJldHVybiBuZXcgR3JvdXAodGhpcy5fcm91dGVyLCBvcHRpb25zLCB0aGlzKTtcbiAgfVxufVxuXG5leHBvcnQgZGVmYXVsdCBHcm91cDtcbiIsImNsYXNzIFJvdXRlIHtcbiAgY29uc3RydWN0b3Iocm91dGVyLCBwYXRoRGVmLCBvcHRpb25zID0ge30pIHtcbiAgICB0aGlzLm9wdGlvbnMgPSBvcHRpb25zO1xuICAgIHRoaXMubmFtZSA9IG9wdGlvbnMubmFtZTtcbiAgICB0aGlzLnBhdGhEZWYgPSBwYXRoRGVmO1xuXG4gICAgLy8gUm91dGUucGF0aCBpcyBkZXByZWNhdGVkIGFuZCB3aWxsIGJlIHJlbW92ZWQgaW4gMy4wXG4gICAgdGhpcy5wYXRoID0gcGF0aERlZjtcblxuICAgIHRoaXMuYWN0aW9uID0gb3B0aW9ucy5hY3Rpb24gfHwgRnVuY3Rpb24ucHJvdG90eXBlO1xuICAgIHRoaXMuc3Vic2NyaXB0aW9ucyA9IG9wdGlvbnMuc3Vic2NyaXB0aW9ucyB8fCBGdW5jdGlvbi5wcm90b3R5cGU7XG4gICAgdGhpcy5fc3Vic01hcCA9IHt9O1xuICB9XG5cblxuICByZWdpc3RlcihuYW1lLCBzdWIpIHtcbiAgICB0aGlzLl9zdWJzTWFwW25hbWVdID0gc3ViO1xuICB9XG5cblxuICBzdWJzY3JpcHRpb24obmFtZSkge1xuICAgIHJldHVybiB0aGlzLl9zdWJzTWFwW25hbWVdO1xuICB9XG5cblxuICBtaWRkbGV3YXJlKCkge1xuICAgIC8vID9cbiAgfVxufVxuXG5leHBvcnQgZGVmYXVsdCBSb3V0ZTtcbiIsImltcG9ydCBwYWdlICAgICAgICAgZnJvbSAncGFnZSc7XG5pbXBvcnQgUm91dGUgICAgICAgIGZyb20gJy4vcm91dGUuanMnO1xuaW1wb3J0IEdyb3VwICAgICAgICBmcm9tICcuL2dyb3VwLmpzJztcbmltcG9ydCB7IE1ldGVvciB9ICAgZnJvbSAnbWV0ZW9yL21ldGVvcic7XG5pbXBvcnQgeyBfaGVscGVycyB9IGZyb20gJy4uL2xpYi9faGVscGVycy5qcyc7XG5cbmNvbnN0IHFzID0gcmVxdWlyZSgncXMnKTtcblxuY2xhc3MgUm91dGVyIHtcbiAgY29uc3RydWN0b3IoKSB7XG4gICAgdGhpcy5wYXRoUmVnRXhwID0gLyg6W1xcd1xcKFxcKVxcXFxcXCtcXCpcXC5cXD9cXFtcXF1cXC1dKykrL2c7XG4gICAgdGhpcy5fcm91dGVzID0gW107XG4gICAgdGhpcy5fcm91dGVzTWFwID0ge307XG4gICAgdGhpcy5fY3VycmVudCA9IHt9O1xuICAgIHRoaXMuX3NwZWNpYWxDaGFycyA9IFsnLycsICclJywgJysnXTtcbiAgICB0aGlzLl9lbmNvZGVQYXJhbSA9IHBhcmFtID0+IHtcbiAgICAgIGNvbnN0IHBhcmFtQXJyID0gcGFyYW0uc3BsaXQoJycpO1xuICAgICAgbGV0IF9wYXJhbSA9ICcnO1xuICAgICAgZm9yIChsZXQgaSA9IDA7IGkgPCBwYXJhbUFyci5sZW5ndGg7IGkrKykge1xuICAgICAgICBpZiAodGhpcy5fc3BlY2lhbENoYXJzLmluY2x1ZGVzKHBhcmFtQXJyW2ldKSkge1xuICAgICAgICAgIF9wYXJhbSArPSBlbmNvZGVVUklDb21wb25lbnQoZW5jb2RlVVJJQ29tcG9uZW50KHBhcmFtQXJyW2ldKSk7XG4gICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgdHJ5IHtcbiAgICAgICAgICAgIF9wYXJhbSArPSBlbmNvZGVVUklDb21wb25lbnQocGFyYW1BcnJbaV0pO1xuICAgICAgICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgICAgICAgIF9wYXJhbSArPSBwYXJhbUFycltpXTtcbiAgICAgICAgICB9XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICAgIHJldHVybiBfcGFyYW07XG4gICAgfTtcbiAgICB0aGlzLnN1YnNjcmlwdGlvbnMgPSBGdW5jdGlvbi5wcm90b3R5cGU7XG5cbiAgICAvLyBob2xkcyBvblJvdXRlIGNhbGxiYWNrc1xuICAgIHRoaXMuX29uUm91dGVDYWxsYmFja3MgPSBbXTtcblxuICAgIHRoaXMudHJpZ2dlcnMgPSB7XG4gICAgICBlbnRlcigpIHtcbiAgICAgICAgLy8gY2xpZW50IG9ubHlcbiAgICAgIH0sXG4gICAgICBleGl0KCkge1xuICAgICAgICAvLyBjbGllbnQgb25seVxuICAgICAgfVxuICAgIH07XG4gIH1cblxuICBtYXRjaFBhdGgocGF0aCkge1xuICAgIGNvbnN0IHBhcmFtcyA9IHt9O1xuICAgIGNvbnN0IHJvdXRlID0gdGhpcy5fcm91dGVzLmZpbmQociA9PiB7XG4gICAgICBjb25zdCBwYWdlUm91dGUgPSBuZXcgcGFnZS5Sb3V0ZShyLnBhdGhEZWYpO1xuICAgICAgcmV0dXJuIHBhZ2VSb3V0ZS5tYXRjaChwYXRoLCBwYXJhbXMpO1xuICAgIH0pO1xuICAgIGlmICghcm91dGUpIHtcbiAgICAgIHJldHVybiBudWxsO1xuICAgIH1cblxuICAgIHJldHVybiB7XG4gICAgICBwYXJhbXM6IF9oZWxwZXJzLmNsb25lKHBhcmFtcyksXG4gICAgICByb3V0ZTogX2hlbHBlcnMuY2xvbmUocm91dGUpLFxuICAgIH07XG4gIH1cblxuICBzZXRDdXJyZW50KGN1cnJlbnQpIHtcbiAgICB0aGlzLl9jdXJyZW50ID0gY3VycmVudDtcbiAgfVxuXG4gIHJvdXRlKHBhdGhEZWYsIG9wdGlvbnMgPSB7fSkge1xuICAgIGlmICghL15cXC8uKi8udGVzdChwYXRoRGVmKSAmJiBwYXRoRGVmICE9PSAnKicpIHtcbiAgICAgIHRocm93IG5ldyBFcnJvcigncm91dGVcXCdzIHBhdGggbXVzdCBzdGFydCB3aXRoIFwiL1wiJyk7XG4gICAgfVxuXG4gICAgY29uc3Qgcm91dGUgPSBuZXcgUm91dGUodGhpcywgcGF0aERlZiwgb3B0aW9ucyk7XG4gICAgdGhpcy5fcm91dGVzLnB1c2gocm91dGUpO1xuXG4gICAgaWYgKG9wdGlvbnMubmFtZSkge1xuICAgICAgdGhpcy5fcm91dGVzTWFwW29wdGlvbnMubmFtZV0gPSByb3V0ZTtcbiAgICB9XG5cbiAgICB0aGlzLl90cmlnZ2VyUm91dGVSZWdpc3Rlcihyb3V0ZSk7XG4gICAgcmV0dXJuIHJvdXRlO1xuICB9XG5cbiAgZ3JvdXAob3B0aW9ucykge1xuICAgIHJldHVybiBuZXcgR3JvdXAodGhpcywgb3B0aW9ucyk7XG4gIH1cblxuICBwYXRoKF9wYXRoRGVmLCBmaWVsZHMgPSB7fSwgcXVlcnlQYXJhbXMpIHtcbiAgICBsZXQgcGF0aERlZiA9IF9wYXRoRGVmO1xuICAgIGlmICh0aGlzLl9yb3V0ZXNNYXBbcGF0aERlZl0pIHtcbiAgICAgIHBhdGhEZWYgPSB0aGlzLl9yb3V0ZXNNYXBbcGF0aERlZl0ucGF0aDtcbiAgICB9XG5cbiAgICBsZXQgcGF0aCA9IHBhdGhEZWYucmVwbGFjZSh0aGlzLnBhdGhSZWdFeHAsIChfa2V5KSA9PiB7XG4gICAgICBjb25zdCBmaXJzdFJlZ2V4cENoYXIgPSBfa2V5LmluZGV4T2YoJygnKTtcbiAgICAgIC8vIGdldCB0aGUgY29udGVudCBiZWhpbmQgOiBhbmQgKFxcXFxkKy8pXG4gICAgICBsZXQga2V5ID0gX2tleS5zdWJzdHJpbmcoMSwgZmlyc3RSZWdleHBDaGFyID4gMCA/IGZpcnN0UmVnZXhwQ2hhciA6IHVuZGVmaW5lZCk7XG4gICAgICAvLyByZW1vdmUgKz8qXG4gICAgICBrZXkgPSBrZXkucmVwbGFjZSgvW1xcK1xcKlxcP10rL2csICcnKTtcblxuICAgICAgaWYgKGZpZWxkc1trZXldKSB7XG4gICAgICAgIHJldHVybiB0aGlzLl9lbmNvZGVQYXJhbShgJHtmaWVsZHNba2V5XX1gKTtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuICcnO1xuICAgIH0pO1xuXG4gICAgcGF0aCA9IHBhdGgucmVwbGFjZSgvXFwvXFwvKy9nLCAnLycpOyAvLyBSZXBsYWNlIG11bHRpcGxlIHNsYXNoZXMgd2l0aCBzaW5nbGUgc2xhc2hcblxuICAgIC8vIHJlbW92ZSB0cmFpbGluZyBzbGFzaFxuICAgIC8vIGJ1dCBrZWVwIHRoZSByb290IHNsYXNoIGlmIGl0J3MgdGhlIG9ubHkgb25lXG4gICAgcGF0aCA9IHBhdGgubWF0Y2goL15cXC97MX0kLykgPyBwYXRoIDogcGF0aC5yZXBsYWNlKC9cXC8kLywgJycpO1xuXG4gICAgY29uc3Qgc3RyUXVlcnlQYXJhbXMgPSBxcy5zdHJpbmdpZnkocXVlcnlQYXJhbXMgfHwge30pO1xuICAgIGlmIChzdHJRdWVyeVBhcmFtcykge1xuICAgICAgcGF0aCArPSBgPyR7c3RyUXVlcnlQYXJhbXN9YDtcbiAgICB9XG5cbiAgICByZXR1cm4gcGF0aDtcbiAgfVxuXG4gIG9uUm91dGVSZWdpc3RlcihjYikge1xuICAgIHRoaXMuX29uUm91dGVDYWxsYmFja3MucHVzaChjYik7XG4gIH1cblxuICBfdHJpZ2dlclJvdXRlUmVnaXN0ZXIoY3VycmVudFJvdXRlKSB7XG4gICAgLy8gV2Ugc2hvdWxkIG9ubHkgbmVlZCB0byBzZW5kIGEgc2FmZSBzZXQgb2YgZmllbGRzIG9uIHRoZSByb3V0ZVxuICAgIC8vIG9iamVjdC5cbiAgICAvLyBUaGlzIGlzIG5vdCB0byBoaWRlIHdoYXQncyBpbnNpZGUgdGhlIHJvdXRlIG9iamVjdCwgYnV0IHRvIHNob3dcbiAgICAvLyB0aGVzZSBhcmUgdGhlIHB1YmxpYyBBUElzXG4gICAgY29uc3Qgcm91dGVQdWJsaWNBcGkgPSBfaGVscGVycy5waWNrKGN1cnJlbnRSb3V0ZSwgW1xuICAgICAgJ25hbWUnLFxuICAgICAgJ3BhdGhEZWYnLFxuICAgICAgJ3BhdGgnLFxuICAgIF0pO1xuICAgIHJvdXRlUHVibGljQXBpLm9wdGlvbnMgPSBfaGVscGVycy5vbWl0KGN1cnJlbnRSb3V0ZS5vcHRpb25zLCBbXG4gICAgICAndHJpZ2dlcnNFbnRlcicsXG4gICAgICAndHJpZ2dlcnNFeGl0JyxcbiAgICAgICdhY3Rpb24nLFxuICAgICAgJ3N1YnNjcmlwdGlvbnMnLFxuICAgICAgJ25hbWUnLFxuICAgIF0pO1xuXG4gICAgdGhpcy5fb25Sb3V0ZUNhbGxiYWNrcy5mb3JFYWNoKGNiID0+IHtcbiAgICAgIGNiKHJvdXRlUHVibGljQXBpKTtcbiAgICB9KTtcbiAgfVxuXG4gIGdvKCkge1xuICAgIC8vIGNsaWVudCBvbmx5XG4gIH1cblxuICBjdXJyZW50KCkge1xuICAgIC8vIGNsaWVudCBvbmx5XG4gICAgcmV0dXJuIHRoaXMuX2N1cnJlbnQ7XG4gIH1cblxuICBtaWRkbGV3YXJlKCkge1xuICAgIC8vIGNsaWVudCBvbmx5XG4gIH1cblxuICBnZXRTdGF0ZSgpIHtcbiAgICAvLyBjbGllbnQgb25seVxuICB9XG5cbiAgZ2V0QWxsU3RhdGVzKCkge1xuICAgIC8vIGNsaWVudCBvbmx5XG4gIH1cblxuICBnZXRSb3V0ZU5hbWUoKSB7XG4gICAgcmV0dXJuIHRoaXMuX2N1cnJlbnQucm91dGUgPyB0aGlzLl9jdXJyZW50LnJvdXRlLm5hbWUgOiB1bmRlZmluZWQ7XG4gIH1cblxuICBnZXRRdWVyeVBhcmFtKGtleSkge1xuICAgIHJldHVybiB0aGlzLl9jdXJyZW50LnF1ZXJ5ID8gdGhpcy5fY3VycmVudC5xdWVyeVBhcmFtc1trZXldIDogdW5kZWZpbmVkO1xuICB9XG5cbiAgc2V0U3RhdGUoKSB7XG4gICAgLy8gY2xpZW50IG9ubHlcbiAgfVxuXG4gIHNldFBhcmFtcygpIHt9XG5cbiAgcmVtb3ZlU3RhdGUoKSB7XG4gICAgLy8gY2xpZW50IG9ubHlcbiAgfVxuXG4gIGNsZWFyU3RhdGVzKCkge1xuICAgIC8vIGNsaWVudCBvbmx5XG4gIH1cblxuICByZWFkeSgpIHtcbiAgICAvLyBjbGllbnQgb25seVxuICB9XG5cbiAgaW5pdGlhbGl6ZSgpIHtcbiAgICAvLyBjbGllbnQgb25seVxuICB9XG5cbiAgd2FpdCgpIHtcbiAgICAvLyBjbGllbnQgb25seVxuICB9XG5cbiAgdXJsKCkge1xuICAgIC8vIFdlIG5lZWQgdG8gcmVtb3ZlIHRoZSBsZWFkaW5nIGJhc2UgcGF0aCwgb3IgXCIvXCIsIGFzIGl0IHdpbGwgYmUgaW5zZXJ0ZWRcbiAgICAvLyBhdXRvbWF0aWNhbGx5IGJ5IGBNZXRlb3IuYWJzb2x1dGVVcmxgIGFzIGRvY3VtZW50ZWQgaW46XG4gICAgLy8gaHR0cDovL2RvY3MubWV0ZW9yLmNvbS8jL2Z1bGwvbWV0ZW9yX2Fic29sdXRldXJsXG4gICAgcmV0dXJuIE1ldGVvci5hYnNvbHV0ZVVybCh0aGlzLnBhdGguYXBwbHkodGhpcywgYXJndW1lbnRzKS5yZXBsYWNlKG5ldyBSZWdFeHAoJ14nICsgKCcvJyArICh0aGlzLl9iYXNlUGF0aCB8fCAnJykgKyAnLycpLnJlcGxhY2UoL1xcL1xcLysvZywgJy8nKSksICcnKSk7XG4gIH1cbn1cblxuZXhwb3J0IGRlZmF1bHQgUm91dGVyO1xuIiwiaW1wb3J0IHsgTWV0ZW9yIH0gICAgIGZyb20gJ21ldGVvci9tZXRlb3InO1xuaW1wb3J0IHsgX2hlbHBlcnMgfSAgIGZyb20gJy4vLi4vLi4vbGliL19oZWxwZXJzLmpzJztcbmltcG9ydCB7IEZsb3dSb3V0ZXIgfSBmcm9tICcuLi9faW5pdC5qcyc7XG5cbmlmKCFQYWNrYWdlWydjb21tdW5pdHlwYWNrYWdlczpmYXN0LXJlbmRlciddKSB7XG4gIHJldHVybjtcbn1cblxuY29uc3QgRmFzdFJlbmRlciA9IFBhY2thZ2VbJ2NvbW11bml0eXBhY2thZ2VzOmZhc3QtcmVuZGVyJ10uRmFzdFJlbmRlcjtcblxuY29uc3Qgc2V0dXBGYXN0UmVuZGVyID0gKCkgPT4ge1xuICBGbG93Um91dGVyLl9yb3V0ZXMuZm9yRWFjaCgocm91dGUpID0+IHtcbiAgICBpZiAocm91dGUucGF0aERlZiA9PT0gJyonKSB7XG4gICAgICByZXR1cm47XG4gICAgfVxuXG4gICAgRmFzdFJlbmRlci5yb3V0ZShyb3V0ZS5wYXRoRGVmLCBmdW5jdGlvbiAocm91dGVQYXJhbXMsIHBhdGgpIHtcbiAgICAgIC8vIGFueW9uZSB1c2luZyBNZXRlb3Iuc3Vic2NyaWJlIGZvciBzb21ldGhpbmcgZWxzZT9cbiAgICAgIGNvbnN0IG1ldGVvclN1YnNjcmliZSA9IE1ldGVvci5zdWJzY3JpYmU7XG4gICAgICBNZXRlb3Iuc3Vic2NyaWJlID0gZnVuY3Rpb24gKCkge1xuICAgICAgICByZXR1cm4gQXJyYXkuZnJvbShhcmd1bWVudHMpO1xuICAgICAgfTtcblxuICAgICAgcm91dGUuX3N1YnNNYXAgPSB7fTtcbiAgICAgIEZsb3dSb3V0ZXIuc3Vic2NyaXB0aW9ucy5jYWxsKHJvdXRlLCBwYXRoKTtcbiAgICAgIGlmIChyb3V0ZS5zdWJzY3JpcHRpb25zKSB7XG4gICAgICAgIHJvdXRlLnN1YnNjcmlwdGlvbnMoX2hlbHBlcnMub21pdChyb3V0ZVBhcmFtcywgWydxdWVyeSddKSwgcm91dGVQYXJhbXMucXVlcnkpO1xuICAgICAgfVxuXG4gICAgICBPYmplY3Qua2V5cyhyb3V0ZS5fc3Vic01hcCkuZm9yRWFjaCgoa2V5KSA9PiB7XG4gICAgICAgIHRoaXMuc3Vic2NyaWJlLmFwcGx5KHRoaXMsIHJvdXRlLl9zdWJzTWFwW2tleV0pO1xuICAgICAgfSk7XG5cbiAgICAgIC8vIHJlc3RvcmUgTWV0ZW9yLnN1YnNjcmliZSwgLi4uIG9uIHNlcnZlciBzaWRlXG4gICAgICBNZXRlb3Iuc3Vic2NyaWJlID0gbWV0ZW9yU3Vic2NyaWJlO1xuICAgIH0pO1xuICB9KTtcbn07XG5cbi8vIGhhY2sgdG8gcnVuIGFmdGVyIGV2ZXJ5dGhpbmcgZWxzZSBvbiBzdGFydHVwXG5NZXRlb3Iuc3RhcnR1cCgoKSA9PiB7XG4gIE1ldGVvci5zdGFydHVwKCgpID0+IHtcbiAgICBzZXR1cEZhc3RSZW5kZXIoKTtcbiAgfSk7XG59KTtcbiIsImltcG9ydCB7IE1ldGVvciB9IGZyb20gJ21ldGVvci9tZXRlb3InO1xuXG5jb25zdCBfaGVscGVycyA9IHtcbiAgaXNFbXB0eShvYmopIHsgLy8gMVxuICAgIGlmIChvYmogPT0gbnVsbCkge1xuICAgICAgcmV0dXJuIHRydWU7XG4gICAgfVxuXG4gICAgaWYgKHRoaXMuaXNBcnJheShvYmopIHx8IHRoaXMuaXNTdHJpbmcob2JqKSB8fCB0aGlzLmlzQXJndW1lbnRzKG9iaikpIHtcbiAgICAgIHJldHVybiBvYmoubGVuZ3RoID09PSAwO1xuICAgIH1cblxuICAgIHJldHVybiBPYmplY3Qua2V5cyhvYmopLmxlbmd0aCA9PT0gMDtcbiAgfSxcbiAgaXNPYmplY3Qob2JqKSB7XG4gICAgY29uc3QgdHlwZSA9IHR5cGVvZiBvYmo7XG4gICAgcmV0dXJuIHR5cGUgPT09ICdmdW5jdGlvbicgfHwgdHlwZSA9PT0gJ29iamVjdCcgJiYgISFvYmo7XG4gIH0sXG4gIG9taXQob2JqLCBrZXlzKSB7IC8vIDEwXG4gICAgaWYgKCF0aGlzLmlzT2JqZWN0KG9iaikpIHtcbiAgICAgIE1ldGVvci5fZGVidWcoJ1tvc3RyaW86Zmxvdy1yb3V0ZXItZXh0cmFdIFtfaGVscGVycy5vbWl0XSBGaXJzdCBhcmd1bWVudCBtdXN0IGJlIGFuIE9iamVjdCcpO1xuICAgICAgcmV0dXJuIG9iajtcbiAgICB9XG5cbiAgICBpZiAoIXRoaXMuaXNBcnJheShrZXlzKSkge1xuICAgICAgTWV0ZW9yLl9kZWJ1ZygnW29zdHJpbzpmbG93LXJvdXRlci1leHRyYV0gW19oZWxwZXJzLm9taXRdIFNlY29uZCBhcmd1bWVudCBtdXN0IGJlIGFuIEFycmF5Jyk7XG4gICAgICByZXR1cm4gb2JqO1xuICAgIH1cblxuICAgIGNvbnN0IGNvcHkgPSB0aGlzLmNsb25lKG9iaik7XG4gICAga2V5cy5mb3JFYWNoKChrZXkpID0+IHtcbiAgICAgIGRlbGV0ZSBjb3B5W2tleV07XG4gICAgfSk7XG5cbiAgICByZXR1cm4gY29weTtcbiAgfSxcbiAgcGljayhvYmosIGtleXMpIHsgLy8gMlxuICAgIGlmICghdGhpcy5pc09iamVjdChvYmopKSB7XG4gICAgICBNZXRlb3IuX2RlYnVnKCdbb3N0cmlvOmZsb3ctcm91dGVyLWV4dHJhXSBbX2hlbHBlcnMub21pdF0gRmlyc3QgYXJndW1lbnQgbXVzdCBiZSBhbiBPYmplY3QnKTtcbiAgICAgIHJldHVybiBvYmo7XG4gICAgfVxuXG4gICAgaWYgKCF0aGlzLmlzQXJyYXkoa2V5cykpIHtcbiAgICAgIE1ldGVvci5fZGVidWcoJ1tvc3RyaW86Zmxvdy1yb3V0ZXItZXh0cmFdIFtfaGVscGVycy5vbWl0XSBTZWNvbmQgYXJndW1lbnQgbXVzdCBiZSBhbiBBcnJheScpO1xuICAgICAgcmV0dXJuIG9iajtcbiAgICB9XG5cbiAgICBjb25zdCBwaWNrZWQgPSB7fTtcbiAgICBrZXlzLmZvckVhY2goKGtleSkgPT4ge1xuICAgICAgcGlja2VkW2tleV0gPSBvYmpba2V5XTtcbiAgICB9KTtcblxuICAgIHJldHVybiBwaWNrZWQ7XG4gIH0sXG4gIGlzQXJyYXkob2JqKSB7XG4gICAgcmV0dXJuIEFycmF5LmlzQXJyYXkob2JqKTtcbiAgfSxcbiAgZXh0ZW5kKC4uLm9ianMpIHsgLy8gNFxuICAgIHJldHVybiBPYmplY3QuYXNzaWduKHt9LCAuLi5vYmpzKTtcbiAgfSxcbiAgY2xvbmUob2JqKSB7XG4gICAgaWYgKCF0aGlzLmlzT2JqZWN0KG9iaikpIHJldHVybiBvYmo7XG4gICAgcmV0dXJuIHRoaXMuaXNBcnJheShvYmopID8gb2JqLnNsaWNlKCkgOiB0aGlzLmV4dGVuZChvYmopO1xuICB9XG59O1xuXG5bJ0FyZ3VtZW50cycsICdGdW5jdGlvbicsICdTdHJpbmcnLCAnUmVnRXhwJ10uZm9yRWFjaCgobmFtZSkgPT4ge1xuICBfaGVscGVyc1snaXMnICsgbmFtZV0gPSBmdW5jdGlvbiAob2JqKSB7XG4gICAgcmV0dXJuIE9iamVjdC5wcm90b3R5cGUudG9TdHJpbmcuY2FsbChvYmopID09PSAnW29iamVjdCAnICsgbmFtZSArICddJztcbiAgfTtcbn0pO1xuXG5leHBvcnQgeyBfaGVscGVycyB9O1xuIl19
