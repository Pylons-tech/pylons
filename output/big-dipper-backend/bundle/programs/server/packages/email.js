(function () {

/* Imports */
var Meteor = Package.meteor.Meteor;
var global = Package.meteor.global;
var meteorEnv = Package.meteor.meteorEnv;
var ECMAScript = Package.ecmascript.ECMAScript;
var Log = Package.logging.Log;
var Hook = Package['callback-hook'].Hook;
var meteorInstall = Package.modules.meteorInstall;
var Promise = Package.promise.Promise;

/* Package-scope variables */
var Email, EmailInternals, EmailTest;

var require = meteorInstall({"node_modules":{"meteor":{"email":{"email.js":function module(require,exports,module){

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                  //
// packages/email/email.js                                                                                          //
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
    Email: () => Email,
    EmailTest: () => EmailTest,
    EmailInternals: () => EmailInternals
  });
  let Meteor;
  module1.link("meteor/meteor", {
    Meteor(v) {
      Meteor = v;
    }

  }, 0);
  let Log;
  module1.link("meteor/logging", {
    Log(v) {
      Log = v;
    }

  }, 1);
  let Hook;
  module1.link("meteor/callback-hook", {
    Hook(v) {
      Hook = v;
    }

  }, 2);
  let Future;
  module1.link("fibers/future", {
    default(v) {
      Future = v;
    }

  }, 3);
  let url;
  module1.link("url", {
    default(v) {
      url = v;
    }

  }, 4);
  let nodemailer;
  module1.link("nodemailer", {
    default(v) {
      nodemailer = v;
    }

  }, 5);
  let wellKnow;
  module1.link("nodemailer/lib/well-known", {
    default(v) {
      wellKnow = v;
    }

  }, 6);
  const Email = {};
  const EmailTest = {};
  const EmailInternals = {
    NpmModules: {
      mailcomposer: {
        version: Npm.require('nodemailer/package.json').version,
        module: Npm.require('nodemailer/lib/mail-composer')
      },
      nodemailer: {
        version: Npm.require('nodemailer/package.json').version,
        module: Npm.require('nodemailer')
      }
    }
  };
  const MailComposer = EmailInternals.NpmModules.mailcomposer.module;

  const makeTransport = function (mailUrlString) {
    const mailUrl = new URL(mailUrlString);

    if (mailUrl.protocol !== 'smtp:' && mailUrl.protocol !== 'smtps:') {
      throw new Error('Email protocol in $MAIL_URL (' + mailUrlString + ") must be 'smtp' or 'smtps'");
    }

    if (mailUrl.protocol === 'smtp:' && mailUrl.port === '465') {
      Log.debug("The $MAIL_URL is 'smtp://...:465'.  " + "You probably want 'smtps://' (The 's' enables TLS/SSL) " + "since '465' is typically a secure port.");
    } // Allow overriding pool setting, but default to true.


    if (!mailUrl.query) {
      mailUrl.query = {};
    }

    if (!mailUrl.query.pool) {
      mailUrl.query.pool = 'true';
    }

    const transport = nodemailer.createTransport(url.format(mailUrl));
    transport._syncSendMail = Meteor.wrapAsync(transport.sendMail, transport);
    return transport;
  }; // More info: https://nodemailer.com/smtp/well-known/


  const knownHostsTransport = function () {
    let settings = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : undefined;
    let url = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : undefined;
    let service, user, password;
    const hasSettings = settings && Object.keys(settings).length;

    if (url && !hasSettings) {
      let host = url.split(':')[0];
      const urlObject = new URL(url);

      if (host === 'http' || host === 'https') {
        // Look to hostname for service
        host = urlObject.hostname;
        user = urlObject.username;
        password = urlObject.password;
      } else if (urlObject.protocol && urlObject.username && urlObject.password) {
        // We have some data from urlObject
        host = urlObject.protocol.split(':')[0];
        user = urlObject.username;
        password = urlObject.password;
      } else {
        var _urlObject$pathname$s;

        // We need to disect the URL ourselves to get the data
        // First get rid of the leading '//' and split to username and the rest
        const temp = (_urlObject$pathname$s = urlObject.pathname.substring(2)) === null || _urlObject$pathname$s === void 0 ? void 0 : _urlObject$pathname$s.split(':');
        user = temp[0]; // Now we split by '@' to get password and hostname

        const temp2 = temp[1].split('@');
        password = temp2[0];
        host = temp2[1];
      }

      service = host;
    }

    if (!wellKnow((settings === null || settings === void 0 ? void 0 : settings.service) || service)) {
      throw new Error('Could not recognize e-mail service. See list at https://nodemailer.com/smtp/well-known/ for services that we can configure for you.');
    }

    const transport = nodemailer.createTransport({
      service: (settings === null || settings === void 0 ? void 0 : settings.service) || service,
      auth: {
        user: (settings === null || settings === void 0 ? void 0 : settings.user) || user,
        pass: (settings === null || settings === void 0 ? void 0 : settings.password) || password
      }
    });
    transport._syncSendMail = Meteor.wrapAsync(transport.sendMail, transport);
    return transport;
  };

  EmailTest.knowHostsTransport = knownHostsTransport;

  const getTransport = function () {
    var _Meteor$settings$pack;

    const packageSettings = ((_Meteor$settings$pack = Meteor.settings.packages) === null || _Meteor$settings$pack === void 0 ? void 0 : _Meteor$settings$pack.email) || {}; // We delay this check until the first call to Email.send, in case someone
    // set process.env.MAIL_URL in startup code. Then we store in a cache until
    // process.env.MAIL_URL changes.

    const url = process.env.MAIL_URL;

    if (this.cacheKey === undefined || this.cacheKey !== url || this.cacheKey !== packageSettings.service || this.cacheKey !== 'settings') {
      if (packageSettings.service && wellKnow(packageSettings.service) || url && wellKnow(new URL(url).hostname) || wellKnow((url === null || url === void 0 ? void 0 : url.split(':')[0]) || '')) {
        this.cacheKey = packageSettings.service || 'settings';
        this.cache = knownHostsTransport(packageSettings, url);
      } else {
        this.cacheKey = url;
        this.cache = url ? makeTransport(url, packageSettings) : null;
      }
    }

    return this.cache;
  };

  let nextDevModeMailId = 0;
  let output_stream = process.stdout; // Testing hooks

  EmailTest.overrideOutputStream = function (stream) {
    nextDevModeMailId = 0;
    output_stream = stream;
  };

  EmailTest.restoreOutputStream = function () {
    output_stream = process.stdout;
  };

  const devModeSend = function (mail) {
    let devModeMailId = nextDevModeMailId++;
    const stream = output_stream; // This approach does not prevent other writers to stdout from interleaving.

    stream.write('====== BEGIN MAIL #' + devModeMailId + ' ======\n');
    stream.write('(Mail not sent; to enable sending, set the MAIL_URL ' + 'environment variable.)\n');
    const readStream = new MailComposer(mail).compile().createReadStream();
    readStream.pipe(stream, {
      end: false
    });
    const future = new Future();
    readStream.on('end', function () {
      stream.write('====== END MAIL #' + devModeMailId + ' ======\n');
      future.return();
    });
    future.wait();
  };

  const smtpSend = function (transport, mail) {
    transport._syncSendMail(mail);
  };

  const sendHooks = new Hook();
  /**
   * @summary Hook that runs before email is sent.
   * @locus Server
   *
   * @param f {function} receives the arguments to Email.send and should return true to go
   * ahead and send the email (or at least, try subsequent hooks), or
   * false to skip sending.
   * @returns {{ stop: function, callback: function }}
   */

  Email.hookSend = function (f) {
    return sendHooks.register(f);
  };
  /**
   * @summary Overrides sending function with your own.
   * @locus Server
   * @since 2.2
   * @param f {function} function that will receive options from the send function and under `packageSettings` will
   * include the package settings from Meteor.settings.packages.email for your custom transport to access.
   */


  Email.customTransport = undefined;
  /**
   * @summary Send an email. Throws an `Error` on failure to contact mail server
   * or if mail server returns an error. All fields should match
   * [RFC5322](http://tools.ietf.org/html/rfc5322) specification.
   *
   * If the `MAIL_URL` environment variable is set, actually sends the email.
   * Otherwise, prints the contents of the email to standard out.
   *
   * Note that this package is based on **nodemailer**, so make sure to refer to
   * [the documentation](http://nodemailer.com/)
   * when using the `attachments` or `mailComposer` options.
   *
   * @locus Server
   * @param {Object} options
   * @param {String} [options.from] "From:" address (required)
   * @param {String|String[]} options.to,cc,bcc,replyTo
   *   "To:", "Cc:", "Bcc:", and "Reply-To:" addresses
   * @param {String} [options.inReplyTo] Message-ID this message is replying to
   * @param {String|String[]} [options.references] Array (or space-separated string) of Message-IDs to refer to
   * @param {String} [options.messageId] Message-ID for this message; otherwise, will be set to a random value
   * @param {String} [options.subject]  "Subject:" line
   * @param {String} [options.text|html] Mail body (in plain text and/or HTML)
   * @param {String} [options.watchHtml] Mail body in HTML specific for Apple Watch
   * @param {String} [options.icalEvent] iCalendar event attachment
   * @param {Object} [options.headers] Dictionary of custom headers - e.g. `{ "header name": "header value" }`. To set an object under a header name, use `JSON.stringify` - e.g. `{ "header name": JSON.stringify({ tracking: { level: 'full' } }) }`.
   * @param {Object[]} [options.attachments] Array of attachment objects, as
   * described in the [nodemailer documentation](https://nodemailer.com/message/attachments/).
   * @param {MailComposer} [options.mailComposer] A [MailComposer](https://nodemailer.com/extras/mailcomposer/#e-mail-message-fields)
   * object representing the message to be sent.  Overrides all other options.
   * You can create a `MailComposer` object via
   * `new EmailInternals.NpmModules.mailcomposer.module`.
   */

  Email.send = function (options) {
    var _Meteor$settings$pack3;

    if (options.mailComposer) {
      options = options.mailComposer.mail;
    }

    let send = true;
    sendHooks.forEach(hook => {
      send = hook(options);
      return send;
    });
    if (!send) return;
    const customTransport = Email.customTransport;

    if (customTransport) {
      var _Meteor$settings$pack2;

      const packageSettings = ((_Meteor$settings$pack2 = Meteor.settings.packages) === null || _Meteor$settings$pack2 === void 0 ? void 0 : _Meteor$settings$pack2.email) || {};
      customTransport(_objectSpread({
        packageSettings
      }, options));
      return;
    }

    const mailUrlEnv = process.env.MAIL_URL;
    const mailUrlSettings = (_Meteor$settings$pack3 = Meteor.settings.packages) === null || _Meteor$settings$pack3 === void 0 ? void 0 : _Meteor$settings$pack3.email;

    if (Meteor.isProduction && !mailUrlEnv && !mailUrlSettings) {
      // This check is mostly necessary when using the flag --production when running locally.
      // And it works as a reminder to properly set the mail URL when running locally.
      throw new Error('You have not provided a mail URL. You can provide it by using the environment variable MAIL_URL or your settings. You can read more about it here: https://docs.meteor.com/api/email.html.');
    }

    if (mailUrlEnv || mailUrlSettings) {
      const transport = getTransport();
      smtpSend(transport, options);
      return;
    }

    devModeSend(options);
  };
}.call(this, module);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"node_modules":{"nodemailer":{"package.json":function module(require,exports,module){

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                  //
// node_modules/meteor/email/node_modules/nodemailer/package.json                                                   //
//                                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                    //
module.exports = {
  "name": "nodemailer",
  "version": "6.6.3",
  "main": "lib/nodemailer.js"
};

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"lib":{"nodemailer.js":function module(require,exports,module){

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                  //
// node_modules/meteor/email/node_modules/nodemailer/lib/nodemailer.js                                              //
//                                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                    //
module.useNode();
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"well-known":{"index.js":function module(require,exports,module){

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                  //
// node_modules/meteor/email/node_modules/nodemailer/lib/well-known/index.js                                        //
//                                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                    //
module.useNode();
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}}}}}}}}},{
  "extensions": [
    ".js",
    ".json"
  ]
});

var exports = require("/node_modules/meteor/email/email.js");

/* Exports */
Package._define("email", exports, {
  Email: Email,
  EmailInternals: EmailInternals,
  EmailTest: EmailTest
});

})();

//# sourceURL=meteor://💻app/packages/email.js
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvZW1haWwvZW1haWwuanMiXSwibmFtZXMiOlsiX29iamVjdFNwcmVhZCIsIm1vZHVsZTEiLCJsaW5rIiwiZGVmYXVsdCIsInYiLCJleHBvcnQiLCJFbWFpbCIsIkVtYWlsVGVzdCIsIkVtYWlsSW50ZXJuYWxzIiwiTWV0ZW9yIiwiTG9nIiwiSG9vayIsIkZ1dHVyZSIsInVybCIsIm5vZGVtYWlsZXIiLCJ3ZWxsS25vdyIsIk5wbU1vZHVsZXMiLCJtYWlsY29tcG9zZXIiLCJ2ZXJzaW9uIiwiTnBtIiwicmVxdWlyZSIsIm1vZHVsZSIsIk1haWxDb21wb3NlciIsIm1ha2VUcmFuc3BvcnQiLCJtYWlsVXJsU3RyaW5nIiwibWFpbFVybCIsIlVSTCIsInByb3RvY29sIiwiRXJyb3IiLCJwb3J0IiwiZGVidWciLCJxdWVyeSIsInBvb2wiLCJ0cmFuc3BvcnQiLCJjcmVhdGVUcmFuc3BvcnQiLCJmb3JtYXQiLCJfc3luY1NlbmRNYWlsIiwid3JhcEFzeW5jIiwic2VuZE1haWwiLCJrbm93bkhvc3RzVHJhbnNwb3J0Iiwic2V0dGluZ3MiLCJ1bmRlZmluZWQiLCJzZXJ2aWNlIiwidXNlciIsInBhc3N3b3JkIiwiaGFzU2V0dGluZ3MiLCJPYmplY3QiLCJrZXlzIiwibGVuZ3RoIiwiaG9zdCIsInNwbGl0IiwidXJsT2JqZWN0IiwiaG9zdG5hbWUiLCJ1c2VybmFtZSIsInRlbXAiLCJwYXRobmFtZSIsInN1YnN0cmluZyIsInRlbXAyIiwiYXV0aCIsInBhc3MiLCJrbm93SG9zdHNUcmFuc3BvcnQiLCJnZXRUcmFuc3BvcnQiLCJwYWNrYWdlU2V0dGluZ3MiLCJwYWNrYWdlcyIsImVtYWlsIiwicHJvY2VzcyIsImVudiIsIk1BSUxfVVJMIiwiY2FjaGVLZXkiLCJjYWNoZSIsIm5leHREZXZNb2RlTWFpbElkIiwib3V0cHV0X3N0cmVhbSIsInN0ZG91dCIsIm92ZXJyaWRlT3V0cHV0U3RyZWFtIiwic3RyZWFtIiwicmVzdG9yZU91dHB1dFN0cmVhbSIsImRldk1vZGVTZW5kIiwibWFpbCIsImRldk1vZGVNYWlsSWQiLCJ3cml0ZSIsInJlYWRTdHJlYW0iLCJjb21waWxlIiwiY3JlYXRlUmVhZFN0cmVhbSIsInBpcGUiLCJlbmQiLCJmdXR1cmUiLCJvbiIsInJldHVybiIsIndhaXQiLCJzbXRwU2VuZCIsInNlbmRIb29rcyIsImhvb2tTZW5kIiwiZiIsInJlZ2lzdGVyIiwiY3VzdG9tVHJhbnNwb3J0Iiwic2VuZCIsIm9wdGlvbnMiLCJtYWlsQ29tcG9zZXIiLCJmb3JFYWNoIiwiaG9vayIsIm1haWxVcmxFbnYiLCJtYWlsVXJsU2V0dGluZ3MiLCJpc1Byb2R1Y3Rpb24iXSwibWFwcGluZ3MiOiI7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OztBQUFBLE1BQUlBLGFBQUo7O0FBQWtCQyxTQUFPLENBQUNDLElBQVIsQ0FBYSxzQ0FBYixFQUFvRDtBQUFDQyxXQUFPLENBQUNDLENBQUQsRUFBRztBQUFDSixtQkFBYSxHQUFDSSxDQUFkO0FBQWdCOztBQUE1QixHQUFwRCxFQUFrRixDQUFsRjtBQUFsQkgsU0FBTyxDQUFDSSxNQUFSLENBQWU7QUFBQ0MsU0FBSyxFQUFDLE1BQUlBLEtBQVg7QUFBaUJDLGFBQVMsRUFBQyxNQUFJQSxTQUEvQjtBQUF5Q0Msa0JBQWMsRUFBQyxNQUFJQTtBQUE1RCxHQUFmO0FBQTRGLE1BQUlDLE1BQUo7QUFBV1IsU0FBTyxDQUFDQyxJQUFSLENBQWEsZUFBYixFQUE2QjtBQUFDTyxVQUFNLENBQUNMLENBQUQsRUFBRztBQUFDSyxZQUFNLEdBQUNMLENBQVA7QUFBUzs7QUFBcEIsR0FBN0IsRUFBbUQsQ0FBbkQ7QUFBc0QsTUFBSU0sR0FBSjtBQUFRVCxTQUFPLENBQUNDLElBQVIsQ0FBYSxnQkFBYixFQUE4QjtBQUFDUSxPQUFHLENBQUNOLENBQUQsRUFBRztBQUFDTSxTQUFHLEdBQUNOLENBQUo7QUFBTTs7QUFBZCxHQUE5QixFQUE4QyxDQUE5QztBQUFpRCxNQUFJTyxJQUFKO0FBQVNWLFNBQU8sQ0FB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LEtBQW1DLEVBQTNEO0FBQ0E4QixxQkFBZTtBQUFHaEM7QUFBSCxTQUF1QmtDLE9BQXZCLEVBQWY7QUFDQTtBQUNEOztBQUVELFVBQU1JLFVBQVUsR0FBR25DLE9BQU8sQ0FBQ0MsR0FBUixDQUFZQyxRQUEvQjtBQUNBLFVBQU1rQyxlQUFlLDZCQUFHNUYsTUFBTSxDQUFDK0IsUUFBUCxDQUFnQnVCLFFBQW5CLDJEQUFHLHVCQUEwQkMsS0FBbEQ7O0FBRUEsUUFBSXZELE1BQU0sQ0FBQzZGLFlBQVAsSUFBdUIsQ0FBQ0YsVUFBeEIsSUFBc0MsQ0FBQ0MsZUFBM0MsRUFBNEQ7QUFDMUQ7QUFDQTtBQUNBLFlBQU0sSUFBSXpFLEtBQUosQ0FDSiw0TEFESSxDQUFOO0FBR0Q7O0FBRUQsUUFBSXdFLFVBQVUsSUFBSUMsZUFBbEIsRUFBbUM7QUFDakMsWUFBTXBFLFNBQVMsR0FBRzRCLFlBQVksRUFBOUI7QUFDQTRCLGNBQVEsQ0FBQ3hELFNBQUQsRUFBWStELE9BQVosQ0FBUjtBQUNBO0FBQ0Q7O0FBQ0RwQixlQUFXLENBQUNvQixPQUFELENBQVg7QUFDRCxHQXBDRCIsImZpbGUiOiIvcGFja2FnZXMvZW1haWwuanMiLCJzb3VyY2VzQ29udGVudCI6WyJpbXBvcnQgeyBNZXRlb3IgfSBmcm9tICdtZXRlb3IvbWV0ZW9yJztcbmltcG9ydCB7IExvZyB9IGZyb20gJ21ldGVvci9sb2dnaW5nJztcbmltcG9ydCB7IEhvb2sgfSBmcm9tICdtZXRlb3IvY2FsbGJhY2staG9vayc7XG5cbmltcG9ydCBGdXR1cmUgZnJvbSAnZmliZXJzL2Z1dHVyZSc7XG5pbXBvcnQgdXJsIGZyb20gJ3VybCc7XG5pbXBvcnQgbm9kZW1haWxlciBmcm9tICdub2RlbWFpbGVyJztcbmltcG9ydCB3ZWxsS25vdyBmcm9tICdub2RlbWFpbGVyL2xpYi93ZWxsLWtub3duJztcblxuZXhwb3J0IGNvbnN0IEVtYWlsID0ge307XG5leHBvcnQgY29uc3QgRW1haWxUZXN0ID0ge307XG5cbmV4cG9ydCBjb25zdCBFbWFpbEludGVybmFscyA9IHtcbiAgTnBtTW9kdWxlczoge1xuICAgIG1haWxjb21wb3Nlcjoge1xuICAgICAgdmVyc2lvbjogTnBtLnJlcXVpcmUoJ25vZGVtYWlsZXIvcGFja2FnZS5qc29uJykudmVyc2lvbixcbiAgICAgIG1vZHVsZTogTnBtLnJlcXVpcmUoJ25vZGVtYWlsZXIvbGliL21haWwtY29tcG9zZXInKSxcbiAgICB9LFxuICAgIG5vZGVtYWlsZXI6IHtcbiAgICAgIHZlcnNpb246IE5wbS5yZXF1aXJlKCdub2RlbWFpbGVyL3BhY2thZ2UuanNvbicpLnZlcnNpb24sXG4gICAgICBtb2R1bGU6IE5wbS5yZXF1aXJlKCdub2RlbWFpbGVyJyksXG4gICAgfSxcbiAgfSxcbn07XG5cbmNvbnN0IE1haWxDb21wb3NlciA9IEVtYWlsSW50ZXJuYWxzLk5wbU1vZHVsZXMubWFpbGNvbXBvc2VyLm1vZHVsZTtcblxuY29uc3QgbWFrZVRyYW5zcG9ydCA9IGZ1bmN0aW9uKG1haWxVcmxTdHJpbmcpIHtcbiAgY29uc3QgbWFpbFVybCA9IG5ldyBVUkwobWFpbFVybFN0cmluZyk7XG5cbiAgaWYgKG1haWxVcmwucHJvdG9jb2wgIT09ICdzbXRwOicgJiYgbWFpbFVybC5wcm90b2NvbCAhPT0gJ3NtdHBzOicpIHtcbiAgICB0aHJvdyBuZXcgRXJyb3IoXG4gICAgICAnRW1haWwgcHJvdG9jb2wgaW4gJE1BSUxfVVJMICgnICtcbiAgICAgICAgbWFpbFVybFN0cmluZyArXG4gICAgICAgIFwiKSBtdXN0IGJlICdzbXRwJyBvciAnc210cHMnXCJcbiAgICApO1xuICB9XG5cbiAgaWYgKG1haWxVcmwucHJvdG9jb2wgPT09ICdzbXRwOicgJiYgbWFpbFVybC5wb3J0ID09PSAnNDY1Jykge1xuICAgIExvZy5kZWJ1ZyhcbiAgICAgIFwiVGhlICRNQUlMX1VSTCBpcyAnc210cDovLy4uLjo0NjUnLiAgXCIgK1xuICAgICAgICBcIllvdSBwcm9iYWJseSB3YW50ICdzbXRwczovLycgKFRoZSAncycgZW5hYmxlcyBUTFMvU1NMKSBcIiArXG4gICAgICAgIFwic2luY2UgJzQ2NScgaXMgdHlwaWNhbGx5IGEgc2VjdXJlIHBvcnQuXCJcbiAgICApO1xuICB9XG5cbiAgLy8gQWxsb3cgb3ZlcnJpZGluZyBwb29sIHNldHRpbmcsIGJ1dCBkZWZhdWx0IHRvIHRydWUuXG4gIGlmICghbWFpbFVybC5xdWVyeSkge1xuICAgIG1haWxVcmwucXVlcnkgPSB7fTtcbiAgfVxuXG4gIGlmICghbWFpbFVybC5xdWVyeS5wb29sKSB7XG4gICAgbWFpbFVybC5xdWVyeS5wb29sID0gJ3RydWUnO1xuICB9XG5cbiAgY29uc3QgdHJhbnNwb3J0ID0gbm9kZW1haWxlci5jcmVhdGVUcmFuc3BvcnQodXJsLmZvcm1hdChtYWlsVXJsKSk7XG5cbiAgdHJhbnNwb3J0Ll9zeW5jU2VuZE1haWwgPSBNZXRlb3Iud3JhcEFzeW5jKHRyYW5zcG9ydC5zZW5kTWFpbCwgdHJhbnNwb3J0KTtcbiAgcmV0dXJuIHRyYW5zcG9ydDtcbn07XG5cbi8vIE1vcmUgaW5mbzogaHR0cHM6Ly9ub2RlbWFpbGVyLmNvbS9zbXRwL3dlbGwta25vd24vXG5jb25zdCBrbm93bkhvc3RzVHJhbnNwb3J0ID0gZnVuY3Rpb24oc2V0dGluZ3MgPSB1bmRlZmluZWQsIHVybCA9IHVuZGVmaW5lZCkge1xuICBsZXQgc2VydmljZSwgdXNlciwgcGFzc3dvcmQ7XG5cbiAgY29uc3QgaGFzU2V0dGluZ3MgPSBzZXR0aW5ncyAmJiBPYmplY3Qua2V5cyhzZXR0aW5ncykubGVuZ3RoO1xuXG4gIGlmICh1cmwgJiYgIWhhc1NldHRpbmdzKSB7XG4gICAgbGV0IGhvc3QgPSB1cmwuc3BsaXQoJzonKVswXTtcbiAgICBjb25zdCB1cmxPYmplY3QgPSBuZXcgVVJMKHVybCk7XG4gICAgaWYgKGhvc3QgPT09ICdodHRwJyB8fCBob3N0ID09PSAnaHR0cHMnKSB7XG4gICAgICAvLyBMb29rIHRvIGhvc3RuYW1lIGZvciBzZXJ2aWNlXG4gICAgICBob3N0ID0gdXJsT2JqZWN0Lmhvc3RuYW1lO1xuICAgICAgdXNlciA9IHVybE9iamVjdC51c2VybmFtZTtcbiAgICAgIHBhc3N3b3JkID0gdXJsT2JqZWN0LnBhc3N3b3JkO1xuICAgIH0gZWxzZSBpZiAodXJsT2JqZWN0LnByb3RvY29sICYmIHVybE9iamVjdC51c2VybmFtZSAmJiB1cmxPYmplY3QucGFzc3dvcmQpIHtcbiAgICAgIC8vIFdlIGhhdmUgc29tZSBkYXRhIGZyb20gdXJsT2JqZWN0XG4gICAgICBob3N0ID0gdXJsT2JqZWN0LnByb3RvY29sLnNwbGl0KCc6JylbMF07XG4gICAgICB1c2VyID0gdXJsT2JqZWN0LnVzZXJuYW1lO1xuICAgICAgcGFzc3dvcmQgPSB1cmxPYmplY3QucGFzc3dvcmQ7XG4gICAgfSBlbHNlIHtcbiAgICAgIC8vIFdlIG5lZWQgdG8gZGlzZWN0IHRoZSBVUkwgb3Vyc2VsdmVzIHRvIGdldCB0aGUgZGF0YVxuICAgICAgLy8gRmlyc3QgZ2V0IHJpZCBvZiB0aGUgbGVhZGluZyAnLy8nIGFuZCBzcGxpdCB0byB1c2VybmFtZSBhbmQgdGhlIHJlc3RcbiAgICAgIGNvbnN0IHRlbXAgPSB1cmxPYmplY3QucGF0aG5hbWUuc3Vic3RyaW5nKDIpPy5zcGxpdCgnOicpO1xuICAgICAgdXNlciA9IHRlbXBbMF07XG4gICAgICAvLyBOb3cgd2Ugc3BsaXQgYnkgJ0AnIHRvIGdldCBwYXNzd29yZCBhbmQgaG9zdG5hbWVcbiAgICAgIGNvbnN0IHRlbXAyID0gdGVtcFsxXS5zcGxpdCgnQCcpO1xuICAgICAgcGFzc3dvcmQgPSB0ZW1wMlswXTtcbiAgICAgIGhvc3QgPSB0ZW1wMlsxXTtcbiAgICB9XG4gICAgc2VydmljZSA9IGhvc3Q7XG4gIH1cblxuICBpZiAoIXdlbGxLbm93KHNldHRpbmdzPy5zZXJ2aWNlIHx8IHNlcnZpY2UpKSB7XG4gICAgdGhyb3cgbmV3IEVycm9yKFxuICAgICAgJ0NvdWxkIG5vdCByZWNvZ25pemUgZS1tYWlsIHNlcnZpY2UuIFNlZSBsaXN0IGF0IGh0dHBzOi8vbm9kZW1haWxlci5jb20vc210cC93ZWxsLWtub3duLyBmb3Igc2VydmljZXMgdGhhdCB3ZSBjYW4gY29uZmlndXJlIGZvciB5b3UuJ1xuICAgICk7XG4gIH1cblxuICBjb25zdCB0cmFuc3BvcnQgPSBub2RlbWFpbGVyLmNyZWF0ZVRyYW5zcG9ydCh7XG4gICAgc2VydmljZTogc2V0dGluZ3M/LnNlcnZpY2UgfHwgc2VydmljZSxcbiAgICBhdXRoOiB7XG4gICAgICB1c2VyOiBzZXR0aW5ncz8udXNlciB8fCB1c2VyLFxuICAgICAgcGFzczogc2V0dGluZ3M/LnBhc3N3b3JkIHx8IHBhc3N3b3JkLFxuICAgIH0sXG4gIH0pO1xuXG4gIHRyYW5zcG9ydC5fc3luY1NlbmRNYWlsID0gTWV0ZW9yLndyYXBBc3luYyh0cmFuc3BvcnQuc2VuZE1haWwsIHRyYW5zcG9ydCk7XG4gIHJldHVybiB0cmFuc3BvcnQ7XG59O1xuRW1haWxUZXN0Lmtub3dIb3N0c1RyYW5zcG9ydCA9IGtub3duSG9zdHNUcmFuc3BvcnQ7XG5cbmNvbnN0IGdldFRyYW5zcG9ydCA9IGZ1bmN0aW9uKCkge1xuICBjb25zdCBwYWNrYWdlU2V0dGluZ3MgPSBNZXRlb3Iuc2V0dGluZ3MucGFja2FnZXM/LmVtYWlsIHx8IHt9O1xuICAvLyBXZSBkZWxheSB0aGlzIGNoZWNrIHVudGlsIHRoZSBmaXJzdCBjYWxsIHRvIEVtYWlsLnNlbmQsIGluIGNhc2Ugc29tZW9uZVxuICAvLyBzZXQgcHJvY2Vzcy5lbnYuTUFJTF9VUkwgaW4gc3RhcnR1cCBjb2RlLiBUaGVuIHdlIHN0b3JlIGluIGEgY2FjaGUgdW50aWxcbiAgLy8gcHJvY2Vzcy5lbnYuTUFJTF9VUkwgY2hhbmdlcy5cbiAgY29uc3QgdXJsID0gcHJvY2Vzcy5lbnYuTUFJTF9VUkw7XG4gIGlmIChcbiAgICB0aGlzLmNhY2hlS2V5ID09PSB1bmRlZmluZWQgfHxcbiAgICB0aGlzLmNhY2hlS2V5ICE9PSB1cmwgfHxcbiAgICB0aGlzLmNhY2hlS2V5ICE9PSBwYWNrYWdlU2V0dGluZ3Muc2VydmljZSB8fFxuICAgIHRoaXMuY2FjaGVLZXkgIT09ICdzZXR0aW5ncydcbiAgKSB7XG4gICAgaWYgKFxuICAgICAgKHBhY2thZ2VTZXR0aW5ncy5zZXJ2aWNlICYmIHdlbGxLbm93KHBhY2thZ2VTZXR0aW5ncy5zZXJ2aWNlKSkgfHxcbiAgICAgICh1cmwgJiYgd2VsbEtub3cobmV3IFVSTCh1cmwpLmhvc3RuYW1lKSkgfHxcbiAgICAgIHdlbGxLbm93KHVybD8uc3BsaXQoJzonKVswXSB8fCAnJylcbiAgICApIHtcbiAgICAgIHRoaXMuY2FjaGVLZXkgPSBwYWNrYWdlU2V0dGluZ3Muc2VydmljZSB8fCAnc2V0dGluZ3MnO1xuICAgICAgdGhpcy5jYWNoZSA9IGtub3duSG9zdHNUcmFuc3BvcnQocGFja2FnZVNldHRpbmdzLCB1cmwpO1xuICAgIH0gZWxzZSB7XG4gICAgICB0aGlzLmNhY2hlS2V5ID0gdXJsO1xuICAgICAgdGhpcy5jYWNoZSA9IHVybCA/IG1ha2VUcmFuc3BvcnQodXJsLCBwYWNrYWdlU2V0dGluZ3MpIDogbnVsbDtcbiAgICB9XG4gIH1cbiAgcmV0dXJuIHRoaXMuY2FjaGU7XG59O1xuXG5sZXQgbmV4dERldk1vZGVNYWlsSWQgPSAwO1xubGV0IG91dHB1dF9zdHJlYW0gPSBwcm9jZXNzLnN0ZG91dDtcblxuLy8gVGVzdGluZyBob29rc1xuRW1haWxUZXN0Lm92ZXJyaWRlT3V0cHV0U3RyZWFtID0gZnVuY3Rpb24oc3RyZWFtKSB7XG4gIG5leHREZXZNb2RlTWFpbElkID0gMDtcbiAgb3V0cHV0X3N0cmVhbSA9IHN0cmVhbTtcbn07XG5cbkVtYWlsVGVzdC5yZXN0b3JlT3V0cHV0U3RyZWFtID0gZnVuY3Rpb24oKSB7XG4gIG91dHB1dF9zdHJlYW0gPSBwcm9jZXNzLnN0ZG91dDtcbn07XG5cbmNvbnN0IGRldk1vZGVTZW5kID0gZnVuY3Rpb24obWFpbCkge1xuICBsZXQgZGV2TW9kZU1haWxJZCA9IG5leHREZXZNb2RlTWFpbElkKys7XG5cbiAgY29uc3Qgc3RyZWFtID0gb3V0cHV0X3N0cmVhbTtcblxuICAvLyBUaGlzIGFwcHJvYWNoIGRvZXMgbm90IHByZXZlbnQgb3RoZXIgd3JpdGVycyB0byBzdGRvdXQgZnJvbSBpbnRlcmxlYXZpbmcuXG4gIHN0cmVhbS53cml0ZSgnPT09PT09IEJFR0lOIE1BSUwgIycgKyBkZXZNb2RlTWFpbElkICsgJyA9PT09PT1cXG4nKTtcbiAgc3RyZWFtLndyaXRlKFxuICAgICcoTWFpbCBub3Qgc2VudDsgdG8gZW5hYmxlIHNlbmRpbmcsIHNldCB0aGUgTUFJTF9VUkwgJyArXG4gICAgICAnZW52aXJvbm1lbnQgdmFyaWFibGUuKVxcbidcbiAgKTtcbiAgY29uc3QgcmVhZFN0cmVhbSA9IG5ldyBNYWlsQ29tcG9zZXIobWFpbCkuY29tcGlsZSgpLmNyZWF0ZVJlYWRTdHJlYW0oKTtcbiAgcmVhZFN0cmVhbS5waXBlKHN0cmVhbSwgeyBlbmQ6IGZhbHNlIH0pO1xuICBjb25zdCBmdXR1cmUgPSBuZXcgRnV0dXJlKCk7XG4gIHJlYWRTdHJlYW0ub24oJ2VuZCcsIGZ1bmN0aW9uKCkge1xuICAgIHN0cmVhbS53cml0ZSgnPT09PT09IEVORCBNQUlMICMnICsgZGV2TW9kZU1haWxJZCArICcgPT09PT09XFxuJyk7XG4gICAgZnV0dXJlLnJldHVybigpO1xuICB9KTtcbiAgZnV0dXJlLndhaXQoKTtcbn07XG5cbmNvbnN0IHNtdHBTZW5kID0gZnVuY3Rpb24odHJhbnNwb3J0LCBtYWlsKSB7XG4gIHRyYW5zcG9ydC5fc3luY1NlbmRNYWlsKG1haWwpO1xufTtcblxuY29uc3Qgc2VuZEhvb2tzID0gbmV3IEhvb2soKTtcblxuLyoqXG4gKiBAc3VtbWFyeSBIb29rIHRoYXQgcnVucyBiZWZvcmUgZW1haWwgaXMgc2VudC5cbiAqIEBsb2N1cyBTZXJ2ZXJcbiAqXG4gKiBAcGFyYW0gZiB7ZnVuY3Rpb259IHJlY2VpdmVzIHRoZSBhcmd1bWVudHMgdG8gRW1haWwuc2VuZCBhbmQgc2hvdWxkIHJldHVybiB0cnVlIHRvIGdvXG4gKiBhaGVhZCBhbmQgc2VuZCB0aGUgZW1haWwgKG9yIGF0IGxlYXN0LCB0cnkgc3Vic2VxdWVudCBob29rcyksIG9yXG4gKiBmYWxzZSB0byBza2lwIHNlbmRpbmcuXG4gKiBAcmV0dXJucyB7eyBzdG9wOiBmdW5jdGlvbiwgY2FsbGJhY2s6IGZ1bmN0aW9uIH19XG4gKi9cbkVtYWlsLmhvb2tTZW5kID0gZnVuY3Rpb24oZikge1xuICByZXR1cm4gc2VuZEhvb2tzLnJlZ2lzdGVyKGYpO1xufTtcblxuLyoqXG4gKiBAc3VtbWFyeSBPdmVycmlkZXMgc2VuZGluZyBmdW5jdGlvbiB3aXRoIHlvdXIgb3duLlxuICogQGxvY3VzIFNlcnZlclxuICogQHNpbmNlIDIuMlxuICogQHBhcmFtIGYge2Z1bmN0aW9ufSBmdW5jdGlvbiB0aGF0IHdpbGwgcmVjZWl2ZSBvcHRpb25zIGZyb20gdGhlIHNlbmQgZnVuY3Rpb24gYW5kIHVuZGVyIGBwYWNrYWdlU2V0dGluZ3NgIHdpbGxcbiAqIGluY2x1ZGUgdGhlIHBhY2thZ2Ugc2V0dGluZ3MgZnJvbSBNZXRlb3Iuc2V0dGluZ3MucGFja2FnZXMuZW1haWwgZm9yIHlvdXIgY3VzdG9tIHRyYW5zcG9ydCB0byBhY2Nlc3MuXG4gKi9cbkVtYWlsLmN1c3RvbVRyYW5zcG9ydCA9IHVuZGVmaW5lZDtcblxuLyoqXG4gKiBAc3VtbWFyeSBTZW5kIGFuIGVtYWlsLiBUaHJvd3MgYW4gYEVycm9yYCBvbiBmYWlsdXJlIHRvIGNvbnRhY3QgbWFpbCBzZXJ2ZXJcbiAqIG9yIGlmIG1haWwgc2VydmVyIHJldHVybnMgYW4gZXJyb3IuIEFsbCBmaWVsZHMgc2hvdWxkIG1hdGNoXG4gKiBbUkZDNTMyMl0oaHR0cDovL3Rvb2xzLmlldGYub3JnL2h0bWwvcmZjNTMyMikgc3BlY2lmaWNhdGlvbi5cbiAqXG4gKiBJZiB0aGUgYE1BSUxfVVJMYCBlbnZpcm9ubWVudCB2YXJpYWJsZSBpcyBzZXQsIGFjdHVhbGx5IHNlbmRzIHRoZSBlbWFpbC5cbiAqIE90aGVyd2lzZSwgcHJpbnRzIHRoZSBjb250ZW50cyBvZiB0aGUgZW1haWwgdG8gc3RhbmRhcmQgb3V0LlxuICpcbiAqIE5vdGUgdGhhdCB0aGlzIHBhY2thZ2UgaXMgYmFzZWQgb24gKipub2RlbWFpbGVyKiosIHNvIG1ha2Ugc3VyZSB0byByZWZlciB0b1xuICogW3RoZSBkb2N1bWVudGF0aW9uXShodHRwOi8vbm9kZW1haWxlci5jb20vKVxuICogd2hlbiB1c2luZyB0aGUgYGF0dGFjaG1lbnRzYCBvciBgbWFpbENvbXBvc2VyYCBvcHRpb25zLlxuICpcbiAqIEBsb2N1cyBTZXJ2ZXJcbiAqIEBwYXJhbSB7T2JqZWN0fSBvcHRpb25zXG4gKiBAcGFyYW0ge1N0cmluZ30gW29wdGlvbnMuZnJvbV0gXCJGcm9tOlwiIGFkZHJlc3MgKHJlcXVpcmVkKVxuICogQHBhcmFtIHtTdHJpbmd8U3RyaW5nW119IG9wdGlvbnMudG8sY2MsYmNjLHJlcGx5VG9cbiAqICAgXCJUbzpcIiwgXCJDYzpcIiwgXCJCY2M6XCIsIGFuZCBcIlJlcGx5LVRvOlwiIGFkZHJlc3Nlc1xuICogQHBhcmFtIHtTdHJpbmd9IFtvcHRpb25zLmluUmVwbHlUb10gTWVzc2FnZS1JRCB0aGlzIG1lc3NhZ2UgaXMgcmVwbHlpbmcgdG9cbiAqIEBwYXJhbSB7U3RyaW5nfFN0cmluZ1tdfSBbb3B0aW9ucy5yZWZlcmVuY2VzXSBBcnJheSAob3Igc3BhY2Utc2VwYXJhdGVkIHN0cmluZykgb2YgTWVzc2FnZS1JRHMgdG8gcmVmZXIgdG9cbiAqIEBwYXJhbSB7U3RyaW5nfSBbb3B0aW9ucy5tZXNzYWdlSWRdIE1lc3NhZ2UtSUQgZm9yIHRoaXMgbWVzc2FnZTsgb3RoZXJ3aXNlLCB3aWxsIGJlIHNldCB0byBhIHJhbmRvbSB2YWx1ZVxuICogQHBhcmFtIHtTdHJpbmd9IFtvcHRpb25zLnN1YmplY3RdICBcIlN1YmplY3Q6XCIgbGluZVxuICogQHBhcmFtIHtTdHJpbmd9IFtvcHRpb25zLnRleHR8aHRtbF0gTWFpbCBib2R5IChpbiBwbGFpbiB0ZXh0IGFuZC9vciBIVE1MKVxuICogQHBhcmFtIHtTdHJpbmd9IFtvcHRpb25zLndhdGNoSHRtbF0gTWFpbCBib2R5IGluIEhUTUwgc3BlY2lmaWMgZm9yIEFwcGxlIFdhdGNoXG4gKiBAcGFyYW0ge1N0cmluZ30gW29wdGlvbnMuaWNhbEV2ZW50XSBpQ2FsZW5kYXIgZXZlbnQgYXR0YWNobWVudFxuICogQHBhcmFtIHtPYmplY3R9IFtvcHRpb25zLmhlYWRlcnNdIERpY3Rpb25hcnkgb2YgY3VzdG9tIGhlYWRlcnMgLSBlLmcuIGB7IFwiaGVhZGVyIG5hbWVcIjogXCJoZWFkZXIgdmFsdWVcIiB9YC4gVG8gc2V0IGFuIG9iamVjdCB1bmRlciBhIGhlYWRlciBuYW1lLCB1c2UgYEpTT04uc3RyaW5naWZ5YCAtIGUuZy4gYHsgXCJoZWFkZXIgbmFtZVwiOiBKU09OLnN0cmluZ2lmeSh7IHRyYWNraW5nOiB7IGxldmVsOiAnZnVsbCcgfSB9KSB9YC5cbiAqIEBwYXJhbSB7T2JqZWN0W119IFtvcHRpb25zLmF0dGFjaG1lbnRzXSBBcnJheSBvZiBhdHRhY2htZW50IG9iamVjdHMsIGFzXG4gKiBkZXNjcmliZWQgaW4gdGhlIFtub2RlbWFpbGVyIGRvY3VtZW50YXRpb25dKGh0dHBzOi8vbm9kZW1haWxlci5jb20vbWVzc2FnZS9hdHRhY2htZW50cy8pLlxuICogQHBhcmFtIHtNYWlsQ29tcG9zZXJ9IFtvcHRpb25zLm1haWxDb21wb3Nlcl0gQSBbTWFpbENvbXBvc2VyXShodHRwczovL25vZGVtYWlsZXIuY29tL2V4dHJhcy9tYWlsY29tcG9zZXIvI2UtbWFpbC1tZXNzYWdlLWZpZWxkcylcbiAqIG9iamVjdCByZXByZXNlbnRpbmcgdGhlIG1lc3NhZ2UgdG8gYmUgc2VudC4gIE92ZXJyaWRlcyBhbGwgb3RoZXIgb3B0aW9ucy5cbiAqIFlvdSBjYW4gY3JlYXRlIGEgYE1haWxDb21wb3NlcmAgb2JqZWN0IHZpYVxuICogYG5ldyBFbWFpbEludGVybmFscy5OcG1Nb2R1bGVzLm1haWxjb21wb3Nlci5tb2R1bGVgLlxuICovXG5FbWFpbC5zZW5kID0gZnVuY3Rpb24ob3B0aW9ucykge1xuICBpZiAob3B0aW9ucy5tYWlsQ29tcG9zZXIpIHtcbiAgICBvcHRpb25zID0gb3B0aW9ucy5tYWlsQ29tcG9zZXIubWFpbDtcbiAgfVxuXG4gIGxldCBzZW5kID0gdHJ1ZTtcbiAgc2VuZEhvb2tzLmZvckVhY2goaG9vayA9PiB7XG4gICAgc2VuZCA9IGhvb2sob3B0aW9ucyk7XG4gICAgcmV0dXJuIHNlbmQ7XG4gIH0pO1xuICBpZiAoIXNlbmQpIHJldHVybjtcblxuICBjb25zdCBjdXN0b21UcmFuc3BvcnQgPSBFbWFpbC5jdXN0b21UcmFuc3BvcnQ7XG4gIGlmIChjdXN0b21UcmFuc3BvcnQpIHtcbiAgICBjb25zdCBwYWNrYWdlU2V0dGluZ3MgPSBNZXRlb3Iuc2V0dGluZ3MucGFja2FnZXM/LmVtYWlsIHx8IHt9O1xuICAgIGN1c3RvbVRyYW5zcG9ydCh7IHBhY2thZ2VTZXR0aW5ncywgLi4ub3B0aW9ucyB9KTtcbiAgICByZXR1cm47XG4gIH1cblxuICBjb25zdCBtYWlsVXJsRW52ID0gcHJvY2Vzcy5lbnYuTUFJTF9VUkw7XG4gIGNvbnN0IG1haWxVcmxTZXR0aW5ncyA9IE1ldGVvci5zZXR0aW5ncy5wYWNrYWdlcz8uZW1haWw7XG5cbiAgaWYgKE1ldGVvci5pc1Byb2R1Y3Rpb24gJiYgIW1haWxVcmxFbnYgJiYgIW1haWxVcmxTZXR0aW5ncykge1xuICAgIC8vIFRoaXMgY2hlY2sgaXMgbW9zdGx5IG5lY2Vzc2FyeSB3aGVuIHVzaW5nIHRoZSBmbGFnIC0tcHJvZHVjdGlvbiB3aGVuIHJ1bm5pbmcgbG9jYWxseS5cbiAgICAvLyBBbmQgaXQgd29ya3MgYXMgYSByZW1pbmRlciB0byBwcm9wZXJseSBzZXQgdGhlIG1haWwgVVJMIHdoZW4gcnVubmluZyBsb2NhbGx5LlxuICAgIHRocm93IG5ldyBFcnJvcihcbiAgICAgICdZb3UgaGF2ZSBub3QgcHJvdmlkZWQgYSBtYWlsIFVSTC4gWW91IGNhbiBwcm92aWRlIGl0IGJ5IHVzaW5nIHRoZSBlbnZpcm9ubWVudCB2YXJpYWJsZSBNQUlMX1VSTCBvciB5b3VyIHNldHRpbmdzLiBZb3UgY2FuIHJlYWQgbW9yZSBhYm91dCBpdCBoZXJlOiBodHRwczovL2RvY3MubWV0ZW9yLmNvbS9hcGkvZW1haWwuaHRtbC4nXG4gICAgKTtcbiAgfVxuXG4gIGlmIChtYWlsVXJsRW52IHx8IG1haWxVcmxTZXR0aW5ncykge1xuICAgIGNvbnN0IHRyYW5zcG9ydCA9IGdldFRyYW5zcG9ydCgpO1xuICAgIHNtdHBTZW5kKHRyYW5zcG9ydCwgb3B0aW9ucyk7XG4gICAgcmV0dXJuO1xuICB9XG4gIGRldk1vZGVTZW5kKG9wdGlvbnMpO1xufTtcbiJdfQ==
