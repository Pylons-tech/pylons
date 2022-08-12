(function () {

/* Imports */
var Meteor = Package.meteor.Meteor;
var global = Package.meteor.global;
var meteorEnv = Package.meteor.meteorEnv;
var meteorInstall = Package.modules.meteorInstall;

/* Package-scope variables */
var URL, URLSearchParams;

var require = meteorInstall({"node_modules":{"meteor":{"url":{"server.js":function module(require,exports,module){

///////////////////////////////////////////////////////////////////////////////////
//                                                                               //
// packages/url/server.js                                                        //
//                                                                               //
///////////////////////////////////////////////////////////////////////////////////
                                                                                 //
const { URL, URLSearchParams } = require('url');

exports.URL = URL;
exports.URLSearchParams = URLSearchParams;

const { setMinimumBrowserVersions } = require("meteor/modern-browsers");

// https://caniuse.com/#feat=url
setMinimumBrowserVersions({
   // Since there is no IE12, this effectively excludes Internet Explorer
  // (pre-Edge) from the modern classification. #9818 #9839
  ie: 12,
  chrome: 32,
  edge: 12,
  firefox: 26,
  mobile_safari: 8,
  opera: 36,
  safari: [7, 1],
  phantomjs: Infinity,
  // https://github.com/Kilian/electron-to-chromium/blob/master/full-versions.js
  electron: [0, 20],
}, module.id);

// backwards compatibility
Object.assign(exports.URL, require('./bc/url_server'));

///////////////////////////////////////////////////////////////////////////////////

},"bc":{"url_common.js":function module(require,exports){

///////////////////////////////////////////////////////////////////////////////////
//                                                                               //
// packages/url/bc/url_common.js                                                 //
//                                                                               //
///////////////////////////////////////////////////////////////////////////////////
                                                                                 //
function encodeString(str) {
  return encodeURIComponent(str).replace(/\*/g, '%2A');
}

// Encode URL parameters into a query string, handling nested objects and
// arrays properly.
var _encodeParams = function (params, prefix) {
  var str = [];
  var isParamsArray = Array.isArray(params);
  for (var p in params) {
    if (Object.prototype.hasOwnProperty.call(params, p)) {
      var k = prefix ? prefix + '[' + (isParamsArray ? '' : p) + ']' : p;
      var v = params[p];
      if (typeof v === 'object') {
        str.push(_encodeParams(v, k));
      } else {
        var encodedKey =
          encodeString(k).replace('%5B', '[').replace('%5D', ']');
        str.push(encodedKey + '=' + encodeString(v));
      }
    }
  }
  return str.join('&').replace(/%20/g, '+');
};

exports._encodeParams = _encodeParams;

exports.buildUrl = function(before_qmark, from_qmark, opt_query, opt_params) {
  var url_without_query = before_qmark;
  var query = from_qmark ? from_qmark.slice(1) : null;

  if (typeof opt_query === "string")
    query = String(opt_query);

  if (opt_params) {
    query = query || "";
    var prms = _encodeParams(opt_params);
    if (query && prms)
      query += '&';
    query += prms;
  }

  var url = url_without_query;
  if (query !== null)
    url += ("?"+query);

  return url;
};

///////////////////////////////////////////////////////////////////////////////////

},"url_server.js":function module(require,exports){

///////////////////////////////////////////////////////////////////////////////////
//                                                                               //
// packages/url/bc/url_server.js                                                 //
//                                                                               //
///////////////////////////////////////////////////////////////////////////////////
                                                                                 //
var url_util = require('url');
var common = require("./url_common.js");

exports._constructUrl = function (url, query, params) {
  var url_parts = url_util.parse(url);
  return common.buildUrl(
    url_parts.protocol + "//" + url_parts.host + url_parts.pathname,
    url_parts.search,
    query,
    params
  );
};

exports._encodeParams = common._encodeParams;
///////////////////////////////////////////////////////////////////////////////////

}}}}}},{
  "extensions": [
    ".js",
    ".json"
  ]
});

var exports = require("/node_modules/meteor/url/server.js");

/* Exports */
Package._define("url", exports, {
  URL: URL,
  URLSearchParams: URLSearchParams
});

})();
