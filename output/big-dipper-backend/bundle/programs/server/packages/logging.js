(function () {

/* Imports */
var Meteor = Package.meteor.Meteor;
var global = Package.meteor.global;
var meteorEnv = Package.meteor.meteorEnv;
var EJSON = Package.ejson.EJSON;
var ECMAScript = Package.ecmascript.ECMAScript;
var meteorInstall = Package.modules.meteorInstall;
var Promise = Package.promise.Promise;

/* Package-scope variables */
var Formatter, Log;

var require = meteorInstall({"node_modules":{"meteor":{"logging":{"logging.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                             //
// packages/logging/logging.js                                                                                 //
//                                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                               //
let _objectSpread;

module.link("@babel/runtime/helpers/objectSpread2", {
  default(v) {
    _objectSpread = v;
  }

}, 0);
module.export({
  Log: () => Log
});
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
const hasOwn = Object.prototype.hasOwnProperty;

function Log() {
  Log.info(...arguments);
} /// FOR TESTING


let intercept = 0;
let interceptedLines = [];
let suppress = 0; // Intercept the next 'count' calls to a Log function. The actual
// lines printed to the console can be cleared and read by calling
// Log._intercepted().

Log._intercept = count => {
  intercept += count;
}; // Suppress the next 'count' calls to a Log function. Use this to stop
// tests from spamming the console, especially with red errors that
// might look like a failing test.


Log._suppress = count => {
  suppress += count;
}; // Returns intercepted lines and resets the intercept counter.


Log._intercepted = () => {
  const lines = interceptedLines;
  interceptedLines = [];
  intercept = 0;
  return lines;
}; // Either 'json' or 'colored-text'.
//
// When this is set to 'json', print JSON documents that are parsed by another
// process ('satellite' or 'meteor run'). This other process should call
// 'Log.format' for nice output.
//
// When this is set to 'colored-text', call 'Log.format' before printing.
// This should be used for logging from within satellite, since there is no
// other process that will be reading its standard output.


Log.outputFormat = 'json';
const LEVEL_COLORS = {
  debug: 'green',
  // leave info as the default color
  warn: 'magenta',
  error: 'red'
};
const META_COLOR = 'blue'; // Default colors cause readability problems on Windows Powershell,
// switch to bright variants. While still capable of millions of
// operations per second, the benchmark showed a 25%+ increase in
// ops per second (on Node 8) by caching "process.platform".

const isWin32 = typeof process === 'object' && process.platform === 'win32';

const platformColor = color => {
  if (isWin32 && typeof color === 'string' && !color.endsWith('Bright')) {
    return "".concat(color, "Bright");
  }

  return color;
}; // XXX package


const RESTRICTED_KEYS = ['time', 'timeInexact', 'level', 'file', 'line', 'program', 'originApp', 'satellite', 'stderr'];
const FORMATTED_KEYS = [...RESTRICTED_KEYS, 'app', 'message'];

const logInBrowser = obj => {
  const str = Log.format(obj); // XXX Some levels should be probably be sent to the server

  const level = obj.level;

  if (typeof console !== 'undefined' && console[level]) {
    console[level](str);
  } else {
    // IE doesn't have console.log.apply, it's not a real Object.
    // http://stackoverflow.com/questions/5538972/console-log-apply-not-working-in-ie9
    // http://patik.com/blog/complete-cross-browser-console-log/
    if (typeof console.log.apply === "function") {
      // Most browsers
      console.log.apply(console, [str]);
    } else if (typeof Function.prototype.bind === "function") {
      // IE9
      const log = Function.prototype.bind.call(console.log, console);
      log.apply(console, [str]);
    }
  }
}; // @returns {Object: { line: Number, file: String }}


Log._getCallerDetails = () => {
  const getStack = () => {
    // We do NOT use Error.prepareStackTrace here (a V8 extension that gets us a
    // pre-parsed stack) since it's impossible to compose it with the use of
    // Error.prepareStackTrace used on the server for source maps.
    const err = new Error();
    const stack = err.stack;
    return stack;
  };

  const stack = getStack();
  if (!stack) return {}; // looking for the first line outside the logging package (or an
  // eval if we find that first)

  let line;
  const lines = stack.split('\n').slice(1);

  for (line of lines) {
    if (line.match(/^\s*(at eval \(eval)|(eval:)/)) {
      return {
        file: "eval"
      };
    }

    if (!line.match(/packages\/(?:local-test[:_])?logging(?:\/|\.js)/)) {
      break;
    }
  }

  const details = {}; // The format for FF is 'functionName@filePath:lineNumber'
  // The format for V8 is 'functionName (packages/logging/logging.js:81)' or
  //                      'packages/logging/logging.js:81'

  const match = /(?:[@(]| at )([^(]+?):([0-9:]+)(?:\)|$)/.exec(line);

  if (!match) {
    return details;
  } // in case the matched block here is line:column


  details.line = match[2].split(':')[0]; // Possible format: https://foo.bar.com/scripts/file.js?random=foobar
  // XXX: if you can write the following in better way, please do it
  // XXX: what about evals?

  details.file = match[1].split('/').slice(-1)[0].split('?')[0];
  return details;
};

['debug', 'info', 'warn', 'error'].forEach(level => {
  // @param arg {String|Object}
  Log[level] = arg => {
    if (suppress) {
      suppress--;
      return;
    }

    let intercepted = false;

    if (intercept) {
      intercept--;
      intercepted = true;
    }

    let obj = arg === Object(arg) && !(arg instanceof RegExp) && !(arg instanceof Date) ? arg : {
      message: new String(arg).toString()
    };
    RESTRICTED_KEYS.forEach(key => {
      if (obj[key]) {
        throw new Error("Can't set '".concat(key, "' in log message"));
      }
    });

    if (hasOwn.call(obj, 'message') && typeof obj.message !== 'string') {
      throw new Error("The 'message' field in log objects must be a string");
    }

    if (!obj.omitCallerDetails) {
      obj = _objectSpread(_objectSpread({}, Log._getCallerDetails()), obj);
    }

    obj.time = new Date();
    obj.level = level; // If we are in production don't write out debug logs.

    if (level === 'debug' && Meteor.isProduction) {
      return;
    }

    if (intercepted) {
      interceptedLines.push(EJSON.stringify(obj));
    } else if (Meteor.isServer) {
      if (Log.outputFormat === 'colored-text') {
        console.log(Log.format(obj, {
          color: true
        }));
      } else if (Log.outputFormat === 'json') {
        console.log(EJSON.stringify(obj));
      } else {
        throw new Error("Unknown logging output format: ".concat(Log.outputFormat));
      }
    } else {
      logInBrowser(obj);
    }
  };
}); // tries to parse line as EJSON. returns object if parse is successful, or null if not

Log.parse = line => {
  let obj = null;

  if (line && line.startsWith('{')) {
    // might be json generated from calling 'Log'
    try {
      obj = EJSON.parse(line);
    } catch (e) {}
  } // XXX should probably check fields other than 'time'


  if (obj && obj.time && obj.time instanceof Date) {
    return obj;
  } else {
    return null;
  }
}; // formats a log object into colored human and machine-readable text


Log.format = function (obj) {
  let options = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : {};
  obj = _objectSpread({}, obj); // don't mutate the argument

  let {
    time,
    timeInexact,
    level = 'info',
    file,
    line: lineNumber,
    app: appName = '',
    originApp,
    message = '',
    program = '',
    satellite = '',
    stderr = ''
  } = obj;

  if (!(time instanceof Date)) {
    throw new Error("'time' must be a Date object");
  }

  FORMATTED_KEYS.forEach(key => {
    delete obj[key];
  });

  if (Object.keys(obj).length > 0) {
    if (message) {
      message += ' ';
    }

    message += EJSON.stringify(obj);
  }

  const pad2 = n => n.toString().padStart(2, '0');

  const pad3 = n => n.toString().padStart(3, '0');

  const dateStamp = time.getFullYear().toString() + pad2(time.getMonth() + 1
  /*0-based*/
  ) + pad2(time.getDate());
  const timeStamp = pad2(time.getHours()) + ':' + pad2(time.getMinutes()) + ':' + pad2(time.getSeconds()) + '.' + pad3(time.getMilliseconds()); // eg in San Francisco in June this will be '(-7)'

  const utcOffsetStr = "(".concat(-(new Date().getTimezoneOffset() / 60), ")");
  let appInfo = '';

  if (appName) {
    appInfo += appName;
  }

  if (originApp && originApp !== appName) {
    appInfo += " via ".concat(originApp);
  }

  if (appInfo) {
    appInfo = "[".concat(appInfo, "] ");
  }

  const sourceInfoParts = [];

  if (program) {
    sourceInfoParts.push(program);
  }

  if (file) {
    sourceInfoParts.push(file);
  }

  if (lineNumber) {
    sourceInfoParts.push(lineNumber);
  }

  let sourceInfo = !sourceInfoParts.length ? '' : "(".concat(sourceInfoParts.join(':'), ") ");
  if (satellite) sourceInfo += "[".concat(satellite, "]");
  const stderrIndicator = stderr ? '(STDERR) ' : '';
  const metaPrefix = [level.charAt(0).toUpperCase(), dateStamp, '-', timeStamp, utcOffsetStr, timeInexact ? '? ' : ' ', appInfo, sourceInfo, stderrIndicator].join('');
  return Formatter.prettify(metaPrefix, options.color && platformColor(options.metaColor || META_COLOR)) + Formatter.prettify(message, options.color && platformColor(LEVEL_COLORS[level]));
}; // Turn a line of text into a loggable object.
// @param line {String}
// @param override {Object}


Log.objFromText = (line, override) => {
  return _objectSpread({
    message: line,
    level: 'info',
    time: new Date(),
    timeInexact: true
  }, override);
};
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"logging_server.js":function module(require){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                             //
// packages/logging/logging_server.js                                                                          //
//                                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                               //
Formatter = {};

Formatter.prettify = function (line, color) {
  if (!color) return line;
  return require("chalk")[color](line);
};
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"node_modules":{"chalk":{"package.json":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                             //
// node_modules/meteor/logging/node_modules/chalk/package.json                                                 //
//                                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                               //
module.exports = {
  "name": "chalk",
  "version": "4.1.1",
  "main": "source"
};

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"source":{"index.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                             //
// node_modules/meteor/logging/node_modules/chalk/source/index.js                                              //
//                                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                               //
module.useNode();
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}}}}}}}},{
  "extensions": [
    ".js",
    ".json"
  ]
});

var exports = require("/node_modules/meteor/logging/logging.js");
require("/node_modules/meteor/logging/logging_server.js");

/* Exports */
Package._define("logging", exports, {
  Log: Log
});

})();

//# sourceURL=meteor://💻app/packages/logging.js
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvbG9nZ2luZy9sb2dnaW5nLmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9wYWNrYWdlcy9sb2dnaW5nL2xvZ2dpbmdfc2VydmVyLmpzIl0sIm5hbWVzIjpbIl9vYmplY3RTcHJlYWQiLCJtb2R1bGUiLCJsaW5rIiwiZGVmYXVsdCIsInYiLCJleHBvcnQiLCJMb2ciLCJNZXRlb3IiLCJoYXNPd24iLCJPYmplY3QiLCJwcm90b3R5cGUiLCJoYXNPd25Qcm9wZXJ0eSIsImluZm8iLCJpbnRlcmNlcHQiLCJpbnRlcmNlcHRlZExpbmVzIiwic3VwcHJlc3MiLCJfaW50ZXJjZXB0IiwiY291bnQiLCJfc3VwcHJlc3MiLCJfaW50ZXJjZXB0ZWQiLCJsaW5lcyIsIm91dHB1dEZvcm1hdCIsIkxFVkVMX0NPTE9SUyIsImRlYnVnIiwid2FybiIsImVycm9yIiwiTUVUQV9DT0xPUiIsImlzV2luMzIiLCJwcm9jZXNzIiwicGxhdGZvcm0iLCJwbGF0Zm9ybUNvbG9yIiwiY29sb3IiLCJlbmRzV2l0aCIsIlJFU1RSSUNURURfS0VZUyIsIkZPUk1BVFRFRF9LRVlTIiwibG9nSW5Ccm93c2VyIiwib2JqIiwic3RyIiwiZm9ybWF0IiwibGV2ZWwiLCJjb25zb2xlIiwibG9nIiwiYXBwbHkiLCJGdW5jdGlvbiIsImJpbmQiLCJjYWxsIiwiX2dldENhbGxlckRldGFpbHMiLCJnZXRTdGFjayIsImVyciIsIkVycm9yIiwic3RhY2siLCJsaW5lIiwic3BsaXQiLCJzbGljZSIsIm1hdGNoIiwiZmlsZSIsImRldGFpbHMiLCJleGVjIiwiZm9yRWFjaCIsImFyZyIsImludGVyY2VwdGVkIiwiUmVnRXhwIiwiRGF0ZSIsIm1lc3NhZ2UiLCJTdHJpbmciLCJ0b1N0cmluZyIsImtleSIsIm9taXRDYWxsZXJEZXRhaWxzIiwidGltZSIsImlzUHJvZHVjdGlvbiIsInB1c2giLCJFSlNPTiIsInN0cmluZ2lmeSIsImlzU2VydmVyIiwicGFyc2UiLCJzdGFydHNXaXRoIiwiZSIsIm9wdGlvbnMiLCJ0aW1lSW5leGFjdCIsImxpbmVOdW1iZXIiLCJhcHAiLCJhcHBOYW1lIiwib3JpZ2luQXBwIiwicHJvZ3JhbSIsInNhdGVsbGl0ZSIsInN0ZGVyciIsImtleXMiLCJsZW5ndGgiLCJwYWQyIiwibiIsInBhZFN0YXJ0IiwicGFkMyIsImRhdGVTdGFtcCIsImdldEZ1bGxZZWFyIiwiZ2V0TW9udGgiLCJnZXREYXRlIiwidGltZVN0YW1wIiwiZ2V0SG91cnMiLCJnZXRNaW51dGVzIiwiZ2V0U2Vjb25kcyIsImdldE1pbGxpc2Vjb25kcyIsInV0Y09mZnNldFN0ciIsImdldFRpbWV6b25lT2Zmc2V0IiwiYXBwSW5mbyIsInNvdXJjZUluZm9QYXJ0cyIsInNvdXJjZUluZm8iLCJqb2luIiwic3RkZXJySW5kaWNhdG9yIiwibWV0YVByZWZpeCIsImNoYXJBdCIsInRvVXBwZXJDYXNlIiwiRm9ybWF0dGVyIiwicHJldHRpZnkiLCJtZXRhQ29sb3IiLCJvYmpGcm9tVGV4dCIsIm92ZXJyaWRlIiwicmVxdWlyZSJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OztBQUFBLElBQUlBLGFBQUo7O0FBQWtCQyxNQUFNLENBQUNDLElBQVAsQ0FBWSxzQ0FBWixFQUFtRDtBQUFDQyxTQUFPLENBQUNDLENBQUQsRUFBRztBQUFDSixpQkFBYSxHQUFDSSxDQUFkO0FBQWdCOztBQUE1QixDQUFuRCxFQUFpRixDQUFqRjtBQUFsQkgsTUFBTSxDQUFDSSxNQUFQLENBQWM7QUFBQ0MsS0FBRyxFQUFDLE1BQUlBO0FBQVQsQ0FBZDtBQUE2QixJQUFJQyxNQUFKO0FBQVdOLE1BQU0sQ0FBQ0MsSUFBUCxDQUFZLGVBQVosRUFBNEI7QUFBQ0ssUUFBTSxDQUFDSCxDQUFELEVBQUc7QUFBQ0csVUFBTSxHQUFDSCxDQUFQO0FBQVM7O0FBQXBCLENBQTVCLEVBQWtELENBQWxEO0FBRXhDLE1BQU1JLE1BQU0sR0FBR0MsTUFBTSxDQUFDQyxTQUFQLENBQWlCQyxjQUFoQzs7QUFFQSxT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K0MsT0FBTyxDQUFDb0MsU0FBUixJQUFxQnZGLFVBQXRCLENBQTdELElBQ0hxRixTQUFTLENBQUNDLFFBQVYsQ0FBbUJqRCxPQUFuQixFQUE0QmMsT0FBTyxDQUFDOUMsS0FBUixJQUFpQkQsYUFBYSxDQUFDUixZQUFZLENBQUNpQixLQUFELENBQWIsQ0FBMUQsQ0FESjtBQUVELENBMUZELEMsQ0E0RkE7QUFDQTtBQUNBOzs7QUFDQWpDLEdBQUcsQ0FBQzRHLFdBQUosR0FBa0IsQ0FBQy9ELElBQUQsRUFBT2dFLFFBQVAsS0FBb0I7QUFDcEM7QUFDRXBELFdBQU8sRUFBRVosSUFEWDtBQUVFWixTQUFLLEVBQUUsTUFGVDtBQUdFNkIsUUFBSSxFQUFFLElBQUlOLElBQUosRUFIUjtBQUlFZ0IsZUFBVyxFQUFFO0FBSmYsS0FLS3FDLFFBTEw7QUFPRCxDQVJELEM7Ozs7Ozs7Ozs7O0FDN1RBSixTQUFTLEdBQUcsRUFBWjs7QUFDQUEsU0FBUyxDQUFDQyxRQUFWLEdBQXFCLFVBQVM3RCxJQUFULEVBQWVwQixLQUFmLEVBQXFCO0FBQ3RDLE1BQUcsQ0FBQ0EsS0FBSixFQUFXLE9BQU9vQixJQUFQO0FBQ1gsU0FBT2lFLE9BQU8sQ0FBQyxPQUFELENBQVAsQ0FBaUJyRixLQUFqQixFQUF3Qm9CLElBQXhCLENBQVA7QUFDSCxDQUhELEMiLCJmaWxlIjoiL3BhY2thZ2VzL2xvZ2dpbmcuanMiLCJzb3VyY2VzQ29udGVudCI6WyJpbXBvcnQgeyBNZXRlb3IgfSBmcm9tICdtZXRlb3IvbWV0ZW9yJztcblxuY29uc3QgaGFzT3duID0gT2JqZWN0LnByb3RvdHlwZS5oYXNPd25Qcm9wZXJ0eTtcblxuZnVuY3Rpb24gTG9nKC4uLmFyZ3MpIHtcbiAgTG9nLmluZm8oLi4uYXJncyk7XG59XG5cbi8vLyBGT1IgVEVTVElOR1xubGV0IGludGVyY2VwdCA9IDA7XG5sZXQgaW50ZXJjZXB0ZWRMaW5lcyA9IFtdO1xubGV0IHN1cHByZXNzID0gMDtcblxuLy8gSW50ZXJjZXB0IHRoZSBuZXh0ICdjb3VudCcgY2FsbHMgdG8gYSBMb2cgZnVuY3Rpb24uIFRoZSBhY3R1YWxcbi8vIGxpbmVzIHByaW50ZWQgdG8gdGhlIGNvbnNvbGUgY2FuIGJlIGNsZWFyZWQgYW5kIHJlYWQgYnkgY2FsbGluZ1xuLy8gTG9nLl9pbnRlcmNlcHRlZCgpLlxuTG9nLl9pbnRlcmNlcHQgPSAoY291bnQpID0+IHtcbiAgaW50ZXJjZXB0ICs9IGNvdW50O1xufTtcblxuLy8gU3VwcHJlc3MgdGhlIG5leHQgJ2NvdW50JyBjYWxscyB0byBhIExvZyBmdW5jdGlvbi4gVXNlIHRoaXMgdG8gc3RvcFxuLy8gdGVzdHMgZnJvbSBzcGFtbWluZyB0aGUgY29uc29sZSwgZXNwZWNpYWxseSB3aXRoIHJlZCBlcnJvcnMgdGhhdFxuLy8gbWlnaHQgbG9vayBsaWtlIGEgZmFpbGluZyB0ZXN0LlxuTG9nLl9zdXBwcmVzcyA9IChjb3VudCkgPT4ge1xuICBzdXBwcmVzcyArPSBjb3VudDtcbn07XG5cbi8vIFJldHVybnMgaW50ZXJjZXB0ZWQgbGluZXMgYW5kIHJlc2V0cyB0aGUgaW50ZXJjZXB0IGNvdW50ZXIuXG5Mb2cuX2ludGVyY2VwdGVkID0gKCkgPT4ge1xuICBjb25zdCBsaW5lcyA9IGludGVyY2VwdGVkTGluZXM7XG4gIGludGVyY2VwdGVkTGluZXMgPSBbXTtcbiAgaW50ZXJjZXB0ID0gMDtcbiAgcmV0dXJuIGxpbmVzO1xufTtcblxuLy8gRWl0aGVyICdqc29uJyBvciAnY29sb3JlZC10ZXh0Jy5cbi8vXG4vLyBXaGVuIHRoaXMgaXMgc2V0IHRvICdqc29uJywgcHJpbnQgSlNPTiBkb2N1bWVudHMgdGhhdCBhcmUgcGFyc2VkIGJ5IGFub3RoZXJcbi8vIHByb2Nlc3MgKCdzYXRlbGxpdGUnIG9yICdtZXRlb3IgcnVuJykuIFRoaXMgb3RoZXIgcHJvY2VzcyBzaG91bGQgY2FsbFxuLy8gJ0xvZy5mb3JtYXQnIGZvciBuaWNlIG91dHB1dC5cbi8vXG4vLyBXaGVuIHRoaXMgaXMgc2V0IHRvICdjb2xvcmVkLXRleHQnLCBjYWxsICdMb2cuZm9ybWF0JyBiZWZvcmUgcHJpbnRpbmcuXG4vLyBUaGlzIHNob3VsZCBiZSB1c2VkIGZvciBsb2dnaW5nIGZyb20gd2l0aGluIHNhdGVsbGl0ZSwgc2luY2UgdGhlcmUgaXMgbm9cbi8vIG90aGVyIHByb2Nlc3MgdGhhdCB3aWxsIGJlIHJlYWRpbmcgaXRzIHN0YW5kYXJkIG91dHB1dC5cbkxvZy5vdXRwdXRGb3JtYXQgPSAnanNvbic7XG5cbmNvbnN0IExFVkVMX0NPTE9SUyA9IHtcbiAgZGVidWc6ICdncmVlbicsXG4gIC8vIGxlYXZlIGluZm8gYXMgdGhlIGRlZmF1bHQgY29sb3JcbiAgd2FybjogJ21hZ2VudGEnLFxuICBlcnJvcjogJ3JlZCdcbn07XG5cbmNvbnN0IE1FVEFfQ09MT1IgPSAnYmx1ZSc7XG5cbi8vIERlZmF1bHQgY29sb3JzIGNhdXNlIHJlYWRhYmlsaXR5IHByb2JsZW1zIG9uIFdpbmRvd3MgUG93ZXJzaGVsbCxcbi8vIHN3aXRjaCB0byBicmlnaHQgdmFyaWFudHMuIFdoaWxlIHN0aWxsIGNhcGFibGUgb2YgbWlsbGlvbnMgb2Zcbi8vIG9wZXJhdGlvbnMgcGVyIHNlY29uZCwgdGhlIGJlbmNobWFyayBzaG93ZWQgYSAyNSUrIGluY3JlYXNlIGluXG4vLyBvcHMgcGVyIHNlY29uZCAob24gTm9kZSA4KSBieSBjYWNoaW5nIFwicHJvY2Vzcy5wbGF0Zm9ybVwiLlxuY29uc3QgaXNXaW4zMiA9IHR5cGVvZiBwcm9jZXNzID09PSAnb2JqZWN0JyAmJiBwcm9jZXNzLnBsYXRmb3JtID09PSAnd2luMzInO1xuY29uc3QgcGxhdGZvcm1Db2xvciA9IChjb2xvcikgPT4ge1xuICBpZiAoaXNXaW4zMiAmJiB0eXBlb2YgY29sb3IgPT09ICdzdHJpbmcnICYmICFjb2xvci5lbmRzV2l0aCgnQnJpZ2h0JykpIHtcbiAgICByZXR1cm4gYCR7Y29sb3J9QnJpZ2h0YDtcbiAgfVxuICByZXR1cm4gY29sb3I7XG59O1xuXG4vLyBYWFggcGFja2FnZVxuY29uc3QgUkVTVFJJQ1RFRF9LRVlTID0gWyd0aW1lJywgJ3RpbWVJbmV4YWN0JywgJ2xldmVsJywgJ2ZpbGUnLCAnbGluZScsXG4gICAgICAgICAgICAgICAgICAgICAgICAncHJvZ3JhbScsICdvcmlnaW5BcHAnLCAnc2F0ZWxsaXRlJywgJ3N0ZGVyciddO1xuXG5jb25zdCBGT1JNQVRURURfS0VZUyA9IFsuLi5SRVNUUklDVEVEX0tFWVMsICdhcHAnLCAnbWVzc2FnZSddO1xuXG5jb25zdCBsb2dJbkJyb3dzZXIgPSBvYmogPT4ge1xuICBjb25zdCBzdHIgPSBMb2cuZm9ybWF0KG9iaik7XG5cbiAgLy8gWFhYIFNvbWUgbGV2ZWxzIHNob3VsZCBiZSBwcm9iYWJseSBiZSBzZW50IHRvIHRoZSBzZXJ2ZXJcbiAgY29uc3QgbGV2ZWwgPSBvYmoubGV2ZWw7XG5cbiAgaWYgKCh0eXBlb2YgY29uc29sZSAhPT0gJ3VuZGVmaW5lZCcpICYmIGNvbnNvbGVbbGV2ZWxdKSB7XG4gICAgY29uc29sZVtsZXZlbF0oc3RyKTtcbiAgfSBlbHNlIHtcbiAgICAvLyBJRSBkb2Vzbid0IGhhdmUgY29uc29sZS5sb2cuYXBwbHksIGl0J3Mgbm90IGEgcmVhbCBPYmplY3QuXG4gICAgLy8gaHR0cDovL3N0YWNrb3ZlcmZsb3cuY29tL3F1ZXN0aW9ucy81NTM4OTcyL2NvbnNvbGUtbG9nLWFwcGx5LW5vdC13b3JraW5nLWluLWllOVxuICAgIC8vIGh0dHA6Ly9wYXRpay5jb20vYmxvZy9jb21wbGV0ZS1jcm9zcy1icm93c2VyLWNvbnNvbGUtbG9nL1xuICAgIGlmICh0eXBlb2YgY29uc29sZS5sb2cuYXBwbHkgPT09IFwiZnVuY3Rpb25cIikge1xuICAgICAgLy8gTW9zdCBicm93c2Vyc1xuICAgICAgY29uc29sZS5sb2cuYXBwbHkoY29uc29sZSwgW3N0cl0pO1xuXG4gICAgfSBlbHNlIGlmICh0eXBlb2YgRnVuY3Rpb24ucHJvdG90eXBlLmJpbmQgPT09IFwiZnVuY3Rpb25cIikge1xuICAgICAgLy8gSUU5XG4gICAgICBjb25zdCBsb2cgPSBGdW5jdGlvbi5wcm90b3R5cGUuYmluZC5jYWxsKGNvbnNvbGUubG9nLCBjb25zb2xlKTtcbiAgICAgIGxvZy5hcHBseShjb25zb2xlLCBbc3RyXSk7XG4gICAgfVxuICB9XG59O1xuXG4vLyBAcmV0dXJucyB7T2JqZWN0OiB7IGxpbmU6IE51bWJlciwgZmlsZTogU3RyaW5nIH19XG5Mb2cuX2dldENhbGxlckRldGFpbHMgPSAoKSA9PiB7XG4gIGNvbnN0IGdldFN0YWNrID0gKCkgPT4ge1xuICAgIC8vIFdlIGRvIE5PVCB1c2UgRXJyb3IucHJlcGFyZVN0YWNrVHJhY2UgaGVyZSAoYSBWOCBleHRlbnNpb24gdGhhdCBnZXRzIHVzIGFcbiAgICAvLyBwcmUtcGFyc2VkIHN0YWNrKSBzaW5jZSBpdCdzIGltcG9zc2libGUgdG8gY29tcG9zZSBpdCB3aXRoIHRoZSB1c2Ugb2ZcbiAgICAvLyBFcnJvci5wcmVwYXJlU3RhY2tUcmFjZSB1c2VkIG9uIHRoZSBzZXJ2ZXIgZm9yIHNvdXJjZSBtYXBzLlxuICAgIGNvbnN0IGVyciA9IG5ldyBFcnJvcjtcbiAgICBjb25zdCBzdGFjayA9IGVyci5zdGFjaztcbiAgICByZXR1cm4gc3RhY2s7XG4gIH07XG5cbiAgY29uc3Qgc3RhY2sgPSBnZXRTdGFjaygpO1xuXG4gIGlmICghc3RhY2spIHJldHVybiB7fTtcblxuICAvLyBsb29raW5nIGZvciB0aGUgZmlyc3QgbGluZSBvdXRzaWRlIHRoZSBsb2dnaW5nIHBhY2thZ2UgKG9yIGFuXG4gIC8vIGV2YWwgaWYgd2UgZmluZCB0aGF0IGZpcnN0KVxuICBsZXQgbGluZTtcbiAgY29uc3QgbGluZXMgPSBzdGFjay5zcGxpdCgnXFxuJykuc2xpY2UoMSk7XG4gIGZvciAobGluZSBvZiBsaW5lcykge1xuICAgIGlmIChsaW5lLm1hdGNoKC9eXFxzKihhdCBldmFsIFxcKGV2YWwpfChldmFsOikvKSkge1xuICAgICAgcmV0dXJuIHtmaWxlOiBcImV2YWxcIn07XG4gICAgfVxuXG4gICAgaWYgKCFsaW5lLm1hdGNoKC9wYWNrYWdlc1xcLyg/OmxvY2FsLXRlc3RbOl9dKT9sb2dnaW5nKD86XFwvfFxcLmpzKS8pKSB7XG4gICAgICBicmVhaztcbiAgICB9XG4gIH1cblxuICBjb25zdCBkZXRhaWxzID0ge307XG5cbiAgLy8gVGhlIGZvcm1hdCBmb3IgRkYgaXMgJ2Z1bmN0aW9uTmFtZUBmaWxlUGF0aDpsaW5lTnVtYmVyJ1xuICAvLyBUaGUgZm9ybWF0IGZvciBWOCBpcyAnZnVuY3Rpb25OYW1lIChwYWNrYWdlcy9sb2dnaW5nL2xvZ2dpbmcuanM6ODEpJyBvclxuICAvLyAgICAgICAgICAgICAgICAgICAgICAncGFja2FnZXMvbG9nZ2luZy9sb2dnaW5nLmpzOjgxJ1xuICBjb25zdCBtYXRjaCA9IC8oPzpbQChdfCBhdCApKFteKF0rPyk6KFswLTk6XSspKD86XFwpfCQpLy5leGVjKGxpbmUpO1xuICBpZiAoIW1hdGNoKSB7XG4gICAgcmV0dXJuIGRldGFpbHM7XG4gIH1cblxuICAvLyBpbiBjYXNlIHRoZSBtYXRjaGVkIGJsb2NrIGhlcmUgaXMgbGluZTpjb2x1bW5cbiAgZGV0YWlscy5saW5lID0gbWF0Y2hbMl0uc3BsaXQoJzonKVswXTtcblxuICAvLyBQb3NzaWJsZSBmb3JtYXQ6IGh0dHBzOi8vZm9vLmJhci5jb20vc2NyaXB0cy9maWxlLmpzP3JhbmRvbT1mb29iYXJcbiAgLy8gWFhYOiBpZiB5b3UgY2FuIHdyaXRlIHRoZSBmb2xsb3dpbmcgaW4gYmV0dGVyIHdheSwgcGxlYXNlIGRvIGl0XG4gIC8vIFhYWDogd2hhdCBhYm91dCBldmFscz9cbiAgZGV0YWlscy5maWxlID0gbWF0Y2hbMV0uc3BsaXQoJy8nKS5zbGljZSgtMSlbMF0uc3BsaXQoJz8nKVswXTtcblxuICByZXR1cm4gZGV0YWlscztcbn07XG5cblsnZGVidWcnLCAnaW5mbycsICd3YXJuJywgJ2Vycm9yJ10uZm9yRWFjaCgobGV2ZWwpID0+IHtcbiAvLyBAcGFyYW0gYXJnIHtTdHJpbmd8T2JqZWN0fVxuIExvZ1tsZXZlbF0gPSAoYXJnKSA9PiB7XG4gIGlmIChzdXBwcmVzcykge1xuICAgIHN1cHByZXNzLS07XG4gICAgcmV0dXJuO1xuICB9XG5cbiAgbGV0IGludGVyY2VwdGVkID0gZmFsc2U7XG4gIGlmIChpbnRlcmNlcHQpIHtcbiAgICBpbnRlcmNlcHQtLTtcbiAgICBpbnRlcmNlcHRlZCA9IHRydWU7XG4gIH1cblxuICBsZXQgb2JqID0gKGFyZyA9PT0gT2JqZWN0KGFyZylcbiAgICAmJiAhKGFyZyBpbnN0YW5jZW9mIFJlZ0V4cClcbiAgICAmJiAhKGFyZyBpbnN0YW5jZW9mIERhdGUpKVxuICAgID8gYXJnXG4gICAgOiB7IG1lc3NhZ2U6IG5ldyBTdHJpbmcoYXJnKS50b1N0cmluZygpIH07XG5cbiAgUkVTVFJJQ1RFRF9LRVlTLmZvckVhY2goa2V5ID0+IHtcbiAgICBpZiAob2JqW2tleV0pIHtcbiAgICAgIHRocm93IG5ldyBFcnJvcihgQ2FuJ3Qgc2V0ICcke2tleX0nIGluIGxvZyBtZXNzYWdlYCk7XG4gICAgfVxuICB9KTtcblxuICBpZiAoaGFzT3duLmNhbGwob2JqLCAnbWVzc2FnZScpICYmIHR5cGVvZiBvYmoubWVzc2FnZSAhPT0gJ3N0cmluZycpIHtcbiAgICB0aHJvdyBuZXcgRXJyb3IoXCJUaGUgJ21lc3NhZ2UnIGZpZWxkIGluIGxvZyBvYmplY3RzIG11c3QgYmUgYSBzdHJpbmdcIik7XG4gIH1cblxuICBpZiAoIW9iai5vbWl0Q2FsbGVyRGV0YWlscykge1xuICAgIG9iaiA9IHsgLi4uTG9nLl9nZXRDYWxsZXJEZXRhaWxzKCksIC4uLm9iaiB9O1xuICB9XG5cbiAgb2JqLnRpbWUgPSBuZXcgRGF0ZSgpO1xuICBvYmoubGV2ZWwgPSBsZXZlbDtcblxuICAvLyBJZiB3ZSBhcmUgaW4gcHJvZHVjdGlvbiBkb24ndCB3cml0ZSBvdXQgZGVidWcgbG9ncy5cbiAgaWYgKGxldmVsID09PSAnZGVidWcnICYmIE1ldGVvci5pc1Byb2R1Y3Rpb24pIHtcbiAgICByZXR1cm47XG4gIH1cblxuICBpZiAoaW50ZXJjZXB0ZWQpIHtcbiAgICBpbnRlcmNlcHRlZExpbmVzLnB1c2goRUpTT04uc3RyaW5naWZ5KG9iaikpO1xuICB9IGVsc2UgaWYgKE1ldGVvci5pc1NlcnZlcikge1xuICAgIGlmIChMb2cub3V0cHV0Rm9ybWF0ID09PSAnY29sb3JlZC10ZXh0Jykge1xuICAgICAgY29uc29sZS5sb2coTG9nLmZvcm1hdChvYmosIHtjb2xvcjogdHJ1ZX0pKTtcbiAgICB9IGVsc2UgaWYgKExvZy5vdXRwdXRGb3JtYXQgPT09ICdqc29uJykge1xuICAgICAgY29uc29sZS5sb2coRUpTT04uc3RyaW5naWZ5KG9iaikpO1xuICAgIH0gZWxzZSB7XG4gICAgICB0aHJvdyBuZXcgRXJyb3IoYFVua25vd24gbG9nZ2luZyBvdXRwdXQgZm9ybWF0OiAke0xvZy5vdXRwdXRGb3JtYXR9YCk7XG4gICAgfVxuICB9IGVsc2Uge1xuICAgIGxvZ0luQnJvd3NlcihvYmopO1xuICB9XG59O1xufSk7XG5cblxuLy8gdHJpZXMgdG8gcGFyc2UgbGluZSBhcyBFSlNPTi4gcmV0dXJucyBvYmplY3QgaWYgcGFyc2UgaXMgc3VjY2Vzc2Z1bCwgb3IgbnVsbCBpZiBub3RcbkxvZy5wYXJzZSA9IChsaW5lKSA9PiB7XG4gIGxldCBvYmogPSBudWxsO1xuICBpZiAobGluZSAmJiBsaW5lLnN0YXJ0c1dpdGgoJ3snKSkgeyAvLyBtaWdodCBiZSBqc29uIGdlbmVyYXRlZCBmcm9tIGNhbGxpbmcgJ0xvZydcbiAgICB0cnkgeyBvYmogPSBFSlNPTi5wYXJzZShsaW5lKTsgfSBjYXRjaCAoZSkge31cbiAgfVxuXG4gIC8vIFhYWCBzaG91bGQgcHJvYmFibHkgY2hlY2sgZmllbGRzIG90aGVyIHRoYW4gJ3RpbWUnXG4gIGlmIChvYmogJiYgb2JqLnRpbWUgJiYgKG9iai50aW1lIGluc3RhbmNlb2YgRGF0ZSkpIHtcbiAgICByZXR1cm4gb2JqO1xuICB9IGVsc2Uge1xuICAgIHJldHVybiBudWxsO1xuICB9XG59O1xuXG4vLyBmb3JtYXRzIGEgbG9nIG9iamVjdCBpbnRvIGNvbG9yZWQgaHVtYW4gYW5kIG1hY2hpbmUtcmVhZGFibGUgdGV4dFxuTG9nLmZvcm1hdCA9IChvYmosIG9wdGlvbnMgPSB7fSkgPT4ge1xuICBvYmogPSB7IC4uLm9iaiB9OyAvLyBkb24ndCBtdXRhdGUgdGhlIGFyZ3VtZW50XG4gIGxldCB7XG4gICAgdGltZSxcbiAgICB0aW1lSW5leGFjdCxcbiAgICBsZXZlbCA9ICdpbmZvJyxcbiAgICBmaWxlLFxuICAgIGxpbmU6IGxpbmVOdW1iZXIsXG4gICAgYXBwOiBhcHBOYW1lID0gJycsXG4gICAgb3JpZ2luQXBwLFxuICAgIG1lc3NhZ2UgPSAnJyxcbiAgICBwcm9ncmFtID0gJycsXG4gICAgc2F0ZWxsaXRlID0gJycsXG4gICAgc3RkZXJyID0gJycsXG4gIH0gPSBvYmo7XG5cbiAgaWYgKCEodGltZSBpbnN0YW5jZW9mIERhdGUpKSB7XG4gICAgdGhyb3cgbmV3IEVycm9yKFwiJ3RpbWUnIG11c3QgYmUgYSBEYXRlIG9iamVjdFwiKTtcbiAgfVxuXG4gIEZPUk1BVFRFRF9LRVlTLmZvckVhY2goKGtleSkgPT4geyBkZWxldGUgb2JqW2tleV07IH0pO1xuXG4gIGlmIChPYmplY3Qua2V5cyhvYmopLmxlbmd0aCA+IDApIHtcbiAgICBpZiAobWVzc2FnZSkge1xuICAgICAgbWVzc2FnZSArPSAnICc7XG4gICAgfVxuICAgIG1lc3NhZ2UgKz0gRUpTT04uc3RyaW5naWZ5KG9iaik7XG4gIH1cblxuICBjb25zdCBwYWQyID0gbiA9PiBuLnRvU3RyaW5nKCkucGFkU3RhcnQoMiwgJzAnKTtcbiAgY29uc3QgcGFkMyA9IG4gPT4gbi50b1N0cmluZygpLnBhZFN0YXJ0KDMsICcwJyk7XG5cbiAgY29uc3QgZGF0ZVN0YW1wID0gdGltZS5nZXRGdWxsWWVhcigpLnRvU3RyaW5nKCkgK1xuICAgIHBhZDIodGltZS5nZXRNb250aCgpICsgMSAvKjAtYmFzZWQqLykgK1xuICAgIHBhZDIodGltZS5nZXREYXRlKCkpO1xuICBjb25zdCB0aW1lU3RhbXAgPSBwYWQyKHRpbWUuZ2V0SG91cnMoKSkgK1xuICAgICAgICAnOicgK1xuICAgICAgICBwYWQyKHRpbWUuZ2V0TWludXRlcygpKSArXG4gICAgICAgICc6JyArXG4gICAgICAgIHBhZDIodGltZS5nZXRTZWNvbmRzKCkpICtcbiAgICAgICAgJy4nICtcbiAgICAgICAgcGFkMyh0aW1lLmdldE1pbGxpc2Vjb25kcygpKTtcblxuICAvLyBlZyBpbiBTYW4gRnJhbmNpc2NvIGluIEp1bmUgdGhpcyB3aWxsIGJlICcoLTcpJ1xuICBjb25zdCB1dGNPZmZzZXRTdHIgPSBgKCR7KC0obmV3IERhdGUoKS5nZXRUaW1lem9uZU9mZnNldCgpIC8gNjApKX0pYDtcblxuICBsZXQgYXBwSW5mbyA9ICcnO1xuICBpZiAoYXBwTmFtZSkge1xuICAgIGFwcEluZm8gKz0gYXBwTmFtZTtcbiAgfVxuICBpZiAob3JpZ2luQXBwICYmIG9yaWdpbkFwcCAhPT0gYXBwTmFtZSkge1xuICAgIGFwcEluZm8gKz0gYCB2aWEgJHtvcmlnaW5BcHB9YDtcbiAgfVxuICBpZiAoYXBwSW5mbykge1xuICAgIGFwcEluZm8gPSBgWyR7YXBwSW5mb31dIGA7XG4gIH1cblxuICBjb25zdCBzb3VyY2VJbmZvUGFydHMgPSBbXTtcbiAgaWYgKHByb2dyYW0pIHtcbiAgICBzb3VyY2VJbmZvUGFydHMucHVzaChwcm9ncmFtKTtcbiAgfVxuICBpZiAoZmlsZSkge1xuICAgIHNvdXJjZUluZm9QYXJ0cy5wdXNoKGZpbGUpO1xuICB9XG4gIGlmIChsaW5lTnVtYmVyKSB7XG4gICAgc291cmNlSW5mb1BhcnRzLnB1c2gobGluZU51bWJlcik7XG4gIH1cblxuICBsZXQgc291cmNlSW5mbyA9ICFzb3VyY2VJbmZvUGFydHMubGVuZ3RoID9cbiAgICAnJyA6IGAoJHtzb3VyY2VJbmZvUGFydHMuam9pbignOicpfSkgYDtcblxuICBpZiAoc2F0ZWxsaXRlKVxuICAgIHNvdXJjZUluZm8gKz0gYFske3NhdGVsbGl0ZX1dYDtcblxuICBjb25zdCBzdGRlcnJJbmRpY2F0b3IgPSBzdGRlcnIgPyAnKFNUREVSUikgJyA6ICcnO1xuXG4gIGNvbnN0IG1ldGFQcmVmaXggPSBbXG4gICAgbGV2ZWwuY2hhckF0KDApLnRvVXBwZXJDYXNlKCksXG4gICAgZGF0ZVN0YW1wLFxuICAgICctJyxcbiAgICB0aW1lU3RhbXAsXG4gICAgdXRjT2Zmc2V0U3RyLFxuICAgIHRpbWVJbmV4YWN0ID8gJz8gJyA6ICcgJyxcbiAgICBhcHBJbmZvLFxuICAgIHNvdXJjZUluZm8sXG4gICAgc3RkZXJySW5kaWNhdG9yXS5qb2luKCcnKTtcblxuXG4gIHJldHVybiBGb3JtYXR0ZXIucHJldHRpZnkobWV0YVByZWZpeCwgb3B0aW9ucy5jb2xvciAmJiBwbGF0Zm9ybUNvbG9yKG9wdGlvbnMubWV0YUNvbG9yIHx8IE1FVEFfQ09MT1IpKSArXG4gICAgICBGb3JtYXR0ZXIucHJldHRpZnkobWVzc2FnZSwgb3B0aW9ucy5jb2xvciAmJiBwbGF0Zm9ybUNvbG9yKExFVkVMX0NPTE9SU1tsZXZlbF0pKTtcbn07XG5cbi8vIFR1cm4gYSBsaW5lIG9mIHRleHQgaW50byBhIGxvZ2dhYmxlIG9iamVjdC5cbi8vIEBwYXJhbSBsaW5lIHtTdHJpbmd9XG4vLyBAcGFyYW0gb3ZlcnJpZGUge09iamVjdH1cbkxvZy5vYmpGcm9tVGV4dCA9IChsaW5lLCBvdmVycmlkZSkgPT4ge1xuICByZXR1cm4ge1xuICAgIG1lc3NhZ2U6IGxpbmUsXG4gICAgbGV2ZWw6ICdpbmZvJyxcbiAgICB0aW1lOiBuZXcgRGF0ZSgpLFxuICAgIHRpbWVJbmV4YWN0OiB0cnVlLFxuICAgIC4uLm92ZXJyaWRlXG4gIH07XG59O1xuXG5leHBvcnQgeyBMb2cgfTtcbiIsIkZvcm1hdHRlciA9IHt9O1xuRm9ybWF0dGVyLnByZXR0aWZ5ID0gZnVuY3Rpb24obGluZSwgY29sb3Ipe1xuICAgIGlmKCFjb2xvcikgcmV0dXJuIGxpbmU7XG4gICAgcmV0dXJuIHJlcXVpcmUoXCJjaGFsa1wiKVtjb2xvcl0obGluZSk7XG59XG4iXX0=
