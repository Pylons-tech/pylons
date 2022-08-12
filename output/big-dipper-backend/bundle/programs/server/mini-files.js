module.export({
  isWindowsLikeFilesystem: () => isWindowsLikeFilesystem,
  toPosixPath: () => toPosixPath,
  convertToPosixPath: () => convertToPosixPath,
  toDosPath: () => toDosPath,
  convertToWindowsPath: () => convertToWindowsPath,
  convertToOSPath: () => convertToOSPath,
  convertToStandardPath: () => convertToStandardPath,
  convertToOSLineEndings: () => convertToOSLineEndings,
  convertToStandardLineEndings: () => convertToStandardLineEndings,
  unicodeNormalizePath: () => unicodeNormalizePath,
  wrapPathFunction: () => wrapPathFunction,
  pathJoin: () => pathJoin,
  pathNormalize: () => pathNormalize,
  pathRelative: () => pathRelative,
  pathResolve: () => pathResolve,
  pathDirname: () => pathDirname,
  pathBasename: () => pathBasename,
  pathExtname: () => pathExtname,
  pathIsAbsolute: () => pathIsAbsolute,
  pathSep: () => pathSep,
  pathDelimiter: () => pathDelimiter,
  pathOsDelimiter: () => pathOsDelimiter
});
let path;
module.link("path", {
  default(v) {
    path = v;
  }

}, 0);
let release, EOL;
module.link("os", {
  release(v) {
    release = v;
  },

  EOL(v) {
    EOL = v;
  }

}, 1);

function isWindowsLikeFilesystem() {
  return process.platform === "win32" || release().toLowerCase().includes("microsoft");
}

function toPosixPath(p) {
  let partialPath = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : false;

  // Sometimes, you can have a path like \Users\IEUser on windows, and this
  // actually means you want C:\Users\IEUser
  if (p[0] === "\\" && !partialPath) {
    p = process.env.SystemDrive + p;
  }

  p = p.replace(/\\/g, '/');

  if (p[1] === ':' && !partialPath) {
    // transform "C:/bla/bla" to "/c/bla/bla"
    p = '/' + p[0] + p.slice(2);
  }

  return p;
}

const convertToPosixPath = toPosixPath;

function toDosPath(p) {
  let partialPath = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : false;

  if (p[0] === '/' && !partialPath) {
    if (!/^\/[A-Za-z](\/|$)/.test(p)) throw new Error("Surprising path: " + p); // transform a previously windows path back
    // "/C/something" to "c:/something"

    p = p[1] + ":" + p.slice(2);
  }

  p = p.replace(/\//g, '\\');
  return p;
}

const convertToWindowsPath = toDosPath;

function convertToOSPath(standardPath) {
  let partialPath = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : false;

  if (process.platform === "win32") {
    return toDosPath(standardPath, partialPath);
  }

  return standardPath;
}

function convertToStandardPath(osPath) {
  let partialPath = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : false;

  if (process.platform === "win32") {
    return toPosixPath(osPath, partialPath);
  }

  return osPath;
}

function convertToOSLineEndings(fileContents) {
  return fileContents.replace(/\n/g, EOL);
}

function convertToStandardLineEndings(fileContents) {
  // Convert all kinds of end-of-line chars to linuxy "\n".
  return fileContents.replace(new RegExp("\r\n", "g"), "\n").replace(new RegExp("\r", "g"), "\n");
}

function unicodeNormalizePath(path) {
  return path ? path.normalize('NFC') : path;
}

function wrapPathFunction(f) {
  let partialPath = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : false;
  return function wrapper() {
    if (process.platform === 'win32') {
      const result = f.apply(path, Array.prototype.map.call(arguments, // if partialPaths is turned on (for path.join mostly)
      // forget about conversion of absolute paths for Windows
      p => toDosPath(p, partialPath)));
      return typeof result === "string" ? toPosixPath(result, partialPath) : result;
    }

    return f.apply(path, arguments);
  };
}

const pathJoin = wrapPathFunction(path.join, true);
const pathNormalize = wrapPathFunction(path.normalize);
const pathRelative = wrapPathFunction(path.relative);
const pathResolve = wrapPathFunction(path.resolve);
const pathDirname = wrapPathFunction(path.dirname);
const pathBasename = wrapPathFunction(path.basename);
const pathExtname = wrapPathFunction(path.extname);
const pathIsAbsolute = wrapPathFunction(path.isAbsolute);
const pathSep = '/';
const pathDelimiter = ':';
const pathOsDelimiter = path.delimiter;
//# sourceMappingURL=mini-files.js.map