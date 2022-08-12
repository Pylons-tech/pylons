(function () {

/* Imports */
var Meteor = Package.meteor.Meteor;
var global = Package.meteor.global;
var meteorEnv = Package.meteor.meteorEnv;
var ECMAScript = Package.ecmascript.ECMAScript;
var WebApp = Package.webapp.WebApp;
var WebAppInternals = Package.webapp.WebAppInternals;
var main = Package.webapp.main;
var meteorInstall = Package.modules.meteorInstall;
var Promise = Package.promise.Promise;

var require = meteorInstall({"node_modules":{"meteor":{"server-render":{"server.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                 //
// packages/server-render/server.js                                                                //
//                                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                   //
module.export({
  onPageLoad: () => onPageLoad
});
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
module.link("./server-register.js");
const startupPromise = new Promise(Meteor.startup);
const pageLoadCallbacks = new Set();

function onPageLoad(callback) {
  if (typeof callback === "function") {
    pageLoadCallbacks.add(callback);
  } // Return the callback so that it can be more easily removed later.


  return callback;
}

onPageLoad.remove = function (callback) {
  pageLoadCallbacks.delete(callback);
};

onPageLoad.clear = function () {
  pageLoadCallbacks.clear();
};

onPageLoad.chain = function (handler) {
  return startupPromise.then(() => {
    let promise = Promise.resolve();
    pageLoadCallbacks.forEach(callback => {
      promise = promise.then(() => handler(callback));
    });
    return promise;
  });
};
/////////////////////////////////////////////////////////////////////////////////////////////////////

},"server-register.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                 //
// packages/server-render/server-register.js                                                       //
//                                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                   //
let WebAppInternals;
module.link("meteor/webapp", {
  WebAppInternals(v) {
    WebAppInternals = v;
  }

}, 0);
let MagicString;
module.link("magic-string", {
  default(v) {
    MagicString = v;
  }

}, 1);
let SAXParser;
module.link("parse5", {
  SAXParser(v) {
    SAXParser = v;
  }

}, 2);
let createStream;
module.link("combined-stream2", {
  create(v) {
    createStream = v;
  }

}, 3);
let ServerSink;
module.link("./server-sink.js", {
  ServerSink(v) {
    ServerSink = v;
  }

}, 4);
let onPageLoad;
module.link("./server.js", {
  onPageLoad(v) {
    onPageLoad = v;
  }

}, 5);
WebAppInternals.registerBoilerplateDataCallback("meteor/server-render", (request, data, arch) => {
  const sink = new ServerSink(request, arch);
  return onPageLoad.chain(callback => callback(sink, request)).then(() => {
    if (!sink.maybeMadeChanges) {
      return false;
    }

    let reallyMadeChanges = false;

    function rewrite(property) {
      const html = data[property];

      if (typeof html !== "string") {
        return;
      }

      const magic = new MagicString(html);
      const parser = new SAXParser({
        locationInfo: true
      });
      data[property] = parser;

      if (Object.keys(sink.htmlById).length) {
        const stream = createStream();
        let lastStart = magic.start;
        parser.on("startTag", (name, attrs, selfClosing, loc) => {
          attrs.some(attr => {
            if (attr.name === "id") {
              let html = sink.htmlById[attr.value];

              if (html) {
                reallyMadeChanges = true;
                const start = magic.slice(lastStart, loc.endOffset);
                stream.append(Buffer.from(start, "utf8"));
                stream.append(typeof html === "string" ? Buffer.from(html, "utf8") : html);
                lastStart = loc.endOffset;
              }

              return true;
            }
          });
        });
        parser.on("endTag", (name, location) => {
          if (location.endOffset === html.length) {
            // reached the end of the template
            const end = magic.slice(lastStart);
            stream.append(Buffer.from(end, "utf8"));
          }
        });
        data[property] = stream;
      }

      parser.write(html, parser.end.bind(parser));
    }

    if (sink.head) {
      data.dynamicHead = (data.dynamicHead || "") + sink.head;
      reallyMadeChanges = true;
    }

    if (Object.keys(sink.htmlById).length > 0) {
      // We don't currently allow injecting HTML into the <head> except
      // by calling sink.appendHead(html).
      rewrite("body");
      rewrite("dynamicBody");
    }

    if (sink.body) {
      data.dynamicBody = (data.dynamicBody || "") + sink.body;
      reallyMadeChanges = true;
    }

    if (sink.statusCode) {
      data.statusCode = sink.statusCode;
      reallyMadeChanges = true;
    }

    if (Object.keys(sink.responseHeaders)) {
      data.headers = sink.responseHeaders;
      reallyMadeChanges = true;
    }

    return reallyMadeChanges;
  });
});
/////////////////////////////////////////////////////////////////////////////////////////////////////

},"server-sink.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                 //
// packages/server-render/server-sink.js                                                           //
//                                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                   //
module.export({
  ServerSink: () => ServerSink,
  isReadable: () => isReadable
});

class ServerSink {
  constructor(request, arch) {
    this.request = request;
    this.arch = arch;
    this.head = "";
    this.body = "";
    this.htmlById = Object.create(null);
    this.maybeMadeChanges = false;
    this.statusCode = null;
    this.responseHeaders = {};
  }

  appendToHead(html) {
    if (appendContent(this, "head", html)) {
      this.maybeMadeChanges = true;
    }
  }

  appendToBody(html) {
    if (appendContent(this, "body", html)) {
      this.maybeMadeChanges = true;
    }
  }

  appendToElementById(id, html) {
    if (appendContent(this.htmlById, id, html)) {
      this.maybeMadeChanges = true;
    }
  }

  renderIntoElementById(id, html) {
    this.htmlById[id] = "";
    this.appendToElementById(id, html);
  }

  redirect(location) {
    let code = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : 301;
    this.maybeMadeChanges = true;
    this.statusCode = code;
    this.responseHeaders.Location = location;
  } // server only methods


  setStatusCode(code) {
    this.maybeMadeChanges = true;
    this.statusCode = code;
  }

  setHeader(key, value) {
    this.maybeMadeChanges = true;
    this.responseHeaders[key] = value;
  }

  getHeaders() {
    return this.request.headers;
  }

  getCookies() {
    return this.request.cookies;
  }

}

function isReadable(stream) {
  return stream !== null && typeof stream === 'object' && typeof stream.pipe === 'function' && stream.readable !== false && typeof stream._read === 'function' && typeof stream._readableState === 'object';
}

function appendContent(object, property, content) {
  let madeChanges = false;

  if (Array.isArray(content)) {
    content.forEach(elem => {
      if (appendContent(object, property, elem)) {
        madeChanges = true;
      }
    });
  } else if (isReadable(content)) {
    object[property] = content;
    madeChanges = true;
  } else if (content = content && content.toString("utf8")) {
    object[property] = (object[property] || "") + content;
    madeChanges = true;
  }

  return madeChanges;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////

},"node_modules":{"magic-string":{"package.json":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                 //
// node_modules/meteor/server-render/node_modules/magic-string/package.json                        //
//                                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                   //
module.exports = {
  "name": "magic-string",
  "version": "0.25.7",
  "main": "dist/magic-string.cjs.js"
};

/////////////////////////////////////////////////////////////////////////////////////////////////////

},"dist":{"magic-string.cjs.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                 //
// node_modules/meteor/server-render/node_modules/magic-string/dist/magic-string.cjs.js            //
//                                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                   //
module.useNode();
/////////////////////////////////////////////////////////////////////////////////////////////////////

}}},"parse5":{"package.json":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                 //
// node_modules/meteor/server-render/node_modules/parse5/package.json                              //
//                                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                   //
module.exports = {
  "name": "parse5",
  "version": "4.0.0",
  "main": "./lib/index.js"
};

/////////////////////////////////////////////////////////////////////////////////////////////////////

},"lib":{"index.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                 //
// node_modules/meteor/server-render/node_modules/parse5/lib/index.js                              //
//                                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                   //
module.useNode();
/////////////////////////////////////////////////////////////////////////////////////////////////////

}}},"combined-stream2":{"package.json":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                 //
// node_modules/meteor/server-render/node_modules/combined-stream2/package.json                    //
//                                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                   //
module.exports = {
  "name": "combined-stream2",
  "version": "1.1.2",
  "main": "index.js"
};

/////////////////////////////////////////////////////////////////////////////////////////////////////

},"index.js":function module(require,exports,module){

/////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                 //
// node_modules/meteor/server-render/node_modules/combined-stream2/index.js                        //
//                                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                   //
module.useNode();
/////////////////////////////////////////////////////////////////////////////////////////////////////

}}}}}}},{
  "extensions": [
    ".js",
    ".json"
  ]
});

var exports = require("/node_modules/meteor/server-render/server.js");

/* Exports */
Package._define("server-render", exports);

})();

//# sourceURL=meteor://💻app/packages/server-render.js
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvc2VydmVyLXJlbmRlci9zZXJ2ZXIuanMiLCJtZXRlb3I6Ly/wn5K7YXBwL3BhY2thZ2VzL3NlcnZlci1yZW5kZXIvc2VydmVyLXJlZ2lzdGVyLmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9wYWNrYWdlcy9zZXJ2ZXItcmVuZGVyL3NlcnZlci1zaW5rLmpzIl0sIm5hbWVzIjpbIm1vZHVsZSIsImV4cG9ydCIsIm9uUGFnZUxvYWQiLCJNZXRlb3IiLCJsaW5rIiwidiIsInN0YXJ0dXBQcm9taXNlIiwiUHJvbWlzZSIsInN0YXJ0dXAiLCJwYWdlTG9hZENhbGxiYWNrcyIsIlNldCIsImNhbGxiYWNrIiwiYWRkIiwicmVtb3ZlIiwiZGVsZXRlIiwiY2xlYXIiLCJjaGFpbiIsImhhbmRsZXIiLCJ0aGVuIiwicHJvbWlzZSIsInJlc29sdmUiLCJmb3JFYWNoIiwiV2ViQXBwSW50ZXJuYWxzIiwiTWFnaWNTdHJpbmciLCJkZWZhdWx0IiwiU0FYUGFyc2VyIiwiY3JlYXRlU3RyZWFtIiwiY3JlYXRlIiwiU2VydmVyU2luayIsInJlZ2lzdGVyQm9pbGVycGxhdGVEYXRhQ2FsbGJhY2siLCJyZXF1ZXN0IiwiZGF0YSIsImFyY2giLCJzaW5rIiwibWF5YmVNYWRlQ2hhbmdlcyIsInJlYWxseU1hZGVDaGFuZ2VzIiwicmV3cml0ZSIsInByb3BlcnR5IiwiaHRtbCIsIm1hZ2ljIiwicGFyc2VyIiwibG9jYXRpb25JbmZvIiwiT2JqZWN0Iiwia2V5cyIsImh0bWxCeUlkIiwibGVuZ3RoIiwic3RyZWFtIiwibGFzdFN0YXJ0Iiwic3RhcnQiLCJvbiIsIm5hbWUiLCJhdHRycyIsInNlbGZDbG9zaW5nIiwibG9jIiwic29tZSIsImF0dHIiLCJ2YWx1ZSIsInNsaWNlIiwiZW5kT2Zmc2V0IiwiYXBwZW5kIiwiQnVmZmVyIiwiZnJvbSIsImxvY2F0aW9uIiwiZW5kIiwid3JpdGUiLCJiaW5kIiwiaGVhZCIsImR5bmFtaWNIZWFkIiwiYm9keSIsImR5bmFtaWNCb2R5Iiwic3RhdHVzQ29kZSIsInJlc3BvbnNlSGVhZGVycyIsImhlYWRlcnMiLCJpc1JlYWRhYmxlIiwiY29uc3RydWN0b3IiLCJhcHBlbmRUb0hlYWQiLCJhcHBlbmRDb250ZW50IiwiYXBwZW5kVG9Cb2R5IiwiYXBwZW5kVG9FbGVtZW50QnlJZCIsImlkIiwicmVuZGVySW50b0VsZW1lbnRCeUlkIiwicmVkaXJlY3QiLCJjb2RlIiwiTG9jYXRpb24iLCJzZXRTdGF0dXNDb2RlIiwic2V0SGVhZGVyIiwia2V5IiwiZ2V0SGVhZGVycyIsImdldENvb2tpZXMiLCJjb29raWVzIiwicGlwZSIsInJlYWRhYmxlIiwiX3JlYWQiLCJfcmVhZGFibGVTdGF0ZSIsIm9iamVjdCIsImNvbnRlbnQiLCJtYWRlQ2hhbmdlcyIsIkFycmF5IiwiaXNBcnJheSIsImVsZW0iLCJ0b1N0cmluZyJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7O0FBQUFBLE1BQU0sQ0FBQ0MsTUFBUCxDQUFjO0FBQUNDLFlBQVUsRUFBQyxNQUFJQTtBQUFoQixDQUFkO0FBQTJDLElBQUlDLE1BQUo7QUFBV0gsTUFBTSxDQUFDSSxJQUFQLENBQVksZUFBWixFQUE0QjtBQUFDRCxRQUFNLENBQUNFLENBQUQsRUFBRztBQUFDRixVQUFNLEdBQUNFLENBQVA7QUFBUzs7QUFBcEIsQ0FBNUIsRUFBa0QsQ0FBbEQ7QUFBcURMLE1BQU0sQ0FBQ0ksSUFBUCxDQUFZLHNCQUFaO0FBRzNHLE1BQU1FLGNBQWMsR0FBRyxJQUFJQyxPQUFKLENBQVlKLE1BQU0sQ0FBQ0ssT0FBbkIsQ0FBdkI7QUFDQSxNQUFNQyxpQkFBaUIsR0FBRyxJQUFJQyxHQUFKLEVBQTFCOztBQUVPLFNBQVNSLFVBQVQsQ0FBb0JTLFFBQXBCLEVBQThCO0FBQ25DLE1BQUksT0FBT0EsUUFBUCxLQUFvQixVQUF4QixFQUFvQztBQUNsQ0YscUJBQWlCLENBQUNHLEdBQWxCLENBQXNCRCxRQUF0QjtBQUNELEdBSGtDLENBS25DOzs7QUFDQSxTQUFP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RCxTQUFPQSxXQUFQO0FBQ0QsQyIsImZpbGUiOiIvcGFja2FnZXMvc2VydmVyLXJlbmRlci5qcyIsInNvdXJjZXNDb250ZW50IjpbImltcG9ydCB7IE1ldGVvciB9IGZyb20gXCJtZXRlb3IvbWV0ZW9yXCI7XG5pbXBvcnQgXCIuL3NlcnZlci1yZWdpc3Rlci5qc1wiO1xuXG5jb25zdCBzdGFydHVwUHJvbWlzZSA9IG5ldyBQcm9taXNlKE1ldGVvci5zdGFydHVwKTtcbmNvbnN0IHBhZ2VMb2FkQ2FsbGJhY2tzID0gbmV3IFNldDtcblxuZXhwb3J0IGZ1bmN0aW9uIG9uUGFnZUxvYWQoY2FsbGJhY2spIHtcbiAgaWYgKHR5cGVvZiBjYWxsYmFjayA9PT0gXCJmdW5jdGlvblwiKSB7XG4gICAgcGFnZUxvYWRDYWxsYmFja3MuYWRkKGNhbGxiYWNrKTtcbiAgfVxuXG4gIC8vIFJldHVybiB0aGUgY2FsbGJhY2sgc28gdGhhdCBpdCBjYW4gYmUgbW9yZSBlYXNpbHkgcmVtb3ZlZCBsYXRlci5cbiAgcmV0dXJuIGNhbGxiYWNrO1xufVxuXG5vblBhZ2VMb2FkLnJlbW92ZSA9IGZ1bmN0aW9uIChjYWxsYmFjaykge1xuICBwYWdlTG9hZENhbGxiYWNrcy5kZWxldGUoY2FsbGJhY2spO1xufTtcblxub25QYWdlTG9hZC5jbGVhciA9IGZ1bmN0aW9uICgpIHtcbiAgcGFnZUxvYWRDYWxsYmFja3MuY2xlYXIoKTtcbn07XG5cbm9uUGFnZUxvYWQuY2hhaW4gPSBmdW5jdGlvbiAoaGFuZGxlcikge1xuICByZXR1cm4gc3RhcnR1cFByb21pc2UudGhlbigoKSA9PiB7XG4gICAgbGV0IHByb21pc2UgPSBQcm9taXNlLnJlc29sdmUoKTtcbiAgICBwYWdlTG9hZENhbGxiYWNrcy5mb3JFYWNoKGNhbGxiYWNrID0+IHtcbiAgICAgIHByb21pc2UgPSBwcm9taXNlLnRoZW4oKCkgPT4gaGFuZGxlcihjYWxsYmFjaykpO1xuICAgIH0pO1xuICAgIHJldHVybiBwcm9taXNlO1xuICB9KTtcbn07XG4iLCJpbXBvcnQgeyBXZWJBcHBJbnRlcm5hbHMgfSBmcm9tIFwibWV0ZW9yL3dlYmFwcFwiO1xuaW1wb3J0IE1hZ2ljU3RyaW5nIGZyb20gXCJtYWdpYy1zdHJpbmdcIjtcbmltcG9ydCB7IFNBWFBhcnNlciB9IGZyb20gXCJwYXJzZTVcIjtcbmltcG9ydCB7IGNyZWF0ZSBhcyBjcmVhdGVTdHJlYW0gfSBmcm9tIFwiY29tYmluZWQtc3RyZWFtMlwiO1xuaW1wb3J0IHsgU2VydmVyU2luayB9IGZyb20gXCIuL3NlcnZlci1zaW5rLmpzXCI7XG5pbXBvcnQgeyBvblBhZ2VMb2FkIH0gZnJvbSBcIi4vc2VydmVyLmpzXCI7XG5cbldlYkFwcEludGVybmFscy5yZWdpc3RlckJvaWxlcnBsYXRlRGF0YUNhbGxiYWNrKFxuICBcIm1ldGVvci9zZXJ2ZXItcmVuZGVyXCIsXG4gIChyZXF1ZXN0LCBkYXRhLCBhcmNoKSA9PiB7XG4gICAgY29uc3Qgc2luayA9IG5ldyBTZXJ2ZXJTaW5rKHJlcXVlc3QsIGFyY2gpO1xuXG4gICAgcmV0dXJuIG9uUGFnZUxvYWQuY2hhaW4oXG4gICAgICBjYWxsYmFjayA9PiBjYWxsYmFjayhzaW5rLCByZXF1ZXN0KVxuICAgICkudGhlbigoKSA9PiB7XG4gICAgICBpZiAoISBzaW5rLm1heWJlTWFkZUNoYW5nZXMpIHtcbiAgICAgICAgcmV0dXJuIGZhbHNlO1xuICAgICAgfVxuXG4gICAgICBsZXQgcmVhbGx5TWFkZUNoYW5nZXMgPSBmYWxzZTtcblxuICAgICAgZnVuY3Rpb24gcmV3cml0ZShwcm9wZXJ0eSkge1xuICAgICAgICBjb25zdCBodG1sID0gZGF0YVtwcm9wZXJ0eV07XG4gICAgICAgIGlmICh0eXBlb2YgaHRtbCAhPT0gXCJzdHJpbmdcIikge1xuICAgICAgICAgIHJldHVybjtcbiAgICAgICAgfVxuXG4gICAgICAgIGNvbnN0IG1hZ2ljID0gbmV3IE1hZ2ljU3RyaW5nKGh0bWwpO1xuICAgICAgICBjb25zdCBwYXJzZXIgPSBuZXcgU0FYUGFyc2VyKHtcbiAgICAgICAgICBsb2NhdGlvbkluZm86IHRydWVcbiAgICAgICAgfSk7XG5cbiAgICAgICAgZGF0YVtwcm9wZXJ0eV0gPSBwYXJzZXI7XG5cbiAgICAgICAgaWYgKE9iamVjdC5rZXlzKHNpbmsuaHRtbEJ5SWQpLmxlbmd0aCkge1xuICAgICAgICAgIGNvbnN0IHN0cmVhbSA9IGNyZWF0ZVN0cmVhbSgpO1xuXG4gICAgICAgICAgbGV0IGxhc3RTdGFydCA9IG1hZ2ljLnN0YXJ0O1xuICAgICAgICAgIHBhcnNlci5vbihcInN0YXJ0VGFnXCIsIChuYW1lLCBhdHRycywgc2VsZkNsb3NpbmcsIGxvYykgPT4ge1xuICAgICAgICAgICAgYXR0cnMuc29tZShhdHRyID0+IHtcbiAgICAgICAgICAgICAgaWYgKGF0dHIubmFtZSA9PT0gXCJpZFwiKSB7XG4gICAgICAgICAgICAgICAgbGV0IGh0bWwgPSBzaW5rLmh0bWxCeUlkW2F0dHIudmFsdWVdO1xuICAgICAgICAgICAgICAgIGlmIChodG1sKSB7XG4gICAgICAgICAgICAgICAgICByZWFsbHlNYWRlQ2hhbmdlcyA9IHRydWU7XG4gICAgICAgICAgICAgICAgICBjb25zdCBzdGFydCA9IG1hZ2ljLnNsaWNlKGxhc3RTdGFydCwgbG9jLmVuZE9mZnNldCk7XG4gICAgICAgICAgICAgICAgICBzdHJlYW0uYXBwZW5kKEJ1ZmZlci5mcm9tKHN0YXJ0LCBcInV0ZjhcIikpO1xuICAgICAgICAgICAgICAgICAgc3RyZWFtLmFwcGVuZChcbiAgICAgICAgICAgICAgICAgICAgdHlwZW9mIGh0bWwgPT09IFwic3RyaW5nXCJcbiAgICAgICAgICAgICAgICAgICAgICA/IEJ1ZmZlci5mcm9tKGh0bWwsIFwidXRmOFwiKVxuICAgICAgICAgICAgICAgICAgICAgIDogaHRtbFxuICAgICAgICAgICAgICAgICAgKTtcbiAgICAgICAgICAgICAgICAgIGxhc3RTdGFydCA9IGxvYy5lbmRPZmZzZXQ7XG4gICAgICAgICAgICAgICAgfVxuICAgICAgICAgICAgICAgIHJldHVybiB0cnVlO1xuICAgICAgICAgICAgICB9XG4gICAgICAgICAgICB9KTtcbiAgICAgICAgICB9KTtcblxuICAgICAgICAgIHBhcnNlci5vbihcImVuZFRhZ1wiLCAobmFtZSwgbG9jYXRpb24pID0+IHtcbiAgICAgICAgICAgIGlmIChsb2NhdGlvbi5lbmRPZmZzZXQgPT09IGh0bWwubGVuZ3RoKSB7XG4gICAgICAgICAgICAgIC8vIHJlYWNoZWQgdGhlIGVuZCBvZiB0aGUgdGVtcGxhdGVcbiAgICAgICAgICAgICAgY29uc3QgZW5kID0gbWFnaWMuc2xpY2UobGFzdFN0YXJ0KTtcbiAgICAgICAgICAgICAgc3RyZWFtLmFwcGVuZChCdWZmZXIuZnJvbShlbmQsIFwidXRmOFwiKSk7XG4gICAgICAgICAgICB9XG4gICAgICAgICAgfSk7XG5cbiAgICAgICAgICBkYXRhW3Byb3BlcnR5XSA9IHN0cmVhbTtcbiAgICAgICAgfVxuXG4gICAgICAgIHBhcnNlci53cml0ZShodG1sLCBwYXJzZXIuZW5kLmJpbmQocGFyc2VyKSk7XG4gICAgICB9XG5cbiAgICAgIGlmIChzaW5rLmhlYWQpIHtcbiAgICAgICAgZGF0YS5keW5hbWljSGVhZCA9IChkYXRhLmR5bmFtaWNIZWFkIHx8IFwiXCIpICsgc2luay5oZWFkO1xuICAgICAgICByZWFsbHlNYWRlQ2hhbmdlcyA9IHRydWU7XG4gICAgICB9XG5cbiAgICAgIGlmIChPYmplY3Qua2V5cyhzaW5rLmh0bWxCeUlkKS5sZW5ndGggPiAwKSB7XG4gICAgICAgIC8vIFdlIGRvbid0IGN1cnJlbnRseSBhbGxvdyBpbmplY3RpbmcgSFRNTCBpbnRvIHRoZSA8aGVhZD4gZXhjZXB0XG4gICAgICAgIC8vIGJ5IGNhbGxpbmcgc2luay5hcHBlbmRIZWFkKGh0bWwpLlxuICAgICAgICByZXdyaXRlKFwiYm9keVwiKTtcbiAgICAgICAgcmV3cml0ZShcImR5bmFtaWNCb2R5XCIpO1xuICAgICAgfVxuXG4gICAgICBpZiAoc2luay5ib2R5KSB7XG4gICAgICAgIGRhdGEuZHluYW1pY0JvZHkgPSAoZGF0YS5keW5hbWljQm9keSB8fCBcIlwiKSArIHNpbmsuYm9keTtcbiAgICAgICAgcmVhbGx5TWFkZUNoYW5nZXMgPSB0cnVlO1xuICAgICAgfVxuXG4gICAgICBpZiAoc2luay5zdGF0dXNDb2RlKSB7XG4gICAgICAgIGRhdGEuc3RhdHVzQ29kZSA9IHNpbmsuc3RhdHVzQ29kZTtcbiAgICAgICAgcmVhbGx5TWFkZUNoYW5nZXMgPSB0cnVlO1xuICAgICAgfVxuXG4gICAgICBpZiAoT2JqZWN0LmtleXMoc2luay5yZXNwb25zZUhlYWRlcnMpKXtcbiAgICAgICAgZGF0YS5oZWFkZXJzID0gc2luay5yZXNwb25zZUhlYWRlcnM7XG4gICAgICAgIHJlYWxseU1hZGVDaGFuZ2VzID0gdHJ1ZTtcbiAgICAgIH1cblxuICAgICAgcmV0dXJuIHJlYWxseU1hZGVDaGFuZ2VzO1xuICAgIH0pO1xuICB9XG4pO1xuIiwiZXhwb3J0IGNsYXNzIFNlcnZlclNpbmsge1xuICBjb25zdHJ1Y3RvcihyZXF1ZXN0LCBhcmNoKSB7XG4gICAgdGhpcy5yZXF1ZXN0ID0gcmVxdWVzdDtcbiAgICB0aGlzLmFyY2ggPSBhcmNoO1xuICAgIHRoaXMuaGVhZCA9IFwiXCI7XG4gICAgdGhpcy5ib2R5ID0gXCJcIjtcbiAgICB0aGlzLmh0bWxCeUlkID0gT2JqZWN0LmNyZWF0ZShudWxsKTtcbiAgICB0aGlzLm1heWJlTWFkZUNoYW5nZXMgPSBmYWxzZTtcbiAgICB0aGlzLnN0YXR1c0NvZGUgPSBudWxsO1xuICAgIHRoaXMucmVzcG9uc2VIZWFkZXJzID0ge307XG4gIH1cblxuICBhcHBlbmRUb0hlYWQoaHRtbCkge1xuICAgIGlmIChhcHBlbmRDb250ZW50KHRoaXMsIFwiaGVhZFwiLCBodG1sKSkge1xuICAgICAgdGhpcy5tYXliZU1hZGVDaGFuZ2VzID0gdHJ1ZTtcbiAgICB9XG4gIH1cblxuICBhcHBlbmRUb0JvZHkoaHRtbCkge1xuICAgIGlmIChhcHBlbmRDb250ZW50KHRoaXMsIFwiYm9keVwiLCBodG1sKSkge1xuICAgICAgdGhpcy5tYXliZU1hZGVDaGFuZ2VzID0gdHJ1ZTtcbiAgICB9XG4gIH1cblxuICBhcHBlbmRUb0VsZW1lbnRCeUlkKGlkLCBodG1sKSB7XG4gICAgaWYgKGFwcGVuZENvbnRlbnQodGhpcy5odG1sQnlJZCwgaWQsIGh0bWwpKSB7XG4gICAgICB0aGlzLm1heWJlTWFkZUNoYW5nZXMgPSB0cnVlO1xuICAgIH1cbiAgfVxuXG4gIHJlbmRlckludG9FbGVtZW50QnlJZChpZCwgaHRtbCkge1xuICAgIHRoaXMuaHRtbEJ5SWRbaWRdID0gXCJcIjtcbiAgICB0aGlzLmFwcGVuZFRvRWxlbWVudEJ5SWQoaWQsIGh0bWwpO1xuICB9XG5cbiAgcmVkaXJlY3QobG9jYXRpb24sIGNvZGUgPSAzMDEpIHtcbiAgICB0aGlzLm1heWJlTWFkZUNoYW5nZXMgPSB0cnVlO1xuICAgIHRoaXMuc3RhdHVzQ29kZSA9IGNvZGU7XG4gICAgdGhpcy5yZXNwb25zZUhlYWRlcnMuTG9jYXRpb24gPSBsb2NhdGlvbjtcbiAgfVxuXG4gIC8vIHNlcnZlciBvbmx5IG1ldGhvZHNcbiAgc2V0U3RhdHVzQ29kZShjb2RlKSB7XG4gICAgdGhpcy5tYXliZU1hZGVDaGFuZ2VzID0gdHJ1ZTtcbiAgICB0aGlzLnN0YXR1c0NvZGUgPSBjb2RlO1xuICB9XG5cbiAgc2V0SGVhZGVyKGtleSwgdmFsdWUpIHtcbiAgICB0aGlzLm1heWJlTWFkZUNoYW5nZXMgPSB0cnVlO1xuICAgIHRoaXMucmVzcG9uc2VIZWFkZXJzW2tleV0gPSB2YWx1ZTtcbiAgfVxuXG4gIGdldEhlYWRlcnMoKSB7XG4gICAgcmV0dXJuIHRoaXMucmVxdWVzdC5oZWFkZXJzO1xuICB9XG5cbiAgZ2V0Q29va2llcygpIHtcbiAgICByZXR1cm4gdGhpcy5yZXF1ZXN0LmNvb2tpZXM7XG4gIH1cbn1cblxuZXhwb3J0IGZ1bmN0aW9uIGlzUmVhZGFibGUoc3RyZWFtKSB7XG4gIHJldHVybiAoXG4gICAgc3RyZWFtICE9PSBudWxsICYmXG4gICAgdHlwZW9mIHN0cmVhbSA9PT0gJ29iamVjdCcgJiZcbiAgICB0eXBlb2Ygc3RyZWFtLnBpcGUgPT09ICdmdW5jdGlvbicgJiZcbiAgICBzdHJlYW0ucmVhZGFibGUgIT09IGZhbHNlICYmXG4gICAgdHlwZW9mIHN0cmVhbS5fcmVhZCA9PT0gJ2Z1bmN0aW9uJyAmJlxuICAgIHR5cGVvZiBzdHJlYW0uX3JlYWRhYmxlU3RhdGUgPT09ICdvYmplY3QnXG4gICk7XG59XG5cbmZ1bmN0aW9uIGFwcGVuZENvbnRlbnQob2JqZWN0LCBwcm9wZXJ0eSwgY29udGVudCkge1xuICBsZXQgbWFkZUNoYW5nZXMgPSBmYWxzZTtcblxuICBpZiAoQXJyYXkuaXNBcnJheShjb250ZW50KSkge1xuICAgIGNvbnRlbnQuZm9yRWFjaChlbGVtID0+IHtcbiAgICAgIGlmIChhcHBlbmRDb250ZW50KG9iamVjdCwgcHJvcGVydHksIGVsZW0pKSB7XG4gICAgICAgIG1hZGVDaGFuZ2VzID0gdHJ1ZTtcbiAgICAgIH1cbiAgICB9KTtcbiAgfSBlbHNlIGlmIChpc1JlYWRhYmxlKGNvbnRlbnQpKSB7XG4gICAgb2JqZWN0W3Byb3BlcnR5XSA9IGNvbnRlbnQ7XG4gICAgbWFkZUNoYW5nZXMgPSB0cnVlO1xuICB9IGVsc2UgaWYgKChjb250ZW50ID0gY29udGVudCAmJiBjb250ZW50LnRvU3RyaW5nKFwidXRmOFwiKSkpIHtcbiAgICBvYmplY3RbcHJvcGVydHldID0gKG9iamVjdFtwcm9wZXJ0eV0gfHwgXCJcIikgKyBjb250ZW50O1xuICAgIG1hZGVDaGFuZ2VzID0gdHJ1ZTtcbiAgfSBcbiAgcmV0dXJuIG1hZGVDaGFuZ2VzO1xufVxuIl19
