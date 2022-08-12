(function () {

/* Imports */
var Meteor = Package.meteor.Meteor;
var global = Package.meteor.global;
var meteorEnv = Package.meteor.meteorEnv;
var RateLimiter = Package['rate-limit'].RateLimiter;
var ECMAScript = Package.ecmascript.ECMAScript;
var meteorInstall = Package.modules.meteorInstall;
var Promise = Package.promise.Promise;

/* Package-scope variables */
var DDPRateLimiter;

var require = meteorInstall({"node_modules":{"meteor":{"ddp-rate-limiter":{"ddp-rate-limiter.js":function module(require,exports,module){

//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
// packages/ddp-rate-limiter/ddp-rate-limiter.js                                //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////
                                                                                //
module.export({
  DDPRateLimiter: () => DDPRateLimiter
});
let RateLimiter;
module.link("meteor/rate-limit", {
  RateLimiter(v) {
    RateLimiter = v;
  }

}, 0);
// Rate Limiter built into DDP with a default error message. See README or
// online documentation for more details.
const DDPRateLimiter = {};

let errorMessage = rateLimitResult => {
  return 'Error, too many requests. Please slow down. You must wait ' + "".concat(Math.ceil(rateLimitResult.timeToReset / 1000), " seconds before ") + 'trying again.';
};

const rateLimiter = new RateLimiter();

DDPRateLimiter.getErrorMessage = rateLimitResult => {
  if (typeof errorMessage === 'function') {
    return errorMessage(rateLimitResult);
  } else {
    return errorMessage;
  }
};
/**
 * @summary Set error message text when method or subscription rate limit
 * exceeded.
 * @param {string|function} message Functions are passed in an object with a
 * `timeToReset` field that specifies the number of milliseconds until the next
 * method or subscription is allowed to run. The function must return a string
 * of the error message.
 * @locus Server
 */


DDPRateLimiter.setErrorMessage = message => {
  errorMessage = message;
};
/**
 * @summary
 * Add a rule that matches against a stream of events describing method or
 * subscription attempts. Each event is an object with the following
 * properties:
 *
 * - `type`: Either "method" or "subscription"
 * - `name`: The name of the method or subscription being called
 * - `userId`: The user ID attempting the method or subscription
 * - `connectionId`: A string representing the user's DDP connection
 * - `clientAddress`: The IP address of the user
 *
 * Returns unique `ruleId` that can be passed to `removeRule`.
 *
 * @param {Object} matcher
 *   Matchers specify which events are counted towards a rate limit. A matcher
 *   is an object that has a subset of the same properties as the event objects
 *   described above. Each value in a matcher object is one of the following:
 *
 *   - a string: for the event to satisfy the matcher, this value must be equal
 *   to the value of the same property in the event object
 *
 *   - a function: for the event to satisfy the matcher, the function must
 *   evaluate to true when passed the value of the same property
 *   in the event object
 *
 * Here's how events are counted: Each event that satisfies the matcher's
 * filter is mapped to a bucket. Buckets are uniquely determined by the
 * event object's values for all properties present in both the matcher and
 * event objects.
 *
 * @param {number} numRequests  number of requests allowed per time interval.
 * Default = 10.
 * @param {number} timeInterval time interval in milliseconds after which
 * rule's counters are reset. Default = 1000.
 * @param {function} callback function to be called after a rule is executed.
 * @locus Server
 */


DDPRateLimiter.addRule = (matcher, numRequests, timeInterval, callback) => rateLimiter.addRule(matcher, numRequests, timeInterval, callback);

DDPRateLimiter.printRules = () => rateLimiter.rules;
/**
 * @summary Removes the specified rule from the rate limiter. If rule had
 * hit a rate limit, that limit is removed as well.
 * @param  {string} id 'ruleId' returned from `addRule`
 * @return {boolean}    True if a rule was removed.
 * @locus Server
 */


DDPRateLimiter.removeRule = id => rateLimiter.removeRule(id); // This is accessed inside livedata_server.js, but shouldn't be called by any
// user.


DDPRateLimiter._increment = input => {
  rateLimiter.increment(input);
};

DDPRateLimiter._check = input => rateLimiter.check(input);
//////////////////////////////////////////////////////////////////////////////////

}}}}},{
  "extensions": [
    ".js",
    ".json"
  ]
});

var exports = require("/node_modules/meteor/ddp-rate-limiter/ddp-rate-limiter.js");

/* Exports */
Package._define("ddp-rate-limiter", exports, {
  DDPRateLimiter: DDPRateLimiter
});

})();

//# sourceURL=meteor://💻app/packages/ddp-rate-limiter.js
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvZGRwLXJhdGUtbGltaXRlci9kZHAtcmF0ZS1saW1pdGVyLmpzIl0sIm5hbWVzIjpbIm1vZHVsZSIsImV4cG9ydCIsIkREUFJhdGVMaW1pdGVyIiwiUmF0ZUxpbWl0ZXIiLCJsaW5rIiwidiIsImVycm9yTWVzc2FnZSIsInJhdGVMaW1pdFJlc3VsdCIsIk1hdGgiLCJjZWlsIiwidGltZVRvUmVzZXQiLCJyYXRlTGltaXRlciIsImdldEVycm9yTWVzc2FnZSIsInNldEVycm9yTWVzc2FnZSIsIm1lc3NhZ2UiLCJhZGRSdWxlIiwibWF0Y2hlciIsIm51bVJlcXVlc3RzIiwidGltZUludGVydmFsIiwiY2FsbGJhY2siLCJwcmludFJ1bGVzIiwicnVsZXMiLCJyZW1vdmVSdWxlIiwiaWQiLCJfaW5jcmVtZW50IiwiaW5wdXQiLCJpbmNyZW1lbnQiLCJfY2hlY2siLCJjaGVjayJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OztBQUFBQSxNQUFNLENBQUNDLE1BQVAsQ0FBYztBQUFDQyxnQkFBYyxFQUFDLE1BQUlBO0FBQXBCLENBQWQ7QUFBbUQsSUFBSUMsV0FBSjtBQUFnQkgsTUFBTSxDQUFDSSxJQUFQLENBQVksbUJBQVosRUFBZ0M7QUFBQ0QsYUFBVyxDQUFDRSxDQUFELEVBQUc7QUFBQ0YsZUFBVyxHQUFDRSxDQUFaO0FBQWM7O0FBQTlCLENBQWhDLEVBQWdFLENBQWhFO0FBRW5FO0FBQ0E7QUFDQSxNQUFNSCxjQUFjLEdBQUcsRUFBdkI7O0FBRUEsSUFBSUksWUFBWSxHQUFJQyxlQUFELElBQXFCO0FBQ3RDLFNBQU8seUVBQ0ZDLElBQUksQ0FBQ0MsSUFBTCxDQUFVRixlQUFlLENBQUNHLFdBQWhCLEdBQThCLElBQXhDLENBREUsd0JBRUwsZUFGRjtBQUdELENBSkQ7O0FBTUEsTUFBTUMsV0FBVyxHQUFHLElBQUlSLFdBQUosRUFBcEI7O0FBRUFELGNBQWMsQ0FBQ1UsZUFBZixHQUFrQ0wsZUFBRCxJQUFxQjtBQUNwRCxNQUFJLE9BQU9ELFlBQVAsS0FBd0IsVUFBNUIsRUFBd0M7QUFDdEMsV0FBT0EsWUFBWSxDQUFDQyxlQUFELENBQW5CO0FBQ0QsR0FGRCxNQUVPO0FBQ0wsV0FBT0QsWUFBUDtBQUNEO0FBQ0YsQ0FORDtBQVFBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7O0FBQ0FKLGNBQWMsQ0FBQ1csZUFBZixHQUFrQ0MsT0FBRCxJQUFhO0FBQzVDUixjQUFZLEdBQUdRLE9BQWY7QUFDRCxDQUZEO0FBSUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTs7O0FBQ0FaLGNBQWMsQ0FBQ2EsT0FBZixHQUF5QixDQUFDQyxPQUFELEVBQVVDLFdBQVYsRUFBdUJDLFlBQXZCLEVBQXFDQyxRQUFyQyxLQUN2QlIsV0FBVyxDQUFDSSxPQUFaLENBQW9CQyxPQUFwQixFQUE2QkMsV0FBN0IsRUFBMENDLFlBQTFDLEVBQXdEQyxRQUF4RCxDQURGOztBQUdBakIsY0FBYyxDQUFDa0IsVUFBZixHQUE0QixNQUFNVCxXQUFXLENBQUNVLEtBQTlDO0FBRUE7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7OztBQUNBbkIsY0FBYyxDQUFDb0IsVUFBZixHQUE0QkMsRUFBRSxJQUFJWixXQUFXLENBQUNXLFVBQVosQ0FBdUJDLEVBQXZCLENBQWxDLEMsQ0FFQTtBQUNBOzs7QUFDQXJCLGNBQWMsQ0FBQ3NCLFVBQWYsR0FBNkJDLEtBQUQsSUFBVztBQUNyQ2QsYUFBVyxDQUFDZSxTQUFaLENBQXNCRCxLQUF0QjtBQUNELENBRkQ7O0FBSUF2QixjQUFjLENBQUN5QixNQUFmLEdBQXdCRixLQUFLLElBQUlkLFdBQVcsQ0FBQ2lCLEtBQVosQ0FBa0JILEtBQWxCLENBQWpDLEMiLCJmaWxlIjoiL3BhY2thZ2VzL2RkcC1yYXRlLWxpbWl0ZXIuanMiLCJzb3VyY2VzQ29udGVudCI6WyJpbXBvcnQgeyBSYXRlTGltaXRlciB9IGZyb20gJ21ldGVvci9yYXRlLWxpbWl0JztcblxuLy8gUmF0ZSBMaW1pdGVyIGJ1aWx0IGludG8gRERQIHdpdGggYSBkZWZhdWx0IGVycm9yIG1lc3NhZ2UuIFNlZSBSRUFETUUgb3Jcbi8vIG9ubGluZSBkb2N1bWVudGF0aW9uIGZvciBtb3JlIGRldGFpbHMuXG5jb25zdCBERFBSYXRlTGltaXRlciA9IHt9O1xuXG5sZXQgZXJyb3JNZXNzYWdlID0gKHJhdGVMaW1pdFJlc3VsdCkgPT4ge1xuICByZXR1cm4gJ0Vycm9yLCB0b28gbWFueSByZXF1ZXN0cy4gUGxlYXNlIHNsb3cgZG93bi4gWW91IG11c3Qgd2FpdCAnICtcbiAgICBgJHtNYXRoLmNlaWwocmF0ZUxpbWl0UmVzdWx0LnRpbWVUb1Jlc2V0IC8gMTAwMCl9IHNlY29uZHMgYmVmb3JlIGAgK1xuICAgICd0cnlpbmcgYWdhaW4uJztcbn07XG5cbmNvbnN0IHJhdGVMaW1pdGVyID0gbmV3IFJhdGVMaW1pdGVyKCk7XG5cbkREUFJhdGVMaW1pdGVyLmdldEVycm9yTWVzc2FnZSA9IChyYXRlTGltaXRSZXN1bHQpID0+IHtcbiAgaWYgKHR5cGVvZiBlcnJvck1lc3NhZ2UgPT09ICdmdW5jdGlvbicpIHtcbiAgICByZXR1cm4gZXJyb3JNZXNzYWdlKHJhdGVMaW1pdFJlc3VsdCk7XG4gIH0gZWxzZSB7XG4gICAgcmV0dXJuIGVycm9yTWVzc2FnZTtcbiAgfVxufTtcblxuLyoqXG4gKiBAc3VtbWFyeSBTZXQgZXJyb3IgbWVzc2FnZSB0ZXh0IHdoZW4gbWV0aG9kIG9yIHN1YnNjcmlwdGlvbiByYXRlIGxpbWl0XG4gKiBleGNlZWRlZC5cbiAqIEBwYXJhbSB7c3RyaW5nfGZ1bmN0aW9ufSBtZXNzYWdlIEZ1bmN0aW9ucyBhcmUgcGFzc2VkIGluIGFuIG9iamVjdCB3aXRoIGFcbiAqIGB0aW1lVG9SZXNldGAgZmllbGQgdGhhdCBzcGVjaWZpZXMgdGhlIG51bWJlciBvZiBtaWxsaXNlY29uZHMgdW50aWwgdGhlIG5leHRcbiAqIG1ldGhvZCBvciBzdWJzY3JpcHRpb24gaXMgYWxsb3dlZCB0byBydW4uIFRoZSBmdW5jdGlvbiBtdXN0IHJldHVybiBhIHN0cmluZ1xuICogb2YgdGhlIGVycm9yIG1lc3NhZ2UuXG4gKiBAbG9jdXMgU2VydmVyXG4gKi9cbkREUFJhdGVMaW1pdGVyLnNldEVycm9yTWVzc2FnZSA9IChtZXNzYWdlKSA9PiB7XG4gIGVycm9yTWVzc2FnZSA9IG1lc3NhZ2U7XG59O1xuXG4vKipcbiAqIEBzdW1tYXJ5XG4gKiBBZGQgYSBydWxlIHRoYXQgbWF0Y2hlcyBhZ2FpbnN0IGEgc3RyZWFtIG9mIGV2ZW50cyBkZXNjcmliaW5nIG1ldGhvZCBvclxuICogc3Vic2NyaXB0aW9uIGF0dGVtcHRzLiBFYWNoIGV2ZW50IGlzIGFuIG9iamVjdCB3aXRoIHRoZSBmb2xsb3dpbmdcbiAqIHByb3BlcnRpZXM6XG4gKlxuICogLSBgdHlwZWA6IEVpdGhlciBcIm1ldGhvZFwiIG9yIFwic3Vic2NyaXB0aW9uXCJcbiAqIC0gYG5hbWVgOiBUaGUgbmFtZSBvZiB0aGUgbWV0aG9kIG9yIHN1YnNjcmlwdGlvbiBiZWluZyBjYWxsZWRcbiAqIC0gYHVzZXJJZGA6IFRoZSB1c2VyIElEIGF0dGVtcHRpbmcgdGhlIG1ldGhvZCBvciBzdWJzY3JpcHRpb25cbiAqIC0gYGNvbm5lY3Rpb25JZGA6IEEgc3RyaW5nIHJlcHJlc2VudGluZyB0aGUgdXNlcidzIEREUCBjb25uZWN0aW9uXG4gKiAtIGBjbGllbnRBZGRyZXNzYDogVGhlIElQIGFkZHJlc3Mgb2YgdGhlIHVzZXJcbiAqXG4gKiBSZXR1cm5zIHVuaXF1ZSBgcnVsZUlkYCB0aGF0IGNhbiBiZSBwYXNzZWQgdG8gYHJlbW92ZVJ1bGVgLlxuICpcbiAqIEBwYXJhbSB7T2JqZWN0fSBtYXRjaGVyXG4gKiAgIE1hdGNoZXJzIHNwZWNpZnkgd2hpY2ggZXZlbnRzIGFyZSBjb3VudGVkIHRvd2FyZHMgYSByYXRlIGxpbWl0LiBBIG1hdGNoZXJcbiAqICAgaXMgYW4gb2JqZWN0IHRoYXQgaGFzIGEgc3Vic2V0IG9mIHRoZSBzYW1lIHByb3BlcnRpZXMgYXMgdGhlIGV2ZW50IG9iamVjdHNcbiAqICAgZGVzY3JpYmVkIGFib3ZlLiBFYWNoIHZhbHVlIGluIGEgbWF0Y2hlciBvYmplY3QgaXMgb25lIG9mIHRoZSBmb2xsb3dpbmc6XG4gKlxuICogICAtIGEgc3RyaW5nOiBmb3IgdGhlIGV2ZW50IHRvIHNhdGlzZnkgdGhlIG1hdGNoZXIsIHRoaXMgdmFsdWUgbXVzdCBiZSBlcXVhbFxuICogICB0byB0aGUgdmFsdWUgb2YgdGhlIHNhbWUgcHJvcGVydHkgaW4gdGhlIGV2ZW50IG9iamVjdFxuICpcbiAqICAgLSBhIGZ1bmN0aW9uOiBmb3IgdGhlIGV2ZW50IHRvIHNhdGlzZnkgdGhlIG1hdGNoZXIsIHRoZSBmdW5jdGlvbiBtdXN0XG4gKiAgIGV2YWx1YXRlIHRvIHRydWUgd2hlbiBwYXNzZWQgdGhlIHZhbHVlIG9mIHRoZSBzYW1lIHByb3BlcnR5XG4gKiAgIGluIHRoZSBldmVudCBvYmplY3RcbiAqXG4gKiBIZXJlJ3MgaG93IGV2ZW50cyBhcmUgY291bnRlZDogRWFjaCBldmVudCB0aGF0IHNhdGlzZmllcyB0aGUgbWF0Y2hlcidzXG4gKiBmaWx0ZXIgaXMgbWFwcGVkIHRvIGEgYnVja2V0LiBCdWNrZXRzIGFyZSB1bmlxdWVseSBkZXRlcm1pbmVkIGJ5IHRoZVxuICogZXZlbnQgb2JqZWN0J3MgdmFsdWVzIGZvciBhbGwgcHJvcGVydGllcyBwcmVzZW50IGluIGJvdGggdGhlIG1hdGNoZXIgYW5kXG4gKiBldmVudCBvYmplY3RzLlxuICpcbiAqIEBwYXJhbSB7bnVtYmVyfSBudW1SZXF1ZXN0cyAgbnVtYmVyIG9mIHJlcXVlc3RzIGFsbG93ZWQgcGVyIHRpbWUgaW50ZXJ2YWwuXG4gKiBEZWZhdWx0ID0gMTAuXG4gKiBAcGFyYW0ge251bWJlcn0gdGltZUludGVydmFsIHRpbWUgaW50ZXJ2YWwgaW4gbWlsbGlzZWNvbmRzIGFmdGVyIHdoaWNoXG4gKiBydWxlJ3MgY291bnRlcnMgYXJlIHJlc2V0LiBEZWZhdWx0ID0gMTAwMC5cbiAqIEBwYXJhbSB7ZnVuY3Rpb259IGNhbGxiYWNrIGZ1bmN0aW9uIHRvIGJlIGNhbGxlZCBhZnRlciBhIHJ1bGUgaXMgZXhlY3V0ZWQuXG4gKiBAbG9jdXMgU2VydmVyXG4gKi9cbkREUFJhdGVMaW1pdGVyLmFkZFJ1bGUgPSAobWF0Y2hlciwgbnVtUmVxdWVzdHMsIHRpbWVJbnRlcnZhbCwgY2FsbGJhY2spID0+IFxuICByYXRlTGltaXRlci5hZGRSdWxlKG1hdGNoZXIsIG51bVJlcXVlc3RzLCB0aW1lSW50ZXJ2YWwsIGNhbGxiYWNrKTtcblxuRERQUmF0ZUxpbWl0ZXIucHJpbnRSdWxlcyA9ICgpID0+IHJhdGVMaW1pdGVyLnJ1bGVzO1xuXG4vKipcbiAqIEBzdW1tYXJ5IFJlbW92ZXMgdGhlIHNwZWNpZmllZCBydWxlIGZyb20gdGhlIHJhdGUgbGltaXRlci4gSWYgcnVsZSBoYWRcbiAqIGhpdCBhIHJhdGUgbGltaXQsIHRoYXQgbGltaXQgaXMgcmVtb3ZlZCBhcyB3ZWxsLlxuICogQHBhcmFtICB7c3RyaW5nfSBpZCAncnVsZUlkJyByZXR1cm5lZCBmcm9tIGBhZGRSdWxlYFxuICogQHJldHVybiB7Ym9vbGVhbn0gICAgVHJ1ZSBpZiBhIHJ1bGUgd2FzIHJlbW92ZWQuXG4gKiBAbG9jdXMgU2VydmVyXG4gKi9cbkREUFJhdGVMaW1pdGVyLnJlbW92ZVJ1bGUgPSBpZCA9PiByYXRlTGltaXRlci5yZW1vdmVSdWxlKGlkKTtcblxuLy8gVGhpcyBpcyBhY2Nlc3NlZCBpbnNpZGUgbGl2ZWRhdGFfc2VydmVyLmpzLCBidXQgc2hvdWxkbid0IGJlIGNhbGxlZCBieSBhbnlcbi8vIHVzZXIuXG5ERFBSYXRlTGltaXRlci5faW5jcmVtZW50ID0gKGlucHV0KSA9PiB7XG4gIHJhdGVMaW1pdGVyLmluY3JlbWVudChpbnB1dCk7XG59O1xuXG5ERFBSYXRlTGltaXRlci5fY2hlY2sgPSBpbnB1dCA9PiByYXRlTGltaXRlci5jaGVjayhpbnB1dCk7XG5cbmV4cG9ydCB7IEREUFJhdGVMaW1pdGVyIH07XG4iXX0=
