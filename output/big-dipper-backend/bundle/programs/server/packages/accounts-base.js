(function () {

/* Imports */
var Meteor = Package.meteor.Meteor;
var global = Package.meteor.global;
var meteorEnv = Package.meteor.meteorEnv;
var ECMAScript = Package.ecmascript.ECMAScript;
var DDPRateLimiter = Package['ddp-rate-limiter'].DDPRateLimiter;
var check = Package.check.check;
var Match = Package.check.Match;
var Random = Package.random.Random;
var EJSON = Package.ejson.EJSON;
var Hook = Package['callback-hook'].Hook;
var URL = Package.url.URL;
var URLSearchParams = Package.url.URLSearchParams;
var DDP = Package['ddp-client'].DDP;
var DDPServer = Package['ddp-server'].DDPServer;
var MongoInternals = Package.mongo.MongoInternals;
var Mongo = Package.mongo.Mongo;
var meteorInstall = Package.modules.meteorInstall;
var Promise = Package.promise.Promise;

/* Package-scope variables */
var Accounts, options, stampedLoginToken, handler, name, query, oldestValidDate, user;

var require = meteorInstall({"node_modules":{"meteor":{"accounts-base":{"server_main.js":function module(require,exports,module){

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                   //
// packages/accounts-base/server_main.js                                                                             //
//                                                                                                                   //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                     //
!function (module1) {
  module1.export({
    AccountsServer: () => AccountsServer
  });
  let AccountsServer;
  module1.link("./accounts_server.js", {
    AccountsServer(v) {
      AccountsServer = v;
    }

  }, 0);

  /**
   * @namespace Accounts
   * @summary The namespace for all server-side accounts-related methods.
   */
  Accounts = new AccountsServer(Meteor.server); // Users table. Don't use the normal autopublish, since we want to hide
  // some fields. Code to autopublish this is in accounts_server.js.
  // XXX Allow users to configure this collection name.

  /**
   * @summary A [Mongo.Collection](#collections) containing user documents.
   * @locus Anywhere
   * @type {Mongo.Collection}
   * @importFromPackage meteor
  */

  Meteor.users = Accounts.users;
}.call(this, module);
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"accounts_common.js":function module(require,exports,module){

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                   //
// packages/accounts-base/accounts_common.js                                                                         //
//                                                                                                                   //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                     //
let _objectSpread;

module.link("@babel/runtime/helpers/objectSpread2", {
  default(v) {
    _objectSpread = v;
  }

}, 0);
module.export({
  AccountsCommon: () => AccountsCommon,
  EXPIRE_TOKENS_INTERVAL_MS: () => EXPIRE_TOKENS_INTERVAL_MS,
  CONNECTION_CLOSE_DELAY_MS: () => CONNECTION_CLOSE_DELAY_MS
});
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
// config option keys
const VALID_CONFIG_KEYS = ['sendVerificationEmail', 'forbidClientAccountCreation', 'passwordEnrollTokenExpiration', 'passwordEnrollTokenExpirationInDays', 'restrictCreationByEmailDomain', 'loginExpirationInDays', 'loginExpiration', 'passwordResetTokenExpirationInDays', 'passwordResetTokenExpiration', 'ambiguousErrorMessages', 'bcryptRounds', 'defaultFieldSelector'];
/**
 * @summary Super-constructor for AccountsClient and AccountsServer.
 * @locus Anywhere
 * @class AccountsCommon
 * @instancename accountsClientOrServer
 * @param options {Object} an object with fields:
 * - connection {Object} Optional DDP connection to reuse.
 * - ddpUrl {String} Optional URL for creating a new DDP connection.
 */

class AccountsCommon {
  constructor(options) {
    // Currently this is read directly by packages like accounts-password
    // and accounts-ui-unstyled.
    this._options = {}; // Note that setting this.connection = null causes this.users to be a
    // LocalCollection, which is not what we want.

    this.connection = undefined;

    this._initConnection(options || {}); // There is an allow call in accounts_server.js that restricts writes to
    // this collection.


    this.users = new Mongo.Collection('users', {
      _preventAutopublish: true,
      connection: this.connection
    }); // Callback exceptions are printed with Meteor._debug and ignored.

    this._onLoginHook = new Hook({
      bindEnvironment: false,
      debugPrintExceptions: 'onLogin callback'
    });
    this._onLoginFailureHook = new Hook({
      bindEnvironment: false,
      debugPrintExceptions: 'onLoginFailure callback'
    });
    this._onLogoutHook = new Hook({
      bindEnvironment: false,
      debugPrintExceptions: 'onLogout callback'
    }); // Expose for testing.

    this.DEFAULT_LOGIN_EXPIRATION_DAYS = DEFAULT_LOGIN_EXPIRATION_DAYS;
    this.LOGIN_UNEXPIRING_TOKEN_DAYS = LOGIN_UNEXPIRING_TOKEN_DAYS; // Thrown when the user cancels the login process (eg, closes an oauth
    // popup, declines retina scan, etc)

    const lceName = 'Accounts.LoginCancelledError';
    this.LoginCancelledError = Meteor.makeErrorType(lceName, function (description) {
      this.message = description;
    });
    this.LoginCancelledError.prototype.name = lceName; // This is used to transmit specific subclass errors over the wire. We
    // should come up with a more generic way to do this (eg, with some sort of
    // symbolic error code rather than a number).

    this.LoginCancelledError.numericError = 0x8acdc2f; // loginServiceConfiguration and ConfigError are maintained for backwards compatibility

    Meteor.startup(() => {
      var _Meteor$settings, _Meteor$settings$pack;

      const {
        ServiceConfiguration
      } = Package['service-configuration'];
      this.loginServiceConfiguration = ServiceConfiguration.configurations;
      this.ConfigError = ServiceConfiguration.ConfigError;
      const settings = (_Meteor$settings = Meteor.settings) === null || _Meteor$settings === void 0 ? void 0 : (_Meteor$settings$pack = _Meteor$settings.packages) === null || _Meteor$settings$pack === void 0 ? void 0 : _Meteor$settings$pack['accounts-base'];

      if (settings) {
        if (settings.oauthSecretKey) {
          if (!Package['oauth-encryption']) {
            throw new Error('The oauth-encryption package must be loaded to set oauthSecretKey');
          }

          Package['oauth-encryption'].OAuthEncryption.loadKey(settings.oauthSecretKey);
          delete settings.oauthSecretKey;
        } // Validate config options keys


        Object.keys(settings).forEach(key => {
          if (!VALID_CONFIG_KEYS.includes(key)) {
            // TODO Consider just logging a debug message instead to allow for additional keys in the settings here?
            throw new Meteor.Error("Accounts configuration: Invalid key: ".concat(key));
          } else {
            // set values in Accounts._options
            this._options[key] = settings[key];
          }
        });
      }
    });
  }
  /**
   * @summary Get the current user id, or `null` if no user is logged in. A reactive data source.
   * @locus Anywhere
   */


  userId() {
    throw new Error('userId method not implemented');
  } // merge the defaultFieldSelector with an existing options object


  _addDefaultFieldSelector() {
    let options = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};
    // this will be the most common case for most people, so make it quick
    if (!this._options.defaultFieldSelector) return options; // if no field selector then just use defaultFieldSelector

    if (!options.fields) return _objectSpread(_objectSpread({}, options), {}, {
      fields: this._options.defaultFieldSelector
    }); // if empty field selector then the full user object is explicitly requested, so obey

    const keys = Object.keys(options.fields);
    if (!keys.length) return options; // if the requested fields are +ve then ignore defaultFieldSelector
    // assume they are all either +ve or -ve because Mongo doesn't like mixed

    if (!!options.fields[keys[0]]) return options; // The requested fields are -ve.
    // If the defaultFieldSelector is +ve then use requested fields, otherwise merge them

    const keys2 = Object.keys(this._options.defaultFieldSelector);
    return this._options.defaultFieldSelector[keys2[0]] ? options : _objectSpread(_objectSpread({}, options), {}, {
      fields: _objectSpread(_objectSpread({}, options.fields), this._options.defaultFieldSelector)
    });
  }
  /**
   * @summary Get the current user record, or `null` if no user is logged in. A reactive data source.
   * @locus Anywhere
   * @param {Object} [options]
   * @param {MongoFieldSpecifier} options.fields Dictionary of fields to return or exclude.
   */


  user(options) {
    const userId = this.userId();
    return userId ? this.users.findOne(userId, this._addDefaultFieldSelector(options)) : null;
  } // Set up config for the accounts system. Call this on both the client
  // and the server.
  //
  // Note that this method gets overridden on AccountsServer.prototype, but
  // the overriding method calls the overridden method.
  //
  // XXX we should add some enforcement that this is called on both the
  // client and the server. Otherwise, a user can
  // 'forbidClientAccountCreation' only on the client and while it looks
  // like their app is secure, the server will still accept createUser
  // calls. https://github.com/meteor/meteor/issues/828
  //
  // @param options {Object} an object with fields:
  // - sendVerificationEmail {Boolean}
  //     Send email address verification emails to new users created from
  //     client signups.
  // - forbidClientAccountCreation {Boolean}
  //     Do not allow clients to create accounts directly.
  // - restrictCreationByEmailDomain {Function or String}
  //     Require created users to have an email matching the function or
  //     having the string as domain.
  // - loginExpirationInDays {Number}
  //     Number of days since login until a user is logged out (login token
  //     expires).
  // - passwordResetTokenExpirationInDays {Number}
  //     Number of days since password reset token creation until the
  //     token cannt be used any longer (password reset token expires).
  // - ambiguousErrorMessages {Boolean}
  //     Return ambiguous error messages from login failures to prevent
  //     user enumeration.
  // - bcryptRounds {Number}
  //     Allows override of number of bcrypt rounds (aka work factor) used
  //     to store passwords.

  /**
   * @summary Set global accounts options. You can also set these in `Meteor.settings.packages.accounts` without the need to call this function.
   * @locus Anywhere
   * @param {Object} options
   * @param {Boolean} options.sendVerificationEmail New users with an email address will receive an address verification email.
   * @param {Boolean} options.forbidClientAccountCreation Calls to [`createUser`](#accounts_createuser) from the client will be rejected. In addition, if you are using [accounts-ui](#accountsui), the "Create account" link will not be available.
   * @param {String | Function} options.restrictCreationByEmailDomain If set to a string, only allows new users if the domain part of their email address matches the string. If set to a function, only allows new users if the function returns true.  The function is passed the full email address of the proposed new user.  Works with password-based sign-in and external services that expose email addresses (Google, Facebook, GitHub). All existing users still can log in after enabling this option. Example: `Accounts.config({ restrictCreationByEmailDomain: 'school.edu' })`.
   * @param {Number} options.loginExpirationInDays The number of days from when a user logs in until their token expires and they are logged out. Defaults to 90. Set to `null` to disable login expiration.
   * @param {Number} options.loginExpiration The number of milliseconds from when a user logs in until their token expires and they are logged out, for a more granular control. If `loginExpirationInDays` is set, it takes precedent.
   * @param {String} options.oauthSecretKey When using the `oauth-encryption` package, the 16 byte key using to encrypt sensitive account credentials in the database, encoded in base64.  This option may only be specified on the server.  See packages/oauth-encryption/README.md for details.
   * @param {Number} options.passwordResetTokenExpirationInDays The number of days from when a link to reset password is sent until token expires and user can't reset password with the link anymore. Defaults to 3.
   * @param {Number} options.passwordResetTokenExpiration The number of milliseconds from when a link to reset password is sent until token expires and user can't reset password with the link anymore. If `passwordResetTokenExpirationInDays` is set, it takes precedent.
   * @param {Number} options.passwordEnrollTokenExpirationInDays The number of days from when a link to set initial password is sent until token expires and user can't set password with the link anymore. Defaults to 30.
   * @param {Number} options.passwordEnrollTokenExpiration The number of milliseconds from when a link to set initial password is sent until token expires and user can't set password with the link anymore. If `passwordEnrollTokenExpirationInDays` is set, it takes precedent.
   * @param {Boolean} options.ambiguousErrorMessages Return ambiguous error messages from login failures to prevent user enumeration. Defaults to false.
   * @param {MongoFieldSpecifier} options.defaultFieldSelector To exclude by default large custom fields from `Meteor.user()` and `Meteor.findUserBy...()` functions when called without a field selector, and all `onLogin`, `onLoginFailure` and `onLogout` callbacks.  Example: `Accounts.config({ defaultFieldSelector: { myBigArray: 0 }})`. Beware when using this. If, for instance, you do not include `email` when excluding the fields, you can have problems with functions like `forgotPassword` that will break because they won't have the required data available. It's recommend that you always keep the fields `_id`, `username`, and `email`.
   */


  config(options) {
    // We don't want users to accidentally only call Accounts.config on the
    // client, where some of the options will have partial effects (eg removing
    // the "create account" button from accounts-ui if forbidClientAccountCreation
    // is set, or redirecting Google login to a specific-domain page) without
    // having their full effects.
    if (Meteor.isServer) {
      __meteor_runtime_config__.accountsConfigCalled = true;
    } else if (!__meteor_runtime_config__.accountsConfigCalled) {
      // XXX would be nice to "crash" the client and replace the UI with an error
      // message, but there's no trivial way to do this.
      Meteor._debug('Accounts.config was called on the client but not on the ' + 'server; some configuration options may not take effect.');
    } // We need to validate the oauthSecretKey option at the time
    // Accounts.config is called. We also deliberately don't store the
    // oauthSecretKey in Accounts._options.


    if (Object.prototype.hasOwnProperty.call(options, 'oauthSecretKey')) {
      if (Meteor.isClient) {
        throw new Error('The oauthSecretKey option may only be specified on the server');
      }

      if (!Package['oauth-encryption']) {
        throw new Error('The oauth-encryption package must be loaded to set oauthSecretKey');
      }

      Package['oauth-encryption'].OAuthEncryption.loadKey(options.oauthSecretKey);
      options = _objectSpread({}, options);
      delete options.oauthSecretKey;
    } // Validate config options keys


    Object.keys(options).forEach(key => {
      if (!VALID_CONFIG_KEYS.includes(key)) {
        throw new Meteor.Error("Accounts.config: Invalid key: ".concat(key));
      }
    }); // set values in Accounts._options

    VALID_CONFIG_KEYS.forEach(key => {
      if (key in options) {
        if (key in this._options) {
          throw new Meteor.Error("Can't set `".concat(key, "` more than once"));
        }

        this._options[key] = options[key];
      }
    });
  }
  /**
   * @summary Register a callback to be called after a login attempt succeeds.
   * @locus Anywhere
   * @param {Function} func The callback to be called when login is successful.
   *                        The callback receives a single object that
   *                        holds login details. This object contains the login
   *                        result type (password, resume, etc.) on both the
   *                        client and server. `onLogin` callbacks registered
   *                        on the server also receive extra data, such
   *                        as user details, connection information, etc.
   */


  onLogin(func) {
    let ret = this._onLoginHook.register(func); // call the just registered callback if already logged in


    this._startupCallback(ret.callback);

    return ret;
  }
  /**
   * @summary Register a callback to be called after a login attempt fails.
   * @locus Anywhere
   * @param {Function} func The callback to be called after the login has failed.
   */


  onLoginFailure(func) {
    return this._onLoginFailureHook.register(func);
  }
  /**
   * @summary Register a callback to be called after a logout attempt succeeds.
   * @locus Anywhere
   * @param {Function} func The callback to be called when logout is successful.
   */


  onLogout(func) {
    return this._onLogoutHook.register(func);
  }

  _initConnection(options) {
    if (!Meteor.isClient) {
      return;
    } // The connection used by the Accounts system. This is the connection
    // that will get logged in by Meteor.login(), and this is the
    // connection whose login state will be reflected by Meteor.userId().
    //
    // It would be much preferable for this to be in accounts_client.js,
    // but it has to be here because it's needed to create the
    // Meteor.users collection.


    if (options.connection) {
      this.connection = options.connection;
    } else if (options.ddpUrl) {
      this.connection = DDP.connect(options.ddpUrl);
    } else if (typeof __meteor_runtime_config__ !== 'undefined' && __meteor_runtime_config__.ACCOUNTS_CONNECTION_URL) {
      // Temporary, internal hook to allow the server to point the client
      // to a different authentication server. This is for a very
      // particular use case that comes up when implementing a oauth
      // server. Unsupported and may go away at any point in time.
      //
      // We will eventually provide a general way to use account-base
      // against any DDP connection, not just one special one.
      this.connection = DDP.connect(__meteor_runtime_config__.ACCOUNTS_CONNECTION_URL);
    } else {
      this.connection = Meteor.connection;
    }
  }

  _getTokenLifetimeMs() {
    // When loginExpirationInDays is set to null, we'll use a really high
    // number of days (LOGIN_UNEXPIRABLE_TOKEN_DAYS) to simulate an
    // unexpiring token.
    const loginExpirationInDays = this._options.loginExpirationInDays === null ? LOGIN_UNEXPIRING_TOKEN_DAYS : this._options.loginExpirationInDays;
    return this._options.loginExpiration || (loginExpirationInDays || DEFAULT_LOGIN_EXPIRATION_DAYS) * 86400000;
  }

  _getPasswordResetTokenLifetimeMs() {
    return this._options.passwordResetTokenExpiration || (this._options.passwordResetTokenExpirationInDays || DEFAULT_PASSWORD_RESET_TOKEN_EXPIRATION_DAYS) * 86400000;
  }

  _getPasswordEnrollTokenLifetimeMs() {
    return this._options.passwordEnrollTokenExpiration || (this._options.passwordEnrollTokenExpirationInDays || DEFAULT_PASSWORD_ENROLL_TOKEN_EXPIRATION_DAYS) * 86400000;
  }

  _tokenExpiration(when) {
    // We pass when through the Date constructor for backwards compatibility;
    // `when` used to be a number.
    return new Date(new Date(when).getTime() + this._getTokenLifetimeMs());
  }

  _tokenExpiresSoon(when) {
    let minLifetimeMs = 0.1 * this._getTokenLifetimeMs();

    const minLifetimeCapMs = MIN_TOKEN_LIFETIME_CAP_SECS * 1000;

    if (minLifetimeMs > minLifetimeCapMs) {
      minLifetimeMs = minLifetimeCapMs;
    }

    return new Date() > new Date(when) - minLifetimeMs;
  } // No-op on the server, overridden on the client.


  _startupCallback(callback) {}

}

// Note that Accounts is defined separately in accounts_client.js and
// accounts_server.js.

/**
 * @summary Get the current user id, or `null` if no user is logged in. A reactive data source.
 * @locus Anywhere but publish functions
 * @importFromPackage meteor
 */
Meteor.userId = () => Accounts.userId();
/**
 * @summary Get the current user record, or `null` if no user is logged in. A reactive data source.
 * @locus Anywhere but publish functions
 * @importFromPackage meteor
 * @param {Object} [options]
 * @param {MongoFieldSpecifier} options.fields Dictionary of fields to return or exclude.
 */


Meteor.user = options => Accounts.user(options); // how long (in days) until a login token expires


const DEFAULT_LOGIN_EXPIRATION_DAYS = 90; // how long (in days) until reset password token expires

const DEFAULT_PASSWORD_RESET_TOKEN_EXPIRATION_DAYS = 3; // how long (in days) until enrol password token expires

const DEFAULT_PASSWORD_ENROLL_TOKEN_EXPIRATION_DAYS = 30; // Clients don't try to auto-login with a token that is going to expire within
// .1 * DEFAULT_LOGIN_EXPIRATION_DAYS, capped at MIN_TOKEN_LIFETIME_CAP_SECS.
// Tries to avoid abrupt disconnects from expiring tokens.

const MIN_TOKEN_LIFETIME_CAP_SECS = 3600; // one hour
// how often (in milliseconds) we check for expired tokens

const EXPIRE_TOKENS_INTERVAL_MS = 600 * 1000;
const CONNECTION_CLOSE_DELAY_MS = 10 * 1000;
// A large number of expiration days (approximately 100 years worth) that is
// used when creating unexpiring tokens.
const LOGIN_UNEXPIRING_TOKEN_DAYS = 365 * 100;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"accounts_server.js":function module(require,exports,module){

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                   //
// packages/accounts-base/accounts_server.js                                                                         //
//                                                                                                                   //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                     //
const _excluded = ["token"];

let _objectWithoutProperties;

module.link("@babel/runtime/helpers/objectWithoutProperties", {
  default(v) {
    _objectWithoutProperties = v;
  }

}, 0);

let _objectSpread;

module.link("@babel/runtime/helpers/objectSpread2", {
  default(v) {
    _objectSpread = v;
  }

}, 1);
module.export({
  AccountsServer: () => AccountsServer
});
let crypto;
module.link("crypto", {
  default(v) {
    crypto = v;
  }

}, 0);
let AccountsCommon, EXPIRE_TOKENS_INTERVAL_MS;
module.link("./accounts_common.js", {
  AccountsCommon(v) {
    AccountsCommon = v;
  },

  EXPIRE_TOKENS_INTERVAL_MS(v) {
    EXPIRE_TOKENS_INTERVAL_MS = v;
  }

}, 1);
let URL;
module.link("meteor/url", {
  URL(v) {
    URL = v;
  }

}, 2);
const hasOwn = Object.prototype.hasOwnProperty; // XXX maybe this belongs in the check package

const NonEmptyString = Match.Where(x => {
  check(x, String);
  return x.length > 0;
});
/**
 * @summary Constructor for the `Accounts` namespace on the server.
 * @locus Server
 * @class AccountsServer
 * @extends AccountsCommon
 * @instancename accountsServer
 * @param {Object} server A server object such as `Meteor.server`.
 */

class AccountsServer extends AccountsCommon {
  // Note that this constructor is less likely to be instantiated multiple
  // times than the `AccountsClient` constructor, because a single server
  // can provide only one set of methods.
  constructor(server) {
    var _this;

    super();
    _this = this;

    this.onCreateLoginToken = function (func) {
      if (this._onCreateLoginTokenHook) {
        throw new Error('Can only call onCreateLoginToken once');
      }

      this._onCreateLoginTokenHook = func;
    };

    this._selectorForFastCaseInsensitiveLookup = (fieldName, string) => {
      // Performance seems to improve up to 4 prefix characters
      const prefix = string.substring(0, Math.min(string.length, 4));
      const orClause = generateCasePermutationsForString(prefix).map(prefixPermutation => {
        const selector = {};
        selector[fieldName] = new RegExp("^".concat(Meteor._escapeRegExp(prefixPermutation)));
        return selector;
      });
      const caseInsensitiveClause = {};
      caseInsensitiveClause[fieldName] = new RegExp("^".concat(Meteor._escapeRegExp(string), "$"), 'i');
      return {
        $and: [{
          $or: orClause
        }, caseInsensitiveClause]
      };
    };

    this._findUserByQuery = (query, options) => {
      let user = null;

      if (query.id) {
        // default field selector is added within getUserById()
        user = Meteor.users.findOne(query.id, this._addDefaultFieldSelector(options));
      } else {
        options = this._addDefaultFieldSelector(options);
        let fieldName;
        let fieldValue;

        if (query.username) {
          fieldName = 'username';
          fieldValue = query.username;
        } else if (query.email) {
          fieldName = 'emails.address';
          fieldValue = query.email;
        } else {
          throw new Error("shouldn't happen (validation missed something)");
        }

        let selector = {};
        selector[fieldName] = fieldValue;
        user = Meteor.users.findOne(selector, options); // If user is not found, try a case insensitive lookup

        if (!user) {
          selector = this._selectorForFastCaseInsensitiveLookup(fieldName, fieldValue);
          const candidateUsers = Meteor.users.find(selector, options).fetch(); // No match if multiple candidates are found

          if (candidateUsers.length === 1) {
            user = candidateUsers[0];
          }
        }
      }

      return user;
    };

    this._handleError = function (msg) {
      let throwError = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : true;
      let errorCode = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : 403;
      const error = new Meteor.Error(errorCode, _this._options.ambiguousErrorMessages ? "Something went wrong. Please check your credentials." : msg);

      if (throwError) {
        throw error;
      }

      return error;
    };

    this._userQueryValidator = Match.Where(user => {
      check(user, {
        id: Match.Optional(NonEmptyString),
        username: Match.Optional(NonEmptyString),
        email: Match.Optional(NonEmptyString)
      });
      if (Object.keys(user).length !== 1) throw new Match.Error("User property must have exactly one field");
      return true;
    });
    this._server = server || Meteor.server; // Set up the server's methods, as if by calling Meteor.methods.

    this._initServerMethods();

    this._initAccountDataHooks(); // If autopublish is on, publish these user fields. Login service
    // packages (eg accounts-google) add to these by calling
    // addAutopublishFields.  Notably, this isn't implemented with multiple
    // publishes since DDP only merges only across top-level fields, not
    // subfields (such as 'services.facebook.accessToken')


    this._autopublishFields = {
      loggedInUser: ['profile', 'username', 'emails'],
      otherUsers: ['profile', 'username']
    }; // use object to keep the reference when used in functions
    // where _defaultPublishFields is destructured into lexical scope
    // for publish callbacks that need `this`

    this._defaultPublishFields = {
      projection: {
        profile: 1,
        username: 1,
        emails: 1
      }
    };

    this._initServerPublications(); // connectionId -> {connection, loginToken}


    this._accountData = {}; // connection id -> observe handle for the login token that this connection is
    // currently associated with, or a number. The number indicates that we are in
    // the process of setting up the observe (using a number instead of a single
    // sentinel allows multiple attempts to set up the observe to identify which
    // one was theirs).

    this._userObservesForConnections = {};
    this._nextUserObserveNumber = 1; // for the number described above.
    // list of all registered handlers.

    this._loginHandlers = [];
    setupUsersCollection(this.users);
    setupDefaultLoginHandlers(this);
    setExpireTokensInterval(this);
    this._validateLoginHook = new Hook({
      bindEnvironment: false
    });
    this._validateNewUserHooks = [defaultValidateNewUserHook.bind(this)];

    this._deleteSavedTokensForAllUsersOnStartup();

    this._skipCaseInsensitiveChecksForTest = {};
    this.urls = {
      resetPassword: (token, extraParams) => this.buildEmailUrl("#/reset-password/".concat(token), extraParams),
      verifyEmail: (token, extraParams) => this.buildEmailUrl("#/verify-email/".concat(token), extraParams),
      loginToken: (selector, token, extraParams) => this.buildEmailUrl("/?loginToken=".concat(token, "&selector=").concat(selector), extraParams),
      enrollAccount: (token, extraParams) => this.buildEmailUrl("#/enroll-account/".concat(token), extraParams)
    };
    this.addDefaultRateLimit();

    this.buildEmailUrl = function (path) {
      let extraParams = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : {};
      const url = new URL(Meteor.absoluteUrl(path));
      const params = Object.entries(extraParams);

      if (params.length > 0) {
        // Add additional parameters to the url
        for (const [key, value] of params) {
          url.searchParams.append(key, value);
        }
      }

      return url.toString();
    };
  } ///
  /// CURRENT USER
  ///
  // @override of "abstract" non-implementation in accounts_common.js


  userId() {
    // This function only works if called inside a method or a pubication.
    // Using any of the information from Meteor.user() in a method or
    // publish function will always use the value from when the function first
    // runs. This is likely not what the user expects. The way to make this work
    // in a method or publish function is to do Meteor.find(this.userId).observe
    // and recompute when the user record changes.
    const currentInvocation = DDP._CurrentMethodInvocation.get() || DDP._CurrentPublicationInvocation.get();

    if (!currentInvocation) throw new Error("Meteor.userId can only be invoked in method calls or publications.");
    return currentInvocation.userId;
  } ///
  /// LOGIN HOOKS
  ///

  /**
   * @summary Validate login attempts.
   * @locus Server
   * @param {Function} func Called whenever a login is attempted (either successful or unsuccessful).  A login can be aborted by returning a falsy value or throwing an exception.
   */


  validateLoginAttempt(func) {
    // Exceptions inside the hook callback are passed up to us.
    return this._validateLoginHook.register(func);
  }
  /**
   * @summary Set restrictions on new user creation.
   * @locus Server
   * @param {Function} func Called whenever a new user is created. Takes the new user object, and returns true to allow the creation or false to abort.
   */


  validateNewUser(func) {
    this._validateNewUserHooks.push(func);
  }
  /**
   * @summary Validate login from external service
   * @locus Server
   * @param {Function} func Called whenever login/user creation from external service is attempted. Login or user creation based on this login can be aborted by passing a falsy value or throwing an exception.
   */


  beforeExternalLogin(func) {
    if (this._beforeExternalLoginHook) {
      throw new Error("Can only call beforeExternalLogin once");
    }

    this._beforeExternalLoginHook = func;
  } ///
  /// CREATE USER HOOKS
  ///

  /**
   * @summary Customize login token creation.
   * @locus Server
   * @param {Function} func Called whenever a new token is created.
   * Return the sequence and the user object. Return true to keep sending the default email, or false to override the behavior.
   */


  /**
   * @summary Customize new user creation.
   * @locus Server
   * @param {Function} func Called whenever a new user is created. Return the new user object, or throw an `Error` to abort the creation.
   */
  onCreateUser(func) {
    if (this._onCreateUserHook) {
      throw new Error("Can only call onCreateUser once");
    }

    this._onCreateUserHook = func;
  }
  /**
   * @summary Customize oauth user profile updates
   * @locus Server
   * @param {Function} func Called whenever a user is logged in via oauth. Return the profile object to be merged, or throw an `Error` to abort the creation.
   */


  onExternalLogin(func) {
    if (this._onExternalLoginHook) {
      throw new Error("Can only call onExternalLogin once");
    }

    this._onExternalLoginHook = func;
  }
  /**
   * @summary Customize user selection on external logins
   * @locus Server
   * @param {Function} func Called whenever a user is logged in via oauth and a
   * user is not found with the service id. Return the user or undefined.
   */


  setAdditionalFindUserOnExternalLogin(func) {
    if (this._additionalFindUserOnExternalLogin) {
      throw new Error("Can only call setAdditionalFindUserOnExternalLogin once");
    }

    this._additionalFindUserOnExternalLogin = func;
  }

  _validateLogin(connection, attempt) {
    this._validateLoginHook.forEach(callback => {
      let ret;

      try {
        ret = callback(cloneAttemptWithConnection(connection, attempt));
      } catch (e) {
        attempt.allowed = false; // XXX this means the last thrown error overrides previous error
        // messages. Maybe this is surprising to users and we should make
        // overriding errors more explicit. (see
        // https://github.com/meteor/meteor/issues/1960)

        attempt.error = e;
        return true;
      }

      if (!ret) {
        attempt.allowed = false; // don't override a specific error provided by a previous
        // validator or the initial attempt (eg "incorrect password").

        if (!attempt.error) attempt.error = new Meteor.Error(403, "Login forbidden");
      }

      return true;
    });
  }

  _successfulLogin(connection, attempt) {
    this._onLoginHook.each(callback => {
      callback(cloneAttemptWithConnection(connection, attempt));
      return true;
    });
  }

  _failedLogin(connection, attempt) {
    this._onLoginFailureHook.each(callback => {
      callback(cloneAttemptWithConnection(connection, attempt));
      return true;
    });
  }

  _successfulLogout(connection, userId) {
    // don't fetch the user object unless there are some callbacks registered
    let user;

    this._onLogoutHook.each(callback => {
      if (!user && userId) user = this.users.findOne(userId, {
        fields: this._options.defaultFieldSelector
      });
      callback({
        user,
        connection
      });
      return true;
    });
  }

  ///
  /// LOGIN METHODS
  ///
  // Login methods return to the client an object containing these
  // fields when the user was logged in successfully:
  //
  //   id: userId
  //   token: *
  //   tokenExpires: *
  //
  // tokenExpires is optional and intends to provide a hint to the
  // client as to when the token will expire. If not provided, the
  // client will call Accounts._tokenExpiration, passing it the date
  // that it received the token.
  //
  // The login method will throw an error back to the client if the user
  // failed to log in.
  //
  //
  // Login handlers and service specific login methods such as
  // `createUser` internally return a `result` object containing these
  // fields:
  //
  //   type:
  //     optional string; the service name, overrides the handler
  //     default if present.
  //
  //   error:
  //     exception; if the user is not allowed to login, the reason why.
  //
  //   userId:
  //     string; the user id of the user attempting to login (if
  //     known), required for an allowed login.
  //
  //   options:
  //     optional object merged into the result returned by the login
  //     method; used by HAMK from SRP.
  //
  //   stampedLoginToken:
  //     optional object with `token` and `when` indicating the login
  //     token is already present in the database, returned by the
  //     "resume" login handler.
  //
  // For convenience, login methods can also throw an exception, which
  // is converted into an {error} result.  However, if the id of the
  // user attempting the login is known, a {userId, error} result should
  // be returned instead since the user id is not captured when an
  // exception is thrown.
  //
  // This internal `result` object is automatically converted into the
  // public {id, token, tokenExpires} object returned to the client.
  // Try a login method, converting thrown exceptions into an {error}
  // result.  The `type` argument is a default, inserted into the result
  // object if not explicitly returned.
  //
  // Log in a user on a connection.
  //
  // We use the method invocation to set the user id on the connection,
  // not the connection object directly. setUserId is tied to methods to
  // enforce clear ordering of method application (using wait methods on
  // the client, and a no setUserId after unblock restriction on the
  // server)
  //
  // The `stampedLoginToken` parameter is optional.  When present, it
  // indicates that the login token has already been inserted into the
  // database and doesn't need to be inserted again.  (It's used by the
  // "resume" login handler).
  _loginUser(methodInvocation, userId, stampedLoginToken) {
    if (!stampedLoginToken) {
      stampedLoginToken = this._generateStampedLoginToken();

      this._insertLoginToken(userId, stampedLoginToken);
    } // This order (and the avoidance of yields) is important to make
    // sure that when publish functions are rerun, they see a
    // consistent view of the world: the userId is set and matches
    // the login token on the connection (not that there is
    // currently a public API for reading the login token on a
    // connection).


    Meteor._noYieldsAllowed(() => this._setLoginToken(userId, methodInvocation.connection, this._hashLoginToken(stampedLoginToken.token)));

    methodInvocation.setUserId(userId);
    return {
      id: userId,
      token: stampedLoginToken.token,
      tokenExpires: this._tokenExpiration(stampedLoginToken.when)
    };
  }

  // After a login method has completed, call the login hooks.  Note
  // that `attemptLogin` is called for *all* login attempts, even ones
  // which aren't successful (such as an invalid password, etc).
  //
  // If the login is allowed and isn't aborted by a validate login hook
  // callback, log in the user.
  //
  _attemptLogin(methodInvocation, methodName, methodArgs, result) {
    if (!result) throw new Error("result is required"); // XXX A programming error in a login handler can lead to this occurring, and
    // then we don't call onLogin or onLoginFailure callbacks. Should
    // tryLoginMethod catch this case and turn it into an error?

    if (!result.userId && !result.error) throw new Error("A login method must specify a userId or an error");
    let user;
    if (result.userId) user = this.users.findOne(result.userId, {
      fields: this._options.defaultFieldSelector
    });
    const attempt = {
      type: result.type || "unknown",
      allowed: !!(result.userId && !result.error),
      methodName: methodName,
      methodArguments: Array.from(methodArgs)
    };

    if (result.error) {
      attempt.error = result.error;
    }

    if (user) {
      attempt.user = user;
    } // _validateLogin may mutate `attempt` by adding an error and changing allowed
    // to false, but that's the only change it can make (and the user's callbacks
    // only get a clone of `attempt`).


    this._validateLogin(methodInvocation.connection, attempt);

    if (attempt.allowed) {
      const ret = _objectSpread(_objectSpread({}, this._loginUser(methodInvocation, result.userId, result.stampedLoginToken)), result.options);

      ret.type = attempt.type;

      this._successfulLogin(methodInvocation.connection, attempt);

      return ret;
    } else {
      this._failedLogin(methodInvocation.connection, attempt);

      throw attempt.error;
    }
  }

  // All service specific login methods should go through this function.
  // Ensure that thrown exceptions are caught and that login hook
  // callbacks are still called.
  //
  _loginMethod(methodInvocation, methodName, methodArgs, type, fn) {
    return this._attemptLogin(methodInvocation, methodName, methodArgs, tryLoginMethod(type, fn));
  }

  // Report a login attempt failed outside the context of a normal login
  // method. This is for use in the case where there is a multi-step login
  // procedure (eg SRP based password login). If a method early in the
  // chain fails, it should call this function to report a failure. There
  // is no corresponding method for a successful login; methods that can
  // succeed at logging a user in should always be actual login methods
  // (using either Accounts._loginMethod or Accounts.registerLoginHandler).
  _reportLoginFailure(methodInvocation, methodName, methodArgs, result) {
    const attempt = {
      type: result.type || "unknown",
      allowed: false,
      error: result.error,
      methodName: methodName,
      methodArguments: Array.from(methodArgs)
    };

    if (result.userId) {
      attempt.user = this.users.findOne(result.userId, {
        fields: this._options.defaultFieldSelector
      });
    }

    this._validateLogin(methodInvocation.connection, attempt);

    this._failedLogin(methodInvocation.connection, attempt); // _validateLogin may mutate attempt to set a new error message. Return
    // the modified version.


    return attempt;
  }

  ///
  /// LOGIN HANDLERS
  ///
  // The main entry point for auth packages to hook in to login.
  //
  // A login handler is a login method which can return `undefined` to
  // indicate that the login request is not handled by this handler.
  //
  // @param name {String} Optional.  The service name, used by default
  // if a specific service name isn't returned in the result.
  //
  // @param handler {Function} A function that receives an options object
  // (as passed as an argument to the `login` method) and returns one of:
  // - `undefined`, meaning don't handle;
  // - a login method result object
  registerLoginHandler(name, handler) {
    if (!handler) {
      handler = name;
      name = null;
    }

    this._loginHandlers.push({
      name: name,
      handler: handler
    });
  }

  // Checks a user's credentials against all the registered login
  // handlers, and returns a login token if the credentials are valid. It
  // is like the login method, except that it doesn't set the logged-in
  // user on the connection. Throws a Meteor.Error if logging in fails,
  // including the case where none of the login handlers handled the login
  // request. Otherwise, returns {id: userId, token: *, tokenExpires: *}.
  //
  // For example, if you want to login with a plaintext password, `options` could be
  //   { user: { username: <username> }, password: <password> }, or
  //   { user: { email: <email> }, password: <password> }.
  // Try all of the registered login handlers until one of them doesn't
  // return `undefined`, meaning it handled this call to `login`. Return
  // that return value.
  _runLoginHandlers(methodInvocation, options) {
    for (let handler of this._loginHandlers) {
      const result = tryLoginMethod(handler.name, () => handler.handler.call(methodInvocation, options));

      if (result) {
        return result;
      }

      if (result !== undefined) {
        throw new Meteor.Error(400, "A login handler should return a result or undefined");
      }
    }

    return {
      type: null,
      error: new Meteor.Error(400, "Unrecognized options for login request")
    };
  }

  // Deletes the given loginToken from the database.
  //
  // For new-style hashed token, this will cause all connections
  // associated with the token to be closed.
  //
  // Any connections associated with old-style unhashed tokens will be
  // in the process of becoming associated with hashed tokens and then
  // they'll get closed.
  destroyToken(userId, loginToken) {
    this.users.update(userId, {
      $pull: {
        "services.resume.loginTokens": {
          $or: [{
            hashedToken: loginToken
          }, {
            token: loginToken
          }]
        }
      }
    });
  }

  _initServerMethods() {
    // The methods created in this function need to be created here so that
    // this variable is available in their scope.
    const accounts = this; // This object will be populated with methods and then passed to
    // accounts._server.methods further below.

    const methods = {}; // @returns {Object|null}
    //   If successful, returns {token: reconnectToken, id: userId}
    //   If unsuccessful (for example, if the user closed the oauth login popup),
    //     throws an error describing the reason

    methods.login = function (options) {
      // Login handlers should really also check whatever field they look at in
      // options, but we don't enforce it.
      check(options, Object);

      const result = accounts._runLoginHandlers(this, options);

      return accounts._attemptLogin(this, "login", arguments, result);
    };

    methods.logout = function () {
      const token = accounts._getLoginToken(this.connection.id);

      accounts._setLoginToken(this.userId, this.connection, null);

      if (token && this.userId) {
        accounts.destroyToken(this.userId, token);
      }

      accounts._successfulLogout(this.connection, this.userId);

      this.setUserId(null);
    }; // Generates a new login token with the same expiration as the
    // connection's current token and saves it to the database. Associates
    // the connection with this new token and returns it. Throws an error
    // if called on a connection that isn't logged in.
    //
    // @returns Object
    //   If successful, returns { token: <new token>, id: <user id>,
    //   tokenExpires: <expiration date> }.


    methods.getNewToken = function () {
      const user = accounts.users.findOne(this.userId, {
        fields: {
          "services.resume.loginTokens": 1
        }
      });

      if (!this.userId || !user) {
        throw new Meteor.Error("You are not logged in.");
      } // Be careful not to generate a new token that has a later
      // expiration than the curren token. Otherwise, a bad guy with a
      // stolen token could use this method to stop his stolen token from
      // ever expiring.


      const currentHashedToken = accounts._getLoginToken(this.connection.id);

      const currentStampedToken = user.services.resume.loginTokens.find(stampedToken => stampedToken.hashedToken === currentHashedToken);

      if (!currentStampedToken) {
        // safety belt: this should never happen
        throw new Meteor.Error("Invalid login token");
      }

      const newStampedToken = accounts._generateStampedLoginToken();

      newStampedToken.when = currentStampedToken.when;

      accounts._insertLoginToken(this.userId, newStampedToken);

      return accounts._loginUser(this, this.userId, newStampedToken);
    }; // Removes all tokens except the token associated with the current
    // connection. Throws an error if the connection is not logged
    // in. Returns nothing on success.


    methods.removeOtherTokens = function () {
      if (!this.userId) {
        throw new Meteor.Error("You are not logged in.");
      }

      const currentToken = accounts._getLoginToken(this.connection.id);

      accounts.users.update(this.userId, {
        $pull: {
          "services.resume.loginTokens": {
            hashedToken: {
              $ne: currentToken
            }
          }
        }
      });
    }; // Allow a one-time configuration for a login service. Modifications
    // to this collection are also allowed in insecure mode.


    methods.configureLoginService = options => {
      check(options, Match.ObjectIncluding({
        service: String
      })); // Don't let random users configure a service we haven't added yet (so
      // that when we do later add it, it's set up with their configuration
      // instead of ours).
      // XXX if service configuration is oauth-specific then this code should
      //     be in accounts-oauth; if it's not then the registry should be
      //     in this package

      if (!(accounts.oauth && accounts.oauth.serviceNames().includes(options.service))) {
        throw new Meteor.Error(403, "Service unknown");
      }

      const {
        ServiceConfiguration
      } = Package['service-configuration'];
      if (ServiceConfiguration.configurations.findOne({
        service: options.service
      })) throw new Meteor.Error(403, "Service ".concat(options.service, " already configured"));
      if (hasOwn.call(options, 'secret') && usingOAuthEncryption()) options.secret = OAuthEncryption.seal(options.secret);
      ServiceConfiguration.configurations.insert(options);
    };

    accounts._server.methods(methods);
  }

  _initAccountDataHooks() {
    this._server.onConnection(connection => {
      this._accountData[connection.id] = {
        connection: connection
      };
      connection.onClose(() => {
        this._removeTokenFromConnection(connection.id);

        delete this._accountData[connection.id];
      });
    });
  }

  _initServerPublications() {
    // Bring into lexical scope for publish callbacks that need `this`
    const {
      users,
      _autopublishFields,
      _defaultPublishFields
    } = this; // Publish all login service configuration fields other than secret.

    this._server.publish("meteor.loginServiceConfiguration", () => {
      const {
        ServiceConfiguration
      } = Package['service-configuration'];
      return ServiceConfiguration.configurations.find({}, {
        fields: {
          secret: 0
        }
      });
    }, {
      is_auto: true
    }); // not technically autopublish, but stops the warning.
    // Use Meteor.startup to give other packages a chance to call
    // setDefaultPublishFields.


    Meteor.startup(() => {
      // Merge custom fields selector and default publish fields so that the client
      // gets all the necessary fields to run properly
      const customFields = this._addDefaultFieldSelector().fields || {};
      const keys = Object.keys(customFields); // If the custom fields are negative, then ignore them and only send the necessary fields

      const fields = keys.length > 0 && customFields[keys[0]] ? _objectSpread(_objectSpread({}, this._addDefaultFieldSelector().fields), _defaultPublishFields.projection) : _defaultPublishFields.projection; // Publish the current user's record to the client.

      this._server.publish(null, function () {
        if (this.userId) {
          return users.find({
            _id: this.userId
          }, {
            fields
          });
        } else {
          return null;
        }
      },
      /*suppress autopublish warning*/
      {
        is_auto: true
      });
    }); // Use Meteor.startup to give other packages a chance to call
    // addAutopublishFields.

    Package.autopublish && Meteor.startup(() => {
      // ['profile', 'username'] -> {profile: 1, username: 1}
      const toFieldSelector = fields => fields.reduce((prev, field) => _objectSpread(_objectSpread({}, prev), {}, {
        [field]: 1
      }), {});

      this._server.publish(null, function () {
        if (this.userId) {
          return users.find({
            _id: this.userId
          }, {
            fields: toFieldSelector(_autopublishFields.loggedInUser)
          });
        } else {
          return null;
        }
      },
      /*suppress autopublish warning*/
      {
        is_auto: true
      }); // XXX this publish is neither dedup-able nor is it optimized by our special
      // treatment of queries on a specific _id. Therefore this will have O(n^2)
      // run-time performance every time a user document is changed (eg someone
      // logging in). If this is a problem, we can instead write a manual publish
      // function which filters out fields based on 'this.userId'.


      this._server.publish(null, function () {
        const selector = this.userId ? {
          _id: {
            $ne: this.userId
          }
        } : {};
        return users.find(selector, {
          fields: toFieldSelector(_autopublishFields.otherUsers)
        });
      },
      /*suppress autopublish warning*/
      {
        is_auto: true
      });
    });
  }

  // Add to the list of fields or subfields to be automatically
  // published if autopublish is on. Must be called from top-level
  // code (ie, before Meteor.startup hooks run).
  //
  // @param opts {Object} with:
  //   - forLoggedInUser {Array} Array of fields published to the logged-in user
  //   - forOtherUsers {Array} Array of fields published to users that aren't logged in
  addAutopublishFields(opts) {
    this._autopublishFields.loggedInUser.push.apply(this._autopublishFields.loggedInUser, opts.forLoggedInUser);

    this._autopublishFields.otherUsers.push.apply(this._autopublishFields.otherUsers, opts.forOtherUsers);
  }

  // Replaces the fields to be automatically
  // published when the user logs in
  //
  // @param {MongoFieldSpecifier} fields Dictionary of fields to return or exclude.
  setDefaultPublishFields(fields) {
    this._defaultPublishFields.projection = fields;
  }

  ///
  /// ACCOUNT DATA
  ///
  // HACK: This is used by 'meteor-accounts' to get the loginToken for a
  // connection. Maybe there should be a public way to do that.
  _getAccountData(connectionId, field) {
    const data = this._accountData[connectionId];
    return data && data[field];
  }

  _setAccountData(connectionId, field, value) {
    const data = this._accountData[connectionId]; // safety belt. shouldn't happen. accountData is set in onConnection,
    // we don't have a connectionId until it is set.

    if (!data) return;
    if (value === undefined) delete data[field];else data[field] = value;
  }

  ///
  /// RECONNECT TOKENS
  ///
  /// support reconnecting using a meteor login token
  _hashLoginToken(loginToken) {
    const hash = crypto.createHash('sha256');
    hash.update(loginToken);
    return hash.digest('base64');
  }

  // {token, when} => {hashedToken, when}
  _hashStampedToken(stampedToken) {
    const {
      token
    } = stampedToken,
          hashedStampedToken = _objectWithoutProperties(stampedToken, _excluded);

    return _objectSpread(_objectSpread({}, hashedStampedToken), {}, {
      hashedToken: this._hashLoginToken(token)
    });
  }

  // Using $addToSet avoids getting an index error if another client
  // logging in simultaneously has already inserted the new hashed
  // token.
  _insertHashedLoginToken(userId, hashedToken, query) {
    query = query ? _objectSpread({}, query) : {};
    query._id = userId;
    this.users.update(query, {
      $addToSet: {
        "services.resume.loginTokens": hashedToken
      }
    });
  }

  // Exported for tests.
  _insertLoginToken(userId, stampedToken, query) {
    this._insertHashedLoginToken(userId, this._hashStampedToken(stampedToken), query);
  }

  _clearAllLoginTokens(userId) {
    this.users.update(userId, {
      $set: {
        'services.resume.loginTokens': []
      }
    });
  }

  // test hook
  _getUserObserve(connectionId) {
    return this._userObservesForConnections[connectionId];
  }

  // Clean up this connection's association with the token: that is, stop
  // the observe that we started when we associated the connection with
  // this token.
  _removeTokenFromConnection(connectionId) {
    if (hasOwn.call(this._userObservesForConnections, connectionId)) {
      const observe = this._userObservesForConnections[connectionId];

      if (typeof observe === 'number') {
        // We're in the process of setting up an observe for this connection. We
        // can't clean up that observe yet, but if we delete the placeholder for
        // this connection, then the observe will get cleaned up as soon as it has
        // been set up.
        delete this._userObservesForConnections[connectionId];
      } else {
        delete this._userObservesForConnections[connectionId];
        observe.stop();
      }
    }
  }

  _getLoginToken(connectionId) {
    return this._getAccountData(connectionId, 'loginToken');
  }

  // newToken is a hashed token.
  _setLoginToken(userId, connection, newToken) {
    this._removeTokenFromConnection(connection.id);

    this._setAccountData(connection.id, 'loginToken', newToken);

    if (newToken) {
      // Set up an observe for this token. If the token goes away, we need
      // to close the connection.  We defer the observe because there's
      // no need for it to be on the critical path for login; we just need
      // to ensure that the connection will get closed at some point if
      // the token gets deleted.
      //
      // Initially, we set the observe for this connection to a number; this
      // signifies to other code (which might run while we yield) that we are in
      // the process of setting up an observe for this connection. Once the
      // observe is ready to go, we replace the number with the real observe
      // handle (unless the placeholder has been deleted or replaced by a
      // different placehold number, signifying that the connection was closed
      // already -- in this case we just clean up the observe that we started).
      const myObserveNumber = ++this._nextUserObserveNumber;
      this._userObservesForConnections[connection.id] = myObserveNumber;
      Meteor.defer(() => {
        // If something else happened on this connection in the meantime (it got
        // closed, or another call to _setLoginToken happened), just do
        // nothing. We don't need to start an observe for an old connection or old
        // token.
        if (this._userObservesForConnections[connection.id] !== myObserveNumber) {
          return;
        }

        let foundMatchingUser; // Because we upgrade unhashed login tokens to hashed tokens at
        // login time, sessions will only be logged in with a hashed
        // token. Thus we only need to observe hashed tokens here.

        const observe = this.users.find({
          _id: userId,
          'services.resume.loginTokens.hashedToken': newToken
        }, {
          fields: {
            _id: 1
          }
        }).observeChanges({
          added: () => {
            foundMatchingUser = true;
          },
          removed: connection.close // The onClose callback for the connection takes care of
          // cleaning up the observe handle and any other state we have
          // lying around.

        }, {
          nonMutatingCallbacks: true
        }); // If the user ran another login or logout command we were waiting for the
        // defer or added to fire (ie, another call to _setLoginToken occurred),
        // then we let the later one win (start an observe, etc) and just stop our
        // observe now.
        //
        // Similarly, if the connection was already closed, then the onClose
        // callback would have called _removeTokenFromConnection and there won't
        // be an entry in _userObservesForConnections. We can stop the observe.

        if (this._userObservesForConnections[connection.id] !== myObserveNumber) {
          observe.stop();
          return;
        }

        this._userObservesForConnections[connection.id] = observe;

        if (!foundMatchingUser) {
          // We've set up an observe on the user associated with `newToken`,
          // so if the new token is removed from the database, we'll close
          // the connection. But the token might have already been deleted
          // before we set up the observe, which wouldn't have closed the
          // connection because the observe wasn't running yet.
          connection.close();
        }
      });
    }
  }

  // (Also used by Meteor Accounts server and tests).
  //
  _generateStampedLoginToken() {
    return {
      token: Random.secret(),
      when: new Date()
    };
  }

  ///
  /// TOKEN EXPIRATION
  ///
  // Deletes expired password reset tokens from the database.
  //
  // Exported for tests. Also, the arguments are only used by
  // tests. oldestValidDate is simulate expiring tokens without waiting
  // for them to actually expire. userId is used by tests to only expire
  // tokens for the test user.
  _expirePasswordResetTokens(oldestValidDate, userId) {
    const tokenLifetimeMs = this._getPasswordResetTokenLifetimeMs(); // when calling from a test with extra arguments, you must specify both!


    if (oldestValidDate && !userId || !oldestValidDate && userId) {
      throw new Error("Bad test. Must specify both oldestValidDate and userId.");
    }

    oldestValidDate = oldestValidDate || new Date(new Date() - tokenLifetimeMs);
    const tokenFilter = {
      $or: [{
        "services.password.reset.reason": "reset"
      }, {
        "services.password.reset.reason": {
          $exists: false
        }
      }]
    };
    expirePasswordToken(this, oldestValidDate, tokenFilter, userId);
  } // Deletes expired password enroll tokens from the database.
  //
  // Exported for tests. Also, the arguments are only used by
  // tests. oldestValidDate is simulate expiring tokens without waiting
  // for them to actually expire. userId is used by tests to only expire
  // tokens for the test user.


  _expirePasswordEnrollTokens(oldestValidDate, userId) {
    const tokenLifetimeMs = this._getPasswordEnrollTokenLifetimeMs(); // when calling from a test with extra arguments, you must specify both!


    if (oldestValidDate && !userId || !oldestValidDate && userId) {
      throw new Error("Bad test. Must specify both oldestValidDate and userId.");
    }

    oldestValidDate = oldestValidDate || new Date(new Date() - tokenLifetimeMs);
    const tokenFilter = {
      "services.password.enroll.reason": "enroll"
    };
    expirePasswordToken(this, oldestValidDate, tokenFilter, userId);
  } // Deletes expired tokens from the database and closes all open connections
  // associated with these tokens.
  //
  // Exported for tests. Also, the arguments are only used by
  // tests. oldestValidDate is simulate expiring tokens without waiting
  // for them to actually expire. userId is used by tests to only expire
  // tokens for the test user.


  _expireTokens(oldestValidDate, userId) {
    const tokenLifetimeMs = this._getTokenLifetimeMs(); // when calling from a test with extra arguments, you must specify both!


    if (oldestValidDate && !userId || !oldestValidDate && userId) {
      throw new Error("Bad test. Must specify both oldestValidDate and userId.");
    }

    oldestValidDate = oldestValidDate || new Date(new Date() - tokenLifetimeMs);
    const userFilter = userId ? {
      _id: userId
    } : {}; // Backwards compatible with older versions of meteor that stored login token
    // timestamps as numbers.

    this.users.update(_objectSpread(_objectSpread({}, userFilter), {}, {
      $or: [{
        "services.resume.loginTokens.when": {
          $lt: oldestValidDate
        }
      }, {
        "services.resume.loginTokens.when": {
          $lt: +oldestValidDate
        }
      }]
    }), {
      $pull: {
        "services.resume.loginTokens": {
          $or: [{
            when: {
              $lt: oldestValidDate
            }
          }, {
            when: {
              $lt: +oldestValidDate
            }
          }]
        }
      }
    }, {
      multi: true
    }); // The observe on Meteor.users will take care of closing connections for
    // expired tokens.
  }

  // @override from accounts_common.js
  config(options) {
    // Call the overridden implementation of the method.
    const superResult = AccountsCommon.prototype.config.apply(this, arguments); // If the user set loginExpirationInDays to null, then we need to clear the
    // timer that periodically expires tokens.

    if (hasOwn.call(this._options, 'loginExpirationInDays') && this._options.loginExpirationInDays === null && this.expireTokenInterval) {
      Meteor.clearInterval(this.expireTokenInterval);
      this.expireTokenInterval = null;
    }

    return superResult;
  }

  // Called by accounts-password
  insertUserDoc(options, user) {
    // - clone user document, to protect from modification
    // - add createdAt timestamp
    // - prepare an _id, so that you can modify other collections (eg
    // create a first task for every new user)
    //
    // XXX If the onCreateUser or validateNewUser hooks fail, we might
    // end up having modified some other collection
    // inappropriately. The solution is probably to have onCreateUser
    // accept two callbacks - one that gets called before inserting
    // the user document (in which you can modify its contents), and
    // one that gets called after (in which you should change other
    // collections)
    user = _objectSpread({
      createdAt: new Date(),
      _id: Random.id()
    }, user);

    if (user.services) {
      Object.keys(user.services).forEach(service => pinEncryptedFieldsToUser(user.services[service], user._id));
    }

    let fullUser;

    if (this._onCreateUserHook) {
      fullUser = this._onCreateUserHook(options, user); // This is *not* part of the API. We need this because we can't isolate
      // the global server environment between tests, meaning we can't test
      // both having a create user hook set and not having one set.

      if (fullUser === 'TEST DEFAULT HOOK') fullUser = defaultCreateUserHook(options, user);
    } else {
      fullUser = defaultCreateUserHook(options, user);
    }

    this._validateNewUserHooks.forEach(hook => {
      if (!hook(fullUser)) throw new Meteor.Error(403, "User validation failed");
    });

    let userId;

    try {
      userId = this.users.insert(fullUser);
    } catch (e) {
      // XXX string parsing sucks, maybe
      // https://jira.mongodb.org/browse/SERVER-3069 will get fixed one day
      // https://jira.mongodb.org/browse/SERVER-4637
      if (!e.errmsg) throw e;
      if (e.errmsg.includes('emails.address')) throw new Meteor.Error(403, "Email already exists.");
      if (e.errmsg.includes('username')) throw new Meteor.Error(403, "Username already exists.");
      throw e;
    }

    return userId;
  }

  // Helper function: returns false if email does not match company domain from
  // the configuration.
  _testEmailDomain(email) {
    const domain = this._options.restrictCreationByEmailDomain;
    return !domain || typeof domain === 'function' && domain(email) || typeof domain === 'string' && new RegExp("@".concat(Meteor._escapeRegExp(domain), "$"), 'i').test(email);
  }

  ///
  /// CLEAN UP FOR `logoutOtherClients`
  ///
  _deleteSavedTokensForUser(userId, tokensToDelete) {
    if (tokensToDelete) {
      this.users.update(userId, {
        $unset: {
          "services.resume.haveLoginTokensToDelete": 1,
          "services.resume.loginTokensToDelete": 1
        },
        $pullAll: {
          "services.resume.loginTokens": tokensToDelete
        }
      });
    }
  }

  _deleteSavedTokensForAllUsersOnStartup() {
    // If we find users who have saved tokens to delete on startup, delete
    // them now. It's possible that the server could have crashed and come
    // back up before new tokens are found in localStorage, but this
    // shouldn't happen very often. We shouldn't put a delay here because
    // that would give a lot of power to an attacker with a stolen login
    // token and the ability to crash the server.
    Meteor.startup(() => {
      this.users.find({
        "services.resume.haveLoginTokensToDelete": true
      }, {
        fields: {
          "services.resume.loginTokensToDelete": 1
        }
      }).forEach(user => {
        this._deleteSavedTokensForUser(user._id, user.services.resume.loginTokensToDelete);
      });
    });
  }

  ///
  /// MANAGING USER OBJECTS
  ///
  // Updates or creates a user after we authenticate with a 3rd party.
  //
  // @param serviceName {String} Service name (eg, twitter).
  // @param serviceData {Object} Data to store in the user's record
  //        under services[serviceName]. Must include an "id" field
  //        which is a unique identifier for the user in the service.
  // @param options {Object, optional} Other options to pass to insertUserDoc
  //        (eg, profile)
  // @returns {Object} Object with token and id keys, like the result
  //        of the "login" method.
  //
  updateOrCreateUserFromExternalService(serviceName, serviceData, options) {
    options = _objectSpread({}, options);

    if (serviceName === "password" || serviceName === "resume") {
      throw new Error("Can't use updateOrCreateUserFromExternalService with internal service " + serviceName);
    }

    if (!hasOwn.call(serviceData, 'id')) {
      throw new Error("Service data for service ".concat(serviceName, " must include id"));
    } // Look for a user with the appropriate service user id.


    const selector = {};
    const serviceIdKey = "services.".concat(serviceName, ".id"); // XXX Temporary special case for Twitter. (Issue #629)
    //   The serviceData.id will be a string representation of an integer.
    //   We want it to match either a stored string or int representation.
    //   This is to cater to earlier versions of Meteor storing twitter
    //   user IDs in number form, and recent versions storing them as strings.
    //   This can be removed once migration technology is in place, and twitter
    //   users stored with integer IDs have been migrated to string IDs.

    if (serviceName === "twitter" && !isNaN(serviceData.id)) {
      selector["$or"] = [{}, {}];
      selector["$or"][0][serviceIdKey] = serviceData.id;
      selector["$or"][1][serviceIdKey] = parseInt(serviceData.id, 10);
    } else {
      selector[serviceIdKey] = serviceData.id;
    }

    let user = this.users.findOne(selector, {
      fields: this._options.defaultFieldSelector
    }); // Check to see if the developer has a custom way to find the user outside
    // of the general selectors above.

    if (!user && this._additionalFindUserOnExternalLogin) {
      user = this._additionalFindUserOnExternalLogin({
        serviceName,
        serviceData,
        options
      });
    } // Before continuing, run user hook to see if we should continue


    if (this._beforeExternalLoginHook && !this._beforeExternalLoginHook(serviceName, serviceData, user)) {
      throw new Meteor.Error(403, "Login forbidden");
    } // When creating a new user we pass through all options. When updating an
    // existing user, by default we only process/pass through the serviceData
    // (eg, so that we keep an unexpired access token and don't cache old email
    // addresses in serviceData.email). The onExternalLogin hook can be used when
    // creating or updating a user, to modify or pass through more options as
    // needed.


    let opts = user ? {} : options;

    if (this._onExternalLoginHook) {
      opts = this._onExternalLoginHook(options, user);
    }

    if (user) {
      pinEncryptedFieldsToUser(serviceData, user._id);
      let setAttrs = {};
      Object.keys(serviceData).forEach(key => setAttrs["services.".concat(serviceName, ".").concat(key)] = serviceData[key]); // XXX Maybe we should re-use the selector above and notice if the update
      //     touches nothing?

      setAttrs = _objectSpread(_objectSpread({}, setAttrs), opts);
      this.users.update(user._id, {
        $set: setAttrs
      });
      return {
        type: serviceName,
        userId: user._id
      };
    } else {
      // Create a new user with the service data.
      user = {
        services: {}
      };
      user.services[serviceName] = serviceData;
      return {
        type: serviceName,
        userId: this.insertUserDoc(opts, user)
      };
    }
  }

  // Removes default rate limiting rule
  removeDefaultRateLimit() {
    const resp = DDPRateLimiter.removeRule(this.defaultRateLimiterRuleId);
    this.defaultRateLimiterRuleId = null;
    return resp;
  }

  // Add a default rule of limiting logins, creating new users and password reset
  // to 5 times every 10 seconds per connection.
  addDefaultRateLimit() {
    if (!this.defaultRateLimiterRuleId) {
      this.defaultRateLimiterRuleId = DDPRateLimiter.addRule({
        userId: null,
        clientAddress: null,
        type: 'method',
        name: name => ['login', 'createUser', 'resetPassword', 'forgotPassword'].includes(name),
        connectionId: connectionId => true
      }, 5, 10000);
    }
  }

  /**
   * @summary Creates options for email sending for reset password and enroll account emails.
   * You can use this function when customizing a reset password or enroll account email sending.
   * @locus Server
   * @param {Object} email Which address of the user's to send the email to.
   * @param {Object} user The user object to generate options for.
   * @param {String} url URL to which user is directed to confirm the email.
   * @param {String} reason `resetPassword` or `enrollAccount`.
   * @returns {Object} Options which can be passed to `Email.send`.
   * @importFromPackage accounts-base
   */
  generateOptionsForEmail(email, user, url, reason) {
    let extra = arguments.length > 4 && arguments[4] !== undefined ? arguments[4] : {};
    const options = {
      to: email,
      from: this.emailTemplates[reason].from ? this.emailTemplates[reason].from(user) : this.emailTemplates.from,
      subject: this.emailTemplates[reason].subject(user, url, extra)
    };

    if (typeof this.emailTemplates[reason].text === 'function') {
      options.text = this.emailTemplates[reason].text(user, url, extra);
    }

    if (typeof this.emailTemplates[reason].html === 'function') {
      options.html = this.emailTemplates[reason].html(user, url, extra);
    }

    if (typeof this.emailTemplates.headers === 'object') {
      options.headers = this.emailTemplates.headers;
    }

    return options;
  }

  _checkForCaseInsensitiveDuplicates(fieldName, displayName, fieldValue, ownUserId) {
    // Some tests need the ability to add users with the same case insensitive
    // value, hence the _skipCaseInsensitiveChecksForTest check
    const skipCheck = Object.prototype.hasOwnProperty.call(this._skipCaseInsensitiveChecksForTest, fieldValue);

    if (fieldValue && !skipCheck) {
      const matchedUsers = Meteor.users.find(this._selectorForFastCaseInsensitiveLookup(fieldName, fieldValue), {
        fields: {
          _id: 1
        },
        // we only need a maximum of 2 users for the logic below to work
        limit: 2
      }).fetch();

      if (matchedUsers.length > 0 && ( // If we don't have a userId yet, any match we find is a duplicate
      !ownUserId || // Otherwise, check to see if there are multiple matches or a match
      // that is not us
      matchedUsers.length > 1 || matchedUsers[0]._id !== ownUserId)) {
        this._handleError("".concat(displayName, " already exists."));
      }
    }
  }

  _createUserCheckingDuplicates(_ref) {
    let {
      user,
      email,
      username,
      options
    } = _ref;

    const newUser = _objectSpread(_objectSpread(_objectSpread({}, user), username ? {
      username
    } : {}), email ? {
      emails: [{
        address: email,
        verified: false
      }]
    } : {}); // Perform a case insensitive check before insert


    this._checkForCaseInsensitiveDuplicates('username', 'Username', username);

    this._checkForCaseInsensitiveDuplicates('emails.address', 'Email', email);

    const userId = this.insertUserDoc(options, newUser); // Perform another check after insert, in case a matching user has been
    // inserted in the meantime

    try {
      this._checkForCaseInsensitiveDuplicates('username', 'Username', username, userId);

      this._checkForCaseInsensitiveDuplicates('emails.address', 'Email', email, userId);
    } catch (ex) {
      // Remove inserted user if the check fails
      Meteor.users.remove(userId);
      throw ex;
    }

    return userId;
  }

}

// Give each login hook callback a fresh cloned copy of the attempt
// object, but don't clone the connection.
//
const cloneAttemptWithConnection = (connection, attempt) => {
  const clonedAttempt = EJSON.clone(attempt);
  clonedAttempt.connection = connection;
  return clonedAttempt;
};

const tryLoginMethod = (type, fn) => {
  let result;

  try {
    result = fn();
  } catch (e) {
    result = {
      error: e
    };
  }

  if (result && !result.type && type) result.type = type;
  return result;
};

const setupDefaultLoginHandlers = accounts => {
  accounts.registerLoginHandler("resume", function (options) {
    return defaultResumeLoginHandler.call(this, accounts, options);
  });
}; // Login handler for resume tokens.


const defaultResumeLoginHandler = (accounts, options) => {
  if (!options.resume) return undefined;
  check(options.resume, String);

  const hashedToken = accounts._hashLoginToken(options.resume); // First look for just the new-style hashed login token, to avoid
  // sending the unhashed token to the database in a query if we don't
  // need to.


  let user = accounts.users.findOne({
    "services.resume.loginTokens.hashedToken": hashedToken
  }, {
    fields: {
      "services.resume.loginTokens.$": 1
    }
  });

  if (!user) {
    // If we didn't find the hashed login token, try also looking for
    // the old-style unhashed token.  But we need to look for either
    // the old-style token OR the new-style token, because another
    // client connection logging in simultaneously might have already
    // converted the token.
    user = accounts.users.findOne({
      $or: [{
        "services.resume.loginTokens.hashedToken": hashedToken
      }, {
        "services.resume.loginTokens.token": options.resume
      }]
    }, // Note: Cannot use ...loginTokens.$ positional operator with $or query.
    {
      fields: {
        "services.resume.loginTokens": 1
      }
    });
  }

  if (!user) return {
    error: new Meteor.Error(403, "You've been logged out by the server. Please log in again.")
  }; // Find the token, which will either be an object with fields
  // {hashedToken, when} for a hashed token or {token, when} for an
  // unhashed token.

  let oldUnhashedStyleToken;
  let token = user.services.resume.loginTokens.find(token => token.hashedToken === hashedToken);

  if (token) {
    oldUnhashedStyleToken = false;
  } else {
    token = user.services.resume.loginTokens.find(token => token.token === options.resume);
    oldUnhashedStyleToken = true;
  }

  const tokenExpires = accounts._tokenExpiration(token.when);

  if (new Date() >= tokenExpires) return {
    userId: user._id,
    error: new Meteor.Error(403, "Your session has expired. Please log in again.")
  }; // Update to a hashed token when an unhashed token is encountered.

  if (oldUnhashedStyleToken) {
    // Only add the new hashed token if the old unhashed token still
    // exists (this avoids resurrecting the token if it was deleted
    // after we read it).  Using $addToSet avoids getting an index
    // error if another client logging in simultaneously has already
    // inserted the new hashed token.
    accounts.users.update({
      _id: user._id,
      "services.resume.loginTokens.token": options.resume
    }, {
      $addToSet: {
        "services.resume.loginTokens": {
          "hashedToken": hashedToken,
          "when": token.when
        }
      }
    }); // Remove the old token *after* adding the new, since otherwise
    // another client trying to login between our removing the old and
    // adding the new wouldn't find a token to login with.

    accounts.users.update(user._id, {
      $pull: {
        "services.resume.loginTokens": {
          "token": options.resume
        }
      }
    });
  }

  return {
    userId: user._id,
    stampedLoginToken: {
      token: options.resume,
      when: token.when
    }
  };
};

const expirePasswordToken = (accounts, oldestValidDate, tokenFilter, userId) => {
  // boolean value used to determine if this method was called from enroll account workflow
  let isEnroll = false;
  const userFilter = userId ? {
    _id: userId
  } : {}; // check if this method was called from enroll account workflow

  if (tokenFilter['services.password.enroll.reason']) {
    isEnroll = true;
  }

  let resetRangeOr = {
    $or: [{
      "services.password.reset.when": {
        $lt: oldestValidDate
      }
    }, {
      "services.password.reset.when": {
        $lt: +oldestValidDate
      }
    }]
  };

  if (isEnroll) {
    resetRangeOr = {
      $or: [{
        "services.password.enroll.when": {
          $lt: oldestValidDate
        }
      }, {
        "services.password.enroll.when": {
          $lt: +oldestValidDate
        }
      }]
    };
  }

  const expireFilter = {
    $and: [tokenFilter, resetRangeOr]
  };

  if (isEnroll) {
    accounts.users.update(_objectSpread(_objectSpread({}, userFilter), expireFilter), {
      $unset: {
        "services.password.enroll": ""
      }
    }, {
      multi: true
    });
  } else {
    accounts.users.update(_objectSpread(_objectSpread({}, userFilter), expireFilter), {
      $unset: {
        "services.password.reset": ""
      }
    }, {
      multi: true
    });
  }
};

const setExpireTokensInterval = accounts => {
  accounts.expireTokenInterval = Meteor.setInterval(() => {
    accounts._expireTokens();

    accounts._expirePasswordResetTokens();

    accounts._expirePasswordEnrollTokens();
  }, EXPIRE_TOKENS_INTERVAL_MS);
}; ///
/// OAuth Encryption Support
///


const OAuthEncryption = Package["oauth-encryption"] && Package["oauth-encryption"].OAuthEncryption;

const usingOAuthEncryption = () => {
  return OAuthEncryption && OAuthEncryption.keyIsLoaded();
}; // OAuth service data is temporarily stored in the pending credentials
// collection during the oauth authentication process.  Sensitive data
// such as access tokens are encrypted without the user id because
// we don't know the user id yet.  We re-encrypt these fields with the
// user id included when storing the service data permanently in
// the users collection.
//


const pinEncryptedFieldsToUser = (serviceData, userId) => {
  Object.keys(serviceData).forEach(key => {
    let value = serviceData[key];
    if (OAuthEncryption && OAuthEncryption.isSealed(value)) value = OAuthEncryption.seal(OAuthEncryption.open(value), userId);
    serviceData[key] = value;
  });
}; // Encrypt unencrypted login service secrets when oauth-encryption is
// added.
//
// XXX For the oauthSecretKey to be available here at startup, the
// developer must call Accounts.config({oauthSecretKey: ...}) at load
// time, instead of in a Meteor.startup block, because the startup
// block in the app code will run after this accounts-base startup
// block.  Perhaps we need a post-startup callback?


Meteor.startup(() => {
  if (!usingOAuthEncryption()) {
    return;
  }

  const {
    ServiceConfiguration
  } = Package['service-configuration'];
  ServiceConfiguration.configurations.find({
    $and: [{
      secret: {
        $exists: true
      }
    }, {
      "secret.algorithm": {
        $exists: false
      }
    }]
  }).forEach(config => {
    ServiceConfiguration.configurations.update(config._id, {
      $set: {
        secret: OAuthEncryption.seal(config.secret)
      }
    });
  });
}); // XXX see comment on Accounts.createUser in passwords_server about adding a
// second "server options" argument.

const defaultCreateUserHook = (options, user) => {
  if (options.profile) user.profile = options.profile;
  return user;
}; // Validate new user's email or Google/Facebook/GitHub account's email


function defaultValidateNewUserHook(user) {
  const domain = this._options.restrictCreationByEmailDomain;

  if (!domain) {
    return true;
  }

  let emailIsGood = false;

  if (user.emails && user.emails.length > 0) {
    emailIsGood = user.emails.reduce((prev, email) => prev || this._testEmailDomain(email.address), false);
  } else if (user.services && Object.values(user.services).length > 0) {
    // Find any email of any service and check it
    emailIsGood = Object.values(user.services).reduce((prev, service) => service.email && this._testEmailDomain(service.email), false);
  }

  if (emailIsGood) {
    return true;
  }

  if (typeof domain === 'string') {
    throw new Meteor.Error(403, "@".concat(domain, " email required"));
  } else {
    throw new Meteor.Error(403, "Email doesn't match the criteria.");
  }
}

const setupUsersCollection = users => {
  ///
  /// RESTRICTING WRITES TO USER OBJECTS
  ///
  users.allow({
    // clients can modify the profile field of their own document, and
    // nothing else.
    update: (userId, user, fields, modifier) => {
      // make sure it is our record
      if (user._id !== userId) {
        return false;
      } // user can only modify the 'profile' field. sets to multiple
      // sub-keys (eg profile.foo and profile.bar) are merged into entry
      // in the fields list.


      if (fields.length !== 1 || fields[0] !== 'profile') {
        return false;
      }

      return true;
    },
    fetch: ['_id'] // we only look at _id.

  }); /// DEFAULT INDEXES ON USERS

  users.createIndex('username', {
    unique: true,
    sparse: true
  });
  users.createIndex('emails.address', {
    unique: true,
    sparse: true
  });
  users.createIndex('services.resume.loginTokens.hashedToken', {
    unique: true,
    sparse: true
  });
  users.createIndex('services.resume.loginTokens.token', {
    unique: true,
    sparse: true
  }); // For taking care of logoutOtherClients calls that crashed before the
  // tokens were deleted.

  users.createIndex('services.resume.haveLoginTokensToDelete', {
    sparse: true
  }); // For expiring login tokens

  users.createIndex("services.resume.loginTokens.when", {
    sparse: true
  }); // For expiring password tokens

  users.createIndex('services.password.reset.when', {
    sparse: true
  });
  users.createIndex('services.password.enroll.when', {
    sparse: true
  });
}; // Generates permutations of all case variations of a given string.


const generateCasePermutationsForString = string => {
  let permutations = [''];

  for (let i = 0; i < string.length; i++) {
    const ch = string.charAt(i);
    permutations = [].concat(...permutations.map(prefix => {
      const lowerCaseChar = ch.toLowerCase();
      const upperCaseChar = ch.toUpperCase(); // Don't add unnecessary permutations when ch is not a letter

      if (lowerCaseChar === upperCaseChar) {
        return [prefix + ch];
      } else {
        return [prefix + lowerCaseChar, prefix + upperCaseChar];
      }
    }));
  }

  return permutations;
};
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}}}}},{
  "extensions": [
    ".js",
    ".json"
  ]
});

var exports = require("/node_modules/meteor/accounts-base/server_main.js");

/* Exports */
Package._define("accounts-base", exports, {
  Accounts: Accounts
});

})();

//# sourceURL=meteor://💻app/packages/accounts-base.js
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvYWNjb3VudHMtYmFzZS9zZXJ2ZXJfbWFpbi5qcyIsIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvYWNjb3VudHMtYmFzZS9hY2NvdW50c19jb21tb24uanMiLCJtZXRlb3I6Ly/wn5K7YXBwL3BhY2thZ2VzL2FjY291bnRzLWJhc2UvYWNjb3VudHNfc2VydmVyLmpzIl0sIm5hbWVzIjpbIm1vZHVsZTEiLCJleHBvcnQiLCJBY2NvdW50c1NlcnZlciIsImxpbmsiLCJ2IiwiQWNjb3VudHMiLCJNZXRlb3IiLCJzZXJ2ZXIiLCJ1c2VycyIsIl9vYmplY3RTcHJlYWQiLCJtb2R1bGUiLCJkZWZhdWx0IiwiQWNjb3VudHNDb21tb24iLCJFWFBJUkVfVE9LRU5TX0lOVEVSVkFMX01TIiwiQ09OTkVDVElPTl9DTE9TRV9ERUxBWV9NUyIsIlZBTElEX0NPTkZJR19LRVlTIiwiY29uc3RydWN0b3IiLCJvcHRpb25zIiwiX29wdGlvbnMiLCJjb25uZWN0aW9uIiwidW5kZWZpbmVkIiwiX2luaXRDb25uZWN0aW9uIiwiTW9uZ28iLCJDb2xsZWN0aW9uIiwiX3ByZXZlbnRBdXRvcHVibGlzaCIsIl9vbkxvZ2luSG9vayIsIkhvb2siLCJiaW5kRW52aXJvbm1lbnQiLCJkZWJ1Z1ByaW50RXhjZXB0aW9ucyIsIl9vbkxvZ2luRmFpbHVyZUhvb2siLCJfb25Mb2dvdXRIb29rIiwiREVGQVVMVF9MT0dJTl9FWFBJUkFUSU9OX0RBWVMiLCJMT0dJTl9VTkVYUElSSU5HX1RPS0VOX0RBWVMiLCJsY2VOYW1lIiwiTG9naW5DYW5jZWxsZWRFcnJvciIsIm1ha2VFcnJvclR5cGUiLCJkZXNjcmlwdGlvbiIsIm1lc3NhZ2UiLCJwcm90b3R5cGUiLCJuYW1lIiwibnVtZXJpY0Vycm9yIiwic3RhcnR1cCIsIlNlcnZpY2VDb25maWd1cmF0aW9uIiwiUGFja2FnZSIsImxvZ2luU2VydmljZUNvbmZpZ3VyYXRpb24iLCJjb25maWd1cmF0aW9ucyIsIkNvbmZpZ0Vycm9yIiwic2V0dGluZ3MiLCJwYWNrYWdlcyIsIm9hdXRoU2VjcmV0S2V5IiwiRXJyb3IiLCJPQXV0aEVuY3J5cHRpb24iLCJsb2FkS2V5IiwiT2JqZWN0Iiwia2V5cyIsImZvckVhY2giLCJrZXkiLCJpbmNsdWRlcyIsInVzZXJJZCIsIl9hZGREZWZhdWx0RmllbGRTZWxlY3RvciIsImRlZmF1bHRGaWVsZFNlbGVjdG9yIiwiZmllbGRzIiwibGVuZ3RoIiwia2V5czIiLCJ1c2VyIiwiZmluZE9uZSIsImNvbmZpZyIsImlzU2VydmVyIiwiX19tZXRlb3JfcnVudGltZV9jb25maWdfXyIsImFjY291bnRzQ29uZmlnQ2FsbGVkIiwiX2RlYnVnIiwiaGFzT3duUHJvcGVydHkiLCJjYWxsIiwiaXNDbGllbnQiLCJvbkxvZ2luIiwiZnVuYyIsInJldCIsInJlZ2lzdGVyIiwiX3N0YXJ0dXBDYWxsYmFjayIsImNhbGxiYWNrIiwib25Mb2dpbkZhaWx1cmUiLCJvbkxvZ291dCIsImRkcFVybCIsIkREUCIsImNvbm5lY3QiLCJBQ0NPVU5UU19DT05ORUNUSU9OX1VSTCIsIl9nZXRUb2tlbkxpZmV0aW1lTXMiLCJsb2dpbkV4cGlyYXRpb25JbkRheXMiLCJsb2dpbkV4cGlyYXRpb24iLCJfZ2V0UGFzc3dvcmRSZXNldFRva2VuTGlmZXRpbWVNcyIsInBhc3N3b3JkUmVzZXRUb2tlbkV4cGlyYXRpb24iLCJwYXNzd29yZFJlc2V0VG9rZW5FeHBpcmF0aW9uSW5EYXlzIiwiREVGQVVMVF9QQVNTV09SRF9SRVNFVF9UT0tFTl9FWFBJUkFUSU9OX0RBWVMiLCJfZ2V0UGFzc3dvcmRFbnJvbGxUb2tlbkxpZmV0aW1lTXMiLCJwYXNzd29yZEVucm9sbFRva2VuRXhwaXJhdGlvbiIsInBhc3N3b3JkRW5yb2xsVG9rZW5FeHBpcmF0aW9uSW5EYXlzIiwiREVGQVVMVF9QQVNTV09SRF9FTlJPTExfVE9LRU5fRVhQSVJBVElPTl9EQVlTIiwiX3Rva2VuRXhwaXJhdGlvbiIsIndoZW4iLCJEYXRlIiwiZ2V0VGltZSIsIl90b2tlbkV4cGlyZXNTb29uIiwibWluTGlmZXRpbWVNcyIsIm1pbkxpZmV0aW1lQ2FwTXMiLCJNSU5fVE9LRU5fTElGRVRJTUVfQ0FQX1NFQ1MiLCJfb2JqZWN0V2l0aG91dFByb3BlcnRpZXMiLCJjcnlwdG8iLCJVUkwiLCJoYXNPd24iLCJOb25FbXB0eVN0cmluZyIsIk1hdGNoIiwiV2hlcmUiLCJ4IiwiY2hlY2siLCJTdHJpbmciLCJvbkNyZWF0ZUxvZ2luVG9rZW4iLCJfb25DcmVhdGVMb2dpblRva2VuSG9vayIsIl9zZWxlY3RvckZvckZhc3RDYXNlSW5zZW5zaXRpdmVMb29rdXAiLCJmaWVsZE5hbWUiLCJzdHJpbmciLCJwcmVmaXgiLCJzdWJzdHJpbmciLCJNYXRoIiwibWluIiwib3JDbGF1c2UiLCJnZW5lcmF0ZUNhc2VQZXJtdXRhdGlvbnNGb3JTdHJpbmciLCJtYXAiLCJwcmVmaXhQZXJtdXRhdGlvbiIsInNlbGVjdG9yIiwiUmVnRXhwIiwiX2VzY2FwZVJlZ0V4cCIsImNhc2VJbnNlbnNpdGl2ZUNsYXVzZSIsIiRhbmQiLCIkb3IiLCJfZmluZFVzZXJCeVF1ZXJ5IiwicXVlcnkiLCJpZCIsImZpZWxkVmFsdWUiLCJ1c2VybmFtZSIsImVtYWlsIiwiY2FuZGlkYXRlVXNlcnMiLCJmaW5kIiwiZmV0Y2giLCJfaGFuZGxlRXJyb3IiLCJtc2ciLCJ0aHJvd0Vycm9yIiwiZXJyb3JDb2RlIiwiZXJyb3IiLCJhbWJpZ3VvdXNFcnJvck1lc3NhZ2VzIiwiX3VzZXJRdWVyeVZhbGlkYXRvciIsIk9wdGlvbmFsIiwiX3NlcnZlciIsIl9pbml0U2VydmVyTWV0aG9kcyIsIl9pbml0QWNjb3VudERhdGFIb29rcyIsIl9hdXRvcHVibGlzaEZpZWxkcyIsImxvZ2dlZEluVXNlciIsIm90aGVyVXNlcnMiLCJfZGVmYXVsdFB1Ymxpc2hGaWVsZHMiLCJwcm9qZWN0aW9uIiwicHJvZmlsZSIsImVtYWlscyIsIl9pbml0U2VydmVyUHVibGljYXRpb25zIiwiX2FjY291bnREYXRhIiwiX3VzZXJPYnNlcnZlc0ZvckNvbm5lY3Rpb25zIiwiX25leHRVc2VyT2JzZXJ2ZU51bWJlciIsIl9sb2dpbkhhbmRsZXJzIiwic2V0dXBVc2Vyc0NvbGxlY3Rpb24iLCJzZXR1cERlZmF1bHRMb2dpbkhhbmRsZXJzIiwic2V0RXhwaXJlVG9rZW5zSW50ZXJ2YWwiLCJfdmFsaWRhdGVMb2dpbkhvb2siLCJfdmFsaWRhdGVOZXdVc2VySG9va3MiLCJkZWZhdWx0VmFsaWRhdGVOZXdVc2VySG9vayIsImJpbmQiLCJfZGVsZXRlU2F2ZWRUb2tlbnNGb3JBbGxVc2Vyc09uU3RhcnR1cCIsIl9za2lwQ2FzZUluc2Vuc2l0aXZlQ2hlY2tzRm9yVGVzdCIsInVybHMiLCJyZXNldFBhc3N3b3JkIiwidG9rZW4iLCJleHRyYVBhcmFtcyIsImJ1aWxkRW1haWxVcmwiLCJ2ZXJpZnlFbWFpbCIsImxvZ2luVG9rZW4iLCJlbnJvbGxBY2NvdW50IiwiYWRkRGVmYXVsdFJhdGVMaW1pdCIsInBhdGgiLCJ1cmwiLCJhYnNvbHV0ZVVybCIsInBhcmFtcyIsImVudHJpZXMiLCJ2YWx1ZSIsInNlYXJjaFBhcmFtcyIsImFwcGVuZCIsInRvU3RyaW5nIiwiY3VycmVudEludm9jYXRpb24iLCJfQ3VycmVudE1ldGhvZEludm9jYXRpb24iLCJnZXQiLCJfQ3VycmVudFB1YmxpY2F0aW9uSW52b2NhdGlvbiIsInZhbGlkYXRlTG9naW5BdHRlbXB0IiwidmFsaWRhdGVOZXdVc2VyIiwicHVzaCIsImJlZm9yZUV4dGVybmFsTG9naW4iLCJfYmVmb3JlRXh0ZXJuYWxMb2dpbkhvb2siLCJvbkNyZWF0ZVVzZXIiLCJfb25DcmVhdGVVc2VySG9vayIsIm9uRXh0ZXJuYWxMb2dpbiIsIl9vbkV4dGVybmFsTG9naW5Ib29rIiwic2V0QWRkaXRpb25hbEZpbmRVc2VyT25FeHRlcm5hbExvZ2luIiwiX2FkZGl0aW9uYWxGaW5kVXNlck9uRXh0ZXJuYWxMb2dpbiIsIl92YWxpZGF0ZUxvZ2luIiwiYXR0ZW1wdCIsImNsb25lQXR0ZW1wdFdpdGhDb25uZWN0aW9uIiwiZSIsImFsbG93ZWQiLCJfc3VjY2Vzc2Z1bExvZ2luIiwiZWFjaCIsIl9mYWlsZWRMb2dpbiIsIl9zdWNjZXNzZnVsTG9nb3V0IiwiX2xvZ2luVXNlciIsIm1ldGhvZEludm9jYXRpb24iLCJzdGFtcGVkTG9naW5Ub2tlbiIsIl9nZW5lcmF0ZVN0YW1wZWRMb2dpblRva2VuIiwiX2luc2VydExvZ2luVG9rZW4iLCJfbm9ZaWVsZHNBbGxvd2VkIiwiX3NldExvZ2luVG9rZW4iLCJfaGFzaExvZ2luVG9rZW4iLCJzZXRVc2VySWQiLCJ0b2tlbkV4cGlyZXMiLCJfYXR0ZW1wdExvZ2luIiwibWV0aG9kTmFtZSIsIm1ldGhvZEFyZ3MiLCJyZXN1bHQiLCJ0eXBlIiwibWV0aG9kQXJndW1lbnRzIiwiQXJyYXkiLCJmcm9tIiwiX2xvZ2luTWV0aG9kIiwiZm4iLCJ0cnlMb2dpbk1ldGhvZCIsIl9yZXBvcnRMb2dpbkZhaWx1cmUiLCJyZWdpc3RlckxvZ2luSGFuZGxlciIsImhhbmRsZXIiLCJfcnVuTG9naW5IYW5kbGVycyIsImRlc3Ryb3lUb2tlbiIsInVwZGF0ZSIsIiRwdWxsIiwiaGFzaGVkVG9rZW4iLCJhY2NvdW50cyIsIm1ldGhvZHMiLCJsb2dpbiIsImFyZ3VtZW50cyIsImxvZ291dCIsIl9nZXRMb2dpblRva2VuIiwiZ2V0TmV3VG9rZW4iLCJjdXJyZW50SGFzaGVkVG9rZW4iLCJjdXJyZW50U3RhbXBlZFRva2VuIiwic2VydmljZXMiLCJyZXN1bWUiLCJsb2dpblRva2VucyIsInN0YW1wZWRUb2tlbiIsIm5ld1N0YW1wZWRUb2tlbiIsInJlbW92ZU90aGVyVG9rZW5zIiwiY3VycmVudFRva2VuIiwiJG5lIiwiY29uZmlndXJlTG9naW5TZXJ2aWNlIiwiT2JqZWN0SW5jbHVkaW5nIiwic2VydmljZSIsIm9hdXRoIiwic2VydmljZU5hbWVzIiwidXNpbmdPQXV0aEVuY3J5cHRpb24iLCJzZWNyZXQiLCJzZWFsIiwiaW5zZXJ0Iiwib25Db25uZWN0aW9uIiwib25DbG9zZSIsIl9yZW1vdmVUb2tlbkZyb21Db25uZWN0aW9uIiwicHVibGlzaCIsImlzX2F1dG8iLCJjdXN0b21GaWVsZHMiLCJfaWQiLCJhdXRvcHVibGlzaCIsInRvRmllbGRTZWxlY3RvciIsInJlZHVjZSIsInByZXYiLCJmaWVsZCIsImFkZEF1dG9wdWJsaXNoRmllbGRzIiwib3B0cyIsImFwcGx5IiwiZm9yTG9nZ2VkSW5Vc2VyIiwiZm9yT3RoZXJVc2VycyIsInNldERlZmF1bHRQdWJsaXNoRmllbGRzIiwiX2dldEFjY291bnREYXRhIiwiY29ubmVjdGlvbklkIiwiZGF0YSIsIl9zZXRBY2NvdW50RGF0YSIsImhhc2giLCJjcmVhdGVIYXNoIiwiZGlnZXN0IiwiX2hhc2hTdGFtcGVkVG9rZW4iLCJoYXNoZWRTdGFtcGVkVG9rZW4iLCJfaW5zZXJ0SGFzaGVkTG9naW5Ub2tlbiIsIiRhZGRUb1NldCIsIl9jbGVhckFsbExvZ2luVG9rZW5zIiwiJHNldCIsIl9nZXRVc2VyT2JzZXJ2ZSIsIm9ic2VydmUiLCJzdG9wIiwibmV3VG9rZW4iLCJteU9ic2VydmVOdW1iZXIiLCJkZWZlciIsImZvdW5kTWF0Y2hpbmdVc2VyIiwib2JzZXJ2ZUNoYW5nZXMiLCJhZGRlZCIsInJlbW92ZWQiLCJjbG9zZSIsIm5vbk11dGF0aW5nQ2FsbGJhY2tzIiwiUmFuZG9tIiwiX2V4cGlyZVBhc3N3b3JkUmVzZXRUb2tlbnMiLCJvbGRlc3RWYWxpZERhdGUiLCJ0b2tlbkxpZmV0aW1lTXMiLCJ0b2tlbkZpbHRlciIsIiRleGlzdHMiLCJleHBpcmVQYXNzd29yZFRva2VuIiwiX2V4cGlyZVBhc3N3b3JkRW5yb2xsVG9rZW5zIiwiX2V4cGlyZVRva2VucyIsInVzZXJGaWx0ZXIiLCIkbHQiLCJtdWx0aSIsInN1cGVyUmVzdWx0IiwiZXhwaXJlVG9rZW5JbnRlcnZhbCIsImNsZWFySW50ZXJ2YWwiLCJpbnNlcnRVc2VyRG9jIiwiY3JlYXRlZEF0IiwicGluRW5jcnlwdGVkRmllbGRzVG9Vc2VyIiwiZnVsbFVzZXIiLCJkZWZhdWx0Q3JlYXRlVXNlckhvb2siLCJob29rIiwiZXJybXNnIiwiX3Rlc3RFbWFpbERvbWFpbiIsImRvbWFpbiIsInJlc3RyaWN0Q3JlYXRpb25CeUVtYWlsRG9tYWluIiwidGVzdCIsIl9kZWxldGVTYXZlZFRva2Vuc0ZvclVzZXIiLCJ0b2tlbnNUb0RlbGV0ZSIsIiR1bnNldCIsIiRwdWxsQWxsIiwibG9naW5Ub2tlbnNUb0RlbGV0ZSIsInVwZGF0ZU9yQ3JlYXRlVXNlckZyb21FeHRlcm5hbFNlcnZpY2UiLCJzZXJ2aWNlTmFtZSIsInNlcnZpY2VEYXRhIiwic2VydmljZUlkS2V5IiwiaXNOYU4iLCJwYXJzZUludCIsInNldEF0dHJzIiwicmVtb3ZlRGVmYXVsdFJhdGVMaW1pdCIsInJlc3AiLCJERFBSYXRlTGltaXRlciIsInJlbW92ZVJ1bGUiLCJkZWZhdWx0UmF0ZUxpbWl0ZXJSdWxlSWQiLCJhZGRSdWxlIiwiY2xpZW50QWRkcmVzcyIsImdlbmVyYXRlT3B0aW9uc0ZvckVtYWlsIiwicmVhc29uIiwiZXh0cmEiLCJ0byIsImVtYWlsVGVtcGxhdGVzIiwic3ViamVjdCIsInRleHQiLCJodG1sIiwiaGVhZGVycyIsIl9jaGVja0ZvckNhc2VJbnNlbnNpdGl2ZUR1cGxpY2F0ZXMiLCJkaXNwbGF5TmFtZSIsIm93blVzZXJJZCIsInNraXBDaGVjayIsIm1hdGNoZWRVc2VycyIsImxpbWl0IiwiX2NyZWF0ZVVzZXJDaGVja2luZ0R1cGxpY2F0ZXMiLCJuZXdVc2VyIiwiYWRkcmVzcyIsInZlcmlmaWVkIiwiZXgiLCJyZW1vdmUiLCJjbG9uZWRBdHRlbXB0IiwiRUpTT04iLCJjbG9uZSIsImRlZmF1bHRSZXN1bWVMb2dpbkhhbmRsZXIiLCJvbGRVbmhhc2hlZFN0eWxlVG9rZW4iLCJpc0Vucm9sbCIsInJlc2V0UmFuZ2VPciIsImV4cGlyZUZpbHRlciIsInNldEludGVydmFsIiwia2V5SXNMb2FkZWQiLCJpc1NlYWxlZCIsIm9wZW4iLCJlbWFpbElzR29vZCIsInZhbHVlcyIsImFsbG93IiwibW9kaWZpZXIiLCJjcmVhdGVJbmRleCIsInVuaXF1ZSIsInNwYXJzZSIsInBlcm11dGF0aW9ucyIsImkiLCJjaCIsImNoYXJBdCIsImNvbmNhdCIsImxvd2VyQ2FzZUNoYXIiLCJ0b0xvd2VyQ2FzZSIsInVwcGVyQ2FzZUNoYXIiLCJ0b1VwcGVyQ2FzZSJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OztBQUFBQSxTQUFPLENBQUNDLE1BQVIsQ0FBZTtBQUFDQyxrQkFBYyxFQUFDLE1BQUlBO0FBQXBCLEdBQWY7QUFBb0QsTUFBSUEsY0FBSjtBQUFtQkYsU0FBTyxDQUFDRyxJQUFSLENBQWEsc0JBQWIsRUFBb0M7QUFBQ0Qsa0JBQWMsQ0FBQ0UsQ0FBRCxFQUFHO0FBQUNGLG9CQUFjLEdBQUNFLENBQWY7QUFBaUI7O0FBQXBDLEdBQXBDLEVBQTBFLENBQTFFOztBQUV2RTtBQUNBO0FBQ0E7QUFDQTtBQUNBQyxVQUFRLEdBQUcsSUFBSUgsY0FBSixDQUFtQkksTUFBTSxDQUFDQyxNQUExQixDQUFYLEMsQ0FFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBOztBQUNBRCxRQUFNLENBQUNFLEtBQVAsR0FBZUgsUUFBUSxDQUFDRyxLQUF4Qjs7Ozs7Ozs7Ozs7O0FDbEJBLElBQUlDLGFBQUo7O0FBQWtCQyxNQUFNLENBQUNQLElBQVAsQ0FBWSxzQ0FBWixFQUFtRDtBQUFDUSxTQUFPLENBQUNQLENBQUQsRUFBRztBQUFDSyxpQkFBYSxHQUFDTCxDQUFkO0FBQWdCOztBQUE1QixDQUFuRCxFQUFpRixDQUFqRjtBQUFsQk0sTUFBTSxDQUFDVCxNQUFQLENBQWM7QUFBQ1csZ0JBQWMsRUFBQyxNQUFJQSxjQUFwQjtBQUFtQ0MsMkJBQXlCLEVBQUMsTUFBSUEseUJBQWpFO0FBQTJGQywyQkFBeUIsRUFBQyxNQUFJQTtBQUF6SCxDQUFkO0FBQW1LLElBQUlSLE1BQUo7QUFBV0ksTUFBTSxDQUFDUCxJQUFQLENBQVksZUFBWixFQUE0QjtBQUFDRyxRQUFNLENBQUNGLENBQUQsRUFBRztB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TSxHQUFHK1IsYUFBbEMsQ0FBUDtBQUNEO0FBQ0YsS0FUNEIsQ0FBZCxDQUFmO0FBVUQ7O0FBQ0QsU0FBT1AsWUFBUDtBQUNELENBaEJELEMiLCJmaWxlIjoiL3BhY2thZ2VzL2FjY291bnRzLWJhc2UuanMiLCJzb3VyY2VzQ29udGVudCI6WyJpbXBvcnQgeyBBY2NvdW50c1NlcnZlciB9IGZyb20gXCIuL2FjY291bnRzX3NlcnZlci5qc1wiO1xuXG4vKipcbiAqIEBuYW1lc3BhY2UgQWNjb3VudHNcbiAqIEBzdW1tYXJ5IFRoZSBuYW1lc3BhY2UgZm9yIGFsbCBzZXJ2ZXItc2lkZSBhY2NvdW50cy1yZWxhdGVkIG1ldGhvZHMuXG4gKi9cbkFjY291bnRzID0gbmV3IEFjY291bnRzU2VydmVyKE1ldGVvci5zZXJ2ZXIpO1xuXG4vLyBVc2VycyB0YWJsZS4gRG9uJ3QgdXNlIHRoZSBub3JtYWwgYXV0b3B1Ymxpc2gsIHNpbmNlIHdlIHdhbnQgdG8gaGlkZVxuLy8gc29tZSBmaWVsZHMuIENvZGUgdG8gYXV0b3B1Ymxpc2ggdGhpcyBpcyBpbiBhY2NvdW50c19zZXJ2ZXIuanMuXG4vLyBYWFggQWxsb3cgdXNlcnMgdG8gY29uZmlndXJlIHRoaXMgY29sbGVjdGlvbiBuYW1lLlxuXG4vKipcbiAqIEBzdW1tYXJ5IEEgW01vbmdvLkNvbGxlY3Rpb25dKCNjb2xsZWN0aW9ucykgY29udGFpbmluZyB1c2VyIGRvY3VtZW50cy5cbiAqIEBsb2N1cyBBbnl3aGVyZVxuICogQHR5cGUge01vbmdvLkNvbGxlY3Rpb259XG4gKiBAaW1wb3J0RnJvbVBhY2thZ2UgbWV0ZW9yXG4qL1xuTWV0ZW9yLnVzZXJzID0gQWNjb3VudHMudXNlcnM7XG5cbmV4cG9ydCB7XG4gIC8vIFNpbmNlIHRoaXMgZmlsZSBpcyB0aGUgbWFpbiBtb2R1bGUgZm9yIHRoZSBzZXJ2ZXIgdmVyc2lvbiBvZiB0aGVcbiAgLy8gYWNjb3VudHMtYmFzZSBwYWNrYWdlLCBwcm9wZXJ0aWVzIG9mIG5vbi1lbnRyeS1wb2ludCBtb2R1bGVzIG5lZWQgdG9cbiAgLy8gYmUgcmUtZXhwb3J0ZWQgaW4gb3JkZXIgdG8gYmUgYWNjZXNzaWJsZSB0byBtb2R1bGVzIHRoYXQgaW1wb3J0IHRoZVxuICAvLyBhY2NvdW50cy1iYXNlIHBhY2thZ2UuXG4gIEFjY291bnRzU2VydmVyXG59O1xuIiwiaW1wb3J0IHsgTWV0ZW9yIH0gZnJvbSAnbWV0ZW9yL21ldGVvcic7XG5cbi8vIGNvbmZpZyBvcHRpb24ga2V5c1xuY29uc3QgVkFMSURfQ09ORklHX0tFWVMgPSBbXG4gICdzZW5kVmVyaWZpY2F0aW9uRW1haWwnLFxuICAnZm9yYmlkQ2xpZW50QWNjb3VudENyZWF0aW9uJyxcbiAgJ3Bhc3N3b3JkRW5yb2xsVG9rZW5FeHBpcmF0aW9uJyxcbiAgJ3Bhc3N3b3JkRW5yb2xsVG9rZW5FeHBpcmF0aW9uSW5EYXlzJyxcbiAgJ3Jlc3RyaWN0Q3JlYXRpb25CeUVtYWlsRG9tYWluJyxcbiAgJ2xvZ2luRXhwaXJhdGlvbkluRGF5cycsXG4gICdsb2dpbkV4cGlyYXRpb24nLFxuICAncGFzc3dvcmRSZXNldFRva2VuRXhwaXJhdGlvbkluRGF5cycsXG4gICdwYXNzd29yZFJlc2V0VG9rZW5FeHBpcmF0aW9uJyxcbiAgJ2FtYmlndW91c0Vycm9yTWVzc2FnZXMnLFxuICAnYmNyeXB0Um91bmRzJyxcbiAgJ2RlZmF1bHRGaWVsZFNlbGVjdG9yJyxcbl07XG5cbi8qKlxuICogQHN1bW1hcnkgU3VwZXItY29uc3RydWN0b3IgZm9yIEFjY291bnRzQ2xpZW50IGFuZCBBY2NvdW50c1NlcnZlci5cbiAqIEBsb2N1cyBBbnl3aGVyZVxuICogQGNsYXNzIEFjY291bnRzQ29tbW9uXG4gKiBAaW5zdGFuY2VuYW1lIGFjY291bnRzQ2xpZW50T3JTZXJ2ZXJcbiAqIEBwYXJhbSBvcHRpb25zIHtPYmplY3R9IGFuIG9iamVjdCB3aXRoIGZpZWxkczpcbiAqIC0gY29ubmVjdGlvbiB7T2JqZWN0fSBPcHRpb25hbCBERFAgY29ubmVjdGlvbiB0byByZXVzZS5cbiAqIC0gZGRwVXJsIHtTdHJpbmd9IE9wdGlvbmFsIFVSTCBmb3IgY3JlYXRpbmcgYSBuZXcgRERQIGNvbm5lY3Rpb24uXG4gKi9cbmV4cG9ydCBjbGFzcyBBY2NvdW50c0NvbW1vbiB7XG4gIGNvbnN0cnVjdG9yKG9wdGlvbnMpIHtcbiAgICAvLyBDdXJyZW50bHkgdGhpcyBpcyByZWFkIGRpcmVjdGx5IGJ5IHBhY2thZ2VzIGxpa2UgYWNjb3VudHMtcGFzc3dvcmRcbiAgICAvLyBhbmQgYWNjb3VudHMtdWktdW5zdHlsZWQuXG4gICAgdGhpcy5fb3B0aW9ucyA9IHt9O1xuXG4gICAgLy8gTm90ZSB0aGF0IHNldHRpbmcgdGhpcy5jb25uZWN0aW9uID0gbnVsbCBjYXVzZXMgdGhpcy51c2VycyB0byBiZSBhXG4gICAgLy8gTG9jYWxDb2xsZWN0aW9uLCB3aGljaCBpcyBub3Qgd2hhdCB3ZSB3YW50LlxuICAgIHRoaXMuY29ubmVjdGlvbiA9IHVuZGVmaW5lZDtcbiAgICB0aGlzLl9pbml0Q29ubmVjdGlvbihvcHRpb25zIHx8IHt9KTtcblxuICAgIC8vIFRoZXJlIGlzIGFuIGFsbG93IGNhbGwgaW4gYWNjb3VudHNfc2VydmVyLmpzIHRoYXQgcmVzdHJpY3RzIHdyaXRlcyB0b1xuICAgIC8vIHRoaXMgY29sbGVjdGlvbi5cbiAgICB0aGlzLnVzZXJzID0gbmV3IE1vbmdvLkNvbGxlY3Rpb24oJ3VzZXJzJywge1xuICAgICAgX3ByZXZlbnRBdXRvcHVibGlzaDogdHJ1ZSxcbiAgICAgIGNvbm5lY3Rpb246IHRoaXMuY29ubmVjdGlvbixcbiAgICB9KTtcblxuICAgIC8vIENhbGxiYWNrIGV4Y2VwdGlvbnMgYXJlIHByaW50ZWQgd2l0aCBNZXRlb3IuX2RlYnVnIGFuZCBpZ25vcmVkLlxuICAgIHRoaXMuX29uTG9naW5Ib29rID0gbmV3IEhvb2soe1xuICAgICAgYmluZEVudmlyb25tZW50OiBmYWxzZSxcbiAgICAgIGRlYnVnUHJpbnRFeGNlcHRpb25zOiAnb25Mb2dpbiBjYWxsYmFjaycsXG4gICAgfSk7XG5cbiAgICB0aGlzLl9vbkxvZ2luRmFpbHVyZUhvb2sgPSBuZXcgSG9vayh7XG4gICAgICBiaW5kRW52aXJvbm1lbnQ6IGZhbHNlLFxuICAgICAgZGVidWdQcmludEV4Y2VwdGlvbnM6ICdvbkxvZ2luRmFpbHVyZSBjYWxsYmFjaycsXG4gICAgfSk7XG5cbiAgICB0aGlzLl9vbkxvZ291dEhvb2sgPSBuZXcgSG9vayh7XG4gICAgICBiaW5kRW52aXJvbm1lbnQ6IGZhbHNlLFxuICAgICAgZGVidWdQcmludEV4Y2VwdGlvbnM6ICdvbkxvZ291dCBjYWxsYmFjaycsXG4gICAgfSk7XG5cbiAgICAvLyBFeHBvc2UgZm9yIHRlc3RpbmcuXG4gICAgdGhpcy5ERUZBVUxUX0xPR0lOX0VYUElSQVRJT05fREFZUyA9IERFRkFVTFRfTE9HSU5fRVhQSVJBVElPTl9EQVlTO1xuICAgIHRoaXMuTE9HSU5fVU5FWFBJUklOR19UT0tFTl9EQVlTID0gTE9HSU5fVU5FWFBJUklOR19UT0tFTl9EQVlTO1xuXG4gICAgLy8gVGhyb3duIHdoZW4gdGhlIHVzZXIgY2FuY2VscyB0aGUgbG9naW4gcHJvY2VzcyAoZWcsIGNsb3NlcyBhbiBvYXV0aFxuICAgIC8vIHBvcHVwLCBkZWNsaW5lcyByZXRpbmEgc2NhbiwgZXRjKVxuICAgIGNvbnN0IGxjZU5hbWUgPSAnQWNjb3VudHMuTG9naW5DYW5jZWxsZWRFcnJvcic7XG4gICAgdGhpcy5Mb2dpbkNhbmNlbGxlZEVycm9yID0gTWV0ZW9yLm1ha2VFcnJvclR5cGUobGNlTmFtZSwgZnVuY3Rpb24oXG4gICAgICBkZXNjcmlwdGlvblxuICAgICkge1xuICAgICAgdGhpcy5tZXNzYWdlID0gZGVzY3JpcHRpb247XG4gICAgfSk7XG4gICAgdGhpcy5Mb2dpbkNhbmNlbGxlZEVycm9yLnByb3RvdHlwZS5uYW1lID0gbGNlTmFtZTtcblxuICAgIC8vIFRoaXMgaXMgdXNlZCB0byB0cmFuc21pdCBzcGVjaWZpYyBzdWJjbGFzcyBlcnJvcnMgb3ZlciB0aGUgd2lyZS4gV2VcbiAgICAvLyBzaG91bGQgY29tZSB1cCB3aXRoIGEgbW9yZSBnZW5lcmljIHdheSB0byBkbyB0aGlzIChlZywgd2l0aCBzb21lIHNvcnQgb2ZcbiAgICAvLyBzeW1ib2xpYyBlcnJvciBjb2RlIHJhdGhlciB0aGFuIGEgbnVtYmVyKS5cbiAgICB0aGlzLkxvZ2luQ2FuY2VsbGVkRXJyb3IubnVtZXJpY0Vycm9yID0gMHg4YWNkYzJmO1xuXG4gICAgLy8gbG9naW5TZXJ2aWNlQ29uZmlndXJhdGlvbiBhbmQgQ29uZmlnRXJyb3IgYXJlIG1haW50YWluZWQgZm9yIGJhY2t3YXJkcyBjb21wYXRpYmlsaXR5XG4gICAgTWV0ZW9yLnN0YXJ0dXAoKCkgPT4ge1xuICAgICAgY29uc3QgeyBTZXJ2aWNlQ29uZmlndXJhdGlvbiB9ID0gUGFja2FnZVsnc2VydmljZS1jb25maWd1cmF0aW9uJ107XG4gICAgICB0aGlzLmxvZ2luU2VydmljZUNvbmZpZ3VyYXRpb24gPSBTZXJ2aWNlQ29uZmlndXJhdGlvbi5jb25maWd1cmF0aW9ucztcbiAgICAgIHRoaXMuQ29uZmlnRXJyb3IgPSBTZXJ2aWNlQ29uZmlndXJhdGlvbi5Db25maWdFcnJvcjtcblxuICAgICAgY29uc3Qgc2V0dGluZ3MgPSBNZXRlb3Iuc2V0dGluZ3M/LnBhY2thZ2VzPy5bJ2FjY291bnRzLWJhc2UnXTtcbiAgICAgIGlmIChzZXR0aW5ncykge1xuICAgICAgICBpZiAoc2V0dGluZ3Mub2F1dGhTZWNyZXRLZXkpIHtcbiAgICAgICAgICBpZiAoIVBhY2thZ2VbJ29hdXRoLWVuY3J5cHRpb24nXSkge1xuICAgICAgICAgICAgdGhyb3cgbmV3IEVycm9yKFxuICAgICAgICAgICAgICAnVGhlIG9hdXRoLWVuY3J5cHRpb24gcGFja2FnZSBtdXN0IGJlIGxvYWRlZCB0byBzZXQgb2F1dGhTZWNyZXRLZXknXG4gICAgICAgICAgICApO1xuICAgICAgICAgIH1cbiAgICAgICAgICBQYWNrYWdlWydvYXV0aC1lbmNyeXB0aW9uJ10uT0F1dGhFbmNyeXB0aW9uLmxvYWRLZXkoXG4gICAgICAgICAgICBzZXR0aW5ncy5vYXV0aFNlY3JldEtleVxuICAgICAgICAgICk7XG4gICAgICAgICAgZGVsZXRlIHNldHRpbmdzLm9hdXRoU2VjcmV0S2V5O1xuICAgICAgICB9XG4gICAgICAgIC8vIFZhbGlkYXRlIGNvbmZpZyBvcHRpb25zIGtleXNcbiAgICAgICAgT2JqZWN0LmtleXMoc2V0dGluZ3MpLmZvckVhY2goa2V5ID0+IHtcbiAgICAgICAgICBpZiAoIVZBTElEX0NPTkZJR19LRVlTLmluY2x1ZGVzKGtleSkpIHtcbiAgICAgICAgICAgIC8vIFRPRE8gQ29uc2lkZXIganVzdCBsb2dnaW5nIGEgZGVidWcgbWVzc2FnZSBpbnN0ZWFkIHRvIGFsbG93IGZvciBhZGRpdGlvbmFsIGtleXMgaW4gdGhlIHNldHRpbmdzIGhlcmU/XG4gICAgICAgICAgICB0aHJvdyBuZXcgTWV0ZW9yLkVycm9yKFxuICAgICAgICAgICAgICBgQWNjb3VudHMgY29uZmlndXJhdGlvbjogSW52YWxpZCBrZXk6ICR7a2V5fWBcbiAgICAgICAgICAgICk7XG4gICAgICAgICAgfSBlbHNlIHtcbiAgICAgICAgICAgIC8vIHNldCB2YWx1ZXMgaW4gQWNjb3VudHMuX29wdGlvbnNcbiAgICAgICAgICAgIHRoaXMuX29wdGlvbnNba2V5XSA9IHNldHRpbmdzW2tleV07XG4gICAgICAgICAgfVxuICAgICAgICB9KTtcbiAgICAgIH1cbiAgICB9KTtcbiAgfVxuXG4gIC8qKlxuICAgKiBAc3VtbWFyeSBHZXQgdGhlIGN1cnJlbnQgdXNlciBpZCwgb3IgYG51bGxgIGlmIG5vIHVzZXIgaXMgbG9nZ2VkIGluLiBBIHJlYWN0aXZlIGRhdGEgc291cmNlLlxuICAgKiBAbG9jdXMgQW55d2hlcmVcbiAgICovXG4gIHVzZXJJZCgpIHtcbiAgICB0aHJvdyBuZXcgRXJyb3IoJ3VzZXJJZCBtZXRob2Qgbm90IGltcGxlbWVudGVkJyk7XG4gIH1cblxuICAvLyBtZXJnZSB0aGUgZGVmYXVsdEZpZWxkU2VsZWN0b3Igd2l0aCBhbiBleGlzdGluZyBvcHRpb25zIG9iamVjdFxuICBfYWRkRGVmYXVsdEZpZWxkU2VsZWN0b3Iob3B0aW9ucyA9IHt9KSB7XG4gICAgLy8gdGhpcyB3aWxsIGJlIHRoZSBtb3N0IGNvbW1vbiBjYXNlIGZvciBtb3N0IHBlb3BsZSwgc28gbWFrZSBpdCBxdWlja1xuICAgIGlmICghdGhpcy5fb3B0aW9ucy5kZWZhdWx0RmllbGRTZWxlY3RvcikgcmV0dXJuIG9wdGlvbnM7XG5cbiAgICAvLyBpZiBubyBmaWVsZCBzZWxlY3RvciB0aGVuIGp1c3QgdXNlIGRlZmF1bHRGaWVsZFNlbGVjdG9yXG4gICAgaWYgKCFvcHRpb25zLmZpZWxkcylcbiAgICAgIHJldHVybiB7XG4gICAgICAgIC4uLm9wdGlvbnMsXG4gICAgICAgIGZpZWxkczogdGhpcy5fb3B0aW9ucy5kZWZhdWx0RmllbGRTZWxlY3RvcixcbiAgICAgIH07XG5cbiAgICAvLyBpZiBlbXB0eSBmaWVsZCBzZWxlY3RvciB0aGVuIHRoZSBmdWxsIHVzZXIgb2JqZWN0IGlzIGV4cGxpY2l0bHkgcmVxdWVzdGVkLCBzbyBvYmV5XG4gICAgY29uc3Qga2V5cyA9IE9iamVjdC5rZXlzKG9wdGlvbnMuZmllbGRzKTtcbiAgICBpZiAoIWtleXMubGVuZ3RoKSByZXR1cm4gb3B0aW9ucztcblxuICAgIC8vIGlmIHRoZSByZXF1ZXN0ZWQgZmllbGRzIGFyZSArdmUgdGhlbiBpZ25vcmUgZGVmYXVsdEZpZWxkU2VsZWN0b3JcbiAgICAvLyBhc3N1bWUgdGhleSBhcmUgYWxsIGVpdGhlciArdmUgb3IgLXZlIGJlY2F1c2UgTW9uZ28gZG9lc24ndCBsaWtlIG1peGVkXG4gICAgaWYgKCEhb3B0aW9ucy5maWVsZHNba2V5c1swXV0pIHJldHVybiBvcHRpb25zO1xuXG4gICAgLy8gVGhlIHJlcXVlc3RlZCBmaWVsZHMgYXJlIC12ZS5cbiAgICAvLyBJZiB0aGUgZGVmYXVsdEZpZWxkU2VsZWN0b3IgaXMgK3ZlIHRoZW4gdXNlIHJlcXVlc3RlZCBmaWVsZHMsIG90aGVyd2lzZSBtZXJnZSB0aGVtXG4gICAgY29uc3Qga2V5czIgPSBPYmplY3Qua2V5cyh0aGlzLl9vcHRpb25zLmRlZmF1bHRGaWVsZFNlbGVjdG9yKTtcbiAgICByZXR1cm4gdGhpcy5fb3B0aW9ucy5kZWZhdWx0RmllbGRTZWxlY3RvcltrZXlzMlswXV1cbiAgICAgID8gb3B0aW9uc1xuICAgICAgOiB7XG4gICAgICAgICAgLi4ub3B0aW9ucyxcbiAgICAgICAgICBmaWVsZHM6IHtcbiAgICAgICAgICAgIC4uLm9wdGlvbnMuZmllbGRzLFxuICAgICAgICAgICAgLi4udGhpcy5fb3B0aW9ucy5kZWZhdWx0RmllbGRTZWxlY3RvcixcbiAgICAgICAgICB9LFxuICAgICAgICB9O1xuICB9XG5cbiAgLyoqXG4gICAqIEBzdW1tYXJ5IEdldCB0aGUgY3VycmVudCB1c2VyIHJlY29yZCwgb3IgYG51bGxgIGlmIG5vIHVzZXIgaXMgbG9nZ2VkIGluLiBBIHJlYWN0aXZlIGRhdGEgc291cmNlLlxuICAgKiBAbG9jdXMgQW55d2hlcmVcbiAgICogQHBhcmFtIHtPYmplY3R9IFtvcHRpb25zXVxuICAgKiBAcGFyYW0ge01vbmdvRmllbGRTcGVjaWZpZXJ9IG9wdGlvbnMuZmllbGRzIERpY3Rpb25hcnkgb2YgZmllbGRzIHRvIHJldHVybiBvciBleGNsdWRlLlxuICAgKi9cbiAgdXNlcihvcHRpb25zKSB7XG4gICAgY29uc3QgdXNlcklkID0gdGhpcy51c2VySWQoKTtcbiAgICByZXR1cm4gdXNlcklkXG4gICAgICA/IHRoaXMudXNlcnMuZmluZE9uZSh1c2VySWQsIHRoaXMuX2FkZERlZmF1bHRGaWVsZFNlbGVjdG9yKG9wdGlvbnMpKVxuICAgICAgOiBudWxsO1xuICB9XG5cbiAgLy8gU2V0IHVwIGNvbmZpZyBmb3IgdGhlIGFjY291bnRzIHN5c3RlbS4gQ2FsbCB0aGlzIG9uIGJvdGggdGhlIGNsaWVudFxuICAvLyBhbmQgdGhlIHNlcnZlci5cbiAgLy9cbiAgLy8gTm90ZSB0aGF0IHRoaXMgbWV0aG9kIGdldHMgb3ZlcnJpZGRlbiBvbiBBY2NvdW50c1NlcnZlci5wcm90b3R5cGUsIGJ1dFxuICAvLyB0aGUgb3ZlcnJpZGluZyBtZXRob2QgY2FsbHMgdGhlIG92ZXJyaWRkZW4gbWV0aG9kLlxuICAvL1xuICAvLyBYWFggd2Ugc2hvdWxkIGFkZCBzb21lIGVuZm9yY2VtZW50IHRoYXQgdGhpcyBpcyBjYWxsZWQgb24gYm90aCB0aGVcbiAgLy8gY2xpZW50IGFuZCB0aGUgc2VydmVyLiBPdGhlcndpc2UsIGEgdXNlciBjYW5cbiAgLy8gJ2ZvcmJpZENsaWVudEFjY291bnRDcmVhdGlvbicgb25seSBvbiB0aGUgY2xpZW50IGFuZCB3aGlsZSBpdCBsb29rc1xuICAvLyBsaWtlIHRoZWlyIGFwcCBpcyBzZWN1cmUsIHRoZSBzZXJ2ZXIgd2lsbCBzdGlsbCBhY2NlcHQgY3JlYXRlVXNlclxuICAvLyBjYWxscy4gaHR0cHM6Ly9naXRodWIuY29tL21ldGVvci9tZXRlb3IvaXNzdWVzLzgyOFxuICAvL1xuICAvLyBAcGFyYW0gb3B0aW9ucyB7T2JqZWN0fSBhbiBvYmplY3Qgd2l0aCBmaWVsZHM6XG4gIC8vIC0gc2VuZFZlcmlmaWNhdGlvbkVtYWlsIHtCb29sZWFufVxuICAvLyAgICAgU2VuZCBlbWFpbCBhZGRyZXNzIHZlcmlmaWNhdGlvbiBlbWFpbHMgdG8gbmV3IHVzZXJzIGNyZWF0ZWQgZnJvbVxuICAvLyAgICAgY2xpZW50IHNpZ251cHMuXG4gIC8vIC0gZm9yYmlkQ2xpZW50QWNjb3VudENyZWF0aW9uIHtCb29sZWFufVxuICAvLyAgICAgRG8gbm90IGFsbG93IGNsaWVudHMgdG8gY3JlYXRlIGFjY291bnRzIGRpcmVjdGx5LlxuICAvLyAtIHJlc3RyaWN0Q3JlYXRpb25CeUVtYWlsRG9tYWluIHtGdW5jdGlvbiBvciBTdHJpbmd9XG4gIC8vICAgICBSZXF1aXJlIGNyZWF0ZWQgdXNlcnMgdG8gaGF2ZSBhbiBlbWFpbCBtYXRjaGluZyB0aGUgZnVuY3Rpb24gb3JcbiAgLy8gICAgIGhhdmluZyB0aGUgc3RyaW5nIGFzIGRvbWFpbi5cbiAgLy8gLSBsb2dpbkV4cGlyYXRpb25JbkRheXMge051bWJlcn1cbiAgLy8gICAgIE51bWJlciBvZiBkYXlzIHNpbmNlIGxvZ2luIHVudGlsIGEgdXNlciBpcyBsb2dnZWQgb3V0IChsb2dpbiB0b2tlblxuICAvLyAgICAgZXhwaXJlcykuXG4gIC8vIC0gcGFzc3dvcmRSZXNldFRva2VuRXhwaXJhdGlvbkluRGF5cyB7TnVtYmVyfVxuICAvLyAgICAgTnVtYmVyIG9mIGRheXMgc2luY2UgcGFzc3dvcmQgcmVzZXQgdG9rZW4gY3JlYXRpb24gdW50aWwgdGhlXG4gIC8vICAgICB0b2tlbiBjYW5udCBiZSB1c2VkIGFueSBsb25nZXIgKHBhc3N3b3JkIHJlc2V0IHRva2VuIGV4cGlyZXMpLlxuICAvLyAtIGFtYmlndW91c0Vycm9yTWVzc2FnZXMge0Jvb2xlYW59XG4gIC8vICAgICBSZXR1cm4gYW1iaWd1b3VzIGVycm9yIG1lc3NhZ2VzIGZyb20gbG9naW4gZmFpbHVyZXMgdG8gcHJldmVudFxuICAvLyAgICAgdXNlciBlbnVtZXJhdGlvbi5cbiAgLy8gLSBiY3J5cHRSb3VuZHMge051bWJlcn1cbiAgLy8gICAgIEFsbG93cyBvdmVycmlkZSBvZiBudW1iZXIgb2YgYmNyeXB0IHJvdW5kcyAoYWthIHdvcmsgZmFjdG9yKSB1c2VkXG4gIC8vICAgICB0byBzdG9yZSBwYXNzd29yZHMuXG5cbiAgLyoqXG4gICAqIEBzdW1tYXJ5IFNldCBnbG9iYWwgYWNjb3VudHMgb3B0aW9ucy4gWW91IGNhbiBhbHNvIHNldCB0aGVzZSBpbiBgTWV0ZW9yLnNldHRpbmdzLnBhY2thZ2VzLmFjY291bnRzYCB3aXRob3V0IHRoZSBuZWVkIHRvIGNhbGwgdGhpcyBmdW5jdGlvbi5cbiAgICogQGxvY3VzIEFueXdoZXJlXG4gICAqIEBwYXJhbSB7T2JqZWN0fSBvcHRpb25zXG4gICAqIEBwYXJhbSB7Qm9vbGVhbn0gb3B0aW9ucy5zZW5kVmVyaWZpY2F0aW9uRW1haWwgTmV3IHVzZXJzIHdpdGggYW4gZW1haWwgYWRkcmVzcyB3aWxsIHJlY2VpdmUgYW4gYWRkcmVzcyB2ZXJpZmljYXRpb24gZW1haWwuXG4gICAqIEBwYXJhbSB7Qm9vbGVhbn0gb3B0aW9ucy5mb3JiaWRDbGllbnRBY2NvdW50Q3JlYXRpb24gQ2FsbHMgdG8gW2BjcmVhdGVVc2VyYF0oI2FjY291bnRzX2NyZWF0ZXVzZXIpIGZyb20gdGhlIGNsaWVudCB3aWxsIGJlIHJlamVjdGVkLiBJbiBhZGRpdGlvbiwgaWYgeW91IGFyZSB1c2luZyBbYWNjb3VudHMtdWldKCNhY2NvdW50c3VpKSwgdGhlIFwiQ3JlYXRlIGFjY291bnRcIiBsaW5rIHdpbGwgbm90IGJlIGF2YWlsYWJsZS5cbiAgICogQHBhcmFtIHtTdHJpbmcgfCBGdW5jdGlvbn0gb3B0aW9ucy5yZXN0cmljdENyZWF0aW9uQnlFbWFpbERvbWFpbiBJZiBzZXQgdG8gYSBzdHJpbmcsIG9ubHkgYWxsb3dzIG5ldyB1c2VycyBpZiB0aGUgZG9tYWluIHBhcnQgb2YgdGhlaXIgZW1haWwgYWRkcmVzcyBtYXRjaGVzIHRoZSBzdHJpbmcuIElmIHNldCB0byBhIGZ1bmN0aW9uLCBvbmx5IGFsbG93cyBuZXcgdXNlcnMgaWYgdGhlIGZ1bmN0aW9uIHJldHVybnMgdHJ1ZS4gIFRoZSBmdW5jdGlvbiBpcyBwYXNzZWQgdGhlIGZ1bGwgZW1haWwgYWRkcmVzcyBvZiB0aGUgcHJvcG9zZWQgbmV3IHVzZXIuICBXb3JrcyB3aXRoIHBhc3N3b3JkLWJhc2VkIHNpZ24taW4gYW5kIGV4dGVybmFsIHNlcnZpY2VzIHRoYXQgZXhwb3NlIGVtYWlsIGFkZHJlc3NlcyAoR29vZ2xlLCBGYWNlYm9vaywgR2l0SHViKS4gQWxsIGV4aXN0aW5nIHVzZXJzIHN0aWxsIGNhbiBsb2cgaW4gYWZ0ZXIgZW5hYmxpbmcgdGhpcyBvcHRpb24uIEV4YW1wbGU6IGBBY2NvdW50cy5jb25maWcoeyByZXN0cmljdENyZWF0aW9uQnlFbWFpbERvbWFpbjogJ3NjaG9vbC5lZHUnIH0pYC5cbiAgICogQHBhcmFtIHtOdW1iZXJ9IG9wdGlvbnMubG9naW5FeHBpcmF0aW9uSW5EYXlzIFRoZSBudW1iZXIgb2YgZGF5cyBmcm9tIHdoZW4gYSB1c2VyIGxvZ3MgaW4gdW50aWwgdGhlaXIgdG9rZW4gZXhwaXJlcyBhbmQgdGhleSBhcmUgbG9nZ2VkIG91dC4gRGVmYXVsdHMgdG8gOTAuIFNldCB0byBgbnVsbGAgdG8gZGlzYWJsZSBsb2dpbiBleHBpcmF0aW9uLlxuICAgKiBAcGFyYW0ge051bWJlcn0gb3B0aW9ucy5sb2dpbkV4cGlyYXRpb24gVGhlIG51bWJlciBvZiBtaWxsaXNlY29uZHMgZnJvbSB3aGVuIGEgdXNlciBsb2dzIGluIHVudGlsIHRoZWlyIHRva2VuIGV4cGlyZXMgYW5kIHRoZXkgYXJlIGxvZ2dlZCBvdXQsIGZvciBhIG1vcmUgZ3JhbnVsYXIgY29udHJvbC4gSWYgYGxvZ2luRXhwaXJhdGlvbkluRGF5c2AgaXMgc2V0LCBpdCB0YWtlcyBwcmVjZWRlbnQuXG4gICAqIEBwYXJhbSB7U3RyaW5nfSBvcHRpb25zLm9hdXRoU2VjcmV0S2V5IFdoZW4gdXNpbmcgdGhlIGBvYXV0aC1lbmNyeXB0aW9uYCBwYWNrYWdlLCB0aGUgMTYgYnl0ZSBrZXkgdXNpbmcgdG8gZW5jcnlwdCBzZW5zaXRpdmUgYWNjb3VudCBjcmVkZW50aWFscyBpbiB0aGUgZGF0YWJhc2UsIGVuY29kZWQgaW4gYmFzZTY0LiAgVGhpcyBvcHRpb24gbWF5IG9ubHkgYmUgc3BlY2lmaWVkIG9uIHRoZSBzZXJ2ZXIuICBTZWUgcGFja2FnZXMvb2F1dGgtZW5jcnlwdGlvbi9SRUFETUUubWQgZm9yIGRldGFpbHMuXG4gICAqIEBwYXJhbSB7TnVtYmVyfSBvcHRpb25zLnBhc3N3b3JkUmVzZXRUb2tlbkV4cGlyYXRpb25JbkRheXMgVGhlIG51bWJlciBvZiBkYXlzIGZyb20gd2hlbiBhIGxpbmsgdG8gcmVzZXQgcGFzc3dvcmQgaXMgc2VudCB1bnRpbCB0b2tlbiBleHBpcmVzIGFuZCB1c2VyIGNhbid0IHJlc2V0IHBhc3N3b3JkIHdpdGggdGhlIGxpbmsgYW55bW9yZS4gRGVmYXVsdHMgdG8gMy5cbiAgICogQHBhcmFtIHtOdW1iZXJ9IG9wdGlvbnMucGFzc3dvcmRSZXNldFRva2VuRXhwaXJhdGlvbiBUaGUgbnVtYmVyIG9mIG1pbGxpc2Vjb25kcyBmcm9tIHdoZW4gYSBsaW5rIHRvIHJlc2V0IHBhc3N3b3JkIGlzIHNlbnQgdW50aWwgdG9rZW4gZXhwaXJlcyBhbmQgdXNlciBjYW4ndCByZXNldCBwYXNzd29yZCB3aXRoIHRoZSBsaW5rIGFueW1vcmUuIElmIGBwYXNzd29yZFJlc2V0VG9rZW5FeHBpcmF0aW9uSW5EYXlzYCBpcyBzZXQsIGl0IHRha2VzIHByZWNlZGVudC5cbiAgICogQHBhcmFtIHtOdW1iZXJ9IG9wdGlvbnMucGFzc3dvcmRFbnJvbGxUb2tlbkV4cGlyYXRpb25JbkRheXMgVGhlIG51bWJlciBvZiBkYXlzIGZyb20gd2hlbiBhIGxpbmsgdG8gc2V0IGluaXRpYWwgcGFzc3dvcmQgaXMgc2VudCB1bnRpbCB0b2tlbiBleHBpcmVzIGFuZCB1c2VyIGNhbid0IHNldCBwYXNzd29yZCB3aXRoIHRoZSBsaW5rIGFueW1vcmUuIERlZmF1bHRzIHRvIDMwLlxuICAgKiBAcGFyYW0ge051bWJlcn0gb3B0aW9ucy5wYXNzd29yZEVucm9sbFRva2VuRXhwaXJhdGlvbiBUaGUgbnVtYmVyIG9mIG1pbGxpc2Vjb25kcyBmcm9tIHdoZW4gYSBsaW5rIHRvIHNldCBpbml0aWFsIHBhc3N3b3JkIGlzIHNlbnQgdW50aWwgdG9rZW4gZXhwaXJlcyBhbmQgdXNlciBjYW4ndCBzZXQgcGFzc3dvcmQgd2l0aCB0aGUgbGluayBhbnltb3JlLiBJZiBgcGFzc3dvcmRFbnJvbGxUb2tlbkV4cGlyYXRpb25JbkRheXNgIGlzIHNldCwgaXQgdGFrZXMgcHJlY2VkZW50LlxuICAgKiBAcGFyYW0ge0Jvb2xlYW59IG9wdGlvbnMuYW1iaWd1b3VzRXJyb3JNZXNzYWdlcyBSZXR1cm4gYW1iaWd1b3VzIGVycm9yIG1lc3NhZ2VzIGZyb20gbG9naW4gZmFpbHVyZXMgdG8gcHJldmVudCB1c2VyIGVudW1lcmF0aW9uLiBEZWZhdWx0cyB0byBmYWxzZS5cbiAgICogQHBhcmFtIHtNb25nb0ZpZWxkU3BlY2lmaWVyfSBvcHRpb25zLmRlZmF1bHRGaWVsZFNlbGVjdG9yIFRvIGV4Y2x1ZGUgYnkgZGVmYXVsdCBsYXJnZSBjdXN0b20gZmllbGRzIGZyb20gYE1ldGVvci51c2VyKClgIGFuZCBgTWV0ZW9yLmZpbmRVc2VyQnkuLi4oKWAgZnVuY3Rpb25zIHdoZW4gY2FsbGVkIHdpdGhvdXQgYSBmaWVsZCBzZWxlY3RvciwgYW5kIGFsbCBgb25Mb2dpbmAsIGBvbkxvZ2luRmFpbHVyZWAgYW5kIGBvbkxvZ291dGAgY2FsbGJhY2tzLiAgRXhhbXBsZTogYEFjY291bnRzLmNvbmZpZyh7IGRlZmF1bHRGaWVsZFNlbGVjdG9yOiB7IG15QmlnQXJyYXk6IDAgfX0pYC4gQmV3YXJlIHdoZW4gdXNpbmcgdGhpcy4gSWYsIGZvciBpbnN0YW5jZSwgeW91IGRvIG5vdCBpbmNsdWRlIGBlbWFpbGAgd2hlbiBleGNsdWRpbmcgdGhlIGZpZWxkcywgeW91IGNhbiBoYXZlIHByb2JsZW1zIHdpdGggZnVuY3Rpb25zIGxpa2UgYGZvcmdvdFBhc3N3b3JkYCB0aGF0IHdpbGwgYnJlYWsgYmVjYXVzZSB0aGV5IHdvbid0IGhhdmUgdGhlIHJlcXVpcmVkIGRhdGEgYXZhaWxhYmxlLiBJdCdzIHJlY29tbWVuZCB0aGF0IHlvdSBhbHdheXMga2VlcCB0aGUgZmllbGRzIGBfaWRgLCBgdXNlcm5hbWVgLCBhbmQgYGVtYWlsYC5cbiAgICovXG4gIGNvbmZpZyhvcHRpb25zKSB7XG4gICAgLy8gV2UgZG9uJ3Qgd2FudCB1c2VycyB0byBhY2NpZGVudGFsbHkgb25seSBjYWxsIEFjY291bnRzLmNvbmZpZyBvbiB0aGVcbiAgICAvLyBjbGllbnQsIHdoZXJlIHNvbWUgb2YgdGhlIG9wdGlvbnMgd2lsbCBoYXZlIHBhcnRpYWwgZWZmZWN0cyAoZWcgcmVtb3ZpbmdcbiAgICAvLyB0aGUgXCJjcmVhdGUgYWNjb3VudFwiIGJ1dHRvbiBmcm9tIGFjY291bnRzLXVpIGlmIGZvcmJpZENsaWVudEFjY291bnRDcmVhdGlvblxuICAgIC8vIGlzIHNldCwgb3IgcmVkaXJlY3RpbmcgR29vZ2xlIGxvZ2luIHRvIGEgc3BlY2lmaWMtZG9tYWluIHBhZ2UpIHdpdGhvdXRcbiAgICAvLyBoYXZpbmcgdGhlaXIgZnVsbCBlZmZlY3RzLlxuICAgIGlmIChNZXRlb3IuaXNTZXJ2ZXIpIHtcbiAgICAgIF9fbWV0ZW9yX3J1bnRpbWVfY29uZmlnX18uYWNjb3VudHNDb25maWdDYWxsZWQgPSB0cnVlO1xuICAgIH0gZWxzZSBpZiAoIV9fbWV0ZW9yX3J1bnRpbWVfY29uZmlnX18uYWNjb3VudHNDb25maWdDYWxsZWQpIHtcbiAgICAgIC8vIFhYWCB3b3VsZCBiZSBuaWNlIHRvIFwiY3Jhc2hcIiB0aGUgY2xpZW50IGFuZCByZXBsYWNlIHRoZSBVSSB3aXRoIGFuIGVycm9yXG4gICAgICAvLyBtZXNzYWdlLCBidXQgdGhlcmUncyBubyB0cml2aWFsIHdheSB0byBkbyB0aGlzLlxuICAgICAgTWV0ZW9yLl9kZWJ1ZyhcbiAgICAgICAgJ0FjY291bnRzLmNvbmZpZyB3YXMgY2FsbGVkIG9uIHRoZSBjbGllbnQgYnV0IG5vdCBvbiB0aGUgJyArXG4gICAgICAgICAgJ3NlcnZlcjsgc29tZSBjb25maWd1cmF0aW9uIG9wdGlvbnMgbWF5IG5vdCB0YWtlIGVmZmVjdC4nXG4gICAgICApO1xuICAgIH1cblxuICAgIC8vIFdlIG5lZWQgdG8gdmFsaWRhdGUgdGhlIG9hdXRoU2VjcmV0S2V5IG9wdGlvbiBhdCB0aGUgdGltZVxuICAgIC8vIEFjY291bnRzLmNvbmZpZyBpcyBjYWxsZWQuIFdlIGFsc28gZGVsaWJlcmF0ZWx5IGRvbid0IHN0b3JlIHRoZVxuICAgIC8vIG9hdXRoU2VjcmV0S2V5IGluIEFjY291bnRzLl9vcHRpb25zLlxuICAgIGlmIChPYmplY3QucHJvdG90eXBlLmhhc093blByb3BlcnR5LmNhbGwob3B0aW9ucywgJ29hdXRoU2VjcmV0S2V5JykpIHtcbiAgICAgIGlmIChNZXRlb3IuaXNDbGllbnQpIHtcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKFxuICAgICAgICAgICdUaGUgb2F1dGhTZWNyZXRLZXkgb3B0aW9uIG1heSBvbmx5IGJlIHNwZWNpZmllZCBvbiB0aGUgc2VydmVyJ1xuICAgICAgICApO1xuICAgICAgfVxuICAgICAgaWYgKCFQYWNrYWdlWydvYXV0aC1lbmNyeXB0aW9uJ10pIHtcbiAgICAgICAgdGhyb3cgbmV3IEVycm9yKFxuICAgICAgICAgICdUaGUgb2F1dGgtZW5jcnlwdGlvbiBwYWNrYWdlIG11c3QgYmUgbG9hZGVkIHRvIHNldCBvYXV0aFNlY3JldEtleSdcbiAgICAgICAgKTtcbiAgICAgIH1cbiAgICAgIFBhY2thZ2VbJ29hdXRoLWVuY3J5cHRpb24nXS5PQXV0aEVuY3J5cHRpb24ubG9hZEtleShcbiAgICAgICAgb3B0aW9ucy5vYXV0aFNlY3JldEtleVxuICAgICAgKTtcbiAgICAgIG9wdGlvbnMgPSB7IC4uLm9wdGlvbnMgfTtcbiAgICAgIGRlbGV0ZSBvcHRpb25zLm9hdXRoU2VjcmV0S2V5O1xuICAgIH1cblxuICAgIC8vIFZhbGlkYXRlIGNvbmZpZyBvcHRpb25zIGtleXNcbiAgICBPYmplY3Qua2V5cyhvcHRpb25zKS5mb3JFYWNoKGtleSA9PiB7XG4gICAgICBpZiAoIVZBTElEX0NPTkZJR19LRVlTLmluY2x1ZGVzKGtleSkpIHtcbiAgICAgICAgdGhyb3cgbmV3IE1ldGVvci5FcnJvcihgQWNjb3VudHMuY29uZmlnOiBJbnZhbGlkIGtleTogJHtrZXl9YCk7XG4gICAgICB9XG4gICAgfSk7XG5cbiAgICAvLyBzZXQgdmFsdWVzIGluIEFjY291bnRzLl9vcHRpb25zXG4gICAgVkFMSURfQ09ORklHX0tFWVMuZm9yRWFjaChrZXkgPT4ge1xuICAgICAgaWYgKGtleSBpbiBvcHRpb25zKSB7XG4gICAgICAgIGlmIChrZXkgaW4gdGhpcy5fb3B0aW9ucykge1xuICAgICAgICAgIHRocm93IG5ldyBNZXRlb3IuRXJyb3IoYENhbid0IHNldCBcXGAke2tleX1cXGAgbW9yZSB0aGFuIG9uY2VgKTtcbiAgICAgICAgfVxuICAgICAgICB0aGlzLl9vcHRpb25zW2tleV0gPSBvcHRpb25zW2tleV07XG4gICAgICB9XG4gICAgfSk7XG4gIH1cblxuICAvKipcbiAgICogQHN1bW1hcnkgUmVnaXN0ZXIgYSBjYWxsYmFjayB0byBiZSBjYWxsZWQgYWZ0ZXIgYSBsb2dpbiBhdHRlbXB0IHN1Y2NlZWRzLlxuICAgKiBAbG9jdXMgQW55d2hlcmVcbiAgICogQHBhcmFtIHtGdW5jdGlvbn0gZnVuYyBUaGUgY2FsbGJhY2sgdG8gYmUgY2FsbGVkIHdoZW4gbG9naW4gaXMgc3VjY2Vzc2Z1bC5cbiAgICogICAgICAgICAgICAgICAgICAgICAgICBUaGUgY2FsbGJhY2sgcmVjZWl2ZXMgYSBzaW5nbGUgb2JqZWN0IHRoYXRcbiAgICogICAgICAgICAgICAgICAgICAgICAgICBob2xkcyBsb2dpbiBkZXRhaWxzLiBUaGlzIG9iamVjdCBjb250YWlucyB0aGUgbG9naW5cbiAgICogICAgICAgICAgICAgICAgICAgICAgICByZXN1bHQgdHlwZSAocGFzc3dvcmQsIHJlc3VtZSwgZXRjLikgb24gYm90aCB0aGVcbiAgICogICAgICAgICAgICAgICAgICAgICAgICBjbGllbnQgYW5kIHNlcnZlci4gYG9uTG9naW5gIGNhbGxiYWNrcyByZWdpc3RlcmVkXG4gICAqICAgICAgICAgICAgICAgICAgICAgICAgb24gdGhlIHNlcnZlciBhbHNvIHJlY2VpdmUgZXh0cmEgZGF0YSwgc3VjaFxuICAgKiAgICAgICAgICAgICAgICAgICAgICAgIGFzIHVzZXIgZGV0YWlscywgY29ubmVjdGlvbiBpbmZvcm1hdGlvbiwgZXRjLlxuICAgKi9cbiAgb25Mb2dpbihmdW5jKSB7XG4gICAgbGV0IHJldCA9IHRoaXMuX29uTG9naW5Ib29rLnJlZ2lzdGVyKGZ1bmMpO1xuICAgIC8vIGNhbGwgdGhlIGp1c3QgcmVnaXN0ZXJlZCBjYWxsYmFjayBpZiBhbHJlYWR5IGxvZ2dlZCBpblxuICAgIHRoaXMuX3N0YXJ0dXBDYWxsYmFjayhyZXQuY2FsbGJhY2spO1xuICAgIHJldHVybiByZXQ7XG4gIH1cblxuICAvKipcbiAgICogQHN1bW1hcnkgUmVnaXN0ZXIgYSBjYWxsYmFjayB0byBiZSBjYWxsZWQgYWZ0ZXIgYSBsb2dpbiBhdHRlbXB0IGZhaWxzLlxuICAgKiBAbG9jdXMgQW55d2hlcmVcbiAgICogQHBhcmFtIHtGdW5jdGlvbn0gZnVuYyBUaGUgY2FsbGJhY2sgdG8gYmUgY2FsbGVkIGFmdGVyIHRoZSBsb2dpbiBoYXMgZmFpbGVkLlxuICAgKi9cbiAgb25Mb2dpbkZhaWx1cmUoZnVuYykge1xuICAgIHJldHVybiB0aGlzLl9vbkxvZ2luRmFpbHVyZUhvb2sucmVnaXN0ZXIoZnVuYyk7XG4gIH1cblxuICAvKipcbiAgICogQHN1bW1hcnkgUmVnaXN0ZXIgYSBjYWxsYmFjayB0byBiZSBjYWxsZWQgYWZ0ZXIgYSBsb2dvdXQgYXR0ZW1wdCBzdWNjZWVkcy5cbiAgICogQGxvY3VzIEFueXdoZXJlXG4gICAqIEBwYXJhbSB7RnVuY3Rpb259IGZ1bmMgVGhlIGNhbGxiYWNrIHRvIGJlIGNhbGxlZCB3aGVuIGxvZ291dCBpcyBzdWNjZXNzZnVsLlxuICAgKi9cbiAgb25Mb2dvdXQoZnVuYykge1xuICAgIHJldHVybiB0aGlzLl9vbkxvZ291dEhvb2sucmVnaXN0ZXIoZnVuYyk7XG4gIH1cblxuICBfaW5pdENvbm5lY3Rpb24ob3B0aW9ucykge1xuICAgIGlmICghTWV0ZW9yLmlzQ2xpZW50KSB7XG4gICAgICByZXR1cm47XG4gICAgfVxuXG4gICAgLy8gVGhlIGNvbm5lY3Rpb24gdXNlZCBieSB0aGUgQWNjb3VudHMgc3lzdGVtLiBUaGlzIGlzIHRoZSBjb25uZWN0aW9uXG4gICAgLy8gdGhhdCB3aWxsIGdldCBsb2dnZWQgaW4gYnkgTWV0ZW9yLmxvZ2luKCksIGFuZCB0aGlzIGlzIHRoZVxuICAgIC8vIGNvbm5lY3Rpb24gd2hvc2UgbG9naW4gc3RhdGUgd2lsbCBiZSByZWZsZWN0ZWQgYnkgTWV0ZW9yLnVzZXJJZCgpLlxuICAgIC8vXG4gICAgLy8gSXQgd291bGQgYmUgbXVjaCBwcmVmZXJhYmxlIGZvciB0aGlzIHRvIGJlIGluIGFjY291bnRzX2NsaWVudC5qcyxcbiAgICAvLyBidXQgaXQgaGFzIHRvIGJlIGhlcmUgYmVjYXVzZSBpdCdzIG5lZWRlZCB0byBjcmVhdGUgdGhlXG4gICAgLy8gTWV0ZW9yLnVzZXJzIGNvbGxlY3Rpb24uXG4gICAgaWYgKG9wdGlvbnMuY29ubmVjdGlvbikge1xuICAgICAgdGhpcy5jb25uZWN0aW9uID0gb3B0aW9ucy5jb25uZWN0aW9uO1xuICAgIH0gZWxzZSBpZiAob3B0aW9ucy5kZHBVcmwpIHtcbiAgICAgIHRoaXMuY29ubmVjdGlvbiA9IEREUC5jb25uZWN0KG9wdGlvbnMuZGRwVXJsKTtcbiAgICB9IGVsc2UgaWYgKFxuICAgICAgdHlwZW9mIF9fbWV0ZW9yX3J1bnRpbWVfY29uZmlnX18gIT09ICd1bmRlZmluZWQnICYmXG4gICAgICBfX21ldGVvcl9ydW50aW1lX2NvbmZpZ19fLkFDQ09VTlRTX0NPTk5FQ1RJT05fVVJMXG4gICAgKSB7XG4gICAgICAvLyBUZW1wb3JhcnksIGludGVybmFsIGhvb2sgdG8gYWxsb3cgdGhlIHNlcnZlciB0byBwb2ludCB0aGUgY2xpZW50XG4gICAgICAvLyB0byBhIGRpZmZlcmVudCBhdXRoZW50aWNhdGlvbiBzZXJ2ZXIuIFRoaXMgaXMgZm9yIGEgdmVyeVxuICAgICAgLy8gcGFydGljdWxhciB1c2UgY2FzZSB0aGF0IGNvbWVzIHVwIHdoZW4gaW1wbGVtZW50aW5nIGEgb2F1dGhcbiAgICAgIC8vIHNlcnZlci4gVW5zdXBwb3J0ZWQgYW5kIG1heSBnbyBhd2F5IGF0IGFueSBwb2ludCBpbiB0aW1lLlxuICAgICAgLy9cbiAgICAgIC8vIFdlIHdpbGwgZXZlbnR1YWxseSBwcm92aWRlIGEgZ2VuZXJhbCB3YXkgdG8gdXNlIGFjY291bnQtYmFzZVxuICAgICAgLy8gYWdhaW5zdCBhbnkgRERQIGNvbm5lY3Rpb24sIG5vdCBqdXN0IG9uZSBzcGVjaWFsIG9uZS5cbiAgICAgIHRoaXMuY29ubmVjdGlvbiA9IEREUC5jb25uZWN0KFxuICAgICAgICBfX21ldGVvcl9ydW50aW1lX2NvbmZpZ19fLkFDQ09VTlRTX0NPTk5FQ1RJT05fVVJMXG4gICAgICApO1xuICAgIH0gZWxzZSB7XG4gICAgICB0aGlzLmNvbm5lY3Rpb24gPSBNZXRlb3IuY29ubmVjdGlvbjtcbiAgICB9XG4gIH1cblxuICBfZ2V0VG9rZW5MaWZldGltZU1zKCkge1xuICAgIC8vIFdoZW4gbG9naW5FeHBpcmF0aW9uSW5EYXlzIGlzIHNldCB0byBudWxsLCB3ZSdsbCB1c2UgYSByZWFsbHkgaGlnaFxuICAgIC8vIG51bWJlciBvZiBkYXlzIChMT0dJTl9VTkVYUElSQUJMRV9UT0tFTl9EQVlTKSB0byBzaW11bGF0ZSBhblxuICAgIC8vIHVuZXhwaXJpbmcgdG9rZW4uXG4gICAgY29uc3QgbG9naW5FeHBpcmF0aW9uSW5EYXlzID1cbiAgICAgIHRoaXMuX29wdGlvbnMubG9naW5FeHBpcmF0aW9uSW5EYXlzID09PSBudWxsXG4gICAgICAgID8gTE9HSU5fVU5FWFBJUklOR19UT0tFTl9EQVlTXG4gICAgICAgIDogdGhpcy5fb3B0aW9ucy5sb2dpbkV4cGlyYXRpb25JbkRheXM7XG4gICAgcmV0dXJuIChcbiAgICAgIHRoaXMuX29wdGlvbnMubG9naW5FeHBpcmF0aW9uIHx8XG4gICAgICAobG9naW5FeHBpcmF0aW9uSW5EYXlzIHx8IERFRkFVTFRfTE9HSU5fRVhQSVJBVElPTl9EQVlTKSAqIDg2NDAwMDAwXG4gICAgKTtcbiAgfVxuXG4gIF9nZXRQYXNzd29yZFJlc2V0VG9rZW5MaWZldGltZU1zKCkge1xuICAgIHJldHVybiAoXG4gICAgICB0aGlzLl9vcHRpb25zLnBhc3N3b3JkUmVzZXRUb2tlbkV4cGlyYXRpb24gfHxcbiAgICAgICh0aGlzLl9vcHRpb25zLnBhc3N3b3JkUmVzZXRUb2tlbkV4cGlyYXRpb25JbkRheXMgfHxcbiAgICAgICAgREVGQVVMVF9QQVNTV09SRF9SRVNFVF9UT0tFTl9FWFBJUkFUSU9OX0RBWVMpICogODY0MDAwMDBcbiAgICApO1xuICB9XG5cbiAgX2dldFBhc3N3b3JkRW5yb2xsVG9rZW5MaWZldGltZU1zKCkge1xuICAgIHJldHVybiAoXG4gICAgICB0aGlzLl9vcHRpb25zLnBhc3N3b3JkRW5yb2xsVG9rZW5FeHBpcmF0aW9uIHx8XG4gICAgICAodGhpcy5fb3B0aW9ucy5wYXNzd29yZEVucm9sbFRva2VuRXhwaXJhdGlvbkluRGF5cyB8fFxuICAgICAgICBERUZBVUxUX1BBU1NXT1JEX0VOUk9MTF9UT0tFTl9FWFBJUkFUSU9OX0RBWVMpICogODY0MDAwMDBcbiAgICApO1xuICB9XG5cbiAgX3Rva2VuRXhwaXJhdGlvbih3aGVuKSB7XG4gICAgLy8gV2UgcGFzcyB3aGVuIHRocm91Z2ggdGhlIERhdGUgY29uc3RydWN0b3IgZm9yIGJhY2t3YXJkcyBjb21wYXRpYmlsaXR5O1xuICAgIC8vIGB3aGVuYCB1c2VkIHRvIGJlIGEgbnVtYmVyLlxuICAgIHJldHVybiBuZXcgRGF0ZShuZXcgRGF0ZSh3aGVuKS5nZXRUaW1lKCkgKyB0aGlzLl9nZXRUb2tlbkxpZmV0aW1lTXMoKSk7XG4gIH1cblxuICBfdG9rZW5FeHBpcmVzU29vbih3aGVuKSB7XG4gICAgbGV0IG1pbkxpZmV0aW1lTXMgPSAwLjEgKiB0aGlzLl9nZXRUb2tlbkxpZmV0aW1lTXMoKTtcbiAgICBjb25zdCBtaW5MaWZldGltZUNhcE1zID0gTUlOX1RPS0VOX0xJRkVUSU1FX0NBUF9TRUNTICogMTAwMDtcbiAgICBpZiAobWluTGlmZXRpbWVNcyA+IG1pbkxpZmV0aW1lQ2FwTXMpIHtcbiAgICAgIG1pbkxpZmV0aW1lTXMgPSBtaW5MaWZldGltZUNhcE1zO1xuICAgIH1cbiAgICByZXR1cm4gbmV3IERhdGUoKSA+IG5ldyBEYXRlKHdoZW4pIC0gbWluTGlmZXRpbWVNcztcbiAgfVxuXG4gIC8vIE5vLW9wIG9uIHRoZSBzZXJ2ZXIsIG92ZXJyaWRkZW4gb24gdGhlIGNsaWVudC5cbiAgX3N0YXJ0dXBDYWxsYmFjayhjYWxsYmFjaykge31cbn1cblxuLy8gTm90ZSB0aGF0IEFjY291bnRzIGlzIGRlZmluZWQgc2VwYXJhdGVseSBpbiBhY2NvdW50c19jbGllbnQuanMgYW5kXG4vLyBhY2NvdW50c19zZXJ2ZXIuanMuXG5cbi8qKlxuICogQHN1bW1hcnkgR2V0IHRoZSBjdXJyZW50IHVzZXIgaWQsIG9yIGBudWxsYCBpZiBubyB1c2VyIGlzIGxvZ2dlZCBpbi4gQSByZWFjdGl2ZSBkYXRhIHNvdXJjZS5cbiAqIEBsb2N1cyBBbnl3aGVyZSBidXQgcHVibGlzaCBmdW5jdGlvbnNcbiAqIEBpbXBvcnRGcm9tUGFja2FnZSBtZXRlb3JcbiAqL1xuTWV0ZW9yLnVzZXJJZCA9ICgpID0+IEFjY291bnRzLnVzZXJJZCgpO1xuXG4vKipcbiAqIEBzdW1tYXJ5IEdldCB0aGUgY3VycmVudCB1c2VyIHJlY29yZCwgb3IgYG51bGxgIGlmIG5vIHVzZXIgaXMgbG9nZ2VkIGluLiBBIHJlYWN0aXZlIGRhdGEgc291cmNlLlxuICogQGxvY3VzIEFueXdoZXJlIGJ1dCBwdWJsaXNoIGZ1bmN0aW9uc1xuICogQGltcG9ydEZyb21QYWNrYWdlIG1ldGVvclxuICogQHBhcmFtIHtPYmplY3R9IFtvcHRpb25zXVxuICogQHBhcmFtIHtNb25nb0ZpZWxkU3BlY2lmaWVyfSBvcHRpb25zLmZpZWxkcyBEaWN0aW9uYXJ5IG9mIGZpZWxkcyB0byByZXR1cm4gb3IgZXhjbHVkZS5cbiAqL1xuTWV0ZW9yLnVzZXIgPSBvcHRpb25zID0+IEFjY291bnRzLnVzZXIob3B0aW9ucyk7XG5cbi8vIGhvdyBsb25nIChpbiBkYXlzKSB1bnRpbCBhIGxvZ2luIHRva2VuIGV4cGlyZXNcbmNvbnN0IERFRkFVTFRfTE9HSU5fRVhQSVJBVElPTl9EQVlTID0gOTA7XG4vLyBob3cgbG9uZyAoaW4gZGF5cykgdW50aWwgcmVzZXQgcGFzc3dvcmQgdG9rZW4gZXhwaXJlc1xuY29uc3QgREVGQVVMVF9QQVNTV09SRF9SRVNFVF9UT0tFTl9FWFBJUkFUSU9OX0RBWVMgPSAzO1xuLy8gaG93IGxvbmcgKGluIGRheXMpIHVudGlsIGVucm9sIHBhc3N3b3JkIHRva2VuIGV4cGlyZXNcbmNvbnN0IERFRkFVTFRfUEFTU1dPUkRfRU5ST0xMX1RPS0VOX0VYUElSQVRJT05fREFZUyA9IDMwO1xuLy8gQ2xpZW50cyBkb24ndCB0cnkgdG8gYXV0by1sb2dpbiB3aXRoIGEgdG9rZW4gdGhhdCBpcyBnb2luZyB0byBleHBpcmUgd2l0aGluXG4vLyAuMSAqIERFRkFVTFRfTE9HSU5fRVhQSVJBVElPTl9EQVlTLCBjYXBwZWQgYXQgTUlOX1RPS0VOX0xJRkVUSU1FX0NBUF9TRUNTLlxuLy8gVHJpZXMgdG8gYXZvaWQgYWJydXB0IGRpc2Nvbm5lY3RzIGZyb20gZXhwaXJpbmcgdG9rZW5zLlxuY29uc3QgTUlOX1RPS0VOX0xJRkVUSU1FX0NBUF9TRUNTID0gMzYwMDsgLy8gb25lIGhvdXJcbi8vIGhvdyBvZnRlbiAoaW4gbWlsbGlzZWNvbmRzKSB3ZSBjaGVjayBmb3IgZXhwaXJlZCB0b2tlbnNcbmV4cG9ydCBjb25zdCBFWFBJUkVfVE9LRU5TX0lOVEVSVkFMX01TID0gNjAwICogMTAwMDsgLy8gMTAgbWludXRlc1xuLy8gaG93IGxvbmcgd2Ugd2FpdCBiZWZvcmUgbG9nZ2luZyBvdXQgY2xpZW50cyB3aGVuIE1ldGVvci5sb2dvdXRPdGhlckNsaWVudHMgaXNcbi8vIGNhbGxlZFxuZXhwb3J0IGNvbnN0IENPTk5FQ1RJT05fQ0xPU0VfREVMQVlfTVMgPSAxMCAqIDEwMDA7XG4vLyBBIGxhcmdlIG51bWJlciBvZiBleHBpcmF0aW9uIGRheXMgKGFwcHJveGltYXRlbHkgMTAwIHllYXJzIHdvcnRoKSB0aGF0IGlzXG4vLyB1c2VkIHdoZW4gY3JlYXRpbmcgdW5leHBpcmluZyB0b2tlbnMuXG5jb25zdCBMT0dJTl9VTkVYUElSSU5HX1RPS0VOX0RBWVMgPSAzNjUgKiAxMDA7XG4iLCJpbXBvcnQgY3J5cHRvIGZyb20gJ2NyeXB0byc7XG5pbXBvcnQge1xuICBBY2NvdW50c0NvbW1vbixcbiAgRVhQSVJFX1RPS0VOU19JTlRFUlZBTF9NUyxcbn0gZnJvbSAnLi9hY2NvdW50c19jb21tb24uanMnO1xuaW1wb3J0IHsgVVJMIH0gZnJvbSAnbWV0ZW9yL3VybCc7XG5cbmNvbnN0IGhhc093biA9IE9iamVjdC5wcm90b3R5cGUuaGFzT3duUHJvcGVydHk7XG5cbi8vIFhYWCBtYXliZSB0aGlzIGJlbG9uZ3MgaW4gdGhlIGNoZWNrIHBhY2thZ2VcbmNvbnN0IE5vbkVtcHR5U3RyaW5nID0gTWF0Y2guV2hlcmUoeCA9PiB7XG4gIGNoZWNrKHgsIFN0cmluZyk7XG4gIHJldHVybiB4Lmxlbmd0aCA+IDA7XG59KTtcblxuLyoqXG4gKiBAc3VtbWFyeSBDb25zdHJ1Y3RvciBmb3IgdGhlIGBBY2NvdW50c2AgbmFtZXNwYWNlIG9uIHRoZSBzZXJ2ZXIuXG4gKiBAbG9jdXMgU2VydmVyXG4gKiBAY2xhc3MgQWNjb3VudHNTZXJ2ZXJcbiAqIEBleHRlbmRzIEFjY291bnRzQ29tbW9uXG4gKiBAaW5zdGFuY2VuYW1lIGFjY291bnRzU2VydmVyXG4gKiBAcGFyYW0ge09iamVjdH0gc2VydmVyIEEgc2VydmVyIG9iamVjdCBzdWNoIGFzIGBNZXRlb3Iuc2VydmVyYC5cbiAqL1xuZXhwb3J0IGNsYXNzIEFjY291bnRzU2VydmVyIGV4dGVuZHMgQWNjb3VudHNDb21tb24ge1xuICAvLyBOb3RlIHRoYXQgdGhpcyBjb25zdHJ1Y3RvciBpcyBsZXNzIGxpa2VseSB0byBiZSBpbnN0YW50aWF0ZWQgbXVsdGlwbGVcbiAgLy8gdGltZXMgdGhhbiB0aGUgYEFjY291bnRzQ2xpZW50YCBjb25zdHJ1Y3RvciwgYmVjYXVzZSBhIHNpbmdsZSBzZXJ2ZXJcbiAgLy8gY2FuIHByb3ZpZGUgb25seSBvbmUgc2V0IG9mIG1ldGhvZHMuXG4gIGNvbnN0cnVjdG9yKHNlcnZlcikge1xuICAgIHN1cGVyKCk7XG5cbiAgICB0aGlzLl9zZXJ2ZXIgPSBzZXJ2ZXIgfHwgTWV0ZW9yLnNlcnZlcjtcbiAgICAvLyBTZXQgdXAgdGhlIHNlcnZlcidzIG1ldGhvZHMsIGFzIGlmIGJ5IGNhbGxpbmcgTWV0ZW9yLm1ldGhvZHMuXG4gICAgdGhpcy5faW5pdFNlcnZlck1ldGhvZHMoKTtcblxuICAgIHRoaXMuX2luaXRBY2NvdW50RGF0YUhvb2tzKCk7XG5cbiAgICAvLyBJZiBhdXRvcHVibGlzaCBpcyBvbiwgcHVibGlzaCB0aGVzZSB1c2VyIGZpZWxkcy4gTG9naW4gc2VydmljZVxuICAgIC8vIHBhY2thZ2VzIChlZyBhY2NvdW50cy1nb29nbGUpIGFkZCB0byB0aGVzZSBieSBjYWxsaW5nXG4gICAgLy8gYWRkQXV0b3B1Ymxpc2hGaWVsZHMuICBOb3RhYmx5LCB0aGlzIGlzbid0IGltcGxlbWVudGVkIHdpdGggbXVsdGlwbGVcbiAgICAvLyBwdWJsaXNoZXMgc2luY2UgRERQIG9ubHkgbWVyZ2VzIG9ubHkgYWNyb3NzIHRvcC1sZXZlbCBmaWVsZHMsIG5vdFxuICAgIC8vIHN1YmZpZWxkcyAoc3VjaCBhcyAnc2VydmljZXMuZmFjZWJvb2suYWNjZXNzVG9rZW4nKVxuICAgIHRoaXMuX2F1dG9wdWJsaXNoRmllbGRzID0ge1xuICAgICAgbG9nZ2VkSW5Vc2VyOiBbJ3Byb2ZpbGUnLCAndXNlcm5hbWUnLCAnZW1haWxzJ10sXG4gICAgICBvdGhlclVzZXJzOiBbJ3Byb2ZpbGUnLCAndXNlcm5hbWUnXVxuICAgIH07XG5cbiAgICAvLyB1c2Ugb2JqZWN0IHRvIGtlZXAgdGhlIHJlZmVyZW5jZSB3aGVuIHVzZWQgaW4gZnVuY3Rpb25zXG4gICAgLy8gd2hlcmUgX2RlZmF1bHRQdWJsaXNoRmllbGRzIGlzIGRlc3RydWN0dXJlZCBpbnRvIGxleGljYWwgc2NvcGVcbiAgICAvLyBmb3IgcHVibGlzaCBjYWxsYmFja3MgdGhhdCBuZWVkIGB0aGlzYFxuICAgIHRoaXMuX2RlZmF1bHRQdWJsaXNoRmllbGRzID0ge1xuICAgICAgcHJvamVjdGlvbjoge1xuICAgICAgICBwcm9maWxlOiAxLFxuICAgICAgICB1c2VybmFtZTogMSxcbiAgICAgICAgZW1haWxzOiAxLFxuICAgICAgfVxuICAgIH07XG5cbiAgICB0aGlzLl9pbml0U2VydmVyUHVibGljYXRpb25zKCk7XG5cbiAgICAvLyBjb25uZWN0aW9uSWQgLT4ge2Nvbm5lY3Rpb24sIGxvZ2luVG9rZW59XG4gICAgdGhpcy5fYWNjb3VudERhdGEgPSB7fTtcblxuICAgIC8vIGNvbm5lY3Rpb24gaWQgLT4gb2JzZXJ2ZSBoYW5kbGUgZm9yIHRoZSBsb2dpbiB0b2tlbiB0aGF0IHRoaXMgY29ubmVjdGlvbiBpc1xuICAgIC8vIGN1cnJlbnRseSBhc3NvY2lhdGVkIHdpdGgsIG9yIGEgbnVtYmVyLiBUaGUgbnVtYmVyIGluZGljYXRlcyB0aGF0IHdlIGFyZSBpblxuICAgIC8vIHRoZSBwcm9jZXNzIG9mIHNldHRpbmcgdXAgdGhlIG9ic2VydmUgKHVzaW5nIGEgbnVtYmVyIGluc3RlYWQgb2YgYSBzaW5nbGVcbiAgICAvLyBzZW50aW5lbCBhbGxvd3MgbXVsdGlwbGUgYXR0ZW1wdHMgdG8gc2V0IHVwIHRoZSBvYnNlcnZlIHRvIGlkZW50aWZ5IHdoaWNoXG4gICAgLy8gb25lIHdhcyB0aGVpcnMpLlxuICAgIHRoaXMuX3VzZXJPYnNlcnZlc0ZvckNvbm5lY3Rpb25zID0ge307XG4gICAgdGhpcy5fbmV4dFVzZXJPYnNlcnZlTnVtYmVyID0gMTsgIC8vIGZvciB0aGUgbnVtYmVyIGRlc2NyaWJlZCBhYm92ZS5cblxuICAgIC8vIGxpc3Qgb2YgYWxsIHJlZ2lzdGVyZWQgaGFuZGxlcnMuXG4gICAgdGhpcy5fbG9naW5IYW5kbGVycyA9IFtdO1xuXG4gICAgc2V0dXBVc2Vyc0NvbGxlY3Rpb24odGhpcy51c2Vycyk7XG4gICAgc2V0dXBEZWZhdWx0TG9naW5IYW5kbGVycyh0aGlzKTtcbiAgICBzZXRFeHBpcmVUb2tlbnNJbnRlcnZhbCh0aGlzKTtcblxuICAgIHRoaXMuX3ZhbGlkYXRlTG9naW5Ib29rID0gbmV3IEhvb2soeyBiaW5kRW52aXJvbm1lbnQ6IGZhbHNlIH0pO1xuICAgIHRoaXMuX3ZhbGlkYXRlTmV3VXNlckhvb2tzID0gW1xuICAgICAgZGVmYXVsdFZhbGlkYXRlTmV3VXNlckhvb2suYmluZCh0aGlzKVxuICAgIF07XG5cbiAgICB0aGlzLl9kZWxldGVTYXZlZFRva2Vuc0ZvckFsbFVzZXJzT25TdGFydHVwKCk7XG5cbiAgICB0aGlzLl9za2lwQ2FzZUluc2Vuc2l0aXZlQ2hlY2tzRm9yVGVzdCA9IHt9O1xuXG4gICAgdGhpcy51cmxzID0ge1xuICAgICAgcmVzZXRQYXNzd29yZDogKHRva2VuLCBleHRyYVBhcmFtcykgPT4gdGhpcy5idWlsZEVtYWlsVXJsKGAjL3Jlc2V0LXBhc3N3b3JkLyR7dG9rZW59YCwgZXh0cmFQYXJhbXMpLFxuICAgICAgdmVyaWZ5RW1haWw6ICh0b2tlbiwgZXh0cmFQYXJhbXMpID0+IHRoaXMuYnVpbGRFbWFpbFVybChgIy92ZXJpZnktZW1haWwvJHt0b2tlbn1gLCBleHRyYVBhcmFtcyksXG4gICAgICBsb2dpblRva2VuOiAoc2VsZWN0b3IsIHRva2VuLCBleHRyYVBhcmFtcykgPT5cbiAgICAgICAgdGhpcy5idWlsZEVtYWlsVXJsKGAvP2xvZ2luVG9rZW49JHt0b2tlbn0mc2VsZWN0b3I9JHtzZWxlY3Rvcn1gLCBleHRyYVBhcmFtcyksXG4gICAgICBlbnJvbGxBY2NvdW50OiAodG9rZW4sIGV4dHJhUGFyYW1zKSA9PiB0aGlzLmJ1aWxkRW1haWxVcmwoYCMvZW5yb2xsLWFjY291bnQvJHt0b2tlbn1gLCBleHRyYVBhcmFtcyksXG4gICAgfTtcblxuICAgIHRoaXMuYWRkRGVmYXVsdFJhdGVMaW1pdCgpO1xuXG4gICAgdGhpcy5idWlsZEVtYWlsVXJsID0gKHBhdGgsIGV4dHJhUGFyYW1zID0ge30pID0+IHtcbiAgICAgIGNvbnN0IHVybCA9IG5ldyBVUkwoTWV0ZW9yLmFic29sdXRlVXJsKHBhdGgpKTtcbiAgICAgIGNvbnN0IHBhcmFtcyA9IE9iamVjdC5lbnRyaWVzKGV4dHJhUGFyYW1zKTtcbiAgICAgIGlmIChwYXJhbXMubGVuZ3RoID4gMCkge1xuICAgICAgICAvLyBBZGQgYWRkaXRpb25hbCBwYXJhbWV0ZXJzIHRvIHRoZSB1cmxcbiAgICAgICAgZm9yIChjb25zdCBba2V5LCB2YWx1ZV0gb2YgcGFyYW1zKSB7XG4gICAgICAgICAgdXJsLnNlYXJjaFBhcmFtcy5hcHBlbmQoa2V5LCB2YWx1ZSk7XG4gICAgICAgIH1cbiAgICAgIH1cbiAgICAgIHJldHVybiB1cmwudG9TdHJpbmcoKTtcbiAgICB9O1xuICB9XG5cbiAgLy8vXG4gIC8vLyBDVVJSRU5UIFVTRVJcbiAgLy8vXG5cbiAgLy8gQG92ZXJyaWRlIG9mIFwiYWJzdHJhY3RcIiBub24taW1wbGVtZW50YXRpb24gaW4gYWNjb3VudHNfY29tbW9uLmpzXG4gIHVzZXJJZCgpIHtcbiAgICAvLyBUaGlzIGZ1bmN0aW9uIG9ubHkgd29ya3MgaWYgY2FsbGVkIGluc2lkZSBhIG1ldGhvZCBvciBhIHB1YmljYXRpb24uXG4gICAgLy8gVXNpbmcgYW55IG9mIHRoZSBpbmZvcm1hdGlvbiBmcm9tIE1ldGVvci51c2VyKCkgaW4gYSBtZXRob2Qgb3JcbiAgICAvLyBwdWJsaXNoIGZ1bmN0aW9uIHdpbGwgYWx3YXlzIHVzZSB0aGUgdmFsdWUgZnJvbSB3aGVuIHRoZSBmdW5jdGlvbiBmaXJzdFxuICAgIC8vIHJ1bnMuIFRoaXMgaXMgbGlrZWx5IG5vdCB3aGF0IHRoZSB1c2VyIGV4cGVjdHMuIFRoZSB3YXkgdG8gbWFrZSB0aGlzIHdvcmtcbiAgICAvLyBpbiBhIG1ldGhvZCBvciBwdWJsaXNoIGZ1bmN0aW9uIGlzIHRvIGRvIE1ldGVvci5maW5kKHRoaXMudXNlcklkKS5vYnNlcnZlXG4gICAgLy8gYW5kIHJlY29tcHV0ZSB3aGVuIHRoZSB1c2VyIHJlY29yZCBjaGFuZ2VzLlxuICAgIGNvbnN0IGN1cnJlbnRJbnZvY2F0aW9uID0gRERQLl9DdXJyZW50TWV0aG9kSW52b2NhdGlvbi5nZXQoKSB8fCBERFAuX0N1cnJlbnRQdWJsaWNhdGlvbkludm9jYXRpb24uZ2V0KCk7XG4gICAgaWYgKCFjdXJyZW50SW52b2NhdGlvbilcbiAgICAgIHRocm93IG5ldyBFcnJvcihcIk1ldGVvci51c2VySWQgY2FuIG9ubHkgYmUgaW52b2tlZCBpbiBtZXRob2QgY2FsbHMgb3IgcHVibGljYXRpb25zLlwiKTtcbiAgICByZXR1cm4gY3VycmVudEludm9jYXRpb24udXNlcklkO1xuICB9XG5cbiAgLy8vXG4gIC8vLyBMT0dJTiBIT09LU1xuICAvLy9cblxuICAvKipcbiAgICogQHN1bW1hcnkgVmFsaWRhdGUgbG9naW4gYXR0ZW1wdHMuXG4gICAqIEBsb2N1cyBTZXJ2ZXJcbiAgICogQHBhcmFtIHtGdW5jdGlvbn0gZnVuYyBDYWxsZWQgd2hlbmV2ZXIgYSBsb2dpbiBpcyBhdHRlbXB0ZWQgKGVpdGhlciBzdWNjZXNzZnVsIG9yIHVuc3VjY2Vzc2Z1bCkuICBBIGxvZ2luIGNhbiBiZSBhYm9ydGVkIGJ5IHJldHVybmluZyBhIGZhbHN5IHZhbHVlIG9yIHRocm93aW5nIGFuIGV4Y2VwdGlvbi5cbiAgICovXG4gIHZhbGlkYXRlTG9naW5BdHRlbXB0KGZ1bmMpIHtcbiAgICAvLyBFeGNlcHRpb25zIGluc2lkZSB0aGUgaG9vayBjYWxsYmFjayBhcmUgcGFzc2VkIHVwIHRvIHVzLlxuICAgIHJldHVybiB0aGlzLl92YWxpZGF0ZUxvZ2luSG9vay5yZWdpc3RlcihmdW5jKTtcbiAgfVxuXG4gIC8qKlxuICAgKiBAc3VtbWFyeSBTZXQgcmVzdHJpY3Rpb25zIG9uIG5ldyB1c2VyIGNyZWF0aW9uLlxuICAgKiBAbG9jdXMgU2VydmVyXG4gICAqIEBwYXJhbSB7RnVuY3Rpb259IGZ1bmMgQ2FsbGVkIHdoZW5ldmVyIGEgbmV3IHVzZXIgaXMgY3JlYXRlZC4gVGFrZXMgdGhlIG5ldyB1c2VyIG9iamVjdCwgYW5kIHJldHVybnMgdHJ1ZSB0byBhbGxvdyB0aGUgY3JlYXRpb24gb3IgZmFsc2UgdG8gYWJvcnQuXG4gICAqL1xuICB2YWxpZGF0ZU5ld1VzZXIoZnVuYykge1xuICAgIHRoaXMuX3ZhbGlkYXRlTmV3VXNlckhvb2tzLnB1c2goZnVuYyk7XG4gIH1cblxuICAvKipcbiAgICogQHN1bW1hcnkgVmFsaWRhdGUgbG9naW4gZnJvbSBleHRlcm5hbCBzZXJ2aWNlXG4gICAqIEBsb2N1cyBTZXJ2ZXJcbiAgICogQHBhcmFtIHtGdW5jdGlvbn0gZnVuYyBDYWxsZWQgd2hlbmV2ZXIgbG9naW4vdXNlciBjcmVhdGlvbiBmcm9tIGV4dGVybmFsIHNlcnZpY2UgaXMgYXR0ZW1wdGVkLiBMb2dpbiBvciB1c2VyIGNyZWF0aW9uIGJhc2VkIG9uIHRoaXMgbG9naW4gY2FuIGJlIGFib3J0ZWQgYnkgcGFzc2luZyBhIGZhbHN5IHZhbHVlIG9yIHRocm93aW5nIGFuIGV4Y2VwdGlvbi5cbiAgICovXG4gIGJlZm9yZUV4dGVybmFsTG9naW4oZnVuYykge1xuICAgIGlmICh0aGlzLl9iZWZvcmVFeHRlcm5hbExvZ2luSG9vaykge1xuICAgICAgdGhyb3cgbmV3IEVycm9yKFwiQ2FuIG9ubHkgY2FsbCBiZWZvcmVFeHRlcm5hbExvZ2luIG9uY2VcIik7XG4gICAgfVxuXG4gICAgdGhpcy5fYmVmb3JlRXh0ZXJuYWxMb2dpbkhvb2sgPSBmdW5jO1xuICB9XG5cbiAgLy8vXG4gIC8vLyBDUkVBVEUgVVNFUiBIT09LU1xuICAvLy9cblxuICAvKipcbiAgICogQHN1bW1hcnkgQ3VzdG9taXplIGxvZ2luIHRva2VuIGNyZWF0aW9uLlxuICAgKiBAbG9jdXMgU2VydmVyXG4gICAqIEBwYXJhbSB7RnVuY3Rpb259IGZ1bmMgQ2FsbGVkIHdoZW5ldmVyIGEgbmV3IHRva2VuIGlzIGNyZWF0ZWQuXG4gICAqIFJldHVybiB0aGUgc2VxdWVuY2UgYW5kIHRoZSB1c2VyIG9iamVjdC4gUmV0dXJuIHRydWUgdG8ga2VlcCBzZW5kaW5nIHRoZSBkZWZhdWx0IGVtYWlsLCBvciBmYWxzZSB0byBvdmVycmlkZSB0aGUgYmVoYXZpb3IuXG4gICAqL1xuICBvbkNyZWF0ZUxvZ2luVG9rZW4gPSBmdW5jdGlvbihmdW5jKSB7XG4gICAgaWYgKHRoaXMuX29uQ3JlYXRlTG9naW5Ub2tlbkhvb2spIHtcbiAgICAgIHRocm93IG5ldyBFcnJvcignQ2FuIG9ubHkgY2FsbCBvbkNyZWF0ZUxvZ2luVG9rZW4gb25jZScpO1xuICAgIH1cblxuICAgIHRoaXMuX29uQ3JlYXRlTG9naW5Ub2tlbkhvb2sgPSBmdW5jO1xuICB9O1xuXG4gIC8qKlxuICAgKiBAc3VtbWFyeSBDdXN0b21pemUgbmV3IHVzZXIgY3JlYXRpb24uXG4gICAqIEBsb2N1cyBTZXJ2ZXJcbiAgICogQHBhcmFtIHtGdW5jdGlvbn0gZnVuYyBDYWxsZWQgd2hlbmV2ZXIgYSBuZXcgdXNlciBpcyBjcmVhdGVkLiBSZXR1cm4gdGhlIG5ldyB1c2VyIG9iamVjdCwgb3IgdGhyb3cgYW4gYEVycm9yYCB0byBhYm9ydCB0aGUgY3JlYXRpb24uXG4gICAqL1xuICBvbkNyZWF0ZVVzZXIoZnVuYykge1xuICAgIGlmICh0aGlzLl9vbkNyZWF0ZVVzZXJIb29rKSB7XG4gICAgICB0aHJvdyBuZXcgRXJyb3IoXCJDYW4gb25seSBjYWxsIG9uQ3JlYXRlVXNlciBvbmNlXCIpO1xuICAgIH1cblxuICAgIHRoaXMuX29uQ3JlYXRlVXNlckhvb2sgPSBmdW5jO1xuICB9XG5cbiAgLyoqXG4gICAqIEBzdW1tYXJ5IEN1c3RvbWl6ZSBvYXV0aCB1c2VyIHByb2ZpbGUgdXBkYXRlc1xuICAgKiBAbG9jdXMgU2VydmVyXG4gICAqIEBwYXJhbSB7RnVuY3Rpb259IGZ1bmMgQ2FsbGVkIHdoZW5ldmVyIGEgdXNlciBpcyBsb2dnZWQgaW4gdmlhIG9hdXRoLiBSZXR1cm4gdGhlIHByb2ZpbGUgb2JqZWN0IHRvIGJlIG1lcmdlZCwgb3IgdGhyb3cgYW4gYEVycm9yYCB0byBhYm9ydCB0aGUgY3JlYXRpb24uXG4gICAqL1xuICBvbkV4dGVybmFsTG9naW4oZnVuYykge1xuICAgIGlmICh0aGlzLl9vbkV4dGVybmFsTG9naW5Ib29rKSB7XG4gICAgICB0aHJvdyBuZXcgRXJyb3IoXCJDYW4gb25seSBjYWxsIG9uRXh0ZXJuYWxMb2dpbiBvbmNlXCIpO1xuICAgIH1cblxuICAgIHRoaXMuX29uRXh0ZXJuYWxMb2dpbkhvb2sgPSBmdW5jO1xuICB9XG5cbiAgLyoqXG4gICAqIEBzdW1tYXJ5IEN1c3RvbWl6ZSB1c2VyIHNlbGVjdGlvbiBvbiBleHRlcm5hbCBsb2dpbnNcbiAgICogQGxvY3VzIFNlcnZlclxuICAgKiBAcGFyYW0ge0Z1bmN0aW9ufSBmdW5jIENhbGxlZCB3aGVuZXZlciBhIHVzZXIgaXMgbG9nZ2VkIGluIHZpYSBvYXV0aCBhbmQgYVxuICAgKiB1c2VyIGlzIG5vdCBmb3VuZCB3aXRoIHRoZSBzZXJ2aWNlIGlkLiBSZXR1cm4gdGhlIHVzZXIgb3IgdW5kZWZpbmVkLlxuICAgKi9cbiAgc2V0QWRkaXRpb25hbEZpbmRVc2VyT25FeHRlcm5hbExvZ2luKGZ1bmMpIHtcbiAgICBpZiAodGhpcy5fYWRkaXRpb25hbEZpbmRVc2VyT25FeHRlcm5hbExvZ2luKSB7XG4gICAgICB0aHJvdyBuZXcgRXJyb3IoXCJDYW4gb25seSBjYWxsIHNldEFkZGl0aW9uYWxGaW5kVXNlck9uRXh0ZXJuYWxMb2dpbiBvbmNlXCIpO1xuICAgIH1cbiAgICB0aGlzLl9hZGRpdGlvbmFsRmluZFVzZXJPbkV4dGVybmFsTG9naW4gPSBmdW5jO1xuICB9XG5cbiAgX3ZhbGlkYXRlTG9naW4oY29ubmVjdGlvbiwgYXR0ZW1wdCkge1xuICAgIHRoaXMuX3ZhbGlkYXRlTG9naW5Ib29rLmZvckVhY2goY2FsbGJhY2sgPT4ge1xuICAgICAgbGV0IHJldDtcbiAgICAgIHRyeSB7XG4gICAgICAgIHJldCA9IGNhbGxiYWNrKGNsb25lQXR0ZW1wdFdpdGhDb25uZWN0aW9uKGNvbm5lY3Rpb24sIGF0dGVtcHQpKTtcbiAgICAgIH1cbiAgICAgIGNhdGNoIChlKSB7XG4gICAgICAgIGF0dGVtcHQuYWxsb3dlZCA9IGZhbHNlO1xuICAgICAgICAvLyBYWFggdGhpcyBtZWFucyB0aGUgbGFzdCB0aHJvd24gZXJyb3Igb3ZlcnJpZGVzIHByZXZpb3VzIGVycm9yXG4gICAgICAgIC8vIG1lc3NhZ2VzLiBNYXliZSB0aGlzIGlzIHN1cnByaXNpbmcgdG8gdXNlcnMgYW5kIHdlIHNob3VsZCBtYWtlXG4gICAgICAgIC8vIG92ZXJyaWRpbmcgZXJyb3JzIG1vcmUgZXhwbGljaXQuIChzZWVcbiAgICAgICAgLy8gaHR0cHM6Ly9naXRodWIuY29tL21ldGVvci9tZXRlb3IvaXNzdWVzLzE5NjApXG4gICAgICAgIGF0dGVtcHQuZXJyb3IgPSBlO1xuICAgICAgICByZXR1cm4gdHJ1ZTtcbiAgICAgIH1cbiAgICAgIGlmICghIHJldCkge1xuICAgICAgICBhdHRlbXB0LmFsbG93ZWQgPSBmYWxzZTtcbiAgICAgICAgLy8gZG9uJ3Qgb3ZlcnJpZGUgYSBzcGVjaWZpYyBlcnJvciBwcm92aWRlZCBieSBhIHByZXZpb3VzXG4gICAgICAgIC8vIHZhbGlkYXRvciBvciB0aGUgaW5pdGlhbCBhdHRlbXB0IChlZyBcImluY29ycmVjdCBwYXNzd29yZFwiKS5cbiAgICAgICAgaWYgKCFhdHRlbXB0LmVycm9yKVxuICAgICAgICAgIGF0dGVtcHQuZXJyb3IgPSBuZXcgTWV0ZW9yLkVycm9yKDQwMywgXCJMb2dpbiBmb3JiaWRkZW5cIik7XG4gICAgICB9XG4gICAgICByZXR1cm4gdHJ1ZTtcbiAgICB9KTtcbiAgfTtcblxuICBfc3VjY2Vzc2Z1bExvZ2luKGNvbm5lY3Rpb24sIGF0dGVtcHQpIHtcbiAgICB0aGlzLl9vbkxvZ2luSG9vay5lYWNoKGNhbGxiYWNrID0+IHtcbiAgICAgIGNhbGxiYWNrKGNsb25lQXR0ZW1wdFdpdGhDb25uZWN0aW9uKGNvbm5lY3Rpb24sIGF0dGVtcHQpKTtcbiAgICAgIHJldHVybiB0cnVlO1xuICAgIH0pO1xuICB9O1xuXG4gIF9mYWlsZWRMb2dpbihjb25uZWN0aW9uLCBhdHRlbXB0KSB7XG4gICAgdGhpcy5fb25Mb2dpbkZhaWx1cmVIb29rLmVhY2goY2FsbGJhY2sgPT4ge1xuICAgICAgY2FsbGJhY2soY2xvbmVBdHRlbXB0V2l0aENvbm5lY3Rpb24oY29ubmVjdGlvbiwgYXR0ZW1wdCkpO1xuICAgICAgcmV0dXJuIHRydWU7XG4gICAgfSk7XG4gIH07XG5cbiAgX3N1Y2Nlc3NmdWxMb2dvdXQoY29ubmVjdGlvbiwgdXNlcklkKSB7XG4gICAgLy8gZG9uJ3QgZmV0Y2ggdGhlIHVzZXIgb2JqZWN0IHVubGVzcyB0aGVyZSBhcmUgc29tZSBjYWxsYmFja3MgcmVnaXN0ZXJlZFxuICAgIGxldCB1c2VyO1xuICAgIHRoaXMuX29uTG9nb3V0SG9vay5lYWNoKGNhbGxiYWNrID0+IHtcbiAgICAgIGlmICghdXNlciAmJiB1c2VySWQpIHVzZXIgPSB0aGlzLnVzZXJzLmZpbmRPbmUodXNlcklkLCB7ZmllbGRzOiB0aGlzLl9vcHRpb25zLmRlZmF1bHRGaWVsZFNlbGVjdG9yfSk7XG4gICAgICBjYWxsYmFjayh7IHVzZXIsIGNvbm5lY3Rpb24gfSk7XG4gICAgICByZXR1cm4gdHJ1ZTtcbiAgICB9KTtcbiAgfTtcblxuICAvLyBHZW5lcmF0ZXMgYSBNb25nb0RCIHNlbGVjdG9yIHRoYXQgY2FuIGJlIHVzZWQgdG8gcGVyZm9ybSBhIGZhc3QgY2FzZVxuICAvLyBpbnNlbnNpdGl2ZSBsb29rdXAgZm9yIHRoZSBnaXZlbiBmaWVsZE5hbWUgYW5kIHN0cmluZy4gU2luY2UgTW9uZ29EQiBkb2VzXG4gIC8vIG5vdCBzdXBwb3J0IGNhc2UgaW5zZW5zaXRpdmUgaW5kZXhlcywgYW5kIGNhc2UgaW5zZW5zaXRpdmUgcmVnZXggcXVlcmllc1xuICAvLyBhcmUgc2xvdywgd2UgY29uc3RydWN0IGEgc2V0IG9mIHByZWZpeCBzZWxlY3RvcnMgZm9yIGFsbCBwZXJtdXRhdGlvbnMgb2ZcbiAgLy8gdGhlIGZpcnN0IDQgY2hhcmFjdGVycyBvdXJzZWx2ZXMuIFdlIGZpcnN0IGF0dGVtcHQgdG8gbWF0Y2hpbmcgYWdhaW5zdFxuICAvLyB0aGVzZSwgYW5kIGJlY2F1c2UgJ3ByZWZpeCBleHByZXNzaW9uJyByZWdleCBxdWVyaWVzIGRvIHVzZSBpbmRleGVzIChzZWVcbiAgLy8gaHR0cDovL2RvY3MubW9uZ29kYi5vcmcvdjIuNi9yZWZlcmVuY2Uvb3BlcmF0b3IvcXVlcnkvcmVnZXgvI2luZGV4LXVzZSksXG4gIC8vIHRoaXMgaGFzIGJlZW4gZm91bmQgdG8gZ3JlYXRseSBpbXByb3ZlIHBlcmZvcm1hbmNlIChmcm9tIDEyMDBtcyB0byA1bXMgaW4gYVxuICAvLyB0ZXN0IHdpdGggMS4wMDAuMDAwIHVzZXJzKS5cbiAgX3NlbGVjdG9yRm9yRmFzdENhc2VJbnNlbnNpdGl2ZUxvb2t1cCA9IChmaWVsZE5hbWUsIHN0cmluZykgPT4ge1xuICAgIC8vIFBlcmZvcm1hbmNlIHNlZW1zIHRvIGltcHJvdmUgdXAgdG8gNCBwcmVmaXggY2hhcmFjdGVyc1xuICAgIGNvbnN0IHByZWZpeCA9IHN0cmluZy5zdWJzdHJpbmcoMCwgTWF0aC5taW4oc3RyaW5nLmxlbmd0aCwgNCkpO1xuICAgIGNvbnN0IG9yQ2xhdXNlID0gZ2VuZXJhdGVDYXNlUGVybXV0YXRpb25zRm9yU3RyaW5nKHByZWZpeCkubWFwKFxuICAgICAgICBwcmVmaXhQZXJtdXRhdGlvbiA9PiB7XG4gICAgICAgICAgY29uc3Qgc2VsZWN0b3IgPSB7fTtcbiAgICAgICAgICBzZWxlY3RvcltmaWVsZE5hbWVdID1cbiAgICAgICAgICAgICAgbmV3IFJlZ0V4cChgXiR7TWV0ZW9yLl9lc2NhcGVSZWdFeHAocHJlZml4UGVybXV0YXRpb24pfWApO1xuICAgICAgICAgIHJldHVybiBzZWxlY3RvcjtcbiAgICAgICAgfSk7XG4gICAgY29uc3QgY2FzZUluc2Vuc2l0aXZlQ2xhdXNlID0ge307XG4gICAgY2FzZUluc2Vuc2l0aXZlQ2xhdXNlW2ZpZWxkTmFtZV0gPVxuICAgICAgICBuZXcgUmVnRXhwKGBeJHtNZXRlb3IuX2VzY2FwZVJlZ0V4cChzdHJpbmcpfSRgLCAnaScpXG4gICAgcmV0dXJuIHskYW5kOiBbeyRvcjogb3JDbGF1c2V9LCBjYXNlSW5zZW5zaXRpdmVDbGF1c2VdfTtcbiAgfVxuXG4gIF9maW5kVXNlckJ5UXVlcnkgPSAocXVlcnksIG9wdGlvbnMpID0+IHtcbiAgICBsZXQgdXNlciA9IG51bGw7XG5cbiAgICBpZiAocXVlcnkuaWQpIHtcbiAgICAgIC8vIGRlZmF1bHQgZmllbGQgc2VsZWN0b3IgaXMgYWRkZWQgd2l0aGluIGdldFVzZXJCeUlkKClcbiAgICAgIHVzZXIgPSBNZXRlb3IudXNlcnMuZmluZE9uZShxdWVyeS5pZCwgdGhpcy5fYWRkRGVmYXVsdEZpZWxkU2VsZWN0b3Iob3B0aW9ucykpO1xuICAgIH0gZWxzZSB7XG4gICAgICBvcHRpb25zID0gdGhpcy5fYWRkRGVmYXVsdEZpZWxkU2VsZWN0b3Iob3B0aW9ucyk7XG4gICAgICBsZXQgZmllbGROYW1lO1xuICAgICAgbGV0IGZpZWxkVmFsdWU7XG4gICAgICBpZiAocXVlcnkudXNlcm5hbWUpIHtcbiAgICAgICAgZmllbGROYW1lID0gJ3VzZXJuYW1lJztcbiAgICAgICAgZmllbGRWYWx1ZSA9IHF1ZXJ5LnVzZXJuYW1lO1xuICAgICAgfSBlbHNlIGlmIChxdWVyeS5lbWFpbCkge1xuICAgICAgICBmaWVsZE5hbWUgPSAnZW1haWxzLmFkZHJlc3MnO1xuICAgICAgICBmaWVsZFZhbHVlID0gcXVlcnkuZW1haWw7XG4gICAgICB9IGVsc2Uge1xuICAgICAgICB0aHJvdyBuZXcgRXJyb3IoXCJzaG91bGRuJ3QgaGFwcGVuICh2YWxpZGF0aW9uIG1pc3NlZCBzb21ldGhpbmcpXCIpO1xuICAgICAgfVxuICAgICAgbGV0IHNlbGVjdG9yID0ge307XG4gICAgICBzZWxlY3RvcltmaWVsZE5hbWVdID0gZmllbGRWYWx1ZTtcbiAgICAgIHVzZXIgPSBNZXRlb3IudXNlcnMuZmluZE9uZShzZWxlY3Rvciwgb3B0aW9ucyk7XG4gICAgICAvLyBJZiB1c2VyIGlzIG5vdCBmb3VuZCwgdHJ5IGEgY2FzZSBpbnNlbnNpdGl2ZSBsb29rdXBcbiAgICAgIGlmICghdXNlcikge1xuICAgICAgICBzZWxlY3RvciA9IHRoaXMuX3NlbGVjdG9yRm9yRmFzdENhc2VJbnNlbnNpdGl2ZUxvb2t1cChmaWVsZE5hbWUsIGZpZWxkVmFsdWUpO1xuICAgICAgICBjb25zdCBjYW5kaWRhdGVVc2VycyA9IE1ldGVvci51c2Vycy5maW5kKHNlbGVjdG9yLCBvcHRpb25zKS5mZXRjaCgpO1xuICAgICAgICAvLyBObyBtYXRjaCBpZiBtdWx0aXBsZSBjYW5kaWRhdGVzIGFyZSBmb3VuZFxuICAgICAgICBpZiAoY2FuZGlkYXRlVXNlcnMubGVuZ3RoID09PSAxKSB7XG4gICAgICAgICAgdXNlciA9IGNhbmRpZGF0ZVVzZXJzWzBdO1xuICAgICAgICB9XG4gICAgICB9XG4gICAgfVxuXG4gICAgcmV0dXJuIHVzZXI7XG4gIH1cblxuICAvLy9cbiAgLy8vIExPR0lOIE1FVEhPRFNcbiAgLy8vXG5cbiAgLy8gTG9naW4gbWV0aG9kcyByZXR1cm4gdG8gdGhlIGNsaWVudCBhbiBvYmplY3QgY29udGFpbmluZyB0aGVzZVxuICAvLyBmaWVsZHMgd2hlbiB0aGUgdXNlciB3YXMgbG9nZ2VkIGluIHN1Y2Nlc3NmdWxseTpcbiAgLy9cbiAgLy8gICBpZDogdXNlcklkXG4gIC8vICAgdG9rZW46ICpcbiAgLy8gICB0b2tlbkV4cGlyZXM6ICpcbiAgLy9cbiAgLy8gdG9rZW5FeHBpcmVzIGlzIG9wdGlvbmFsIGFuZCBpbnRlbmRzIHRvIHByb3ZpZGUgYSBoaW50IHRvIHRoZVxuICAvLyBjbGllbnQgYXMgdG8gd2hlbiB0aGUgdG9rZW4gd2lsbCBleHBpcmUuIElmIG5vdCBwcm92aWRlZCwgdGhlXG4gIC8vIGNsaWVudCB3aWxsIGNhbGwgQWNjb3VudHMuX3Rva2VuRXhwaXJhdGlvbiwgcGFzc2luZyBpdCB0aGUgZGF0ZVxuICAvLyB0aGF0IGl0IHJlY2VpdmVkIHRoZSB0b2tlbi5cbiAgLy9cbiAgLy8gVGhlIGxvZ2luIG1ldGhvZCB3aWxsIHRocm93IGFuIGVycm9yIGJhY2sgdG8gdGhlIGNsaWVudCBpZiB0aGUgdXNlclxuICAvLyBmYWlsZWQgdG8gbG9nIGluLlxuICAvL1xuICAvL1xuICAvLyBMb2dpbiBoYW5kbGVycyBhbmQgc2VydmljZSBzcGVjaWZpYyBsb2dpbiBtZXRob2RzIHN1Y2ggYXNcbiAgLy8gYGNyZWF0ZVVzZXJgIGludGVybmFsbHkgcmV0dXJuIGEgYHJlc3VsdGAgb2JqZWN0IGNvbnRhaW5pbmcgdGhlc2VcbiAgLy8gZmllbGRzOlxuICAvL1xuICAvLyAgIHR5cGU6XG4gIC8vICAgICBvcHRpb25hbCBzdHJpbmc7IHRoZSBzZXJ2aWNlIG5hbWUsIG92ZXJyaWRlcyB0aGUgaGFuZGxlclxuICAvLyAgICAgZGVmYXVsdCBpZiBwcmVzZW50LlxuICAvL1xuICAvLyAgIGVycm9yOlxuICAvLyAgICAgZXhjZXB0aW9uOyBpZiB0aGUgdXNlciBpcyBub3QgYWxsb3dlZCB0byBsb2dpbiwgdGhlIHJlYXNvbiB3aHkuXG4gIC8vXG4gIC8vICAgdXNlcklkOlxuICAvLyAgICAgc3RyaW5nOyB0aGUgdXNlciBpZCBvZiB0aGUgdXNlciBhdHRlbXB0aW5nIHRvIGxvZ2luIChpZlxuICAvLyAgICAga25vd24pLCByZXF1aXJlZCBmb3IgYW4gYWxsb3dlZCBsb2dpbi5cbiAgLy9cbiAgLy8gICBvcHRpb25zOlxuICAvLyAgICAgb3B0aW9uYWwgb2JqZWN0IG1lcmdlZCBpbnRvIHRoZSByZXN1bHQgcmV0dXJuZWQgYnkgdGhlIGxvZ2luXG4gIC8vICAgICBtZXRob2Q7IHVzZWQgYnkgSEFNSyBmcm9tIFNSUC5cbiAgLy9cbiAgLy8gICBzdGFtcGVkTG9naW5Ub2tlbjpcbiAgLy8gICAgIG9wdGlvbmFsIG9iamVjdCB3aXRoIGB0b2tlbmAgYW5kIGB3aGVuYCBpbmRpY2F0aW5nIHRoZSBsb2dpblxuICAvLyAgICAgdG9rZW4gaXMgYWxyZWFkeSBwcmVzZW50IGluIHRoZSBkYXRhYmFzZSwgcmV0dXJuZWQgYnkgdGhlXG4gIC8vICAgICBcInJlc3VtZVwiIGxvZ2luIGhhbmRsZXIuXG4gIC8vXG4gIC8vIEZvciBjb252ZW5pZW5jZSwgbG9naW4gbWV0aG9kcyBjYW4gYWxzbyB0aHJvdyBhbiBleGNlcHRpb24sIHdoaWNoXG4gIC8vIGlzIGNvbnZlcnRlZCBpbnRvIGFuIHtlcnJvcn0gcmVzdWx0LiAgSG93ZXZlciwgaWYgdGhlIGlkIG9mIHRoZVxuICAvLyB1c2VyIGF0dGVtcHRpbmcgdGhlIGxvZ2luIGlzIGtub3duLCBhIHt1c2VySWQsIGVycm9yfSByZXN1bHQgc2hvdWxkXG4gIC8vIGJlIHJldHVybmVkIGluc3RlYWQgc2luY2UgdGhlIHVzZXIgaWQgaXMgbm90IGNhcHR1cmVkIHdoZW4gYW5cbiAgLy8gZXhjZXB0aW9uIGlzIHRocm93bi5cbiAgLy9cbiAgLy8gVGhpcyBpbnRlcm5hbCBgcmVzdWx0YCBvYmplY3QgaXMgYXV0b21hdGljYWxseSBjb252ZXJ0ZWQgaW50byB0aGVcbiAgLy8gcHVibGljIHtpZCwgdG9rZW4sIHRva2VuRXhwaXJlc30gb2JqZWN0IHJldHVybmVkIHRvIHRoZSBjbGllbnQuXG5cbiAgLy8gVHJ5IGEgbG9naW4gbWV0aG9kLCBjb252ZXJ0aW5nIHRocm93biBleGNlcHRpb25zIGludG8gYW4ge2Vycm9yfVxuICAvLyByZXN1bHQuICBUaGUgYHR5cGVgIGFyZ3VtZW50IGlzIGEgZGVmYXVsdCwgaW5zZXJ0ZWQgaW50byB0aGUgcmVzdWx0XG4gIC8vIG9iamVjdCBpZiBub3QgZXhwbGljaXRseSByZXR1cm5lZC5cbiAgLy9cbiAgLy8gTG9nIGluIGEgdXNlciBvbiBhIGNvbm5lY3Rpb24uXG4gIC8vXG4gIC8vIFdlIHVzZSB0aGUgbWV0aG9kIGludm9jYXRpb24gdG8gc2V0IHRoZSB1c2VyIGlkIG9uIHRoZSBjb25uZWN0aW9uLFxuICAvLyBub3QgdGhlIGNvbm5lY3Rpb24gb2JqZWN0IGRpcmVjdGx5LiBzZXRVc2VySWQgaXMgdGllZCB0byBtZXRob2RzIHRvXG4gIC8vIGVuZm9yY2UgY2xlYXIgb3JkZXJpbmcgb2YgbWV0aG9kIGFwcGxpY2F0aW9uICh1c2luZyB3YWl0IG1ldGhvZHMgb25cbiAgLy8gdGhlIGNsaWVudCwgYW5kIGEgbm8gc2V0VXNlcklkIGFmdGVyIHVuYmxvY2sgcmVzdHJpY3Rpb24gb24gdGhlXG4gIC8vIHNlcnZlcilcbiAgLy9cbiAgLy8gVGhlIGBzdGFtcGVkTG9naW5Ub2tlbmAgcGFyYW1ldGVyIGlzIG9wdGlvbmFsLiAgV2hlbiBwcmVzZW50LCBpdFxuICAvLyBpbmRpY2F0ZXMgdGhhdCB0aGUgbG9naW4gdG9rZW4gaGFzIGFscmVhZHkgYmVlbiBpbnNlcnRlZCBpbnRvIHRoZVxuICAvLyBkYXRhYmFzZSBhbmQgZG9lc24ndCBuZWVkIHRvIGJlIGluc2VydGVkIGFnYWluLiAgKEl0J3MgdXNlZCBieSB0aGVcbiAgLy8gXCJyZXN1bWVcIiBsb2dpbiBoYW5kbGVyKS5cbiAgX2xvZ2luVXNlcihtZXRob2RJbnZvY2F0aW9uLCB1c2VySWQsIHN0YW1wZWRMb2dpblRva2VuKSB7XG4gICAgaWYgKCEgc3RhbXBlZExvZ2luVG9rZW4pIHtcbiAgICAgIHN0YW1wZWRMb2dpblRva2VuID0gdGhpcy5fZ2VuZXJhdGVTdGFtcGVkTG9naW5Ub2tlbigpO1xuICAgICAgdGhpcy5faW5zZXJ0TG9naW5Ub2tlbih1c2VySWQsIHN0YW1wZWRMb2dpblRva2VuKTtcbiAgICB9XG5cbiAgICAvLyBUaGlzIG9yZGVyIChhbmQgdGhlIGF2b2lkYW5jZSBvZiB5aWVsZHMpIGlzIGltcG9ydGFudCB0byBtYWtlXG4gICAgLy8gc3VyZSB0aGF0IHdoZW4gcHVibGlzaCBmdW5jdGlvbnMgYXJlIHJlcnVuLCB0aGV5IHNlZSBhXG4gICAgLy8gY29uc2lzdGVudCB2aWV3IG9mIHRoZSB3b3JsZDogdGhlIHVzZXJJZCBpcyBzZXQgYW5kIG1hdGNoZXNcbiAgICAvLyB0aGUgbG9naW4gdG9rZW4gb24gdGhlIGNvbm5lY3Rpb24gKG5vdCB0aGF0IHRoZXJlIGlzXG4gICAgLy8gY3VycmVudGx5IGEgcHVibGljIEFQSSBmb3IgcmVhZGluZyB0aGUgbG9naW4gdG9rZW4gb24gYVxuICAgIC8vIGNvbm5lY3Rpb24pLlxuICAgIE1ldGVvci5fbm9ZaWVsZHNBbGxvd2VkKCgpID0+XG4gICAgICB0aGlzLl9zZXRMb2dpblRva2VuKFxuICAgICAgICB1c2VySWQsXG4gICAgICAgIG1ldGhvZEludm9jYXRpb24uY29ubmVjdGlvbixcbiAgICAgICAgdGhpcy5faGFzaExvZ2luVG9rZW4oc3RhbXBlZExvZ2luVG9rZW4udG9rZW4pXG4gICAgICApXG4gICAgKTtcblxuICAgIG1ldGhvZEludm9jYXRpb24uc2V0VXNlcklkKHVzZXJJZCk7XG5cbiAgICByZXR1cm4ge1xuICAgICAgaWQ6IHVzZXJJZCxcbiAgICAgIHRva2VuOiBzdGFtcGVkTG9naW5Ub2tlbi50b2tlbixcbiAgICAgIHRva2VuRXhwaXJlczogdGhpcy5fdG9rZW5FeHBpcmF0aW9uKHN0YW1wZWRMb2dpblRva2VuLndoZW4pXG4gICAgfTtcbiAgfTtcblxuICAvLyBBZnRlciBhIGxvZ2luIG1ldGhvZCBoYXMgY29tcGxldGVkLCBjYWxsIHRoZSBsb2dpbiBob29rcy4gIE5vdGVcbiAgLy8gdGhhdCBgYXR0ZW1wdExvZ2luYCBpcyBjYWxsZWQgZm9yICphbGwqIGxvZ2luIGF0dGVtcHRzLCBldmVuIG9uZXNcbiAgLy8gd2hpY2ggYXJlbid0IHN1Y2Nlc3NmdWwgKHN1Y2ggYXMgYW4gaW52YWxpZCBwYXNzd29yZCwgZXRjKS5cbiAgLy9cbiAgLy8gSWYgdGhlIGxvZ2luIGlzIGFsbG93ZWQgYW5kIGlzbid0IGFib3J0ZWQgYnkgYSB2YWxpZGF0ZSBsb2dpbiBob29rXG4gIC8vIGNhbGxiYWNrLCBsb2cgaW4gdGhlIHVzZXIuXG4gIC8vXG4gIF9hdHRlbXB0TG9naW4oXG4gICAgbWV0aG9kSW52b2NhdGlvbixcbiAgICBtZXRob2ROYW1lLFxuICAgIG1ldGhvZEFyZ3MsXG4gICAgcmVzdWx0XG4gICkge1xuICAgIGlmICghcmVzdWx0KVxuICAgICAgdGhyb3cgbmV3IEVycm9yKFwicmVzdWx0IGlzIHJlcXVpcmVkXCIpO1xuXG4gICAgLy8gWFhYIEEgcHJvZ3JhbW1pbmcgZXJyb3IgaW4gYSBsb2dpbiBoYW5kbGVyIGNhbiBsZWFkIHRvIHRoaXMgb2NjdXJyaW5nLCBhbmRcbiAgICAvLyB0aGVuIHdlIGRvbid0IGNhbGwgb25Mb2dpbiBvciBvbkxvZ2luRmFpbHVyZSBjYWxsYmFja3MuIFNob3VsZFxuICAgIC8vIHRyeUxvZ2luTWV0aG9kIGNhdGNoIHRoaXMgY2FzZSBhbmQgdHVybiBpdCBpbnRvIGFuIGVycm9yP1xuICAgIGlmICghcmVzdWx0LnVzZXJJZCAmJiAhcmVzdWx0LmVycm9yKVxuICAgICAgdGhyb3cgbmV3IEVycm9yKFwiQSBsb2dpbiBtZXRob2QgbXVzdCBzcGVjaWZ5IGEgdXNlcklkIG9yIGFuIGVycm9yXCIpO1xuXG4gICAgbGV0IHVzZXI7XG4gICAgaWYgKHJlc3VsdC51c2VySWQpXG4gICAgICB1c2VyID0gdGhpcy51c2Vycy5maW5kT25lKHJlc3VsdC51c2VySWQsIHtmaWVsZHM6IHRoaXMuX29wdGlvbnMuZGVmYXVsdEZpZWxkU2VsZWN0b3J9KTtcblxuICAgIGNvbnN0IGF0dGVtcHQgPSB7XG4gICAgICB0eXBlOiByZXN1bHQudHlwZSB8fCBcInVua25vd25cIixcbiAgICAgIGFsbG93ZWQ6ICEhIChyZXN1bHQudXNlcklkICYmICFyZXN1bHQuZXJyb3IpLFxuICAgICAgbWV0aG9kTmFtZTogbWV0aG9kTmFtZSxcbiAgICAgIG1ldGhvZEFyZ3VtZW50czogQXJyYXkuZnJvbShtZXRob2RBcmdzKVxuICAgIH07XG4gICAgaWYgKHJlc3VsdC5lcnJvcikge1xuICAgICAgYXR0ZW1wdC5lcnJvciA9IHJlc3VsdC5lcnJvcjtcbiAgICB9XG4gICAgaWYgKHVzZXIpIHtcbiAgICAgIGF0dGVtcHQudXNlciA9IHVzZXI7XG4gICAgfVxuXG4gICAgLy8gX3ZhbGlkYXRlTG9naW4gbWF5IG11dGF0ZSBgYXR0ZW1wdGAgYnkgYWRkaW5nIGFuIGVycm9yIGFuZCBjaGFuZ2luZyBhbGxvd2VkXG4gICAgLy8gdG8gZmFsc2UsIGJ1dCB0aGF0J3MgdGhlIG9ubHkgY2hhbmdlIGl0IGNhbiBtYWtlIChhbmQgdGhlIHVzZXIncyBjYWxsYmFja3NcbiAgICAvLyBvbmx5IGdldCBhIGNsb25lIG9mIGBhdHRlbXB0YCkuXG4gICAgdGhpcy5fdmFsaWRhdGVMb2dpbihtZXRob2RJbnZvY2F0aW9uLmNvbm5lY3Rpb24sIGF0dGVtcHQpO1xuXG4gICAgaWYgKGF0dGVtcHQuYWxsb3dlZCkge1xuICAgICAgY29uc3QgcmV0ID0ge1xuICAgICAgICAuLi50aGlzLl9sb2dpblVzZXIoXG4gICAgICAgICAgbWV0aG9kSW52b2NhdGlvbixcbiAgICAgICAgICByZXN1bHQudXNlcklkLFxuICAgICAgICAgIHJlc3VsdC5zdGFtcGVkTG9naW5Ub2tlblxuICAgICAgICApLFxuICAgICAgICAuLi5yZXN1bHQub3B0aW9uc1xuICAgICAgfTtcbiAgICAgIHJldC50eXBlID0gYXR0ZW1wdC50eXBlO1xuICAgICAgdGhpcy5fc3VjY2Vzc2Z1bExvZ2luKG1ldGhvZEludm9jYXRpb24uY29ubmVjdGlvbiwgYXR0ZW1wdCk7XG4gICAgICByZXR1cm4gcmV0O1xuICAgIH1cbiAgICBlbHNlIHtcbiAgICAgIHRoaXMuX2ZhaWxlZExvZ2luKG1ldGhvZEludm9jYXRpb24uY29ubmVjdGlvbiwgYXR0ZW1wdCk7XG4gICAgICB0aHJvdyBhdHRlbXB0LmVycm9yO1xuICAgIH1cbiAgfTtcblxuICAvLyBBbGwgc2VydmljZSBzcGVjaWZpYyBsb2dpbiBtZXRob2RzIHNob3VsZCBnbyB0aHJvdWdoIHRoaXMgZnVuY3Rpb24uXG4gIC8vIEVuc3VyZSB0aGF0IHRocm93biBleGNlcHRpb25zIGFyZSBjYXVnaHQgYW5kIHRoYXQgbG9naW4gaG9va1xuICAvLyBjYWxsYmFja3MgYXJlIHN0aWxsIGNhbGxlZC5cbiAgLy9cbiAgX2xvZ2luTWV0aG9kKFxuICAgIG1ldGhvZEludm9jYXRpb24sXG4gICAgbWV0aG9kTmFtZSxcbiAgICBtZXRob2RBcmdzLFxuICAgIHR5cGUsXG4gICAgZm5cbiAgKSB7XG4gICAgcmV0dXJuIHRoaXMuX2F0dGVtcHRMb2dpbihcbiAgICAgIG1ldGhvZEludm9jYXRpb24sXG4gICAgICBtZXRob2ROYW1lLFxuICAgICAgbWV0aG9kQXJncyxcbiAgICAgIHRyeUxvZ2luTWV0aG9kKHR5cGUsIGZuKVxuICAgICk7XG4gIH07XG5cblxuICAvLyBSZXBvcnQgYSBsb2dpbiBhdHRlbXB0IGZhaWxlZCBvdXRzaWRlIHRoZSBjb250ZXh0IG9mIGEgbm9ybWFsIGxvZ2luXG4gIC8vIG1ldGhvZC4gVGhpcyBpcyBmb3IgdXNlIGluIHRoZSBjYXNlIHdoZXJlIHRoZXJlIGlzIGEgbXVsdGktc3RlcCBsb2dpblxuICAvLyBwcm9jZWR1cmUgKGVnIFNSUCBiYXNlZCBwYXNzd29yZCBsb2dpbikuIElmIGEgbWV0aG9kIGVhcmx5IGluIHRoZVxuICAvLyBjaGFpbiBmYWlscywgaXQgc2hvdWxkIGNhbGwgdGhpcyBmdW5jdGlvbiB0byByZXBvcnQgYSBmYWlsdXJlLiBUaGVyZVxuICAvLyBpcyBubyBjb3JyZXNwb25kaW5nIG1ldGhvZCBmb3IgYSBzdWNjZXNzZnVsIGxvZ2luOyBtZXRob2RzIHRoYXQgY2FuXG4gIC8vIHN1Y2NlZWQgYXQgbG9nZ2luZyBhIHVzZXIgaW4gc2hvdWxkIGFsd2F5cyBiZSBhY3R1YWwgbG9naW4gbWV0aG9kc1xuICAvLyAodXNpbmcgZWl0aGVyIEFjY291bnRzLl9sb2dpbk1ldGhvZCBvciBBY2NvdW50cy5yZWdpc3RlckxvZ2luSGFuZGxlcikuXG4gIF9yZXBvcnRMb2dpbkZhaWx1cmUoXG4gICAgbWV0aG9kSW52b2NhdGlvbixcbiAgICBtZXRob2ROYW1lLFxuICAgIG1ldGhvZEFyZ3MsXG4gICAgcmVzdWx0XG4gICkge1xuICAgIGNvbnN0IGF0dGVtcHQgPSB7XG4gICAgICB0eXBlOiByZXN1bHQudHlwZSB8fCBcInVua25vd25cIixcbiAgICAgIGFsbG93ZWQ6IGZhbHNlLFxuICAgICAgZXJyb3I6IHJlc3VsdC5lcnJvcixcbiAgICAgIG1ldGhvZE5hbWU6IG1ldGhvZE5hbWUsXG4gICAgICBtZXRob2RBcmd1bWVudHM6IEFycmF5LmZyb20obWV0aG9kQXJncylcbiAgICB9O1xuXG4gICAgaWYgKHJlc3VsdC51c2VySWQpIHtcbiAgICAgIGF0dGVtcHQudXNlciA9IHRoaXMudXNlcnMuZmluZE9uZShyZXN1bHQudXNlcklkLCB7ZmllbGRzOiB0aGlzLl9vcHRpb25zLmRlZmF1bHRGaWVsZFNlbGVjdG9yfSk7XG4gICAgfVxuXG4gICAgdGhpcy5fdmFsaWRhdGVMb2dpbihtZXRob2RJbnZvY2F0aW9uLmNvbm5lY3Rpb24sIGF0dGVtcHQpO1xuICAgIHRoaXMuX2ZhaWxlZExvZ2luKG1ldGhvZEludm9jYXRpb24uY29ubmVjdGlvbiwgYXR0ZW1wdCk7XG5cbiAgICAvLyBfdmFsaWRhdGVMb2dpbiBtYXkgbXV0YXRlIGF0dGVtcHQgdG8gc2V0IGEgbmV3IGVycm9yIG1lc3NhZ2UuIFJldHVyblxuICAgIC8vIHRoZSBtb2RpZmllZCB2ZXJzaW9uLlxuICAgIHJldHVybiBhdHRlbXB0O1xuICB9O1xuXG4gIC8vL1xuICAvLy8gTE9HSU4gSEFORExFUlNcbiAgLy8vXG5cbiAgLy8gVGhlIG1haW4gZW50cnkgcG9pbnQgZm9yIGF1dGggcGFja2FnZXMgdG8gaG9vayBpbiB0byBsb2dpbi5cbiAgLy9cbiAgLy8gQSBsb2dpbiBoYW5kbGVyIGlzIGEgbG9naW4gbWV0aG9kIHdoaWNoIGNhbiByZXR1cm4gYHVuZGVmaW5lZGAgdG9cbiAgLy8gaW5kaWNhdGUgdGhhdCB0aGUgbG9naW4gcmVxdWVzdCBpcyBub3QgaGFuZGxlZCBieSB0aGlzIGhhbmRsZXIuXG4gIC8vXG4gIC8vIEBwYXJhbSBuYW1lIHtTdHJpbmd9IE9wdGlvbmFsLiAgVGhlIHNlcnZpY2UgbmFtZSwgdXNlZCBieSBkZWZhdWx0XG4gIC8vIGlmIGEgc3BlY2lmaWMgc2VydmljZSBuYW1lIGlzbid0IHJldHVybmVkIGluIHRoZSByZXN1bHQuXG4gIC8vXG4gIC8vIEBwYXJhbSBoYW5kbGVyIHtGdW5jdGlvbn0gQSBmdW5jdGlvbiB0aGF0IHJlY2VpdmVzIGFuIG9wdGlvbnMgb2JqZWN0XG4gIC8vIChhcyBwYXNzZWQgYXMgYW4gYXJndW1lbnQgdG8gdGhlIGBsb2dpbmAgbWV0aG9kKSBhbmQgcmV0dXJucyBvbmUgb2Y6XG4gIC8vIC0gYHVuZGVmaW5lZGAsIG1lYW5pbmcgZG9uJ3QgaGFuZGxlO1xuICAvLyAtIGEgbG9naW4gbWV0aG9kIHJlc3VsdCBvYmplY3RcblxuICByZWdpc3RlckxvZ2luSGFuZGxlcihuYW1lLCBoYW5kbGVyKSB7XG4gICAgaWYgKCEgaGFuZGxlcikge1xuICAgICAgaGFuZGxlciA9IG5hbWU7XG4gICAgICBuYW1lID0gbnVsbDtcbiAgICB9XG5cbiAgICB0aGlzLl9sb2dpbkhhbmRsZXJzLnB1c2goe1xuICAgICAgbmFtZTogbmFtZSxcbiAgICAgIGhhbmRsZXI6IGhhbmRsZXJcbiAgICB9KTtcbiAgfTtcblxuXG4gIC8vIENoZWNrcyBhIHVzZXIncyBjcmVkZW50aWFscyBhZ2FpbnN0IGFsbCB0aGUgcmVnaXN0ZXJlZCBsb2dpblxuICAvLyBoYW5kbGVycywgYW5kIHJldHVybnMgYSBsb2dpbiB0b2tlbiBpZiB0aGUgY3JlZGVudGlhbHMgYXJlIHZhbGlkLiBJdFxuICAvLyBpcyBsaWtlIHRoZSBsb2dpbiBtZXRob2QsIGV4Y2VwdCB0aGF0IGl0IGRvZXNuJ3Qgc2V0IHRoZSBsb2dnZWQtaW5cbiAgLy8gdXNlciBvbiB0aGUgY29ubmVjdGlvbi4gVGhyb3dzIGEgTWV0ZW9yLkVycm9yIGlmIGxvZ2dpbmcgaW4gZmFpbHMsXG4gIC8vIGluY2x1ZGluZyB0aGUgY2FzZSB3aGVyZSBub25lIG9mIHRoZSBsb2dpbiBoYW5kbGVycyBoYW5kbGVkIHRoZSBsb2dpblxuICAvLyByZXF1ZXN0LiBPdGhlcndpc2UsIHJldHVybnMge2lkOiB1c2VySWQsIHRva2VuOiAqLCB0b2tlbkV4cGlyZXM6ICp9LlxuICAvL1xuICAvLyBGb3IgZXhhbXBsZSwgaWYgeW91IHdhbnQgdG8gbG9naW4gd2l0aCBhIHBsYWludGV4dCBwYXNzd29yZCwgYG9wdGlvbnNgIGNvdWxkIGJlXG4gIC8vICAgeyB1c2VyOiB7IHVzZXJuYW1lOiA8dXNlcm5hbWU+IH0sIHBhc3N3b3JkOiA8cGFzc3dvcmQ+IH0sIG9yXG4gIC8vICAgeyB1c2VyOiB7IGVtYWlsOiA8ZW1haWw+IH0sIHBhc3N3b3JkOiA8cGFzc3dvcmQ+IH0uXG5cbiAgLy8gVHJ5IGFsbCBvZiB0aGUgcmVnaXN0ZXJlZCBsb2dpbiBoYW5kbGVycyB1bnRpbCBvbmUgb2YgdGhlbSBkb2Vzbid0XG4gIC8vIHJldHVybiBgdW5kZWZpbmVkYCwgbWVhbmluZyBpdCBoYW5kbGVkIHRoaXMgY2FsbCB0byBgbG9naW5gLiBSZXR1cm5cbiAgLy8gdGhhdCByZXR1cm4gdmFsdWUuXG4gIF9ydW5Mb2dpbkhhbmRsZXJzKG1ldGhvZEludm9jYXRpb24sIG9wdGlvbnMpIHtcbiAgICBmb3IgKGxldCBoYW5kbGVyIG9mIHRoaXMuX2xvZ2luSGFuZGxlcnMpIHtcbiAgICAgIGNvbnN0IHJlc3VsdCA9IHRyeUxvZ2luTWV0aG9kKFxuICAgICAgICBoYW5kbGVyLm5hbWUsXG4gICAgICAgICgpID0+IGhhbmRsZXIuaGFuZGxlci5jYWxsKG1ldGhvZEludm9jYXRpb24sIG9wdGlvbnMpXG4gICAgICApO1xuXG4gICAgICBpZiAocmVzdWx0KSB7XG4gICAgICAgIHJldHVybiByZXN1bHQ7XG4gICAgICB9XG5cbiAgICAgIGlmIChyZXN1bHQgIT09IHVuZGVmaW5lZCkge1xuICAgICAgICB0aHJvdyBuZXcgTWV0ZW9yLkVycm9yKDQwMCwgXCJBIGxvZ2luIGhhbmRsZXIgc2hvdWxkIHJldHVybiBhIHJlc3VsdCBvciB1bmRlZmluZWRcIik7XG4gICAgICB9XG4gICAgfVxuXG4gICAgcmV0dXJuIHtcbiAgICAgIHR5cGU6IG51bGwsXG4gICAgICBlcnJvcjogbmV3IE1ldGVvci5FcnJvcig0MDAsIFwiVW5yZWNvZ25pemVkIG9wdGlvbnMgZm9yIGxvZ2luIHJlcXVlc3RcIilcbiAgICB9O1xuICB9O1xuXG4gIC8vIERlbGV0ZXMgdGhlIGdpdmVuIGxvZ2luVG9rZW4gZnJvbSB0aGUgZGF0YWJhc2UuXG4gIC8vXG4gIC8vIEZvciBuZXctc3R5bGUgaGFzaGVkIHRva2VuLCB0aGlzIHdpbGwgY2F1c2UgYWxsIGNvbm5lY3Rpb25zXG4gIC8vIGFzc29jaWF0ZWQgd2l0aCB0aGUgdG9rZW4gdG8gYmUgY2xvc2VkLlxuICAvL1xuICAvLyBBbnkgY29ubmVjdGlvbnMgYXNzb2NpYXRlZCB3aXRoIG9sZC1zdHlsZSB1bmhhc2hlZCB0b2tlbnMgd2lsbCBiZVxuICAvLyBpbiB0aGUgcHJvY2VzcyBvZiBiZWNvbWluZyBhc3NvY2lhdGVkIHdpdGggaGFzaGVkIHRva2VucyBhbmQgdGhlblxuICAvLyB0aGV5J2xsIGdldCBjbG9zZWQuXG4gIGRlc3Ryb3lUb2tlbih1c2VySWQsIGxvZ2luVG9rZW4pIHtcbiAgICB0aGlzLnVzZXJzLnVwZGF0ZSh1c2VySWQsIHtcbiAgICAgICRwdWxsOiB7XG4gICAgICAgIFwic2VydmljZXMucmVzdW1lLmxvZ2luVG9rZW5zXCI6IHtcbiAgICAgICAgICAkb3I6IFtcbiAgICAgICAgICAgIHsgaGFzaGVkVG9rZW46IGxvZ2luVG9rZW4gfSxcbiAgICAgICAgICAgIHsgdG9rZW46IGxvZ2luVG9rZW4gfVxuICAgICAgICAgIF1cbiAgICAgICAgfVxuICAgICAgfVxuICAgIH0pO1xuICB9O1xuXG4gIF9pbml0U2VydmVyTWV0aG9kcygpIHtcbiAgICAvLyBUaGUgbWV0aG9kcyBjcmVhdGVkIGluIHRoaXMgZnVuY3Rpb24gbmVlZCB0byBiZSBjcmVhdGVkIGhlcmUgc28gdGhhdFxuICAgIC8vIHRoaXMgdmFyaWFibGUgaXMgYXZhaWxhYmxlIGluIHRoZWlyIHNjb3BlLlxuICAgIGNvbnN0IGFjY291bnRzID0gdGhpcztcblxuXG4gICAgLy8gVGhpcyBvYmplY3Qgd2lsbCBiZSBwb3B1bGF0ZWQgd2l0aCBtZXRob2RzIGFuZCB0aGVuIHBhc3NlZCB0b1xuICAgIC8vIGFjY291bnRzLl9zZXJ2ZXIubWV0aG9kcyBmdXJ0aGVyIGJlbG93LlxuICAgIGNvbnN0IG1ldGhvZHMgPSB7fTtcblxuICAgIC8vIEByZXR1cm5zIHtPYmplY3R8bnVsbH1cbiAgICAvLyAgIElmIHN1Y2Nlc3NmdWwsIHJldHVybnMge3Rva2VuOiByZWNvbm5lY3RUb2tlbiwgaWQ6IHVzZXJJZH1cbiAgICAvLyAgIElmIHVuc3VjY2Vzc2Z1bCAoZm9yIGV4YW1wbGUsIGlmIHRoZSB1c2VyIGNsb3NlZCB0aGUgb2F1dGggbG9naW4gcG9wdXApLFxuICAgIC8vICAgICB0aHJvd3MgYW4gZXJyb3IgZGVzY3JpYmluZyB0aGUgcmVhc29uXG4gICAgbWV0aG9kcy5sb2dpbiA9IGZ1bmN0aW9uIChvcHRpb25zKSB7XG4gICAgICAvLyBMb2dpbiBoYW5kbGVycyBzaG91bGQgcmVhbGx5IGFsc28gY2hlY2sgd2hhdGV2ZXIgZmllbGQgdGhleSBsb29rIGF0IGluXG4gICAgICAvLyBvcHRpb25zLCBidXQgd2UgZG9uJ3QgZW5mb3JjZSBpdC5cbiAgICAgIGNoZWNrKG9wdGlvbnMsIE9iamVjdCk7XG5cbiAgICAgIGNvbnN0IHJlc3VsdCA9IGFjY291bnRzLl9ydW5Mb2dpbkhhbmRsZXJzKHRoaXMsIG9wdGlvbnMpO1xuXG4gICAgICByZXR1cm4gYWNjb3VudHMuX2F0dGVtcHRMb2dpbih0aGlzLCBcImxvZ2luXCIsIGFyZ3VtZW50cywgcmVzdWx0KTtcbiAgICB9O1xuXG4gICAgbWV0aG9kcy5sb2dvdXQgPSBmdW5jdGlvbiAoKSB7XG4gICAgICBjb25zdCB0b2tlbiA9IGFjY291bnRzLl9nZXRMb2dpblRva2VuKHRoaXMuY29ubmVjdGlvbi5pZCk7XG4gICAgICBhY2NvdW50cy5fc2V0TG9naW5Ub2tlbih0aGlzLnVzZXJJZCwgdGhpcy5jb25uZWN0aW9uLCBudWxsKTtcbiAgICAgIGlmICh0b2tlbiAmJiB0aGlzLnVzZXJJZCkge1xuICAgICAgICBhY2NvdW50cy5kZXN0cm95VG9rZW4odGhpcy51c2VySWQsIHRva2VuKTtcbiAgICAgIH1cbiAgICAgIGFjY291bnRzLl9zdWNjZXNzZnVsTG9nb3V0KHRoaXMuY29ubmVjdGlvbiwgdGhpcy51c2VySWQpO1xuICAgICAgdGhpcy5zZXRVc2VySWQobnVsbCk7XG4gICAgfTtcblxuICAgIC8vIEdlbmVyYXRlcyBhIG5ldyBsb2dpbiB0b2tlbiB3aXRoIHRoZSBzYW1lIGV4cGlyYXRpb24gYXMgdGhlXG4gICAgLy8gY29ubmVjdGlvbidzIGN1cnJlbnQgdG9rZW4gYW5kIHNhdmVzIGl0IHRvIHRoZSBkYXRhYmFzZS4gQXNzb2NpYXRlc1xuICAgIC8vIHRoZSBjb25uZWN0aW9uIHdpdGggdGhpcyBuZXcgdG9rZW4gYW5kIHJldHVybnMgaXQuIFRocm93cyBhbiBlcnJvclxuICAgIC8vIGlmIGNhbGxlZCBvbiBhIGNvbm5lY3Rpb24gdGhhdCBpc24ndCBsb2dnZWQgaW4uXG4gICAgLy9cbiAgICAvLyBAcmV0dXJucyBPYmplY3RcbiAgICAvLyAgIElmIHN1Y2Nlc3NmdWwsIHJldHVybnMgeyB0b2tlbjogPG5ldyB0b2tlbj4sIGlkOiA8dXNlciBpZD4sXG4gICAgLy8gICB0b2tlbkV4cGlyZXM6IDxleHBpcmF0aW9uIGRhdGU+IH0uXG4gICAgbWV0aG9kcy5nZXROZXdUb2tlbiA9IGZ1bmN0aW9uICgpIHtcbiAgICAgIGNvbnN0IHVzZXIgPSBhY2NvdW50cy51c2Vycy5maW5kT25lKHRoaXMudXNlcklkLCB7XG4gICAgICAgIGZpZWxkczogeyBcInNlcnZpY2VzLnJlc3VtZS5sb2dpblRva2Vuc1wiOiAxIH1cbiAgICAgIH0pO1xuICAgICAgaWYgKCEgdGhpcy51c2VySWQgfHwgISB1c2VyKSB7XG4gICAgICAgIHRocm93IG5ldyBNZXRlb3IuRXJyb3IoXCJZb3UgYXJlIG5vdCBsb2dnZWQgaW4uXCIpO1xuICAgICAgfVxuICAgICAgLy8gQmUgY2FyZWZ1bCBub3QgdG8gZ2VuZXJhdGUgYSBuZXcgdG9rZW4gdGhhdCBoYXMgYSBsYXRlclxuICAgICAgLy8gZXhwaXJhdGlvbiB0aGFuIHRoZSBjdXJyZW4gdG9rZW4uIE90aGVyd2lzZSwgYSBiYWQgZ3V5IHdpdGggYVxuICAgICAgLy8gc3RvbGVuIHRva2VuIGNvdWxkIHVzZSB0aGlzIG1ldGhvZCB0byBzdG9wIGhpcyBzdG9sZW4gdG9rZW4gZnJvbVxuICAgICAgLy8gZXZlciBleHBpcmluZy5cbiAgICAgIGNvbnN0IGN1cnJlbnRIYXNoZWRUb2tlbiA9IGFjY291bnRzLl9nZXRMb2dpblRva2VuKHRoaXMuY29ubmVjdGlvbi5pZCk7XG4gICAgICBjb25zdCBjdXJyZW50U3RhbXBlZFRva2VuID0gdXNlci5zZXJ2aWNlcy5yZXN1bWUubG9naW5Ub2tlbnMuZmluZChcbiAgICAgICAgc3RhbXBlZFRva2VuID0+IHN0YW1wZWRUb2tlbi5oYXNoZWRUb2tlbiA9PT0gY3VycmVudEhhc2hlZFRva2VuXG4gICAgICApO1xuICAgICAgaWYgKCEgY3VycmVudFN0YW1wZWRUb2tlbikgeyAvLyBzYWZldHkgYmVsdDogdGhpcyBzaG91bGQgbmV2ZXIgaGFwcGVuXG4gICAgICAgIHRocm93IG5ldyBNZXRlb3IuRXJyb3IoXCJJbnZhbGlkIGxvZ2luIHRva2VuXCIpO1xuICAgICAgfVxuICAgICAgY29uc3QgbmV3U3RhbXBlZFRva2VuID0gYWNjb3VudHMuX2dlbmVyYXRlU3RhbXBlZExvZ2luVG9rZW4oKTtcbiAgICAgIG5ld1N0YW1wZWRUb2tlbi53aGVuID0gY3VycmVudFN0YW1wZWRUb2tlbi53aGVuO1xuICAgICAgYWNjb3VudHMuX2luc2VydExvZ2luVG9rZW4odGhpcy51c2VySWQsIG5ld1N0YW1wZWRUb2tlbik7XG4gICAgICByZXR1cm4gYWNjb3VudHMuX2xvZ2luVXNlcih0aGlzLCB0aGlzLnVzZXJJZCwgbmV3U3RhbXBlZFRva2VuKTtcbiAgICB9O1xuXG4gICAgLy8gUmVtb3ZlcyBhbGwgdG9rZW5zIGV4Y2VwdCB0aGUgdG9rZW4gYXNzb2NpYXRlZCB3aXRoIHRoZSBjdXJyZW50XG4gICAgLy8gY29ubmVjdGlvbi4gVGhyb3dzIGFuIGVycm9yIGlmIHRoZSBjb25uZWN0aW9uIGlzIG5vdCBsb2dnZWRcbiAgICAvLyBpbi4gUmV0dXJucyBub3RoaW5nIG9uIHN1Y2Nlc3MuXG4gICAgbWV0aG9kcy5yZW1vdmVPdGhlclRva2VucyA9IGZ1bmN0aW9uICgpIHtcbiAgICAgIGlmICghIHRoaXMudXNlcklkKSB7XG4gICAgICAgIHRocm93IG5ldyBNZXRlb3IuRXJyb3IoXCJZb3UgYXJlIG5vdCBsb2dnZWQgaW4uXCIpO1xuICAgICAgfVxuICAgICAgY29uc3QgY3VycmVudFRva2VuID0gYWNjb3VudHMuX2dldExvZ2luVG9rZW4odGhpcy5jb25uZWN0aW9uLmlkKTtcbiAgICAgIGFjY291bnRzLnVzZXJzLnVwZGF0ZSh0aGlzLnVzZXJJZCwge1xuICAgICAgICAkcHVsbDoge1xuICAgICAgICAgIFwic2VydmljZXMucmVzdW1lLmxvZ2luVG9rZW5zXCI6IHsgaGFzaGVkVG9rZW46IHsgJG5lOiBjdXJyZW50VG9rZW4gfSB9XG4gICAgICAgIH1cbiAgICAgIH0pO1xuICAgIH07XG5cbiAgICAvLyBBbGxvdyBhIG9uZS10aW1lIGNvbmZpZ3VyYXRpb24gZm9yIGEgbG9naW4gc2VydmljZS4gTW9kaWZpY2F0aW9uc1xuICAgIC8vIHRvIHRoaXMgY29sbGVjdGlvbiBhcmUgYWxzbyBhbGxvd2VkIGluIGluc2VjdXJlIG1vZGUuXG4gICAgbWV0aG9kcy5jb25maWd1cmVMb2dpblNlcnZpY2UgPSAob3B0aW9ucykgPT4ge1xuICAgICAgY2hlY2sob3B0aW9ucywgTWF0Y2guT2JqZWN0SW5jbHVkaW5nKHtzZXJ2aWNlOiBTdHJpbmd9KSk7XG4gICAgICAvLyBEb24ndCBsZXQgcmFuZG9tIHVzZXJzIGNvbmZpZ3VyZSBhIHNlcnZpY2Ugd2UgaGF2ZW4ndCBhZGRlZCB5ZXQgKHNvXG4gICAgICAvLyB0aGF0IHdoZW4gd2UgZG8gbGF0ZXIgYWRkIGl0LCBpdCdzIHNldCB1cCB3aXRoIHRoZWlyIGNvbmZpZ3VyYXRpb25cbiAgICAgIC8vIGluc3RlYWQgb2Ygb3VycykuXG4gICAgICAvLyBYWFggaWYgc2VydmljZSBjb25maWd1cmF0aW9uIGlzIG9hdXRoLXNwZWNpZmljIHRoZW4gdGhpcyBjb2RlIHNob3VsZFxuICAgICAgLy8gICAgIGJlIGluIGFjY291bnRzLW9hdXRoOyBpZiBpdCdzIG5vdCB0aGVuIHRoZSByZWdpc3RyeSBzaG91bGQgYmVcbiAgICAgIC8vICAgICBpbiB0aGlzIHBhY2thZ2VcbiAgICAgIGlmICghKGFjY291bnRzLm9hdXRoXG4gICAgICAgICYmIGFjY291bnRzLm9hdXRoLnNlcnZpY2VOYW1lcygpLmluY2x1ZGVzKG9wdGlvbnMuc2VydmljZSkpKSB7XG4gICAgICAgIHRocm93IG5ldyBNZXRlb3IuRXJyb3IoNDAzLCBcIlNlcnZpY2UgdW5rbm93blwiKTtcbiAgICAgIH1cblxuICAgICAgY29uc3QgeyBTZXJ2aWNlQ29uZmlndXJhdGlvbiB9ID0gUGFja2FnZVsnc2VydmljZS1jb25maWd1cmF0aW9uJ107XG4gICAgICBpZiAoU2VydmljZUNvbmZpZ3VyYXRpb24uY29uZmlndXJhdGlvbnMuZmluZE9uZSh7c2VydmljZTogb3B0aW9ucy5zZXJ2aWNlfSkpXG4gICAgICAgIHRocm93IG5ldyBNZXRlb3IuRXJyb3IoNDAzLCBgU2VydmljZSAke29wdGlvbnMuc2VydmljZX0gYWxyZWFkeSBjb25maWd1cmVkYCk7XG5cbiAgICAgIGlmIChoYXNPd24uY2FsbChvcHRpb25zLCAnc2VjcmV0JykgJiYgdXNpbmdPQXV0aEVuY3J5cHRpb24oKSlcbiAgICAgICAgb3B0aW9ucy5zZWNyZXQgPSBPQXV0aEVuY3J5cHRpb24uc2VhbChvcHRpb25zLnNlY3JldCk7XG5cbiAgICAgIFNlcnZpY2VDb25maWd1cmF0aW9uLmNvbmZpZ3VyYXRpb25zLmluc2VydChvcHRpb25zKTtcbiAgICB9O1xuXG4gICAgYWNjb3VudHMuX3NlcnZlci5tZXRob2RzKG1ldGhvZHMpO1xuICB9O1xuXG4gIF9pbml0QWNjb3VudERhdGFIb29rcygpIHtcbiAgICB0aGlzLl9zZXJ2ZXIub25Db25uZWN0aW9uKGNvbm5lY3Rpb24gPT4ge1xuICAgICAgdGhpcy5fYWNjb3VudERhdGFbY29ubmVjdGlvbi5pZF0gPSB7XG4gICAgICAgIGNvbm5lY3Rpb246IGNvbm5lY3Rpb25cbiAgICAgIH07XG5cbiAgICAgIGNvbm5lY3Rpb24ub25DbG9zZSgoKSA9PiB7XG4gICAgICAgIHRoaXMuX3JlbW92ZVRva2VuRnJvbUNvbm5lY3Rpb24oY29ubmVjdGlvbi5pZCk7XG4gICAgICAgIGRlbGV0ZSB0aGlzLl9hY2NvdW50RGF0YVtjb25uZWN0aW9uLmlkXTtcbiAgICAgIH0pO1xuICAgIH0pO1xuICB9O1xuXG4gIF9pbml0U2VydmVyUHVibGljYXRpb25zKCkge1xuICAgIC8vIEJyaW5nIGludG8gbGV4aWNhbCBzY29wZSBmb3IgcHVibGlzaCBjYWxsYmFja3MgdGhhdCBuZWVkIGB0aGlzYFxuICAgIGNvbnN0IHsgdXNlcnMsIF9hdXRvcHVibGlzaEZpZWxkcywgX2RlZmF1bHRQdWJsaXNoRmllbGRzIH0gPSB0aGlzO1xuXG4gICAgLy8gUHVibGlzaCBhbGwgbG9naW4gc2VydmljZSBjb25maWd1cmF0aW9uIGZpZWxkcyBvdGhlciB0aGFuIHNlY3JldC5cbiAgICB0aGlzLl9zZXJ2ZXIucHVibGlzaChcIm1ldGVvci5sb2dpblNlcnZpY2VDb25maWd1cmF0aW9uXCIsICgpID0+IHtcbiAgICAgIGNvbnN0IHsgU2VydmljZUNvbmZpZ3VyYXRpb24gfSA9IFBhY2thZ2VbJ3NlcnZpY2UtY29uZmlndXJhdGlvbiddO1xuICAgICAgcmV0dXJuIFNlcnZpY2VDb25maWd1cmF0aW9uLmNvbmZpZ3VyYXRpb25zLmZpbmQoe30sIHtmaWVsZHM6IHtzZWNyZXQ6IDB9fSk7XG4gICAgfSwge2lzX2F1dG86IHRydWV9KTsgLy8gbm90IHRlY2huaWNhbGx5IGF1dG9wdWJsaXNoLCBidXQgc3RvcHMgdGhlIHdhcm5pbmcuXG5cbiAgICAvLyBVc2UgTWV0ZW9yLnN0YXJ0dXAgdG8gZ2l2ZSBvdGhlciBwYWNrYWdlcyBhIGNoYW5jZSB0byBjYWxsXG4gICAgLy8gc2V0RGVmYXVsdFB1Ymxpc2hGaWVsZHMuXG4gICAgTWV0ZW9yLnN0YXJ0dXAoKCkgPT4ge1xuICAgICAgLy8gTWVyZ2UgY3VzdG9tIGZpZWxkcyBzZWxlY3RvciBhbmQgZGVmYXVsdCBwdWJsaXNoIGZpZWxkcyBzbyB0aGF0IHRoZSBjbGllbnRcbiAgICAgIC8vIGdldHMgYWxsIHRoZSBuZWNlc3NhcnkgZmllbGRzIHRvIHJ1biBwcm9wZXJseVxuICAgICAgY29uc3QgY3VzdG9tRmllbGRzID0gdGhpcy5fYWRkRGVmYXVsdEZpZWxkU2VsZWN0b3IoKS5maWVsZHMgfHwge307XG4gICAgICBjb25zdCBrZXlzID0gT2JqZWN0LmtleXMoY3VzdG9tRmllbGRzKTtcbiAgICAgIC8vIElmIHRoZSBjdXN0b20gZmllbGRzIGFyZSBuZWdhdGl2ZSwgdGhlbiBpZ25vcmUgdGhlbSBhbmQgb25seSBzZW5kIHRoZSBuZWNlc3NhcnkgZmllbGRzXG4gICAgICBjb25zdCBmaWVsZHMgPSBrZXlzLmxlbmd0aCA+IDAgJiYgY3VzdG9tRmllbGRzW2tleXNbMF1dID8ge1xuICAgICAgICAuLi50aGlzLl9hZGREZWZhdWx0RmllbGRTZWxlY3RvcigpLmZpZWxkcyxcbiAgICAgICAgLi4uX2RlZmF1bHRQdWJsaXNoRmllbGRzLnByb2plY3Rpb25cbiAgICAgIH0gOiBfZGVmYXVsdFB1Ymxpc2hGaWVsZHMucHJvamVjdGlvblxuICAgICAgLy8gUHVibGlzaCB0aGUgY3VycmVudCB1c2VyJ3MgcmVjb3JkIHRvIHRoZSBjbGllbnQuXG4gICAgICB0aGlzLl9zZXJ2ZXIucHVibGlzaChudWxsLCBmdW5jdGlvbiAoKSB7XG4gICAgICAgIGlmICh0aGlzLnVzZXJJZCkge1xuICAgICAgICAgIHJldHVybiB1c2Vycy5maW5kKHtcbiAgICAgICAgICAgIF9pZDogdGhpcy51c2VySWRcbiAgICAgICAgICB9LCB7XG4gICAgICAgICAgICBmaWVsZHMsXG4gICAgICAgICAgfSk7XG4gICAgICAgIH0gZWxzZSB7XG4gICAgICAgICAgcmV0dXJuIG51bGw7XG4gICAgICAgIH1cbiAgICAgIH0sIC8qc3VwcHJlc3MgYXV0b3B1Ymxpc2ggd2FybmluZyove2lzX2F1dG86IHRydWV9KTtcbiAgICB9KTtcblxuICAgIC8vIFVzZSBNZXRlb3Iuc3RhcnR1cCB0byBnaXZlIG90aGVyIHBhY2thZ2VzIGEgY2hhbmNlIHRvIGNhbGxcbiAgICAvLyBhZGRBdXRvcHVibGlzaEZpZWxkcy5cbiAgICBQYWNrYWdlLmF1dG9wdWJsaXNoICYmIE1ldGVvci5zdGFydHVwKCgpID0+IHtcbiAgICAgIC8vIFsncHJvZmlsZScsICd1c2VybmFtZSddIC0+IHtwcm9maWxlOiAxLCB1c2VybmFtZTogMX1cbiAgICAgIGNvbnN0IHRvRmllbGRTZWxlY3RvciA9IGZpZWxkcyA9PiBmaWVsZHMucmVkdWNlKChwcmV2LCBmaWVsZCkgPT4gKFxuICAgICAgICAgIHsgLi4ucHJldiwgW2ZpZWxkXTogMSB9KSxcbiAgICAgICAge31cbiAgICAgICk7XG4gICAgICB0aGlzLl9zZXJ2ZXIucHVibGlzaChudWxsLCBmdW5jdGlvbiAoKSB7XG4gICAgICAgIGlmICh0aGlzLnVzZXJJZCkge1xuICAgICAgICAgIHJldHVybiB1c2Vycy5maW5kKHsgX2lkOiB0aGlzLnVzZXJJZCB9LCB7XG4gICAgICAgICAgICBmaWVsZHM6IHRvRmllbGRTZWxlY3RvcihfYXV0b3B1Ymxpc2hGaWVsZHMubG9nZ2VkSW5Vc2VyKSxcbiAgICAgICAgICB9KVxuICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgIHJldHVybiBudWxsO1xuICAgICAgICB9XG4gICAgICB9LCAvKnN1cHByZXNzIGF1dG9wdWJsaXNoIHdhcm5pbmcqL3tpc19hdXRvOiB0cnVlfSk7XG5cbiAgICAgIC8vIFhYWCB0aGlzIHB1Ymxpc2ggaXMgbmVpdGhlciBkZWR1cC1hYmxlIG5vciBpcyBpdCBvcHRpbWl6ZWQgYnkgb3VyIHNwZWNpYWxcbiAgICAgIC8vIHRyZWF0bWVudCBvZiBxdWVyaWVzIG9uIGEgc3BlY2lmaWMgX2lkLiBUaGVyZWZvcmUgdGhpcyB3aWxsIGhhdmUgTyhuXjIpXG4gICAgICAvLyBydW4tdGltZSBwZXJmb3JtYW5jZSBldmVyeSB0aW1lIGEgdXNlciBkb2N1bWVudCBpcyBjaGFuZ2VkIChlZyBzb21lb25lXG4gICAgICAvLyBsb2dnaW5nIGluKS4gSWYgdGhpcyBpcyBhIHByb2JsZW0sIHdlIGNhbiBpbnN0ZWFkIHdyaXRlIGEgbWFudWFsIHB1Ymxpc2hcbiAgICAgIC8vIGZ1bmN0aW9uIHdoaWNoIGZpbHRlcnMgb3V0IGZpZWxkcyBiYXNlZCBvbiAndGhpcy51c2VySWQnLlxuICAgICAgdGhpcy5fc2VydmVyLnB1Ymxpc2gobnVsbCwgZnVuY3Rpb24gKCkge1xuICAgICAgICBjb25zdCBzZWxlY3RvciA9IHRoaXMudXNlcklkID8geyBfaWQ6IHsgJG5lOiB0aGlzLnVzZXJJZCB9IH0gOiB7fTtcbiAgICAgICAgcmV0dXJuIHVzZXJzLmZpbmQoc2VsZWN0b3IsIHtcbiAgICAgICAgICBmaWVsZHM6IHRvRmllbGRTZWxlY3RvcihfYXV0b3B1Ymxpc2hGaWVsZHMub3RoZXJVc2VycyksXG4gICAgICAgIH0pXG4gICAgICB9LCAvKnN1cHByZXNzIGF1dG9wdWJsaXNoIHdhcm5pbmcqL3tpc19hdXRvOiB0cnVlfSk7XG4gICAgfSk7XG4gIH07XG5cbiAgLy8gQWRkIHRvIHRoZSBsaXN0IG9mIGZpZWxkcyBvciBzdWJmaWVsZHMgdG8gYmUgYXV0b21hdGljYWxseVxuICAvLyBwdWJsaXNoZWQgaWYgYXV0b3B1Ymxpc2ggaXMgb24uIE11c3QgYmUgY2FsbGVkIGZyb20gdG9wLWxldmVsXG4gIC8vIGNvZGUgKGllLCBiZWZvcmUgTWV0ZW9yLnN0YXJ0dXAgaG9va3MgcnVuKS5cbiAgLy9cbiAgLy8gQHBhcmFtIG9wdHMge09iamVjdH0gd2l0aDpcbiAgLy8gICAtIGZvckxvZ2dlZEluVXNlciB7QXJyYXl9IEFycmF5IG9mIGZpZWxkcyBwdWJsaXNoZWQgdG8gdGhlIGxvZ2dlZC1pbiB1c2VyXG4gIC8vICAgLSBmb3JPdGhlclVzZXJzIHtBcnJheX0gQXJyYXkgb2YgZmllbGRzIHB1Ymxpc2hlZCB0byB1c2VycyB0aGF0IGFyZW4ndCBsb2dnZWQgaW5cbiAgYWRkQXV0b3B1Ymxpc2hGaWVsZHMob3B0cykge1xuICAgIHRoaXMuX2F1dG9wdWJsaXNoRmllbGRzLmxvZ2dlZEluVXNlci5wdXNoLmFwcGx5KFxuICAgICAgdGhpcy5fYXV0b3B1Ymxpc2hGaWVsZHMubG9nZ2VkSW5Vc2VyLCBvcHRzLmZvckxvZ2dlZEluVXNlcik7XG4gICAgdGhpcy5fYXV0b3B1Ymxpc2hGaWVsZHMub3RoZXJVc2Vycy5wdXNoLmFwcGx5KFxuICAgICAgdGhpcy5fYXV0b3B1Ymxpc2hGaWVsZHMub3RoZXJVc2Vycywgb3B0cy5mb3JPdGhlclVzZXJzKTtcbiAgfTtcblxuICAvLyBSZXBsYWNlcyB0aGUgZmllbGRzIHRvIGJlIGF1dG9tYXRpY2FsbHlcbiAgLy8gcHVibGlzaGVkIHdoZW4gdGhlIHVzZXIgbG9ncyBpblxuICAvL1xuICAvLyBAcGFyYW0ge01vbmdvRmllbGRTcGVjaWZpZXJ9IGZpZWxkcyBEaWN0aW9uYXJ5IG9mIGZpZWxkcyB0byByZXR1cm4gb3IgZXhjbHVkZS5cbiAgc2V0RGVmYXVsdFB1Ymxpc2hGaWVsZHMoZmllbGRzKSB7XG4gICAgdGhpcy5fZGVmYXVsdFB1Ymxpc2hGaWVsZHMucHJvamVjdGlvbiA9IGZpZWxkcztcbiAgfTtcblxuICAvLy9cbiAgLy8vIEFDQ09VTlQgREFUQVxuICAvLy9cblxuICAvLyBIQUNLOiBUaGlzIGlzIHVzZWQgYnkgJ21ldGVvci1hY2NvdW50cycgdG8gZ2V0IHRoZSBsb2dpblRva2VuIGZvciBhXG4gIC8vIGNvbm5lY3Rpb24uIE1heWJlIHRoZXJlIHNob3VsZCBiZSBhIHB1YmxpYyB3YXkgdG8gZG8gdGhhdC5cbiAgX2dldEFjY291bnREYXRhKGNvbm5lY3Rpb25JZCwgZmllbGQpIHtcbiAgICBjb25zdCBkYXRhID0gdGhpcy5fYWNjb3VudERhdGFbY29ubmVjdGlvbklkXTtcbiAgICByZXR1cm4gZGF0YSAmJiBkYXRhW2ZpZWxkXTtcbiAgfTtcblxuICBfc2V0QWNjb3VudERhdGEoY29ubmVjdGlvbklkLCBmaWVsZCwgdmFsdWUpIHtcbiAgICBjb25zdCBkYXRhID0gdGhpcy5fYWNjb3VudERhdGFbY29ubmVjdGlvbklkXTtcblxuICAgIC8vIHNhZmV0eSBiZWx0LiBzaG91bGRuJ3QgaGFwcGVuLiBhY2NvdW50RGF0YSBpcyBzZXQgaW4gb25Db25uZWN0aW9uLFxuICAgIC8vIHdlIGRvbid0IGhhdmUgYSBjb25uZWN0aW9uSWQgdW50aWwgaXQgaXMgc2V0LlxuICAgIGlmICghZGF0YSlcbiAgICAgIHJldHVybjtcblxuICAgIGlmICh2YWx1ZSA9PT0gdW5kZWZpbmVkKVxuICAgICAgZGVsZXRlIGRhdGFbZmllbGRdO1xuICAgIGVsc2VcbiAgICAgIGRhdGFbZmllbGRdID0gdmFsdWU7XG4gIH07XG5cbiAgLy8vXG4gIC8vLyBSRUNPTk5FQ1QgVE9LRU5TXG4gIC8vL1xuICAvLy8gc3VwcG9ydCByZWNvbm5lY3RpbmcgdXNpbmcgYSBtZXRlb3IgbG9naW4gdG9rZW5cblxuICBfaGFzaExvZ2luVG9rZW4obG9naW5Ub2tlbikge1xuICAgIGNvbnN0IGhhc2ggPSBjcnlwdG8uY3JlYXRlSGFzaCgnc2hhMjU2Jyk7XG4gICAgaGFzaC51cGRhdGUobG9naW5Ub2tlbik7XG4gICAgcmV0dXJuIGhhc2guZGlnZXN0KCdiYXNlNjQnKTtcbiAgfTtcblxuICAvLyB7dG9rZW4sIHdoZW59ID0+IHtoYXNoZWRUb2tlbiwgd2hlbn1cbiAgX2hhc2hTdGFtcGVkVG9rZW4oc3RhbXBlZFRva2VuKSB7XG4gICAgY29uc3QgeyB0b2tlbiwgLi4uaGFzaGVkU3RhbXBlZFRva2VuIH0gPSBzdGFtcGVkVG9rZW47XG4gICAgcmV0dXJuIHtcbiAgICAgIC4uLmhhc2hlZFN0YW1wZWRUb2tlbixcbiAgICAgIGhhc2hlZFRva2VuOiB0aGlzLl9oYXNoTG9naW5Ub2tlbih0b2tlbilcbiAgICB9O1xuICB9O1xuXG4gIC8vIFVzaW5nICRhZGRUb1NldCBhdm9pZHMgZ2V0dGluZyBhbiBpbmRleCBlcnJvciBpZiBhbm90aGVyIGNsaWVudFxuICAvLyBsb2dnaW5nIGluIHNpbXVsdGFuZW91c2x5IGhhcyBhbHJlYWR5IGluc2VydGVkIHRoZSBuZXcgaGFzaGVkXG4gIC8vIHRva2VuLlxuICBfaW5zZXJ0SGFzaGVkTG9naW5Ub2tlbih1c2VySWQsIGhhc2hlZFRva2VuLCBxdWVyeSkge1xuICAgIHF1ZXJ5ID0gcXVlcnkgPyB7IC4uLnF1ZXJ5IH0gOiB7fTtcbiAgICBxdWVyeS5faWQgPSB1c2VySWQ7XG4gICAgdGhpcy51c2Vycy51cGRhdGUocXVlcnksIHtcbiAgICAgICRhZGRUb1NldDoge1xuICAgICAgICBcInNlcnZpY2VzLnJlc3VtZS5sb2dpblRva2Vuc1wiOiBoYXNoZWRUb2tlblxuICAgICAgfVxuICAgIH0pO1xuICB9O1xuXG4gIC8vIEV4cG9ydGVkIGZvciB0ZXN0cy5cbiAgX2luc2VydExvZ2luVG9rZW4odXNlcklkLCBzdGFtcGVkVG9rZW4sIHF1ZXJ5KSB7XG4gICAgdGhpcy5faW5zZXJ0SGFzaGVkTG9naW5Ub2tlbihcbiAgICAgIHVzZXJJZCxcbiAgICAgIHRoaXMuX2hhc2hTdGFtcGVkVG9rZW4oc3RhbXBlZFRva2VuKSxcbiAgICAgIHF1ZXJ5XG4gICAgKTtcbiAgfTtcblxuICBfY2xlYXJBbGxMb2dpblRva2Vucyh1c2VySWQpIHtcbiAgICB0aGlzLnVzZXJzLnVwZGF0ZSh1c2VySWQsIHtcbiAgICAgICRzZXQ6IHtcbiAgICAgICAgJ3NlcnZpY2VzLnJlc3VtZS5sb2dpblRva2Vucyc6IFtdXG4gICAgICB9XG4gICAgfSk7XG4gIH07XG5cbiAgLy8gdGVzdCBob29rXG4gIF9nZXRVc2VyT2JzZXJ2ZShjb25uZWN0aW9uSWQpIHtcbiAgICByZXR1cm4gdGhpcy5fdXNlck9ic2VydmVzRm9yQ29ubmVjdGlvbnNbY29ubmVjdGlvbklkXTtcbiAgfTtcblxuICAvLyBDbGVhbiB1cCB0aGlzIGNvbm5lY3Rpb24ncyBhc3NvY2lhdGlvbiB3aXRoIHRoZSB0b2tlbjogdGhhdCBpcywgc3RvcFxuICAvLyB0aGUgb2JzZXJ2ZSB0aGF0IHdlIHN0YXJ0ZWQgd2hlbiB3ZSBhc3NvY2lhdGVkIHRoZSBjb25uZWN0aW9uIHdpdGhcbiAgLy8gdGhpcyB0b2tlbi5cbiAgX3JlbW92ZVRva2VuRnJvbUNvbm5lY3Rpb24oY29ubmVjdGlvbklkKSB7XG4gICAgaWYgKGhhc093bi5jYWxsKHRoaXMuX3VzZXJPYnNlcnZlc0ZvckNvbm5lY3Rpb25zLCBjb25uZWN0aW9uSWQpKSB7XG4gICAgICBjb25zdCBvYnNlcnZlID0gdGhpcy5fdXNlck9ic2VydmVzRm9yQ29ubmVjdGlvbnNbY29ubmVjdGlvbklkXTtcbiAgICAgIGlmICh0eXBlb2Ygb2JzZXJ2ZSA9PT0gJ251bWJlcicpIHtcbiAgICAgICAgLy8gV2UncmUgaW4gdGhlIHByb2Nlc3Mgb2Ygc2V0dGluZyB1cCBhbiBvYnNlcnZlIGZvciB0aGlzIGNvbm5lY3Rpb24uIFdlXG4gICAgICAgIC8vIGNhbid0IGNsZWFuIHVwIHRoYXQgb2JzZXJ2ZSB5ZXQsIGJ1dCBpZiB3ZSBkZWxldGUgdGhlIHBsYWNlaG9sZGVyIGZvclxuICAgICAgICAvLyB0aGlzIGNvbm5lY3Rpb24sIHRoZW4gdGhlIG9ic2VydmUgd2lsbCBnZXQgY2xlYW5lZCB1cCBhcyBzb29uIGFzIGl0IGhhc1xuICAgICAgICAvLyBiZWVuIHNldCB1cC5cbiAgICAgICAgZGVsZXRlIHRoaXMuX3VzZXJPYnNlcnZlc0ZvckNvbm5lY3Rpb25zW2Nvbm5lY3Rpb25JZF07XG4gICAgICB9IGVsc2Uge1xuICAgICAgICBkZWxldGUgdGhpcy5fdXNlck9ic2VydmVzRm9yQ29ubmVjdGlvbnNbY29ubmVjdGlvbklkXTtcbiAgICAgICAgb2JzZXJ2ZS5zdG9wKCk7XG4gICAgICB9XG4gICAgfVxuICB9O1xuXG4gIF9nZXRMb2dpblRva2VuKGNvbm5lY3Rpb25JZCkge1xuICAgIHJldHVybiB0aGlzLl9nZXRBY2NvdW50RGF0YShjb25uZWN0aW9uSWQsICdsb2dpblRva2VuJyk7XG4gIH07XG5cbiAgLy8gbmV3VG9rZW4gaXMgYSBoYXNoZWQgdG9rZW4uXG4gIF9zZXRMb2dpblRva2VuKHVzZXJJZCwgY29ubmVjdGlvbiwgbmV3VG9rZW4pIHtcbiAgICB0aGlzLl9yZW1vdmVUb2tlbkZyb21Db25uZWN0aW9uKGNvbm5lY3Rpb24uaWQpO1xuICAgIHRoaXMuX3NldEFjY291bnREYXRhKGNvbm5lY3Rpb24uaWQsICdsb2dpblRva2VuJywgbmV3VG9rZW4pO1xuXG4gICAgaWYgKG5ld1Rva2VuKSB7XG4gICAgICAvLyBTZXQgdXAgYW4gb2JzZXJ2ZSBmb3IgdGhpcyB0b2tlbi4gSWYgdGhlIHRva2VuIGdvZXMgYXdheSwgd2UgbmVlZFxuICAgICAgLy8gdG8gY2xvc2UgdGhlIGNvbm5lY3Rpb24uICBXZSBkZWZlciB0aGUgb2JzZXJ2ZSBiZWNhdXNlIHRoZXJlJ3NcbiAgICAgIC8vIG5vIG5lZWQgZm9yIGl0IHRvIGJlIG9uIHRoZSBjcml0aWNhbCBwYXRoIGZvciBsb2dpbjsgd2UganVzdCBuZWVkXG4gICAgICAvLyB0byBlbnN1cmUgdGhhdCB0aGUgY29ubmVjdGlvbiB3aWxsIGdldCBjbG9zZWQgYXQgc29tZSBwb2ludCBpZlxuICAgICAgLy8gdGhlIHRva2VuIGdldHMgZGVsZXRlZC5cbiAgICAgIC8vXG4gICAgICAvLyBJbml0aWFsbHksIHdlIHNldCB0aGUgb2JzZXJ2ZSBmb3IgdGhpcyBjb25uZWN0aW9uIHRvIGEgbnVtYmVyOyB0aGlzXG4gICAgICAvLyBzaWduaWZpZXMgdG8gb3RoZXIgY29kZSAod2hpY2ggbWlnaHQgcnVuIHdoaWxlIHdlIHlpZWxkKSB0aGF0IHdlIGFyZSBpblxuICAgICAgLy8gdGhlIHByb2Nlc3Mgb2Ygc2V0dGluZyB1cCBhbiBvYnNlcnZlIGZvciB0aGlzIGNvbm5lY3Rpb24uIE9uY2UgdGhlXG4gICAgICAvLyBvYnNlcnZlIGlzIHJlYWR5IHRvIGdvLCB3ZSByZXBsYWNlIHRoZSBudW1iZXIgd2l0aCB0aGUgcmVhbCBvYnNlcnZlXG4gICAgICAvLyBoYW5kbGUgKHVubGVzcyB0aGUgcGxhY2Vob2xkZXIgaGFzIGJlZW4gZGVsZXRlZCBvciByZXBsYWNlZCBieSBhXG4gICAgICAvLyBkaWZmZXJlbnQgcGxhY2Vob2xkIG51bWJlciwgc2lnbmlmeWluZyB0aGF0IHRoZSBjb25uZWN0aW9uIHdhcyBjbG9zZWRcbiAgICAgIC8vIGFscmVhZHkgLS0gaW4gdGhpcyBjYXNlIHdlIGp1c3QgY2xlYW4gdXAgdGhlIG9ic2VydmUgdGhhdCB3ZSBzdGFydGVkKS5cbiAgICAgIGNvbnN0IG15T2JzZXJ2ZU51bWJlciA9ICsrdGhpcy5fbmV4dFVzZXJPYnNlcnZlTnVtYmVyO1xuICAgICAgdGhpcy5fdXNlck9ic2VydmVzRm9yQ29ubmVjdGlvbnNbY29ubmVjdGlvbi5pZF0gPSBteU9ic2VydmVOdW1iZXI7XG4gICAgICBNZXRlb3IuZGVmZXIoKCkgPT4ge1xuICAgICAgICAvLyBJZiBzb21ldGhpbmcgZWxzZSBoYXBwZW5lZCBvbiB0aGlzIGNvbm5lY3Rpb24gaW4gdGhlIG1lYW50aW1lIChpdCBnb3RcbiAgICAgICAgLy8gY2xvc2VkLCBvciBhbm90aGVyIGNhbGwgdG8gX3NldExvZ2luVG9rZW4gaGFwcGVuZWQpLCBqdXN0IGRvXG4gICAgICAgIC8vIG5vdGhpbmcuIFdlIGRvbid0IG5lZWQgdG8gc3RhcnQgYW4gb2JzZXJ2ZSBmb3IgYW4gb2xkIGNvbm5lY3Rpb24gb3Igb2xkXG4gICAgICAgIC8vIHRva2VuLlxuICAgICAgICBpZiAodGhpcy5fdXNlck9ic2VydmVzRm9yQ29ubmVjdGlvbnNbY29ubmVjdGlvbi5pZF0gIT09IG15T2JzZXJ2ZU51bWJlcikge1xuICAgICAgICAgIHJldHVybjtcbiAgICAgICAgfVxuXG4gICAgICAgIGxldCBmb3VuZE1hdGNoaW5nVXNlcjtcbiAgICAgICAgLy8gQmVjYXVzZSB3ZSB1cGdyYWRlIHVuaGFzaGVkIGxvZ2luIHRva2VucyB0byBoYXNoZWQgdG9rZW5zIGF0XG4gICAgICAgIC8vIGxvZ2luIHRpbWUsIHNlc3Npb25zIHdpbGwgb25seSBiZSBsb2dnZWQgaW4gd2l0aCBhIGhhc2hlZFxuICAgICAgICAvLyB0b2tlbi4gVGh1cyB3ZSBvbmx5IG5lZWQgdG8gb2JzZXJ2ZSBoYXNoZWQgdG9rZW5zIGhlcmUuXG4gICAgICAgIGNvbnN0IG9ic2VydmUgPSB0aGlzLnVzZXJzLmZpbmQoe1xuICAgICAgICAgIF9pZDogdXNlcklkLFxuICAgICAgICAgICdzZXJ2aWNlcy5yZXN1bWUubG9naW5Ub2tlbnMuaGFzaGVkVG9rZW4nOiBuZXdUb2tlblxuICAgICAgICB9LCB7IGZpZWxkczogeyBfaWQ6IDEgfSB9KS5vYnNlcnZlQ2hhbmdlcyh7XG4gICAgICAgICAgYWRkZWQ6ICgpID0+IHtcbiAgICAgICAgICAgIGZvdW5kTWF0Y2hpbmdVc2VyID0gdHJ1ZTtcbiAgICAgICAgICB9LFxuICAgICAgICAgIHJlbW92ZWQ6IGNvbm5lY3Rpb24uY2xvc2UsXG4gICAgICAgICAgLy8gVGhlIG9uQ2xvc2UgY2FsbGJhY2sgZm9yIHRoZSBjb25uZWN0aW9uIHRha2VzIGNhcmUgb2ZcbiAgICAgICAgICAvLyBjbGVhbmluZyB1cCB0aGUgb2JzZXJ2ZSBoYW5kbGUgYW5kIGFueSBvdGhlciBzdGF0ZSB3ZSBoYXZlXG4gICAgICAgICAgLy8gbHlpbmcgYXJvdW5kLlxuICAgICAgICB9LCB7IG5vbk11dGF0aW5nQ2FsbGJhY2tzOiB0cnVlIH0pO1xuXG4gICAgICAgIC8vIElmIHRoZSB1c2VyIHJhbiBhbm90aGVyIGxvZ2luIG9yIGxvZ291dCBjb21tYW5kIHdlIHdlcmUgd2FpdGluZyBmb3IgdGhlXG4gICAgICAgIC8vIGRlZmVyIG9yIGFkZGVkIHRvIGZpcmUgKGllLCBhbm90aGVyIGNhbGwgdG8gX3NldExvZ2luVG9rZW4gb2NjdXJyZWQpLFxuICAgICAgICAvLyB0aGVuIHdlIGxldCB0aGUgbGF0ZXIgb25lIHdpbiAoc3RhcnQgYW4gb2JzZXJ2ZSwgZXRjKSBhbmQganVzdCBzdG9wIG91clxuICAgICAgICAvLyBvYnNlcnZlIG5vdy5cbiAgICAgICAgLy9cbiAgICAgICAgLy8gU2ltaWxhcmx5LCBpZiB0aGUgY29ubmVjdGlvbiB3YXMgYWxyZWFkeSBjbG9zZWQsIHRoZW4gdGhlIG9uQ2xvc2VcbiAgICAgICAgLy8gY2FsbGJhY2sgd291bGQgaGF2ZSBjYWxsZWQgX3JlbW92ZVRva2VuRnJvbUNvbm5lY3Rpb24gYW5kIHRoZXJlIHdvbid0XG4gICAgICAgIC8vIGJlIGFuIGVudHJ5IGluIF91c2VyT2JzZXJ2ZXNGb3JDb25uZWN0aW9ucy4gV2UgY2FuIHN0b3AgdGhlIG9ic2VydmUuXG4gICAgICAgIGlmICh0aGlzLl91c2VyT2JzZXJ2ZXNGb3JDb25uZWN0aW9uc1tjb25uZWN0aW9uLmlkXSAhPT0gbXlPYnNlcnZlTnVtYmVyKSB7XG4gICAgICAgICAgb2JzZXJ2ZS5zdG9wKCk7XG4gICAgICAgICAgcmV0dXJuO1xuICAgICAgICB9XG5cbiAgICAgICAgdGhpcy5fdXNlck9ic2VydmVzRm9yQ29ubmVjdGlvbnNbY29ubmVjdGlvbi5pZF0gPSBvYnNlcnZlO1xuXG4gICAgICAgIGlmICghIGZvdW5kTWF0Y2hpbmdVc2VyKSB7XG4gICAgICAgICAgLy8gV2UndmUgc2V0IHVwIGFuIG9ic2VydmUgb24gdGhlIHVzZXIgYXNzb2NpYXRlZCB3aXRoIGBuZXdUb2tlbmAsXG4gICAgICAgICAgLy8gc28gaWYgdGhlIG5ldyB0b2tlbiBpcyByZW1vdmVkIGZyb20gdGhlIGRhdGFiYXNlLCB3ZSdsbCBjbG9zZVxuICAgICAgICAgIC8vIHRoZSBjb25uZWN0aW9uLiBCdXQgdGhlIHRva2VuIG1pZ2h0IGhhdmUgYWxyZWFkeSBiZWVuIGRlbGV0ZWRcbiAgICAgICAgICAvLyBiZWZvcmUgd2Ugc2V0IHVwIHRoZSBvYnNlcnZlLCB3aGljaCB3b3VsZG4ndCBoYXZlIGNsb3NlZCB0aGVcbiAgICAgICAgICAvLyBjb25uZWN0aW9uIGJlY2F1c2UgdGhlIG9ic2VydmUgd2Fzbid0IHJ1bm5pbmcgeWV0LlxuICAgICAgICAgIGNvbm5lY3Rpb24uY2xvc2UoKTtcbiAgICAgICAgfVxuICAgICAgfSk7XG4gICAgfVxuICB9O1xuXG4gIC8vIChBbHNvIHVzZWQgYnkgTWV0ZW9yIEFjY291bnRzIHNlcnZlciBhbmQgdGVzdHMpLlxuICAvL1xuICBfZ2VuZXJhdGVTdGFtcGVkTG9naW5Ub2tlbigpIHtcbiAgICByZXR1cm4ge1xuICAgICAgdG9rZW46IFJhbmRvbS5zZWNyZXQoKSxcbiAgICAgIHdoZW46IG5ldyBEYXRlXG4gICAgfTtcbiAgfTtcblxuICAvLy9cbiAgLy8vIFRPS0VOIEVYUElSQVRJT05cbiAgLy8vXG5cbiAgLy8gRGVsZXRlcyBleHBpcmVkIHBhc3N3b3JkIHJlc2V0IHRva2VucyBmcm9tIHRoZSBkYXRhYmFzZS5cbiAgLy9cbiAgLy8gRXhwb3J0ZWQgZm9yIHRlc3RzLiBBbHNvLCB0aGUgYXJndW1lbnRzIGFyZSBvbmx5IHVzZWQgYnlcbiAgLy8gdGVzdHMuIG9sZGVzdFZhbGlkRGF0ZSBpcyBzaW11bGF0ZSBleHBpcmluZyB0b2tlbnMgd2l0aG91dCB3YWl0aW5nXG4gIC8vIGZvciB0aGVtIHRvIGFjdHVhbGx5IGV4cGlyZS4gdXNlcklkIGlzIHVzZWQgYnkgdGVzdHMgdG8gb25seSBleHBpcmVcbiAgLy8gdG9rZW5zIGZvciB0aGUgdGVzdCB1c2VyLlxuICBfZXhwaXJlUGFzc3dvcmRSZXNldFRva2VucyhvbGRlc3RWYWxpZERhdGUsIHVzZXJJZCkge1xuICAgIGNvbnN0IHRva2VuTGlmZXRpbWVNcyA9IHRoaXMuX2dldFBhc3N3b3JkUmVzZXRUb2tlbkxpZmV0aW1lTXMoKTtcblxuICAgIC8vIHdoZW4gY2FsbGluZyBmcm9tIGEgdGVzdCB3aXRoIGV4dHJhIGFyZ3VtZW50cywgeW91IG11c3Qgc3BlY2lmeSBib3RoIVxuICAgIGlmICgob2xkZXN0VmFsaWREYXRlICYmICF1c2VySWQpIHx8ICghb2xkZXN0VmFsaWREYXRlICYmIHVzZXJJZCkpIHtcbiAgICAgIHRocm93IG5ldyBFcnJvcihcIkJhZCB0ZXN0LiBNdXN0IHNwZWNpZnkgYm90aCBvbGRlc3RWYWxpZERhdGUgYW5kIHVzZXJJZC5cIik7XG4gICAgfVxuXG4gICAgb2xkZXN0VmFsaWREYXRlID0gb2xkZXN0VmFsaWREYXRlIHx8XG4gICAgICAobmV3IERhdGUobmV3IERhdGUoKSAtIHRva2VuTGlmZXRpbWVNcykpO1xuXG4gICAgY29uc3QgdG9rZW5GaWx0ZXIgPSB7XG4gICAgICAkb3I6IFtcbiAgICAgICAgeyBcInNlcnZpY2VzLnBhc3N3b3JkLnJlc2V0LnJlYXNvblwiOiBcInJlc2V0XCJ9LFxuICAgICAgICB7IFwic2VydmljZXMucGFzc3dvcmQucmVzZXQucmVhc29uXCI6IHskZXhpc3RzOiBmYWxzZX19XG4gICAgICBdXG4gICAgfTtcblxuICAgIGV4cGlyZVBhc3N3b3JkVG9rZW4odGhpcywgb2xkZXN0VmFsaWREYXRlLCB0b2tlbkZpbHRlciwgdXNlcklkKTtcbiAgfVxuXG4gIC8vIERlbGV0ZXMgZXhwaXJlZCBwYXNzd29yZCBlbnJvbGwgdG9rZW5zIGZyb20gdGhlIGRhdGFiYXNlLlxuICAvL1xuICAvLyBFeHBvcnRlZCBmb3IgdGVzdHMuIEFsc28sIHRoZSBhcmd1bWVudHMgYXJlIG9ubHkgdXNlZCBieVxuICAvLyB0ZXN0cy4gb2xkZXN0VmFsaWREYXRlIGlzIHNpbXVsYXRlIGV4cGlyaW5nIHRva2VucyB3aXRob3V0IHdhaXRpbmdcbiAgLy8gZm9yIHRoZW0gdG8gYWN0dWFsbHkgZXhwaXJlLiB1c2VySWQgaXMgdXNlZCBieSB0ZXN0cyB0byBvbmx5IGV4cGlyZVxuICAvLyB0b2tlbnMgZm9yIHRoZSB0ZXN0IHVzZXIuXG4gIF9leHBpcmVQYXNzd29yZEVucm9sbFRva2VucyhvbGRlc3RWYWxpZERhdGUsIHVzZXJJZCkge1xuICAgIGNvbnN0IHRva2VuTGlmZXRpbWVNcyA9IHRoaXMuX2dldFBhc3N3b3JkRW5yb2xsVG9rZW5MaWZldGltZU1zKCk7XG5cbiAgICAvLyB3aGVuIGNhbGxpbmcgZnJvbSBhIHRlc3Qgd2l0aCBleHRyYSBhcmd1bWVudHMsIHlvdSBtdXN0IHNwZWNpZnkgYm90aCFcbiAgICBpZiAoKG9sZGVzdFZhbGlkRGF0ZSAmJiAhdXNlcklkKSB8fCAoIW9sZGVzdFZhbGlkRGF0ZSAmJiB1c2VySWQpKSB7XG4gICAgICB0aHJvdyBuZXcgRXJyb3IoXCJCYWQgdGVzdC4gTXVzdCBzcGVjaWZ5IGJvdGggb2xkZXN0VmFsaWREYXRlIGFuZCB1c2VySWQuXCIpO1xuICAgIH1cblxuICAgIG9sZGVzdFZhbGlkRGF0ZSA9IG9sZGVzdFZhbGlkRGF0ZSB8fFxuICAgICAgKG5ldyBEYXRlKG5ldyBEYXRlKCkgLSB0b2tlbkxpZmV0aW1lTXMpKTtcblxuICAgIGNvbnN0IHRva2VuRmlsdGVyID0ge1xuICAgICAgXCJzZXJ2aWNlcy5wYXNzd29yZC5lbnJvbGwucmVhc29uXCI6IFwiZW5yb2xsXCJcbiAgICB9O1xuXG4gICAgZXhwaXJlUGFzc3dvcmRUb2tlbih0aGlzLCBvbGRlc3RWYWxpZERhdGUsIHRva2VuRmlsdGVyLCB1c2VySWQpO1xuICB9XG5cbiAgLy8gRGVsZXRlcyBleHBpcmVkIHRva2VucyBmcm9tIHRoZSBkYXRhYmFzZSBhbmQgY2xvc2VzIGFsbCBvcGVuIGNvbm5lY3Rpb25zXG4gIC8vIGFzc29jaWF0ZWQgd2l0aCB0aGVzZSB0b2tlbnMuXG4gIC8vXG4gIC8vIEV4cG9ydGVkIGZvciB0ZXN0cy4gQWxzbywgdGhlIGFyZ3VtZW50cyBhcmUgb25seSB1c2VkIGJ5XG4gIC8vIHRlc3RzLiBvbGRlc3RWYWxpZERhdGUgaXMgc2ltdWxhdGUgZXhwaXJpbmcgdG9rZW5zIHdpdGhvdXQgd2FpdGluZ1xuICAvLyBmb3IgdGhlbSB0byBhY3R1YWxseSBleHBpcmUuIHVzZXJJZCBpcyB1c2VkIGJ5IHRlc3RzIHRvIG9ubHkgZXhwaXJlXG4gIC8vIHRva2VucyBmb3IgdGhlIHRlc3QgdXNlci5cbiAgX2V4cGlyZVRva2VucyhvbGRlc3RWYWxpZERhdGUsIHVzZXJJZCkge1xuICAgIGNvbnN0IHRva2VuTGlmZXRpbWVNcyA9IHRoaXMuX2dldFRva2VuTGlmZXRpbWVNcygpO1xuXG4gICAgLy8gd2hlbiBjYWxsaW5nIGZyb20gYSB0ZXN0IHdpdGggZXh0cmEgYXJndW1lbnRzLCB5b3UgbXVzdCBzcGVjaWZ5IGJvdGghXG4gICAgaWYgKChvbGRlc3RWYWxpZERhdGUgJiYgIXVzZXJJZCkgfHwgKCFvbGRlc3RWYWxpZERhdGUgJiYgdXNlcklkKSkge1xuICAgICAgdGhyb3cgbmV3IEVycm9yKFwiQmFkIHRlc3QuIE11c3Qgc3BlY2lmeSBib3RoIG9sZGVzdFZhbGlkRGF0ZSBhbmQgdXNlcklkLlwiKTtcbiAgICB9XG5cbiAgICBvbGRlc3RWYWxpZERhdGUgPSBvbGRlc3RWYWxpZERhdGUgfHxcbiAgICAgIChuZXcgRGF0ZShuZXcgRGF0ZSgpIC0gdG9rZW5MaWZldGltZU1zKSk7XG4gICAgY29uc3QgdXNlckZpbHRlciA9IHVzZXJJZCA/IHtfaWQ6IHVzZXJJZH0gOiB7fTtcblxuXG4gICAgLy8gQmFja3dhcmRzIGNvbXBhdGlibGUgd2l0aCBvbGRlciB2ZXJzaW9ucyBvZiBtZXRlb3IgdGhhdCBzdG9yZWQgbG9naW4gdG9rZW5cbiAgICAvLyB0aW1lc3RhbXBzIGFzIG51bWJlcnMuXG4gICAgdGhpcy51c2Vycy51cGRhdGUoeyAuLi51c2VyRmlsdGVyLFxuICAgICAgJG9yOiBbXG4gICAgICAgIHsgXCJzZXJ2aWNlcy5yZXN1bWUubG9naW5Ub2tlbnMud2hlblwiOiB7ICRsdDogb2xkZXN0VmFsaWREYXRlIH0gfSxcbiAgICAgICAgeyBcInNlcnZpY2VzLnJlc3VtZS5sb2dpblRva2Vucy53aGVuXCI6IHsgJGx0OiArb2xkZXN0VmFsaWREYXRlIH0gfVxuICAgICAgXVxuICAgIH0sIHtcbiAgICAgICRwdWxsOiB7XG4gICAgICAgIFwic2VydmljZXMucmVzdW1lLmxvZ2luVG9rZW5zXCI6IHtcbiAgICAgICAgICAkb3I6IFtcbiAgICAgICAgICAgIHsgd2hlbjogeyAkbHQ6IG9sZGVzdFZhbGlkRGF0ZSB9IH0sXG4gICAgICAgICAgICB7IHdoZW46IHsgJGx0OiArb2xkZXN0VmFsaWREYXRlIH0gfVxuICAgICAgICAgIF1cbiAgICAgICAgfVxuICAgICAgfVxuICAgIH0sIHsgbXVsdGk6IHRydWUgfSk7XG4gICAgLy8gVGhlIG9ic2VydmUgb24gTWV0ZW9yLnVzZXJzIHdpbGwgdGFrZSBjYXJlIG9mIGNsb3NpbmcgY29ubmVjdGlvbnMgZm9yXG4gICAgLy8gZXhwaXJlZCB0b2tlbnMuXG4gIH07XG5cbiAgLy8gQG92ZXJyaWRlIGZyb20gYWNjb3VudHNfY29tbW9uLmpzXG4gIGNvbmZpZyhvcHRpb25zKSB7XG4gICAgLy8gQ2FsbCB0aGUgb3ZlcnJpZGRlbiBpbXBsZW1lbnRhdGlvbiBvZiB0aGUgbWV0aG9kLlxuICAgIGNvbnN0IHN1cGVyUmVzdWx0ID0gQWNjb3VudHNDb21tb24ucHJvdG90eXBlLmNvbmZpZy5hcHBseSh0aGlzLCBhcmd1bWVudHMpO1xuXG4gICAgLy8gSWYgdGhlIHVzZXIgc2V0IGxvZ2luRXhwaXJhdGlvbkluRGF5cyB0byBudWxsLCB0aGVuIHdlIG5lZWQgdG8gY2xlYXIgdGhlXG4gICAgLy8gdGltZXIgdGhhdCBwZXJpb2RpY2FsbHkgZXhwaXJlcyB0b2tlbnMuXG4gICAgaWYgKGhhc093bi5jYWxsKHRoaXMuX29wdGlvbnMsICdsb2dpbkV4cGlyYXRpb25JbkRheXMnKSAmJlxuICAgICAgdGhpcy5fb3B0aW9ucy5sb2dpbkV4cGlyYXRpb25JbkRheXMgPT09IG51bGwgJiZcbiAgICAgIHRoaXMuZXhwaXJlVG9rZW5JbnRlcnZhbCkge1xuICAgICAgTWV0ZW9yLmNsZWFySW50ZXJ2YWwodGhpcy5leHBpcmVUb2tlbkludGVydmFsKTtcbiAgICAgIHRoaXMuZXhwaXJlVG9rZW5JbnRlcnZhbCA9IG51bGw7XG4gICAgfVxuXG4gICAgcmV0dXJuIHN1cGVyUmVzdWx0O1xuICB9O1xuXG4gIC8vIENhbGxlZCBieSBhY2NvdW50cy1wYXNzd29yZFxuICBpbnNlcnRVc2VyRG9jKG9wdGlvbnMsIHVzZXIpIHtcbiAgICAvLyAtIGNsb25lIHVzZXIgZG9jdW1lbnQsIHRvIHByb3RlY3QgZnJvbSBtb2RpZmljYXRpb25cbiAgICAvLyAtIGFkZCBjcmVhdGVkQXQgdGltZXN0YW1wXG4gICAgLy8gLSBwcmVwYXJlIGFuIF9pZCwgc28gdGhhdCB5b3UgY2FuIG1vZGlmeSBvdGhlciBjb2xsZWN0aW9ucyAoZWdcbiAgICAvLyBjcmVhdGUgYSBmaXJzdCB0YXNrIGZvciBldmVyeSBuZXcgdXNlcilcbiAgICAvL1xuICAgIC8vIFhYWCBJZiB0aGUgb25DcmVhdGVVc2VyIG9yIHZhbGlkYXRlTmV3VXNlciBob29rcyBmYWlsLCB3ZSBtaWdodFxuICAgIC8vIGVuZCB1cCBoYXZpbmcgbW9kaWZpZWQgc29tZSBvdGhlciBjb2xsZWN0aW9uXG4gICAgLy8gaW5hcHByb3ByaWF0ZWx5LiBUaGUgc29sdXRpb24gaXMgcHJvYmFibHkgdG8gaGF2ZSBvbkNyZWF0ZVVzZXJcbiAgICAvLyBhY2NlcHQgdHdvIGNhbGxiYWNrcyAtIG9uZSB0aGF0IGdldHMgY2FsbGVkIGJlZm9yZSBpbnNlcnRpbmdcbiAgICAvLyB0aGUgdXNlciBkb2N1bWVudCAoaW4gd2hpY2ggeW91IGNhbiBtb2RpZnkgaXRzIGNvbnRlbnRzKSwgYW5kXG4gICAgLy8gb25lIHRoYXQgZ2V0cyBjYWxsZWQgYWZ0ZXIgKGluIHdoaWNoIHlvdSBzaG91bGQgY2hhbmdlIG90aGVyXG4gICAgLy8gY29sbGVjdGlvbnMpXG4gICAgdXNlciA9IHtcbiAgICAgIGNyZWF0ZWRBdDogbmV3IERhdGUoKSxcbiAgICAgIF9pZDogUmFuZG9tLmlkKCksXG4gICAgICAuLi51c2VyLFxuICAgIH07XG5cbiAgICBpZiAodXNlci5zZXJ2aWNlcykge1xuICAgICAgT2JqZWN0LmtleXModXNlci5zZXJ2aWNlcykuZm9yRWFjaChzZXJ2aWNlID0+XG4gICAgICAgIHBpbkVuY3J5cHRlZEZpZWxkc1RvVXNlcih1c2VyLnNlcnZpY2VzW3NlcnZpY2VdLCB1c2VyLl9pZClcbiAgICAgICk7XG4gICAgfVxuXG4gICAgbGV0IGZ1bGxVc2VyO1xuICAgIGlmICh0aGlzLl9vbkNyZWF0ZVVzZXJIb29rKSB7XG4gICAgICBmdWxsVXNlciA9IHRoaXMuX29uQ3JlYXRlVXNlckhvb2sob3B0aW9ucywgdXNlcik7XG5cbiAgICAgIC8vIFRoaXMgaXMgKm5vdCogcGFydCBvZiB0aGUgQVBJLiBXZSBuZWVkIHRoaXMgYmVjYXVzZSB3ZSBjYW4ndCBpc29sYXRlXG4gICAgICAvLyB0aGUgZ2xvYmFsIHNlcnZlciBlbnZpcm9ubWVudCBiZXR3ZWVuIHRlc3RzLCBtZWFuaW5nIHdlIGNhbid0IHRlc3RcbiAgICAgIC8vIGJvdGggaGF2aW5nIGEgY3JlYXRlIHVzZXIgaG9vayBzZXQgYW5kIG5vdCBoYXZpbmcgb25lIHNldC5cbiAgICAgIGlmIChmdWxsVXNlciA9PT0gJ1RFU1QgREVGQVVMVCBIT09LJylcbiAgICAgICAgZnVsbFVzZXIgPSBkZWZhdWx0Q3JlYXRlVXNlckhvb2sob3B0aW9ucywgdXNlcik7XG4gICAgfSBlbHNlIHtcbiAgICAgIGZ1bGxVc2VyID0gZGVmYXVsdENyZWF0ZVVzZXJIb29rKG9wdGlvbnMsIHVzZXIpO1xuICAgIH1cblxuICAgIHRoaXMuX3ZhbGlkYXRlTmV3VXNlckhvb2tzLmZvckVhY2goaG9vayA9PiB7XG4gICAgICBpZiAoISBob29rKGZ1bGxVc2VyKSlcbiAgICAgICAgdGhyb3cgbmV3IE1ldGVvci5FcnJvcig0MDMsIFwiVXNlciB2YWxpZGF0aW9uIGZhaWxlZFwiKTtcbiAgICB9KTtcblxuICAgIGxldCB1c2VySWQ7XG4gICAgdHJ5IHtcbiAgICAgIHVzZXJJZCA9IHRoaXMudXNlcnMuaW5zZXJ0KGZ1bGxVc2VyKTtcbiAgICB9IGNhdGNoIChlKSB7XG4gICAgICAvLyBYWFggc3RyaW5nIHBhcnNpbmcgc3Vja3MsIG1heWJlXG4gICAgICAvLyBodHRwczovL2ppcmEubW9uZ29kYi5vcmcvYnJvd3NlL1NFUlZFUi0zMDY5IHdpbGwgZ2V0IGZpeGVkIG9uZSBkYXlcbiAgICAgIC8vIGh0dHBzOi8vamlyYS5tb25nb2RiLm9yZy9icm93c2UvU0VSVkVSLTQ2MzdcbiAgICAgIGlmICghZS5lcnJtc2cpIHRocm93IGU7XG4gICAgICBpZiAoZS5lcnJtc2cuaW5jbHVkZXMoJ2VtYWlscy5hZGRyZXNzJykpXG4gICAgICAgIHRocm93IG5ldyBNZXRlb3IuRXJyb3IoNDAzLCBcIkVtYWlsIGFscmVhZHkgZXhpc3RzLlwiKTtcbiAgICAgIGlmIChlLmVycm1zZy5pbmNsdWRlcygndXNlcm5hbWUnKSlcbiAgICAgICAgdGhyb3cgbmV3IE1ldGVvci5FcnJvcig0MDMsIFwiVXNlcm5hbWUgYWxyZWFkeSBleGlzdHMuXCIpO1xuICAgICAgdGhyb3cgZTtcbiAgICB9XG4gICAgcmV0dXJuIHVzZXJJZDtcbiAgfTtcblxuICAvLyBIZWxwZXIgZnVuY3Rpb246IHJldHVybnMgZmFsc2UgaWYgZW1haWwgZG9lcyBub3QgbWF0Y2ggY29tcGFueSBkb21haW4gZnJvbVxuICAvLyB0aGUgY29uZmlndXJhdGlvbi5cbiAgX3Rlc3RFbWFpbERvbWFpbihlbWFpbCkge1xuICAgIGNvbnN0IGRvbWFpbiA9IHRoaXMuX29wdGlvbnMucmVzdHJpY3RDcmVhdGlvbkJ5RW1haWxEb21haW47XG5cbiAgICByZXR1cm4gIWRvbWFpbiB8fFxuICAgICAgKHR5cGVvZiBkb21haW4gPT09ICdmdW5jdGlvbicgJiYgZG9tYWluKGVtYWlsKSkgfHxcbiAgICAgICh0eXBlb2YgZG9tYWluID09PSAnc3RyaW5nJyAmJlxuICAgICAgICAobmV3IFJlZ0V4cChgQCR7TWV0ZW9yLl9lc2NhcGVSZWdFeHAoZG9tYWluKX0kYCwgJ2knKSkudGVzdChlbWFpbCkpO1xuICB9O1xuXG4gIC8vL1xuICAvLy8gQ0xFQU4gVVAgRk9SIGBsb2dvdXRPdGhlckNsaWVudHNgXG4gIC8vL1xuXG4gIF9kZWxldGVTYXZlZFRva2Vuc0ZvclVzZXIodXNlcklkLCB0b2tlbnNUb0RlbGV0ZSkge1xuICAgIGlmICh0b2tlbnNUb0RlbGV0ZSkge1xuICAgICAgdGhpcy51c2Vycy51cGRhdGUodXNlcklkLCB7XG4gICAgICAgICR1bnNldDoge1xuICAgICAgICAgIFwic2VydmljZXMucmVzdW1lLmhhdmVMb2dpblRva2Vuc1RvRGVsZXRlXCI6IDEsXG4gICAgICAgICAgXCJzZXJ2aWNlcy5yZXN1bWUubG9naW5Ub2tlbnNUb0RlbGV0ZVwiOiAxXG4gICAgICAgIH0sXG4gICAgICAgICRwdWxsQWxsOiB7XG4gICAgICAgICAgXCJzZXJ2aWNlcy5yZXN1bWUubG9naW5Ub2tlbnNcIjogdG9rZW5zVG9EZWxldGVcbiAgICAgICAgfVxuICAgICAgfSk7XG4gICAgfVxuICB9O1xuXG4gIF9kZWxldGVTYXZlZFRva2Vuc0ZvckFsbFVzZXJzT25TdGFydHVwKCkge1xuICAgIC8vIElmIHdlIGZpbmQgdXNlcnMgd2hvIGhhdmUgc2F2ZWQgdG9rZW5zIHRvIGRlbGV0ZSBvbiBzdGFydHVwLCBkZWxldGVcbiAgICAvLyB0aGVtIG5vdy4gSXQncyBwb3NzaWJsZSB0aGF0IHRoZSBzZXJ2ZXIgY291bGQgaGF2ZSBjcmFzaGVkIGFuZCBjb21lXG4gICAgLy8gYmFjayB1cCBiZWZvcmUgbmV3IHRva2VucyBhcmUgZm91bmQgaW4gbG9jYWxTdG9yYWdlLCBidXQgdGhpc1xuICAgIC8vIHNob3VsZG4ndCBoYXBwZW4gdmVyeSBvZnRlbi4gV2Ugc2hvdWxkbid0IHB1dCBhIGRlbGF5IGhlcmUgYmVjYXVzZVxuICAgIC8vIHRoYXQgd291bGQgZ2l2ZSBhIGxvdCBvZiBwb3dlciB0byBhbiBhdHRhY2tlciB3aXRoIGEgc3RvbGVuIGxvZ2luXG4gICAgLy8gdG9rZW4gYW5kIHRoZSBhYmlsaXR5IHRvIGNyYXNoIHRoZSBzZXJ2ZXIuXG4gICAgTWV0ZW9yLnN0YXJ0dXAoKCkgPT4ge1xuICAgICAgdGhpcy51c2Vycy5maW5kKHtcbiAgICAgICAgXCJzZXJ2aWNlcy5yZXN1bWUuaGF2ZUxvZ2luVG9rZW5zVG9EZWxldGVcIjogdHJ1ZVxuICAgICAgfSwge2ZpZWxkczoge1xuICAgICAgICAgIFwic2VydmljZXMucmVzdW1lLmxvZ2luVG9rZW5zVG9EZWxldGVcIjogMVxuICAgICAgICB9fSkuZm9yRWFjaCh1c2VyID0+IHtcbiAgICAgICAgdGhpcy5fZGVsZXRlU2F2ZWRUb2tlbnNGb3JVc2VyKFxuICAgICAgICAgIHVzZXIuX2lkLFxuICAgICAgICAgIHVzZXIuc2VydmljZXMucmVzdW1lLmxvZ2luVG9rZW5zVG9EZWxldGVcbiAgICAgICAgKTtcbiAgICAgIH0pO1xuICAgIH0pO1xuICB9O1xuXG4gIC8vL1xuICAvLy8gTUFOQUdJTkcgVVNFUiBPQkpFQ1RTXG4gIC8vL1xuXG4gIC8vIFVwZGF0ZXMgb3IgY3JlYXRlcyBhIHVzZXIgYWZ0ZXIgd2UgYXV0aGVudGljYXRlIHdpdGggYSAzcmQgcGFydHkuXG4gIC8vXG4gIC8vIEBwYXJhbSBzZXJ2aWNlTmFtZSB7U3RyaW5nfSBTZXJ2aWNlIG5hbWUgKGVnLCB0d2l0dGVyKS5cbiAgLy8gQHBhcmFtIHNlcnZpY2VEYXRhIHtPYmplY3R9IERhdGEgdG8gc3RvcmUgaW4gdGhlIHVzZXIncyByZWNvcmRcbiAgLy8gICAgICAgIHVuZGVyIHNlcnZpY2VzW3NlcnZpY2VOYW1lXS4gTXVzdCBpbmNsdWRlIGFuIFwiaWRcIiBmaWVsZFxuICAvLyAgICAgICAgd2hpY2ggaXMgYSB1bmlxdWUgaWRlbnRpZmllciBmb3IgdGhlIHVzZXIgaW4gdGhlIHNlcnZpY2UuXG4gIC8vIEBwYXJhbSBvcHRpb25zIHtPYmplY3QsIG9wdGlvbmFsfSBPdGhlciBvcHRpb25zIHRvIHBhc3MgdG8gaW5zZXJ0VXNlckRvY1xuICAvLyAgICAgICAgKGVnLCBwcm9maWxlKVxuICAvLyBAcmV0dXJucyB7T2JqZWN0fSBPYmplY3Qgd2l0aCB0b2tlbiBhbmQgaWQga2V5cywgbGlrZSB0aGUgcmVzdWx0XG4gIC8vICAgICAgICBvZiB0aGUgXCJsb2dpblwiIG1ldGhvZC5cbiAgLy9cbiAgdXBkYXRlT3JDcmVhdGVVc2VyRnJvbUV4dGVybmFsU2VydmljZShcbiAgICBzZXJ2aWNlTmFtZSxcbiAgICBzZXJ2aWNlRGF0YSxcbiAgICBvcHRpb25zXG4gICkge1xuICAgIG9wdGlvbnMgPSB7IC4uLm9wdGlvbnMgfTtcblxuICAgIGlmIChzZXJ2aWNlTmFtZSA9PT0gXCJwYXNzd29yZFwiIHx8IHNlcnZpY2VOYW1lID09PSBcInJlc3VtZVwiKSB7XG4gICAgICB0aHJvdyBuZXcgRXJyb3IoXG4gICAgICAgIFwiQ2FuJ3QgdXNlIHVwZGF0ZU9yQ3JlYXRlVXNlckZyb21FeHRlcm5hbFNlcnZpY2Ugd2l0aCBpbnRlcm5hbCBzZXJ2aWNlIFwiXG4gICAgICAgICsgc2VydmljZU5hbWUpO1xuICAgIH1cbiAgICBpZiAoIWhhc093bi5jYWxsKHNlcnZpY2VEYXRhLCAnaWQnKSkge1xuICAgICAgdGhyb3cgbmV3IEVycm9yKFxuICAgICAgICBgU2VydmljZSBkYXRhIGZvciBzZXJ2aWNlICR7c2VydmljZU5hbWV9IG11c3QgaW5jbHVkZSBpZGApO1xuICAgIH1cblxuICAgIC8vIExvb2sgZm9yIGEgdXNlciB3aXRoIHRoZSBhcHByb3ByaWF0ZSBzZXJ2aWNlIHVzZXIgaWQuXG4gICAgY29uc3Qgc2VsZWN0b3IgPSB7fTtcbiAgICBjb25zdCBzZXJ2aWNlSWRLZXkgPSBgc2VydmljZXMuJHtzZXJ2aWNlTmFtZX0uaWRgO1xuXG4gICAgLy8gWFhYIFRlbXBvcmFyeSBzcGVjaWFsIGNhc2UgZm9yIFR3aXR0ZXIuIChJc3N1ZSAjNjI5KVxuICAgIC8vICAgVGhlIHNlcnZpY2VEYXRhLmlkIHdpbGwgYmUgYSBzdHJpbmcgcmVwcmVzZW50YXRpb24gb2YgYW4gaW50ZWdlci5cbiAgICAvLyAgIFdlIHdhbnQgaXQgdG8gbWF0Y2ggZWl0aGVyIGEgc3RvcmVkIHN0cmluZyBvciBpbnQgcmVwcmVzZW50YXRpb24uXG4gICAgLy8gICBUaGlzIGlzIHRvIGNhdGVyIHRvIGVhcmxpZXIgdmVyc2lvbnMgb2YgTWV0ZW9yIHN0b3JpbmcgdHdpdHRlclxuICAgIC8vICAgdXNlciBJRHMgaW4gbnVtYmVyIGZvcm0sIGFuZCByZWNlbnQgdmVyc2lvbnMgc3RvcmluZyB0aGVtIGFzIHN0cmluZ3MuXG4gICAgLy8gICBUaGlzIGNhbiBiZSByZW1vdmVkIG9uY2UgbWlncmF0aW9uIHRlY2hub2xvZ3kgaXMgaW4gcGxhY2UsIGFuZCB0d2l0dGVyXG4gICAgLy8gICB1c2VycyBzdG9yZWQgd2l0aCBpbnRlZ2VyIElEcyBoYXZlIGJlZW4gbWlncmF0ZWQgdG8gc3RyaW5nIElEcy5cbiAgICBpZiAoc2VydmljZU5hbWUgPT09IFwidHdpdHRlclwiICYmICFpc05hTihzZXJ2aWNlRGF0YS5pZCkpIHtcbiAgICAgIHNlbGVjdG9yW1wiJG9yXCJdID0gW3t9LHt9XTtcbiAgICAgIHNlbGVjdG9yW1wiJG9yXCJdWzBdW3NlcnZpY2VJZEtleV0gPSBzZXJ2aWNlRGF0YS5pZDtcbiAgICAgIHNlbGVjdG9yW1wiJG9yXCJdWzFdW3NlcnZpY2VJZEtleV0gPSBwYXJzZUludChzZXJ2aWNlRGF0YS5pZCwgMTApO1xuICAgIH0gZWxzZSB7XG4gICAgICBzZWxlY3RvcltzZXJ2aWNlSWRLZXldID0gc2VydmljZURhdGEuaWQ7XG4gICAgfVxuXG4gICAgbGV0IHVzZXIgPSB0aGlzLnVzZXJzLmZpbmRPbmUoc2VsZWN0b3IsIHtmaWVsZHM6IHRoaXMuX29wdGlvbnMuZGVmYXVsdEZpZWxkU2VsZWN0b3J9KTtcblxuICAgIC8vIENoZWNrIHRvIHNlZSBpZiB0aGUgZGV2ZWxvcGVyIGhhcyBhIGN1c3RvbSB3YXkgdG8gZmluZCB0aGUgdXNlciBvdXRzaWRlXG4gICAgLy8gb2YgdGhlIGdlbmVyYWwgc2VsZWN0b3JzIGFib3ZlLlxuICAgIGlmICghdXNlciAmJiB0aGlzLl9hZGRpdGlvbmFsRmluZFVzZXJPbkV4dGVybmFsTG9naW4pIHtcbiAgICAgIHVzZXIgPSB0aGlzLl9hZGRpdGlvbmFsRmluZFVzZXJPbkV4dGVybmFsTG9naW4oe3NlcnZpY2VOYW1lLCBzZXJ2aWNlRGF0YSwgb3B0aW9uc30pXG4gICAgfVxuXG4gICAgLy8gQmVmb3JlIGNvbnRpbnVpbmcsIHJ1biB1c2VyIGhvb2sgdG8gc2VlIGlmIHdlIHNob3VsZCBjb250aW51ZVxuICAgIGlmICh0aGlzLl9iZWZvcmVFeHRlcm5hbExvZ2luSG9vayAmJiAhdGhpcy5fYmVmb3JlRXh0ZXJuYWxMb2dpbkhvb2soc2VydmljZU5hbWUsIHNlcnZpY2VEYXRhLCB1c2VyKSkge1xuICAgICAgdGhyb3cgbmV3IE1ldGVvci5FcnJvcig0MDMsIFwiTG9naW4gZm9yYmlkZGVuXCIpO1xuICAgIH1cblxuICAgIC8vIFdoZW4gY3JlYXRpbmcgYSBuZXcgdXNlciB3ZSBwYXNzIHRocm91Z2ggYWxsIG9wdGlvbnMuIFdoZW4gdXBkYXRpbmcgYW5cbiAgICAvLyBleGlzdGluZyB1c2VyLCBieSBkZWZhdWx0IHdlIG9ubHkgcHJvY2Vzcy9wYXNzIHRocm91Z2ggdGhlIHNlcnZpY2VEYXRhXG4gICAgLy8gKGVnLCBzbyB0aGF0IHdlIGtlZXAgYW4gdW5leHBpcmVkIGFjY2VzcyB0b2tlbiBhbmQgZG9uJ3QgY2FjaGUgb2xkIGVtYWlsXG4gICAgLy8gYWRkcmVzc2VzIGluIHNlcnZpY2VEYXRhLmVtYWlsKS4gVGhlIG9uRXh0ZXJuYWxMb2dpbiBob29rIGNhbiBiZSB1c2VkIHdoZW5cbiAgICAvLyBjcmVhdGluZyBvciB1cGRhdGluZyBhIHVzZXIsIHRvIG1vZGlmeSBvciBwYXNzIHRocm91Z2ggbW9yZSBvcHRpb25zIGFzXG4gICAgLy8gbmVlZGVkLlxuICAgIGxldCBvcHRzID0gdXNlciA/IHt9IDogb3B0aW9ucztcbiAgICBpZiAodGhpcy5fb25FeHRlcm5hbExvZ2luSG9vaykge1xuICAgICAgb3B0cyA9IHRoaXMuX29uRXh0ZXJuYWxMb2dpbkhvb2sob3B0aW9ucywgdXNlcik7XG4gICAgfVxuXG4gICAgaWYgKHVzZXIpIHtcbiAgICAgIHBpbkVuY3J5cHRlZEZpZWxkc1RvVXNlcihzZXJ2aWNlRGF0YSwgdXNlci5faWQpO1xuXG4gICAgICBsZXQgc2V0QXR0cnMgPSB7fTtcbiAgICAgIE9iamVjdC5rZXlzKHNlcnZpY2VEYXRhKS5mb3JFYWNoKGtleSA9PlxuICAgICAgICBzZXRBdHRyc1tgc2VydmljZXMuJHtzZXJ2aWNlTmFtZX0uJHtrZXl9YF0gPSBzZXJ2aWNlRGF0YVtrZXldXG4gICAgICApO1xuXG4gICAgICAvLyBYWFggTWF5YmUgd2Ugc2hvdWxkIHJlLXVzZSB0aGUgc2VsZWN0b3IgYWJvdmUgYW5kIG5vdGljZSBpZiB0aGUgdXBkYXRlXG4gICAgICAvLyAgICAgdG91Y2hlcyBub3RoaW5nP1xuICAgICAgc2V0QXR0cnMgPSB7IC4uLnNldEF0dHJzLCAuLi5vcHRzIH07XG4gICAgICB0aGlzLnVzZXJzLnVwZGF0ZSh1c2VyLl9pZCwge1xuICAgICAgICAkc2V0OiBzZXRBdHRyc1xuICAgICAgfSk7XG5cbiAgICAgIHJldHVybiB7XG4gICAgICAgIHR5cGU6IHNlcnZpY2VOYW1lLFxuICAgICAgICB1c2VySWQ6IHVzZXIuX2lkXG4gICAgICB9O1xuICAgIH0gZWxzZSB7XG4gICAgICAvLyBDcmVhdGUgYSBuZXcgdXNlciB3aXRoIHRoZSBzZXJ2aWNlIGRhdGEuXG4gICAgICB1c2VyID0ge3NlcnZpY2VzOiB7fX07XG4gICAgICB1c2VyLnNlcnZpY2VzW3NlcnZpY2VOYW1lXSA9IHNlcnZpY2VEYXRhO1xuICAgICAgcmV0dXJuIHtcbiAgICAgICAgdHlwZTogc2VydmljZU5hbWUsXG4gICAgICAgIHVzZXJJZDogdGhpcy5pbnNlcnRVc2VyRG9jKG9wdHMsIHVzZXIpXG4gICAgICB9O1xuICAgIH1cbiAgfTtcblxuICAvLyBSZW1vdmVzIGRlZmF1bHQgcmF0ZSBsaW1pdGluZyBydWxlXG4gIHJlbW92ZURlZmF1bHRSYXRlTGltaXQoKSB7XG4gICAgY29uc3QgcmVzcCA9IEREUFJhdGVMaW1pdGVyLnJlbW92ZVJ1bGUodGhpcy5kZWZhdWx0UmF0ZUxpbWl0ZXJSdWxlSWQpO1xuICAgIHRoaXMuZGVmYXVsdFJhdGVMaW1pdGVyUnVsZUlkID0gbnVsbDtcbiAgICByZXR1cm4gcmVzcDtcbiAgfTtcblxuICAvLyBBZGQgYSBkZWZhdWx0IHJ1bGUgb2YgbGltaXRpbmcgbG9naW5zLCBjcmVhdGluZyBuZXcgdXNlcnMgYW5kIHBhc3N3b3JkIHJlc2V0XG4gIC8vIHRvIDUgdGltZXMgZXZlcnkgMTAgc2Vjb25kcyBwZXIgY29ubmVjdGlvbi5cbiAgYWRkRGVmYXVsdFJhdGVMaW1pdCgpIHtcbiAgICBpZiAoIXRoaXMuZGVmYXVsdFJhdGVMaW1pdGVyUnVsZUlkKSB7XG4gICAgICB0aGlzLmRlZmF1bHRSYXRlTGltaXRlclJ1bGVJZCA9IEREUFJhdGVMaW1pdGVyLmFkZFJ1bGUoe1xuICAgICAgICB1c2VySWQ6IG51bGwsXG4gICAgICAgIGNsaWVudEFkZHJlc3M6IG51bGwsXG4gICAgICAgIHR5cGU6ICdtZXRob2QnLFxuICAgICAgICBuYW1lOiBuYW1lID0+IFsnbG9naW4nLCAnY3JlYXRlVXNlcicsICdyZXNldFBhc3N3b3JkJywgJ2ZvcmdvdFBhc3N3b3JkJ11cbiAgICAgICAgICAuaW5jbHVkZXMobmFtZSksXG4gICAgICAgIGNvbm5lY3Rpb25JZDogKGNvbm5lY3Rpb25JZCkgPT4gdHJ1ZSxcbiAgICAgIH0sIDUsIDEwMDAwKTtcbiAgICB9XG4gIH07XG5cbiAgLyoqXG4gICAqIEBzdW1tYXJ5IENyZWF0ZXMgb3B0aW9ucyBmb3IgZW1haWwgc2VuZGluZyBmb3IgcmVzZXQgcGFzc3dvcmQgYW5kIGVucm9sbCBhY2NvdW50IGVtYWlscy5cbiAgICogWW91IGNhbiB1c2UgdGhpcyBmdW5jdGlvbiB3aGVuIGN1c3RvbWl6aW5nIGEgcmVzZXQgcGFzc3dvcmQgb3IgZW5yb2xsIGFjY291bnQgZW1haWwgc2VuZGluZy5cbiAgICogQGxvY3VzIFNlcnZlclxuICAgKiBAcGFyYW0ge09iamVjdH0gZW1haWwgV2hpY2ggYWRkcmVzcyBvZiB0aGUgdXNlcidzIHRvIHNlbmQgdGhlIGVtYWlsIHRvLlxuICAgKiBAcGFyYW0ge09iamVjdH0gdXNlciBUaGUgdXNlciBvYmplY3QgdG8gZ2VuZXJhdGUgb3B0aW9ucyBmb3IuXG4gICAqIEBwYXJhbSB7U3RyaW5nfSB1cmwgVVJMIHRvIHdoaWNoIHVzZXIgaXMgZGlyZWN0ZWQgdG8gY29uZmlybSB0aGUgZW1haWwuXG4gICAqIEBwYXJhbSB7U3RyaW5nfSByZWFzb24gYHJlc2V0UGFzc3dvcmRgIG9yIGBlbnJvbGxBY2NvdW50YC5cbiAgICogQHJldHVybnMge09iamVjdH0gT3B0aW9ucyB3aGljaCBjYW4gYmUgcGFzc2VkIHRvIGBFbWFpbC5zZW5kYC5cbiAgICogQGltcG9ydEZyb21QYWNrYWdlIGFjY291bnRzLWJhc2VcbiAgICovXG4gIGdlbmVyYXRlT3B0aW9uc0ZvckVtYWlsKGVtYWlsLCB1c2VyLCB1cmwsIHJlYXNvbiwgZXh0cmEgPSB7fSl7XG4gICAgY29uc3Qgb3B0aW9ucyA9IHtcbiAgICAgIHRvOiBlbWFpbCxcbiAgICAgIGZyb206IHRoaXMuZW1haWxUZW1wbGF0ZXNbcmVhc29uXS5mcm9tXG4gICAgICAgID8gdGhpcy5lbWFpbFRlbXBsYXRlc1tyZWFzb25dLmZyb20odXNlcilcbiAgICAgICAgOiB0aGlzLmVtYWlsVGVtcGxhdGVzLmZyb20sXG4gICAgICBzdWJqZWN0OiB0aGlzLmVtYWlsVGVtcGxhdGVzW3JlYXNvbl0uc3ViamVjdCh1c2VyLCB1cmwsIGV4dHJhKSxcbiAgICB9O1xuXG4gICAgaWYgKHR5cGVvZiB0aGlzLmVtYWlsVGVtcGxhdGVzW3JlYXNvbl0udGV4dCA9PT0gJ2Z1bmN0aW9uJykge1xuICAgICAgb3B0aW9ucy50ZXh0ID0gdGhpcy5lbWFpbFRlbXBsYXRlc1tyZWFzb25dLnRleHQodXNlciwgdXJsLCBleHRyYSk7XG4gICAgfVxuXG4gICAgaWYgKHR5cGVvZiB0aGlzLmVtYWlsVGVtcGxhdGVzW3JlYXNvbl0uaHRtbCA9PT0gJ2Z1bmN0aW9uJykge1xuICAgICAgb3B0aW9ucy5odG1sID0gdGhpcy5lbWFpbFRlbXBsYXRlc1tyZWFzb25dLmh0bWwodXNlciwgdXJsLCBleHRyYSk7XG4gICAgfVxuXG4gICAgaWYgKHR5cGVvZiB0aGlzLmVtYWlsVGVtcGxhdGVzLmhlYWRlcnMgPT09ICdvYmplY3QnKSB7XG4gICAgICBvcHRpb25zLmhlYWRlcnMgPSB0aGlzLmVtYWlsVGVtcGxhdGVzLmhlYWRlcnM7XG4gICAgfVxuXG4gICAgcmV0dXJuIG9wdGlvbnM7XG4gIH07XG5cbiAgX2NoZWNrRm9yQ2FzZUluc2Vuc2l0aXZlRHVwbGljYXRlcyhcbiAgICBmaWVsZE5hbWUsXG4gICAgZGlzcGxheU5hbWUsXG4gICAgZmllbGRWYWx1ZSxcbiAgICBvd25Vc2VySWRcbiAgKSB7XG4gICAgLy8gU29tZSB0ZXN0cyBuZWVkIHRoZSBhYmlsaXR5IHRvIGFkZCB1c2VycyB3aXRoIHRoZSBzYW1lIGNhc2UgaW5zZW5zaXRpdmVcbiAgICAvLyB2YWx1ZSwgaGVuY2UgdGhlIF9za2lwQ2FzZUluc2Vuc2l0aXZlQ2hlY2tzRm9yVGVzdCBjaGVja1xuICAgIGNvbnN0IHNraXBDaGVjayA9IE9iamVjdC5wcm90b3R5cGUuaGFzT3duUHJvcGVydHkuY2FsbChcbiAgICAgIHRoaXMuX3NraXBDYXNlSW5zZW5zaXRpdmVDaGVja3NGb3JUZXN0LFxuICAgICAgZmllbGRWYWx1ZVxuICAgICk7XG5cbiAgICBpZiAoZmllbGRWYWx1ZSAmJiAhc2tpcENoZWNrKSB7XG4gICAgICBjb25zdCBtYXRjaGVkVXNlcnMgPSBNZXRlb3IudXNlcnNcbiAgICAgICAgLmZpbmQoXG4gICAgICAgICAgdGhpcy5fc2VsZWN0b3JGb3JGYXN0Q2FzZUluc2Vuc2l0aXZlTG9va3VwKGZpZWxkTmFtZSwgZmllbGRWYWx1ZSksXG4gICAgICAgICAge1xuICAgICAgICAgICAgZmllbGRzOiB7IF9pZDogMSB9LFxuICAgICAgICAgICAgLy8gd2Ugb25seSBuZWVkIGEgbWF4aW11bSBvZiAyIHVzZXJzIGZvciB0aGUgbG9naWMgYmVsb3cgdG8gd29ya1xuICAgICAgICAgICAgbGltaXQ6IDIsXG4gICAgICAgICAgfVxuICAgICAgICApXG4gICAgICAgIC5mZXRjaCgpO1xuXG4gICAgICBpZiAoXG4gICAgICAgIG1hdGNoZWRVc2Vycy5sZW5ndGggPiAwICYmXG4gICAgICAgIC8vIElmIHdlIGRvbid0IGhhdmUgYSB1c2VySWQgeWV0LCBhbnkgbWF0Y2ggd2UgZmluZCBpcyBhIGR1cGxpY2F0ZVxuICAgICAgICAoIW93blVzZXJJZCB8fFxuICAgICAgICAgIC8vIE90aGVyd2lzZSwgY2hlY2sgdG8gc2VlIGlmIHRoZXJlIGFyZSBtdWx0aXBsZSBtYXRjaGVzIG9yIGEgbWF0Y2hcbiAgICAgICAgICAvLyB0aGF0IGlzIG5vdCB1c1xuICAgICAgICAgIG1hdGNoZWRVc2Vycy5sZW5ndGggPiAxIHx8IG1hdGNoZWRVc2Vyc1swXS5faWQgIT09IG93blVzZXJJZClcbiAgICAgICkge1xuICAgICAgICB0aGlzLl9oYW5kbGVFcnJvcihgJHtkaXNwbGF5TmFtZX0gYWxyZWFkeSBleGlzdHMuYCk7XG4gICAgICB9XG4gICAgfVxuICB9O1xuXG4gIF9jcmVhdGVVc2VyQ2hlY2tpbmdEdXBsaWNhdGVzKHsgdXNlciwgZW1haWwsIHVzZXJuYW1lLCBvcHRpb25zIH0pIHtcbiAgICBjb25zdCBuZXdVc2VyID0ge1xuICAgICAgLi4udXNlcixcbiAgICAgIC4uLih1c2VybmFtZSA/IHsgdXNlcm5hbWUgfSA6IHt9KSxcbiAgICAgIC4uLihlbWFpbCA/IHsgZW1haWxzOiBbeyBhZGRyZXNzOiBlbWFpbCwgdmVyaWZpZWQ6IGZhbHNlIH1dIH0gOiB7fSksXG4gICAgfTtcblxuICAgIC8vIFBlcmZvcm0gYSBjYXNlIGluc2Vuc2l0aXZlIGNoZWNrIGJlZm9yZSBpbnNlcnRcbiAgICB0aGlzLl9jaGVja0ZvckNhc2VJbnNlbnNpdGl2ZUR1cGxpY2F0ZXMoJ3VzZXJuYW1lJywgJ1VzZXJuYW1lJywgdXNlcm5hbWUpO1xuICAgIHRoaXMuX2NoZWNrRm9yQ2FzZUluc2Vuc2l0aXZlRHVwbGljYXRlcygnZW1haWxzLmFkZHJlc3MnLCAnRW1haWwnLCBlbWFpbCk7XG5cbiAgICBjb25zdCB1c2VySWQgPSB0aGlzLmluc2VydFVzZXJEb2Mob3B0aW9ucywgbmV3VXNlcik7XG4gICAgLy8gUGVyZm9ybSBhbm90aGVyIGNoZWNrIGFmdGVyIGluc2VydCwgaW4gY2FzZSBhIG1hdGNoaW5nIHVzZXIgaGFzIGJlZW5cbiAgICAvLyBpbnNlcnRlZCBpbiB0aGUgbWVhbnRpbWVcbiAgICB0cnkge1xuICAgICAgdGhpcy5fY2hlY2tGb3JDYXNlSW5zZW5zaXRpdmVEdXBsaWNhdGVzKCd1c2VybmFtZScsICdVc2VybmFtZScsIHVzZXJuYW1lLCB1c2VySWQpO1xuICAgICAgdGhpcy5fY2hlY2tGb3JDYXNlSW5zZW5zaXRpdmVEdXBsaWNhdGVzKCdlbWFpbHMuYWRkcmVzcycsICdFbWFpbCcsIGVtYWlsLCB1c2VySWQpO1xuICAgIH0gY2F0Y2ggKGV4KSB7XG4gICAgICAvLyBSZW1vdmUgaW5zZXJ0ZWQgdXNlciBpZiB0aGUgY2hlY2sgZmFpbHNcbiAgICAgIE1ldGVvci51c2Vycy5yZW1vdmUodXNlcklkKTtcbiAgICAgIHRocm93IGV4O1xuICAgIH1cbiAgICByZXR1cm4gdXNlcklkO1xuICB9XG5cbiAgX2hhbmRsZUVycm9yID0gKG1zZywgdGhyb3dFcnJvciA9IHRydWUsIGVycm9yQ29kZSA9IDQwMykgPT4ge1xuICAgIGNvbnN0IGVycm9yID0gbmV3IE1ldGVvci5FcnJvcihcbiAgICAgIGVycm9yQ29kZSxcbiAgICAgIHRoaXMuX29wdGlvbnMuYW1iaWd1b3VzRXJyb3JNZXNzYWdlc1xuICAgICAgICA/IFwiU29tZXRoaW5nIHdlbnQgd3JvbmcuIFBsZWFzZSBjaGVjayB5b3VyIGNyZWRlbnRpYWxzLlwiXG4gICAgICAgIDogbXNnXG4gICAgKTtcbiAgICBpZiAodGhyb3dFcnJvcikge1xuICAgICAgdGhyb3cgZXJyb3I7XG4gICAgfVxuICAgIHJldHVybiBlcnJvcjtcbiAgfVxuXG4gIF91c2VyUXVlcnlWYWxpZGF0b3IgPSBNYXRjaC5XaGVyZSh1c2VyID0+IHtcbiAgICBjaGVjayh1c2VyLCB7XG4gICAgICBpZDogTWF0Y2guT3B0aW9uYWwoTm9uRW1wdHlTdHJpbmcpLFxuICAgICAgdXNlcm5hbWU6IE1hdGNoLk9wdGlvbmFsKE5vbkVtcHR5U3RyaW5nKSxcbiAgICAgIGVtYWlsOiBNYXRjaC5PcHRpb25hbChOb25FbXB0eVN0cmluZylcbiAgICB9KTtcbiAgICBpZiAoT2JqZWN0LmtleXModXNlcikubGVuZ3RoICE9PSAxKVxuICAgICAgdGhyb3cgbmV3IE1hdGNoLkVycm9yKFwiVXNlciBwcm9wZXJ0eSBtdXN0IGhhdmUgZXhhY3RseSBvbmUgZmllbGRcIik7XG4gICAgcmV0dXJuIHRydWU7XG4gIH0pO1xuXG59XG5cbi8vIEdpdmUgZWFjaCBsb2dpbiBob29rIGNhbGxiYWNrIGEgZnJlc2ggY2xvbmVkIGNvcHkgb2YgdGhlIGF0dGVtcHRcbi8vIG9iamVjdCwgYnV0IGRvbid0IGNsb25lIHRoZSBjb25uZWN0aW9uLlxuLy9cbmNvbnN0IGNsb25lQXR0ZW1wdFdpdGhDb25uZWN0aW9uID0gKGNvbm5lY3Rpb24sIGF0dGVtcHQpID0+IHtcbiAgY29uc3QgY2xvbmVkQXR0ZW1wdCA9IEVKU09OLmNsb25lKGF0dGVtcHQpO1xuICBjbG9uZWRBdHRlbXB0LmNvbm5lY3Rpb24gPSBjb25uZWN0aW9uO1xuICByZXR1cm4gY2xvbmVkQXR0ZW1wdDtcbn07XG5cbmNvbnN0IHRyeUxvZ2luTWV0aG9kID0gKHR5cGUsIGZuKSA9PiB7XG4gIGxldCByZXN1bHQ7XG4gIHRyeSB7XG4gICAgcmVzdWx0ID0gZm4oKTtcbiAgfVxuICBjYXRjaCAoZSkge1xuICAgIHJlc3VsdCA9IHtlcnJvcjogZX07XG4gIH1cblxuICBpZiAocmVzdWx0ICYmICFyZXN1bHQudHlwZSAmJiB0eXBlKVxuICAgIHJlc3VsdC50eXBlID0gdHlwZTtcblxuICByZXR1cm4gcmVzdWx0O1xufTtcblxuY29uc3Qgc2V0dXBEZWZhdWx0TG9naW5IYW5kbGVycyA9IGFjY291bnRzID0+IHtcbiAgYWNjb3VudHMucmVnaXN0ZXJMb2dpbkhhbmRsZXIoXCJyZXN1bWVcIiwgZnVuY3Rpb24gKG9wdGlvbnMpIHtcbiAgICByZXR1cm4gZGVmYXVsdFJlc3VtZUxvZ2luSGFuZGxlci5jYWxsKHRoaXMsIGFjY291bnRzLCBvcHRpb25zKTtcbiAgfSk7XG59O1xuXG4vLyBMb2dpbiBoYW5kbGVyIGZvciByZXN1bWUgdG9rZW5zLlxuY29uc3QgZGVmYXVsdFJlc3VtZUxvZ2luSGFuZGxlciA9IChhY2NvdW50cywgb3B0aW9ucykgPT4ge1xuICBpZiAoIW9wdGlvbnMucmVzdW1lKVxuICAgIHJldHVybiB1bmRlZmluZWQ7XG5cbiAgY2hlY2sob3B0aW9ucy5yZXN1bWUsIFN0cmluZyk7XG5cbiAgY29uc3QgaGFzaGVkVG9rZW4gPSBhY2NvdW50cy5faGFzaExvZ2luVG9rZW4ob3B0aW9ucy5yZXN1bWUpO1xuXG4gIC8vIEZpcnN0IGxvb2sgZm9yIGp1c3QgdGhlIG5ldy1zdHlsZSBoYXNoZWQgbG9naW4gdG9rZW4sIHRvIGF2b2lkXG4gIC8vIHNlbmRpbmcgdGhlIHVuaGFzaGVkIHRva2VuIHRvIHRoZSBkYXRhYmFzZSBpbiBhIHF1ZXJ5IGlmIHdlIGRvbid0XG4gIC8vIG5lZWQgdG8uXG4gIGxldCB1c2VyID0gYWNjb3VudHMudXNlcnMuZmluZE9uZShcbiAgICB7XCJzZXJ2aWNlcy5yZXN1bWUubG9naW5Ub2tlbnMuaGFzaGVkVG9rZW5cIjogaGFzaGVkVG9rZW59LFxuICAgIHtmaWVsZHM6IHtcInNlcnZpY2VzLnJlc3VtZS5sb2dpblRva2Vucy4kXCI6IDF9fSk7XG5cbiAgaWYgKCEgdXNlcikge1xuICAgIC8vIElmIHdlIGRpZG4ndCBmaW5kIHRoZSBoYXNoZWQgbG9naW4gdG9rZW4sIHRyeSBhbHNvIGxvb2tpbmcgZm9yXG4gICAgLy8gdGhlIG9sZC1zdHlsZSB1bmhhc2hlZCB0b2tlbi4gIEJ1dCB3ZSBuZWVkIHRvIGxvb2sgZm9yIGVpdGhlclxuICAgIC8vIHRoZSBvbGQtc3R5bGUgdG9rZW4gT1IgdGhlIG5ldy1zdHlsZSB0b2tlbiwgYmVjYXVzZSBhbm90aGVyXG4gICAgLy8gY2xpZW50IGNvbm5lY3Rpb24gbG9nZ2luZyBpbiBzaW11bHRhbmVvdXNseSBtaWdodCBoYXZlIGFscmVhZHlcbiAgICAvLyBjb252ZXJ0ZWQgdGhlIHRva2VuLlxuICAgIHVzZXIgPSBhY2NvdW50cy51c2Vycy5maW5kT25lKHtcbiAgICAgICAgJG9yOiBbXG4gICAgICAgICAge1wic2VydmljZXMucmVzdW1lLmxvZ2luVG9rZW5zLmhhc2hlZFRva2VuXCI6IGhhc2hlZFRva2VufSxcbiAgICAgICAgICB7XCJzZXJ2aWNlcy5yZXN1bWUubG9naW5Ub2tlbnMudG9rZW5cIjogb3B0aW9ucy5yZXN1bWV9XG4gICAgICAgIF1cbiAgICAgIH0sXG4gICAgICAvLyBOb3RlOiBDYW5ub3QgdXNlIC4uLmxvZ2luVG9rZW5zLiQgcG9zaXRpb25hbCBvcGVyYXRvciB3aXRoICRvciBxdWVyeS5cbiAgICAgIHtmaWVsZHM6IHtcInNlcnZpY2VzLnJlc3VtZS5sb2dpblRva2Vuc1wiOiAxfX0pO1xuICB9XG5cbiAgaWYgKCEgdXNlcilcbiAgICByZXR1cm4ge1xuICAgICAgZXJyb3I6IG5ldyBNZXRlb3IuRXJyb3IoNDAzLCBcIllvdSd2ZSBiZWVuIGxvZ2dlZCBvdXQgYnkgdGhlIHNlcnZlci4gUGxlYXNlIGxvZyBpbiBhZ2Fpbi5cIilcbiAgICB9O1xuXG4gIC8vIEZpbmQgdGhlIHRva2VuLCB3aGljaCB3aWxsIGVpdGhlciBiZSBhbiBvYmplY3Qgd2l0aCBmaWVsZHNcbiAgLy8ge2hhc2hlZFRva2VuLCB3aGVufSBmb3IgYSBoYXNoZWQgdG9rZW4gb3Ige3Rva2VuLCB3aGVufSBmb3IgYW5cbiAgLy8gdW5oYXNoZWQgdG9rZW4uXG4gIGxldCBvbGRVbmhhc2hlZFN0eWxlVG9rZW47XG4gIGxldCB0b2tlbiA9IHVzZXIuc2VydmljZXMucmVzdW1lLmxvZ2luVG9rZW5zLmZpbmQodG9rZW4gPT5cbiAgICB0b2tlbi5oYXNoZWRUb2tlbiA9PT0gaGFzaGVkVG9rZW5cbiAgKTtcbiAgaWYgKHRva2VuKSB7XG4gICAgb2xkVW5oYXNoZWRTdHlsZVRva2VuID0gZmFsc2U7XG4gIH0gZWxzZSB7XG4gICAgdG9rZW4gPSB1c2VyLnNlcnZpY2VzLnJlc3VtZS5sb2dpblRva2Vucy5maW5kKHRva2VuID0+XG4gICAgICB0b2tlbi50b2tlbiA9PT0gb3B0aW9ucy5yZXN1bWVcbiAgICApO1xuICAgIG9sZFVuaGFzaGVkU3R5bGVUb2tlbiA9IHRydWU7XG4gIH1cblxuICBjb25zdCB0b2tlbkV4cGlyZXMgPSBhY2NvdW50cy5fdG9rZW5FeHBpcmF0aW9uKHRva2VuLndoZW4pO1xuICBpZiAobmV3IERhdGUoKSA+PSB0b2tlbkV4cGlyZXMpXG4gICAgcmV0dXJuIHtcbiAgICAgIHVzZXJJZDogdXNlci5faWQsXG4gICAgICBlcnJvcjogbmV3IE1ldGVvci5FcnJvcig0MDMsIFwiWW91ciBzZXNzaW9uIGhhcyBleHBpcmVkLiBQbGVhc2UgbG9nIGluIGFnYWluLlwiKVxuICAgIH07XG5cbiAgLy8gVXBkYXRlIHRvIGEgaGFzaGVkIHRva2VuIHdoZW4gYW4gdW5oYXNoZWQgdG9rZW4gaXMgZW5jb3VudGVyZWQuXG4gIGlmIChvbGRVbmhhc2hlZFN0eWxlVG9rZW4pIHtcbiAgICAvLyBPbmx5IGFkZCB0aGUgbmV3IGhhc2hlZCB0b2tlbiBpZiB0aGUgb2xkIHVuaGFzaGVkIHRva2VuIHN0aWxsXG4gICAgLy8gZXhpc3RzICh0aGlzIGF2b2lkcyByZXN1cnJlY3RpbmcgdGhlIHRva2VuIGlmIGl0IHdhcyBkZWxldGVkXG4gICAgLy8gYWZ0ZXIgd2UgcmVhZCBpdCkuICBVc2luZyAkYWRkVG9TZXQgYXZvaWRzIGdldHRpbmcgYW4gaW5kZXhcbiAgICAvLyBlcnJvciBpZiBhbm90aGVyIGNsaWVudCBsb2dnaW5nIGluIHNpbXVsdGFuZW91c2x5IGhhcyBhbHJlYWR5XG4gICAgLy8gaW5zZXJ0ZWQgdGhlIG5ldyBoYXNoZWQgdG9rZW4uXG4gICAgYWNjb3VudHMudXNlcnMudXBkYXRlKFxuICAgICAge1xuICAgICAgICBfaWQ6IHVzZXIuX2lkLFxuICAgICAgICBcInNlcnZpY2VzLnJlc3VtZS5sb2dpblRva2Vucy50b2tlblwiOiBvcHRpb25zLnJlc3VtZVxuICAgICAgfSxcbiAgICAgIHskYWRkVG9TZXQ6IHtcbiAgICAgICAgICBcInNlcnZpY2VzLnJlc3VtZS5sb2dpblRva2Vuc1wiOiB7XG4gICAgICAgICAgICBcImhhc2hlZFRva2VuXCI6IGhhc2hlZFRva2VuLFxuICAgICAgICAgICAgXCJ3aGVuXCI6IHRva2VuLndoZW5cbiAgICAgICAgICB9XG4gICAgICAgIH19XG4gICAgKTtcblxuICAgIC8vIFJlbW92ZSB0aGUgb2xkIHRva2VuICphZnRlciogYWRkaW5nIHRoZSBuZXcsIHNpbmNlIG90aGVyd2lzZVxuICAgIC8vIGFub3RoZXIgY2xpZW50IHRyeWluZyB0byBsb2dpbiBiZXR3ZWVuIG91ciByZW1vdmluZyB0aGUgb2xkIGFuZFxuICAgIC8vIGFkZGluZyB0aGUgbmV3IHdvdWxkbid0IGZpbmQgYSB0b2tlbiB0byBsb2dpbiB3aXRoLlxuICAgIGFjY291bnRzLnVzZXJzLnVwZGF0ZSh1c2VyLl9pZCwge1xuICAgICAgJHB1bGw6IHtcbiAgICAgICAgXCJzZXJ2aWNlcy5yZXN1bWUubG9naW5Ub2tlbnNcIjogeyBcInRva2VuXCI6IG9wdGlvbnMucmVzdW1lIH1cbiAgICAgIH1cbiAgICB9KTtcbiAgfVxuXG4gIHJldHVybiB7XG4gICAgdXNlcklkOiB1c2VyLl9pZCxcbiAgICBzdGFtcGVkTG9naW5Ub2tlbjoge1xuICAgICAgdG9rZW46IG9wdGlvbnMucmVzdW1lLFxuICAgICAgd2hlbjogdG9rZW4ud2hlblxuICAgIH1cbiAgfTtcbn07XG5cbmNvbnN0IGV4cGlyZVBhc3N3b3JkVG9rZW4gPSAoXG4gIGFjY291bnRzLFxuICBvbGRlc3RWYWxpZERhdGUsXG4gIHRva2VuRmlsdGVyLFxuICB1c2VySWRcbikgPT4ge1xuICAvLyBib29sZWFuIHZhbHVlIHVzZWQgdG8gZGV0ZXJtaW5lIGlmIHRoaXMgbWV0aG9kIHdhcyBjYWxsZWQgZnJvbSBlbnJvbGwgYWNjb3VudCB3b3JrZmxvd1xuICBsZXQgaXNFbnJvbGwgPSBmYWxzZTtcbiAgY29uc3QgdXNlckZpbHRlciA9IHVzZXJJZCA/IHtfaWQ6IHVzZXJJZH0gOiB7fTtcbiAgLy8gY2hlY2sgaWYgdGhpcyBtZXRob2Qgd2FzIGNhbGxlZCBmcm9tIGVucm9sbCBhY2NvdW50IHdvcmtmbG93XG4gIGlmKHRva2VuRmlsdGVyWydzZXJ2aWNlcy5wYXNzd29yZC5lbnJvbGwucmVhc29uJ10pIHtcbiAgICBpc0Vucm9sbCA9IHRydWU7XG4gIH1cbiAgbGV0IHJlc2V0UmFuZ2VPciA9IHtcbiAgICAkb3I6IFtcbiAgICAgIHsgXCJzZXJ2aWNlcy5wYXNzd29yZC5yZXNldC53aGVuXCI6IHsgJGx0OiBvbGRlc3RWYWxpZERhdGUgfSB9LFxuICAgICAgeyBcInNlcnZpY2VzLnBhc3N3b3JkLnJlc2V0LndoZW5cIjogeyAkbHQ6ICtvbGRlc3RWYWxpZERhdGUgfSB9XG4gICAgXVxuICB9O1xuICBpZihpc0Vucm9sbCkge1xuICAgIHJlc2V0UmFuZ2VPciA9IHtcbiAgICAgICRvcjogW1xuICAgICAgICB7IFwic2VydmljZXMucGFzc3dvcmQuZW5yb2xsLndoZW5cIjogeyAkbHQ6IG9sZGVzdFZhbGlkRGF0ZSB9IH0sXG4gICAgICAgIHsgXCJzZXJ2aWNlcy5wYXNzd29yZC5lbnJvbGwud2hlblwiOiB7ICRsdDogK29sZGVzdFZhbGlkRGF0ZSB9IH1cbiAgICAgIF1cbiAgICB9O1xuICB9XG4gIGNvbnN0IGV4cGlyZUZpbHRlciA9IHsgJGFuZDogW3Rva2VuRmlsdGVyLCByZXNldFJhbmdlT3JdIH07XG4gIGlmKGlzRW5yb2xsKSB7XG4gICAgYWNjb3VudHMudXNlcnMudXBkYXRlKHsuLi51c2VyRmlsdGVyLCAuLi5leHBpcmVGaWx0ZXJ9LCB7XG4gICAgICAkdW5zZXQ6IHtcbiAgICAgICAgXCJzZXJ2aWNlcy5wYXNzd29yZC5lbnJvbGxcIjogXCJcIlxuICAgICAgfVxuICAgIH0sIHsgbXVsdGk6IHRydWUgfSk7XG4gIH0gZWxzZSB7XG4gICAgYWNjb3VudHMudXNlcnMudXBkYXRlKHsuLi51c2VyRmlsdGVyLCAuLi5leHBpcmVGaWx0ZXJ9LCB7XG4gICAgICAkdW5zZXQ6IHtcbiAgICAgICAgXCJzZXJ2aWNlcy5wYXNzd29yZC5yZXNldFwiOiBcIlwiXG4gICAgICB9XG4gICAgfSwgeyBtdWx0aTogdHJ1ZSB9KTtcbiAgfVxuXG59O1xuXG5jb25zdCBzZXRFeHBpcmVUb2tlbnNJbnRlcnZhbCA9IGFjY291bnRzID0+IHtcbiAgYWNjb3VudHMuZXhwaXJlVG9rZW5JbnRlcnZhbCA9IE1ldGVvci5zZXRJbnRlcnZhbCgoKSA9PiB7XG4gICAgYWNjb3VudHMuX2V4cGlyZVRva2VucygpO1xuICAgIGFjY291bnRzLl9leHBpcmVQYXNzd29yZFJlc2V0VG9rZW5zKCk7XG4gICAgYWNjb3VudHMuX2V4cGlyZVBhc3N3b3JkRW5yb2xsVG9rZW5zKCk7XG4gIH0sIEVYUElSRV9UT0tFTlNfSU5URVJWQUxfTVMpO1xufTtcblxuLy8vXG4vLy8gT0F1dGggRW5jcnlwdGlvbiBTdXBwb3J0XG4vLy9cblxuY29uc3QgT0F1dGhFbmNyeXB0aW9uID1cbiAgUGFja2FnZVtcIm9hdXRoLWVuY3J5cHRpb25cIl0gJiZcbiAgUGFja2FnZVtcIm9hdXRoLWVuY3J5cHRpb25cIl0uT0F1dGhFbmNyeXB0aW9uO1xuXG5jb25zdCB1c2luZ09BdXRoRW5jcnlwdGlvbiA9ICgpID0+IHtcbiAgcmV0dXJuIE9BdXRoRW5jcnlwdGlvbiAmJiBPQXV0aEVuY3J5cHRpb24ua2V5SXNMb2FkZWQoKTtcbn07XG5cbi8vIE9BdXRoIHNlcnZpY2UgZGF0YSBpcyB0ZW1wb3JhcmlseSBzdG9yZWQgaW4gdGhlIHBlbmRpbmcgY3JlZGVudGlhbHNcbi8vIGNvbGxlY3Rpb24gZHVyaW5nIHRoZSBvYXV0aCBhdXRoZW50aWNhdGlvbiBwcm9jZXNzLiAgU2Vuc2l0aXZlIGRhdGFcbi8vIHN1Y2ggYXMgYWNjZXNzIHRva2VucyBhcmUgZW5jcnlwdGVkIHdpdGhvdXQgdGhlIHVzZXIgaWQgYmVjYXVzZVxuLy8gd2UgZG9uJ3Qga25vdyB0aGUgdXNlciBpZCB5ZXQuICBXZSByZS1lbmNyeXB0IHRoZXNlIGZpZWxkcyB3aXRoIHRoZVxuLy8gdXNlciBpZCBpbmNsdWRlZCB3aGVuIHN0b3JpbmcgdGhlIHNlcnZpY2UgZGF0YSBwZXJtYW5lbnRseSBpblxuLy8gdGhlIHVzZXJzIGNvbGxlY3Rpb24uXG4vL1xuY29uc3QgcGluRW5jcnlwdGVkRmllbGRzVG9Vc2VyID0gKHNlcnZpY2VEYXRhLCB1c2VySWQpID0+IHtcbiAgT2JqZWN0LmtleXMoc2VydmljZURhdGEpLmZvckVhY2goa2V5ID0+IHtcbiAgICBsZXQgdmFsdWUgPSBzZXJ2aWNlRGF0YVtrZXldO1xuICAgIGlmIChPQXV0aEVuY3J5cHRpb24gJiYgT0F1dGhFbmNyeXB0aW9uLmlzU2VhbGVkKHZhbHVlKSlcbiAgICAgIHZhbHVlID0gT0F1dGhFbmNyeXB0aW9uLnNlYWwoT0F1dGhFbmNyeXB0aW9uLm9wZW4odmFsdWUpLCB1c2VySWQpO1xuICAgIHNlcnZpY2VEYXRhW2tleV0gPSB2YWx1ZTtcbiAgfSk7XG59O1xuXG5cbi8vIEVuY3J5cHQgdW5lbmNyeXB0ZWQgbG9naW4gc2VydmljZSBzZWNyZXRzIHdoZW4gb2F1dGgtZW5jcnlwdGlvbiBpc1xuLy8gYWRkZWQuXG4vL1xuLy8gWFhYIEZvciB0aGUgb2F1dGhTZWNyZXRLZXkgdG8gYmUgYXZhaWxhYmxlIGhlcmUgYXQgc3RhcnR1cCwgdGhlXG4vLyBkZXZlbG9wZXIgbXVzdCBjYWxsIEFjY291bnRzLmNvbmZpZyh7b2F1dGhTZWNyZXRLZXk6IC4uLn0pIGF0IGxvYWRcbi8vIHRpbWUsIGluc3RlYWQgb2YgaW4gYSBNZXRlb3Iuc3RhcnR1cCBibG9jaywgYmVjYXVzZSB0aGUgc3RhcnR1cFxuLy8gYmxvY2sgaW4gdGhlIGFwcCBjb2RlIHdpbGwgcnVuIGFmdGVyIHRoaXMgYWNjb3VudHMtYmFzZSBzdGFydHVwXG4vLyBibG9jay4gIFBlcmhhcHMgd2UgbmVlZCBhIHBvc3Qtc3RhcnR1cCBjYWxsYmFjaz9cblxuTWV0ZW9yLnN0YXJ0dXAoKCkgPT4ge1xuICBpZiAoISB1c2luZ09BdXRoRW5jcnlwdGlvbigpKSB7XG4gICAgcmV0dXJuO1xuICB9XG5cbiAgY29uc3QgeyBTZXJ2aWNlQ29uZmlndXJhdGlvbiB9ID0gUGFja2FnZVsnc2VydmljZS1jb25maWd1cmF0aW9uJ107XG5cbiAgU2VydmljZUNvbmZpZ3VyYXRpb24uY29uZmlndXJhdGlvbnMuZmluZCh7XG4gICAgJGFuZDogW3tcbiAgICAgIHNlY3JldDogeyAkZXhpc3RzOiB0cnVlIH1cbiAgICB9LCB7XG4gICAgICBcInNlY3JldC5hbGdvcml0aG1cIjogeyAkZXhpc3RzOiBmYWxzZSB9XG4gICAgfV1cbiAgfSkuZm9yRWFjaChjb25maWcgPT4ge1xuICAgIFNlcnZpY2VDb25maWd1cmF0aW9uLmNvbmZpZ3VyYXRpb25zLnVwZGF0ZShjb25maWcuX2lkLCB7XG4gICAgICAkc2V0OiB7XG4gICAgICAgIHNlY3JldDogT0F1dGhFbmNyeXB0aW9uLnNlYWwoY29uZmlnLnNlY3JldClcbiAgICAgIH1cbiAgICB9KTtcbiAgfSk7XG59KTtcblxuLy8gWFhYIHNlZSBjb21tZW50IG9uIEFjY291bnRzLmNyZWF0ZVVzZXIgaW4gcGFzc3dvcmRzX3NlcnZlciBhYm91dCBhZGRpbmcgYVxuLy8gc2Vjb25kIFwic2VydmVyIG9wdGlvbnNcIiBhcmd1bWVudC5cbmNvbnN0IGRlZmF1bHRDcmVhdGVVc2VySG9vayA9IChvcHRpb25zLCB1c2VyKSA9PiB7XG4gIGlmIChvcHRpb25zLnByb2ZpbGUpXG4gICAgdXNlci5wcm9maWxlID0gb3B0aW9ucy5wcm9maWxlO1xuICByZXR1cm4gdXNlcjtcbn07XG5cbi8vIFZhbGlkYXRlIG5ldyB1c2VyJ3MgZW1haWwgb3IgR29vZ2xlL0ZhY2Vib29rL0dpdEh1YiBhY2NvdW50J3MgZW1haWxcbmZ1bmN0aW9uIGRlZmF1bHRWYWxpZGF0ZU5ld1VzZXJIb29rKHVzZXIpIHtcbiAgY29uc3QgZG9tYWluID0gdGhpcy5fb3B0aW9ucy5yZXN0cmljdENyZWF0aW9uQnlFbWFpbERvbWFpbjtcbiAgaWYgKCFkb21haW4pIHtcbiAgICByZXR1cm4gdHJ1ZTtcbiAgfVxuXG4gIGxldCBlbWFpbElzR29vZCA9IGZhbHNlO1xuICBpZiAodXNlci5lbWFpbHMgJiYgdXNlci5lbWFpbHMubGVuZ3RoID4gMCkge1xuICAgIGVtYWlsSXNHb29kID0gdXNlci5lbWFpbHMucmVkdWNlKFxuICAgICAgKHByZXYsIGVtYWlsKSA9PiBwcmV2IHx8IHRoaXMuX3Rlc3RFbWFpbERvbWFpbihlbWFpbC5hZGRyZXNzKSwgZmFsc2VcbiAgICApO1xuICB9IGVsc2UgaWYgKHVzZXIuc2VydmljZXMgJiYgT2JqZWN0LnZhbHVlcyh1c2VyLnNlcnZpY2VzKS5sZW5ndGggPiAwKSB7XG4gICAgLy8gRmluZCBhbnkgZW1haWwgb2YgYW55IHNlcnZpY2UgYW5kIGNoZWNrIGl0XG4gICAgZW1haWxJc0dvb2QgPSBPYmplY3QudmFsdWVzKHVzZXIuc2VydmljZXMpLnJlZHVjZShcbiAgICAgIChwcmV2LCBzZXJ2aWNlKSA9PiBzZXJ2aWNlLmVtYWlsICYmIHRoaXMuX3Rlc3RFbWFpbERvbWFpbihzZXJ2aWNlLmVtYWlsKSxcbiAgICAgIGZhbHNlLFxuICAgICk7XG4gIH1cblxuICBpZiAoZW1haWxJc0dvb2QpIHtcbiAgICByZXR1cm4gdHJ1ZTtcbiAgfVxuXG4gIGlmICh0eXBlb2YgZG9tYWluID09PSAnc3RyaW5nJykge1xuICAgIHRocm93IG5ldyBNZXRlb3IuRXJyb3IoNDAzLCBgQCR7ZG9tYWlufSBlbWFpbCByZXF1aXJlZGApO1xuICB9IGVsc2Uge1xuICAgIHRocm93IG5ldyBNZXRlb3IuRXJyb3IoNDAzLCBcIkVtYWlsIGRvZXNuJ3QgbWF0Y2ggdGhlIGNyaXRlcmlhLlwiKTtcbiAgfVxufVxuXG5jb25zdCBzZXR1cFVzZXJzQ29sbGVjdGlvbiA9IHVzZXJzID0+IHtcbiAgLy8vXG4gIC8vLyBSRVNUUklDVElORyBXUklURVMgVE8gVVNFUiBPQkpFQ1RTXG4gIC8vL1xuICB1c2Vycy5hbGxvdyh7XG4gICAgLy8gY2xpZW50cyBjYW4gbW9kaWZ5IHRoZSBwcm9maWxlIGZpZWxkIG9mIHRoZWlyIG93biBkb2N1bWVudCwgYW5kXG4gICAgLy8gbm90aGluZyBlbHNlLlxuICAgIHVwZGF0ZTogKHVzZXJJZCwgdXNlciwgZmllbGRzLCBtb2RpZmllcikgPT4ge1xuICAgICAgLy8gbWFrZSBzdXJlIGl0IGlzIG91ciByZWNvcmRcbiAgICAgIGlmICh1c2VyLl9pZCAhPT0gdXNlcklkKSB7XG4gICAgICAgIHJldHVybiBmYWxzZTtcbiAgICAgIH1cblxuICAgICAgLy8gdXNlciBjYW4gb25seSBtb2RpZnkgdGhlICdwcm9maWxlJyBmaWVsZC4gc2V0cyB0byBtdWx0aXBsZVxuICAgICAgLy8gc3ViLWtleXMgKGVnIHByb2ZpbGUuZm9vIGFuZCBwcm9maWxlLmJhcikgYXJlIG1lcmdlZCBpbnRvIGVudHJ5XG4gICAgICAvLyBpbiB0aGUgZmllbGRzIGxpc3QuXG4gICAgICBpZiAoZmllbGRzLmxlbmd0aCAhPT0gMSB8fCBmaWVsZHNbMF0gIT09ICdwcm9maWxlJykge1xuICAgICAgICByZXR1cm4gZmFsc2U7XG4gICAgICB9XG5cbiAgICAgIHJldHVybiB0cnVlO1xuICAgIH0sXG4gICAgZmV0Y2g6IFsnX2lkJ10gLy8gd2Ugb25seSBsb29rIGF0IF9pZC5cbiAgfSk7XG5cbiAgLy8vIERFRkFVTFQgSU5ERVhFUyBPTiBVU0VSU1xuICB1c2Vycy5jcmVhdGVJbmRleCgndXNlcm5hbWUnLCB7IHVuaXF1ZTogdHJ1ZSwgc3BhcnNlOiB0cnVlIH0pO1xuICB1c2Vycy5jcmVhdGVJbmRleCgnZW1haWxzLmFkZHJlc3MnLCB7IHVuaXF1ZTogdHJ1ZSwgc3BhcnNlOiB0cnVlIH0pO1xuICB1c2Vycy5jcmVhdGVJbmRleCgnc2VydmljZXMucmVzdW1lLmxvZ2luVG9rZW5zLmhhc2hlZFRva2VuJyxcbiAgICB7IHVuaXF1ZTogdHJ1ZSwgc3BhcnNlOiB0cnVlIH0pO1xuICB1c2Vycy5jcmVhdGVJbmRleCgnc2VydmljZXMucmVzdW1lLmxvZ2luVG9rZW5zLnRva2VuJyxcbiAgICB7IHVuaXF1ZTogdHJ1ZSwgc3BhcnNlOiB0cnVlIH0pO1xuICAvLyBGb3IgdGFraW5nIGNhcmUgb2YgbG9nb3V0T3RoZXJDbGllbnRzIGNhbGxzIHRoYXQgY3Jhc2hlZCBiZWZvcmUgdGhlXG4gIC8vIHRva2VucyB3ZXJlIGRlbGV0ZWQuXG4gIHVzZXJzLmNyZWF0ZUluZGV4KCdzZXJ2aWNlcy5yZXN1bWUuaGF2ZUxvZ2luVG9rZW5zVG9EZWxldGUnLFxuICAgIHsgc3BhcnNlOiB0cnVlIH0pO1xuICAvLyBGb3IgZXhwaXJpbmcgbG9naW4gdG9rZW5zXG4gIHVzZXJzLmNyZWF0ZUluZGV4KFwic2VydmljZXMucmVzdW1lLmxvZ2luVG9rZW5zLndoZW5cIiwgeyBzcGFyc2U6IHRydWUgfSk7XG4gIC8vIEZvciBleHBpcmluZyBwYXNzd29yZCB0b2tlbnNcbiAgdXNlcnMuY3JlYXRlSW5kZXgoJ3NlcnZpY2VzLnBhc3N3b3JkLnJlc2V0LndoZW4nLCB7IHNwYXJzZTogdHJ1ZSB9KTtcbiAgdXNlcnMuY3JlYXRlSW5kZXgoJ3NlcnZpY2VzLnBhc3N3b3JkLmVucm9sbC53aGVuJywgeyBzcGFyc2U6IHRydWUgfSk7XG59O1xuXG5cbi8vIEdlbmVyYXRlcyBwZXJtdXRhdGlvbnMgb2YgYWxsIGNhc2UgdmFyaWF0aW9ucyBvZiBhIGdpdmVuIHN0cmluZy5cbmNvbnN0IGdlbmVyYXRlQ2FzZVBlcm11dGF0aW9uc0ZvclN0cmluZyA9IHN0cmluZyA9PiB7XG4gIGxldCBwZXJtdXRhdGlvbnMgPSBbJyddO1xuICBmb3IgKGxldCBpID0gMDsgaSA8IHN0cmluZy5sZW5ndGg7IGkrKykge1xuICAgIGNvbnN0IGNoID0gc3RyaW5nLmNoYXJBdChpKTtcbiAgICBwZXJtdXRhdGlvbnMgPSBbXS5jb25jYXQoLi4uKHBlcm11dGF0aW9ucy5tYXAocHJlZml4ID0+IHtcbiAgICAgIGNvbnN0IGxvd2VyQ2FzZUNoYXIgPSBjaC50b0xvd2VyQ2FzZSgpO1xuICAgICAgY29uc3QgdXBwZXJDYXNlQ2hhciA9IGNoLnRvVXBwZXJDYXNlKCk7XG4gICAgICAvLyBEb24ndCBhZGQgdW5uZWNlc3NhcnkgcGVybXV0YXRpb25zIHdoZW4gY2ggaXMgbm90IGEgbGV0dGVyXG4gICAgICBpZiAobG93ZXJDYXNlQ2hhciA9PT0gdXBwZXJDYXNlQ2hhcikge1xuICAgICAgICByZXR1cm4gW3ByZWZpeCArIGNoXTtcbiAgICAgIH0gZWxzZSB7XG4gICAgICAgIHJldHVybiBbcHJlZml4ICsgbG93ZXJDYXNlQ2hhciwgcHJlZml4ICsgdXBwZXJDYXNlQ2hhcl07XG4gICAgICB9XG4gICAgfSkpKTtcbiAgfVxuICByZXR1cm4gcGVybXV0YXRpb25zO1xufVxuXG4iXX0=
