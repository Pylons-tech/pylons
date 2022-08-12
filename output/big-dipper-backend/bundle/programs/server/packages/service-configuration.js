(function () {

/* Imports */
var Meteor = Package.meteor.Meteor;
var global = Package.meteor.global;
var meteorEnv = Package.meteor.meteorEnv;
var Accounts = Package['accounts-base'].Accounts;
var MongoInternals = Package.mongo.MongoInternals;
var Mongo = Package.mongo.Mongo;
var ECMAScript = Package.ecmascript.ECMAScript;
var meteorInstall = Package.modules.meteorInstall;
var Promise = Package.promise.Promise;

/* Package-scope variables */
var ServiceConfiguration;

var require = meteorInstall({"node_modules":{"meteor":{"service-configuration":{"service_configuration_common.js":function module(){

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                        //
// packages/service-configuration/service_configuration_common.js                                         //
//                                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                          //
if (typeof ServiceConfiguration === 'undefined') {
  ServiceConfiguration = {};
} // Table containing documents with configuration options for each
// login service


ServiceConfiguration.configurations = new Mongo.Collection('meteor_accounts_loginServiceConfiguration', {
  _preventAutopublish: true,
  connection: Meteor.isClient ? Accounts.connection : Meteor.connection
}); // Leave this collection open in insecure mode. In theory, someone could
// hijack your oauth connect requests to a different endpoint or appId,
// but you did ask for 'insecure'. The advantage is that it is much
// easier to write a configuration wizard that works only in insecure
// mode.
// Thrown when trying to use a login service which is not configured

ServiceConfiguration.ConfigError = function (serviceName) {
  if (Meteor.isClient && !Accounts.loginServicesConfigured()) {
    this.message = 'Login service configuration not yet loaded';
  } else if (serviceName) {
    this.message = 'Service ' + serviceName + ' not configured';
  } else {
    this.message = 'Service not configured';
  }
};

ServiceConfiguration.ConfigError.prototype = new Error();
ServiceConfiguration.ConfigError.prototype.name = 'ServiceConfiguration.ConfigError';
////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"service_configuration_server.js":function module(require,exports,module){

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                        //
// packages/service-configuration/service_configuration_server.js                                         //
//                                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                          //
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);

// Only one configuration should ever exist for each service.
// A unique index helps avoid various race conditions which could
// otherwise lead to an inconsistent database state (when there are multiple
// configurations for a single service, which configuration is correct?)
try {
  ServiceConfiguration.configurations.createIndex({
    service: 1
  }, {
    unique: true
  });
} catch (err) {
  console.error('The service-configuration package persists configuration in the ' + 'meteor_accounts_loginServiceConfiguration collection in MongoDB. As ' + 'each service should have exactly one configuration, Meteor ' + 'automatically creates a MongoDB index with a unique constraint on the ' + ' meteor_accounts_loginServiceConfiguration collection. The ' + 'createIndex command which creates that index is failing.\n\n' + 'Meteor versions before 1.0.4 did not create this index. If you recently ' + 'upgraded and are seeing this error message for the first time, please ' + 'check your meteor_accounts_loginServiceConfiguration collection for ' + 'multiple configuration entries for the same service and delete ' + 'configuration entries until there is no more than one configuration ' + 'entry per service.\n\n' + 'If the meteor_accounts_loginServiceConfiguration collection looks ' + 'fine, the createIndex command is failing for some other reason.\n\n' + 'For more information on this history of this issue, please see ' + 'https://github.com/meteor/meteor/pull/3514.\n');
  throw err;
}

Meteor.startup(() => {
  var _Meteor$settings, _Meteor$settings$pack;

  const settings = (_Meteor$settings = Meteor.settings) === null || _Meteor$settings === void 0 ? void 0 : (_Meteor$settings$pack = _Meteor$settings.packages) === null || _Meteor$settings$pack === void 0 ? void 0 : _Meteor$settings$pack['service-configuration'];
  if (!settings) return;
  Object.keys(settings).forEach(key => {
    ServiceConfiguration.configurations.upsert({
      service: key
    }, {
      $set: settings[key]
    });
  });
});
////////////////////////////////////////////////////////////////////////////////////////////////////////////

}}}}},{
  "extensions": [
    ".js",
    ".json"
  ]
});

require("/node_modules/meteor/service-configuration/service_configuration_common.js");
require("/node_modules/meteor/service-configuration/service_configuration_server.js");

/* Exports */
Package._define("service-configuration", {
  ServiceConfiguration: ServiceConfiguration
});

})();

//# sourceURL=meteor://💻app/packages/service-configuration.js
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvc2VydmljZS1jb25maWd1cmF0aW9uL3NlcnZpY2VfY29uZmlndXJhdGlvbl9jb21tb24uanMiLCJtZXRlb3I6Ly/wn5K7YXBwL3BhY2thZ2VzL3NlcnZpY2UtY29uZmlndXJhdGlvbi9zZXJ2aWNlX2NvbmZpZ3VyYXRpb25fc2VydmVyLmpzIl0sIm5hbWVzIjpbIlNlcnZpY2VDb25maWd1cmF0aW9uIiwiY29uZmlndXJhdGlvbnMiLCJNb25nbyIsIkNvbGxlY3Rpb24iLCJfcHJldmVudEF1dG9wdWJsaXNoIiwiY29ubmVjdGlvbiIsIk1ldGVvciIsImlzQ2xpZW50IiwiQWNjb3VudHMiLCJDb25maWdFcnJvciIsInNlcnZpY2VOYW1lIiwibG9naW5TZXJ2aWNlc0NvbmZpZ3VyZWQiLCJtZXNzYWdlIiwicHJvdG90eXBlIiwiRXJyb3IiLCJuYW1lIiwibW9kdWxlIiwibGluayIsInYiLCJjcmVhdGVJbmRleCIsInNlcnZpY2UiLCJ1bmlxdWUiLCJlcnIiLCJjb25zb2xlIiwiZXJyb3IiLCJzdGFydHVwIiwic2V0dGluZ3MiLCJwYWNrYWdlcyIsIk9iamVjdCIsImtleXMiLCJmb3JFYWNoIiwia2V5IiwidXBzZXJ0IiwiJHNldCJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7O0FBQUEsSUFBSSxPQUFPQSxvQkFBUCxLQUFnQyxXQUFwQyxFQUFpRDtBQUMvQ0Esc0JBQW9CLEdBQUcsRUFBdkI7QUFDRCxDLENBRUQ7QUFDQTs7O0FBQ0FBLG9CQUFvQixDQUFDQyxjQUFyQixHQUFzQyxJQUFJQyxLQUFLLENBQUNDLFVBQVYsQ0FDcEMsMkNBRG9DLEVBRXBDO0FBQ0VDLHFCQUFtQixFQUFFLElBRHZCO0FBRUVDLFlBQVUsRUFBRUMsTUFBTSxDQUFDQyxRQUFQLEdBQWtCQyxRQUFRLENBQUNILFVBQTNCLEdBQXdDQyxNQUFNLENBQUNEO0FBRjdELENBRm9DLENBQXRDLEMsQ0FPQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBRUE7O0FBQ0FMLG9CQUFvQixDQUFDUyxXQUFyQixHQUFtQyxVQUFTQyxXQUFULEVBQXNCO0FBQ3ZELE1BQUlKLE1BQU0sQ0FBQ0MsUUFBUCxJQUFtQixDQUFDQyxRQUFRLENBQUNHLHVCQUFULEVBQXhCLEVBQTREO0FBQzFELFNBQUtDLE9BQUwsR0FBZSw0Q0FBZjtBQUNELEdBRkQsTUFFTyxJQUFJRixXQUFKLEVBQWlCO0FBQ3RCLFNBQUtFLE9BQUwsR0FBZSxhQUFhRixXQUFiLEdBQTJCLGlCQUExQztBQUNELEdBRk0sTUFFQTtBQUNMLFNBQUtFLE9BQUwsR0FBZSx3QkFBZjtBQUNEO0FBQ0YsQ0FSRDs7QUFTQVosb0JBQW9CLENBQUNTLFdBQXJCLENBQWlDSSxTQUFqQyxHQUE2QyxJQUFJQyxLQUFKLEVBQTdDO0FBQ0FkLG9CQUFvQixDQUFDUyxXQUFyQixDQUFpQ0ksU0FBakMsQ0FBMkNFLElBQTNDLEdBQ0Usa0NBREYsQzs7Ozs7Ozs7Ozs7QUM5QkEsSUFBSVQsTUFBSjtBQUFXVSxNQUFNLENBQUNDLElBQVAsQ0FBWSxlQUFaLEVBQTRCO0FBQUNYLFFBQU0sQ0FBQ1ksQ0FBRCxFQUFHO0FBQUNaLFVBQU0sR0FBQ1ksQ0FBUDtBQUFTOztBQUFwQixDQUE1QixFQUFrRCxDQUFsRDs7QUFFWDtBQUNBO0FBQ0E7QUFDQTtBQUNBLElBQUk7QUFDRmxCLHNCQUFvQixDQUFDQyxjQUFyQixDQUFvQ2tCLFdBQXBDLENBQ0U7QUFBRUMsV0FBTyxFQUFFO0FBQVgsR0FERixFQUVFO0FBQUVDLFVBQU0sRUFBRTtBQUFWLEdBRkY7QUFJRCxDQUxELENBS0UsT0FBT0MsR0FBUCxFQUFZO0FBQ1pDLFNBQU8sQ0FBQ0MsS0FBUixDQUNFLHFFQUNFLHNFQURGLEdBRUUsNkRBRkYsR0FHRSx3RUFIRixHQUlFLDZEQUpGLEdBS0UsOERBTEYsR0FNRSwwRUFORixHQU9FLHdFQVBGLEdBUUUsc0VBUkYsR0FTRSxpRUFURixHQVVFLHNFQVZGLEdBV0Usd0JBWEYsR0FZRSxvRUFaRixHQWFFLHFFQWJGLEdBY0UsaUVBZEYsR0FlRSwrQ0FoQko7QUFrQkEsUUFBTUYsR0FBTjtBQUNEOztBQUVEaEIsTUFBTSxDQUFDbUIsT0FBUCxDQUFlLE1BQU07QUFBQTs7QUFDbkIsUUFBTUMsUUFBUSx1QkFBR3BCLE1BQU0sQ0FBQ29CLFFBQVYsOEVBQUcsaUJBQWlCQyxRQUFwQiwwREFBRyxzQkFBNEIsdUJBQTVCLENBQWpCO0FBQ0EsTUFBSSxDQUFDRCxRQUFMLEVBQWU7QUFDZkUsUUFBTSxDQUFDQyxJQUFQLENBQVlILFFBQVosRUFBc0JJLE9BQXRCLENBQThCQyxHQUFHLElBQUk7QUFDbkMvQix3QkFBb0IsQ0FBQ0MsY0FBckIsQ0FBb0MrQixNQUFwQyxDQUNFO0FBQUVaLGFBQU8sRUFBRVc7QUFBWCxLQURGLEVBRUU7QUFDRUUsVUFBSSxFQUFFUCxRQUFRLENBQUNLLEdBQUQ7QUFEaEIsS0FGRjtBQU1ELEdBUEQ7QUFRRCxDQVhELEUiLCJmaWxlIjoiL3BhY2thZ2VzL3NlcnZpY2UtY29uZmlndXJhdGlvbi5qcyIsInNvdXJjZXNDb250ZW50IjpbImlmICh0eXBlb2YgU2VydmljZUNvbmZpZ3VyYXRpb24gPT09ICd1bmRlZmluZWQnKSB7XG4gIFNlcnZpY2VDb25maWd1cmF0aW9uID0ge307XG59XG5cbi8vIFRhYmxlIGNvbnRhaW5pbmcgZG9jdW1lbnRzIHdpdGggY29uZmlndXJhdGlvbiBvcHRpb25zIGZvciBlYWNoXG4vLyBsb2dpbiBzZXJ2aWNlXG5TZXJ2aWNlQ29uZmlndXJhdGlvbi5jb25maWd1cmF0aW9ucyA9IG5ldyBNb25nby5Db2xsZWN0aW9uKFxuICAnbWV0ZW9yX2FjY291bnRzX2xvZ2luU2VydmljZUNvbmZpZ3VyYXRpb24nLFxuICB7XG4gICAgX3ByZXZlbnRBdXRvcHVibGlzaDogdHJ1ZSxcbiAgICBjb25uZWN0aW9uOiBNZXRlb3IuaXNDbGllbnQgPyBBY2NvdW50cy5jb25uZWN0aW9uIDogTWV0ZW9yLmNvbm5lY3Rpb24sXG4gIH1cbik7XG4vLyBMZWF2ZSB0aGlzIGNvbGxlY3Rpb24gb3BlbiBpbiBpbnNlY3VyZSBtb2RlLiBJbiB0aGVvcnksIHNvbWVvbmUgY291bGRcbi8vIGhpamFjayB5b3VyIG9hdXRoIGNvbm5lY3QgcmVxdWVzdHMgdG8gYSBkaWZmZXJlbnQgZW5kcG9pbnQgb3IgYXBwSWQsXG4vLyBidXQgeW91IGRpZCBhc2sgZm9yICdpbnNlY3VyZScuIFRoZSBhZHZhbnRhZ2UgaXMgdGhhdCBpdCBpcyBtdWNoXG4vLyBlYXNpZXIgdG8gd3JpdGUgYSBjb25maWd1cmF0aW9uIHdpemFyZCB0aGF0IHdvcmtzIG9ubHkgaW4gaW5zZWN1cmVcbi8vIG1vZGUuXG5cbi8vIFRocm93biB3aGVuIHRyeWluZyB0byB1c2UgYSBsb2dpbiBzZXJ2aWNlIHdoaWNoIGlzIG5vdCBjb25maWd1cmVkXG5TZXJ2aWNlQ29uZmlndXJhdGlvbi5Db25maWdFcnJvciA9IGZ1bmN0aW9uKHNlcnZpY2VOYW1lKSB7XG4gIGlmIChNZXRlb3IuaXNDbGllbnQgJiYgIUFjY291bnRzLmxvZ2luU2VydmljZXNDb25maWd1cmVkKCkpIHtcbiAgICB0aGlzLm1lc3NhZ2UgPSAnTG9naW4gc2VydmljZSBjb25maWd1cmF0aW9uIG5vdCB5ZXQgbG9hZGVkJztcbiAgfSBlbHNlIGlmIChzZXJ2aWNlTmFtZSkge1xuICAgIHRoaXMubWVzc2FnZSA9ICdTZXJ2aWNlICcgKyBzZXJ2aWNlTmFtZSArICcgbm90IGNvbmZpZ3VyZWQnO1xuICB9IGVsc2Uge1xuICAgIHRoaXMubWVzc2FnZSA9ICdTZXJ2aWNlIG5vdCBjb25maWd1cmVkJztcbiAgfVxufTtcblNlcnZpY2VDb25maWd1cmF0aW9uLkNvbmZpZ0Vycm9yLnByb3RvdHlwZSA9IG5ldyBFcnJvcigpO1xuU2VydmljZUNvbmZpZ3VyYXRpb24uQ29uZmlnRXJyb3IucHJvdG90eXBlLm5hbWUgPVxuICAnU2VydmljZUNvbmZpZ3VyYXRpb24uQ29uZmlnRXJyb3InO1xuIiwiaW1wb3J0IHsgTWV0ZW9yIH0gZnJvbSAnbWV0ZW9yL21ldGVvcic7XG5cbi8vIE9ubHkgb25lIGNvbmZpZ3VyYXRpb24gc2hvdWxkIGV2ZXIgZXhpc3QgZm9yIGVhY2ggc2VydmljZS5cbi8vIEEgdW5pcXVlIGluZGV4IGhlbHBzIGF2b2lkIHZhcmlvdXMgcmFjZSBjb25kaXRpb25zIHdoaWNoIGNvdWxkXG4vLyBvdGhlcndpc2UgbGVhZCB0byBhbiBpbmNvbnNpc3RlbnQgZGF0YWJhc2Ugc3RhdGUgKHdoZW4gdGhlcmUgYXJlIG11bHRpcGxlXG4vLyBjb25maWd1cmF0aW9ucyBmb3IgYSBzaW5nbGUgc2VydmljZSwgd2hpY2ggY29uZmlndXJhdGlvbiBpcyBjb3JyZWN0PylcbnRyeSB7XG4gIFNlcnZpY2VDb25maWd1cmF0aW9uLmNvbmZpZ3VyYXRpb25zLmNyZWF0ZUluZGV4KFxuICAgIHsgc2VydmljZTogMSB9LFxuICAgIHsgdW5pcXVlOiB0cnVlIH1cbiAgKTtcbn0gY2F0Y2ggKGVycikge1xuICBjb25zb2xlLmVycm9yKFxuICAgICdUaGUgc2VydmljZS1jb25maWd1cmF0aW9uIHBhY2thZ2UgcGVyc2lzdHMgY29uZmlndXJhdGlvbiBpbiB0aGUgJyArXG4gICAgICAnbWV0ZW9yX2FjY291bnRzX2xvZ2luU2VydmljZUNvbmZpZ3VyYXRpb24gY29sbGVjdGlvbiBpbiBNb25nb0RCLiBBcyAnICtcbiAgICAgICdlYWNoIHNlcnZpY2Ugc2hvdWxkIGhhdmUgZXhhY3RseSBvbmUgY29uZmlndXJhdGlvbiwgTWV0ZW9yICcgK1xuICAgICAgJ2F1dG9tYXRpY2FsbHkgY3JlYXRlcyBhIE1vbmdvREIgaW5kZXggd2l0aCBhIHVuaXF1ZSBjb25zdHJhaW50IG9uIHRoZSAnICtcbiAgICAgICcgbWV0ZW9yX2FjY291bnRzX2xvZ2luU2VydmljZUNvbmZpZ3VyYXRpb24gY29sbGVjdGlvbi4gVGhlICcgK1xuICAgICAgJ2NyZWF0ZUluZGV4IGNvbW1hbmQgd2hpY2ggY3JlYXRlcyB0aGF0IGluZGV4IGlzIGZhaWxpbmcuXFxuXFxuJyArXG4gICAgICAnTWV0ZW9yIHZlcnNpb25zIGJlZm9yZSAxLjAuNCBkaWQgbm90IGNyZWF0ZSB0aGlzIGluZGV4LiBJZiB5b3UgcmVjZW50bHkgJyArXG4gICAgICAndXBncmFkZWQgYW5kIGFyZSBzZWVpbmcgdGhpcyBlcnJvciBtZXNzYWdlIGZvciB0aGUgZmlyc3QgdGltZSwgcGxlYXNlICcgK1xuICAgICAgJ2NoZWNrIHlvdXIgbWV0ZW9yX2FjY291bnRzX2xvZ2luU2VydmljZUNvbmZpZ3VyYXRpb24gY29sbGVjdGlvbiBmb3IgJyArXG4gICAgICAnbXVsdGlwbGUgY29uZmlndXJhdGlvbiBlbnRyaWVzIGZvciB0aGUgc2FtZSBzZXJ2aWNlIGFuZCBkZWxldGUgJyArXG4gICAgICAnY29uZmlndXJhdGlvbiBlbnRyaWVzIHVudGlsIHRoZXJlIGlzIG5vIG1vcmUgdGhhbiBvbmUgY29uZmlndXJhdGlvbiAnICtcbiAgICAgICdlbnRyeSBwZXIgc2VydmljZS5cXG5cXG4nICtcbiAgICAgICdJZiB0aGUgbWV0ZW9yX2FjY291bnRzX2xvZ2luU2VydmljZUNvbmZpZ3VyYXRpb24gY29sbGVjdGlvbiBsb29rcyAnICtcbiAgICAgICdmaW5lLCB0aGUgY3JlYXRlSW5kZXggY29tbWFuZCBpcyBmYWlsaW5nIGZvciBzb21lIG90aGVyIHJlYXNvbi5cXG5cXG4nICtcbiAgICAgICdGb3IgbW9yZSBpbmZvcm1hdGlvbiBvbiB0aGlzIGhpc3Rvcnkgb2YgdGhpcyBpc3N1ZSwgcGxlYXNlIHNlZSAnICtcbiAgICAgICdodHRwczovL2dpdGh1Yi5jb20vbWV0ZW9yL21ldGVvci9wdWxsLzM1MTQuXFxuJ1xuICApO1xuICB0aHJvdyBlcnI7XG59XG5cbk1ldGVvci5zdGFydHVwKCgpID0+IHtcbiAgY29uc3Qgc2V0dGluZ3MgPSBNZXRlb3Iuc2V0dGluZ3M/LnBhY2thZ2VzPy5bJ3NlcnZpY2UtY29uZmlndXJhdGlvbiddO1xuICBpZiAoIXNldHRpbmdzKSByZXR1cm47XG4gIE9iamVjdC5rZXlzKHNldHRpbmdzKS5mb3JFYWNoKGtleSA9PiB7XG4gICAgU2VydmljZUNvbmZpZ3VyYXRpb24uY29uZmlndXJhdGlvbnMudXBzZXJ0KFxuICAgICAgeyBzZXJ2aWNlOiBrZXkgfSxcbiAgICAgIHtcbiAgICAgICAgJHNldDogc2V0dGluZ3Nba2V5XSxcbiAgICAgIH1cbiAgICApO1xuICB9KTtcbn0pO1xuIl19
