(function () {

/* Imports */
var Meteor = Package.meteor.Meteor;
var global = Package.meteor.global;
var meteorEnv = Package.meteor.meteorEnv;
var check = Package.check.check;
var Match = Package.check.Match;
var _ = Package.underscore._;
var JsonRoutes = Package['simple:json-routes'].JsonRoutes;
var RestMiddleware = Package['simple:json-routes'].RestMiddleware;
var Accounts = Package['accounts-base'].Accounts;

/* Package-scope variables */
var __coffeescriptShare, ironRouterSendErrorToResponse, msg, Restivus;

(function(){

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                   //
// packages/nimble_restivus/lib/auth.coffee.js                                                                       //
//                                                                                                                   //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                     //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
var getUserQuerySelector, passwordValidator, userValidator;

this.Auth || (this.Auth = {});


/*
  A valid user will have exactly one of the following identification fields: id, username, or email
 */

userValidator = Match.Where(function(user) {
  check(user, {
    id: Match.Optional(String),
    username: Match.Optional(String),
    email: Match.Optional(String)
  });
  if (_.keys(user).length === !1) {
    throw new Match.Error('User must have exactly one identifier field');
  }
  return true;
});


/*
  A password can be either in plain text or hashed
 */

passwordValidator = Match.OneOf(String, {
  digest: String,
  algorithm: String
});


/*
  Return a MongoDB query selector for finding the given user
 */

getUserQuerySelector = function(user) {
  if (user.id) {
    return {
      '_id': user.id
    };
  } else if (user.username) {
    return {
      'username': user.username
    };
  } else if (user.email) {
    return {
      'emails.address': user.email
    };
  }
  throw new Error('Cannot create selector from invalid user');
};


/*
  Log a user in with their password
 */

this.Auth.loginWithPassword = function(user, password) {
  var authToken, authenticatingUser, authenticatingUserSelector, hashedToken, passwordVerification, ref;
  if (!user || !password) {
    throw new Meteor.Error(401, 'Unauthorized');
  }
  check(user, userValidator);
  check(password, passwordValidator);
  authenticatingUserSelector = getUserQuerySelector(user);
  authenticatingUser = Meteor.users.findOne(authenticatingUserSelector);
  if (!authenticatingUser) {
    throw new Meteor.Error(401, 'Unauthorized');
  }
  if (!((ref = authenticatingUser.services) != null ? ref.password : void 0)) {
    throw new Meteor.Error(401, 'Unauthorized');
  }
  passwordVerification = Accounts._checkPassword(authenticatingUser, password);
  if (passwordVerification.error) {
    throw new Meteor.Error(401, 'Unauthorized');
  }
  authToken = Accounts._generateStampedLoginToken();
  hashedToken = Accounts._hashLoginToken(authToken.token);
  Accounts._insertHashedLoginToken(authenticatingUser._id, {
    hashedToken: hashedToken
  });
  return {
    authToken: authToken.token,
    userId: authenticatingUser._id
  };
};

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}).call(this);






(function(){

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                   //
// packages/nimble_restivus/lib/iron-router-error-to-response.js                                                     //
//                                                                                                                   //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                     //
// We need a function that treats thrown errors exactly like Iron Router would.
// This file is written in JavaScript to enable copy-pasting Iron Router code.

// Taken from: https://github.com/iron-meteor/iron-router/blob/9c369499c98af9fd12ef9e68338dee3b1b1276aa/lib/router_server.js#L3
var env = process.env.NODE_ENV || 'development';

// Taken from: https://github.com/iron-meteor/iron-router/blob/9c369499c98af9fd12ef9e68338dee3b1b1276aa/lib/router_server.js#L47
ironRouterSendErrorToResponse = function (err, req, res) {
  if (res.statusCode < 400)
    res.statusCode = 500;

  if (err.status)
    res.statusCode = err.status;

  if (env === 'development')
    msg = (err.stack || err.toString()) + '\n';
  else
    //XXX get this from standard dict of error messages?
    msg = 'Server error.';

  console.error(err.stack || err.toString());

  if (res.headersSent)
    return req.socket.destroy();

  res.setHeader('Content-Type', 'text/html');
  res.setHeader('Content-Length', Buffer.byteLength(msg));
  if (req.method === 'HEAD')
    return res.end();
  res.end(msg);
  return;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}).call(this);






(function(){

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                   //
// packages/nimble_restivus/lib/route.coffee.js                                                                      //
//                                                                                                                   //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                     //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
share.Route = (function() {
  function Route(api, path, options, endpoints1) {
    this.api = api;
    this.path = path;
    this.options = options;
    this.endpoints = endpoints1;
    if (!this.endpoints) {
      this.endpoints = this.options;
      this.options = {};
    }
  }

  Route.prototype.addToApi = (function() {
    var availableMethods;
    availableMethods = ['get', 'post', 'put', 'patch', 'delete', 'options'];
    return function() {
      var allowedMethods, fullPath, rejectedMethods, self;
      self = this;
      if (_.contains(this.api._config.paths, this.path)) {
        throw new Error("Cannot add a route at an existing path: " + this.path);
      }
      this.endpoints = _.extend({
        options: this.api._config.defaultOptionsEndpoint
      }, this.endpoints);
      this._resolveEndpoints();
      this._configureEndpoints();
      this.api._config.paths.push(this.path);
      allowedMethods = _.filter(availableMethods, function(method) {
        return _.contains(_.keys(self.endpoints), method);
      });
      rejectedMethods = _.reject(availableMethods, function(method) {
        return _.contains(_.keys(self.endpoints), method);
      });
      fullPath = this.api._config.apiPath + this.path;
      _.each(allowedMethods, function(method) {
        var endpoint;
        endpoint = self.endpoints[method];
        return JsonRoutes.add(method, fullPath, function(req, res) {
          var doneFunc, endpointContext, error, responseData, responseInitiated;
          responseInitiated = false;
          doneFunc = function() {
            return responseInitiated = true;
          };
          endpointContext = {
            urlParams: req.params,
            queryParams: req.query,
            bodyParams: req.body,
            request: req,
            response: res,
            done: doneFunc
          };
          _.extend(endpointContext, endpoint);
          responseData = null;
          try {
            responseData = self._callEndpoint(endpointContext, endpoint);
          } catch (_error) {
            error = _error;
            ironRouterSendErrorToResponse(error, req, res);
            return;
          }
          if (responseInitiated) {
            res.end();
            return;
          } else {
            if (res.headersSent) {
              throw new Error("Must call this.done() after handling endpoint response manually: " + method + " " + fullPath);
            } else if (responseData === null || responseData === void 0) {
              throw new Error("Cannot return null or undefined from an endpoint: " + method + " " + fullPath);
            }
          }
          if (responseData.body && (responseData.statusCode || responseData.headers)) {
            return self._respond(res, responseData.body, responseData.statusCode, responseData.headers);
          } else {
            return self._respond(res, responseData);
          }
        });
      });
      return _.each(rejectedMethods, function(method) {
        return JsonRoutes.add(method, fullPath, function(req, res) {
          var headers, responseData;
          responseData = {
            status: 'error',
            message: 'API endpoint does not exist'
          };
          headers = {
            'Allow': allowedMethods.join(', ').toUpperCase()
          };
          return self._respond(res, responseData, 405, headers);
        });
      });
    };
  })();


  /*
    Convert all endpoints on the given route into our expected endpoint object if it is a bare
    function
  
    @param {Route} route The route the endpoints belong to
   */

  Route.prototype._resolveEndpoints = function() {
    _.each(this.endpoints, function(endpoint, method, endpoints) {
      if (_.isFunction(endpoint)) {
        return endpoints[method] = {
          action: endpoint
        };
      }
    });
  };


  /*
    Configure the authentication and role requirement on all endpoints (except OPTIONS, which must
    be configured directly on the endpoint)
  
    Authentication can be required on an entire route or individual endpoints. If required on an
    entire route, that serves as the default. If required in any individual endpoints, that will
    override the default.
  
    After the endpoint is configured, all authentication and role requirements of an endpoint can be
    accessed at <code>endpoint.authRequired</code> and <code>endpoint.roleRequired</code>,
    respectively.
  
    @param {Route} route The route the endpoints belong to
    @param {Endpoint} endpoint The endpoint to configure
   */

  Route.prototype._configureEndpoints = function() {
    _.each(this.endpoints, function(endpoint, method) {
      var ref, ref1;
      if (method !== 'options') {
        if (!((ref = this.options) != null ? ref.roleRequired : void 0)) {
          this.options.roleRequired = [];
        }
        if (!endpoint.roleRequired) {
          endpoint.roleRequired = [];
        }
        endpoint.roleRequired = _.union(endpoint.roleRequired, this.options.roleRequired);
        if (_.isEmpty(endpoint.roleRequired)) {
          endpoint.roleRequired = false;
        }
        if (endpoint.authRequired === void 0) {
          if (((ref1 = this.options) != null ? ref1.authRequired : void 0) || endpoint.roleRequired) {
            endpoint.authRequired = true;
          } else {
            endpoint.authRequired = false;
          }
        }
      }
    }, this);
  };


  /*
    Authenticate an endpoint if required, and return the result of calling it
  
    @returns The endpoint response or a 401 if authentication fails
   */

  Route.prototype._callEndpoint = function(endpointContext, endpoint) {
    var auth;
    auth = this._authAccepted(endpointContext, endpoint);
    if (auth.success) {
      if (this._roleAccepted(endpointContext, endpoint)) {
        return endpoint.action.call(endpointContext);
      } else {
        return {
          statusCode: 403,
          body: {
            status: 'error',
            message: 'You do not have permission to do this.'
          }
        };
      }
    } else {
      if (auth.data) {
        return auth.data;
      } else {
        return {
          statusCode: 401,
          body: {
            status: 'error',
            message: 'You must be logged in to do this.'
          }
        };
      }
    }
  };


  /*
    Authenticate the given endpoint if required
  
    Once it's globally configured in the API, authentication can be required on an entire route or
    individual endpoints. If required on an entire endpoint, that serves as the default. If required
    in any individual endpoints, that will override the default.
  
    @returns An object of the following format:
  
        {
          success: Boolean
          data: String or Object
        }
  
      where `success` is `true` if all required authentication checks pass and the optional `data`
      will contain the auth data when successful and an optional error response when auth fails.
   */

  Route.prototype._authAccepted = function(endpointContext, endpoint) {
    if (endpoint.authRequired) {
      return this._authenticate(endpointContext);
    } else {
      return {
        success: true
      };
    }
  };


  /*
    Verify the request is being made by an actively logged in user
  
    If verified, attach the authenticated user to the context.
  
    @returns An object of the following format:
  
        {
          success: Boolean
          data: String or Object
        }
  
      where `success` is `true` if all required authentication checks pass and the optional `data`
      will contain the auth data when successful and an optional error response when auth fails.
   */

  Route.prototype._authenticate = function(endpointContext) {
    var auth, userSelector;
    auth = this.api._config.auth.user.call(endpointContext);
    if (!auth) {
      return {
        success: false
      };
    }
    if (auth.userId && auth.token && !auth.user) {
      userSelector = {};
      userSelector._id = auth.userId;
      userSelector[this.api._config.auth.token] = auth.token;
      auth.user = Meteor.users.findOne(userSelector);
    }
    if (auth.error) {
      return {
        success: false,
        data: auth.error
      };
    }
    if (auth.user) {
      endpointContext.user = auth.user;
      endpointContext.userId = auth.user._id;
      return {
        success: true,
        data: auth
      };
    } else {
      return {
        success: false
      };
    }
  };


  /*
    Authenticate the user role if required
  
    Must be called after _authAccepted().
  
    @returns True if the authenticated user belongs to <i>any</i> of the acceptable roles on the
             endpoint
   */

  Route.prototype._roleAccepted = function(endpointContext, endpoint) {
    if (endpoint.roleRequired) {
      if (_.isEmpty(_.intersection(endpoint.roleRequired, endpointContext.user.roles))) {
        return false;
      }
    }
    return true;
  };


  /*
    Respond to an HTTP request
   */

  Route.prototype._respond = function(response, body, statusCode, headers) {
    var defaultHeaders, delayInMilliseconds, minimumDelayInMilliseconds, randomMultiplierBetweenOneAndTwo, sendResponse;
    if (statusCode == null) {
      statusCode = 200;
    }
    if (headers == null) {
      headers = {};
    }
    defaultHeaders = this._lowerCaseKeys(this.api._config.defaultHeaders);
    headers = this._lowerCaseKeys(headers);
    headers = _.extend(defaultHeaders, headers);
    if (headers['content-type'].match(/json|javascript/) !== null) {
      if (this.api._config.prettyJson) {
        body = JSON.stringify(body, void 0, 2);
      } else {
        body = JSON.stringify(body);
      }
    }
    sendResponse = function() {
      response.writeHead(statusCode, headers);
      response.write(body);
      return response.end();
    };
    if (statusCode === 401 || statusCode === 403) {
      minimumDelayInMilliseconds = 500;
      randomMultiplierBetweenOneAndTwo = 1 + Math.random();
      delayInMilliseconds = minimumDelayInMilliseconds * randomMultiplierBetweenOneAndTwo;
      return Meteor.setTimeout(sendResponse, delayInMilliseconds);
    } else {
      return sendResponse();
    }
  };


  /*
    Return the object with all of the keys converted to lowercase
   */

  Route.prototype._lowerCaseKeys = function(object) {
    return _.chain(object).pairs().map(function(attr) {
      return [attr[0].toLowerCase(), attr[1]];
    }).object().value();
  };

  return Route;

})();

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}).call(this);






(function(){

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                   //
// packages/nimble_restivus/lib/restivus.coffee.js                                                                   //
//                                                                                                                   //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                     //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
var          
  indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

this.Restivus = (function() {
  function Restivus(options) {
    var corsHeaders;
    this._routes = [];
    this._config = {
      paths: [],
      useDefaultAuth: false,
      apiPath: 'api/',
      version: null,
      prettyJson: false,
      auth: {
        token: 'services.resume.loginTokens.hashedToken',
        user: function() {
          var token;
          if (this.request.headers['x-auth-token']) {
            token = Accounts._hashLoginToken(this.request.headers['x-auth-token']);
          }
          return {
            userId: this.request.headers['x-user-id'],
            token: token
          };
        }
      },
      defaultHeaders: {
        'Content-Type': 'application/json'
      },
      enableCors: true
    };
    _.extend(this._config, options);
    if (this._config.enableCors) {
      corsHeaders = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Origin, X-Requested-With, Content-Type, Accept'
      };
      if (this._config.useDefaultAuth) {
        corsHeaders['Access-Control-Allow-Headers'] += ', X-User-Id, X-Auth-Token';
      }
      _.extend(this._config.defaultHeaders, corsHeaders);
      if (!this._config.defaultOptionsEndpoint) {
        this._config.defaultOptionsEndpoint = function() {
          this.response.writeHead(200, corsHeaders);
          return this.done();
        };
      }
    }
    if (this._config.apiPath[0] === '/') {
      this._config.apiPath = this._config.apiPath.slice(1);
    }
    if (_.last(this._config.apiPath) !== '/') {
      this._config.apiPath = this._config.apiPath + '/';
    }
    if (this._config.version) {
      this._config.apiPath += this._config.version + '/';
    }
    if (this._config.useDefaultAuth) {
      this._initAuth();
    } else if (this._config.useAuth) {
      this._initAuth();
      console.warn('Warning: useAuth API config option will be removed in Restivus v1.0 ' + '\n    Use the useDefaultAuth option instead');
    }
    return this;
  }


  /**
    Add endpoints for the given HTTP methods at the given path
  
    @param path {String} The extended URL path (will be appended to base path of the API)
    @param options {Object} Route configuration options
    @param options.authRequired {Boolean} The default auth requirement for each endpoint on the route
    @param options.roleRequired {String or String[]} The default role required for each endpoint on the route
    @param endpoints {Object} A set of endpoints available on the new route (get, post, put, patch, delete, options)
    @param endpoints.<method> {Function or Object} If a function is provided, all default route
        configuration options will be applied to the endpoint. Otherwise an object with an `action`
        and all other route config options available. An `action` must be provided with the object.
   */

  Restivus.prototype.addRoute = function(path, options, endpoints) {
    var route;
    route = new share.Route(this, path, options, endpoints);
    this._routes.push(route);
    route.addToApi();
    return this;
  };


  /**
    Generate routes for the Meteor Collection with the given name
   */

  Restivus.prototype.addCollection = function(collection, options) {
    var collectionEndpoints, collectionRouteEndpoints, endpointsAwaitingConfiguration, entityRouteEndpoints, excludedEndpoints, methods, methodsOnCollection, path, routeOptions;
    if (options == null) {
      options = {};
    }
    methods = ['get', 'post', 'put', 'patch', 'delete', 'getAll'];
    methodsOnCollection = ['post', 'getAll'];
    if (collection === Meteor.users) {
      collectionEndpoints = this._userCollectionEndpoints;
    } else {
      collectionEndpoints = this._collectionEndpoints;
    }
    endpointsAwaitingConfiguration = options.endpoints || {};
    routeOptions = options.routeOptions || {};
    excludedEndpoints = options.excludedEndpoints || [];
    path = options.path || collection._name;
    collectionRouteEndpoints = {};
    entityRouteEndpoints = {};
    if (_.isEmpty(endpointsAwaitingConfiguration) && _.isEmpty(excludedEndpoints)) {
      _.each(methods, function(method) {
        if (indexOf.call(methodsOnCollection, method) >= 0) {
          _.extend(collectionRouteEndpoints, collectionEndpoints[method].call(this, collection));
        } else {
          _.extend(entityRouteEndpoints, collectionEndpoints[method].call(this, collection));
        }
      }, this);
    } else {
      _.each(methods, function(method) {
        var configuredEndpoint, endpointOptions;
        if (indexOf.call(excludedEndpoints, method) < 0 && endpointsAwaitingConfiguration[method] !== false) {
          endpointOptions = endpointsAwaitingConfiguration[method];
          configuredEndpoint = {};
          _.each(collectionEndpoints[method].call(this, collection), function(action, methodType) {
            return configuredEndpoint[methodType] = _.chain(action).clone().extend(endpointOptions).value();
          });
          if (indexOf.call(methodsOnCollection, method) >= 0) {
            _.extend(collectionRouteEndpoints, configuredEndpoint);
          } else {
            _.extend(entityRouteEndpoints, configuredEndpoint);
          }
        }
      }, this);
    }
    this.addRoute(path, routeOptions, collectionRouteEndpoints);
    this.addRoute(path + "/:id", routeOptions, entityRouteEndpoints);
    return this;
  };


  /**
    A set of endpoints that can be applied to a Collection Route
   */

  Restivus.prototype._collectionEndpoints = {
    get: function(collection) {
      return {
        get: {
          action: function() {
            var entity;
            entity = collection.findOne(this.urlParams.id);
            if (entity) {
              return {
                status: 'success',
                data: entity
              };
            } else {
              return {
                statusCode: 404,
                body: {
                  status: 'fail',
                  message: 'Item not found'
                }
              };
            }
          }
        }
      };
    },
    put: function(collection) {
      return {
        put: {
          action: function() {
            var entity, entityIsUpdated;
            entityIsUpdated = collection.update(this.urlParams.id, this.bodyParams);
            if (entityIsUpdated) {
              entity = collection.findOne(this.urlParams.id);
              return {
                status: 'success',
                data: entity
              };
            } else {
              return {
                statusCode: 404,
                body: {
                  status: 'fail',
                  message: 'Item not found'
                }
              };
            }
          }
        }
      };
    },
    patch: function(collection) {
      return {
        patch: {
          action: function() {
            var entity, entityIsUpdated;
            entityIsUpdated = collection.update(this.urlParams.id, {
              $set: this.bodyParams
            });
            if (entityIsUpdated) {
              entity = collection.findOne(this.urlParams.id);
              return {
                status: 'success',
                data: entity
              };
            } else {
              return {
                statusCode: 404,
                body: {
                  status: 'fail',
                  message: 'Item not found'
                }
              };
            }
          }
        }
      };
    },
    "delete": function(collection) {
      return {
        "delete": {
          action: function() {
            if (collection.remove(this.urlParams.id)) {
              return {
                status: 'success',
                data: {
                  message: 'Item removed'
                }
              };
            } else {
              return {
                statusCode: 404,
                body: {
                  status: 'fail',
                  message: 'Item not found'
                }
              };
            }
          }
        }
      };
    },
    post: function(collection) {
      return {
        post: {
          action: function() {
            var entity, entityId;
            entityId = collection.insert(this.bodyParams);
            entity = collection.findOne(entityId);
            if (entity) {
              return {
                statusCode: 201,
                body: {
                  status: 'success',
                  data: entity
                }
              };
            } else {
              return {
                statusCode: 400,
                body: {
                  status: 'fail',
                  message: 'No item added'
                }
              };
            }
          }
        }
      };
    },
    getAll: function(collection) {
      return {
        get: {
          action: function() {
            var entities;
            entities = collection.find().fetch();
            if (entities) {
              return {
                status: 'success',
                data: entities
              };
            } else {
              return {
                statusCode: 404,
                body: {
                  status: 'fail',
                  message: 'Unable to retrieve items from collection'
                }
              };
            }
          }
        }
      };
    }
  };


  /**
    A set of endpoints that can be applied to a Meteor.users Collection Route
   */

  Restivus.prototype._userCollectionEndpoints = {
    get: function(collection) {
      return {
        get: {
          action: function() {
            var entity;
            entity = collection.findOne(this.urlParams.id, {
              fields: {
                profile: 1
              }
            });
            if (entity) {
              return {
                status: 'success',
                data: entity
              };
            } else {
              return {
                statusCode: 404,
                body: {
                  status: 'fail',
                  message: 'User not found'
                }
              };
            }
          }
        }
      };
    },
    put: function(collection) {
      return {
        put: {
          action: function() {
            var entity, entityIsUpdated;
            entityIsUpdated = collection.update(this.urlParams.id, {
              $set: {
                profile: this.bodyParams
              }
            });
            if (entityIsUpdated) {
              entity = collection.findOne(this.urlParams.id, {
                fields: {
                  profile: 1
                }
              });
              return {
                status: "success",
                data: entity
              };
            } else {
              return {
                statusCode: 404,
                body: {
                  status: 'fail',
                  message: 'User not found'
                }
              };
            }
          }
        }
      };
    },
    "delete": function(collection) {
      return {
        "delete": {
          action: function() {
            if (collection.remove(this.urlParams.id)) {
              return {
                status: 'success',
                data: {
                  message: 'User removed'
                }
              };
            } else {
              return {
                statusCode: 404,
                body: {
                  status: 'fail',
                  message: 'User not found'
                }
              };
            }
          }
        }
      };
    },
    post: function(collection) {
      return {
        post: {
          action: function() {
            var entity, entityId;
            entityId = Accounts.createUser(this.bodyParams);
            entity = collection.findOne(entityId, {
              fields: {
                profile: 1
              }
            });
            if (entity) {
              return {
                statusCode: 201,
                body: {
                  status: 'success',
                  data: entity
                }
              };
            } else {
              ({
                statusCode: 400
              });
              return {
                status: 'fail',
                message: 'No user added'
              };
            }
          }
        }
      };
    },
    getAll: function(collection) {
      return {
        get: {
          action: function() {
            var entities;
            entities = collection.find({}, {
              fields: {
                profile: 1
              }
            }).fetch();
            if (entities) {
              return {
                status: 'success',
                data: entities
              };
            } else {
              return {
                statusCode: 404,
                body: {
                  status: 'fail',
                  message: 'Unable to retrieve users'
                }
              };
            }
          }
        }
      };
    }
  };


  /*
    Add /login and /logout endpoints to the API
   */

  Restivus.prototype._initAuth = function() {
    var logout, self;
    self = this;

    /*
      Add a login endpoint to the API
    
      After the user is logged in, the onLoggedIn hook is called (see Restfully.configure() for
      adding hook).
     */
    this.addRoute('login', {
      authRequired: false
    }, {
      post: function() {
        var auth, e, extraData, password, ref, ref1, response, searchQuery, user;
        user = {};
        if (this.bodyParams.user) {
          if (this.bodyParams.user.indexOf('@') === -1) {
            user.username = this.bodyParams.user;
          } else {
            user.email = this.bodyParams.user;
          }
        } else if (this.bodyParams.username) {
          user.username = this.bodyParams.username;
        } else if (this.bodyParams.email) {
          user.email = this.bodyParams.email;
        }
        password = this.bodyParams.password;
        if (this.bodyParams.hashed) {
          password = {
            digest: password,
            algorithm: 'sha-256'
          };
        }
        try {
          auth = Auth.loginWithPassword(user, password);
        } catch (_error) {
          e = _error;
          return {
            statusCode: e.error,
            body: {
              status: 'error',
              message: e.reason
            }
          };
        }
        if (auth.userId && auth.authToken) {
          searchQuery = {};
          searchQuery[self._config.auth.token] = Accounts._hashLoginToken(auth.authToken);
          this.user = Meteor.users.findOne({
            '_id': auth.userId
          }, searchQuery);
          this.userId = (ref = this.user) != null ? ref._id : void 0;
        }
        response = {
          status: 'success',
          data: auth
        };
        extraData = (ref1 = self._config.onLoggedIn) != null ? ref1.call(this) : void 0;
        if (extraData != null) {
          _.extend(response.data, {
            extra: extraData
          });
        }
        return response;
      }
    });
    logout = function() {
      var authToken, extraData, hashedToken, index, ref, response, tokenFieldName, tokenLocation, tokenPath, tokenRemovalQuery, tokenToRemove;
      authToken = this.request.headers['x-auth-token'];
      hashedToken = Accounts._hashLoginToken(authToken);
      tokenLocation = self._config.auth.token;
      index = tokenLocation.lastIndexOf('.');
      tokenPath = tokenLocation.substring(0, index);
      tokenFieldName = tokenLocation.substring(index + 1);
      tokenToRemove = {};
      tokenToRemove[tokenFieldName] = hashedToken;
      tokenRemovalQuery = {};
      tokenRemovalQuery[tokenPath] = tokenToRemove;
      Meteor.users.update(this.user._id, {
        $pull: tokenRemovalQuery
      });
      response = {
        status: 'success',
        data: {
          message: 'You\'ve been logged out!'
        }
      };
      extraData = (ref = self._config.onLoggedOut) != null ? ref.call(this) : void 0;
      if (extraData != null) {
        _.extend(response.data, {
          extra: extraData
        });
      }
      return response;
    };

    /*
      Add a logout endpoint to the API
    
      After the user is logged out, the onLoggedOut hook is called (see Restfully.configure() for
      adding hook).
     */
    return this.addRoute('logout', {
      authRequired: true
    }, {
      get: function() {
        console.warn("Warning: Default logout via GET will be removed in Restivus v1.0. Use POST instead.");
        console.warn("    See https://github.com/kahmali/meteor-restivus/issues/100");
        return logout.call(this);
      },
      post: logout
    });
  };

  return Restivus;

})();

Restivus = this.Restivus;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}).call(this);


/* Exports */
Package._define("nimble:restivus", {
  Restivus: Restivus
});

})();

//# sourceURL=meteor://💻app/packages/nimble_restivus.js
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvbmltYmxlX3Jlc3RpdnVzL2xpYi9hdXRoLmNvZmZlZSIsIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvbmltYmxlX3Jlc3RpdnVzL2xpYi9yb3V0ZS5jb2ZmZWUiLCJtZXRlb3I6Ly/wn5K7YXBwL3BhY2thZ2VzL25pbWJsZV9yZXN0aXZ1cy9saWIvcmVzdGl2dXMuY29mZmVlIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiI7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7QUFBQTs7QUFBQSxJQUFDLFVBQUQsSUFBQyxRQUFTLEdBQVY7O0FBRUE7QUFBQTs7R0FGQTs7QUFBQSxhQUtBLEdBQWdCLEtBQUssQ0FBQyxLQUFOLENBQVksU0FBQyxJQUFEO0FBQzFCLFFBQU0sSUFBTixFQUNFO0FBQUEsUUFBSSxLQUFLLENBQUMsUUFBTixDQUFlLE1BQWYsQ0FBSjtBQUFBLElBQ0EsVUFBVSxLQUFLLENBQUMsUUFBTixDQUFlLE1BQWYsQ0FEVjtBQUFBLElBRUEsT0FBTyxLQUFLLENBQUMsUUFBTixDQUFlLE1BQWYsQ0FGUDtHQURGO0FBS0EsTUFBRyxDQUFDLENBQUMsSUFBRixDQUFPLElBQVAsQ0FBWSxDQUFDLE1BQWIsS0FBdUIsRUFBMUI7QUFDRSxVQUFVLFNBQUssQ0FBQyxLQUFOLENBQVksNkNBQVosQ0FBVixDQURGO0dBTEE7QUFRQSxTQUFPLElBQVAsQ0FUMEI7QUFBQSxDQUFaLENBTGhCOztBQWdCQTtBQUFBOztHQWhCQTs7QUFBQSxpQkFtQkEsR0FBb0IsS0FBSyxDQUFDLEtBQU4sQ0FBWSxNQUFaLEVBQ2xCO0FBQUEsVUFBUSxNQUFSO0FBQUEsRUFDQSxXQUFXLE1BRFg7Q0FEa0IsQ0FuQnBCOztBQXVCQTtBQUFBOztHQXZCQTs7QUFBQSxvQkEwQkEsR0FBdUIsU0FBQyxJQUFEO0FBQ3JCLE1BQUcsSUFBSSxDQUFDLEVBQVI7QUFDRSxXQUFPO0FBQUEsTUFBQyxPQUFPLElBQUksQ0FBQyxFQUFiO0tBQVAs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QUZGOztBQUFBLFFBb1dBLEdBQVcsSUFBQyxTQXBXWiIsImZpbGUiOiIvcGFja2FnZXMvbmltYmxlX3Jlc3RpdnVzLmpzIiwic291cmNlc0NvbnRlbnQiOlsiQEF1dGggb3I9IHt9XG5cbiMjI1xuICBBIHZhbGlkIHVzZXIgd2lsbCBoYXZlIGV4YWN0bHkgb25lIG9mIHRoZSBmb2xsb3dpbmcgaWRlbnRpZmljYXRpb24gZmllbGRzOiBpZCwgdXNlcm5hbWUsIG9yIGVtYWlsXG4jIyNcbnVzZXJWYWxpZGF0b3IgPSBNYXRjaC5XaGVyZSAodXNlcikgLT5cbiAgY2hlY2sgdXNlcixcbiAgICBpZDogTWF0Y2guT3B0aW9uYWwgU3RyaW5nXG4gICAgdXNlcm5hbWU6IE1hdGNoLk9wdGlvbmFsIFN0cmluZ1xuICAgIGVtYWlsOiBNYXRjaC5PcHRpb25hbCBTdHJpbmdcblxuICBpZiBfLmtleXModXNlcikubGVuZ3RoIGlzIG5vdCAxXG4gICAgdGhyb3cgbmV3IE1hdGNoLkVycm9yICdVc2VyIG11c3QgaGF2ZSBleGFjdGx5IG9uZSBpZGVudGlmaWVyIGZpZWxkJ1xuXG4gIHJldHVybiB0cnVlXG5cbiMjI1xuICBBIHBhc3N3b3JkIGNhbiBiZSBlaXRoZXIgaW4gcGxhaW4gdGV4dCBvciBoYXNoZWRcbiMjI1xucGFzc3dvcmRWYWxpZGF0b3IgPSBNYXRjaC5PbmVPZihTdHJpbmcsXG4gIGRpZ2VzdDogU3RyaW5nXG4gIGFsZ29yaXRobTogU3RyaW5nKVxuXG4jIyNcbiAgUmV0dXJuIGEgTW9uZ29EQiBxdWVyeSBzZWxlY3RvciBmb3IgZmluZGluZyB0aGUgZ2l2ZW4gdXNlclxuIyMjXG5nZXRVc2VyUXVlcnlTZWxlY3RvciA9ICh1c2VyKSAtPlxuICBpZiB1c2VyLmlkXG4gICAgcmV0dXJuIHsnX2lkJzogdXNlci5pZH1cbiAgZWxzZSBpZiB1c2VyLnVzZXJuYW1lXG4gICAgcmV0dXJuIHsndXNlcm5hbWUnOiB1c2VyLnVzZXJuYW1lfVxuICBlbHNlIGlmIHVzZXIuZW1haWxcbiAgICByZXR1cm4geydlbWFpbHMuYWRkcmVzcyc6IHVzZXIuZW1haWx9XG5cbiAgIyBXZSBzaG91bGRuJ3QgYmUgaGVyZSBpZiB0aGUgdXNlciBvYmplY3Qgd2FzIHByb3Blcmx5IHZhbGlkYXRlZFxuICB0aHJvdyBuZXcgRXJyb3IgJ0Nhbm5vdCBjcmVhdGUgc2VsZWN0b3IgZnJvbSBpbnZhbGlkIHVzZXInXG5cbiMjI1xuICBMb2cgYSB1c2VyIGluIHdpdGggdGhlaXIgcGFzc3dvcmRcbiMjI1xuQEF1dGgubG9naW5XaXRoUGFzc3dvcmQgPSAodXNlciwgcGFzc3dvcmQpIC0+XG4gIGlmIG5vdCB1c2VyIG9yIG5vdCBwYXNzd29yZFxuICAgIHRocm93IG5ldyBNZXRlb3IuRXJyb3IgNDAxLCAnVW5hdXRob3JpemVkJ1xuXG4gICMgVmFsaWRhdGUgdGhlIGxvZ2luIGlucHV0IHR5cGVzXG4gIGNoZWNrIHVzZXIsIHVzZXJWYWxpZGF0b3JcbiAgY2hlY2sgcGFzc3dvcmQsIHBhc3N3b3JkVmFsaWRhdG9yXG5cbiAgIyBSZXRyaWV2ZSB0aGUgdXNlciBmcm9tIHRoZSBkYXRhYmFzZVxuICBhdXRoZW50aWNhdGluZ1VzZXJTZWxlY3RvciA9IGdldFVzZXJRdWVyeVNlbGVjdG9yKHVzZXIpXG4gIGF1dGhlbnRpY2F0aW5nVXNlciA9IE1ldGVvci51c2Vycy5maW5kT25lKGF1dGhlbnRpY2F0aW5nVXNlclNlbGVjdG9yKVxuXG4gIGlmIG5vdCBhdXRoZW50aWNhdGluZ1VzZXJcbiAgICB0aHJvdyBuZXcgTWV0ZW9yLkVycm9yIDQwMSwgJ1VuYXV0aG9yaXplZCdcbiAgaWYgbm90IGF1dGhlbnRpY2F0aW5nVXNlci5zZXJ2aWNlcz8ucGFzc3dvcmRcbiAgICB0aHJvdyBuZXcgTWV0ZW9yLkVycm9yIDQwMSwgJ1VuYXV0aG9yaXplZCdcblxuICAjIEF1dGhlbnRpY2F0ZSB0aGUgdXNlcidzIHBhc3N3b3JkXG4gIHBhc3N3b3JkVmVyaWZpY2F0aW9uID0gQWNjb3VudHMuX2NoZWNrUGFzc3dvcmQgYXV0aGVudGljYXRpbmdVc2VyLCBwYXNzd29yZFxuICBpZiBwYXNzd29yZFZlcmlmaWNhdGlvbi5lcnJvclxuICAgIHRocm93IG5ldyBNZXRlb3IuRXJyb3IgNDAxLCAnVW5hdXRob3JpemVkJ1xuXG4gICMgQWRkIGEgbmV3IGF1dGggdG9rZW4gdG8gdGhlIHVzZXIncyBhY2NvdW50XG4gIGF1dGhUb2tlbiA9IEFjY291bnRzLl9nZW5lcmF0ZVN0YW1wZWRMb2dpblRva2VuKClcbiAgaGFzaGVkVG9rZW4gPSBBY2NvdW50cy5faGFzaExvZ2luVG9rZW4gYXV0aFRva2VuLnRva2VuXG4gIEFjY291bnRzLl9pbnNlcnRIYXNoZWRMb2dpblRva2VuIGF1dGhlbnRpY2F0aW5nVXNlci5faWQsIHtoYXNoZWRUb2tlbn1cblxuICByZXR1cm4ge2F1dGhUb2tlbjogYXV0aFRva2VuLnRva2VuLCB1c2VySWQ6IGF1dGhlbnRpY2F0aW5nVXNlci5faWR9XG4iLCJjbGFzcyBzaGFyZS5Sb3V0ZVxuXG4gIGNvbnN0cnVjdG9yOiAoQGFwaSwgQHBhdGgsIEBvcHRpb25zLCBAZW5kcG9pbnRzKSAtPlxuICAgICMgQ2hlY2sgaWYgb3B0aW9ucyB3ZXJlIHByb3ZpZGVkXG4gICAgaWYgbm90IEBlbmRwb2ludHNcbiAgICAgIEBlbmRwb2ludHMgPSBAb3B0aW9uc1xuICAgICAgQG9wdGlvbnMgPSB7fVxuXG5cbiAgYWRkVG9BcGk6IGRvIC0+XG4gICAgYXZhaWxhYmxlTWV0aG9kcyA9IFsnZ2V0JywgJ3Bvc3QnLCAncHV0JywgJ3BhdGNoJywgJ2RlbGV0ZScsICdvcHRpb25zJ11cblxuICAgIHJldHVybiAtPlxuICAgICAgc2VsZiA9IHRoaXNcblxuICAgICAgIyBUaHJvdyBhbiBlcnJvciBpZiBhIHJvdXRlIGhhcyBhbHJlYWR5IGJlZW4gYWRkZWQgYXQgdGhpcyBwYXRoXG4gICAgICAjIFRPRE86IENoZWNrIGZvciBjb2xsaXNpb25zIHdpdGggcGF0aHMgdGhhdCBmb2xsb3cgc2FtZSBwYXR0ZXJuIHdpdGggZGlmZmVyZW50IHBhcmFtZXRlciBuYW1lc1xuICAgICAgaWYgXy5jb250YWlucyBAYXBpLl9jb25maWcucGF0aHMsIEBwYXRoXG4gICAgICAgIHRocm93IG5ldyBFcnJvciBcIkNhbm5vdCBhZGQgYSByb3V0ZSBhdCBhbiBleGlzdGluZyBwYXRoOiAje0BwYXRofVwiXG5cbiAgICAgICMgT3ZlcnJpZGUgdGhlIGRlZmF1bHQgT1BUSU9OUyBlbmRwb2ludCB3aXRoIG91ciBvd25cbiAgICAgIEBlbmRwb2ludHMgPSBfLmV4dGVuZCBvcHRpb25zOiBAYXBpLl9jb25maWcuZGVmYXVsdE9wdGlvbnNFbmRwb2ludCwgQGVuZHBvaW50c1xuXG4gICAgICAjIENvbmZpZ3VyZSBlYWNoIGVuZHBvaW50IG9uIHRoaXMgcm91dGVcbiAgICAgIEBfcmVzb2x2ZUVuZHBvaW50cygpXG4gICAgICBAX2NvbmZpZ3VyZUVuZHBvaW50cygpXG5cbiAgICAgICMgQWRkIHRvIG91ciBsaXN0IG9mIGV4aXN0aW5nIHBhdGhzXG4gICAgICBAYXBpLl9jb25maWcucGF0aHMucHVzaCBAcGF0aFxuXG4gICAgICBhbGxvd2VkTWV0aG9kcyA9IF8uZmlsdGVyIGF2YWlsYWJsZU1ldGhvZHMsIChtZXRob2QpIC0+XG4gICAgICAgIF8uY29udGFpbnMoXy5rZXlzKHNlbGYuZW5kcG9pbnRzKSwgbWV0aG9kKVxuICAgICAgcmVqZWN0ZWRNZXRob2RzID0gXy5yZWplY3QgYXZhaWxhYmxlTWV0aG9kcywgKG1ldGhvZCkgLT5cbiAgICAgICAgXy5jb250YWlucyhfLmtleXMoc2VsZi5lbmRwb2ludHMpLCBtZXRob2QpXG5cbiAgICAgICMgU2V0dXAgZW5kcG9pbnRzIG9uIHJvdXRlXG4gICAgICBmdWxsUGF0aCA9IEBhcGkuX2NvbmZpZy5hcGlQYXRoICsgQHBhdGhcbiAgICAgIF8uZWFjaCBhbGxvd2VkTWV0aG9kcywgKG1ldGhvZCkgLT5cbiAgICAgICAgZW5kcG9pbnQgPSBzZWxmLmVuZHBvaW50c1ttZXRob2RdXG4gICAgICAgIEpzb25Sb3V0ZXMuYWRkIG1ldGhvZCwgZnVsbFBhdGgsIChyZXEsIHJlcykgLT5cbiAgICAgICAgICAjIEFkZCBmdW5jdGlvbiB0byBlbmRwb2ludCBjb250ZXh0IGZvciBpbmRpY2F0aW5nIGEgcmVzcG9uc2UgaGFzIGJlZW4gaW5pdGlhdGVkIG1hbnVhbGx5XG4gICAgICAgICAgcmVzcG9uc2VJbml0aWF0ZWQgPSBmYWxzZVxuICAgICAgICAgIGRvbmVGdW5jID0gLT5cbiAgICAgICAgICAgIHJlc3BvbnNlSW5pdGlhdGVkID0gdHJ1ZVxuXG4gICAgICAgICAgZW5kcG9pbnRDb250ZXh0ID1cbiAgICAgICAgICAgIHVybFBhcmFtczogcmVxLnBhcmFtc1xuICAgICAgICAgICAgcXVlcnlQYXJhbXM6IHJlcS5xdWVyeVxuICAgICAgICAgICAgYm9keVBhcmFtczogcmVxLmJvZHlcbiAgICAgICAgICAgIHJlcXVlc3Q6IHJlcVxuICAgICAgICAgICAgcmVzcG9uc2U6IHJlc1xuICAgICAgICAgICAgZG9uZTogZG9uZUZ1bmNcbiAgICAgICAgICAjIEFkZCBlbmRwb2ludCBjb25maWcgb3B0aW9ucyB0byBjb250ZXh0XG4gICAgICAgICAgXy5leHRlbmQgZW5kcG9pbnRDb250ZXh0LCBlbmRwb2ludFxuXG4gICAgICAgICAgIyBSdW4gdGhlIHJlcXVlc3RlZCBlbmRwb2ludFxuICAgICAgICAgIHJlc3BvbnNlRGF0YSA9IG51bGxcbiAgICAgICAgICB0cnlcbiAgICAgICAgICAgIHJlc3BvbnNlRGF0YSA9IHNlbGYuX2NhbGxFbmRwb2ludCBlbmRwb2ludENvbnRleHQsIGVuZHBvaW50XG4gICAgICAgICAgY2F0Y2ggZXJyb3JcbiAgICAgICAgICAgICMgRG8gZXhhY3RseSB3aGF0IElyb24gUm91dGVyIHdvdWxkIGhhdmUgZG9uZSwgdG8gYXZvaWQgY2hhbmdpbmcgdGhlIEFQSVxuICAgICAgICAgICAgaXJvblJvdXRlclNlbmRFcnJvclRvUmVzcG9uc2UoZXJyb3IsIHJlcSwgcmVzKTtcbiAgICAgICAgICAgIHJldHVyblxuXG4gICAgICAgICAgaWYgcmVzcG9uc2VJbml0aWF0ZWRcbiAgICAgICAgICAgICMgRW5zdXJlIHRoZSByZXNwb25zZSBpcyBwcm9wZXJseSBjb21wbGV0ZWRcbiAgICAgICAgICAgIHJlcy5lbmQoKVxuICAgICAgICAgICAgcmV0dXJuXG4gICAgICAgICAgZWxzZVxuICAgICAgICAgICAgaWYgcmVzLmhlYWRlcnNTZW50XG4gICAgICAgICAgICAgIHRocm93IG5ldyBFcnJvciBcIk11c3QgY2FsbCB0aGlzLmRvbmUoKSBhZnRlciBoYW5kbGluZyBlbmRwb2ludCByZXNwb25zZSBtYW51YWxseTogI3ttZXRob2R9ICN7ZnVsbFBhdGh9XCJcbiAgICAgICAgICAgIGVsc2UgaWYgcmVzcG9uc2VEYXRhIGlzIG51bGwgb3IgcmVzcG9uc2VEYXRhIGlzIHVuZGVmaW5lZFxuICAgICAgICAgICAgICB0aHJvdyBuZXcgRXJyb3IgXCJDYW5ub3QgcmV0dXJuIG51bGwgb3IgdW5kZWZpbmVkIGZyb20gYW4gZW5kcG9pbnQ6ICN7bWV0aG9kfSAje2Z1bGxQYXRofVwiXG5cbiAgICAgICAgICAjIEdlbmVyYXRlIGFuZCByZXR1cm4gdGhlIGh0dHAgcmVzcG9uc2UsIGhhbmRsaW5nIHRoZSBkaWZmZXJlbnQgZW5kcG9pbnQgcmVzcG9uc2UgdHlwZXNcbiAgICAgICAgICBpZiByZXNwb25zZURhdGEuYm9keSBhbmQgKHJlc3BvbnNlRGF0YS5zdGF0dXNDb2RlIG9yIHJlc3BvbnNlRGF0YS5oZWFkZXJzKVxuICAgICAgICAgICAgc2VsZi5fcmVzcG9uZCByZXMsIHJlc3BvbnNlRGF0YS5ib2R5LCByZXNwb25zZURhdGEuc3RhdHVzQ29kZSwgcmVzcG9uc2VEYXRhLmhlYWRlcnNcbiAgICAgICAgICBlbHNlXG4gICAgICAgICAgICBzZWxmLl9yZXNwb25kIHJlcywgcmVzcG9uc2VEYXRhXG5cbiAgICAgIF8uZWFjaCByZWplY3RlZE1ldGhvZHMsIChtZXRob2QpIC0+XG4gICAgICAgIEpzb25Sb3V0ZXMuYWRkIG1ldGhvZCwgZnVsbFBhdGgsIChyZXEsIHJlcykgLT5cbiAgICAgICAgICByZXNwb25zZURhdGEgPSBzdGF0dXM6ICdlcnJvcicsIG1lc3NhZ2U6ICdBUEkgZW5kcG9pbnQgZG9lcyBub3QgZXhpc3QnXG4gICAgICAgICAgaGVhZGVycyA9ICdBbGxvdyc6IGFsbG93ZWRNZXRob2RzLmpvaW4oJywgJykudG9VcHBlckNhc2UoKVxuICAgICAgICAgIHNlbGYuX3Jlc3BvbmQgcmVzLCByZXNwb25zZURhdGEsIDQwNSwgaGVhZGVyc1xuXG5cbiAgIyMjXG4gICAgQ29udmVydCBhbGwgZW5kcG9pbnRzIG9uIHRoZSBnaXZlbiByb3V0ZSBpbnRvIG91ciBleHBlY3RlZCBlbmRwb2ludCBvYmplY3QgaWYgaXQgaXMgYSBiYXJlXG4gICAgZnVuY3Rpb25cblxuICAgIEBwYXJhbSB7Um91dGV9IHJvdXRlIFRoZSByb3V0ZSB0aGUgZW5kcG9pbnRzIGJlbG9uZyB0b1xuICAjIyNcbiAgX3Jlc29sdmVFbmRwb2ludHM6IC0+XG4gICAgXy5lYWNoIEBlbmRwb2ludHMsIChlbmRwb2ludCwgbWV0aG9kLCBlbmRwb2ludHMpIC0+XG4gICAgICBpZiBfLmlzRnVuY3Rpb24oZW5kcG9pbnQpXG4gICAgICAgIGVuZHBvaW50c1ttZXRob2RdID0ge2FjdGlvbjogZW5kcG9pbnR9XG4gICAgcmV0dXJuXG5cblxuICAjIyNcbiAgICBDb25maWd1cmUgdGhlIGF1dGhlbnRpY2F0aW9uIGFuZCByb2xlIHJlcXVpcmVtZW50IG9uIGFsbCBlbmRwb2ludHMgKGV4Y2VwdCBPUFRJT05TLCB3aGljaCBtdXN0XG4gICAgYmUgY29uZmlndXJlZCBkaXJlY3RseSBvbiB0aGUgZW5kcG9pbnQpXG5cbiAgICBBdXRoZW50aWNhdGlvbiBjYW4gYmUgcmVxdWlyZWQgb24gYW4gZW50aXJlIHJvdXRlIG9yIGluZGl2aWR1YWwgZW5kcG9pbnRzLiBJZiByZXF1aXJlZCBvbiBhblxuICAgIGVudGlyZSByb3V0ZSwgdGhhdCBzZXJ2ZXMgYXMgdGhlIGRlZmF1bHQuIElmIHJlcXVpcmVkIGluIGFueSBpbmRpdmlkdWFsIGVuZHBvaW50cywgdGhhdCB3aWxsXG4gICAgb3ZlcnJpZGUgdGhlIGRlZmF1bHQuXG5cbiAgICBBZnRlciB0aGUgZW5kcG9pbnQgaXMgY29uZmlndXJlZCwgYWxsIGF1dGhlbnRpY2F0aW9uIGFuZCByb2xlIHJlcXVpcmVtZW50cyBvZiBhbiBlbmRwb2ludCBjYW4gYmVcbiAgICBhY2Nlc3NlZCBhdCA8Y29kZT5lbmRwb2ludC5hdXRoUmVxdWlyZWQ8L2NvZGU+IGFuZCA8Y29kZT5lbmRwb2ludC5yb2xlUmVxdWlyZWQ8L2NvZGU+LFxuICAgIHJlc3BlY3RpdmVseS5cblxuICAgIEBwYXJhbSB7Um91dGV9IHJvdXRlIFRoZSByb3V0ZSB0aGUgZW5kcG9pbnRzIGJlbG9uZyB0b1xuICAgIEBwYXJhbSB7RW5kcG9pbnR9IGVuZHBvaW50IFRoZSBlbmRwb2ludCB0byBjb25maWd1cmVcbiAgIyMjXG4gIF9jb25maWd1cmVFbmRwb2ludHM6IC0+XG4gICAgXy5lYWNoIEBlbmRwb2ludHMsIChlbmRwb2ludCwgbWV0aG9kKSAtPlxuICAgICAgaWYgbWV0aG9kIGlzbnQgJ29wdGlvbnMnXG4gICAgICAgICMgQ29uZmlndXJlIGFjY2VwdGFibGUgcm9sZXNcbiAgICAgICAgaWYgbm90IEBvcHRpb25zPy5yb2xlUmVxdWlyZWRcbiAgICAgICAgICBAb3B0aW9ucy5yb2xlUmVxdWlyZWQgPSBbXVxuICAgICAgICBpZiBub3QgZW5kcG9pbnQucm9sZVJlcXVpcmVkXG4gICAgICAgICAgZW5kcG9pbnQucm9sZVJlcXVpcmVkID0gW11cbiAgICAgICAgZW5kcG9pbnQucm9sZVJlcXVpcmVkID0gXy51bmlvbiBlbmRwb2ludC5yb2xlUmVxdWlyZWQsIEBvcHRpb25zLnJvbGVSZXF1aXJlZFxuICAgICAgICAjIE1ha2UgaXQgZWFzaWVyIHRvIGNoZWNrIGlmIG5vIHJvbGVzIGFyZSByZXF1aXJlZFxuICAgICAgICBpZiBfLmlzRW1wdHkgZW5kcG9pbnQucm9sZVJlcXVpcmVkXG4gICAgICAgICAgZW5kcG9pbnQucm9sZVJlcXVpcmVkID0gZmFsc2VcblxuICAgICAgICAjIENvbmZpZ3VyZSBhdXRoIHJlcXVpcmVtZW50XG4gICAgICAgIGlmIGVuZHBvaW50LmF1dGhSZXF1aXJlZCBpcyB1bmRlZmluZWRcbiAgICAgICAgICBpZiBAb3B0aW9ucz8uYXV0aFJlcXVpcmVkIG9yIGVuZHBvaW50LnJvbGVSZXF1aXJlZFxuICAgICAgICAgICAgZW5kcG9pbnQuYXV0aFJlcXVpcmVkID0gdHJ1ZVxuICAgICAgICAgIGVsc2VcbiAgICAgICAgICAgIGVuZHBvaW50LmF1dGhSZXF1aXJlZCA9IGZhbHNlXG4gICAgICAgIHJldHVyblxuICAgICwgdGhpc1xuICAgIHJldHVyblxuXG5cbiAgIyMjXG4gICAgQXV0aGVudGljYXRlIGFuIGVuZHBvaW50IGlmIHJlcXVpcmVkLCBhbmQgcmV0dXJuIHRoZSByZXN1bHQgb2YgY2FsbGluZyBpdFxuXG4gICAgQHJldHVybnMgVGhlIGVuZHBvaW50IHJlc3BvbnNlIG9yIGEgNDAxIGlmIGF1dGhlbnRpY2F0aW9uIGZhaWxzXG4gICMjI1xuICBfY2FsbEVuZHBvaW50OiAoZW5kcG9pbnRDb250ZXh0LCBlbmRwb2ludCkgLT5cbiAgICAjIENhbGwgdGhlIGVuZHBvaW50IGlmIGF1dGhlbnRpY2F0aW9uIGRvZXNuJ3QgZmFpbFxuICAgIGF1dGggPSBAX2F1dGhBY2NlcHRlZCBlbmRwb2ludENvbnRleHQsIGVuZHBvaW50XG4gICAgaWYgYXV0aC5zdWNjZXNzXG4gICAgICBpZiBAX3JvbGVBY2NlcHRlZCBlbmRwb2ludENvbnRleHQsIGVuZHBvaW50XG4gICAgICAgIHJldHVybiBlbmRwb2ludC5hY3Rpb24uY2FsbCBlbmRwb2ludENvbnRleHRcbiAgICAgIGVsc2UgcmV0dXJuIHtcbiAgICAgICAgc3RhdHVzQ29kZTogNDAzXG4gICAgICAgIGJvZHk6IHtzdGF0dXM6ICdlcnJvcicsIG1lc3NhZ2U6ICdZb3UgZG8gbm90IGhhdmUgcGVybWlzc2lvbiB0byBkbyB0aGlzLid9XG4gICAgICB9XG4gICAgZWxzZSAjIEF1dGggZmFpbGVkXG4gICAgICBpZiBhdXRoLmRhdGEgdGhlbiByZXR1cm4gYXV0aC5kYXRhXG4gICAgICBlbHNlIHJldHVybiB7XG4gICAgICAgIHN0YXR1c0NvZGU6IDQwMVxuICAgICAgICBib2R5OiB7c3RhdHVzOiAnZXJyb3InLCBtZXNzYWdlOiAnWW91IG11c3QgYmUgbG9nZ2VkIGluIHRvIGRvIHRoaXMuJ31cbiAgICAgIH1cblxuXG4gICMjI1xuICAgIEF1dGhlbnRpY2F0ZSB0aGUgZ2l2ZW4gZW5kcG9pbnQgaWYgcmVxdWlyZWRcblxuICAgIE9uY2UgaXQncyBnbG9iYWxseSBjb25maWd1cmVkIGluIHRoZSBBUEksIGF1dGhlbnRpY2F0aW9uIGNhbiBiZSByZXF1aXJlZCBvbiBhbiBlbnRpcmUgcm91dGUgb3JcbiAgICBpbmRpdmlkdWFsIGVuZHBvaW50cy4gSWYgcmVxdWlyZWQgb24gYW4gZW50aXJlIGVuZHBvaW50LCB0aGF0IHNlcnZlcyBhcyB0aGUgZGVmYXVsdC4gSWYgcmVxdWlyZWRcbiAgICBpbiBhbnkgaW5kaXZpZHVhbCBlbmRwb2ludHMsIHRoYXQgd2lsbCBvdmVycmlkZSB0aGUgZGVmYXVsdC5cblxuICAgIEByZXR1cm5zIEFuIG9iamVjdCBvZiB0aGUgZm9sbG93aW5nIGZvcm1hdDpcblxuICAgICAgICB7XG4gICAgICAgICAgc3VjY2VzczogQm9vbGVhblxuICAgICAgICAgIGRhdGE6IFN0cmluZyBvciBPYmplY3RcbiAgICAgICAgfVxuXG4gICAgICB3aGVyZSBgc3VjY2Vzc2AgaXMgYHRydWVgIGlmIGFsbCByZXF1aXJlZCBhdXRoZW50aWNhdGlvbiBjaGVja3MgcGFzcyBhbmQgdGhlIG9wdGlvbmFsIGBkYXRhYFxuICAgICAgd2lsbCBjb250YWluIHRoZSBhdXRoIGRhdGEgd2hlbiBzdWNjZXNzZnVsIGFuZCBhbiBvcHRpb25hbCBlcnJvciByZXNwb25zZSB3aGVuIGF1dGggZmFpbHMuXG4gICMjI1xuICBfYXV0aEFjY2VwdGVkOiAoZW5kcG9pbnRDb250ZXh0LCBlbmRwb2ludCkgLT5cbiAgICBpZiBlbmRwb2ludC5hdXRoUmVxdWlyZWRcbiAgICAgIHJldHVybiBAX2F1dGhlbnRpY2F0ZSBlbmRwb2ludENvbnRleHRcbiAgICBlbHNlIHJldHVybiB7IHN1Y2Nlc3M6IHRydWUgfVxuXG5cbiAgIyMjXG4gICAgVmVyaWZ5IHRoZSByZXF1ZXN0IGlzIGJlaW5nIG1hZGUgYnkgYW4gYWN0aXZlbHkgbG9nZ2VkIGluIHVzZXJcblxuICAgIElmIHZlcmlmaWVkLCBhdHRhY2ggdGhlIGF1dGhlbnRpY2F0ZWQgdXNlciB0byB0aGUgY29udGV4dC5cblxuICAgIEByZXR1cm5zIEFuIG9iamVjdCBvZiB0aGUgZm9sbG93aW5nIGZvcm1hdDpcblxuICAgICAgICB7XG4gICAgICAgICAgc3VjY2VzczogQm9vbGVhblxuICAgICAgICAgIGRhdGE6IFN0cmluZyBvciBPYmplY3RcbiAgICAgICAgfVxuXG4gICAgICB3aGVyZSBgc3VjY2Vzc2AgaXMgYHRydWVgIGlmIGFsbCByZXF1aXJlZCBhdXRoZW50aWNhdGlvbiBjaGVja3MgcGFzcyBhbmQgdGhlIG9wdGlvbmFsIGBkYXRhYFxuICAgICAgd2lsbCBjb250YWluIHRoZSBhdXRoIGRhdGEgd2hlbiBzdWNjZXNzZnVsIGFuZCBhbiBvcHRpb25hbCBlcnJvciByZXNwb25zZSB3aGVuIGF1dGggZmFpbHMuXG4gICMjI1xuICBfYXV0aGVudGljYXRlOiAoZW5kcG9pbnRDb250ZXh0KSAtPlxuICAgICMgR2V0IGF1dGggaW5mb1xuICAgIGF1dGggPSBAYXBpLl9jb25maWcuYXV0aC51c2VyLmNhbGwoZW5kcG9pbnRDb250ZXh0KVxuXG4gICAgaWYgbm90IGF1dGggdGhlbiByZXR1cm4geyBzdWNjZXNzOiBmYWxzZSB9XG5cbiAgICAjIEdldCB0aGUgdXNlciBmcm9tIHRoZSBkYXRhYmFzZVxuICAgIGlmIGF1dGgudXNlcklkIGFuZCBhdXRoLnRva2VuIGFuZCBub3QgYXV0aC51c2VyXG4gICAgICB1c2VyU2VsZWN0b3IgPSB7fVxuICAgICAgdXNlclNlbGVjdG9yLl9pZCA9IGF1dGgudXNlcklkXG4gICAgICB1c2VyU2VsZWN0b3JbQGFwaS5fY29uZmlnLmF1dGgudG9rZW5dID0gYXV0aC50b2tlblxuICAgICAgYXV0aC51c2VyID0gTWV0ZW9yLnVzZXJzLmZpbmRPbmUgdXNlclNlbGVjdG9yXG5cbiAgICBpZiBhdXRoLmVycm9yIHRoZW4gcmV0dXJuIHsgc3VjY2VzczogZmFsc2UsIGRhdGE6IGF1dGguZXJyb3IgfVxuXG4gICAgIyBBdHRhY2ggdGhlIHVzZXIgYW5kIHRoZWlyIElEIHRvIHRoZSBjb250ZXh0IGlmIHRoZSBhdXRoZW50aWNhdGlvbiB3YXMgc3VjY2Vzc2Z1bFxuICAgIGlmIGF1dGgudXNlclxuICAgICAgZW5kcG9pbnRDb250ZXh0LnVzZXIgPSBhdXRoLnVzZXJcbiAgICAgIGVuZHBvaW50Q29udGV4dC51c2VySWQgPSBhdXRoLnVzZXIuX2lkXG4gICAgICByZXR1cm4geyBzdWNjZXNzOiB0cnVlICwgZGF0YTogYXV0aCB9XG4gICAgZWxzZSByZXR1cm4geyBzdWNjZXNzOiBmYWxzZSB9XG5cblxuICAjIyNcbiAgICBBdXRoZW50aWNhdGUgdGhlIHVzZXIgcm9sZSBpZiByZXF1aXJlZFxuXG4gICAgTXVzdCBiZSBjYWxsZWQgYWZ0ZXIgX2F1dGhBY2NlcHRlZCgpLlxuXG4gICAgQHJldHVybnMgVHJ1ZSBpZiB0aGUgYXV0aGVudGljYXRlZCB1c2VyIGJlbG9uZ3MgdG8gPGk+YW55PC9pPiBvZiB0aGUgYWNjZXB0YWJsZSByb2xlcyBvbiB0aGVcbiAgICAgICAgICAgICBlbmRwb2ludFxuICAjIyNcbiAgX3JvbGVBY2NlcHRlZDogKGVuZHBvaW50Q29udGV4dCwgZW5kcG9pbnQpIC0+XG4gICAgaWYgZW5kcG9pbnQucm9sZVJlcXVpcmVkXG4gICAgICBpZiBfLmlzRW1wdHkgXy5pbnRlcnNlY3Rpb24oZW5kcG9pbnQucm9sZVJlcXVpcmVkLCBlbmRwb2ludENvbnRleHQudXNlci5yb2xlcylcbiAgICAgICAgcmV0dXJuIGZhbHNlXG4gICAgdHJ1ZVxuXG5cbiAgIyMjXG4gICAgUmVzcG9uZCB0byBhbiBIVFRQIHJlcXVlc3RcbiAgIyMjXG4gIF9yZXNwb25kOiAocmVzcG9uc2UsIGJvZHksIHN0YXR1c0NvZGU9MjAwLCBoZWFkZXJzPXt9KSAtPlxuICAgICMgT3ZlcnJpZGUgYW55IGRlZmF1bHQgaGVhZGVycyB0aGF0IGhhdmUgYmVlbiBwcm92aWRlZCAoa2V5cyBhcmUgbm9ybWFsaXplZCB0byBiZSBjYXNlIGluc2Vuc2l0aXZlKVxuICAgICMgVE9ETzogQ29uc2lkZXIgb25seSBsb3dlcmNhc2luZyB0aGUgaGVhZGVyIGtleXMgd2UgbmVlZCBub3JtYWxpemVkLCBsaWtlIENvbnRlbnQtVHlwZVxuICAgIGRlZmF1bHRIZWFkZXJzID0gQF9sb3dlckNhc2VLZXlzIEBhcGkuX2NvbmZpZy5kZWZhdWx0SGVhZGVyc1xuICAgIGhlYWRlcnMgPSBAX2xvd2VyQ2FzZUtleXMgaGVhZGVyc1xuICAgIGhlYWRlcnMgPSBfLmV4dGVuZCBkZWZhdWx0SGVhZGVycywgaGVhZGVyc1xuXG4gICAgIyBQcmVwYXJlIEpTT04gYm9keSBmb3IgcmVzcG9uc2Ugd2hlbiBDb250ZW50LVR5cGUgaW5kaWNhdGVzIEpTT04gdHlwZVxuICAgIGlmIGhlYWRlcnNbJ2NvbnRlbnQtdHlwZSddLm1hdGNoKC9qc29ufGphdmFzY3JpcHQvKSBpc250IG51bGxcbiAgICAgIGlmIEBhcGkuX2NvbmZpZy5wcmV0dHlKc29uXG4gICAgICAgIGJvZHkgPSBKU09OLnN0cmluZ2lmeSBib2R5LCB1bmRlZmluZWQsIDJcbiAgICAgIGVsc2VcbiAgICAgICAgYm9keSA9IEpTT04uc3RyaW5naWZ5IGJvZHlcblxuICAgICMgU2VuZCByZXNwb25zZVxuICAgIHNlbmRSZXNwb25zZSA9IC0+XG4gICAgICByZXNwb25zZS53cml0ZUhlYWQgc3RhdHVzQ29kZSwgaGVhZGVyc1xuICAgICAgcmVzcG9uc2Uud3JpdGUgYm9keVxuICAgICAgcmVzcG9uc2UuZW5kKClcbiAgICBpZiBzdGF0dXNDb2RlIGluIFs0MDEsIDQwM11cbiAgICAgICMgSGFja2VycyBjYW4gbWVhc3VyZSB0aGUgcmVzcG9uc2UgdGltZSB0byBkZXRlcm1pbmUgdGhpbmdzIGxpa2Ugd2hldGhlciB0aGUgNDAxIHJlc3BvbnNlIHdhcyBcbiAgICAgICMgY2F1c2VkIGJ5IGJhZCB1c2VyIGlkIHZzIGJhZCBwYXNzd29yZC5cbiAgICAgICMgSW4gZG9pbmcgc28sIHRoZXkgY2FuIGZpcnN0IHNjYW4gZm9yIHZhbGlkIHVzZXIgaWRzIHJlZ2FyZGxlc3Mgb2YgdmFsaWQgcGFzc3dvcmRzLlxuICAgICAgIyBEZWxheSBieSBhIHJhbmRvbSBhbW91bnQgdG8gcmVkdWNlIHRoZSBhYmlsaXR5IGZvciBhIGhhY2tlciB0byBkZXRlcm1pbmUgdGhlIHJlc3BvbnNlIHRpbWUuXG4gICAgICAjIFNlZSBodHRwczovL3d3dy5vd2FzcC5vcmcvaW5kZXgucGhwL0Jsb2NraW5nX0JydXRlX0ZvcmNlX0F0dGFja3MjRmluZGluZ19PdGhlcl9Db3VudGVybWVhc3VyZXNcbiAgICAgICMgU2VlIGh0dHBzOi8vZW4ud2lraXBlZGlhLm9yZy93aWtpL1RpbWluZ19hdHRhY2tcbiAgICAgIG1pbmltdW1EZWxheUluTWlsbGlzZWNvbmRzID0gNTAwXG4gICAgICByYW5kb21NdWx0aXBsaWVyQmV0d2Vlbk9uZUFuZFR3byA9IDEgKyBNYXRoLnJhbmRvbSgpXG4gICAgICBkZWxheUluTWlsbGlzZWNvbmRzID0gbWluaW11bURlbGF5SW5NaWxsaXNlY29uZHMgKiByYW5kb21NdWx0aXBsaWVyQmV0d2Vlbk9uZUFuZFR3b1xuICAgICAgTWV0ZW9yLnNldFRpbWVvdXQgc2VuZFJlc3BvbnNlLCBkZWxheUluTWlsbGlzZWNvbmRzXG4gICAgZWxzZVxuICAgICAgc2VuZFJlc3BvbnNlKClcblxuICAjIyNcbiAgICBSZXR1cm4gdGhlIG9iamVjdCB3aXRoIGFsbCBvZiB0aGUga2V5cyBjb252ZXJ0ZWQgdG8gbG93ZXJjYXNlXG4gICMjI1xuICBfbG93ZXJDYXNlS2V5czogKG9iamVjdCkgLT5cbiAgICBfLmNoYWluIG9iamVjdFxuICAgIC5wYWlycygpXG4gICAgLm1hcCAoYXR0cikgLT5cbiAgICAgIFthdHRyWzBdLnRvTG93ZXJDYXNlKCksIGF0dHJbMV1dXG4gICAgLm9iamVjdCgpXG4gICAgLnZhbHVlKClcbiIsImNsYXNzIEBSZXN0aXZ1c1xuXG4gIGNvbnN0cnVjdG9yOiAob3B0aW9ucykgLT5cbiAgICBAX3JvdXRlcyA9IFtdXG4gICAgQF9jb25maWcgPVxuICAgICAgcGF0aHM6IFtdXG4gICAgICB1c2VEZWZhdWx0QXV0aDogZmFsc2VcbiAgICAgIGFwaVBhdGg6ICdhcGkvJ1xuICAgICAgdmVyc2lvbjogbnVsbFxuICAgICAgcHJldHR5SnNvbjogZmFsc2VcbiAgICAgIGF1dGg6XG4gICAgICAgIHRva2VuOiAnc2VydmljZXMucmVzdW1lLmxvZ2luVG9rZW5zLmhhc2hlZFRva2VuJ1xuICAgICAgICB1c2VyOiAtPlxuICAgICAgICAgIGlmIEByZXF1ZXN0LmhlYWRlcnNbJ3gtYXV0aC10b2tlbiddXG4gICAgICAgICAgICB0b2tlbiA9IEFjY291bnRzLl9oYXNoTG9naW5Ub2tlbiBAcmVxdWVzdC5oZWFkZXJzWyd4LWF1dGgtdG9rZW4nXVxuICAgICAgICAgIHVzZXJJZDogQHJlcXVlc3QuaGVhZGVyc1sneC11c2VyLWlkJ11cbiAgICAgICAgICB0b2tlbjogdG9rZW5cbiAgICAgIGRlZmF1bHRIZWFkZXJzOlxuICAgICAgICAnQ29udGVudC1UeXBlJzogJ2FwcGxpY2F0aW9uL2pzb24nXG4gICAgICBlbmFibGVDb3JzOiB0cnVlXG5cbiAgICAjIENvbmZpZ3VyZSBBUEkgd2l0aCB0aGUgZ2l2ZW4gb3B0aW9uc1xuICAgIF8uZXh0ZW5kIEBfY29uZmlnLCBvcHRpb25zXG5cbiAgICBpZiBAX2NvbmZpZy5lbmFibGVDb3JzXG4gICAgICBjb3JzSGVhZGVycyA9XG4gICAgICAgICdBY2Nlc3MtQ29udHJvbC1BbGxvdy1PcmlnaW4nOiAnKidcbiAgICAgICAgJ0FjY2Vzcy1Db250cm9sLUFsbG93LUhlYWRlcnMnOiAnT3JpZ2luLCBYLVJlcXVlc3RlZC1XaXRoLCBDb250ZW50LVR5cGUsIEFjY2VwdCdcblxuICAgICAgaWYgQF9jb25maWcudXNlRGVmYXVsdEF1dGhcbiAgICAgICAgY29yc0hlYWRlcnNbJ0FjY2Vzcy1Db250cm9sLUFsbG93LUhlYWRlcnMnXSArPSAnLCBYLVVzZXItSWQsIFgtQXV0aC1Ub2tlbidcblxuICAgICAgIyBTZXQgZGVmYXVsdCBoZWFkZXIgdG8gZW5hYmxlIENPUlMgaWYgY29uZmlndXJlZFxuICAgICAgXy5leHRlbmQgQF9jb25maWcuZGVmYXVsdEhlYWRlcnMsIGNvcnNIZWFkZXJzXG5cbiAgICAgIGlmIG5vdCBAX2NvbmZpZy5kZWZhdWx0T3B0aW9uc0VuZHBvaW50XG4gICAgICAgIEBfY29uZmlnLmRlZmF1bHRPcHRpb25zRW5kcG9pbnQgPSAtPlxuICAgICAgICAgIEByZXNwb25zZS53cml0ZUhlYWQgMjAwLCBjb3JzSGVhZGVyc1xuICAgICAgICAgIEBkb25lKClcblxuICAgICMgTm9ybWFsaXplIHRoZSBBUEkgcGF0aFxuICAgIGlmIEBfY29uZmlnLmFwaVBhdGhbMF0gaXMgJy8nXG4gICAgICBAX2NvbmZpZy5hcGlQYXRoID0gQF9jb25maWcuYXBpUGF0aC5zbGljZSAxXG4gICAgaWYgXy5sYXN0KEBfY29uZmlnLmFwaVBhdGgpIGlzbnQgJy8nXG4gICAgICBAX2NvbmZpZy5hcGlQYXRoID0gQF9jb25maWcuYXBpUGF0aCArICcvJ1xuXG4gICAgIyBVUkwgcGF0aCB2ZXJzaW9uaW5nIGlzIHRoZSBvbmx5IHR5cGUgb2YgQVBJIHZlcnNpb25pbmcgY3VycmVudGx5IGF2YWlsYWJsZSwgc28gaWYgYSB2ZXJzaW9uIGlzXG4gICAgIyBwcm92aWRlZCwgYXBwZW5kIGl0IHRvIHRoZSBiYXNlIHBhdGggb2YgdGhlIEFQSVxuICAgIGlmIEBfY29uZmlnLnZlcnNpb25cbiAgICAgIEBfY29uZmlnLmFwaVBhdGggKz0gQF9jb25maWcudmVyc2lvbiArICcvJ1xuXG4gICAgIyBBZGQgZGVmYXVsdCBsb2dpbiBhbmQgbG9nb3V0IGVuZHBvaW50cyBpZiBhdXRoIGlzIGNvbmZpZ3VyZWRcbiAgICBpZiBAX2NvbmZpZy51c2VEZWZhdWx0QXV0aFxuICAgICAgQF9pbml0QXV0aCgpXG4gICAgZWxzZSBpZiBAX2NvbmZpZy51c2VBdXRoXG4gICAgICBAX2luaXRBdXRoKClcbiAgICAgIGNvbnNvbGUud2FybiAnV2FybmluZzogdXNlQXV0aCBBUEkgY29uZmlnIG9wdGlvbiB3aWxsIGJlIHJlbW92ZWQgaW4gUmVzdGl2dXMgdjEuMCAnICtcbiAgICAgICAgICAnXFxuICAgIFVzZSB0aGUgdXNlRGVmYXVsdEF1dGggb3B0aW9uIGluc3RlYWQnXG5cbiAgICByZXR1cm4gdGhpc1xuXG5cbiAgIyMjKlxuICAgIEFkZCBlbmRwb2ludHMgZm9yIHRoZSBnaXZlbiBIVFRQIG1ldGhvZHMgYXQgdGhlIGdpdmVuIHBhdGhcblxuICAgIEBwYXJhbSBwYXRoIHtTdHJpbmd9IFRoZSBleHRlbmRlZCBVUkwgcGF0aCAod2lsbCBiZSBhcHBlbmRlZCB0byBiYXNlIHBhdGggb2YgdGhlIEFQSSlcbiAgICBAcGFyYW0gb3B0aW9ucyB7T2JqZWN0fSBSb3V0ZSBjb25maWd1cmF0aW9uIG9wdGlvbnNcbiAgICBAcGFyYW0gb3B0aW9ucy5hdXRoUmVxdWlyZWQge0Jvb2xlYW59IFRoZSBkZWZhdWx0IGF1dGggcmVxdWlyZW1lbnQgZm9yIGVhY2ggZW5kcG9pbnQgb24gdGhlIHJvdXRlXG4gICAgQHBhcmFtIG9wdGlvbnMucm9sZVJlcXVpcmVkIHtTdHJpbmcgb3IgU3RyaW5nW119IFRoZSBkZWZhdWx0IHJvbGUgcmVxdWlyZWQgZm9yIGVhY2ggZW5kcG9pbnQgb24gdGhlIHJvdXRlXG4gICAgQHBhcmFtIGVuZHBvaW50cyB7T2JqZWN0fSBBIHNldCBvZiBlbmRwb2ludHMgYXZhaWxhYmxlIG9uIHRoZSBuZXcgcm91dGUgKGdldCwgcG9zdCwgcHV0LCBwYXRjaCwgZGVsZXRlLCBvcHRpb25zKVxuICAgIEBwYXJhbSBlbmRwb2ludHMuPG1ldGhvZD4ge0Z1bmN0aW9uIG9yIE9iamVjdH0gSWYgYSBmdW5jdGlvbiBpcyBwcm92aWRlZCwgYWxsIGRlZmF1bHQgcm91dGVcbiAgICAgICAgY29uZmlndXJhdGlvbiBvcHRpb25zIHdpbGwgYmUgYXBwbGllZCB0byB0aGUgZW5kcG9pbnQuIE90aGVyd2lzZSBhbiBvYmplY3Qgd2l0aCBhbiBgYWN0aW9uYFxuICAgICAgICBhbmQgYWxsIG90aGVyIHJvdXRlIGNvbmZpZyBvcHRpb25zIGF2YWlsYWJsZS4gQW4gYGFjdGlvbmAgbXVzdCBiZSBwcm92aWRlZCB3aXRoIHRoZSBvYmplY3QuXG4gICMjI1xuICBhZGRSb3V0ZTogKHBhdGgsIG9wdGlvbnMsIGVuZHBvaW50cykgLT5cbiAgICAjIENyZWF0ZSBhIG5ldyByb3V0ZSBhbmQgYWRkIGl0IHRvIG91ciBsaXN0IG9mIGV4aXN0aW5nIHJvdXRlc1xuICAgIHJvdXRlID0gbmV3IHNoYXJlLlJvdXRlKHRoaXMsIHBhdGgsIG9wdGlvbnMsIGVuZHBvaW50cylcbiAgICBAX3JvdXRlcy5wdXNoKHJvdXRlKVxuXG4gICAgcm91dGUuYWRkVG9BcGkoKVxuXG4gICAgcmV0dXJuIHRoaXNcblxuXG4gICMjIypcbiAgICBHZW5lcmF0ZSByb3V0ZXMgZm9yIHRoZSBNZXRlb3IgQ29sbGVjdGlvbiB3aXRoIHRoZSBnaXZlbiBuYW1lXG4gICMjI1xuICBhZGRDb2xsZWN0aW9uOiAoY29sbGVjdGlvbiwgb3B0aW9ucz17fSkgLT5cbiAgICBtZXRob2RzID0gWydnZXQnLCAncG9zdCcsICdwdXQnLCAncGF0Y2gnLCAnZGVsZXRlJywgJ2dldEFsbCddXG4gICAgbWV0aG9kc09uQ29sbGVjdGlvbiA9IFsncG9zdCcsICdnZXRBbGwnXVxuXG4gICAgIyBHcmFiIHRoZSBzZXQgb2YgZW5kcG9pbnRzXG4gICAgaWYgY29sbGVjdGlvbiBpcyBNZXRlb3IudXNlcnNcbiAgICAgIGNvbGxlY3Rpb25FbmRwb2ludHMgPSBAX3VzZXJDb2xsZWN0aW9uRW5kcG9pbnRzXG4gICAgZWxzZVxuICAgICAgY29sbGVjdGlvbkVuZHBvaW50cyA9IEBfY29sbGVjdGlvbkVuZHBvaW50c1xuXG4gICAgIyBGbGF0dGVuIHRoZSBvcHRpb25zIGFuZCBzZXQgZGVmYXVsdHMgaWYgbmVjZXNzYXJ5XG4gICAgZW5kcG9pbnRzQXdhaXRpbmdDb25maWd1cmF0aW9uID0gb3B0aW9ucy5lbmRwb2ludHMgb3Ige31cbiAgICByb3V0ZU9wdGlvbnMgPSBvcHRpb25zLnJvdXRlT3B0aW9ucyBvciB7fVxuICAgIGV4Y2x1ZGVkRW5kcG9pbnRzID0gb3B0aW9ucy5leGNsdWRlZEVuZHBvaW50cyBvciBbXVxuICAgICMgVXNlIGNvbGxlY3Rpb24gbmFtZSBhcyBkZWZhdWx0IHBhdGhcbiAgICBwYXRoID0gb3B0aW9ucy5wYXRoIG9yIGNvbGxlY3Rpb24uX25hbWVcblxuICAgICMgU2VwYXJhdGUgdGhlIHJlcXVlc3RlZCBlbmRwb2ludHMgYnkgdGhlIHJvdXRlIHRoZXkgYmVsb25nIHRvIChvbmUgZm9yIG9wZXJhdGluZyBvbiB0aGUgZW50aXJlXG4gICAgIyBjb2xsZWN0aW9uIGFuZCBvbmUgZm9yIG9wZXJhdGluZyBvbiBhIHNpbmdsZSBlbnRpdHkgd2l0aGluIHRoZSBjb2xsZWN0aW9uKVxuICAgIGNvbGxlY3Rpb25Sb3V0ZUVuZHBvaW50cyA9IHt9XG4gICAgZW50aXR5Um91dGVFbmRwb2ludHMgPSB7fVxuICAgIGlmIF8uaXNFbXB0eShlbmRwb2ludHNBd2FpdGluZ0NvbmZpZ3VyYXRpb24pIGFuZCBfLmlzRW1wdHkoZXhjbHVkZWRFbmRwb2ludHMpXG4gICAgICAjIEdlbmVyYXRlIGFsbCBlbmRwb2ludHMgb24gdGhpcyBjb2xsZWN0aW9uXG4gICAgICBfLmVhY2ggbWV0aG9kcywgKG1ldGhvZCkgLT5cbiAgICAgICAgIyBQYXJ0aXRpb24gdGhlIGVuZHBvaW50cyBpbnRvIHRoZWlyIHJlc3BlY3RpdmUgcm91dGVzXG4gICAgICAgIGlmIG1ldGhvZCBpbiBtZXRob2RzT25Db2xsZWN0aW9uXG4gICAgICAgICAgXy5leHRlbmQgY29sbGVjdGlvblJvdXRlRW5kcG9pbnRzLCBjb2xsZWN0aW9uRW5kcG9pbnRzW21ldGhvZF0uY2FsbCh0aGlzLCBjb2xsZWN0aW9uKVxuICAgICAgICBlbHNlIF8uZXh0ZW5kIGVudGl0eVJvdXRlRW5kcG9pbnRzLCBjb2xsZWN0aW9uRW5kcG9pbnRzW21ldGhvZF0uY2FsbCh0aGlzLCBjb2xsZWN0aW9uKVxuICAgICAgICByZXR1cm5cbiAgICAgICwgdGhpc1xuICAgIGVsc2VcbiAgICAgICMgR2VuZXJhdGUgYW55IGVuZHBvaW50cyB0aGF0IGhhdmVuJ3QgYmVlbiBleHBsaWNpdGx5IGV4Y2x1ZGVkXG4gICAgICBfLmVhY2ggbWV0aG9kcywgKG1ldGhvZCkgLT5cbiAgICAgICAgaWYgbWV0aG9kIG5vdCBpbiBleGNsdWRlZEVuZHBvaW50cyBhbmQgZW5kcG9pbnRzQXdhaXRpbmdDb25maWd1cmF0aW9uW21ldGhvZF0gaXNudCBmYWxzZVxuICAgICAgICAgICMgQ29uZmlndXJlIGVuZHBvaW50IGFuZCBtYXAgdG8gaXQncyBodHRwIG1ldGhvZFxuICAgICAgICAgICMgVE9ETzogQ29uc2lkZXIgcHJlZGVmaW5pbmcgYSBtYXAgb2YgbWV0aG9kcyB0byB0aGVpciBodHRwIG1ldGhvZCB0eXBlIChlLmcuLCBnZXRBbGw6IGdldClcbiAgICAgICAgICBlbmRwb2ludE9wdGlvbnMgPSBlbmRwb2ludHNBd2FpdGluZ0NvbmZpZ3VyYXRpb25bbWV0aG9kXVxuICAgICAgICAgIGNvbmZpZ3VyZWRFbmRwb2ludCA9IHt9XG4gICAgICAgICAgXy5lYWNoIGNvbGxlY3Rpb25FbmRwb2ludHNbbWV0aG9kXS5jYWxsKHRoaXMsIGNvbGxlY3Rpb24pLCAoYWN0aW9uLCBtZXRob2RUeXBlKSAtPlxuICAgICAgICAgICAgY29uZmlndXJlZEVuZHBvaW50W21ldGhvZFR5cGVdID1cbiAgICAgICAgICAgICAgXy5jaGFpbiBhY3Rpb25cbiAgICAgICAgICAgICAgLmNsb25lKClcbiAgICAgICAgICAgICAgLmV4dGVuZCBlbmRwb2ludE9wdGlvbnNcbiAgICAgICAgICAgICAgLnZhbHVlKClcbiAgICAgICAgICAjIFBhcnRpdGlvbiB0aGUgZW5kcG9pbnRzIGludG8gdGhlaXIgcmVzcGVjdGl2ZSByb3V0ZXNcbiAgICAgICAgICBpZiBtZXRob2QgaW4gbWV0aG9kc09uQ29sbGVjdGlvblxuICAgICAgICAgICAgXy5leHRlbmQgY29sbGVjdGlvblJvdXRlRW5kcG9pbnRzLCBjb25maWd1cmVkRW5kcG9pbnRcbiAgICAgICAgICBlbHNlIF8uZXh0ZW5kIGVudGl0eVJvdXRlRW5kcG9pbnRzLCBjb25maWd1cmVkRW5kcG9pbnRcbiAgICAgICAgICByZXR1cm5cbiAgICAgICwgdGhpc1xuXG4gICAgIyBBZGQgdGhlIHJvdXRlcyB0byB0aGUgQVBJXG4gICAgQGFkZFJvdXRlIHBhdGgsIHJvdXRlT3B0aW9ucywgY29sbGVjdGlvblJvdXRlRW5kcG9pbnRzXG4gICAgQGFkZFJvdXRlIFwiI3twYXRofS86aWRcIiwgcm91dGVPcHRpb25zLCBlbnRpdHlSb3V0ZUVuZHBvaW50c1xuXG4gICAgcmV0dXJuIHRoaXNcblxuXG4gICMjIypcbiAgICBBIHNldCBvZiBlbmRwb2ludHMgdGhhdCBjYW4gYmUgYXBwbGllZCB0byBhIENvbGxlY3Rpb24gUm91dGVcbiAgIyMjXG4gIF9jb2xsZWN0aW9uRW5kcG9pbnRzOlxuICAgIGdldDogKGNvbGxlY3Rpb24pIC0+XG4gICAgICBnZXQ6XG4gICAgICAgIGFjdGlvbjogLT5cbiAgICAgICAgICBlbnRpdHkgPSBjb2xsZWN0aW9uLmZpbmRPbmUgQHVybFBhcmFtcy5pZFxuICAgICAgICAgIGlmIGVudGl0eVxuICAgICAgICAgICAge3N0YXR1czogJ3N1Y2Nlc3MnLCBkYXRhOiBlbnRpdHl9XG4gICAgICAgICAgZWxzZVxuICAgICAgICAgICAgc3RhdHVzQ29kZTogNDA0XG4gICAgICAgICAgICBib2R5OiB7c3RhdHVzOiAnZmFpbCcsIG1lc3NhZ2U6ICdJdGVtIG5vdCBmb3VuZCd9XG4gICAgcHV0OiAoY29sbGVjdGlvbikgLT5cbiAgICAgIHB1dDpcbiAgICAgICAgYWN0aW9uOiAtPlxuICAgICAgICAgIGVudGl0eUlzVXBkYXRlZCA9IGNvbGxlY3Rpb24udXBkYXRlIEB1cmxQYXJhbXMuaWQsIEBib2R5UGFyYW1zXG4gICAgICAgICAgaWYgZW50aXR5SXNVcGRhdGVkXG4gICAgICAgICAgICBlbnRpdHkgPSBjb2xsZWN0aW9uLmZpbmRPbmUgQHVybFBhcmFtcy5pZFxuICAgICAgICAgICAge3N0YXR1czogJ3N1Y2Nlc3MnLCBkYXRhOiBlbnRpdHl9XG4gICAgICAgICAgZWxzZVxuICAgICAgICAgICAgc3RhdHVzQ29kZTogNDA0XG4gICAgICAgICAgICBib2R5OiB7c3RhdHVzOiAnZmFpbCcsIG1lc3NhZ2U6ICdJdGVtIG5vdCBmb3VuZCd9XG4gICAgcGF0Y2g6IChjb2xsZWN0aW9uKSAtPlxuICAgICAgcGF0Y2g6XG4gICAgICAgIGFjdGlvbjogLT5cbiAgICAgICAgICBlbnRpdHlJc1VwZGF0ZWQgPSBjb2xsZWN0aW9uLnVwZGF0ZSBAdXJsUGFyYW1zLmlkLCAkc2V0OiBAYm9keVBhcmFtc1xuICAgICAgICAgIGlmIGVudGl0eUlzVXBkYXRlZFxuICAgICAgICAgICAgZW50aXR5ID0gY29sbGVjdGlvbi5maW5kT25lIEB1cmxQYXJhbXMuaWRcbiAgICAgICAgICAgIHtzdGF0dXM6ICdzdWNjZXNzJywgZGF0YTogZW50aXR5fVxuICAgICAgICAgIGVsc2VcbiAgICAgICAgICAgIHN0YXR1c0NvZGU6IDQwNFxuICAgICAgICAgICAgYm9keToge3N0YXR1czogJ2ZhaWwnLCBtZXNzYWdlOiAnSXRlbSBub3QgZm91bmQnfVxuICAgIGRlbGV0ZTogKGNvbGxlY3Rpb24pIC0+XG4gICAgICBkZWxldGU6XG4gICAgICAgIGFjdGlvbjogLT5cbiAgICAgICAgICBpZiBjb2xsZWN0aW9uLnJlbW92ZSBAdXJsUGFyYW1zLmlkXG4gICAgICAgICAgICB7c3RhdHVzOiAnc3VjY2VzcycsIGRhdGE6IG1lc3NhZ2U6ICdJdGVtIHJlbW92ZWQnfVxuICAgICAgICAgIGVsc2VcbiAgICAgICAgICAgIHN0YXR1c0NvZGU6IDQwNFxuICAgICAgICAgICAgYm9keToge3N0YXR1czogJ2ZhaWwnLCBtZXNzYWdlOiAnSXRlbSBub3QgZm91bmQnfVxuICAgIHBvc3Q6IChjb2xsZWN0aW9uKSAtPlxuICAgICAgcG9zdDpcbiAgICAgICAgYWN0aW9uOiAtPlxuICAgICAgICAgIGVudGl0eUlkID0gY29sbGVjdGlvbi5pbnNlcnQgQGJvZHlQYXJhbXNcbiAgICAgICAgICBlbnRpdHkgPSBjb2xsZWN0aW9uLmZpbmRPbmUgZW50aXR5SWRcbiAgICAgICAgICBpZiBlbnRpdHlcbiAgICAgICAgICAgIHN0YXR1c0NvZGU6IDIwMVxuICAgICAgICAgICAgYm9keToge3N0YXR1czogJ3N1Y2Nlc3MnLCBkYXRhOiBlbnRpdHl9XG4gICAgICAgICAgZWxzZVxuICAgICAgICAgICAgc3RhdHVzQ29kZTogNDAwXG4gICAgICAgICAgICBib2R5OiB7c3RhdHVzOiAnZmFpbCcsIG1lc3NhZ2U6ICdObyBpdGVtIGFkZGVkJ31cbiAgICBnZXRBbGw6IChjb2xsZWN0aW9uKSAtPlxuICAgICAgZ2V0OlxuICAgICAgICBhY3Rpb246IC0+XG4gICAgICAgICAgZW50aXRpZXMgPSBjb2xsZWN0aW9uLmZpbmQoKS5mZXRjaCgpXG4gICAgICAgICAgaWYgZW50aXRpZXNcbiAgICAgICAgICAgIHtzdGF0dXM6ICdzdWNjZXNzJywgZGF0YTogZW50aXRpZXN9XG4gICAgICAgICAgZWxzZVxuICAgICAgICAgICAgc3RhdHVzQ29kZTogNDA0XG4gICAgICAgICAgICBib2R5OiB7c3RhdHVzOiAnZmFpbCcsIG1lc3NhZ2U6ICdVbmFibGUgdG8gcmV0cmlldmUgaXRlbXMgZnJvbSBjb2xsZWN0aW9uJ31cblxuXG4gICMjIypcbiAgICBBIHNldCBvZiBlbmRwb2ludHMgdGhhdCBjYW4gYmUgYXBwbGllZCB0byBhIE1ldGVvci51c2VycyBDb2xsZWN0aW9uIFJvdXRlXG4gICMjI1xuICBfdXNlckNvbGxlY3Rpb25FbmRwb2ludHM6XG4gICAgZ2V0OiAoY29sbGVjdGlvbikgLT5cbiAgICAgIGdldDpcbiAgICAgICAgYWN0aW9uOiAtPlxuICAgICAgICAgIGVudGl0eSA9IGNvbGxlY3Rpb24uZmluZE9uZSBAdXJsUGFyYW1zLmlkLCBmaWVsZHM6IHByb2ZpbGU6IDFcbiAgICAgICAgICBpZiBlbnRpdHlcbiAgICAgICAgICAgIHtzdGF0dXM6ICdzdWNjZXNzJywgZGF0YTogZW50aXR5fVxuICAgICAgICAgIGVsc2VcbiAgICAgICAgICAgIHN0YXR1c0NvZGU6IDQwNFxuICAgICAgICAgICAgYm9keToge3N0YXR1czogJ2ZhaWwnLCBtZXNzYWdlOiAnVXNlciBub3QgZm91bmQnfVxuICAgIHB1dDogKGNvbGxlY3Rpb24pIC0+XG4gICAgICBwdXQ6XG4gICAgICAgIGFjdGlvbjogLT5cbiAgICAgICAgICBlbnRpdHlJc1VwZGF0ZWQgPSBjb2xsZWN0aW9uLnVwZGF0ZSBAdXJsUGFyYW1zLmlkLCAkc2V0OiBwcm9maWxlOiBAYm9keVBhcmFtc1xuICAgICAgICAgIGlmIGVudGl0eUlzVXBkYXRlZFxuICAgICAgICAgICAgZW50aXR5ID0gY29sbGVjdGlvbi5maW5kT25lIEB1cmxQYXJhbXMuaWQsIGZpZWxkczogcHJvZmlsZTogMVxuICAgICAgICAgICAge3N0YXR1czogXCJzdWNjZXNzXCIsIGRhdGE6IGVudGl0eX1cbiAgICAgICAgICBlbHNlXG4gICAgICAgICAgICBzdGF0dXNDb2RlOiA0MDRcbiAgICAgICAgICAgIGJvZHk6IHtzdGF0dXM6ICdmYWlsJywgbWVzc2FnZTogJ1VzZXIgbm90IGZvdW5kJ31cbiAgICBkZWxldGU6IChjb2xsZWN0aW9uKSAtPlxuICAgICAgZGVsZXRlOlxuICAgICAgICBhY3Rpb246IC0+XG4gICAgICAgICAgaWYgY29sbGVjdGlvbi5yZW1vdmUgQHVybFBhcmFtcy5pZFxuICAgICAgICAgICAge3N0YXR1czogJ3N1Y2Nlc3MnLCBkYXRhOiBtZXNzYWdlOiAnVXNlciByZW1vdmVkJ31cbiAgICAgICAgICBlbHNlXG4gICAgICAgICAgICBzdGF0dXNDb2RlOiA0MDRcbiAgICAgICAgICAgIGJvZHk6IHtzdGF0dXM6ICdmYWlsJywgbWVzc2FnZTogJ1VzZXIgbm90IGZvdW5kJ31cbiAgICBwb3N0OiAoY29sbGVjdGlvbikgLT5cbiAgICAgIHBvc3Q6XG4gICAgICAgIGFjdGlvbjogLT5cbiAgICAgICAgICAjIENyZWF0ZSBhIG5ldyB1c2VyIGFjY291bnRcbiAgICAgICAgICBlbnRpdHlJZCA9IEFjY291bnRzLmNyZWF0ZVVzZXIgQGJvZHlQYXJhbXNcbiAgICAgICAgICBlbnRpdHkgPSBjb2xsZWN0aW9uLmZpbmRPbmUgZW50aXR5SWQsIGZpZWxkczogcHJvZmlsZTogMVxuICAgICAgICAgIGlmIGVudGl0eVxuICAgICAgICAgICAgc3RhdHVzQ29kZTogMjAxXG4gICAgICAgICAgICBib2R5OiB7c3RhdHVzOiAnc3VjY2VzcycsIGRhdGE6IGVudGl0eX1cbiAgICAgICAgICBlbHNlXG4gICAgICAgICAgICBzdGF0dXNDb2RlOiA0MDBcbiAgICAgICAgICAgIHtzdGF0dXM6ICdmYWlsJywgbWVzc2FnZTogJ05vIHVzZXIgYWRkZWQnfVxuICAgIGdldEFsbDogKGNvbGxlY3Rpb24pIC0+XG4gICAgICBnZXQ6XG4gICAgICAgIGFjdGlvbjogLT5cbiAgICAgICAgICBlbnRpdGllcyA9IGNvbGxlY3Rpb24uZmluZCh7fSwgZmllbGRzOiBwcm9maWxlOiAxKS5mZXRjaCgpXG4gICAgICAgICAgaWYgZW50aXRpZXNcbiAgICAgICAgICAgIHtzdGF0dXM6ICdzdWNjZXNzJywgZGF0YTogZW50aXRpZXN9XG4gICAgICAgICAgZWxzZVxuICAgICAgICAgICAgc3RhdHVzQ29kZTogNDA0XG4gICAgICAgICAgICBib2R5OiB7c3RhdHVzOiAnZmFpbCcsIG1lc3NhZ2U6ICdVbmFibGUgdG8gcmV0cmlldmUgdXNlcnMnfVxuXG5cbiAgIyMjXG4gICAgQWRkIC9sb2dpbiBhbmQgL2xvZ291dCBlbmRwb2ludHMgdG8gdGhlIEFQSVxuICAjIyNcbiAgX2luaXRBdXRoOiAtPlxuICAgIHNlbGYgPSB0aGlzXG4gICAgIyMjXG4gICAgICBBZGQgYSBsb2dpbiBlbmRwb2ludCB0byB0aGUgQVBJXG5cbiAgICAgIEFmdGVyIHRoZSB1c2VyIGlzIGxvZ2dlZCBpbiwgdGhlIG9uTG9nZ2VkSW4gaG9vayBpcyBjYWxsZWQgKHNlZSBSZXN0ZnVsbHkuY29uZmlndXJlKCkgZm9yXG4gICAgICBhZGRpbmcgaG9vaykuXG4gICAgIyMjXG4gICAgQGFkZFJvdXRlICdsb2dpbicsIHthdXRoUmVxdWlyZWQ6IGZhbHNlfSxcbiAgICAgIHBvc3Q6IC0+XG4gICAgICAgICMgR3JhYiB0aGUgdXNlcm5hbWUgb3IgZW1haWwgdGhhdCB0aGUgdXNlciBpcyBsb2dnaW5nIGluIHdpdGhcbiAgICAgICAgdXNlciA9IHt9XG4gICAgICAgIGlmIEBib2R5UGFyYW1zLnVzZXJcbiAgICAgICAgICBpZiBAYm9keVBhcmFtcy51c2VyLmluZGV4T2YoJ0AnKSBpcyAtMVxuICAgICAgICAgICAgdXNlci51c2VybmFtZSA9IEBib2R5UGFyYW1zLnVzZXJcbiAgICAgICAgICBlbHNlXG4gICAgICAgICAgICB1c2VyLmVtYWlsID0gQGJvZHlQYXJhbXMudXNlclxuICAgICAgICBlbHNlIGlmIEBib2R5UGFyYW1zLnVzZXJuYW1lXG4gICAgICAgICAgdXNlci51c2VybmFtZSA9IEBib2R5UGFyYW1zLnVzZXJuYW1lXG4gICAgICAgIGVsc2UgaWYgQGJvZHlQYXJhbXMuZW1haWxcbiAgICAgICAgICB1c2VyLmVtYWlsID0gQGJvZHlQYXJhbXMuZW1haWxcblxuICAgICAgICBwYXNzd29yZCA9IEBib2R5UGFyYW1zLnBhc3N3b3JkXG4gICAgICAgIGlmIEBib2R5UGFyYW1zLmhhc2hlZFxuICAgICAgICAgIHBhc3N3b3JkID1cbiAgICAgICAgICAgIGRpZ2VzdDogcGFzc3dvcmRcbiAgICAgICAgICAgIGFsZ29yaXRobTogJ3NoYS0yNTYnXG5cbiAgICAgICAgIyBUcnkgdG8gbG9nIHRoZSB1c2VyIGludG8gdGhlIHVzZXIncyBhY2NvdW50IChpZiBzdWNjZXNzZnVsIHdlJ2xsIGdldCBhbiBhdXRoIHRva2VuIGJhY2spXG4gICAgICAgIHRyeVxuICAgICAgICAgIGF1dGggPSBBdXRoLmxvZ2luV2l0aFBhc3N3b3JkIHVzZXIsIHBhc3N3b3JkXG4gICAgICAgIGNhdGNoIGVcbiAgICAgICAgICByZXR1cm4ge30gPVxuICAgICAgICAgICAgc3RhdHVzQ29kZTogZS5lcnJvclxuICAgICAgICAgICAgYm9keTogc3RhdHVzOiAnZXJyb3InLCBtZXNzYWdlOiBlLnJlYXNvblxuXG4gICAgICAgICMgR2V0IHRoZSBhdXRoZW50aWNhdGVkIHVzZXJcbiAgICAgICAgIyBUT0RPOiBDb25zaWRlciByZXR1cm5pbmcgdGhlIHVzZXIgaW4gQXV0aC5sb2dpbldpdGhQYXNzd29yZCgpLCBpbnN0ZWFkIG9mIGZldGNoaW5nIGl0IGFnYWluIGhlcmVcbiAgICAgICAgaWYgYXV0aC51c2VySWQgYW5kIGF1dGguYXV0aFRva2VuXG4gICAgICAgICAgc2VhcmNoUXVlcnkgPSB7fVxuICAgICAgICAgIHNlYXJjaFF1ZXJ5W3NlbGYuX2NvbmZpZy5hdXRoLnRva2VuXSA9IEFjY291bnRzLl9oYXNoTG9naW5Ub2tlbiBhdXRoLmF1dGhUb2tlblxuICAgICAgICAgIEB1c2VyID0gTWV0ZW9yLnVzZXJzLmZpbmRPbmVcbiAgICAgICAgICAgICdfaWQnOiBhdXRoLnVzZXJJZFxuICAgICAgICAgICAgc2VhcmNoUXVlcnlcbiAgICAgICAgICBAdXNlcklkID0gQHVzZXI/Ll9pZFxuXG4gICAgICAgIHJlc3BvbnNlID0ge3N0YXR1czogJ3N1Y2Nlc3MnLCBkYXRhOiBhdXRofVxuXG4gICAgICAgICMgQ2FsbCB0aGUgbG9naW4gaG9vayB3aXRoIHRoZSBhdXRoZW50aWNhdGVkIHVzZXIgYXR0YWNoZWRcbiAgICAgICAgZXh0cmFEYXRhID0gc2VsZi5fY29uZmlnLm9uTG9nZ2VkSW4/LmNhbGwodGhpcylcbiAgICAgICAgaWYgZXh0cmFEYXRhP1xuICAgICAgICAgIF8uZXh0ZW5kKHJlc3BvbnNlLmRhdGEsIHtleHRyYTogZXh0cmFEYXRhfSlcblxuICAgICAgICByZXNwb25zZVxuXG4gICAgbG9nb3V0ID0gLT5cbiAgICAgICMgUmVtb3ZlIHRoZSBnaXZlbiBhdXRoIHRva2VuIGZyb20gdGhlIHVzZXIncyBhY2NvdW50XG4gICAgICBhdXRoVG9rZW4gPSBAcmVxdWVzdC5oZWFkZXJzWyd4LWF1dGgtdG9rZW4nXVxuICAgICAgaGFzaGVkVG9rZW4gPSBBY2NvdW50cy5faGFzaExvZ2luVG9rZW4gYXV0aFRva2VuXG4gICAgICB0b2tlbkxvY2F0aW9uID0gc2VsZi5fY29uZmlnLmF1dGgudG9rZW5cbiAgICAgIGluZGV4ID0gdG9rZW5Mb2NhdGlvbi5sYXN0SW5kZXhPZiAnLidcbiAgICAgIHRva2VuUGF0aCA9IHRva2VuTG9jYXRpb24uc3Vic3RyaW5nIDAsIGluZGV4XG4gICAgICB0b2tlbkZpZWxkTmFtZSA9IHRva2VuTG9jYXRpb24uc3Vic3RyaW5nIGluZGV4ICsgMVxuICAgICAgdG9rZW5Ub1JlbW92ZSA9IHt9XG4gICAgICB0b2tlblRvUmVtb3ZlW3Rva2VuRmllbGROYW1lXSA9IGhhc2hlZFRva2VuXG4gICAgICB0b2tlblJlbW92YWxRdWVyeSA9IHt9XG4gICAgICB0b2tlblJlbW92YWxRdWVyeVt0b2tlblBhdGhdID0gdG9rZW5Ub1JlbW92ZVxuICAgICAgTWV0ZW9yLnVzZXJzLnVwZGF0ZSBAdXNlci5faWQsIHskcHVsbDogdG9rZW5SZW1vdmFsUXVlcnl9XG5cbiAgICAgIHJlc3BvbnNlID0ge3N0YXR1czogJ3N1Y2Nlc3MnLCBkYXRhOiB7bWVzc2FnZTogJ1lvdVxcJ3ZlIGJlZW4gbG9nZ2VkIG91dCEnfX1cblxuICAgICAgIyBDYWxsIHRoZSBsb2dvdXQgaG9vayB3aXRoIHRoZSBhdXRoZW50aWNhdGVkIHVzZXIgYXR0YWNoZWRcbiAgICAgIGV4dHJhRGF0YSA9IHNlbGYuX2NvbmZpZy5vbkxvZ2dlZE91dD8uY2FsbCh0aGlzKVxuICAgICAgaWYgZXh0cmFEYXRhP1xuICAgICAgICBfLmV4dGVuZChyZXNwb25zZS5kYXRhLCB7ZXh0cmE6IGV4dHJhRGF0YX0pXG5cbiAgICAgIHJlc3BvbnNlXG5cbiAgICAjIyNcbiAgICAgIEFkZCBhIGxvZ291dCBlbmRwb2ludCB0byB0aGUgQVBJXG5cbiAgICAgIEFmdGVyIHRoZSB1c2VyIGlzIGxvZ2dlZCBvdXQsIHRoZSBvbkxvZ2dlZE91dCBob29rIGlzIGNhbGxlZCAoc2VlIFJlc3RmdWxseS5jb25maWd1cmUoKSBmb3JcbiAgICAgIGFkZGluZyBob29rKS5cbiAgICAjIyNcbiAgICBAYWRkUm91dGUgJ2xvZ291dCcsIHthdXRoUmVxdWlyZWQ6IHRydWV9LFxuICAgICAgZ2V0OiAtPlxuICAgICAgICBjb25zb2xlLndhcm4gXCJXYXJuaW5nOiBEZWZhdWx0IGxvZ291dCB2aWEgR0VUIHdpbGwgYmUgcmVtb3ZlZCBpbiBSZXN0aXZ1cyB2MS4wLiBVc2UgUE9TVCBpbnN0ZWFkLlwiXG4gICAgICAgIGNvbnNvbGUud2FybiBcIiAgICBTZWUgaHR0cHM6Ly9naXRodWIuY29tL2thaG1hbGkvbWV0ZW9yLXJlc3RpdnVzL2lzc3Vlcy8xMDBcIlxuICAgICAgICByZXR1cm4gbG9nb3V0LmNhbGwodGhpcylcbiAgICAgIHBvc3Q6IGxvZ291dFxuXG5SZXN0aXZ1cyA9IEBSZXN0aXZ1c1xuIl19
