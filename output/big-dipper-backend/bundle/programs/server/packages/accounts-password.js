(function () {

/* Imports */
var Meteor = Package.meteor.Meteor;
var global = Package.meteor.global;
var meteorEnv = Package.meteor.meteorEnv;
var Accounts = Package['accounts-base'].Accounts;
var SHA256 = Package.sha.SHA256;
var EJSON = Package.ejson.EJSON;
var DDP = Package['ddp-client'].DDP;
var DDPServer = Package['ddp-server'].DDPServer;
var Email = Package.email.Email;
var EmailInternals = Package.email.EmailInternals;
var Random = Package.random.Random;
var check = Package.check.check;
var Match = Package.check.Match;
var ECMAScript = Package.ecmascript.ECMAScript;
var meteorInstall = Package.modules.meteorInstall;
var Promise = Package.promise.Promise;

var require = meteorInstall({"node_modules":{"meteor":{"accounts-password":{"email_templates.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// packages/accounts-password/email_templates.js                                                                       //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let _objectSpread;

module.link("@babel/runtime/helpers/objectSpread2", {
  default(v) {
    _objectSpread = v;
  }

}, 0);

const greet = welcomeMsg => (user, url) => {
  const greeting = user.profile && user.profile.name ? "Hello ".concat(user.profile.name, ",") : 'Hello,';
  return "".concat(greeting, "\n\n").concat(welcomeMsg, ", simply click the link below.\n\n").concat(url, "\n\nThank you.\n");
};
/**
 * @summary Options to customize emails sent from the Accounts system.
 * @locus Server
 * @importFromPackage accounts-base
 */


Accounts.emailTemplates = _objectSpread(_objectSpread({}, Accounts.emailTemplates || {}), {}, {
  from: 'Accounts Example <no-reply@example.com>',
  siteName: Meteor.absoluteUrl().replace(/^https?:\/\//, '').replace(/\/$/, ''),
  resetPassword: {
    subject: () => "How to reset your password on ".concat(Accounts.emailTemplates.siteName),
    text: greet('To reset your password')
  },
  verifyEmail: {
    subject: () => "How to verify email address on ".concat(Accounts.emailTemplates.siteName),
    text: greet('To verify your account email')
  },
  enrollAccount: {
    subject: () => "An account has been created for you on ".concat(Accounts.emailTemplates.siteName),
    text: greet('To start using the service')
  }
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"password_server.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// packages/accounts-password/password_server.js                                                                       //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
let _objectSpread;

module.link("@babel/runtime/helpers/objectSpread2", {
  default(v) {
    _objectSpread = v;
  }

}, 0);
let bcrypt;
module.link("bcrypt", {
  default(v) {
    bcrypt = v;
  }

}, 0);
let Accounts;
module.link("meteor/accounts-base", {
  Accounts(v) {
    Accounts = v;
  }

}, 1);
const bcryptHash = Meteor.wrapAsync(bcrypt.hash);
const bcryptCompare = Meteor.wrapAsync(bcrypt.compare); // Utility for grabbing user

const getUserById = (id, options) => Meteor.users.findOne(id, Accounts._addDefaultFieldSelector(options)); // User records have a 'services.password.bcrypt' field on them to hold
// their hashed passwords.
//
// When the client sends a password to the server, it can either be a
// string (the plaintext password) or an object with keys 'digest' and
// 'algorithm' (must be "sha-256" for now). The Meteor client always sends
// password objects { digest: *, algorithm: "sha-256" }, but DDP clients
// that don't have access to SHA can just send plaintext passwords as
// strings.
//
// When the server receives a plaintext password as a string, it always
// hashes it with SHA256 before passing it into bcrypt. When the server
// receives a password as an object, it asserts that the algorithm is
// "sha-256" and then passes the digest to bcrypt.


Accounts._bcryptRounds = () => Accounts._options.bcryptRounds || 10; // Given a 'password' from the client, extract the string that we should
// bcrypt. 'password' can be one of:
//  - String (the plaintext password)
//  - Object with 'digest' and 'algorithm' keys. 'algorithm' must be "sha-256".
//


const getPasswordString = password => {
  if (typeof password === "string") {
    password = SHA256(password);
  } else {
    // 'password' is an object
    if (password.algorithm !== "sha-256") {
      throw new Error("Invalid password hash algorithm. " + "Only 'sha-256' is allowed.");
    }

    password = password.digest;
  }

  return password;
}; // Use bcrypt to hash the password for storage in the database.
// `password` can be a string (in which case it will be run through
// SHA256 before bcrypt) or an object with properties `digest` and
// `algorithm` (in which case we bcrypt `password.digest`).
//


const hashPassword = password => {
  password = getPasswordString(password);
  return bcryptHash(password, Accounts._bcryptRounds());
}; // Extract the number of rounds used in the specified bcrypt hash.


const getRoundsFromBcryptHash = hash => {
  let rounds;

  if (hash) {
    const hashSegments = hash.split('$');

    if (hashSegments.length > 2) {
      rounds = parseInt(hashSegments[2], 10);
    }
  }

  return rounds;
}; // Check whether the provided password matches the bcrypt'ed password in
// the database user record. `password` can be a string (in which case
// it will be run through SHA256 before bcrypt) or an object with
// properties `digest` and `algorithm` (in which case we bcrypt
// `password.digest`).
//
// The user parameter needs at least user._id and user.services


Accounts._checkPasswordUserFields = {
  _id: 1,
  services: 1
}; //

Accounts._checkPassword = (user, password) => {
  const result = {
    userId: user._id
  };
  const formattedPassword = getPasswordString(password);
  const hash = user.services.password.bcrypt;
  const hashRounds = getRoundsFromBcryptHash(hash);

  if (!bcryptCompare(formattedPassword, hash)) {
    result.error = Accounts._handleError("Incorrect password", false);
  } else if (hash && Accounts._bcryptRounds() != hashRounds) {
    // The password checks out, but the user's bcrypt hash needs to be updated.
    Meteor.defer(() => {
      Meteor.users.update({
        _id: user._id
      }, {
        $set: {
          'services.password.bcrypt': bcryptHash(formattedPassword, Accounts._bcryptRounds())
        }
      });
    });
  }

  return result;
};

const checkPassword = Accounts._checkPassword; ///
/// LOGIN
///

/**
 * @summary Finds the user with the specified username.
 * First tries to match username case sensitively; if that fails, it
 * tries case insensitively; but if more than one user matches the case
 * insensitive search, it returns null.
 * @locus Server
 * @param {String} username The username to look for
 * @param {Object} [options]
 * @param {MongoFieldSpecifier} options.fields Dictionary of fields to return or exclude.
 * @returns {Object} A user if found, else null
 * @importFromPackage accounts-base
 */

Accounts.findUserByUsername = (username, options) => Accounts._findUserByQuery({
  username
}, options);
/**
 * @summary Finds the user with the specified email.
 * First tries to match email case sensitively; if that fails, it
 * tries case insensitively; but if more than one user matches the case
 * insensitive search, it returns null.
 * @locus Server
 * @param {String} email The email address to look for
 * @param {Object} [options]
 * @param {MongoFieldSpecifier} options.fields Dictionary of fields to return or exclude.
 * @returns {Object} A user if found, else null
 * @importFromPackage accounts-base
 */


Accounts.findUserByEmail = (email, options) => Accounts._findUserByQuery({
  email
}, options); // XXX maybe this belongs in the check package


const NonEmptyString = Match.Where(x => {
  check(x, String);
  return x.length > 0;
});
const passwordValidator = Match.OneOf(Match.Where(str => {
  var _Meteor$settings, _Meteor$settings$pack, _Meteor$settings$pack2;

  return Match.test(str, String) && str.length <= ((_Meteor$settings = Meteor.settings) === null || _Meteor$settings === void 0 ? void 0 : (_Meteor$settings$pack = _Meteor$settings.packages) === null || _Meteor$settings$pack === void 0 ? void 0 : (_Meteor$settings$pack2 = _Meteor$settings$pack.accounts) === null || _Meteor$settings$pack2 === void 0 ? void 0 : _Meteor$settings$pack2.passwordMaxLength) || 256;
}), {
  digest: Match.Where(str => Match.test(str, String) && str.length === 64),
  algorithm: Match.OneOf('sha-256')
}); // Handler to login with a password.
//
// The Meteor client sets options.password to an object with keys
// 'digest' (set to SHA256(password)) and 'algorithm' ("sha-256").
//
// For other DDP clients which don't have access to SHA, the handler
// also accepts the plaintext password in options.password as a string.
//
// (It might be nice if servers could turn the plaintext password
// option off. Or maybe it should be opt-in, not opt-out?
// Accounts.config option?)
//
// Note that neither password option is secure without SSL.
//

Accounts.registerLoginHandler("password", options => {
  var _Accounts$_check2faEn, _Accounts;

  if (!options.password) return undefined; // don't handle

  check(options, {
    user: Accounts._userQueryValidator,
    password: passwordValidator,
    code: Match.Optional(NonEmptyString)
  });

  const user = Accounts._findUserByQuery(options.user, {
    fields: _objectSpread({
      services: 1
    }, Accounts._checkPasswordUserFields)
  });

  if (!user) {
    Accounts._handleError("User not found");
  }

  if (!user.services || !user.services.password || !user.services.password.bcrypt) {
    Accounts._handleError("User has no password set");
  }

  const result = checkPassword(user, options.password); // This method is added by the package accounts-2fa
  // First the login is validated, then the code situation is checked

  if (!result.error && (_Accounts$_check2faEn = (_Accounts = Accounts)._check2faEnabled) !== null && _Accounts$_check2faEn !== void 0 && _Accounts$_check2faEn.call(_Accounts, user)) {
    if (!options.code) {
      Accounts._handleError('2FA code must be informed', true, 'no-2fa-code');
    }

    if (!Accounts._isTokenValid(user.services.twoFactorAuthentication.secret, options.code)) {
      Accounts._handleError('Invalid 2FA code', true, 'invalid-2fa-code');
    }
  }

  return result;
}); ///
/// CHANGING
///

/**
 * @summary Change a user's username. Use this instead of updating the
 * database directly. The operation will fail if there is an existing user
 * with a username only differing in case.
 * @locus Server
 * @param {String} userId The ID of the user to update.
 * @param {String} newUsername A new username for the user.
 * @importFromPackage accounts-base
 */

Accounts.setUsername = (userId, newUsername) => {
  check(userId, NonEmptyString);
  check(newUsername, NonEmptyString);
  const user = getUserById(userId, {
    fields: {
      username: 1
    }
  });

  if (!user) {
    Accounts._handleError("User not found");
  }

  const oldUsername = user.username; // Perform a case insensitive check for duplicates before update

  Accounts._checkForCaseInsensitiveDuplicates('username', 'Username', newUsername, user._id);

  Meteor.users.update({
    _id: user._id
  }, {
    $set: {
      username: newUsername
    }
  }); // Perform another check after update, in case a matching user has been
  // inserted in the meantime

  try {
    Accounts._checkForCaseInsensitiveDuplicates('username', 'Username', newUsername, user._id);
  } catch (ex) {
    // Undo update if the check fails
    Meteor.users.update({
      _id: user._id
    }, {
      $set: {
        username: oldUsername
      }
    });
    throw ex;
  }
}; // Let the user change their own password if they know the old
// password. `oldPassword` and `newPassword` should be objects with keys
// `digest` and `algorithm` (representing the SHA256 of the password).


Meteor.methods({
  changePassword: function (oldPassword, newPassword) {
    check(oldPassword, passwordValidator);
    check(newPassword, passwordValidator);

    if (!this.userId) {
      throw new Meteor.Error(401, "Must be logged in");
    }

    const user = getUserById(this.userId, {
      fields: _objectSpread({
        services: 1
      }, Accounts._checkPasswordUserFields)
    });

    if (!user) {
      Accounts._handleError("User not found");
    }

    if (!user.services || !user.services.password || !user.services.password.bcrypt) {
      Accounts._handleError("User has no password set");
    }

    const result = checkPassword(user, oldPassword);

    if (result.error) {
      throw result.error;
    }

    const hashed = hashPassword(newPassword); // It would be better if this removed ALL existing tokens and replaced
    // the token for the current connection with a new one, but that would
    // be tricky, so we'll settle for just replacing all tokens other than
    // the one for the current connection.

    const currentToken = Accounts._getLoginToken(this.connection.id);

    Meteor.users.update({
      _id: this.userId
    }, {
      $set: {
        'services.password.bcrypt': hashed
      },
      $pull: {
        'services.resume.loginTokens': {
          hashedToken: {
            $ne: currentToken
          }
        }
      },
      $unset: {
        'services.password.reset': 1
      }
    });
    return {
      passwordChanged: true
    };
  }
}); // Force change the users password.

/**
 * @summary Forcibly change the password for a user.
 * @locus Server
 * @param {String} userId The id of the user to update.
 * @param {String} newPassword A new password for the user.
 * @param {Object} [options]
 * @param {Object} options.logout Logout all current connections with this userId (default: true)
 * @importFromPackage accounts-base
 */

Accounts.setPassword = (userId, newPlaintextPassword, options) => {
  check(userId, String);
  check(newPlaintextPassword, Match.Where(str => {
    var _Meteor$settings2, _Meteor$settings2$pac, _Meteor$settings2$pac2;

    return Match.test(str, String) && str.length <= ((_Meteor$settings2 = Meteor.settings) === null || _Meteor$settings2 === void 0 ? void 0 : (_Meteor$settings2$pac = _Meteor$settings2.packages) === null || _Meteor$settings2$pac === void 0 ? void 0 : (_Meteor$settings2$pac2 = _Meteor$settings2$pac.accounts) === null || _Meteor$settings2$pac2 === void 0 ? void 0 : _Meteor$settings2$pac2.passwordMaxLength) || 256;
  }));
  check(options, Match.Maybe({
    logout: Boolean
  }));
  options = _objectSpread({
    logout: true
  }, options);
  const user = getUserById(userId, {
    fields: {
      _id: 1
    }
  });

  if (!user) {
    throw new Meteor.Error(403, "User not found");
  }

  const update = {
    $unset: {
      'services.password.reset': 1
    },
    $set: {
      'services.password.bcrypt': hashPassword(newPlaintextPassword)
    }
  };

  if (options.logout) {
    update.$unset['services.resume.loginTokens'] = 1;
  }

  Meteor.users.update({
    _id: user._id
  }, update);
}; ///
/// RESETTING VIA EMAIL
///
// Utility for plucking addresses from emails


const pluckAddresses = function () {
  let emails = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];
  return emails.map(email => email.address);
}; // Method called by a user to request a password reset email. This is
// the start of the reset process.


Meteor.methods({
  forgotPassword: options => {
    check(options, {
      email: String
    });
    const user = Accounts.findUserByEmail(options.email, {
      fields: {
        emails: 1
      }
    });

    if (!user) {
      Accounts._handleError("User not found");
    }

    const emails = pluckAddresses(user.emails);
    const caseSensitiveEmail = emails.find(email => email.toLowerCase() === options.email.toLowerCase());
    Accounts.sendResetPasswordEmail(user._id, caseSensitiveEmail);
  }
});
/**
 * @summary Generates a reset token and saves it into the database.
 * @locus Server
 * @param {String} userId The id of the user to generate the reset token for.
 * @param {String} email Which address of the user to generate the reset token for. This address must be in the user's `emails` list. If `null`, defaults to the first email in the list.
 * @param {String} reason `resetPassword` or `enrollAccount`.
 * @param {Object} [extraTokenData] Optional additional data to be added into the token record.
 * @returns {Object} Object with {email, user, token} values.
 * @importFromPackage accounts-base
 */

Accounts.generateResetToken = (userId, email, reason, extraTokenData) => {
  // Make sure the user exists, and email is one of their addresses.
  // Don't limit the fields in the user object since the user is returned
  // by the function and some other fields might be used elsewhere.
  const user = getUserById(userId);

  if (!user) {
    Accounts._handleError("Can't find user");
  } // pick the first email if we weren't passed an email.


  if (!email && user.emails && user.emails[0]) {
    email = user.emails[0].address;
  } // make sure we have a valid email


  if (!email || !pluckAddresses(user.emails).includes(email)) {
    Accounts._handleError("No such email for user.");
  }

  const token = Random.secret();
  const tokenRecord = {
    token,
    email,
    when: new Date()
  };

  if (reason === 'resetPassword') {
    tokenRecord.reason = 'reset';
  } else if (reason === 'enrollAccount') {
    tokenRecord.reason = 'enroll';
  } else if (reason) {
    // fallback so that this function can be used for unknown reasons as well
    tokenRecord.reason = reason;
  }

  if (extraTokenData) {
    Object.assign(tokenRecord, extraTokenData);
  } // if this method is called from the enroll account work-flow then
  // store the token record in 'services.password.enroll' db field
  // else store the token record in in 'services.password.reset' db field


  if (reason === 'enrollAccount') {
    Meteor.users.update({
      _id: user._id
    }, {
      $set: {
        'services.password.enroll': tokenRecord
      }
    }); // before passing to template, update user object with new token

    Meteor._ensure(user, 'services', 'password').enroll = tokenRecord;
  } else {
    Meteor.users.update({
      _id: user._id
    }, {
      $set: {
        'services.password.reset': tokenRecord
      }
    }); // before passing to template, update user object with new token

    Meteor._ensure(user, 'services', 'password').reset = tokenRecord;
  }

  return {
    email,
    user,
    token
  };
};
/**
 * @summary Generates an e-mail verification token and saves it into the database.
 * @locus Server
 * @param {String} userId The id of the user to generate the  e-mail verification token for.
 * @param {String} email Which address of the user to generate the e-mail verification token for. This address must be in the user's `emails` list. If `null`, defaults to the first unverified email in the list.
 * @param {Object} [extraTokenData] Optional additional data to be added into the token record.
 * @returns {Object} Object with {email, user, token} values.
 * @importFromPackage accounts-base
 */


Accounts.generateVerificationToken = (userId, email, extraTokenData) => {
  // Make sure the user exists, and email is one of their addresses.
  // Don't limit the fields in the user object since the user is returned
  // by the function and some other fields might be used elsewhere.
  const user = getUserById(userId);

  if (!user) {
    Accounts._handleError("Can't find user");
  } // pick the first unverified email if we weren't passed an email.


  if (!email) {
    const emailRecord = (user.emails || []).find(e => !e.verified);
    email = (emailRecord || {}).address;

    if (!email) {
      Accounts._handleError("That user has no unverified email addresses.");
    }
  } // make sure we have a valid email


  if (!email || !pluckAddresses(user.emails).includes(email)) {
    Accounts._handleError("No such email for user.");
  }

  const token = Random.secret();
  const tokenRecord = {
    token,
    // TODO: This should probably be renamed to "email" to match reset token record.
    address: email,
    when: new Date()
  };

  if (extraTokenData) {
    Object.assign(tokenRecord, extraTokenData);
  }

  Meteor.users.update({
    _id: user._id
  }, {
    $push: {
      'services.email.verificationTokens': tokenRecord
    }
  }); // before passing to template, update user object with new token

  Meteor._ensure(user, 'services', 'email');

  if (!user.services.email.verificationTokens) {
    user.services.email.verificationTokens = [];
  }

  user.services.email.verificationTokens.push(tokenRecord);
  return {
    email,
    user,
    token
  };
}; // send the user an email with a link that when opened allows the user
// to set a new password, without the old password.

/**
 * @summary Send an email with a link the user can use to reset their password.
 * @locus Server
 * @param {String} userId The id of the user to send email to.
 * @param {String} [email] Optional. Which address of the user's to send the email to. This address must be in the user's `emails` list. Defaults to the first email in the list.
 * @param {Object} [extraTokenData] Optional additional data to be added into the token record.
 * @param {Object} [extraParams] Optional additional params to be added to the reset url.
 * @returns {Object} Object with {email, user, token, url, options} values.
 * @importFromPackage accounts-base
 */


Accounts.sendResetPasswordEmail = (userId, email, extraTokenData, extraParams) => {
  const {
    email: realEmail,
    user,
    token
  } = Accounts.generateResetToken(userId, email, 'resetPassword', extraTokenData);
  const url = Accounts.urls.resetPassword(token, extraParams);
  const options = Accounts.generateOptionsForEmail(realEmail, user, url, 'resetPassword');
  Email.send(options);

  if (Meteor.isDevelopment) {
    console.log("\nReset password URL: ".concat(url));
  }

  return {
    email: realEmail,
    user,
    token,
    url,
    options
  };
}; // send the user an email informing them that their account was created, with
// a link that when opened both marks their email as verified and forces them
// to choose their password. The email must be one of the addresses in the
// user's emails field, or undefined to pick the first email automatically.
//
// This is not called automatically. It must be called manually if you
// want to use enrollment emails.

/**
 * @summary Send an email with a link the user can use to set their initial password.
 * @locus Server
 * @param {String} userId The id of the user to send email to.
 * @param {String} [email] Optional. Which address of the user's to send the email to. This address must be in the user's `emails` list. Defaults to the first email in the list.
 * @param {Object} [extraTokenData] Optional additional data to be added into the token record.
 * @param {Object} [extraParams] Optional additional params to be added to the enrollment url.
 * @returns {Object} Object with {email, user, token, url, options} values.
 * @importFromPackage accounts-base
 */


Accounts.sendEnrollmentEmail = (userId, email, extraTokenData, extraParams) => {
  const {
    email: realEmail,
    user,
    token
  } = Accounts.generateResetToken(userId, email, 'enrollAccount', extraTokenData);
  const url = Accounts.urls.enrollAccount(token, extraParams);
  const options = Accounts.generateOptionsForEmail(realEmail, user, url, 'enrollAccount');
  Email.send(options);

  if (Meteor.isDevelopment) {
    console.log("\nEnrollment email URL: ".concat(url));
  }

  return {
    email: realEmail,
    user,
    token,
    url,
    options
  };
}; // Take token from sendResetPasswordEmail or sendEnrollmentEmail, change
// the users password, and log them in.


Meteor.methods({
  resetPassword: function () {
    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }

    const token = args[0];
    const newPassword = args[1];
    return Accounts._loginMethod(this, "resetPassword", args, "password", () => {
      check(token, String);
      check(newPassword, passwordValidator);
      let user = Meteor.users.findOne({
        "services.password.reset.token": token
      }, {
        fields: {
          services: 1,
          emails: 1
        }
      });
      let isEnroll = false; // if token is in services.password.reset db field implies
      // this method is was not called from enroll account workflow
      // else this method is called from enroll account workflow

      if (!user) {
        user = Meteor.users.findOne({
          "services.password.enroll.token": token
        }, {
          fields: {
            services: 1,
            emails: 1
          }
        });
        isEnroll = true;
      }

      if (!user) {
        throw new Meteor.Error(403, "Token expired");
      }

      let tokenRecord = {};

      if (isEnroll) {
        tokenRecord = user.services.password.enroll;
      } else {
        tokenRecord = user.services.password.reset;
      }

      const {
        when,
        email
      } = tokenRecord;

      let tokenLifetimeMs = Accounts._getPasswordResetTokenLifetimeMs();

      if (isEnroll) {
        tokenLifetimeMs = Accounts._getPasswordEnrollTokenLifetimeMs();
      }

      const currentTimeMs = Date.now();
      if (currentTimeMs - when > tokenLifetimeMs) throw new Meteor.Error(403, "Token expired");
      if (!pluckAddresses(user.emails).includes(email)) return {
        userId: user._id,
        error: new Meteor.Error(403, "Token has invalid email address")
      };
      const hashed = hashPassword(newPassword); // NOTE: We're about to invalidate tokens on the user, who we might be
      // logged in as. Make sure to avoid logging ourselves out if this
      // happens. But also make sure not to leave the connection in a state
      // of having a bad token set if things fail.

      const oldToken = Accounts._getLoginToken(this.connection.id);

      Accounts._setLoginToken(user._id, this.connection, null);

      const resetToOldToken = () => Accounts._setLoginToken(user._id, this.connection, oldToken);

      try {
        // Update the user record by:
        // - Changing the password to the new one
        // - Forgetting about the reset token or enroll token that was just used
        // - Verifying their email, since they got the password reset via email.
        let affectedRecords = {}; // if reason is enroll then check services.password.enroll.token field for affected records

        if (isEnroll) {
          affectedRecords = Meteor.users.update({
            _id: user._id,
            'emails.address': email,
            'services.password.enroll.token': token
          }, {
            $set: {
              'services.password.bcrypt': hashed,
              'emails.$.verified': true
            },
            $unset: {
              'services.password.enroll': 1
            }
          });
        } else {
          affectedRecords = Meteor.users.update({
            _id: user._id,
            'emails.address': email,
            'services.password.reset.token': token
          }, {
            $set: {
              'services.password.bcrypt': hashed,
              'emails.$.verified': true
            },
            $unset: {
              'services.password.reset': 1
            }
          });
        }

        if (affectedRecords !== 1) return {
          userId: user._id,
          error: new Meteor.Error(403, "Invalid email")
        };
      } catch (err) {
        resetToOldToken();
        throw err;
      } // Replace all valid login tokens with new ones (changing
      // password should invalidate existing sessions).


      Accounts._clearAllLoginTokens(user._id);

      return {
        userId: user._id
      };
    });
  }
}); ///
/// EMAIL VERIFICATION
///
// send the user an email with a link that when opened marks that
// address as verified

/**
 * @summary Send an email with a link the user can use verify their email address.
 * @locus Server
 * @param {String} userId The id of the user to send email to.
 * @param {String} [email] Optional. Which address of the user's to send the email to. This address must be in the user's `emails` list. Defaults to the first unverified email in the list.
 * @param {Object} [extraTokenData] Optional additional data to be added into the token record.
 * @param {Object} [extraParams] Optional additional params to be added to the verification url.
 *
 * @returns {Object} Object with {email, user, token, url, options} values.
 * @importFromPackage accounts-base
 */

Accounts.sendVerificationEmail = (userId, email, extraTokenData, extraParams) => {
  // XXX Also generate a link using which someone can delete this
  // account if they own said address but weren't those who created
  // this account.
  const {
    email: realEmail,
    user,
    token
  } = Accounts.generateVerificationToken(userId, email, extraTokenData);
  const url = Accounts.urls.verifyEmail(token, extraParams);
  const options = Accounts.generateOptionsForEmail(realEmail, user, url, 'verifyEmail');
  Email.send(options);

  if (Meteor.isDevelopment) {
    console.log("\nVerification email URL: ".concat(url));
  }

  return {
    email: realEmail,
    user,
    token,
    url,
    options
  };
}; // Take token from sendVerificationEmail, mark the email as verified,
// and log them in.


Meteor.methods({
  verifyEmail: function () {
    for (var _len2 = arguments.length, args = new Array(_len2), _key2 = 0; _key2 < _len2; _key2++) {
      args[_key2] = arguments[_key2];
    }

    const token = args[0];
    return Accounts._loginMethod(this, "verifyEmail", args, "password", () => {
      check(token, String);
      const user = Meteor.users.findOne({
        'services.email.verificationTokens.token': token
      }, {
        fields: {
          services: 1,
          emails: 1
        }
      });
      if (!user) throw new Meteor.Error(403, "Verify email link expired");
      const tokenRecord = user.services.email.verificationTokens.find(t => t.token == token);
      if (!tokenRecord) return {
        userId: user._id,
        error: new Meteor.Error(403, "Verify email link expired")
      };
      const emailsRecord = user.emails.find(e => e.address == tokenRecord.address);
      if (!emailsRecord) return {
        userId: user._id,
        error: new Meteor.Error(403, "Verify email link is for unknown address")
      }; // By including the address in the query, we can use 'emails.$' in the
      // modifier to get a reference to the specific object in the emails
      // array. See
      // http://www.mongodb.org/display/DOCS/Updating/#Updating-The%24positionaloperator)
      // http://www.mongodb.org/display/DOCS/Updating#Updating-%24pull

      Meteor.users.update({
        _id: user._id,
        'emails.address': tokenRecord.address
      }, {
        $set: {
          'emails.$.verified': true
        },
        $pull: {
          'services.email.verificationTokens': {
            address: tokenRecord.address
          }
        }
      });
      return {
        userId: user._id
      };
    });
  }
});
/**
 * @summary Add an email address for a user. Use this instead of directly
 * updating the database. The operation will fail if there is a different user
 * with an email only differing in case. If the specified user has an existing
 * email only differing in case however, we replace it.
 * @locus Server
 * @param {String} userId The ID of the user to update.
 * @param {String} newEmail A new email address for the user.
 * @param {Boolean} [verified] Optional - whether the new email address should
 * be marked as verified. Defaults to false.
 * @importFromPackage accounts-base
 */

Accounts.addEmail = (userId, newEmail, verified) => {
  check(userId, NonEmptyString);
  check(newEmail, NonEmptyString);
  check(verified, Match.Optional(Boolean));

  if (verified === void 0) {
    verified = false;
  }

  const user = getUserById(userId, {
    fields: {
      emails: 1
    }
  });
  if (!user) throw new Meteor.Error(403, "User not found"); // Allow users to change their own email to a version with a different case
  // We don't have to call checkForCaseInsensitiveDuplicates to do a case
  // insensitive check across all emails in the database here because: (1) if
  // there is no case-insensitive duplicate between this user and other users,
  // then we are OK and (2) if this would create a conflict with other users
  // then there would already be a case-insensitive duplicate and we can't fix
  // that in this code anyway.

  const caseInsensitiveRegExp = new RegExp("^".concat(Meteor._escapeRegExp(newEmail), "$"), 'i');
  const didUpdateOwnEmail = (user.emails || []).reduce((prev, email) => {
    if (caseInsensitiveRegExp.test(email.address)) {
      Meteor.users.update({
        _id: user._id,
        'emails.address': email.address
      }, {
        $set: {
          'emails.$.address': newEmail,
          'emails.$.verified': verified
        }
      });
      return true;
    } else {
      return prev;
    }
  }, false); // In the other updates below, we have to do another call to
  // checkForCaseInsensitiveDuplicates to make sure that no conflicting values
  // were added to the database in the meantime. We don't have to do this for
  // the case where the user is updating their email address to one that is the
  // same as before, but only different because of capitalization. Read the
  // big comment above to understand why.

  if (didUpdateOwnEmail) {
    return;
  } // Perform a case insensitive check for duplicates before update


  Accounts._checkForCaseInsensitiveDuplicates('emails.address', 'Email', newEmail, user._id);

  Meteor.users.update({
    _id: user._id
  }, {
    $addToSet: {
      emails: {
        address: newEmail,
        verified: verified
      }
    }
  }); // Perform another check after update, in case a matching user has been
  // inserted in the meantime

  try {
    Accounts._checkForCaseInsensitiveDuplicates('emails.address', 'Email', newEmail, user._id);
  } catch (ex) {
    // Undo update if the check fails
    Meteor.users.update({
      _id: user._id
    }, {
      $pull: {
        emails: {
          address: newEmail
        }
      }
    });
    throw ex;
  }
};
/**
 * @summary Remove an email address for a user. Use this instead of updating
 * the database directly.
 * @locus Server
 * @param {String} userId The ID of the user to update.
 * @param {String} email The email address to remove.
 * @importFromPackage accounts-base
 */


Accounts.removeEmail = (userId, email) => {
  check(userId, NonEmptyString);
  check(email, NonEmptyString);
  const user = getUserById(userId, {
    fields: {
      _id: 1
    }
  });
  if (!user) throw new Meteor.Error(403, "User not found");
  Meteor.users.update({
    _id: user._id
  }, {
    $pull: {
      emails: {
        address: email
      }
    }
  });
}; ///
/// CREATING USERS
///
// Shared createUser function called from the createUser method, both
// if originates in client or server code. Calls user provided hooks,
// does the actual user insertion.
//
// returns the user id


const createUser = options => {
  // Unknown keys allowed, because a onCreateUserHook can take arbitrary
  // options.
  check(options, Match.ObjectIncluding({
    username: Match.Optional(String),
    email: Match.Optional(String),
    password: Match.Optional(passwordValidator)
  }));
  const {
    username,
    email,
    password
  } = options;
  if (!username && !email) throw new Meteor.Error(400, "Need to set a username or email");
  const user = {
    services: {}
  };

  if (password) {
    const hashed = hashPassword(password);
    user.services.password = {
      bcrypt: hashed
    };
  }

  return Accounts._createUserCheckingDuplicates({
    user,
    email,
    username,
    options
  });
}; // method for create user. Requests come from the client.


Meteor.methods({
  createUser: function () {
    for (var _len3 = arguments.length, args = new Array(_len3), _key3 = 0; _key3 < _len3; _key3++) {
      args[_key3] = arguments[_key3];
    }

    const options = args[0];
    return Accounts._loginMethod(this, "createUser", args, "password", () => {
      // createUser() above does more checking.
      check(options, Object);
      if (Accounts._options.forbidClientAccountCreation) return {
        error: new Meteor.Error(403, "Signups forbidden")
      };
      const userId = Accounts.createUserVerifyingEmail(options); // client gets logged in as the new user afterwards.

      return {
        userId: userId
      };
    });
  }
});
/**
 * @summary Creates an user and sends an email if `options.email` is informed.
 * Then if the `sendVerificationEmail` option from the `Accounts` package is
 * enabled, you'll send a verification email if `options.password` is informed,
 * otherwise you'll send an enrollment email.
 * @locus Server
 * @param {Object} options The options object to be passed down when creating
 * the user
 * @param {String} options.username A unique name for this user.
 * @param {String} options.email The user's email address.
 * @param {String} options.password The user's password. This is __not__ sent in plain text over the wire.
 * @param {Object} options.profile The user's profile, typically including the `name` field.
 * @importFromPackage accounts-base
 * */

Accounts.createUserVerifyingEmail = options => {
  options = _objectSpread({}, options); // Create user. result contains id and token.

  const userId = createUser(options); // safety belt. createUser is supposed to throw on error. send 500 error
  // instead of sending a verification email with empty userid.

  if (!userId) throw new Error("createUser failed to insert new user"); // If `Accounts._options.sendVerificationEmail` is set, register
  // a token to verify the user's primary email, and send it to
  // that address.

  if (options.email && Accounts._options.sendVerificationEmail) {
    if (options.password) {
      Accounts.sendVerificationEmail(userId, options.email);
    } else {
      Accounts.sendEnrollmentEmail(userId, options.email);
    }
  }

  return userId;
}; // Create user directly on the server.
//
// Unlike the client version, this does not log you in as this user
// after creation.
//
// returns userId or throws an error if it can't create
//
// XXX add another argument ("server options") that gets sent to onCreateUser,
// which is always empty when called from the createUser method? eg, "admin:
// true", which we want to prevent the client from setting, but which a custom
// method calling Accounts.createUser could set?
//


Accounts.createUser = (options, callback) => {
  options = _objectSpread({}, options); // XXX allow an optional callback?

  if (callback) {
    throw new Error("Accounts.createUser with callback not supported on the server yet.");
  }

  return createUser(options);
}; ///
/// PASSWORD-SPECIFIC INDEXES ON USERS
///


Meteor.users.createIndex('services.email.verificationTokens.token', {
  unique: true,
  sparse: true
});
Meteor.users.createIndex('services.password.reset.token', {
  unique: true,
  sparse: true
});
Meteor.users.createIndex('services.password.enroll.token', {
  unique: true,
  sparse: true
});
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"node_modules":{"bcrypt":{"package.json":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// node_modules/meteor/accounts-password/node_modules/bcrypt/package.json                                              //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
module.exports = {
  "name": "bcrypt",
  "version": "5.0.1",
  "main": "./bcrypt"
};

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"bcrypt.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
// node_modules/meteor/accounts-password/node_modules/bcrypt/bcrypt.js                                                 //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                       //
module.useNode();
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}}}}}}},{
  "extensions": [
    ".js",
    ".json"
  ]
});

require("/node_modules/meteor/accounts-password/email_templates.js");
require("/node_modules/meteor/accounts-password/password_server.js");

/* Exports */
Package._define("accounts-password");

})();

//# sourceURL=meteor://💻app/packages/accounts-password.js
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvYWNjb3VudHMtcGFzc3dvcmQvZW1haWxfdGVtcGxhdGVzLmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9wYWNrYWdlcy9hY2NvdW50cy1wYXNzd29yZC9wYXNzd29yZF9zZXJ2ZXIuanMiXSwibmFtZXMiOlsiX29iamVjdFNwcmVhZCIsIm1vZHVsZSIsImxpbmsiLCJkZWZhdWx0IiwidiIsImdyZWV0Iiwid2VsY29tZU1zZyIsInVzZXIiLCJ1cmwiLCJncmVldGluZyIsInByb2ZpbGUiLCJuYW1lIiwiQWNjb3VudHMiLCJlbWFpbFRlbXBsYXRlcyIsImZyb20iLCJzaXRlTmFtZSIsIk1ldGVvciIsImFic29sdXRlVXJsIiwicmVwbGFjZSIsInJlc2V0UGFzc3dvcmQiLCJzdWJqZWN0IiwidGV4dCIsInZlcmlmeUVtYWlsIiwiZW5yb2xsQWNjb3VudCIsImJjcnlwdCIsImJjcnlwdEhhc2giLCJ3cmFwQXN5bmMiLCJoYXNoIiwiYmNyeXB0Q29tcGFyZSIsImNvbXBhcmUiLCJnZXRVc2VyQnlJZCIsImlkIiwib3B0aW9ucyIsInVzZXJzIiwiZmluZE9uZSIsIl9hZGREZWZhdWx0RmllbGRTZWxlY3RvciIsIl9iY3J5cHRSb3VuZHMiLCJfb3B0aW9ucyIsImJjcnlwdFJvdW5kcyIsImdldFBhc3N3b3JkU3RyaW5nIiwicGFzc3dvcmQiLCJTSEEyNTYiLCJhbGdvcml0aG0iLCJFcnJvciIsImRpZ2VzdCIsImhhc2hQYXNzd29yZCIsImdldFJvdW5kc0Zyb21CY3J5cHRIYXNoIiwicm91bmRzIiwiaGFzaFNlZ21lbnRzIiwic3BsaXQiLCJsZW5ndGgiLCJwYXJzZUludCIsIl9jaGVja1Bhc3N3b3JkVXNlckZpZWxkcyIsIl9pZCIsInNlcnZpY2VzIiwiX2NoZWNrUGFzc3dvcmQiLCJyZXN1bHQiLCJ1c2VySWQiLCJmb3JtYXR0ZWRQYXNzd29yZCIsImhhc2hSb3VuZHMiLCJlcnJvciIsIl9oYW5kbGVFcnJvciIsImRlZmVyIiwidXBkYXRlIiwiJHNldCIsImNoZWNrUGFzc3dvcmQiLCJmaW5kVXNlckJ5VXNlcm5hbWUiLCJ1c2VybmFtZSIsIl9maW5kVXNlckJ5UXVlcnkiLCJmaW5kVXNlckJ5RW1haWwiLCJlbWFpbCIsIk5vbkVtcHR5U3RyaW5nIiwiTWF0Y2giLCJXaGVyZSIsIngiLCJjaGVjayIsIlN0cmluZyIsInBhc3N3b3JkVmFsaWRhdG9yIiwiT25lT2YiLCJzdHIiLCJ0ZXN0Iiwic2V0dGluZ3MiLCJwYWNrYWdlcyIsImFjY291bnRzIiwicGFzc3dvcmRNYXhMZW5ndGgiLCJyZWdpc3RlckxvZ2luSGFuZGxlciIsInVuZGVmaW5lZCIsIl91c2VyUXVlcnlWYWxpZGF0b3IiLCJjb2RlIiwiT3B0aW9uYWwiLCJmaWVsZHMiLCJfY2hlY2syZmFFbmFibGVkIiwiX2lzVG9rZW5WYWxpZCIsInR3b0ZhY3RvckF1dGhlbnRpY2F0aW9uIiwic2VjcmV0Iiwic2V0VXNlcm5hbWUiLCJuZXdVc2VybmFtZSIsIm9sZFVzZXJuYW1lIiwiX2NoZWNrRm9yQ2FzZUluc2Vuc2l0aXZlRHVwbGljYXRlcyIsImV4IiwibWV0aG9kcyIsImNoYW5nZVBhc3N3b3JkIiwib2xkUGFzc3dvcmQiLCJuZXdQYXNzd29yZCIsImhhc2hlZCIsImN1cnJlbnRUb2tlbiIsIl9nZXRMb2dpblRva2VuIiwiY29ubmVjdGlvbiIsIiRwdWxsIiwiaGFzaGVkVG9rZW4iLCIkbmUiLCIkdW5zZXQiLCJwYXNzd29yZENoYW5nZWQiLCJzZXRQYXNzd29yZCIsIm5ld1BsYWludGV4dFBhc3N3b3JkIiwiTWF5YmUiLCJsb2dvdXQiLCJCb29sZWFuIiwicGx1Y2tBZGRyZXNzZXMiLCJlbWFpbHMiLCJtYXAiLCJhZGRyZXNzIiwiZm9yZ290UGFzc3dvcmQiLCJjYXNlU2Vuc2l0aXZlRW1haWwiLCJmaW5kIiwidG9Mb3dlckNhc2UiLCJzZW5kUmVzZXRQYXNzd29yZEVtYWlsIiwiZ2VuZXJhdGVSZXNldFRva2VuIiwicmVhc29uIiwiZXh0cmFUb2tlbkRhdGEiLCJpbmNsdWRlcyIsInRva2VuIiwiUmFuZG9tIiwidG9rZW5SZWNvcmQiLCJ3aGVuIiwiRGF0ZSIsIk9iamVjdCIsImFzc2lnbiIsIl9lbnN1cmUiLCJlbnJvbGwiLCJyZXNldCIsImdlbmVyYXRlVmVyaWZpY2F0aW9uVG9rZW4iLCJlbWFpbFJlY29yZCIsImUiLCJ2ZXJpZmllZCIsIiRwdXNoIiwidmVyaWZpY2F0aW9uVG9rZW5zIiwicHVzaCIsImV4dHJhUGFyYW1zIiwicmVhbEVtYWlsIiwidXJscyIsImdlbmVyYXRlT3B0aW9uc0ZvckVtYWlsIiwiRW1haWwiLCJzZW5kIiwiaXNEZXZlbG9wbWVudCIsImNvbnNvbGUiLCJsb2ciLCJzZW5kRW5yb2xsbWVudEVtYWlsIiwiYXJncyIsIl9sb2dpbk1ldGhvZCIsImlzRW5yb2xsIiwidG9rZW5MaWZldGltZU1zIiwiX2dldFBhc3N3b3JkUmVzZXRUb2tlbkxpZmV0aW1lTXMiLCJfZ2V0UGFzc3dvcmRFbnJvbGxUb2tlbkxpZmV0aW1lTXMiLCJjdXJyZW50VGltZU1zIiwibm93Iiwib2xkVG9rZW4iLCJfc2V0TG9naW5Ub2tlbiIsInJlc2V0VG9PbGRUb2tlbiIsImFmZmVjdGVkUmVjb3JkcyIsImVyciIsIl9jbGVhckFsbExvZ2luVG9rZW5zIiwic2VuZFZlcmlmaWNhdGlvbkVtYWlsIiwidCIsImVtYWlsc1JlY29yZCIsImFkZEVtYWlsIiwibmV3RW1haWwiLCJjYXNlSW5zZW5zaXRpdmVSZWdFeHAiLCJSZWdFeHAiLCJfZXNjYXBlUmVnRXhwIiwiZGlkVXBkYXRlT3duRW1haWwiLCJyZWR1Y2UiLCJwcmV2IiwiJGFkZFRvU2V0IiwicmVtb3ZlRW1haWwiLCJjcmVhdGVVc2VyIiwiT2JqZWN0SW5jbHVkaW5nIiwiX2NyZWF0ZVVzZXJDaGVja2luZ0R1cGxpY2F0ZXMiLCJmb3JiaWRDbGllbnRBY2NvdW50Q3JlYXRpb24iLCJjcmVhdGVVc2VyVmVyaWZ5aW5nRW1haWwiLCJjYWxsYmFjayIsImNyZWF0ZUluZGV4IiwidW5pcXVlIiwic3BhcnNlIl0sIm1h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Q0FBQ2lCLEtBQVAsQ0FBYThKLFdBQWIsQ0FBeUIsZ0NBQXpCLEVBQzBCO0FBQUVDLFFBQU0sRUFBRSxJQUFWO0FBQWdCQyxRQUFNLEVBQUU7QUFBeEIsQ0FEMUIsRSIsImZpbGUiOiIvcGFja2FnZXMvYWNjb3VudHMtcGFzc3dvcmQuanMiLCJzb3VyY2VzQ29udGVudCI6WyJjb25zdCBncmVldCA9IHdlbGNvbWVNc2cgPT4gKHVzZXIsIHVybCkgPT4ge1xuICBjb25zdCBncmVldGluZyA9XG4gICAgdXNlci5wcm9maWxlICYmIHVzZXIucHJvZmlsZS5uYW1lXG4gICAgICA/IGBIZWxsbyAke3VzZXIucHJvZmlsZS5uYW1lfSxgXG4gICAgICA6ICdIZWxsbywnO1xuICByZXR1cm4gYCR7Z3JlZXRpbmd9XG5cbiR7d2VsY29tZU1zZ30sIHNpbXBseSBjbGljayB0aGUgbGluayBiZWxvdy5cblxuJHt1cmx9XG5cblRoYW5rIHlvdS5cbmA7XG59O1xuXG4vKipcbiAqIEBzdW1tYXJ5IE9wdGlvbnMgdG8gY3VzdG9taXplIGVtYWlscyBzZW50IGZyb20gdGhlIEFjY291bnRzIHN5c3RlbS5cbiAqIEBsb2N1cyBTZXJ2ZXJcbiAqIEBpbXBvcnRGcm9tUGFja2FnZSBhY2NvdW50cy1iYXNlXG4gKi9cbkFjY291bnRzLmVtYWlsVGVtcGxhdGVzID0ge1xuICAuLi4oQWNjb3VudHMuZW1haWxUZW1wbGF0ZXMgfHwge30pLFxuICBmcm9tOiAnQWNjb3VudHMgRXhhbXBsZSA8bm8tcmVwbHlAZXhhbXBsZS5jb20+JyxcbiAgc2l0ZU5hbWU6IE1ldGVvci5hYnNvbHV0ZVVybCgpXG4gICAgLnJlcGxhY2UoL15odHRwcz86XFwvXFwvLywgJycpXG4gICAgLnJlcGxhY2UoL1xcLyQvLCAnJyksXG5cbiAgcmVzZXRQYXNzd29yZDoge1xuICAgIHN1YmplY3Q6ICgpID0+XG4gICAgICBgSG93IHRvIHJlc2V0IHlvdXIgcGFzc3dvcmQgb24gJHtBY2NvdW50cy5lbWFpbFRlbXBsYXRlcy5zaXRlTmFtZX1gLFxuICAgIHRleHQ6IGdyZWV0KCdUbyByZXNldCB5b3VyIHBhc3N3b3JkJyksXG4gIH0sXG4gIHZlcmlmeUVtYWlsOiB7XG4gICAgc3ViamVjdDogKCkgPT5cbiAgICAgIGBIb3cgdG8gdmVyaWZ5IGVtYWlsIGFkZHJlc3Mgb24gJHtBY2NvdW50cy5lbWFpbFRlbXBsYXRlcy5zaXRlTmFtZX1gLFxuICAgIHRleHQ6IGdyZWV0KCdUbyB2ZXJpZnkgeW91ciBhY2NvdW50IGVtYWlsJyksXG4gIH0sXG4gIGVucm9sbEFjY291bnQ6IHtcbiAgICBzdWJqZWN0OiAoKSA9PlxuICAgICAgYEFuIGFjY291bnQgaGFzIGJlZW4gY3JlYXRlZCBmb3IgeW91IG9uICR7QWNjb3VudHMuZW1haWxUZW1wbGF0ZXMuc2l0ZU5hbWV9YCxcbiAgICB0ZXh0OiBncmVldCgnVG8gc3RhcnQgdXNpbmcgdGhlIHNlcnZpY2UnKSxcbiAgfSxcbn07XG4iLCJpbXBvcnQgYmNyeXB0IGZyb20gJ2JjcnlwdCdcbmltcG9ydCB7QWNjb3VudHN9IGZyb20gXCJtZXRlb3IvYWNjb3VudHMtYmFzZVwiO1xuXG5jb25zdCBiY3J5cHRIYXNoID0gTWV0ZW9yLndyYXBBc3luYyhiY3J5cHQuaGFzaCk7XG5jb25zdCBiY3J5cHRDb21wYXJlID0gTWV0ZW9yLndyYXBBc3luYyhiY3J5cHQuY29tcGFyZSk7XG5cbi8vIFV0aWxpdHkgZm9yIGdyYWJiaW5nIHVzZXJcbmNvbnN0IGdldFVzZXJCeUlkID0gKGlkLCBvcHRpb25zKSA9PiBNZXRlb3IudXNlcnMuZmluZE9uZShpZCwgQWNjb3VudHMuX2FkZERlZmF1bHRGaWVsZFNlbGVjdG9yKG9wdGlvbnMpKTtcblxuLy8gVXNlciByZWNvcmRzIGhhdmUgYSAnc2VydmljZXMucGFzc3dvcmQuYmNyeXB0JyBmaWVsZCBvbiB0aGVtIHRvIGhvbGRcbi8vIHRoZWlyIGhhc2hlZCBwYXNzd29yZHMuXG4vL1xuLy8gV2hlbiB0aGUgY2xpZW50IHNlbmRzIGEgcGFzc3dvcmQgdG8gdGhlIHNlcnZlciwgaXQgY2FuIGVpdGhlciBiZSBhXG4vLyBzdHJpbmcgKHRoZSBwbGFpbnRleHQgcGFzc3dvcmQpIG9yIGFuIG9iamVjdCB3aXRoIGtleXMgJ2RpZ2VzdCcgYW5kXG4vLyAnYWxnb3JpdGhtJyAobXVzdCBiZSBcInNoYS0yNTZcIiBmb3Igbm93KS4gVGhlIE1ldGVvciBjbGllbnQgYWx3YXlzIHNlbmRzXG4vLyBwYXNzd29yZCBvYmplY3RzIHsgZGlnZXN0OiAqLCBhbGdvcml0aG06IFwic2hhLTI1NlwiIH0sIGJ1dCBERFAgY2xpZW50c1xuLy8gdGhhdCBkb24ndCBoYXZlIGFjY2VzcyB0byBTSEEgY2FuIGp1c3Qgc2VuZCBwbGFpbnRleHQgcGFzc3dvcmRzIGFzXG4vLyBzdHJpbmdzLlxuLy9cbi8vIFdoZW4gdGhlIHNlcnZlciByZWNlaXZlcyBhIHBsYWludGV4dCBwYXNzd29yZCBhcyBhIHN0cmluZywgaXQgYWx3YXlzXG4vLyBoYXNoZXMgaXQgd2l0aCBTSEEyNTYgYmVmb3JlIHBhc3NpbmcgaXQgaW50byBiY3J5cHQuIFdoZW4gdGhlIHNlcnZlclxuLy8gcmVjZWl2ZXMgYSBwYXNzd29yZCBhcyBhbiBvYmplY3QsIGl0IGFzc2VydHMgdGhhdCB0aGUgYWxnb3JpdGhtIGlzXG4vLyBcInNoYS0yNTZcIiBhbmQgdGhlbiBwYXNzZXMgdGhlIGRpZ2VzdCB0byBiY3J5cHQuXG5cblxuQWNjb3VudHMuX2JjcnlwdFJvdW5kcyA9ICgpID0+IEFjY291bnRzLl9vcHRpb25zLmJjcnlwdFJvdW5kcyB8fCAxMDtcblxuLy8gR2l2ZW4gYSAncGFzc3dvcmQnIGZyb20gdGhlIGNsaWVudCwgZXh0cmFjdCB0aGUgc3RyaW5nIHRoYXQgd2Ugc2hvdWxkXG4vLyBiY3J5cHQuICdwYXNzd29yZCcgY2FuIGJlIG9uZSBvZjpcbi8vICAtIFN0cmluZyAodGhlIHBsYWludGV4dCBwYXNzd29yZClcbi8vICAtIE9iamVjdCB3aXRoICdkaWdlc3QnIGFuZCAnYWxnb3JpdGhtJyBrZXlzLiAnYWxnb3JpdGhtJyBtdXN0IGJlIFwic2hhLTI1NlwiLlxuLy9cbmNvbnN0IGdldFBhc3N3b3JkU3RyaW5nID0gcGFzc3dvcmQgPT4ge1xuICBpZiAodHlwZW9mIHBhc3N3b3JkID09PSBcInN0cmluZ1wiKSB7XG4gICAgcGFzc3dvcmQgPSBTSEEyNTYocGFzc3dvcmQpO1xuICB9IGVsc2UgeyAvLyAncGFzc3dvcmQnIGlzIGFuIG9iamVjdFxuICAgIGlmIChwYXNzd29yZC5hbGdvcml0aG0gIT09IFwic2hhLTI1NlwiKSB7XG4gICAgICB0aHJvdyBuZXcgRXJyb3IoXCJJbnZhbGlkIHBhc3N3b3JkIGhhc2ggYWxnb3JpdGhtLiBcIiArXG4gICAgICAgICAgICAgICAgICAgICAgXCJPbmx5ICdzaGEtMjU2JyBpcyBhbGxvd2VkLlwiKTtcbiAgICB9XG4gICAgcGFzc3dvcmQgPSBwYXNzd29yZC5kaWdlc3Q7XG4gIH1cbiAgcmV0dXJuIHBhc3N3b3JkO1xufTtcblxuLy8gVXNlIGJjcnlwdCB0byBoYXNoIHRoZSBwYXNzd29yZCBmb3Igc3RvcmFnZSBpbiB0aGUgZGF0YWJhc2UuXG4vLyBgcGFzc3dvcmRgIGNhbiBiZSBhIHN0cmluZyAoaW4gd2hpY2ggY2FzZSBpdCB3aWxsIGJlIHJ1biB0aHJvdWdoXG4vLyBTSEEyNTYgYmVmb3JlIGJjcnlwdCkgb3IgYW4gb2JqZWN0IHdpdGggcHJvcGVydGllcyBgZGlnZXN0YCBhbmRcbi8vIGBhbGdvcml0aG1gIChpbiB3aGljaCBjYXNlIHdlIGJjcnlwdCBgcGFzc3dvcmQuZGlnZXN0YCkuXG4vL1xuY29uc3QgaGFzaFBhc3N3b3JkID0gcGFzc3dvcmQgPT4ge1xuICBwYXNzd29yZCA9IGdldFBhc3N3b3JkU3RyaW5nKHBhc3N3b3JkKTtcbiAgcmV0dXJuIGJjcnlwdEhhc2gocGFzc3dvcmQsIEFjY291bnRzLl9iY3J5cHRSb3VuZHMoKSk7XG59O1xuXG4vLyBFeHRyYWN0IHRoZSBudW1iZXIgb2Ygcm91bmRzIHVzZWQgaW4gdGhlIHNwZWNpZmllZCBiY3J5cHQgaGFzaC5cbmNvbnN0IGdldFJvdW5kc0Zyb21CY3J5cHRIYXNoID0gaGFzaCA9PiB7XG4gIGxldCByb3VuZHM7XG4gIGlmIChoYXNoKSB7XG4gICAgY29uc3QgaGFzaFNlZ21lbnRzID0gaGFzaC5zcGxpdCgnJCcpO1xuICAgIGlmIChoYXNoU2VnbWVudHMubGVuZ3RoID4gMikge1xuICAgICAgcm91bmRzID0gcGFyc2VJbnQoaGFzaFNlZ21lbnRzWzJdLCAxMCk7XG4gICAgfVxuICB9XG4gIHJldHVybiByb3VuZHM7XG59O1xuXG4vLyBDaGVjayB3aGV0aGVyIHRoZSBwcm92aWRlZCBwYXNzd29yZCBtYXRjaGVzIHRoZSBiY3J5cHQnZWQgcGFzc3dvcmQgaW5cbi8vIHRoZSBkYXRhYmFzZSB1c2VyIHJlY29yZC4gYHBhc3N3b3JkYCBjYW4gYmUgYSBzdHJpbmcgKGluIHdoaWNoIGNhc2Vcbi8vIGl0IHdpbGwgYmUgcnVuIHRocm91Z2ggU0hBMjU2IGJlZm9yZSBiY3J5cHQpIG9yIGFuIG9iamVjdCB3aXRoXG4vLyBwcm9wZXJ0aWVzIGBkaWdlc3RgIGFuZCBgYWxnb3JpdGhtYCAoaW4gd2hpY2ggY2FzZSB3ZSBiY3J5cHRcbi8vIGBwYXNzd29yZC5kaWdlc3RgKS5cbi8vXG4vLyBUaGUgdXNlciBwYXJhbWV0ZXIgbmVlZHMgYXQgbGVhc3QgdXNlci5faWQgYW5kIHVzZXIuc2VydmljZXNcbkFjY291bnRzLl9jaGVja1Bhc3N3b3JkVXNlckZpZWxkcyA9IHtfaWQ6IDEsIHNlcnZpY2VzOiAxfTtcbi8vXG5BY2NvdW50cy5fY2hlY2tQYXNzd29yZCA9ICh1c2VyLCBwYXNzd29yZCkgPT4ge1xuICBjb25zdCByZXN1bHQgPSB7XG4gICAgdXNlcklkOiB1c2VyLl9pZFxuICB9O1xuXG4gIGNvbnN0IGZvcm1hdHRlZFBhc3N3b3JkID0gZ2V0UGFzc3dvcmRTdHJpbmcocGFzc3dvcmQpO1xuICBjb25zdCBoYXNoID0gdXNlci5zZXJ2aWNlcy5wYXNzd29yZC5iY3J5cHQ7XG4gIGNvbnN0IGhhc2hSb3VuZHMgPSBnZXRSb3VuZHNGcm9tQmNyeXB0SGFzaChoYXNoKTtcblxuICBpZiAoISBiY3J5cHRDb21wYXJlKGZvcm1hdHRlZFBhc3N3b3JkLCBoYXNoKSkge1xuICAgIHJlc3VsdC5lcnJvciA9IEFjY291bnRzLl9oYW5kbGVFcnJvcihcIkluY29ycmVjdCBwYXNzd29yZFwiLCBmYWxzZSk7XG4gIH0gZWxzZSBpZiAoaGFzaCAmJiBBY2NvdW50cy5fYmNyeXB0Um91bmRzKCkgIT0gaGFzaFJvdW5kcykge1xuICAgIC8vIFRoZSBwYXNzd29yZCBjaGVja3Mgb3V0LCBidXQgdGhlIHVzZXIncyBiY3J5cHQgaGFzaCBuZWVkcyB0byBiZSB1cGRhdGVkLlxuICAgIE1ldGVvci5kZWZlcigoKSA9PiB7XG4gICAgICBNZXRlb3IudXNlcnMudXBkYXRlKHsgX2lkOiB1c2VyLl9pZCB9LCB7XG4gICAgICAgICRzZXQ6IHtcbiAgICAgICAgICAnc2VydmljZXMucGFzc3dvcmQuYmNyeXB0JzpcbiAgICAgICAgICAgIGJjcnlwdEhhc2goZm9ybWF0dGVkUGFzc3dvcmQsIEFjY291bnRzLl9iY3J5cHRSb3VuZHMoKSlcbiAgICAgICAgfVxuICAgICAgfSk7XG4gICAgfSk7XG4gIH1cblxuICByZXR1cm4gcmVzdWx0O1xufTtcbmNvbnN0IGNoZWNrUGFzc3dvcmQgPSBBY2NvdW50cy5fY2hlY2tQYXNzd29yZDtcblxuLy8vXG4vLy8gTE9HSU5cbi8vL1xuXG5cbi8qKlxuICogQHN1bW1hcnkgRmluZHMgdGhlIHVzZXIgd2l0aCB0aGUgc3BlY2lmaWVkIHVzZXJuYW1lLlxuICogRmlyc3QgdHJpZXMgdG8gbWF0Y2ggdXNlcm5hbWUgY2FzZSBzZW5zaXRpdmVseTsgaWYgdGhhdCBmYWlscywgaXRcbiAqIHRyaWVzIGNhc2UgaW5zZW5zaXRpdmVseTsgYnV0IGlmIG1vcmUgdGhhbiBvbmUgdXNlciBtYXRjaGVzIHRoZSBjYXNlXG4gKiBpbnNlbnNpdGl2ZSBzZWFyY2gsIGl0IHJldHVybnMgbnVsbC5cbiAqIEBsb2N1cyBTZXJ2ZXJcbiAqIEBwYXJhbSB7U3RyaW5nfSB1c2VybmFtZSBUaGUgdXNlcm5hbWUgdG8gbG9vayBmb3JcbiAqIEBwYXJhbSB7T2JqZWN0fSBbb3B0aW9uc11cbiAqIEBwYXJhbSB7TW9uZ29GaWVsZFNwZWNpZmllcn0gb3B0aW9ucy5maWVsZHMgRGljdGlvbmFyeSBvZiBmaWVsZHMgdG8gcmV0dXJuIG9yIGV4Y2x1ZGUuXG4gKiBAcmV0dXJucyB7T2JqZWN0fSBBIHVzZXIgaWYgZm91bmQsIGVsc2UgbnVsbFxuICogQGltcG9ydEZyb21QYWNrYWdlIGFjY291bnRzLWJhc2VcbiAqL1xuQWNjb3VudHMuZmluZFVzZXJCeVVzZXJuYW1lID1cbiAgKHVzZXJuYW1lLCBvcHRpb25zKSA9PiBBY2NvdW50cy5fZmluZFVzZXJCeVF1ZXJ5KHsgdXNlcm5hbWUgfSwgb3B0aW9ucyk7XG5cbi8qKlxuICogQHN1bW1hcnkgRmluZHMgdGhlIHVzZXIgd2l0aCB0aGUgc3BlY2lmaWVkIGVtYWlsLlxuICogRmlyc3QgdHJpZXMgdG8gbWF0Y2ggZW1haWwgY2FzZSBzZW5zaXRpdmVseTsgaWYgdGhhdCBmYWlscywgaXRcbiAqIHRyaWVzIGNhc2UgaW5zZW5zaXRpdmVseTsgYnV0IGlmIG1vcmUgdGhhbiBvbmUgdXNlciBtYXRjaGVzIHRoZSBjYXNlXG4gKiBpbnNlbnNpdGl2ZSBzZWFyY2gsIGl0IHJldHVybnMgbnVsbC5cbiAqIEBsb2N1cyBTZXJ2ZXJcbiAqIEBwYXJhbSB7U3RyaW5nfSBlbWFpbCBUaGUgZW1haWwgYWRkcmVzcyB0byBsb29rIGZvclxuICogQHBhcmFtIHtPYmplY3R9IFtvcHRpb25zXVxuICogQHBhcmFtIHtNb25nb0ZpZWxkU3BlY2lmaWVyfSBvcHRpb25zLmZpZWxkcyBEaWN0aW9uYXJ5IG9mIGZpZWxkcyB0byByZXR1cm4gb3IgZXhjbHVkZS5cbiAqIEByZXR1cm5zIHtPYmplY3R9IEEgdXNlciBpZiBmb3VuZCwgZWxzZSBudWxsXG4gKiBAaW1wb3J0RnJvbVBhY2thZ2UgYWNjb3VudHMtYmFzZVxuICovXG5BY2NvdW50cy5maW5kVXNlckJ5RW1haWwgPVxuICAoZW1haWwsIG9wdGlvbnMpID0+IEFjY291bnRzLl9maW5kVXNlckJ5UXVlcnkoeyBlbWFpbCB9LCBvcHRpb25zKTtcblxuLy8gWFhYIG1heWJlIHRoaXMgYmVsb25ncyBpbiB0aGUgY2hlY2sgcGFja2FnZVxuY29uc3QgTm9uRW1wdHlTdHJpbmcgPSBNYXRjaC5XaGVyZSh4ID0+IHtcbiAgY2hlY2soeCwgU3RyaW5nKTtcbiAgcmV0dXJuIHgubGVuZ3RoID4gMDtcbn0pO1xuXG5jb25zdCBwYXNzd29yZFZhbGlkYXRvciA9IE1hdGNoLk9uZU9mKFxuICBNYXRjaC5XaGVyZShzdHIgPT4gTWF0Y2gudGVzdChzdHIsIFN0cmluZykgJiYgc3RyLmxlbmd0aCA8PSBNZXRlb3Iuc2V0dGluZ3M/LnBhY2thZ2VzPy5hY2NvdW50cz8ucGFzc3dvcmRNYXhMZW5ndGggfHwgMjU2KSwge1xuICAgIGRpZ2VzdDogTWF0Y2guV2hlcmUoc3RyID0+IE1hdGNoLnRlc3Qoc3RyLCBTdHJpbmcpICYmIHN0ci5sZW5ndGggPT09IDY0KSxcbiAgICBhbGdvcml0aG06IE1hdGNoLk9uZU9mKCdzaGEtMjU2JylcbiAgfVxuKTtcblxuLy8gSGFuZGxlciB0byBsb2dpbiB3aXRoIGEgcGFzc3dvcmQuXG4vL1xuLy8gVGhlIE1ldGVvciBjbGllbnQgc2V0cyBvcHRpb25zLnBhc3N3b3JkIHRvIGFuIG9iamVjdCB3aXRoIGtleXNcbi8vICdkaWdlc3QnIChzZXQgdG8gU0hBMjU2KHBhc3N3b3JkKSkgYW5kICdhbGdvcml0aG0nIChcInNoYS0yNTZcIikuXG4vL1xuLy8gRm9yIG90aGVyIEREUCBjbGllbnRzIHdoaWNoIGRvbid0IGhhdmUgYWNjZXNzIHRvIFNIQSwgdGhlIGhhbmRsZXJcbi8vIGFsc28gYWNjZXB0cyB0aGUgcGxhaW50ZXh0IHBhc3N3b3JkIGluIG9wdGlvbnMucGFzc3dvcmQgYXMgYSBzdHJpbmcuXG4vL1xuLy8gKEl0IG1pZ2h0IGJlIG5pY2UgaWYgc2VydmVycyBjb3VsZCB0dXJuIHRoZSBwbGFpbnRleHQgcGFzc3dvcmRcbi8vIG9wdGlvbiBvZmYuIE9yIG1heWJlIGl0IHNob3VsZCBiZSBvcHQtaW4sIG5vdCBvcHQtb3V0P1xuLy8gQWNjb3VudHMuY29uZmlnIG9wdGlvbj8pXG4vL1xuLy8gTm90ZSB0aGF0IG5laXRoZXIgcGFzc3dvcmQgb3B0aW9uIGlzIHNlY3VyZSB3aXRob3V0IFNTTC5cbi8vXG5BY2NvdW50cy5yZWdpc3RlckxvZ2luSGFuZGxlcihcInBhc3N3b3JkXCIsIG9wdGlvbnMgPT4ge1xuICBpZiAoIW9wdGlvbnMucGFzc3dvcmQpXG4gICAgcmV0dXJuIHVuZGVmaW5lZDsgLy8gZG9uJ3QgaGFuZGxlXG5cbiAgY2hlY2sob3B0aW9ucywge1xuICAgIHVzZXI6IEFjY291bnRzLl91c2VyUXVlcnlWYWxpZGF0b3IsXG4gICAgcGFzc3dvcmQ6IHBhc3N3b3JkVmFsaWRhdG9yLFxuICAgIGNvZGU6IE1hdGNoLk9wdGlvbmFsKE5vbkVtcHR5U3RyaW5nKSxcbiAgfSk7XG5cblxuICBjb25zdCB1c2VyID0gQWNjb3VudHMuX2ZpbmRVc2VyQnlRdWVyeShvcHRpb25zLnVzZXIsIHtmaWVsZHM6IHtcbiAgICBzZXJ2aWNlczogMSxcbiAgICAuLi5BY2NvdW50cy5fY2hlY2tQYXNzd29yZFVzZXJGaWVsZHMsXG4gIH19KTtcbiAgaWYgKCF1c2VyKSB7XG4gICAgQWNjb3VudHMuX2hhbmRsZUVycm9yKFwiVXNlciBub3QgZm91bmRcIik7XG4gIH1cblxuXG4gIGlmICghdXNlci5zZXJ2aWNlcyB8fCAhdXNlci5zZXJ2aWNlcy5wYXNzd29yZCB8fFxuICAgICAgIXVzZXIuc2VydmljZXMucGFzc3dvcmQuYmNyeXB0KSB7XG4gICAgQWNjb3VudHMuX2hhbmRsZUVycm9yKFwiVXNlciBoYXMgbm8gcGFzc3dvcmQgc2V0XCIpO1xuICB9XG5cbiAgY29uc3QgcmVzdWx0ID0gY2hlY2tQYXNzd29yZCh1c2VyLCBvcHRpb25zLnBhc3N3b3JkKTtcbiAgLy8gVGhpcyBtZXRob2QgaXMgYWRkZWQgYnkgdGhlIHBhY2thZ2UgYWNjb3VudHMtMmZhXG4gIC8vIEZpcnN0IHRoZSBsb2dpbiBpcyB2YWxpZGF0ZWQsIHRoZW4gdGhlIGNvZGUgc2l0dWF0aW9uIGlzIGNoZWNrZWRcbiAgaWYgKFxuICAgICFyZXN1bHQuZXJyb3IgJiZcbiAgICBBY2NvdW50cy5fY2hlY2syZmFFbmFibGVkPy4odXNlcilcbiAgKSB7XG4gICAgaWYgKCFvcHRpb25zLmNvZGUpIHtcbiAgICAgIEFjY291bnRzLl9oYW5kbGVFcnJvcignMkZBIGNvZGUgbXVzdCBiZSBpbmZvcm1lZCcsIHRydWUsICduby0yZmEtY29kZScpO1xuICAgIH1cbiAgICBpZiAoXG4gICAgICAhQWNjb3VudHMuX2lzVG9rZW5WYWxpZChcbiAgICAgICAgdXNlci5zZXJ2aWNlcy50d29GYWN0b3JBdXRoZW50aWNhdGlvbi5zZWNyZXQsXG4gICAgICAgIG9wdGlvbnMuY29kZVxuICAgICAgKVxuICAgICkge1xuICAgICAgQWNjb3VudHMuX2hhbmRsZUVycm9yKCdJbnZhbGlkIDJGQSBjb2RlJywgdHJ1ZSwgJ2ludmFsaWQtMmZhLWNvZGUnKTtcbiAgICB9XG4gIH1cblxuICByZXR1cm4gcmVzdWx0O1xufSk7XG5cbi8vL1xuLy8vIENIQU5HSU5HXG4vLy9cblxuLyoqXG4gKiBAc3VtbWFyeSBDaGFuZ2UgYSB1c2VyJ3MgdXNlcm5hbWUuIFVzZSB0aGlzIGluc3RlYWQgb2YgdXBkYXRpbmcgdGhlXG4gKiBkYXRhYmFzZSBkaXJlY3RseS4gVGhlIG9wZXJhdGlvbiB3aWxsIGZhaWwgaWYgdGhlcmUgaXMgYW4gZXhpc3RpbmcgdXNlclxuICogd2l0aCBhIHVzZXJuYW1lIG9ubHkgZGlmZmVyaW5nIGluIGNhc2UuXG4gKiBAbG9jdXMgU2VydmVyXG4gKiBAcGFyYW0ge1N0cmluZ30gdXNlcklkIFRoZSBJRCBvZiB0aGUgdXNlciB0byB1cGRhdGUuXG4gKiBAcGFyYW0ge1N0cmluZ30gbmV3VXNlcm5hbWUgQSBuZXcgdXNlcm5hbWUgZm9yIHRoZSB1c2VyLlxuICogQGltcG9ydEZyb21QYWNrYWdlIGFjY291bnRzLWJhc2VcbiAqL1xuQWNjb3VudHMuc2V0VXNlcm5hbWUgPSAodXNlcklkLCBuZXdVc2VybmFtZSkgPT4ge1xuICBjaGVjayh1c2VySWQsIE5vbkVtcHR5U3RyaW5nKTtcbiAgY2hlY2sobmV3VXNlcm5hbWUsIE5vbkVtcHR5U3RyaW5nKTtcblxuICBjb25zdCB1c2VyID0gZ2V0VXNlckJ5SWQodXNlcklkLCB7ZmllbGRzOiB7XG4gICAgdXNlcm5hbWU6IDEsXG4gIH19KTtcbiAgaWYgKCF1c2VyKSB7XG4gICAgQWNjb3VudHMuX2hhbmRsZUVycm9yKFwiVXNlciBub3QgZm91bmRcIik7XG4gIH1cblxuICBjb25zdCBvbGRVc2VybmFtZSA9IHVzZXIudXNlcm5hbWU7XG5cbiAgLy8gUGVyZm9ybSBhIGNhc2UgaW5zZW5zaXRpdmUgY2hlY2sgZm9yIGR1cGxpY2F0ZXMgYmVmb3JlIHVwZGF0ZVxuICBBY2NvdW50cy5fY2hlY2tGb3JDYXNlSW5zZW5zaXRpdmVEdXBsaWNhdGVzKCd1c2VybmFtZScsXG4gICAgJ1VzZXJuYW1lJywgbmV3VXNlcm5hbWUsIHVzZXIuX2lkKTtcblxuICBNZXRlb3IudXNlcnMudXBkYXRlKHtfaWQ6IHVzZXIuX2lkfSwgeyRzZXQ6IHt1c2VybmFtZTogbmV3VXNlcm5hbWV9fSk7XG5cbiAgLy8gUGVyZm9ybSBhbm90aGVyIGNoZWNrIGFmdGVyIHVwZGF0ZSwgaW4gY2FzZSBhIG1hdGNoaW5nIHVzZXIgaGFzIGJlZW5cbiAgLy8gaW5zZXJ0ZWQgaW4gdGhlIG1lYW50aW1lXG4gIHRyeSB7XG4gICAgQWNjb3VudHMuX2NoZWNrRm9yQ2FzZUluc2Vuc2l0aXZlRHVwbGljYXRlcygndXNlcm5hbWUnLFxuICAgICAgJ1VzZXJuYW1lJywgbmV3VXNlcm5hbWUsIHVzZXIuX2lkKTtcbiAgfSBjYXRjaCAoZXgpIHtcbiAgICAvLyBVbmRvIHVwZGF0ZSBpZiB0aGUgY2hlY2sgZmFpbHNcbiAgICBNZXRlb3IudXNlcnMudXBkYXRlKHtfaWQ6IHVzZXIuX2lkfSwgeyRzZXQ6IHt1c2VybmFtZTogb2xkVXNlcm5hbWV9fSk7XG4gICAgdGhyb3cgZXg7XG4gIH1cbn07XG5cbi8vIExldCB0aGUgdXNlciBjaGFuZ2UgdGhlaXIgb3duIHBhc3N3b3JkIGlmIHRoZXkga25vdyB0aGUgb2xkXG4vLyBwYXNzd29yZC4gYG9sZFBhc3N3b3JkYCBhbmQgYG5ld1Bhc3N3b3JkYCBzaG91bGQgYmUgb2JqZWN0cyB3aXRoIGtleXNcbi8vIGBkaWdlc3RgIGFuZCBgYWxnb3JpdGhtYCAocmVwcmVzZW50aW5nIHRoZSBTSEEyNTYgb2YgdGhlIHBhc3N3b3JkKS5cbk1ldGVvci5tZXRob2RzKHtjaGFuZ2VQYXNzd29yZDogZnVuY3Rpb24gKG9sZFBhc3N3b3JkLCBuZXdQYXNzd29yZCkge1xuICBjaGVjayhvbGRQYXNzd29yZCwgcGFzc3dvcmRWYWxpZGF0b3IpO1xuICBjaGVjayhuZXdQYXNzd29yZCwgcGFzc3dvcmRWYWxpZGF0b3IpO1xuXG4gIGlmICghdGhpcy51c2VySWQpIHtcbiAgICB0aHJvdyBuZXcgTWV0ZW9yLkVycm9yKDQwMSwgXCJNdXN0IGJlIGxvZ2dlZCBpblwiKTtcbiAgfVxuXG4gIGNvbnN0IHVzZXIgPSBnZXRVc2VyQnlJZCh0aGlzLnVzZXJJZCwge2ZpZWxkczoge1xuICAgIHNlcnZpY2VzOiAxLFxuICAgIC4uLkFjY291bnRzLl9jaGVja1Bhc3N3b3JkVXNlckZpZWxkcyxcbiAgfX0pO1xuICBpZiAoIXVzZXIpIHtcbiAgICBBY2NvdW50cy5faGFuZGxlRXJyb3IoXCJVc2VyIG5vdCBmb3VuZFwiKTtcbiAgfVxuXG4gIGlmICghdXNlci5zZXJ2aWNlcyB8fCAhdXNlci5zZXJ2aWNlcy5wYXNzd29yZCB8fCAhdXNlci5zZXJ2aWNlcy5wYXNzd29yZC5iY3J5cHQpIHtcbiAgICBBY2NvdW50cy5faGFuZGxlRXJyb3IoXCJVc2VyIGhhcyBubyBwYXNzd29yZCBzZXRcIik7XG4gIH1cblxuICBjb25zdCByZXN1bHQgPSBjaGVja1Bhc3N3b3JkKHVzZXIsIG9sZFBhc3N3b3JkKTtcbiAgaWYgKHJlc3VsdC5lcnJvcikge1xuICAgIHRocm93IHJlc3VsdC5lcnJvcjtcbiAgfVxuXG4gIGNvbnN0IGhhc2hlZCA9IGhhc2hQYXNzd29yZChuZXdQYXNzd29yZCk7XG5cbiAgLy8gSXQgd291bGQgYmUgYmV0dGVyIGlmIHRoaXMgcmVtb3ZlZCBBTEwgZXhpc3RpbmcgdG9rZW5zIGFuZCByZXBsYWNlZFxuICAvLyB0aGUgdG9rZW4gZm9yIHRoZSBjdXJyZW50IGNvbm5lY3Rpb24gd2l0aCBhIG5ldyBvbmUsIGJ1dCB0aGF0IHdvdWxkXG4gIC8vIGJlIHRyaWNreSwgc28gd2UnbGwgc2V0dGxlIGZvciBqdXN0IHJlcGxhY2luZyBhbGwgdG9rZW5zIG90aGVyIHRoYW5cbiAgLy8gdGhlIG9uZSBmb3IgdGhlIGN1cnJlbnQgY29ubmVjdGlvbi5cbiAgY29uc3QgY3VycmVudFRva2VuID0gQWNjb3VudHMuX2dldExvZ2luVG9rZW4odGhpcy5jb25uZWN0aW9uLmlkKTtcbiAgTWV0ZW9yLnVzZXJzLnVwZGF0ZShcbiAgICB7IF9pZDogdGhpcy51c2VySWQgfSxcbiAgICB7XG4gICAgICAkc2V0OiB7ICdzZXJ2aWNlcy5wYXNzd29yZC5iY3J5cHQnOiBoYXNoZWQgfSxcbiAgICAgICRwdWxsOiB7XG4gICAgICAgICdzZXJ2aWNlcy5yZXN1bWUubG9naW5Ub2tlbnMnOiB7IGhhc2hlZFRva2VuOiB7ICRuZTogY3VycmVudFRva2VuIH0gfVxuICAgICAgfSxcbiAgICAgICR1bnNldDogeyAnc2VydmljZXMucGFzc3dvcmQucmVzZXQnOiAxIH1cbiAgICB9XG4gICk7XG5cbiAgcmV0dXJuIHtwYXNzd29yZENoYW5nZWQ6IHRydWV9O1xufX0pO1xuXG5cbi8vIEZvcmNlIGNoYW5nZSB0aGUgdXNlcnMgcGFzc3dvcmQuXG5cbi8qKlxuICogQHN1bW1hcnkgRm9yY2libHkgY2hhbmdlIHRoZSBwYXNzd29yZCBmb3IgYSB1c2VyLlxuICogQGxvY3VzIFNlcnZlclxuICogQHBhcmFtIHtTdHJpbmd9IHVzZXJJZCBUaGUgaWQgb2YgdGhlIHVzZXIgdG8gdXBkYXRlLlxuICogQHBhcmFtIHtTdHJpbmd9IG5ld1Bhc3N3b3JkIEEgbmV3IHBhc3N3b3JkIGZvciB0aGUgdXNlci5cbiAqIEBwYXJhbSB7T2JqZWN0fSBbb3B0aW9uc11cbiAqIEBwYXJhbSB7T2JqZWN0fSBvcHRpb25zLmxvZ291dCBMb2dvdXQgYWxsIGN1cnJlbnQgY29ubmVjdGlvbnMgd2l0aCB0aGlzIHVzZXJJZCAoZGVmYXVsdDogdHJ1ZSlcbiAqIEBpbXBvcnRGcm9tUGFja2FnZSBhY2NvdW50cy1iYXNlXG4gKi9cbkFjY291bnRzLnNldFBhc3N3b3JkID0gKHVzZXJJZCwgbmV3UGxhaW50ZXh0UGFzc3dvcmQsIG9wdGlvbnMpID0+IHtcbiAgY2hlY2sodXNlcklkLCBTdHJpbmcpXG4gIGNoZWNrKG5ld1BsYWludGV4dFBhc3N3b3JkLCBNYXRjaC5XaGVyZShzdHIgPT4gTWF0Y2gudGVzdChzdHIsIFN0cmluZykgJiYgc3RyLmxlbmd0aCA8PSBNZXRlb3Iuc2V0dGluZ3M/LnBhY2thZ2VzPy5hY2NvdW50cz8ucGFzc3dvcmRNYXhMZW5ndGggfHwgMjU2KSlcbiAgY2hlY2sob3B0aW9ucywgTWF0Y2guTWF5YmUoeyBsb2dvdXQ6IEJvb2xlYW4gfSkpXG4gIG9wdGlvbnMgPSB7IGxvZ291dDogdHJ1ZSAsIC4uLm9wdGlvbnMgfTtcblxuICBjb25zdCB1c2VyID0gZ2V0VXNlckJ5SWQodXNlcklkLCB7ZmllbGRzOiB7X2lkOiAxfX0pO1xuICBpZiAoIXVzZXIpIHtcbiAgICB0aHJvdyBuZXcgTWV0ZW9yLkVycm9yKDQwMywgXCJVc2VyIG5vdCBmb3VuZFwiKTtcbiAgfVxuXG4gIGNvbnN0IHVwZGF0ZSA9IHtcbiAgICAkdW5zZXQ6IHtcbiAgICAgICdzZXJ2aWNlcy5wYXNzd29yZC5yZXNldCc6IDFcbiAgICB9LFxuICAgICRzZXQ6IHsnc2VydmljZXMucGFzc3dvcmQuYmNyeXB0JzogaGFzaFBhc3N3b3JkKG5ld1BsYWludGV4dFBhc3N3b3JkKX1cbiAgfTtcblxuICBpZiAob3B0aW9ucy5sb2dvdXQpIHtcbiAgICB1cGRhdGUuJHVuc2V0WydzZXJ2aWNlcy5yZXN1bWUubG9naW5Ub2tlbnMnXSA9IDE7XG4gIH1cblxuICBNZXRlb3IudXNlcnMudXBkYXRlKHtfaWQ6IHVzZXIuX2lkfSwgdXBkYXRlKTtcbn07XG5cblxuLy8vXG4vLy8gUkVTRVRUSU5HIFZJQSBFTUFJTFxuLy8vXG5cbi8vIFV0aWxpdHkgZm9yIHBsdWNraW5nIGFkZHJlc3NlcyBmcm9tIGVtYWlsc1xuY29uc3QgcGx1Y2tBZGRyZXNzZXMgPSAoZW1haWxzID0gW10pID0+IGVtYWlscy5tYXAoZW1haWwgPT4gZW1haWwuYWRkcmVzcyk7XG5cbi8vIE1ldGhvZCBjYWxsZWQgYnkgYSB1c2VyIHRvIHJlcXVlc3QgYSBwYXNzd29yZCByZXNldCBlbWFpbC4gVGhpcyBpc1xuLy8gdGhlIHN0YXJ0IG9mIHRoZSByZXNldCBwcm9jZXNzLlxuTWV0ZW9yLm1ldGhvZHMoe2ZvcmdvdFBhc3N3b3JkOiBvcHRpb25zID0+IHtcbiAgY2hlY2sob3B0aW9ucywge2VtYWlsOiBTdHJpbmd9KVxuXG4gIGNvbnN0IHVzZXIgPSBBY2NvdW50cy5maW5kVXNlckJ5RW1haWwob3B0aW9ucy5lbWFpbCwgeyBmaWVsZHM6IHsgZW1haWxzOiAxIH0gfSk7XG5cbiAgaWYgKCF1c2VyKSB7XG4gICAgQWNjb3VudHMuX2hhbmRsZUVycm9yKFwiVXNlciBub3QgZm91bmRcIik7XG4gIH1cblxuICBjb25zdCBlbWFpbHMgPSBwbHVja0FkZHJlc3Nlcyh1c2VyLmVtYWlscyk7XG4gIGNvbnN0IGNhc2VTZW5zaXRpdmVFbWFpbCA9IGVtYWlscy5maW5kKFxuICAgIGVtYWlsID0+IGVtYWlsLnRvTG93ZXJDYXNlKCkgPT09IG9wdGlvbnMuZW1haWwudG9Mb3dlckNhc2UoKVxuICApO1xuXG4gIEFjY291bnRzLnNlbmRSZXNldFBhc3N3b3JkRW1haWwodXNlci5faWQsIGNhc2VTZW5zaXRpdmVFbWFpbCk7XG59fSk7XG5cbi8qKlxuICogQHN1bW1hcnkgR2VuZXJhdGVzIGEgcmVzZXQgdG9rZW4gYW5kIHNhdmVzIGl0IGludG8gdGhlIGRhdGFiYXNlLlxuICogQGxvY3VzIFNlcnZlclxuICogQHBhcmFtIHtTdHJpbmd9IHVzZXJJZCBUaGUgaWQgb2YgdGhlIHVzZXIgdG8gZ2VuZXJhdGUgdGhlIHJlc2V0IHRva2VuIGZvci5cbiAqIEBwYXJhbSB7U3RyaW5nfSBlbWFpbCBXaGljaCBhZGRyZXNzIG9mIHRoZSB1c2VyIHRvIGdlbmVyYXRlIHRoZSByZXNldCB0b2tlbiBmb3IuIFRoaXMgYWRkcmVzcyBtdXN0IGJlIGluIHRoZSB1c2VyJ3MgYGVtYWlsc2AgbGlzdC4gSWYgYG51bGxgLCBkZWZhdWx0cyB0byB0aGUgZmlyc3QgZW1haWwgaW4gdGhlIGxpc3QuXG4gKiBAcGFyYW0ge1N0cmluZ30gcmVhc29uIGByZXNldFBhc3N3b3JkYCBvciBgZW5yb2xsQWNjb3VudGAuXG4gKiBAcGFyYW0ge09iamVjdH0gW2V4dHJhVG9rZW5EYXRhXSBPcHRpb25hbCBhZGRpdGlvbmFsIGRhdGEgdG8gYmUgYWRkZWQgaW50byB0aGUgdG9rZW4gcmVjb3JkLlxuICogQHJldHVybnMge09iamVjdH0gT2JqZWN0IHdpdGgge2VtYWlsLCB1c2VyLCB0b2tlbn0gdmFsdWVzLlxuICogQGltcG9ydEZyb21QYWNrYWdlIGFjY291bnRzLWJhc2VcbiAqL1xuQWNjb3VudHMuZ2VuZXJhdGVSZXNldFRva2VuID0gKHVzZXJJZCwgZW1haWwsIHJlYXNvbiwgZXh0cmFUb2tlbkRhdGEpID0+IHtcbiAgLy8gTWFrZSBzdXJlIHRoZSB1c2VyIGV4aXN0cywgYW5kIGVtYWlsIGlzIG9uZSBvZiB0aGVpciBhZGRyZXNzZXMuXG4gIC8vIERvbid0IGxpbWl0IHRoZSBmaWVsZHMgaW4gdGhlIHVzZXIgb2JqZWN0IHNpbmNlIHRoZSB1c2VyIGlzIHJldHVybmVkXG4gIC8vIGJ5IHRoZSBmdW5jdGlvbiBhbmQgc29tZSBvdGhlciBmaWVsZHMgbWlnaHQgYmUgdXNlZCBlbHNld2hlcmUuXG4gIGNvbnN0IHVzZXIgPSBnZXRVc2VyQnlJZCh1c2VySWQpO1xuICBpZiAoIXVzZXIpIHtcbiAgICBBY2NvdW50cy5faGFuZGxlRXJyb3IoXCJDYW4ndCBmaW5kIHVzZXJcIik7XG4gIH1cblxuICAvLyBwaWNrIHRoZSBmaXJzdCBlbWFpbCBpZiB3ZSB3ZXJlbid0IHBhc3NlZCBhbiBlbWFpbC5cbiAgaWYgKCFlbWFpbCAmJiB1c2VyLmVtYWlscyAmJiB1c2VyLmVtYWlsc1swXSkge1xuICAgIGVtYWlsID0gdXNlci5lbWFpbHNbMF0uYWRkcmVzcztcbiAgfVxuXG4gIC8vIG1ha2Ugc3VyZSB3ZSBoYXZlIGEgdmFsaWQgZW1haWxcbiAgaWYgKCFlbWFpbCB8fFxuICAgICEocGx1Y2tBZGRyZXNzZXModXNlci5lbWFpbHMpLmluY2x1ZGVzKGVtYWlsKSkpIHtcbiAgICBBY2NvdW50cy5faGFuZGxlRXJyb3IoXCJObyBzdWNoIGVtYWlsIGZvciB1c2VyLlwiKTtcbiAgfVxuXG4gIGNvbnN0IHRva2VuID0gUmFuZG9tLnNlY3JldCgpO1xuICBjb25zdCB0b2tlblJlY29yZCA9IHtcbiAgICB0b2tlbixcbiAgICBlbWFpbCxcbiAgICB3aGVuOiBuZXcgRGF0ZSgpXG4gIH07XG5cbiAgaWYgKHJlYXNvbiA9PT0gJ3Jlc2V0UGFzc3dvcmQnKSB7XG4gICAgdG9rZW5SZWNvcmQucmVhc29uID0gJ3Jlc2V0JztcbiAgfSBlbHNlIGlmIChyZWFzb24gPT09ICdlbnJvbGxBY2NvdW50Jykge1xuICAgIHRva2VuUmVjb3JkLnJlYXNvbiA9ICdlbnJvbGwnO1xuICB9IGVsc2UgaWYgKHJlYXNvbikge1xuICAgIC8vIGZhbGxiYWNrIHNvIHRoYXQgdGhpcyBmdW5jdGlvbiBjYW4gYmUgdXNlZCBmb3IgdW5rbm93biByZWFzb25zIGFzIHdlbGxcbiAgICB0b2tlblJlY29yZC5yZWFzb24gPSByZWFzb247XG4gIH1cblxuICBpZiAoZXh0cmFUb2tlbkRhdGEpIHtcbiAgICBPYmplY3QuYXNzaWduKHRva2VuUmVjb3JkLCBleHRyYVRva2VuRGF0YSk7XG4gIH1cbiAgLy8gaWYgdGhpcyBtZXRob2QgaXMgY2FsbGVkIGZyb20gdGhlIGVucm9sbCBhY2NvdW50IHdvcmstZmxvdyB0aGVuXG4gIC8vIHN0b3JlIHRoZSB0b2tlbiByZWNvcmQgaW4gJ3NlcnZpY2VzLnBhc3N3b3JkLmVucm9sbCcgZGIgZmllbGRcbiAgLy8gZWxzZSBzdG9yZSB0aGUgdG9rZW4gcmVjb3JkIGluIGluICdzZXJ2aWNlcy5wYXNzd29yZC5yZXNldCcgZGIgZmllbGRcbiAgaWYocmVhc29uID09PSAnZW5yb2xsQWNjb3VudCcpIHtcbiAgICBNZXRlb3IudXNlcnMudXBkYXRlKHtfaWQ6IHVzZXIuX2lkfSwge1xuICAgICAgJHNldCA6IHtcbiAgICAgICAgJ3NlcnZpY2VzLnBhc3N3b3JkLmVucm9sbCc6IHRva2VuUmVjb3JkXG4gICAgICB9XG4gICAgfSk7XG4gICAgLy8gYmVmb3JlIHBhc3NpbmcgdG8gdGVtcGxhdGUsIHVwZGF0ZSB1c2VyIG9iamVjdCB3aXRoIG5ldyB0b2tlblxuICAgIE1ldGVvci5fZW5zdXJlKHVzZXIsICdzZXJ2aWNlcycsICdwYXNzd29yZCcpLmVucm9sbCA9IHRva2VuUmVjb3JkO1xuICB9IGVsc2Uge1xuICAgIE1ldGVvci51c2Vycy51cGRhdGUoe19pZDogdXNlci5faWR9LCB7XG4gICAgICAkc2V0IDoge1xuICAgICAgICAnc2VydmljZXMucGFzc3dvcmQucmVzZXQnOiB0b2tlblJlY29yZFxuICAgICAgfVxuICAgIH0pO1xuICAgIC8vIGJlZm9yZSBwYXNzaW5nIHRvIHRlbXBsYXRlLCB1cGRhdGUgdXNlciBvYmplY3Qgd2l0aCBuZXcgdG9rZW5cbiAgICBNZXRlb3IuX2Vuc3VyZSh1c2VyLCAnc2VydmljZXMnLCAncGFzc3dvcmQnKS5yZXNldCA9IHRva2VuUmVjb3JkO1xuICB9XG5cbiAgcmV0dXJuIHtlbWFpbCwgdXNlciwgdG9rZW59O1xufTtcblxuLyoqXG4gKiBAc3VtbWFyeSBHZW5lcmF0ZXMgYW4gZS1tYWlsIHZlcmlmaWNhdGlvbiB0b2tlbiBhbmQgc2F2ZXMgaXQgaW50byB0aGUgZGF0YWJhc2UuXG4gKiBAbG9jdXMgU2VydmVyXG4gKiBAcGFyYW0ge1N0cmluZ30gdXNlcklkIFRoZSBpZCBvZiB0aGUgdXNlciB0byBnZW5lcmF0ZSB0aGUgIGUtbWFpbCB2ZXJpZmljYXRpb24gdG9rZW4gZm9yLlxuICogQHBhcmFtIHtTdHJpbmd9IGVtYWlsIFdoaWNoIGFkZHJlc3Mgb2YgdGhlIHVzZXIgdG8gZ2VuZXJhdGUgdGhlIGUtbWFpbCB2ZXJpZmljYXRpb24gdG9rZW4gZm9yLiBUaGlzIGFkZHJlc3MgbXVzdCBiZSBpbiB0aGUgdXNlcidzIGBlbWFpbHNgIGxpc3QuIElmIGBudWxsYCwgZGVmYXVsdHMgdG8gdGhlIGZpcnN0IHVudmVyaWZpZWQgZW1haWwgaW4gdGhlIGxpc3QuXG4gKiBAcGFyYW0ge09iamVjdH0gW2V4dHJhVG9rZW5EYXRhXSBPcHRpb25hbCBhZGRpdGlvbmFsIGRhdGEgdG8gYmUgYWRkZWQgaW50byB0aGUgdG9rZW4gcmVjb3JkLlxuICogQHJldHVybnMge09iamVjdH0gT2JqZWN0IHdpdGgge2VtYWlsLCB1c2VyLCB0b2tlbn0gdmFsdWVzLlxuICogQGltcG9ydEZyb21QYWNrYWdlIGFjY291bnRzLWJhc2VcbiAqL1xuQWNjb3VudHMuZ2VuZXJhdGVWZXJpZmljYXRpb25Ub2tlbiA9ICh1c2VySWQsIGVtYWlsLCBleHRyYVRva2VuRGF0YSkgPT4ge1xuICAvLyBNYWtlIHN1cmUgdGhlIHVzZXIgZXhpc3RzLCBhbmQgZW1haWwgaXMgb25lIG9mIHRoZWlyIGFkZHJlc3Nlcy5cbiAgLy8gRG9uJ3QgbGltaXQgdGhlIGZpZWxkcyBpbiB0aGUgdXNlciBvYmplY3Qgc2luY2UgdGhlIHVzZXIgaXMgcmV0dXJuZWRcbiAgLy8gYnkgdGhlIGZ1bmN0aW9uIGFuZCBzb21lIG90aGVyIGZpZWxkcyBtaWdodCBiZSB1c2VkIGVsc2V3aGVyZS5cbiAgY29uc3QgdXNlciA9IGdldFVzZXJCeUlkKHVzZXJJZCk7XG4gIGlmICghdXNlcikge1xuICAgIEFjY291bnRzLl9oYW5kbGVFcnJvcihcIkNhbid0IGZpbmQgdXNlclwiKTtcbiAgfVxuXG4gIC8vIHBpY2sgdGhlIGZpcnN0IHVudmVyaWZpZWQgZW1haWwgaWYgd2Ugd2VyZW4ndCBwYXNzZWQgYW4gZW1haWwuXG4gIGlmICghZW1haWwpIHtcbiAgICBjb25zdCBlbWFpbFJlY29yZCA9ICh1c2VyLmVtYWlscyB8fCBbXSkuZmluZChlID0+ICFlLnZlcmlmaWVkKTtcbiAgICBlbWFpbCA9IChlbWFpbFJlY29yZCB8fCB7fSkuYWRkcmVzcztcblxuICAgIGlmICghZW1haWwpIHtcbiAgICAgIEFjY291bnRzLl9oYW5kbGVFcnJvcihcIlRoYXQgdXNlciBoYXMgbm8gdW52ZXJpZmllZCBlbWFpbCBhZGRyZXNzZXMuXCIpO1xuICAgIH1cbiAgfVxuXG4gIC8vIG1ha2Ugc3VyZSB3ZSBoYXZlIGEgdmFsaWQgZW1haWxcbiAgaWYgKCFlbWFpbCB8fFxuICAgICEocGx1Y2tBZGRyZXNzZXModXNlci5lbWFpbHMpLmluY2x1ZGVzKGVtYWlsKSkpIHtcbiAgICBBY2NvdW50cy5faGFuZGxlRXJyb3IoXCJObyBzdWNoIGVtYWlsIGZvciB1c2VyLlwiKTtcbiAgfVxuXG4gIGNvbnN0IHRva2VuID0gUmFuZG9tLnNlY3JldCgpO1xuICBjb25zdCB0b2tlblJlY29yZCA9IHtcbiAgICB0b2tlbixcbiAgICAvLyBUT0RPOiBUaGlzIHNob3VsZCBwcm9iYWJseSBiZSByZW5hbWVkIHRvIFwiZW1haWxcIiB0byBtYXRjaCByZXNldCB0b2tlbiByZWNvcmQuXG4gICAgYWRkcmVzczogZW1haWwsXG4gICAgd2hlbjogbmV3IERhdGUoKVxuICB9O1xuXG4gIGlmIChleHRyYVRva2VuRGF0YSkge1xuICAgIE9iamVjdC5hc3NpZ24odG9rZW5SZWNvcmQsIGV4dHJhVG9rZW5EYXRhKTtcbiAgfVxuXG4gIE1ldGVvci51c2Vycy51cGRhdGUoe19pZDogdXNlci5faWR9LCB7JHB1c2g6IHtcbiAgICAnc2VydmljZXMuZW1haWwudmVyaWZpY2F0aW9uVG9rZW5zJzogdG9rZW5SZWNvcmRcbiAgfX0pO1xuXG4gIC8vIGJlZm9yZSBwYXNzaW5nIHRvIHRlbXBsYXRlLCB1cGRhdGUgdXNlciBvYmplY3Qgd2l0aCBuZXcgdG9rZW5cbiAgTWV0ZW9yLl9lbnN1cmUodXNlciwgJ3NlcnZpY2VzJywgJ2VtYWlsJyk7XG4gIGlmICghdXNlci5zZXJ2aWNlcy5lbWFpbC52ZXJpZmljYXRpb25Ub2tlbnMpIHtcbiAgICB1c2VyLnNlcnZpY2VzLmVtYWlsLnZlcmlmaWNhdGlvblRva2VucyA9IFtdO1xuICB9XG4gIHVzZXIuc2VydmljZXMuZW1haWwudmVyaWZpY2F0aW9uVG9rZW5zLnB1c2godG9rZW5SZWNvcmQpO1xuXG4gIHJldHVybiB7ZW1haWwsIHVzZXIsIHRva2VufTtcbn07XG5cblxuLy8gc2VuZCB0aGUgdXNlciBhbiBlbWFpbCB3aXRoIGEgbGluayB0aGF0IHdoZW4gb3BlbmVkIGFsbG93cyB0aGUgdXNlclxuLy8gdG8gc2V0IGEgbmV3IHBhc3N3b3JkLCB3aXRob3V0IHRoZSBvbGQgcGFzc3dvcmQuXG5cbi8qKlxuICogQHN1bW1hcnkgU2VuZCBhbiBlbWFpbCB3aXRoIGEgbGluayB0aGUgdXNlciBjYW4gdXNlIHRvIHJlc2V0IHRoZWlyIHBhc3N3b3JkLlxuICogQGxvY3VzIFNlcnZlclxuICogQHBhcmFtIHtTdHJpbmd9IHVzZXJJZCBUaGUgaWQgb2YgdGhlIHVzZXIgdG8gc2VuZCBlbWFpbCB0by5cbiAqIEBwYXJhbSB7U3RyaW5nfSBbZW1haWxdIE9wdGlvbmFsLiBXaGljaCBhZGRyZXNzIG9mIHRoZSB1c2VyJ3MgdG8gc2VuZCB0aGUgZW1haWwgdG8uIFRoaXMgYWRkcmVzcyBtdXN0IGJlIGluIHRoZSB1c2VyJ3MgYGVtYWlsc2AgbGlzdC4gRGVmYXVsdHMgdG8gdGhlIGZpcnN0IGVtYWlsIGluIHRoZSBsaXN0LlxuICogQHBhcmFtIHtPYmplY3R9IFtleHRyYVRva2VuRGF0YV0gT3B0aW9uYWwgYWRkaXRpb25hbCBkYXRhIHRvIGJlIGFkZGVkIGludG8gdGhlIHRva2VuIHJlY29yZC5cbiAqIEBwYXJhbSB7T2JqZWN0fSBbZXh0cmFQYXJhbXNdIE9wdGlvbmFsIGFkZGl0aW9uYWwgcGFyYW1zIHRvIGJlIGFkZGVkIHRvIHRoZSByZXNldCB1cmwuXG4gKiBAcmV0dXJucyB7T2JqZWN0fSBPYmplY3Qgd2l0aCB7ZW1haWwsIHVzZXIsIHRva2VuLCB1cmwsIG9wdGlvbnN9IHZhbHVlcy5cbiAqIEBpbXBvcnRGcm9tUGFja2FnZSBhY2NvdW50cy1iYXNlXG4gKi9cbkFjY291bnRzLnNlbmRSZXNldFBhc3N3b3JkRW1haWwgPSAodXNlcklkLCBlbWFpbCwgZXh0cmFUb2tlbkRhdGEsIGV4dHJhUGFyYW1zKSA9PiB7XG4gIGNvbnN0IHtlbWFpbDogcmVhbEVtYWlsLCB1c2VyLCB0b2tlbn0gPVxuICAgIEFjY291bnRzLmdlbmVyYXRlUmVzZXRUb2tlbih1c2VySWQsIGVtYWlsLCAncmVzZXRQYXNzd29yZCcsIGV4dHJhVG9rZW5EYXRhKTtcbiAgY29uc3QgdXJsID0gQWNjb3VudHMudXJscy5yZXNldFBhc3N3b3JkKHRva2VuLCBleHRyYVBhcmFtcyk7XG4gIGNvbnN0IG9wdGlvbnMgPSBBY2NvdW50cy5nZW5lcmF0ZU9wdGlvbnNGb3JFbWFpbChyZWFsRW1haWwsIHVzZXIsIHVybCwgJ3Jlc2V0UGFzc3dvcmQnKTtcbiAgRW1haWwuc2VuZChvcHRpb25zKTtcbiAgaWYgKE1ldGVvci5pc0RldmVsb3BtZW50KSB7XG4gICAgY29uc29sZS5sb2coYFxcblJlc2V0IHBhc3N3b3JkIFVSTDogJHt1cmx9YCk7XG4gIH1cbiAgcmV0dXJuIHtlbWFpbDogcmVhbEVtYWlsLCB1c2VyLCB0b2tlbiwgdXJsLCBvcHRpb25zfTtcbn07XG5cbi8vIHNlbmQgdGhlIHVzZXIgYW4gZW1haWwgaW5mb3JtaW5nIHRoZW0gdGhhdCB0aGVpciBhY2NvdW50IHdhcyBjcmVhdGVkLCB3aXRoXG4vLyBhIGxpbmsgdGhhdCB3aGVuIG9wZW5lZCBib3RoIG1hcmtzIHRoZWlyIGVtYWlsIGFzIHZlcmlmaWVkIGFuZCBmb3JjZXMgdGhlbVxuLy8gdG8gY2hvb3NlIHRoZWlyIHBhc3N3b3JkLiBUaGUgZW1haWwgbXVzdCBiZSBvbmUgb2YgdGhlIGFkZHJlc3NlcyBpbiB0aGVcbi8vIHVzZXIncyBlbWFpbHMgZmllbGQsIG9yIHVuZGVmaW5lZCB0byBwaWNrIHRoZSBmaXJzdCBlbWFpbCBhdXRvbWF0aWNhbGx5LlxuLy9cbi8vIFRoaXMgaXMgbm90IGNhbGxlZCBhdXRvbWF0aWNhbGx5LiBJdCBtdXN0IGJlIGNhbGxlZCBtYW51YWxseSBpZiB5b3Vcbi8vIHdhbnQgdG8gdXNlIGVucm9sbG1lbnQgZW1haWxzLlxuXG4vKipcbiAqIEBzdW1tYXJ5IFNlbmQgYW4gZW1haWwgd2l0aCBhIGxpbmsgdGhlIHVzZXIgY2FuIHVzZSB0byBzZXQgdGhlaXIgaW5pdGlhbCBwYXNzd29yZC5cbiAqIEBsb2N1cyBTZXJ2ZXJcbiAqIEBwYXJhbSB7U3RyaW5nfSB1c2VySWQgVGhlIGlkIG9mIHRoZSB1c2VyIHRvIHNlbmQgZW1haWwgdG8uXG4gKiBAcGFyYW0ge1N0cmluZ30gW2VtYWlsXSBPcHRpb25hbC4gV2hpY2ggYWRkcmVzcyBvZiB0aGUgdXNlcidzIHRvIHNlbmQgdGhlIGVtYWlsIHRvLiBUaGlzIGFkZHJlc3MgbXVzdCBiZSBpbiB0aGUgdXNlcidzIGBlbWFpbHNgIGxpc3QuIERlZmF1bHRzIHRvIHRoZSBmaXJzdCBlbWFpbCBpbiB0aGUgbGlzdC5cbiAqIEBwYXJhbSB7T2JqZWN0fSBbZXh0cmFUb2tlbkRhdGFdIE9wdGlvbmFsIGFkZGl0aW9uYWwgZGF0YSB0byBiZSBhZGRlZCBpbnRvIHRoZSB0b2tlbiByZWNvcmQuXG4gKiBAcGFyYW0ge09iamVjdH0gW2V4dHJhUGFyYW1zXSBPcHRpb25hbCBhZGRpdGlvbmFsIHBhcmFtcyB0byBiZSBhZGRlZCB0byB0aGUgZW5yb2xsbWVudCB1cmwuXG4gKiBAcmV0dXJucyB7T2JqZWN0fSBPYmplY3Qgd2l0aCB7ZW1haWwsIHVzZXIsIHRva2VuLCB1cmwsIG9wdGlvbnN9IHZhbHVlcy5cbiAqIEBpbXBvcnRGcm9tUGFja2FnZSBhY2NvdW50cy1iYXNlXG4gKi9cbkFjY291bnRzLnNlbmRFbnJvbGxtZW50RW1haWwgPSAodXNlcklkLCBlbWFpbCwgZXh0cmFUb2tlbkRhdGEsIGV4dHJhUGFyYW1zKSA9PiB7XG4gIGNvbnN0IHtlbWFpbDogcmVhbEVtYWlsLCB1c2VyLCB0b2tlbn0gPVxuICAgIEFjY291bnRzLmdlbmVyYXRlUmVzZXRUb2tlbih1c2VySWQsIGVtYWlsLCAnZW5yb2xsQWNjb3VudCcsIGV4dHJhVG9rZW5EYXRhKTtcbiAgY29uc3QgdXJsID0gQWNjb3VudHMudXJscy5lbnJvbGxBY2NvdW50KHRva2VuLCBleHRyYVBhcmFtcyk7XG4gIGNvbnN0IG9wdGlvbnMgPSBBY2NvdW50cy5nZW5lcmF0ZU9wdGlvbnNGb3JFbWFpbChyZWFsRW1haWwsIHVzZXIsIHVybCwgJ2Vucm9sbEFjY291bnQnKTtcbiAgRW1haWwuc2VuZChvcHRpb25zKTtcbiAgaWYgKE1ldGVvci5pc0RldmVsb3BtZW50KSB7XG4gICAgY29uc29sZS5sb2coYFxcbkVucm9sbG1lbnQgZW1haWwgVVJMOiAke3VybH1gKTtcbiAgfVxuICByZXR1cm4ge2VtYWlsOiByZWFsRW1haWwsIHVzZXIsIHRva2VuLCB1cmwsIG9wdGlvbnN9O1xufTtcblxuXG4vLyBUYWtlIHRva2VuIGZyb20gc2VuZFJlc2V0UGFzc3dvcmRFbWFpbCBvciBzZW5kRW5yb2xsbWVudEVtYWlsLCBjaGFuZ2Vcbi8vIHRoZSB1c2VycyBwYXNzd29yZCwgYW5kIGxvZyB0aGVtIGluLlxuTWV0ZW9yLm1ldGhvZHMoe3Jlc2V0UGFzc3dvcmQ6IGZ1bmN0aW9uICguLi5hcmdzKSB7XG4gIGNvbnN0IHRva2VuID0gYXJnc1swXTtcbiAgY29uc3QgbmV3UGFzc3dvcmQgPSBhcmdzWzFdO1xuICByZXR1cm4gQWNjb3VudHMuX2xvZ2luTWV0aG9kKFxuICAgIHRoaXMsXG4gICAgXCJyZXNldFBhc3N3b3JkXCIsXG4gICAgYXJncyxcbiAgICBcInBhc3N3b3JkXCIsXG4gICAgKCkgPT4ge1xuICAgICAgY2hlY2sodG9rZW4sIFN0cmluZyk7XG4gICAgICBjaGVjayhuZXdQYXNzd29yZCwgcGFzc3dvcmRWYWxpZGF0b3IpO1xuXG4gICAgICBsZXQgdXNlciA9IE1ldGVvci51c2Vycy5maW5kT25lKFxuICAgICAgICB7XCJzZXJ2aWNlcy5wYXNzd29yZC5yZXNldC50b2tlblwiOiB0b2tlbn0sXG4gICAgICAgIHtmaWVsZHM6IHtcbiAgICAgICAgICBzZXJ2aWNlczogMSxcbiAgICAgICAgICBlbWFpbHM6IDEsXG4gICAgICAgIH19XG4gICAgICApO1xuXG4gICAgICBsZXQgaXNFbnJvbGwgPSBmYWxzZTtcbiAgICAgIC8vIGlmIHRva2VuIGlzIGluIHNlcnZpY2VzLnBhc3N3b3JkLnJlc2V0IGRiIGZpZWxkIGltcGxpZXNcbiAgICAgIC8vIHRoaXMgbWV0aG9kIGlzIHdhcyBub3QgY2FsbGVkIGZyb20gZW5yb2xsIGFjY291bnQgd29ya2Zsb3dcbiAgICAgIC8vIGVsc2UgdGhpcyBtZXRob2QgaXMgY2FsbGVkIGZyb20gZW5yb2xsIGFjY291bnQgd29ya2Zsb3dcbiAgICAgIGlmKCF1c2VyKSB7XG4gICAgICAgIHVzZXIgPSBNZXRlb3IudXNlcnMuZmluZE9uZShcbiAgICAgICAgICB7XCJzZXJ2aWNlcy5wYXNzd29yZC5lbnJvbGwudG9rZW5cIjogdG9rZW59LFxuICAgICAgICAgIHtmaWVsZHM6IHtcbiAgICAgICAgICAgIHNlcnZpY2VzOiAxLFxuICAgICAgICAgICAgZW1haWxzOiAxLFxuICAgICAgICAgIH19XG4gICAgICAgICk7XG4gICAgICAgIGlzRW5yb2xsID0gdHJ1ZTtcbiAgICAgIH1cbiAgICAgIGlmICghdXNlcikge1xuICAgICAgICB0aHJvdyBuZXcgTWV0ZW9yLkVycm9yKDQwMywgXCJUb2tlbiBleHBpcmVkXCIpO1xuICAgICAgfVxuICAgICAgbGV0IHRva2VuUmVjb3JkID0ge307XG4gICAgICBpZihpc0Vucm9sbCkge1xuICAgICAgICB0b2tlblJlY29yZCA9IHVzZXIuc2VydmljZXMucGFzc3dvcmQuZW5yb2xsO1xuICAgICAgfSBlbHNlIHtcbiAgICAgICAgdG9rZW5SZWNvcmQgPSB1c2VyLnNlcnZpY2VzLnBhc3N3b3JkLnJlc2V0O1xuICAgICAgfVxuICAgICAgY29uc3QgeyB3aGVuLCBlbWFpbCB9ID0gdG9rZW5SZWNvcmQ7XG4gICAgICBsZXQgdG9rZW5MaWZldGltZU1zID0gQWNjb3VudHMuX2dldFBhc3N3b3JkUmVzZXRUb2tlbkxpZmV0aW1lTXMoKTtcbiAgICAgIGlmIChpc0Vucm9sbCkge1xuICAgICAgICB0b2tlbkxpZmV0aW1lTXMgPSBBY2NvdW50cy5fZ2V0UGFzc3dvcmRFbnJvbGxUb2tlbkxpZmV0aW1lTXMoKTtcbiAgICAgIH1cbiAgICAgIGNvbnN0IGN1cnJlbnRUaW1lTXMgPSBEYXRlLm5vdygpO1xuICAgICAgaWYgKChjdXJyZW50VGltZU1zIC0gd2hlbikgPiB0b2tlbkxpZmV0aW1lTXMpXG4gICAgICAgIHRocm93IG5ldyBNZXRlb3IuRXJyb3IoNDAzLCBcIlRva2VuIGV4cGlyZWRcIik7XG4gICAgICBpZiAoIShwbHVja0FkZHJlc3Nlcyh1c2VyLmVtYWlscykuaW5jbHVkZXMoZW1haWwpKSlcbiAgICAgICAgcmV0dXJuIHtcbiAgICAgICAgICB1c2VySWQ6IHVzZXIuX2lkLFxuICAgICAgICAgIGVycm9yOiBuZXcgTWV0ZW9yLkVycm9yKDQwMywgXCJUb2tlbiBoYXMgaW52YWxpZCBlbWFpbCBhZGRyZXNzXCIpXG4gICAgICAgIH07XG5cbiAgICAgIGNvbnN0IGhhc2hlZCA9IGhhc2hQYXNzd29yZChuZXdQYXNzd29yZCk7XG5cbiAgICAgIC8vIE5PVEU6IFdlJ3JlIGFib3V0IHRvIGludmFsaWRhdGUgdG9rZW5zIG9uIHRoZSB1c2VyLCB3aG8gd2UgbWlnaHQgYmVcbiAgICAgIC8vIGxvZ2dlZCBpbiBhcy4gTWFrZSBzdXJlIHRvIGF2b2lkIGxvZ2dpbmcgb3Vyc2VsdmVzIG91dCBpZiB0aGlzXG4gICAgICAvLyBoYXBwZW5zLiBCdXQgYWxzbyBtYWtlIHN1cmUgbm90IHRvIGxlYXZlIHRoZSBjb25uZWN0aW9uIGluIGEgc3RhdGVcbiAgICAgIC8vIG9mIGhhdmluZyBhIGJhZCB0b2tlbiBzZXQgaWYgdGhpbmdzIGZhaWwuXG4gICAgICBjb25zdCBvbGRUb2tlbiA9IEFjY291bnRzLl9nZXRMb2dpblRva2VuKHRoaXMuY29ubmVjdGlvbi5pZCk7XG4gICAgICBBY2NvdW50cy5fc2V0TG9naW5Ub2tlbih1c2VyLl9pZCwgdGhpcy5jb25uZWN0aW9uLCBudWxsKTtcbiAgICAgIGNvbnN0IHJlc2V0VG9PbGRUb2tlbiA9ICgpID0+XG4gICAgICAgIEFjY291bnRzLl9zZXRMb2dpblRva2VuKHVzZXIuX2lkLCB0aGlzLmNvbm5lY3Rpb24sIG9sZFRva2VuKTtcblxuICAgICAgdHJ5IHtcbiAgICAgICAgLy8gVXBkYXRlIHRoZSB1c2VyIHJlY29yZCBieTpcbiAgICAgICAgLy8gLSBDaGFuZ2luZyB0aGUgcGFzc3dvcmQgdG8gdGhlIG5ldyBvbmVcbiAgICAgICAgLy8gLSBGb3JnZXR0aW5nIGFib3V0IHRoZSByZXNldCB0b2tlbiBvciBlbnJvbGwgdG9rZW4gdGhhdCB3YXMganVzdCB1c2VkXG4gICAgICAgIC8vIC0gVmVyaWZ5aW5nIHRoZWlyIGVtYWlsLCBzaW5jZSB0aGV5IGdvdCB0aGUgcGFzc3dvcmQgcmVzZXQgdmlhIGVtYWlsLlxuICAgICAgICBsZXQgYWZmZWN0ZWRSZWNvcmRzID0ge307XG4gICAgICAgIC8vIGlmIHJlYXNvbiBpcyBlbnJvbGwgdGhlbiBjaGVjayBzZXJ2aWNlcy5wYXNzd29yZC5lbnJvbGwudG9rZW4gZmllbGQgZm9yIGFmZmVjdGVkIHJlY29yZHNcbiAgICAgICAgaWYoaXNFbnJvbGwpIHtcbiAgICAgICAgICBhZmZlY3RlZFJlY29yZHMgPSBNZXRlb3IudXNlcnMudXBkYXRlKFxuICAgICAgICAgICAge1xuICAgICAgICAgICAgICBfaWQ6IHVzZXIuX2lkLFxuICAgICAgICAgICAgICAnZW1haWxzLmFkZHJlc3MnOiBlbWFpbCxcbiAgICAgICAgICAgICAgJ3NlcnZpY2VzLnBhc3N3b3JkLmVucm9sbC50b2tlbic6IHRva2VuXG4gICAgICAgICAgICB9LFxuICAgICAgICAgICAgeyRzZXQ6IHsnc2VydmljZXMucGFzc3dvcmQuYmNyeXB0JzogaGFzaGVkLFxuICAgICAgICAgICAgICAgICAgICAnZW1haWxzLiQudmVyaWZpZWQnOiB0cnVlfSxcbiAgICAgICAgICAgICAgJHVuc2V0OiB7J3NlcnZpY2VzLnBhc3N3b3JkLmVucm9sbCc6IDEgfX0pO1xuICAgICAgICB9IGVsc2Uge1xuICAgICAgICAgIGFmZmVjdGVkUmVjb3JkcyA9IE1ldGVvci51c2Vycy51cGRhdGUoXG4gICAgICAgICAgICB7XG4gICAgICAgICAgICAgIF9pZDogdXNlci5faWQsXG4gICAgICAgICAgICAgICdlbWFpbHMuYWRkcmVzcyc6IGVtYWlsLFxuICAgICAgICAgICAgICAnc2VydmljZXMucGFzc3dvcmQucmVzZXQudG9rZW4nOiB0b2tlblxuICAgICAgICAgICAgfSxcbiAgICAgICAgICAgIHskc2V0OiB7J3NlcnZpY2VzLnBhc3N3b3JkLmJjcnlwdCc6IGhhc2hlZCxcbiAgICAgICAgICAgICAgICAgICAgJ2VtYWlscy4kLnZlcmlmaWVkJzogdHJ1ZX0sXG4gICAgICAgICAgICAgICR1bnNldDogeydzZXJ2aWNlcy5wYXNzd29yZC5yZXNldCc6IDEgfX0pO1xuICAgICAgICB9XG4gICAgICAgIGlmIChhZmZlY3RlZFJlY29yZHMgIT09IDEpXG4gICAgICAgICAgcmV0dXJuIHtcbiAgICAgICAgICAgIHVzZXJJZDogdXNlci5faWQsXG4gICAgICAgICAgICBlcnJvcjogbmV3IE1ldGVvci5FcnJvcig0MDMsIFwiSW52YWxpZCBlbWFpbFwiKVxuICAgICAgICAgIH07XG4gICAgICB9IGNhdGNoIChlcnIpIHtcbiAgICAgICAgcmVzZXRUb09sZFRva2VuKCk7XG4gICAgICAgIHRocm93IGVycjtcbiAgICAgIH1cblxuICAgICAgLy8gUmVwbGFjZSBhbGwgdmFsaWQgbG9naW4gdG9rZW5zIHdpdGggbmV3IG9uZXMgKGNoYW5naW5nXG4gICAgICAvLyBwYXNzd29yZCBzaG91bGQgaW52YWxpZGF0ZSBleGlzdGluZyBzZXNzaW9ucykuXG4gICAgICBBY2NvdW50cy5fY2xlYXJBbGxMb2dpblRva2Vucyh1c2VyLl9pZCk7XG5cbiAgICAgIHJldHVybiB7dXNlcklkOiB1c2VyLl9pZH07XG4gICAgfVxuICApO1xufX0pO1xuXG4vLy9cbi8vLyBFTUFJTCBWRVJJRklDQVRJT05cbi8vL1xuXG5cbi8vIHNlbmQgdGhlIHVzZXIgYW4gZW1haWwgd2l0aCBhIGxpbmsgdGhhdCB3aGVuIG9wZW5lZCBtYXJrcyB0aGF0XG4vLyBhZGRyZXNzIGFzIHZlcmlmaWVkXG5cbi8qKlxuICogQHN1bW1hcnkgU2VuZCBhbiBlbWFpbCB3aXRoIGEgbGluayB0aGUgdXNlciBjYW4gdXNlIHZlcmlmeSB0aGVpciBlbWFpbCBhZGRyZXNzLlxuICogQGxvY3VzIFNlcnZlclxuICogQHBhcmFtIHtTdHJpbmd9IHVzZXJJZCBUaGUgaWQgb2YgdGhlIHVzZXIgdG8gc2VuZCBlbWFpbCB0by5cbiAqIEBwYXJhbSB7U3RyaW5nfSBbZW1haWxdIE9wdGlvbmFsLiBXaGljaCBhZGRyZXNzIG9mIHRoZSB1c2VyJ3MgdG8gc2VuZCB0aGUgZW1haWwgdG8uIFRoaXMgYWRkcmVzcyBtdXN0IGJlIGluIHRoZSB1c2VyJ3MgYGVtYWlsc2AgbGlzdC4gRGVmYXVsdHMgdG8gdGhlIGZpcnN0IHVudmVyaWZpZWQgZW1haWwgaW4gdGhlIGxpc3QuXG4gKiBAcGFyYW0ge09iamVjdH0gW2V4dHJhVG9rZW5EYXRhXSBPcHRpb25hbCBhZGRpdGlvbmFsIGRhdGEgdG8gYmUgYWRkZWQgaW50byB0aGUgdG9rZW4gcmVjb3JkLlxuICogQHBhcmFtIHtPYmplY3R9IFtleHRyYVBhcmFtc10gT3B0aW9uYWwgYWRkaXRpb25hbCBwYXJhbXMgdG8gYmUgYWRkZWQgdG8gdGhlIHZlcmlmaWNhdGlvbiB1cmwuXG4gKlxuICogQHJldHVybnMge09iamVjdH0gT2JqZWN0IHdpdGgge2VtYWlsLCB1c2VyLCB0b2tlbiwgdXJsLCBvcHRpb25zfSB2YWx1ZXMuXG4gKiBAaW1wb3J0RnJvbVBhY2thZ2UgYWNjb3VudHMtYmFzZVxuICovXG5BY2NvdW50cy5zZW5kVmVyaWZpY2F0aW9uRW1haWwgPSAodXNlcklkLCBlbWFpbCwgZXh0cmFUb2tlbkRhdGEsIGV4dHJhUGFyYW1zKSA9PiB7XG4gIC8vIFhYWCBBbHNvIGdlbmVyYXRlIGEgbGluayB1c2luZyB3aGljaCBzb21lb25lIGNhbiBkZWxldGUgdGhpc1xuICAvLyBhY2NvdW50IGlmIHRoZXkgb3duIHNhaWQgYWRkcmVzcyBidXQgd2VyZW4ndCB0aG9zZSB3aG8gY3JlYXRlZFxuICAvLyB0aGlzIGFjY291bnQuXG5cbiAgY29uc3Qge2VtYWlsOiByZWFsRW1haWwsIHVzZXIsIHRva2VufSA9XG4gICAgQWNjb3VudHMuZ2VuZXJhdGVWZXJpZmljYXRpb25Ub2tlbih1c2VySWQsIGVtYWlsLCBleHRyYVRva2VuRGF0YSk7XG4gIGNvbnN0IHVybCA9IEFjY291bnRzLnVybHMudmVyaWZ5RW1haWwodG9rZW4sIGV4dHJhUGFyYW1zKTtcbiAgY29uc3Qgb3B0aW9ucyA9IEFjY291bnRzLmdlbmVyYXRlT3B0aW9uc0ZvckVtYWlsKHJlYWxFbWFpbCwgdXNlciwgdXJsLCAndmVyaWZ5RW1haWwnKTtcbiAgRW1haWwuc2VuZChvcHRpb25zKTtcbiAgaWYgKE1ldGVvci5pc0RldmVsb3BtZW50KSB7XG4gICAgY29uc29sZS5sb2coYFxcblZlcmlmaWNhdGlvbiBlbWFpbCBVUkw6ICR7dXJsfWApO1xuICB9XG4gIHJldHVybiB7ZW1haWw6IHJlYWxFbWFpbCwgdXNlciwgdG9rZW4sIHVybCwgb3B0aW9uc307XG59O1xuXG4vLyBUYWtlIHRva2VuIGZyb20gc2VuZFZlcmlmaWNhdGlvbkVtYWlsLCBtYXJrIHRoZSBlbWFpbCBhcyB2ZXJpZmllZCxcbi8vIGFuZCBsb2cgdGhlbSBpbi5cbk1ldGVvci5tZXRob2RzKHt2ZXJpZnlFbWFpbDogZnVuY3Rpb24gKC4uLmFyZ3MpIHtcbiAgY29uc3QgdG9rZW4gPSBhcmdzWzBdO1xuICByZXR1cm4gQWNjb3VudHMuX2xvZ2luTWV0aG9kKFxuICAgIHRoaXMsXG4gICAgXCJ2ZXJpZnlFbWFpbFwiLFxuICAgIGFyZ3MsXG4gICAgXCJwYXNzd29yZFwiLFxuICAgICgpID0+IHtcbiAgICAgIGNoZWNrKHRva2VuLCBTdHJpbmcpO1xuXG4gICAgICBjb25zdCB1c2VyID0gTWV0ZW9yLnVzZXJzLmZpbmRPbmUoXG4gICAgICAgIHsnc2VydmljZXMuZW1haWwudmVyaWZpY2F0aW9uVG9rZW5zLnRva2VuJzogdG9rZW59LFxuICAgICAgICB7ZmllbGRzOiB7XG4gICAgICAgICAgc2VydmljZXM6IDEsXG4gICAgICAgICAgZW1haWxzOiAxLFxuICAgICAgICB9fVxuICAgICAgKTtcbiAgICAgIGlmICghdXNlcilcbiAgICAgICAgdGhyb3cgbmV3IE1ldGVvci5FcnJvcig0MDMsIFwiVmVyaWZ5IGVtYWlsIGxpbmsgZXhwaXJlZFwiKTtcblxuICAgICAgICBjb25zdCB0b2tlblJlY29yZCA9IHVzZXIuc2VydmljZXMuZW1haWwudmVyaWZpY2F0aW9uVG9rZW5zLmZpbmQoXG4gICAgICAgICAgdCA9PiB0LnRva2VuID09IHRva2VuXG4gICAgICAgICk7XG4gICAgICBpZiAoIXRva2VuUmVjb3JkKVxuICAgICAgICByZXR1cm4ge1xuICAgICAgICAgIHVzZXJJZDogdXNlci5faWQsXG4gICAgICAgICAgZXJyb3I6IG5ldyBNZXRlb3IuRXJyb3IoNDAzLCBcIlZlcmlmeSBlbWFpbCBsaW5rIGV4cGlyZWRcIilcbiAgICAgICAgfTtcblxuICAgICAgY29uc3QgZW1haWxzUmVjb3JkID0gdXNlci5lbWFpbHMuZmluZChcbiAgICAgICAgZSA9PiBlLmFkZHJlc3MgPT0gdG9rZW5SZWNvcmQuYWRkcmVzc1xuICAgICAgKTtcbiAgICAgIGlmICghZW1haWxzUmVjb3JkKVxuICAgICAgICByZXR1cm4ge1xuICAgICAgICAgIHVzZXJJZDogdXNlci5faWQsXG4gICAgICAgICAgZXJyb3I6IG5ldyBNZXRlb3IuRXJyb3IoNDAzLCBcIlZlcmlmeSBlbWFpbCBsaW5rIGlzIGZvciB1bmtub3duIGFkZHJlc3NcIilcbiAgICAgICAgfTtcblxuICAgICAgLy8gQnkgaW5jbHVkaW5nIHRoZSBhZGRyZXNzIGluIHRoZSBxdWVyeSwgd2UgY2FuIHVzZSAnZW1haWxzLiQnIGluIHRoZVxuICAgICAgLy8gbW9kaWZpZXIgdG8gZ2V0IGEgcmVmZXJlbmNlIHRvIHRoZSBzcGVjaWZpYyBvYmplY3QgaW4gdGhlIGVtYWlsc1xuICAgICAgLy8gYXJyYXkuIFNlZVxuICAgICAgLy8gaHR0cDovL3d3dy5tb25nb2RiLm9yZy9kaXNwbGF5L0RPQ1MvVXBkYXRpbmcvI1VwZGF0aW5nLVRoZSUyNHBvc2l0aW9uYWxvcGVyYXRvcilcbiAgICAgIC8vIGh0dHA6Ly93d3cubW9uZ29kYi5vcmcvZGlzcGxheS9ET0NTL1VwZGF0aW5nI1VwZGF0aW5nLSUyNHB1bGxcbiAgICAgIE1ldGVvci51c2Vycy51cGRhdGUoXG4gICAgICAgIHtfaWQ6IHVzZXIuX2lkLFxuICAgICAgICAgJ2VtYWlscy5hZGRyZXNzJzogdG9rZW5SZWNvcmQuYWRkcmVzc30sXG4gICAgICAgIHskc2V0OiB7J2VtYWlscy4kLnZlcmlmaWVkJzogdHJ1ZX0sXG4gICAgICAgICAkcHVsbDogeydzZXJ2aWNlcy5lbWFpbC52ZXJpZmljYXRpb25Ub2tlbnMnOiB7YWRkcmVzczogdG9rZW5SZWNvcmQuYWRkcmVzc319fSk7XG5cbiAgICAgIHJldHVybiB7dXNlcklkOiB1c2VyLl9pZH07XG4gICAgfVxuICApO1xufX0pO1xuXG4vKipcbiAqIEBzdW1tYXJ5IEFkZCBhbiBlbWFpbCBhZGRyZXNzIGZvciBhIHVzZXIuIFVzZSB0aGlzIGluc3RlYWQgb2YgZGlyZWN0bHlcbiAqIHVwZGF0aW5nIHRoZSBkYXRhYmFzZS4gVGhlIG9wZXJhdGlvbiB3aWxsIGZhaWwgaWYgdGhlcmUgaXMgYSBkaWZmZXJlbnQgdXNlclxuICogd2l0aCBhbiBlbWFpbCBvbmx5IGRpZmZlcmluZyBpbiBjYXNlLiBJZiB0aGUgc3BlY2lmaWVkIHVzZXIgaGFzIGFuIGV4aXN0aW5nXG4gKiBlbWFpbCBvbmx5IGRpZmZlcmluZyBpbiBjYXNlIGhvd2V2ZXIsIHdlIHJlcGxhY2UgaXQuXG4gKiBAbG9jdXMgU2VydmVyXG4gKiBAcGFyYW0ge1N0cmluZ30gdXNlcklkIFRoZSBJRCBvZiB0aGUgdXNlciB0byB1cGRhdGUuXG4gKiBAcGFyYW0ge1N0cmluZ30gbmV3RW1haWwgQSBuZXcgZW1haWwgYWRkcmVzcyBmb3IgdGhlIHVzZXIuXG4gKiBAcGFyYW0ge0Jvb2xlYW59IFt2ZXJpZmllZF0gT3B0aW9uYWwgLSB3aGV0aGVyIHRoZSBuZXcgZW1haWwgYWRkcmVzcyBzaG91bGRcbiAqIGJlIG1hcmtlZCBhcyB2ZXJpZmllZC4gRGVmYXVsdHMgdG8gZmFsc2UuXG4gKiBAaW1wb3J0RnJvbVBhY2thZ2UgYWNjb3VudHMtYmFzZVxuICovXG5BY2NvdW50cy5hZGRFbWFpbCA9ICh1c2VySWQsIG5ld0VtYWlsLCB2ZXJpZmllZCkgPT4ge1xuICBjaGVjayh1c2VySWQsIE5vbkVtcHR5U3RyaW5nKTtcbiAgY2hlY2sobmV3RW1haWwsIE5vbkVtcHR5U3RyaW5nKTtcbiAgY2hlY2sodmVyaWZpZWQsIE1hdGNoLk9wdGlvbmFsKEJvb2xlYW4pKTtcblxuICBpZiAodmVyaWZpZWQgPT09IHZvaWQgMCkge1xuICAgIHZlcmlmaWVkID0gZmFsc2U7XG4gIH1cblxuICBjb25zdCB1c2VyID0gZ2V0VXNlckJ5SWQodXNlcklkLCB7ZmllbGRzOiB7ZW1haWxzOiAxfX0pO1xuICBpZiAoIXVzZXIpXG4gICAgdGhyb3cgbmV3IE1ldGVvci5FcnJvcig0MDMsIFwiVXNlciBub3QgZm91bmRcIik7XG5cbiAgLy8gQWxsb3cgdXNlcnMgdG8gY2hhbmdlIHRoZWlyIG93biBlbWFpbCB0byBhIHZlcnNpb24gd2l0aCBhIGRpZmZlcmVudCBjYXNlXG5cbiAgLy8gV2UgZG9uJ3QgaGF2ZSB0byBjYWxsIGNoZWNrRm9yQ2FzZUluc2Vuc2l0aXZlRHVwbGljYXRlcyB0byBkbyBhIGNhc2VcbiAgLy8gaW5zZW5zaXRpdmUgY2hlY2sgYWNyb3NzIGFsbCBlbWFpbHMgaW4gdGhlIGRhdGFiYXNlIGhlcmUgYmVjYXVzZTogKDEpIGlmXG4gIC8vIHRoZXJlIGlzIG5vIGNhc2UtaW5zZW5zaXRpdmUgZHVwbGljYXRlIGJldHdlZW4gdGhpcyB1c2VyIGFuZCBvdGhlciB1c2VycyxcbiAgLy8gdGhlbiB3ZSBhcmUgT0sgYW5kICgyKSBpZiB0aGlzIHdvdWxkIGNyZWF0ZSBhIGNvbmZsaWN0IHdpdGggb3RoZXIgdXNlcnNcbiAgLy8gdGhlbiB0aGVyZSB3b3VsZCBhbHJlYWR5IGJlIGEgY2FzZS1pbnNlbnNpdGl2ZSBkdXBsaWNhdGUgYW5kIHdlIGNhbid0IGZpeFxuICAvLyB0aGF0IGluIHRoaXMgY29kZSBhbnl3YXkuXG4gIGNvbnN0IGNhc2VJbnNlbnNpdGl2ZVJlZ0V4cCA9XG4gICAgbmV3IFJlZ0V4cChgXiR7TWV0ZW9yLl9lc2NhcGVSZWdFeHAobmV3RW1haWwpfSRgLCAnaScpO1xuXG4gIGNvbnN0IGRpZFVwZGF0ZU93bkVtYWlsID0gKHVzZXIuZW1haWxzIHx8IFtdKS5yZWR1Y2UoXG4gICAgKHByZXYsIGVtYWlsKSA9PiB7XG4gICAgICBpZiAoY2FzZUluc2Vuc2l0aXZlUmVnRXhwLnRlc3QoZW1haWwuYWRkcmVzcykpIHtcbiAgICAgICAgTWV0ZW9yLnVzZXJzLnVwZGF0ZSh7XG4gICAgICAgICAgX2lkOiB1c2VyLl9pZCxcbiAgICAgICAgICAnZW1haWxzLmFkZHJlc3MnOiBlbWFpbC5hZGRyZXNzXG4gICAgICAgIH0sIHskc2V0OiB7XG4gICAgICAgICAgJ2VtYWlscy4kLmFkZHJlc3MnOiBuZXdFbWFpbCxcbiAgICAgICAgICAnZW1haWxzLiQudmVyaWZpZWQnOiB2ZXJpZmllZFxuICAgICAgICB9fSk7XG4gICAgICAgIHJldHVybiB0cnVlO1xuICAgICAgfSBlbHNlIHtcbiAgICAgICAgcmV0dXJuIHByZXY7XG4gICAgICB9XG4gICAgfSxcbiAgICBmYWxzZVxuICApO1xuXG4gIC8vIEluIHRoZSBvdGhlciB1cGRhdGVzIGJlbG93LCB3ZSBoYXZlIHRvIGRvIGFub3RoZXIgY2FsbCB0b1xuICAvLyBjaGVja0ZvckNhc2VJbnNlbnNpdGl2ZUR1cGxpY2F0ZXMgdG8gbWFrZSBzdXJlIHRoYXQgbm8gY29uZmxpY3RpbmcgdmFsdWVzXG4gIC8vIHdlcmUgYWRkZWQgdG8gdGhlIGRhdGFiYXNlIGluIHRoZSBtZWFudGltZS4gV2UgZG9uJ3QgaGF2ZSB0byBkbyB0aGlzIGZvclxuICAvLyB0aGUgY2FzZSB3aGVyZSB0aGUgdXNlciBpcyB1cGRhdGluZyB0aGVpciBlbWFpbCBhZGRyZXNzIHRvIG9uZSB0aGF0IGlzIHRoZVxuICAvLyBzYW1lIGFzIGJlZm9yZSwgYnV0IG9ubHkgZGlmZmVyZW50IGJlY2F1c2Ugb2YgY2FwaXRhbGl6YXRpb24uIFJlYWQgdGhlXG4gIC8vIGJpZyBjb21tZW50IGFib3ZlIHRvIHVuZGVyc3RhbmQgd2h5LlxuXG4gIGlmIChkaWRVcGRhdGVPd25FbWFpbCkge1xuICAgIHJldHVybjtcbiAgfVxuXG4gIC8vIFBlcmZvcm0gYSBjYXNlIGluc2Vuc2l0aXZlIGNoZWNrIGZvciBkdXBsaWNhdGVzIGJlZm9yZSB1cGRhdGVcbiAgQWNjb3VudHMuX2NoZWNrRm9yQ2FzZUluc2Vuc2l0aXZlRHVwbGljYXRlcygnZW1haWxzLmFkZHJlc3MnLFxuICAgICdFbWFpbCcsIG5ld0VtYWlsLCB1c2VyLl9pZCk7XG5cbiAgTWV0ZW9yLnVzZXJzLnVwZGF0ZSh7XG4gICAgX2lkOiB1c2VyLl9pZFxuICB9LCB7XG4gICAgJGFkZFRvU2V0OiB7XG4gICAgICBlbWFpbHM6IHtcbiAgICAgICAgYWRkcmVzczogbmV3RW1haWwsXG4gICAgICAgIHZlcmlmaWVkOiB2ZXJpZmllZFxuICAgICAgfVxuICAgIH1cbiAgfSk7XG5cbiAgLy8gUGVyZm9ybSBhbm90aGVyIGNoZWNrIGFmdGVyIHVwZGF0ZSwgaW4gY2FzZSBhIG1hdGNoaW5nIHVzZXIgaGFzIGJlZW5cbiAgLy8gaW5zZXJ0ZWQgaW4gdGhlIG1lYW50aW1lXG4gIHRyeSB7XG4gICAgQWNjb3VudHMuX2NoZWNrRm9yQ2FzZUluc2Vuc2l0aXZlRHVwbGljYXRlcygnZW1haWxzLmFkZHJlc3MnLFxuICAgICAgJ0VtYWlsJywgbmV3RW1haWwsIHVzZXIuX2lkKTtcbiAgfSBjYXRjaCAoZXgpIHtcbiAgICAvLyBVbmRvIHVwZGF0ZSBpZiB0aGUgY2hlY2sgZmFpbHNcbiAgICBNZXRlb3IudXNlcnMudXBkYXRlKHtfaWQ6IHVzZXIuX2lkfSxcbiAgICAgIHskcHVsbDoge2VtYWlsczoge2FkZHJlc3M6IG5ld0VtYWlsfX19KTtcbiAgICB0aHJvdyBleDtcbiAgfVxufVxuXG4vKipcbiAqIEBzdW1tYXJ5IFJlbW92ZSBhbiBlbWFpbCBhZGRyZXNzIGZvciBhIHVzZXIuIFVzZSB0aGlzIGluc3RlYWQgb2YgdXBkYXRpbmdcbiAqIHRoZSBkYXRhYmFzZSBkaXJlY3RseS5cbiAqIEBsb2N1cyBTZXJ2ZXJcbiAqIEBwYXJhbSB7U3RyaW5nfSB1c2VySWQgVGhlIElEIG9mIHRoZSB1c2VyIHRvIHVwZGF0ZS5cbiAqIEBwYXJhbSB7U3RyaW5nfSBlbWFpbCBUaGUgZW1haWwgYWRkcmVzcyB0byByZW1vdmUuXG4gKiBAaW1wb3J0RnJvbVBhY2thZ2UgYWNjb3VudHMtYmFzZVxuICovXG5BY2NvdW50cy5yZW1vdmVFbWFpbCA9ICh1c2VySWQsIGVtYWlsKSA9PiB7XG4gIGNoZWNrKHVzZXJJZCwgTm9uRW1wdHlTdHJpbmcpO1xuICBjaGVjayhlbWFpbCwgTm9uRW1wdHlTdHJpbmcpO1xuXG4gIGNvbnN0IHVzZXIgPSBnZXRVc2VyQnlJZCh1c2VySWQsIHtmaWVsZHM6IHtfaWQ6IDF9fSk7XG4gIGlmICghdXNlcilcbiAgICB0aHJvdyBuZXcgTWV0ZW9yLkVycm9yKDQwMywgXCJVc2VyIG5vdCBmb3VuZFwiKTtcblxuICBNZXRlb3IudXNlcnMudXBkYXRlKHtfaWQ6IHVzZXIuX2lkfSxcbiAgICB7JHB1bGw6IHtlbWFpbHM6IHthZGRyZXNzOiBlbWFpbH19fSk7XG59XG5cbi8vL1xuLy8vIENSRUFUSU5HIFVTRVJTXG4vLy9cblxuLy8gU2hhcmVkIGNyZWF0ZVVzZXIgZnVuY3Rpb24gY2FsbGVkIGZyb20gdGhlIGNyZWF0ZVVzZXIgbWV0aG9kLCBib3RoXG4vLyBpZiBvcmlnaW5hdGVzIGluIGNsaWVudCBvciBzZXJ2ZXIgY29kZS4gQ2FsbHMgdXNlciBwcm92aWRlZCBob29rcyxcbi8vIGRvZXMgdGhlIGFjdHVhbCB1c2VyIGluc2VydGlvbi5cbi8vXG4vLyByZXR1cm5zIHRoZSB1c2VyIGlkXG5jb25zdCBjcmVhdGVVc2VyID0gb3B0aW9ucyA9PiB7XG4gIC8vIFVua25vd24ga2V5cyBhbGxvd2VkLCBiZWNhdXNlIGEgb25DcmVhdGVVc2VySG9vayBjYW4gdGFrZSBhcmJpdHJhcnlcbiAgLy8gb3B0aW9ucy5cbiAgY2hlY2sob3B0aW9ucywgTWF0Y2guT2JqZWN0SW5jbHVkaW5nKHtcbiAgICB1c2VybmFtZTogTWF0Y2guT3B0aW9uYWwoU3RyaW5nKSxcbiAgICBlbWFpbDogTWF0Y2guT3B0aW9uYWwoU3RyaW5nKSxcbiAgICBwYXNzd29yZDogTWF0Y2guT3B0aW9uYWwocGFzc3dvcmRWYWxpZGF0b3IpXG4gIH0pKTtcblxuICBjb25zdCB7IHVzZXJuYW1lLCBlbWFpbCwgcGFzc3dvcmQgfSA9IG9wdGlvbnM7XG4gIGlmICghdXNlcm5hbWUgJiYgIWVtYWlsKVxuICAgIHRocm93IG5ldyBNZXRlb3IuRXJyb3IoNDAwLCBcIk5lZWQgdG8gc2V0IGEgdXNlcm5hbWUgb3IgZW1haWxcIik7XG5cbiAgY29uc3QgdXNlciA9IHtzZXJ2aWNlczoge319O1xuICBpZiAocGFzc3dvcmQpIHtcbiAgICBjb25zdCBoYXNoZWQgPSBoYXNoUGFzc3dvcmQocGFzc3dvcmQpO1xuICAgIHVzZXIuc2VydmljZXMucGFzc3dvcmQgPSB7IGJjcnlwdDogaGFzaGVkIH07XG4gIH1cblxuICByZXR1cm4gQWNjb3VudHMuX2NyZWF0ZVVzZXJDaGVja2luZ0R1cGxpY2F0ZXMoeyB1c2VyLCBlbWFpbCwgdXNlcm5hbWUsIG9wdGlvbnMgfSlcbn07XG5cbi8vIG1ldGhvZCBmb3IgY3JlYXRlIHVzZXIuIFJlcXVlc3RzIGNvbWUgZnJvbSB0aGUgY2xpZW50LlxuTWV0ZW9yLm1ldGhvZHMoe2NyZWF0ZVVzZXI6IGZ1bmN0aW9uICguLi5hcmdzKSB7XG4gIGNvbnN0IG9wdGlvbnMgPSBhcmdzWzBdO1xuICByZXR1cm4gQWNjb3VudHMuX2xvZ2luTWV0aG9kKFxuICAgIHRoaXMsXG4gICAgXCJjcmVhdGVVc2VyXCIsXG4gICAgYXJncyxcbiAgICBcInBhc3N3b3JkXCIsXG4gICAgKCkgPT4ge1xuICAgICAgLy8gY3JlYXRlVXNlcigpIGFib3ZlIGRvZXMgbW9yZSBjaGVja2luZy5cbiAgICAgIGNoZWNrKG9wdGlvbnMsIE9iamVjdCk7XG4gICAgICBpZiAoQWNjb3VudHMuX29wdGlvbnMuZm9yYmlkQ2xpZW50QWNjb3VudENyZWF0aW9uKVxuICAgICAgICByZXR1cm4ge1xuICAgICAgICAgIGVycm9yOiBuZXcgTWV0ZW9yLkVycm9yKDQwMywgXCJTaWdudXBzIGZvcmJpZGRlblwiKVxuICAgICAgICB9O1xuXG4gICAgICBjb25zdCB1c2VySWQgPSBBY2NvdW50cy5jcmVhdGVVc2VyVmVyaWZ5aW5nRW1haWwob3B0aW9ucyk7XG5cbiAgICAgIC8vIGNsaWVudCBnZXRzIGxvZ2dlZCBpbiBhcyB0aGUgbmV3IHVzZXIgYWZ0ZXJ3YXJkcy5cbiAgICAgIHJldHVybiB7dXNlcklkOiB1c2VySWR9O1xuICAgIH1cbiAgKTtcbn19KTtcblxuLyoqXG4gKiBAc3VtbWFyeSBDcmVhdGVzIGFuIHVzZXIgYW5kIHNlbmRzIGFuIGVtYWlsIGlmIGBvcHRpb25zLmVtYWlsYCBpcyBpbmZvcm1lZC5cbiAqIFRoZW4gaWYgdGhlIGBzZW5kVmVyaWZpY2F0aW9uRW1haWxgIG9wdGlvbiBmcm9tIHRoZSBgQWNjb3VudHNgIHBhY2thZ2UgaXNcbiAqIGVuYWJsZWQsIHlvdSdsbCBzZW5kIGEgdmVyaWZpY2F0aW9uIGVtYWlsIGlmIGBvcHRpb25zLnBhc3N3b3JkYCBpcyBpbmZvcm1lZCxcbiAqIG90aGVyd2lzZSB5b3UnbGwgc2VuZCBhbiBlbnJvbGxtZW50IGVtYWlsLlxuICogQGxvY3VzIFNlcnZlclxuICogQHBhcmFtIHtPYmplY3R9IG9wdGlvbnMgVGhlIG9wdGlvbnMgb2JqZWN0IHRvIGJlIHBhc3NlZCBkb3duIHdoZW4gY3JlYXRpbmdcbiAqIHRoZSB1c2VyXG4gKiBAcGFyYW0ge1N0cmluZ30gb3B0aW9ucy51c2VybmFtZSBBIHVuaXF1ZSBuYW1lIGZvciB0aGlzIHVzZXIuXG4gKiBAcGFyYW0ge1N0cmluZ30gb3B0aW9ucy5lbWFpbCBUaGUgdXNlcidzIGVtYWlsIGFkZHJlc3MuXG4gKiBAcGFyYW0ge1N0cmluZ30gb3B0aW9ucy5wYXNzd29yZCBUaGUgdXNlcidzIHBhc3N3b3JkLiBUaGlzIGlzIF9fbm90X18gc2VudCBpbiBwbGFpbiB0ZXh0IG92ZXIgdGhlIHdpcmUuXG4gKiBAcGFyYW0ge09iamVjdH0gb3B0aW9ucy5wcm9maWxlIFRoZSB1c2VyJ3MgcHJvZmlsZSwgdHlwaWNhbGx5IGluY2x1ZGluZyB0aGUgYG5hbWVgIGZpZWxkLlxuICogQGltcG9ydEZyb21QYWNrYWdlIGFjY291bnRzLWJhc2VcbiAqICovXG5BY2NvdW50cy5jcmVhdGVVc2VyVmVyaWZ5aW5nRW1haWwgPSAob3B0aW9ucykgPT4ge1xuICBvcHRpb25zID0geyAuLi5vcHRpb25zIH07XG4gIC8vIENyZWF0ZSB1c2VyLiByZXN1bHQgY29udGFpbnMgaWQgYW5kIHRva2VuLlxuICBjb25zdCB1c2VySWQgPSBjcmVhdGVVc2VyKG9wdGlvbnMpO1xuICAvLyBzYWZldHkgYmVsdC4gY3JlYXRlVXNlciBpcyBzdXBwb3NlZCB0byB0aHJvdyBvbiBlcnJvci4gc2VuZCA1MDAgZXJyb3JcbiAgLy8gaW5zdGVhZCBvZiBzZW5kaW5nIGEgdmVyaWZpY2F0aW9uIGVtYWlsIHdpdGggZW1wdHkgdXNlcmlkLlxuICBpZiAoISB1c2VySWQpXG4gICAgdGhyb3cgbmV3IEVycm9yKFwiY3JlYXRlVXNlciBmYWlsZWQgdG8gaW5zZXJ0IG5ldyB1c2VyXCIpO1xuXG4gIC8vIElmIGBBY2NvdW50cy5fb3B0aW9ucy5zZW5kVmVyaWZpY2F0aW9uRW1haWxgIGlzIHNldCwgcmVnaXN0ZXJcbiAgLy8gYSB0b2tlbiB0byB2ZXJpZnkgdGhlIHVzZXIncyBwcmltYXJ5IGVtYWlsLCBhbmQgc2VuZCBpdCB0b1xuICAvLyB0aGF0IGFkZHJlc3MuXG4gIGlmIChvcHRpb25zLmVtYWlsICYmIEFjY291bnRzLl9vcHRpb25zLnNlbmRWZXJpZmljYXRpb25FbWFpbCkge1xuICAgIGlmIChvcHRpb25zLnBhc3N3b3JkKSB7XG4gICAgICBBY2NvdW50cy5zZW5kVmVyaWZpY2F0aW9uRW1haWwodXNlcklkLCBvcHRpb25zLmVtYWlsKTtcbiAgICB9IGVsc2Uge1xuICAgICAgQWNjb3VudHMuc2VuZEVucm9sbG1lbnRFbWFpbCh1c2VySWQsIG9wdGlvbnMuZW1haWwpO1xuICAgIH1cbiAgfVxuXG4gIHJldHVybiB1c2VySWQ7XG59O1xuXG4vLyBDcmVhdGUgdXNlciBkaXJlY3RseSBvbiB0aGUgc2VydmVyLlxuLy9cbi8vIFVubGlrZSB0aGUgY2xpZW50IHZlcnNpb24sIHRoaXMgZG9lcyBub3QgbG9nIHlvdSBpbiBhcyB0aGlzIHVzZXJcbi8vIGFmdGVyIGNyZWF0aW9uLlxuLy9cbi8vIHJldHVybnMgdXNlcklkIG9yIHRocm93cyBhbiBlcnJvciBpZiBpdCBjYW4ndCBjcmVhdGVcbi8vXG4vLyBYWFggYWRkIGFub3RoZXIgYXJndW1lbnQgKFwic2VydmVyIG9wdGlvbnNcIikgdGhhdCBnZXRzIHNlbnQgdG8gb25DcmVhdGVVc2VyLFxuLy8gd2hpY2ggaXMgYWx3YXlzIGVtcHR5IHdoZW4gY2FsbGVkIGZyb20gdGhlIGNyZWF0ZVVzZXIgbWV0aG9kPyBlZywgXCJhZG1pbjpcbi8vIHRydWVcIiwgd2hpY2ggd2Ugd2FudCB0byBwcmV2ZW50IHRoZSBjbGllbnQgZnJvbSBzZXR0aW5nLCBidXQgd2hpY2ggYSBjdXN0b21cbi8vIG1ldGhvZCBjYWxsaW5nIEFjY291bnRzLmNyZWF0ZVVzZXIgY291bGQgc2V0P1xuLy9cbkFjY291bnRzLmNyZWF0ZVVzZXIgPSAob3B0aW9ucywgY2FsbGJhY2spID0+IHtcbiAgb3B0aW9ucyA9IHsgLi4ub3B0aW9ucyB9O1xuXG4gIC8vIFhYWCBhbGxvdyBhbiBvcHRpb25hbCBjYWxsYmFjaz9cbiAgaWYgKGNhbGxiYWNrKSB7XG4gICAgdGhyb3cgbmV3IEVycm9yKFwiQWNjb3VudHMuY3JlYXRlVXNlciB3aXRoIGNhbGxiYWNrIG5vdCBzdXBwb3J0ZWQgb24gdGhlIHNlcnZlciB5ZXQuXCIpO1xuICB9XG5cbiAgcmV0dXJuIGNyZWF0ZVVzZXIob3B0aW9ucyk7XG59O1xuXG4vLy9cbi8vLyBQQVNTV09SRC1TUEVDSUZJQyBJTkRFWEVTIE9OIFVTRVJTXG4vLy9cbk1ldGVvci51c2Vycy5jcmVhdGVJbmRleCgnc2VydmljZXMuZW1haWwudmVyaWZpY2F0aW9uVG9rZW5zLnRva2VuJyxcbiAgICAgICAgICAgICAgICAgICAgICAgICAgeyB1bmlxdWU6IHRydWUsIHNwYXJzZTogdHJ1ZSB9KTtcbk1ldGVvci51c2Vycy5jcmVhdGVJbmRleCgnc2VydmljZXMucGFzc3dvcmQucmVzZXQudG9rZW4nLFxuICAgICAgICAgICAgICAgICAgICAgICAgICB7IHVuaXF1ZTogdHJ1ZSwgc3BhcnNlOiB0cnVlIH0pO1xuTWV0ZW9yLnVzZXJzLmNyZWF0ZUluZGV4KCdzZXJ2aWNlcy5wYXNzd29yZC5lbnJvbGwudG9rZW4nLFxuICAgICAgICAgICAgICAgICAgICAgICAgICB7IHVuaXF1ZTogdHJ1ZSwgc3BhcnNlOiB0cnVlIH0pO1xuIl19
