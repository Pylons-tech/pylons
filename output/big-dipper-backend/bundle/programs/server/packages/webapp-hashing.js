(function () {

/* Imports */
var Meteor = Package.meteor.Meteor;
var global = Package.meteor.global;
var meteorEnv = Package.meteor.meteorEnv;
var ECMAScript = Package.ecmascript.ECMAScript;
var _ = Package.underscore._;
var meteorInstall = Package.modules.meteorInstall;
var Promise = Package.promise.Promise;

/* Package-scope variables */
var WebAppHashing;

var require = meteorInstall({"node_modules":{"meteor":{"webapp-hashing":{"webapp-hashing.js":function module(require){

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                         //
// packages/webapp-hashing/webapp-hashing.js                                                               //
//                                                                                                         //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                           //
var crypto = Npm.require("crypto");

WebAppHashing = {}; // Calculate a hash of all the client resources downloaded by the
// browser, including the application HTML, runtime config, code, and
// static files.
//
// This hash *must* change if any resources seen by the browser
// change, and ideally *doesn't* change for any server-only changes
// (but the second is a performance enhancement, not a hard
// requirement).

WebAppHashing.calculateClientHash = function (manifest, includeFilter, runtimeConfigOverride) {
  var hash = crypto.createHash('sha1'); // Omit the old hashed client values in the new hash. These may be
  // modified in the new boilerplate.

  var runtimeCfg = _.omit(__meteor_runtime_config__, ['autoupdateVersion', 'autoupdateVersionRefreshable', 'autoupdateVersionCordova']);

  if (runtimeConfigOverride) {
    runtimeCfg = runtimeConfigOverride;
  }

  hash.update(JSON.stringify(runtimeCfg, 'utf8'));

  _.each(manifest, function (resource) {
    if ((!includeFilter || includeFilter(resource.type, resource.replaceable)) && (resource.where === 'client' || resource.where === 'internal')) {
      hash.update(resource.path);
      hash.update(resource.hash);
    }
  });

  return hash.digest('hex');
};

WebAppHashing.calculateCordovaCompatibilityHash = function (platformVersion, pluginVersions) {
  const hash = crypto.createHash('sha1');
  hash.update(platformVersion); // Sort plugins first so iteration order doesn't affect the hash

  const plugins = Object.keys(pluginVersions).sort();

  for (let plugin of plugins) {
    const version = pluginVersions[plugin];
    hash.update(plugin);
    hash.update(version);
  }

  return hash.digest('hex');
};
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

}}}}},{
  "extensions": [
    ".js",
    ".json"
  ]
});

require("/node_modules/meteor/webapp-hashing/webapp-hashing.js");

/* Exports */
Package._define("webapp-hashing", {
  WebAppHashing: WebAppHashing
});

})();

//# sourceURL=meteor://💻app/packages/webapp-hashing.js
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvd2ViYXBwLWhhc2hpbmcvd2ViYXBwLWhhc2hpbmcuanMiXSwibmFtZXMiOlsiY3J5cHRvIiwiTnBtIiwicmVxdWlyZSIsIldlYkFwcEhhc2hpbmciLCJjYWxjdWxhdGVDbGllbnRIYXNoIiwibWFuaWZlc3QiLCJpbmNsdWRlRmlsdGVyIiwicnVudGltZUNvbmZpZ092ZXJyaWRlIiwiaGFzaCIsImNyZWF0ZUhhc2giLCJydW50aW1lQ2ZnIiwiXyIsIm9taXQiLCJfX21ldGVvcl9ydW50aW1lX2NvbmZpZ19fIiwidXBkYXRlIiwiSlNPTiIsInN0cmluZ2lmeSIsImVhY2giLCJyZXNvdXJjZSIsInR5cGUiLCJyZXBsYWNlYWJsZSIsIndoZXJlIiwicGF0aCIsImRpZ2VzdCIsImNhbGN1bGF0ZUNvcmRvdmFDb21wYXRpYmlsaXR5SGFzaCIsInBsYXRmb3JtVmVyc2lvbiIsInBsdWdpblZlcnNpb25zIiwicGx1Z2lucyIsIk9iamVjdCIsImtleXMiLCJzb3J0IiwicGx1Z2luIiwidmVyc2lvbiJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OztBQUFBLElBQUlBLE1BQU0sR0FBR0MsR0FBRyxDQUFDQyxPQUFKLENBQVksUUFBWixDQUFiOztBQUVBQyxhQUFhLEdBQUcsRUFBaEIsQyxDQUVBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7QUFDQTtBQUNBO0FBQ0E7O0FBRUFBLGFBQWEsQ0FBQ0MsbUJBQWQsR0FDRSxVQUFVQyxRQUFWLEVBQW9CQyxhQUFwQixFQUFtQ0MscUJBQW5DLEVBQTBEO0FBQzFELE1BQUlDLElBQUksR0FBR1IsTUFBTSxDQUFDUyxVQUFQLENBQWtCLE1BQWxCLENBQVgsQ0FEMEQsQ0FHMUQ7QUFDQTs7QUFDQSxNQUFJQyxVQUFVLEdBQUdDLENBQUMsQ0FBQ0MsSUFBRixDQUFPQyx5QkFBUCxFQUNmLENBQUMsbUJBQUQsRUFBc0IsOEJBQXRCLEVBQ0MsMEJBREQsQ0FEZSxDQUFqQjs7QUFJQSxNQUFJTixxQkFBSixFQUEyQjtBQUN6QkcsY0FBVSxHQUFHSCxxQkFBYjtBQUNEOztBQUVEQyxNQUFJLENBQUNNLE1BQUwsQ0FBWUMsSUFBSSxDQUFDQyxTQUFMLENBQWVOLFVBQWYsRUFBMkIsTUFBM0IsQ0FBWjs7QUFFQUMsR0FBQyxDQUFDTSxJQUFGLENBQU9aLFFBQVAsRUFBaUIsVUFBVWEsUUFBVixFQUFvQjtBQUNqQyxRQUFJLENBQUMsQ0FBRVosYUFBRixJQUFtQkEsYUFBYSxDQUFDWSxRQUFRLENBQUNDLElBQVYsRUFBZ0JELFFBQVEsQ0FBQ0UsV0FBekIsQ0FBakMsTUFDQ0YsUUFBUSxDQUFDRyxLQUFULEtBQW1CLFFBQW5CLElBQStCSCxRQUFRLENBQUNHLEtBQVQsS0FBbUIsVUFEbkQsQ0FBSixFQUNvRTtBQUNwRWIsVUFBSSxDQUFDTSxNQUFMLENBQVlJLFFBQVEsQ0FBQ0ksSUFBckI7QUFDQWQsVUFBSSxDQUFDTSxNQUFMLENBQVlJLFFBQVEsQ0FBQ1YsSUFBckI7QUFDRDtBQUNGLEdBTkQ7O0FBT0EsU0FBT0EsSUFBSSxDQUFDZSxNQUFMLENBQVksS0FBWixDQUFQO0FBQ0QsQ0F4QkQ7O0FBMEJBcEIsYUFBYSxDQUFDcUIsaUNBQWQsR0FDRSxVQUFTQyxlQUFULEVBQTBCQyxjQUExQixFQUEwQztBQUMxQyxRQUFNbEIsSUFBSSxHQUFHUixNQUFNLENBQUNTLFVBQVAsQ0FBa0IsTUFBbEIsQ0FBYjtBQUVBRCxNQUFJLENBQUNNLE1BQUwsQ0FBWVcsZUFBWixFQUgwQyxDQUsxQzs7QUFDQSxRQUFNRSxPQUFPLEdBQUdDLE1BQU0sQ0FBQ0MsSUFBUCxDQUFZSCxjQUFaLEVBQTRCSSxJQUE1QixFQUFoQjs7QUFDQSxPQUFLLElBQUlDLE1BQVQsSUFBbUJKLE9BQW5CLEVBQTRCO0FBQzFCLFVBQU1LLE9BQU8sR0FBR04sY0FBYyxDQUFDSyxNQUFELENBQTlCO0FBQ0F2QixRQUFJLENBQUNNLE1BQUwsQ0FBWWlCLE1BQVo7QUFDQXZCLFFBQUksQ0FBQ00sTUFBTCxDQUFZa0IsT0FBWjtBQUNEOztBQUVELFNBQU94QixJQUFJLENBQUNlLE1BQUwsQ0FBWSxLQUFaLENBQVA7QUFDRCxDQWZELEMiLCJmaWxlIjoiL3BhY2thZ2VzL3dlYmFwcC1oYXNoaW5nLmpzIiwic291cmNlc0NvbnRlbnQiOlsidmFyIGNyeXB0byA9IE5wbS5yZXF1aXJlKFwiY3J5cHRvXCIpO1xuXG5XZWJBcHBIYXNoaW5nID0ge307XG5cbi8vIENhbGN1bGF0ZSBhIGhhc2ggb2YgYWxsIHRoZSBjbGllbnQgcmVzb3VyY2VzIGRvd25sb2FkZWQgYnkgdGhlXG4vLyBicm93c2VyLCBpbmNsdWRpbmcgdGhlIGFwcGxpY2F0aW9uIEhUTUwsIHJ1bnRpbWUgY29uZmlnLCBjb2RlLCBhbmRcbi8vIHN0YXRpYyBmaWxlcy5cbi8vXG4vLyBUaGlzIGhhc2ggKm11c3QqIGNoYW5nZSBpZiBhbnkgcmVzb3VyY2VzIHNlZW4gYnkgdGhlIGJyb3dzZXJcbi8vIGNoYW5nZSwgYW5kIGlkZWFsbHkgKmRvZXNuJ3QqIGNoYW5nZSBmb3IgYW55IHNlcnZlci1vbmx5IGNoYW5nZXNcbi8vIChidXQgdGhlIHNlY29uZCBpcyBhIHBlcmZvcm1hbmNlIGVuaGFuY2VtZW50LCBub3QgYSBoYXJkXG4vLyByZXF1aXJlbWVudCkuXG5cbldlYkFwcEhhc2hpbmcuY2FsY3VsYXRlQ2xpZW50SGFzaCA9XG4gIGZ1bmN0aW9uIChtYW5pZmVzdCwgaW5jbHVkZUZpbHRlciwgcnVudGltZUNvbmZpZ092ZXJyaWRlKSB7XG4gIHZhciBoYXNoID0gY3J5cHRvLmNyZWF0ZUhhc2goJ3NoYTEnKTtcblxuICAvLyBPbWl0IHRoZSBvbGQgaGFzaGVkIGNsaWVudCB2YWx1ZXMgaW4gdGhlIG5ldyBoYXNoLiBUaGVzZSBtYXkgYmVcbiAgLy8gbW9kaWZpZWQgaW4gdGhlIG5ldyBib2lsZXJwbGF0ZS5cbiAgdmFyIHJ1bnRpbWVDZmcgPSBfLm9taXQoX19tZXRlb3JfcnVudGltZV9jb25maWdfXyxcbiAgICBbJ2F1dG91cGRhdGVWZXJzaW9uJywgJ2F1dG91cGRhdGVWZXJzaW9uUmVmcmVzaGFibGUnLFxuICAgICAnYXV0b3VwZGF0ZVZlcnNpb25Db3Jkb3ZhJ10pO1xuXG4gIGlmIChydW50aW1lQ29uZmlnT3ZlcnJpZGUpIHtcbiAgICBydW50aW1lQ2ZnID0gcnVudGltZUNvbmZpZ092ZXJyaWRlO1xuICB9XG5cbiAgaGFzaC51cGRhdGUoSlNPTi5zdHJpbmdpZnkocnVudGltZUNmZywgJ3V0ZjgnKSk7XG5cbiAgXy5lYWNoKG1hbmlmZXN0LCBmdW5jdGlvbiAocmVzb3VyY2UpIHtcbiAgICAgIGlmICgoISBpbmNsdWRlRmlsdGVyIHx8IGluY2x1ZGVGaWx0ZXIocmVzb3VyY2UudHlwZSwgcmVzb3VyY2UucmVwbGFjZWFibGUpKSAmJlxuICAgICAgICAgIChyZXNvdXJjZS53aGVyZSA9PT0gJ2NsaWVudCcgfHwgcmVzb3VyY2Uud2hlcmUgPT09ICdpbnRlcm5hbCcpKSB7XG4gICAgICBoYXNoLnVwZGF0ZShyZXNvdXJjZS5wYXRoKTtcbiAgICAgIGhhc2gudXBkYXRlKHJlc291cmNlLmhhc2gpO1xuICAgIH1cbiAgfSk7XG4gIHJldHVybiBoYXNoLmRpZ2VzdCgnaGV4Jyk7XG59O1xuXG5XZWJBcHBIYXNoaW5nLmNhbGN1bGF0ZUNvcmRvdmFDb21wYXRpYmlsaXR5SGFzaCA9XG4gIGZ1bmN0aW9uKHBsYXRmb3JtVmVyc2lvbiwgcGx1Z2luVmVyc2lvbnMpIHtcbiAgY29uc3QgaGFzaCA9IGNyeXB0by5jcmVhdGVIYXNoKCdzaGExJyk7XG5cbiAgaGFzaC51cGRhdGUocGxhdGZvcm1WZXJzaW9uKTtcblxuICAvLyBTb3J0IHBsdWdpbnMgZmlyc3Qgc28gaXRlcmF0aW9uIG9yZGVyIGRvZXNuJ3QgYWZmZWN0IHRoZSBoYXNoXG4gIGNvbnN0IHBsdWdpbnMgPSBPYmplY3Qua2V5cyhwbHVnaW5WZXJzaW9ucykuc29ydCgpO1xuICBmb3IgKGxldCBwbHVnaW4gb2YgcGx1Z2lucykge1xuICAgIGNvbnN0IHZlcnNpb24gPSBwbHVnaW5WZXJzaW9uc1twbHVnaW5dO1xuICAgIGhhc2gudXBkYXRlKHBsdWdpbik7XG4gICAgaGFzaC51cGRhdGUodmVyc2lvbik7XG4gIH1cblxuICByZXR1cm4gaGFzaC5kaWdlc3QoJ2hleCcpO1xufTtcbiJdfQ==
