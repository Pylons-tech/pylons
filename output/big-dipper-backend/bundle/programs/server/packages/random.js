(function () {

/* Imports */
var Meteor = Package.meteor.Meteor;
var global = Package.meteor.global;
var meteorEnv = Package.meteor.meteorEnv;
var ECMAScript = Package.ecmascript.ECMAScript;
var meteorInstall = Package.modules.meteorInstall;
var Promise = Package.promise.Promise;

/* Package-scope variables */
var charsCount, Random;

var require = meteorInstall({"node_modules":{"meteor":{"random":{"main_server.js":function module(require,exports,module){

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                //
// packages/random/main_server.js                                                                                 //
//                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                  //
module.export({
  Random: () => Random
});
let NodeRandomGenerator;
module.link("./NodeRandomGenerator", {
  default(v) {
    NodeRandomGenerator = v;
  }

}, 0);
let createRandom;
module.link("./createRandom", {
  default(v) {
    createRandom = v;
  }

}, 1);
const Random = createRandom(new NodeRandomGenerator());
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"AbstractRandomGenerator.js":function module(require,exports,module){

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                //
// packages/random/AbstractRandomGenerator.js                                                                     //
//                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                  //
module.export({
  default: () => RandomGenerator
});
let Meteor;
module.link("meteor/meteor", {
  Meteor(v) {
    Meteor = v;
  }

}, 0);
const UNMISTAKABLE_CHARS = '23456789ABCDEFGHJKLMNPQRSTWXYZabcdefghijkmnopqrstuvwxyz';
const BASE64_CHARS = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' + '0123456789-_'; // `type` is one of `RandomGenerator.Type` as defined below.
//
// options:
// - seeds: (required, only for RandomGenerator.Type.ALEA) an array
//   whose items will be `toString`ed and used as the seed to the Alea
//   algorithm

class RandomGenerator {
  /**
   * @name Random.fraction
   * @summary Return a number between 0 and 1, like `Math.random`.
   * @locus Anywhere
   */
  fraction() {
    throw new Error("Unknown random generator type");
  }
  /**
   * @name Random.hexString
   * @summary Return a random string of `n` hexadecimal digits.
   * @locus Anywhere
   * @param {Number} n Length of the string
   */


  hexString(digits) {
    return this._randomString(digits, '0123456789abcdef');
  }

  _randomString(charsCount, alphabet) {
    let result = '';

    for (let i = 0; i < charsCount; i++) {
      result += this.choice(alphabet);
    }

    return result;
  }
  /**
   * @name Random.id
   * @summary Return a unique identifier, such as `"Jjwjg6gouWLXhMGKW"`, that is
   * likely to be unique in the whole world.
   * @locus Anywhere
   * @param {Number} [n] Optional length of the identifier in characters
   *   (defaults to 17)
   */


  id(charsCount) {
    // 17 characters is around 96 bits of entropy, which is the amount of
    // state in the Alea PRNG.
    if (charsCount === undefined) {
      charsCount = 17;
    }

    return this._randomString(charsCount, UNMISTAKABLE_CHARS);
  }
  /**
   * @name Random.secret
   * @summary Return a random string of printable characters with 6 bits of
   * entropy per character. Use `Random.secret` for security-critical secrets
   * that are intended for machine, rather than human, consumption.
   * @locus Anywhere
   * @param {Number} [n] Optional length of the secret string (defaults to 43
   *   characters, or 256 bits of entropy)
   */


  secret(charsCount) {
    // Default to 256 bits of entropy, or 43 characters at 6 bits per
    // character.
    if (charsCount === undefined) {
      charsCount = 43;
    }

    return this._randomString(charsCount, BASE64_CHARS);
  }
  /**
   * @name Random.choice
   * @summary Return a random element of the given array or string.
   * @locus Anywhere
   * @param {Array|String} arrayOrString Array or string to choose from
   */


  choice(arrayOrString) {
    const index = Math.floor(this.fraction() * arrayOrString.length);

    if (typeof arrayOrString === 'string') {
      return arrayOrString.substr(index, 1);
    }

    return arrayOrString[index];
  }

}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"AleaRandomGenerator.js":function module(require,exports,module){

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                //
// packages/random/AleaRandomGenerator.js                                                                         //
//                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                  //
module.export({
  default: () => AleaRandomGenerator
});
let RandomGenerator;
module.link("./AbstractRandomGenerator", {
  default(v) {
    RandomGenerator = v;
  }

}, 0);

// Alea PRNG, which is not cryptographically strong
// see http://baagoe.org/en/wiki/Better_random_numbers_for_javascript
// for a full discussion and Alea implementation.
function Alea(seeds) {
  function Mash() {
    let n = 0xefc8249d;

    const mash = data => {
      data = data.toString();

      for (let i = 0; i < data.length; i++) {
        n += data.charCodeAt(i);
        let h = 0.02519603282416938 * n;
        n = h >>> 0;
        h -= n;
        h *= n;
        n = h >>> 0;
        h -= n;
        n += h * 0x100000000; // 2^32
      }

      return (n >>> 0) * 2.3283064365386963e-10; // 2^-32
    };

    mash.version = 'Mash 0.9';
    return mash;
  }

  let s0 = 0;
  let s1 = 0;
  let s2 = 0;
  let c = 1;

  if (seeds.length === 0) {
    seeds = [+new Date()];
  }

  let mash = Mash();
  s0 = mash(' ');
  s1 = mash(' ');
  s2 = mash(' ');

  for (let i = 0; i < seeds.length; i++) {
    s0 -= mash(seeds[i]);

    if (s0 < 0) {
      s0 += 1;
    }

    s1 -= mash(seeds[i]);

    if (s1 < 0) {
      s1 += 1;
    }

    s2 -= mash(seeds[i]);

    if (s2 < 0) {
      s2 += 1;
    }
  }

  mash = null;

  const random = () => {
    const t = 2091639 * s0 + c * 2.3283064365386963e-10; // 2^-32

    s0 = s1;
    s1 = s2;
    return s2 = t - (c = t | 0);
  };

  random.uint32 = () => random() * 0x100000000; // 2^32


  random.fract53 = () => random() + (random() * 0x200000 | 0) * 1.1102230246251565e-16; // 2^-53


  random.version = 'Alea 0.9';
  random.args = seeds;
  return random;
} // options:
// - seeds: an array
//   whose items will be `toString`ed and used as the seed to the Alea
//   algorithm


class AleaRandomGenerator extends RandomGenerator {
  constructor() {
    let {
      seeds = []
    } = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};
    super();

    if (!seeds) {
      throw new Error('No seeds were provided for Alea PRNG');
    }

    this.alea = Alea(seeds);
  }
  /**
   * @name Random.fraction
   * @summary Return a number between 0 and 1, like `Math.random`.
   * @locus Anywhere
   */


  fraction() {
    return this.alea();
  }

}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"NodeRandomGenerator.js":function module(require,exports,module){

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                //
// packages/random/NodeRandomGenerator.js                                                                         //
//                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                  //
module.export({
  default: () => NodeRandomGenerator
});
let crypto;
module.link("crypto", {
  default(v) {
    crypto = v;
  }

}, 0);
let RandomGenerator;
module.link("./AbstractRandomGenerator", {
  default(v) {
    RandomGenerator = v;
  }

}, 1);

class NodeRandomGenerator extends RandomGenerator {
  /**
   * @name Random.fraction
   * @summary Return a number between 0 and 1, like `Math.random`.
   * @locus Anywhere
   */
  fraction() {
    const numerator = Number.parseInt(this.hexString(8), 16);
    return numerator * 2.3283064365386963e-10; // 2^-3;
  }
  /**
   * @name Random.hexString
   * @summary Return a random string of `n` hexadecimal digits.
   * @locus Anywhere
   * @param {Number} n Length of the string
   */


  hexString(digits) {
    const numBytes = Math.ceil(digits / 2);
    let bytes; // Try to get cryptographically strong randomness. Fall back to
    // non-cryptographically strong if not available.

    try {
      bytes = crypto.randomBytes(numBytes);
    } catch (e) {
      // XXX should re-throw any error except insufficient entropy
      bytes = crypto.pseudoRandomBytes(numBytes);
    }

    const result = bytes.toString('hex'); // If the number of digits is odd, we'll have generated an extra 4 bits
    // of randomness, so we need to trim the last digit.

    return result.substring(0, digits);
  }

}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"createAleaGenerator.js":function module(require,exports,module){

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                //
// packages/random/createAleaGenerator.js                                                                         //
//                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                  //
module.export({
  default: () => createAleaGenerator
});
let AleaRandomGenerator;
module.link("./AleaRandomGenerator", {
  default(v) {
    AleaRandomGenerator = v;
  }

}, 0);
// instantiate RNG.  Heuristically collect entropy from various sources when a
// cryptographic PRNG isn't available.
// client sources
const height = typeof window !== 'undefined' && window.innerHeight || typeof document !== 'undefined' && document.documentElement && document.documentElement.clientHeight || typeof document !== 'undefined' && document.body && document.body.clientHeight || 1;
const width = typeof window !== 'undefined' && window.innerWidth || typeof document !== 'undefined' && document.documentElement && document.documentElement.clientWidth || typeof document !== 'undefined' && document.body && document.body.clientWidth || 1;
const agent = typeof navigator !== 'undefined' && navigator.userAgent || '';

function createAleaGenerator() {
  return new AleaRandomGenerator({
    seeds: [new Date(), height, width, agent, Math.random()]
  });
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

},"createRandom.js":function module(require,exports,module){

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                //
// packages/random/createRandom.js                                                                                //
//                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                  //
module.export({
  default: () => createRandom
});
let AleaRandomGenerator;
module.link("./AleaRandomGenerator", {
  default(v) {
    AleaRandomGenerator = v;
  }

}, 0);
let createAleaGeneratorWithGeneratedSeed;
module.link("./createAleaGenerator", {
  default(v) {
    createAleaGeneratorWithGeneratedSeed = v;
  }

}, 1);

function createRandom(generator) {
  // Create a non-cryptographically secure PRNG with a given seed (using
  // the Alea algorithm)
  generator.createWithSeeds = function () {
    for (var _len = arguments.length, seeds = new Array(_len), _key = 0; _key < _len; _key++) {
      seeds[_key] = arguments[_key];
    }

    if (seeds.length === 0) {
      throw new Error('No seeds were provided');
    }

    return new AleaRandomGenerator({
      seeds
    });
  }; // Used like `Random`, but much faster and not cryptographically
  // secure


  generator.insecure = createAleaGeneratorWithGeneratedSeed();
  return generator;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}}}}},{
  "extensions": [
    ".js",
    ".json"
  ]
});

var exports = require("/node_modules/meteor/random/main_server.js");

/* Exports */
Package._define("random", exports, {
  Random: Random
});

})();

//# sourceURL=meteor://💻app/packages/random.js
//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvcmFuZG9tL21haW5fc2VydmVyLmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9wYWNrYWdlcy9yYW5kb20vQWJzdHJhY3RSYW5kb21HZW5lcmF0b3IuanMiLCJtZXRlb3I6Ly/wn5K7YXBwL3BhY2thZ2VzL3JhbmRvbS9BbGVhUmFuZG9tR2VuZXJhdG9yLmpzIiwibWV0ZW9yOi8v8J+Su2FwcC9wYWNrYWdlcy9yYW5kb20vTm9kZVJhbmRvbUdlbmVyYXRvci5qcyIsIm1ldGVvcjovL/CfkrthcHAvcGFja2FnZXMvcmFuZG9tL2NyZWF0ZUFsZWFHZW5lcmF0b3IuanMiLCJtZXRlb3I6Ly/wn5K7YXBwL3BhY2thZ2VzL3JhbmRvbS9jcmVhdGVSYW5kb20uanMiXSwibmFtZXMiOlsibW9kdWxlIiwiZXhwb3J0IiwiUmFuZG9tIiwiTm9kZVJhbmRvbUdlbmVyYXRvciIsImxpbmsiLCJkZWZhdWx0IiwidiIsImNyZWF0ZVJhbmRvbSIsIlJhbmRvbUdlbmVyYXRvciIsIk1ldGVvciIsIlVOTUlTVEFLQUJMRV9DSEFSUyIsIkJBU0U2NF9DSEFSUyIsImZyYWN0aW9uIiwiRXJyb3IiLCJoZXhTdHJpbmciLCJkaWdpdHMiLCJfcmFuZG9tU3RyaW5nIiwiY2hhcnNDb3VudCIsImFscGhhYmV0IiwicmVzdWx0IiwiaSIsImNob2ljZSIsImlkIiwidW5kZWZpbmVkIiwic2VjcmV0IiwiYXJyYXlPclN0cmluZyIsImluZGV4IiwiTWF0aCIsImZsb29yIiwibGVuZ3RoIiwic3Vic3RyIiwiQWxlYVJhbmRvbUdlbmVyYXRvciIsIkFsZWEiLCJzZWVkcyIsIk1hc2giLCJuIiwibWFzaCIsImRhdGEiLCJ0b1N0cmluZyIsImNoYXJDb2RlQXQiLCJoIiwidmVyc2lvbiIsInMwIiwiczEiLCJzMiIsImMiLCJEYXRlIiwicmFuZG9tIiwidCIsInVpbnQzMiIsImZyYWN0NTMiLCJhcmdzIiwiY29uc3RydWN0b3IiLCJhbGVhIiwiY3J5cHRvIiwibnVtZXJhdG9yIiwiTnVtYmVyIiwicGFyc2VJbnQiLCJudW1CeXRlcyIsImNlaWwiLCJieXRlcyIsInJhbmRvbUJ5dGVzIiwiZSIsInBzZXVkb1JhbmRvbUJ5dGVzIiwic3Vic3RyaW5nIiwiY3JlYXRlQWxlYUdlbmVyYXRvciIsImhlaWdodCIsIndpbmRvdyIsImlubmVySGVpZ2h0IiwiZG9jdW1lbnQiLCJkb2N1bWVudEVsZW1lbnQiLCJjbGllbnRIZWlnaHQiLCJib2R5Iiwid2lkdGgiLCJpbm5lcldpZHRoIiwiY2xpZW50V2lkdGgiLCJhZ2VudCIsIm5hdmlnYXRvciIsInVzZXJBZ2VudCIsImNyZWF0ZUFsZWFHZW5lcmF0b3JXaXRoR2VuZXJhdGVkU2VlZCIsImdlbmVyYXRvciIsImNyZWF0ZVdpdGhTZWVkcyIsImluc2VjdXJlIl0sIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7QUFBQUEsTUFBTSxDQUFDQyxNQUFQLENBQWM7QUFBQ0MsUUFBTSxFQUFDLE1BQUlBO0FBQVosQ0FBZDtBQUFtQyxJQUFJQyxtQkFBSjtBQUF3QkgsTUFBTSxDQUFDSSxJQUFQLENBQVksdUJBQVosRUFBb0M7QUFBQ0MsU0FBTyxDQUFDQyxDQUFELEVBQUc7QUFBQ0gsdUJBQW1CLEdBQUNHLENBQXBCO0FBQXNCOztBQUFsQyxDQUFwQyxFQUF3RSxDQUF4RTtBQUEyRSxJQUFJQyxZQUFKO0FBQWlCUCxNQUFNLENBQUNJLElBQVAsQ0FBWSxnQkFBWixFQUE2QjtBQUFDQyxTQUFPLENBQUNDLENBQUQsRUFBRztBQUFDQyxnQkFBWSxHQUFDRCxDQUFiO0FBQWU7O0FBQTNCLENBQTdCLEVBQTBELENBQTFEO0FBT2hKLE1BQU1KLE1BQU0sR0FBR0ssWUFBWSxDQUFDLElBQUlKLG1CQUFKLEVBQUQsQ0FBM0IsQzs7Ozs7Ozs7Ozs7QUNQUEgsTUFBTSxDQUFDQyxNQUFQLENBQWM7QUFBQ0ksU0FBTyxFQUFDLE1BQUlHO0FBQWIsQ0FBZDtBQUE2QyxJQUFJQyxNQUFKO0FBQVdULE1BQU0sQ0FBQ0ksSUFBUCxDQUFZ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QUFWaEQsS0FBVTtBQUFWQSxXQUFVO0FBQUE7O0FBQ3hDLFFBQUlBLEtBQUssQ0FBQ0osTUFBTixLQUFpQixDQUFyQixFQUF3QjtBQUN0QixZQUFNLElBQUloQixLQUFKLENBQVUsd0JBQVYsQ0FBTjtBQUNEOztBQUNELFdBQU8sSUFBSWtCLG1CQUFKLENBQXdCO0FBQUVFO0FBQUYsS0FBeEIsQ0FBUDtBQUNELEdBTEQsQ0FIOEMsQ0FVOUM7QUFDQTs7O0FBQ0ErQyxXQUFTLENBQUNFLFFBQVYsR0FBcUJILG9DQUFvQyxFQUF6RDtBQUVBLFNBQU9DLFNBQVA7QUFDRCxDIiwiZmlsZSI6Ii9wYWNrYWdlcy9yYW5kb20uanMiLCJzb3VyY2VzQ29udGVudCI6WyIvLyBXZSB1c2UgY3J5cHRvZ3JhcGhpY2FsbHkgc3Ryb25nIFBSTkdzIChjcnlwdG8uZ2V0UmFuZG9tQnl0ZXMoKSlcbi8vIFdoZW4gdXNpbmcgY3J5cHRvLmdldFJhbmRvbVZhbHVlcygpLCBvdXIgcHJpbWl0aXZlIGlzIGhleFN0cmluZygpLFxuLy8gZnJvbSB3aGljaCB3ZSBjb25zdHJ1Y3QgZnJhY3Rpb24oKS5cblxuaW1wb3J0IE5vZGVSYW5kb21HZW5lcmF0b3IgZnJvbSAnLi9Ob2RlUmFuZG9tR2VuZXJhdG9yJztcbmltcG9ydCBjcmVhdGVSYW5kb20gZnJvbSAnLi9jcmVhdGVSYW5kb20nO1xuXG5leHBvcnQgY29uc3QgUmFuZG9tID0gY3JlYXRlUmFuZG9tKG5ldyBOb2RlUmFuZG9tR2VuZXJhdG9yKCkpO1xuIiwiLy8gV2UgdXNlIGNyeXB0b2dyYXBoaWNhbGx5IHN0cm9uZyBQUk5HcyAoY3J5cHRvLmdldFJhbmRvbUJ5dGVzKCkgb24gdGhlIHNlcnZlcixcbi8vIHdpbmRvdy5jcnlwdG8uZ2V0UmFuZG9tVmFsdWVzKCkgaW4gdGhlIGJyb3dzZXIpIHdoZW4gYXZhaWxhYmxlLiBJZiB0aGVzZVxuLy8gUFJOR3MgZmFpbCwgd2UgZmFsbCBiYWNrIHRvIHRoZSBBbGVhIFBSTkcsIHdoaWNoIGlzIG5vdCBjcnlwdG9ncmFwaGljYWxseVxuLy8gc3Ryb25nLCBhbmQgd2Ugc2VlZCBpdCB3aXRoIHZhcmlvdXMgc291cmNlcyBzdWNoIGFzIHRoZSBkYXRlLCBNYXRoLnJhbmRvbSxcbi8vIGFuZCB3aW5kb3cgc2l6ZSBvbiB0aGUgY2xpZW50LiAgV2hlbiB1c2luZyBjcnlwdG8uZ2V0UmFuZG9tVmFsdWVzKCksIG91clxuLy8gcHJpbWl0aXZlIGlzIGhleFN0cmluZygpLCBmcm9tIHdoaWNoIHdlIGNvbnN0cnVjdCBmcmFjdGlvbigpLiBXaGVuIHVzaW5nXG4vLyB3aW5kb3cuY3J5cHRvLmdldFJhbmRvbVZhbHVlcygpIG9yIGFsZWEsIHRoZSBwcmltaXRpdmUgaXMgZnJhY3Rpb24gYW5kIHdlIHVzZVxuLy8gdGhhdCB0byBjb25zdHJ1Y3QgaGV4IHN0cmluZy5cblxuaW1wb3J0IHsgTWV0ZW9yIH0gZnJvbSAnbWV0ZW9yL21ldGVvcic7XG5cbmNvbnN0IFVOTUlTVEFLQUJMRV9DSEFSUyA9ICcyMzQ1Njc4OUFCQ0RFRkdISktMTU5QUVJTVFdYWVphYmNkZWZnaGlqa21ub3BxcnN0dXZ3eHl6JztcbmNvbnN0IEJBU0U2NF9DSEFSUyA9ICdhYmNkZWZnaGlqa2xtbm9wcXJzdHV2d3h5ekFCQ0RFRkdISUpLTE1OT1BRUlNUVVZXWFlaJyArXG4gICcwMTIzNDU2Nzg5LV8nO1xuXG4vLyBgdHlwZWAgaXMgb25lIG9mIGBSYW5kb21HZW5lcmF0b3IuVHlwZWAgYXMgZGVmaW5lZCBiZWxvdy5cbi8vXG4vLyBvcHRpb25zOlxuLy8gLSBzZWVkczogKHJlcXVpcmVkLCBvbmx5IGZvciBSYW5kb21HZW5lcmF0b3IuVHlwZS5BTEVBKSBhbiBhcnJheVxuLy8gICB3aG9zZSBpdGVtcyB3aWxsIGJlIGB0b1N0cmluZ2BlZCBhbmQgdXNlZCBhcyB0aGUgc2VlZCB0byB0aGUgQWxlYVxuLy8gICBhbGdvcml0aG1cbmV4cG9ydCBkZWZhdWx0IGNsYXNzIFJhbmRvbUdlbmVyYXRvciB7XG5cbiAgLyoqXG4gICAqIEBuYW1lIFJhbmRvbS5mcmFjdGlvblxuICAgKiBAc3VtbWFyeSBSZXR1cm4gYSBudW1iZXIgYmV0d2VlbiAwIGFuZCAxLCBsaWtlIGBNYXRoLnJhbmRvbWAuXG4gICAqIEBsb2N1cyBBbnl3aGVyZVxuICAgKi9cbiAgZnJhY3Rpb24gKCkge1xuICAgIHRocm93IG5ldyBFcnJvcihgVW5rbm93biByYW5kb20gZ2VuZXJhdG9yIHR5cGVgKTtcbiAgfVxuXG4gIC8qKlxuICAgKiBAbmFtZSBSYW5kb20uaGV4U3RyaW5nXG4gICAqIEBzdW1tYXJ5IFJldHVybiBhIHJhbmRvbSBzdHJpbmcgb2YgYG5gIGhleGFkZWNpbWFsIGRpZ2l0cy5cbiAgICogQGxvY3VzIEFueXdoZXJlXG4gICAqIEBwYXJhbSB7TnVtYmVyfSBuIExlbmd0aCBvZiB0aGUgc3RyaW5nXG4gICAqL1xuICBoZXhTdHJpbmcgKGRpZ2l0cykge1xuICAgIHJldHVybiB0aGlzLl9yYW5kb21TdHJpbmcoZGlnaXRzLCAnMDEyMzQ1Njc4OWFiY2RlZicpO1xuICB9XG5cbiAgX3JhbmRvbVN0cmluZyAoY2hhcnNDb3VudCwgYWxwaGFiZXQpIHtcbiAgICBsZXQgcmVzdWx0ID0gJyc7XG4gICAgZm9yIChsZXQgaSA9IDA7IGkgPCBjaGFyc0NvdW50OyBpKyspIHtcdFxuICAgICAgcmVzdWx0ICs9IHRoaXMuY2hvaWNlKGFscGhhYmV0KTtcbiAgICB9XG4gICAgcmV0dXJuIHJlc3VsdDtcbiAgfVxuXG4gIC8qKlxuICAgKiBAbmFtZSBSYW5kb20uaWRcbiAgICogQHN1bW1hcnkgUmV0dXJuIGEgdW5pcXVlIGlkZW50aWZpZXIsIHN1Y2ggYXMgYFwiSmp3amc2Z291V0xYaE1HS1dcImAsIHRoYXQgaXNcbiAgICogbGlrZWx5IHRvIGJlIHVuaXF1ZSBpbiB0aGUgd2hvbGUgd29ybGQuXG4gICAqIEBsb2N1cyBBbnl3aGVyZVxuICAgKiBAcGFyYW0ge051bWJlcn0gW25dIE9wdGlvbmFsIGxlbmd0aCBvZiB0aGUgaWRlbnRpZmllciBpbiBjaGFyYWN0ZXJzXG4gICAqICAgKGRlZmF1bHRzIHRvIDE3KVxuICAgKi9cbiAgaWQgKGNoYXJzQ291bnQpIHtcbiAgICAvLyAxNyBjaGFyYWN0ZXJzIGlzIGFyb3VuZCA5NiBiaXRzIG9mIGVudHJvcHksIHdoaWNoIGlzIHRoZSBhbW91bnQgb2ZcbiAgICAvLyBzdGF0ZSBpbiB0aGUgQWxlYSBQUk5HLlxuICAgIGlmIChjaGFyc0NvdW50ID09PSB1bmRlZmluZWQpIHtcbiAgICAgIGNoYXJzQ291bnQgPSAxNztcbiAgICB9XG5cbiAgICByZXR1cm4gdGhpcy5fcmFuZG9tU3RyaW5nKGNoYXJzQ291bnQsIFVOTUlTVEFLQUJMRV9DSEFSUyk7XG4gIH1cblxuICAvKipcbiAgICogQG5hbWUgUmFuZG9tLnNlY3JldFxuICAgKiBAc3VtbWFyeSBSZXR1cm4gYSByYW5kb20gc3RyaW5nIG9mIHByaW50YWJsZSBjaGFyYWN0ZXJzIHdpdGggNiBiaXRzIG9mXG4gICAqIGVudHJvcHkgcGVyIGNoYXJhY3Rlci4gVXNlIGBSYW5kb20uc2VjcmV0YCBmb3Igc2VjdXJpdHktY3JpdGljYWwgc2VjcmV0c1xuICAgKiB0aGF0IGFyZSBpbnRlbmRlZCBmb3IgbWFjaGluZSwgcmF0aGVyIHRoYW4gaHVtYW4sIGNvbnN1bXB0aW9uLlxuICAgKiBAbG9jdXMgQW55d2hlcmVcbiAgICogQHBhcmFtIHtOdW1iZXJ9IFtuXSBPcHRpb25hbCBsZW5ndGggb2YgdGhlIHNlY3JldCBzdHJpbmcgKGRlZmF1bHRzIHRvIDQzXG4gICAqICAgY2hhcmFjdGVycywgb3IgMjU2IGJpdHMgb2YgZW50cm9weSlcbiAgICovXG4gIHNlY3JldCAoY2hhcnNDb3VudCkge1xuICAgIC8vIERlZmF1bHQgdG8gMjU2IGJpdHMgb2YgZW50cm9weSwgb3IgNDMgY2hhcmFjdGVycyBhdCA2IGJpdHMgcGVyXG4gICAgLy8gY2hhcmFjdGVyLlxuICAgIGlmIChjaGFyc0NvdW50ID09PSB1bmRlZmluZWQpIHtcbiAgICAgIGNoYXJzQ291bnQgPSA0MztcbiAgICB9XG5cbiAgICByZXR1cm4gdGhpcy5fcmFuZG9tU3RyaW5nKGNoYXJzQ291bnQsIEJBU0U2NF9DSEFSUyk7XG4gIH1cblxuICAvKipcbiAgICogQG5hbWUgUmFuZG9tLmNob2ljZVxuICAgKiBAc3VtbWFyeSBSZXR1cm4gYSByYW5kb20gZWxlbWVudCBvZiB0aGUgZ2l2ZW4gYXJyYXkgb3Igc3RyaW5nLlxuICAgKiBAbG9jdXMgQW55d2hlcmVcbiAgICogQHBhcmFtIHtBcnJheXxTdHJpbmd9IGFycmF5T3JTdHJpbmcgQXJyYXkgb3Igc3RyaW5nIHRvIGNob29zZSBmcm9tXG4gICAqL1xuICBjaG9pY2UgKGFycmF5T3JTdHJpbmcpIHtcbiAgICBjb25zdCBpbmRleCA9IE1hdGguZmxvb3IodGhpcy5mcmFjdGlvbigpICogYXJyYXlPclN0cmluZy5sZW5ndGgpO1xuICAgIGlmICh0eXBlb2YgYXJyYXlPclN0cmluZyA9PT0gJ3N0cmluZycpIHtcbiAgICAgIHJldHVybiBhcnJheU9yU3RyaW5nLnN1YnN0cihpbmRleCwgMSk7XG4gICAgfVxuICAgIHJldHVybiBhcnJheU9yU3RyaW5nW2luZGV4XTtcbiAgfVxufVxuIiwiaW1wb3J0IFJhbmRvbUdlbmVyYXRvciBmcm9tICcuL0Fic3RyYWN0UmFuZG9tR2VuZXJhdG9yJztcblxuLy8gQWxlYSBQUk5HLCB3aGljaCBpcyBub3QgY3J5cHRvZ3JhcGhpY2FsbHkgc3Ryb25nXG4vLyBzZWUgaHR0cDovL2JhYWdvZS5vcmcvZW4vd2lraS9CZXR0ZXJfcmFuZG9tX251bWJlcnNfZm9yX2phdmFzY3JpcHRcbi8vIGZvciBhIGZ1bGwgZGlzY3Vzc2lvbiBhbmQgQWxlYSBpbXBsZW1lbnRhdGlvbi5cbmZ1bmN0aW9uIEFsZWEoc2VlZHMpIHtcbiAgZnVuY3Rpb24gTWFzaCgpIHtcbiAgICBsZXQgbiA9IDB4ZWZjODI0OWQ7XG5cbiAgICBjb25zdCBtYXNoID0gKGRhdGEpID0+IHtcbiAgICAgIGRhdGEgPSBkYXRhLnRvU3RyaW5nKCk7XG4gICAgICBmb3IgKGxldCBpID0gMDsgaSA8IGRhdGEubGVuZ3RoOyBpKyspIHtcbiAgICAgICAgbiArPSBkYXRhLmNoYXJDb2RlQXQoaSk7XG4gICAgICAgIGxldCBoID0gMC4wMjUxOTYwMzI4MjQxNjkzOCAqIG47XG4gICAgICAgIG4gPSBoID4+PiAwO1xuICAgICAgICBoIC09IG47XG4gICAgICAgIGggKj0gbjtcbiAgICAgICAgbiA9IGggPj4+IDA7XG4gICAgICAgIGggLT0gbjtcbiAgICAgICAgbiArPSBoICogMHgxMDAwMDAwMDA7IC8vIDJeMzJcbiAgICAgIH1cbiAgICAgIHJldHVybiAobiA+Pj4gMCkgKiAyLjMyODMwNjQzNjUzODY5NjNlLTEwOyAvLyAyXi0zMlxuICAgIH07XG5cbiAgICBtYXNoLnZlcnNpb24gPSAnTWFzaCAwLjknO1xuICAgIHJldHVybiBtYXNoO1xuICB9XG5cbiAgbGV0IHMwID0gMDtcbiAgbGV0IHMxID0gMDtcbiAgbGV0IHMyID0gMDtcbiAgbGV0IGMgPSAxO1xuICBpZiAoc2VlZHMubGVuZ3RoID09PSAwKSB7XG4gICAgc2VlZHMgPSBbK25ldyBEYXRlXTtcbiAgfVxuICBsZXQgbWFzaCA9IE1hc2goKTtcbiAgczAgPSBtYXNoKCcgJyk7XG4gIHMxID0gbWFzaCgnICcpO1xuICBzMiA9IG1hc2goJyAnKTtcblxuICBmb3IgKGxldCBpID0gMDsgaSA8IHNlZWRzLmxlbmd0aDsgaSsrKSB7XG4gICAgczAgLT0gbWFzaChzZWVkc1tpXSk7XG4gICAgaWYgKHMwIDwgMCkge1xuICAgICAgczAgKz0gMTtcbiAgICB9XG4gICAgczEgLT0gbWFzaChzZWVkc1tpXSk7XG4gICAgaWYgKHMxIDwgMCkge1xuICAgICAgczEgKz0gMTtcbiAgICB9XG4gICAgczIgLT0gbWFzaChzZWVkc1tpXSk7XG4gICAgaWYgKHMyIDwgMCkge1xuICAgICAgczIgKz0gMTtcbiAgICB9XG4gIH1cbiAgbWFzaCA9IG51bGw7XG5cbiAgY29uc3QgcmFuZG9tID0gKCkgPT4ge1xuICAgIGNvbnN0IHQgPSAoMjA5MTYzOSAqIHMwKSArIChjICogMi4zMjgzMDY0MzY1Mzg2OTYzZS0xMCk7IC8vIDJeLTMyXG4gICAgczAgPSBzMTtcbiAgICBzMSA9IHMyO1xuICAgIHJldHVybiBzMiA9IHQgLSAoYyA9IHQgfCAwKTtcbiAgfTtcblxuICByYW5kb20udWludDMyID0gKCkgPT4gcmFuZG9tKCkgKiAweDEwMDAwMDAwMDsgLy8gMl4zMlxuICByYW5kb20uZnJhY3Q1MyA9ICgpID0+IHJhbmRvbSgpICtcbiAgICAgICAgKChyYW5kb20oKSAqIDB4MjAwMDAwIHwgMCkgKiAxLjExMDIyMzAyNDYyNTE1NjVlLTE2KTsgLy8gMl4tNTNcblxuICByYW5kb20udmVyc2lvbiA9ICdBbGVhIDAuOSc7XG4gIHJhbmRvbS5hcmdzID0gc2VlZHM7XG4gIHJldHVybiByYW5kb207XG59XG5cbi8vIG9wdGlvbnM6XG4vLyAtIHNlZWRzOiBhbiBhcnJheVxuLy8gICB3aG9zZSBpdGVtcyB3aWxsIGJlIGB0b1N0cmluZ2BlZCBhbmQgdXNlZCBhcyB0aGUgc2VlZCB0byB0aGUgQWxlYVxuLy8gICBhbGdvcml0aG1cbmV4cG9ydCBkZWZhdWx0IGNsYXNzIEFsZWFSYW5kb21HZW5lcmF0b3IgZXh0ZW5kcyBSYW5kb21HZW5lcmF0b3Ige1xuICBjb25zdHJ1Y3RvciAoeyBzZWVkcyA9IFtdIH0gPSB7fSkge1xuICAgIHN1cGVyKCk7XG4gICAgaWYgKCFzZWVkcykge1xuICAgICAgdGhyb3cgbmV3IEVycm9yKCdObyBzZWVkcyB3ZXJlIHByb3ZpZGVkIGZvciBBbGVhIFBSTkcnKTtcbiAgICB9XG4gICAgdGhpcy5hbGVhID0gQWxlYShzZWVkcyk7XG4gIH1cblxuICAvKipcbiAgICogQG5hbWUgUmFuZG9tLmZyYWN0aW9uXG4gICAqIEBzdW1tYXJ5IFJldHVybiBhIG51bWJlciBiZXR3ZWVuIDAgYW5kIDEsIGxpa2UgYE1hdGgucmFuZG9tYC5cbiAgICogQGxvY3VzIEFueXdoZXJlXG4gICAqL1xuICBmcmFjdGlvbiAoKSB7XG4gICAgcmV0dXJuIHRoaXMuYWxlYSgpO1xuICB9XG59XG4iLCJpbXBvcnQgY3J5cHRvIGZyb20gJ2NyeXB0byc7XG5pbXBvcnQgUmFuZG9tR2VuZXJhdG9yIGZyb20gJy4vQWJzdHJhY3RSYW5kb21HZW5lcmF0b3InO1xuXG5leHBvcnQgZGVmYXVsdCBjbGFzcyBOb2RlUmFuZG9tR2VuZXJhdG9yIGV4dGVuZHMgUmFuZG9tR2VuZXJhdG9yIHtcbiAgLyoqXG4gICAqIEBuYW1lIFJhbmRvbS5mcmFjdGlvblxuICAgKiBAc3VtbWFyeSBSZXR1cm4gYSBudW1iZXIgYmV0d2VlbiAwIGFuZCAxLCBsaWtlIGBNYXRoLnJhbmRvbWAuXG4gICAqIEBsb2N1cyBBbnl3aGVyZVxuICAgKi9cbiAgZnJhY3Rpb24gKCkge1xuICAgIGNvbnN0IG51bWVyYXRvciA9IE51bWJlci5wYXJzZUludCh0aGlzLmhleFN0cmluZyg4KSwgMTYpO1xuICAgIHJldHVybiBudW1lcmF0b3IgKiAyLjMyODMwNjQzNjUzODY5NjNlLTEwOyAvLyAyXi0zO1xuICB9XG5cbiAgLyoqXG4gICAqIEBuYW1lIFJhbmRvbS5oZXhTdHJpbmdcbiAgICogQHN1bW1hcnkgUmV0dXJuIGEgcmFuZG9tIHN0cmluZyBvZiBgbmAgaGV4YWRlY2ltYWwgZGlnaXRzLlxuICAgKiBAbG9jdXMgQW55d2hlcmVcbiAgICogQHBhcmFtIHtOdW1iZXJ9IG4gTGVuZ3RoIG9mIHRoZSBzdHJpbmdcbiAgICovXG4gIGhleFN0cmluZyAoZGlnaXRzKSB7XG4gICAgY29uc3QgbnVtQnl0ZXMgPSBNYXRoLmNlaWwoZGlnaXRzIC8gMik7XG4gICAgbGV0IGJ5dGVzO1xuICAgIC8vIFRyeSB0byBnZXQgY3J5cHRvZ3JhcGhpY2FsbHkgc3Ryb25nIHJhbmRvbW5lc3MuIEZhbGwgYmFjayB0b1xuICAgIC8vIG5vbi1jcnlwdG9ncmFwaGljYWxseSBzdHJvbmcgaWYgbm90IGF2YWlsYWJsZS5cbiAgICB0cnkge1xuICAgICAgYnl0ZXMgPSBjcnlwdG8ucmFuZG9tQnl0ZXMobnVtQnl0ZXMpO1xuICAgIH0gY2F0Y2ggKGUpIHtcbiAgICAgIC8vIFhYWCBzaG91bGQgcmUtdGhyb3cgYW55IGVycm9yIGV4Y2VwdCBpbnN1ZmZpY2llbnQgZW50cm9weVxuICAgICAgYnl0ZXMgPSBjcnlwdG8ucHNldWRvUmFuZG9tQnl0ZXMobnVtQnl0ZXMpO1xuICAgIH1cbiAgICBjb25zdCByZXN1bHQgPSBieXRlcy50b1N0cmluZygnaGV4Jyk7XG4gICAgLy8gSWYgdGhlIG51bWJlciBvZiBkaWdpdHMgaXMgb2RkLCB3ZSdsbCBoYXZlIGdlbmVyYXRlZCBhbiBleHRyYSA0IGJpdHNcbiAgICAvLyBvZiByYW5kb21uZXNzLCBzbyB3ZSBuZWVkIHRvIHRyaW0gdGhlIGxhc3QgZGlnaXQuXG4gICAgcmV0dXJuIHJlc3VsdC5zdWJzdHJpbmcoMCwgZGlnaXRzKTtcbiAgfVxufVxuIiwiaW1wb3J0IEFsZWFSYW5kb21HZW5lcmF0b3IgZnJvbSAnLi9BbGVhUmFuZG9tR2VuZXJhdG9yJztcblxuLy8gaW5zdGFudGlhdGUgUk5HLiAgSGV1cmlzdGljYWxseSBjb2xsZWN0IGVudHJvcHkgZnJvbSB2YXJpb3VzIHNvdXJjZXMgd2hlbiBhXG4vLyBjcnlwdG9ncmFwaGljIFBSTkcgaXNuJ3QgYXZhaWxhYmxlLlxuXG4vLyBjbGllbnQgc291cmNlc1xuY29uc3QgaGVpZ2h0ID0gKHR5cGVvZiB3aW5kb3cgIT09ICd1bmRlZmluZWQnICYmIHdpbmRvdy5pbm5lckhlaWdodCkgfHxcbiAgICAgICh0eXBlb2YgZG9jdW1lbnQgIT09ICd1bmRlZmluZWQnXG4gICAgICAgJiYgZG9jdW1lbnQuZG9jdW1lbnRFbGVtZW50XG4gICAgICAgJiYgZG9jdW1lbnQuZG9jdW1lbnRFbGVtZW50LmNsaWVudEhlaWdodCkgfHxcbiAgICAgICh0eXBlb2YgZG9jdW1lbnQgIT09ICd1bmRlZmluZWQnXG4gICAgICAgJiYgZG9jdW1lbnQuYm9keVxuICAgICAgICYmIGRvY3VtZW50LmJvZHkuY2xpZW50SGVpZ2h0KSB8fFxuICAgICAgMTtcblxuY29uc3Qgd2lkdGggPSAodHlwZW9mIHdpbmRvdyAhPT0gJ3VuZGVmaW5lZCcgJiYgd2luZG93LmlubmVyV2lkdGgpIHx8XG4gICAgICAodHlwZW9mIGRvY3VtZW50ICE9PSAndW5kZWZpbmVkJ1xuICAgICAgICYmIGRvY3VtZW50LmRvY3VtZW50RWxlbWVudFxuICAgICAgICYmIGRvY3VtZW50LmRvY3VtZW50RWxlbWVudC5jbGllbnRXaWR0aCkgfHxcbiAgICAgICh0eXBlb2YgZG9jdW1lbnQgIT09ICd1bmRlZmluZWQnXG4gICAgICAgJiYgZG9jdW1lbnQuYm9keVxuICAgICAgICYmIGRvY3VtZW50LmJvZHkuY2xpZW50V2lkdGgpIHx8XG4gICAgICAxO1xuXG5jb25zdCBhZ2VudCA9ICh0eXBlb2YgbmF2aWdhdG9yICE9PSAndW5kZWZpbmVkJyAmJiBuYXZpZ2F0b3IudXNlckFnZW50KSB8fCAnJztcblxuZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24gY3JlYXRlQWxlYUdlbmVyYXRvcigpIHtcbiAgcmV0dXJuIG5ldyBBbGVhUmFuZG9tR2VuZXJhdG9yKHtcbiAgICBzZWVkczogW25ldyBEYXRlLCBoZWlnaHQsIHdpZHRoLCBhZ2VudCwgTWF0aC5yYW5kb20oKV0sXG4gIH0pO1xufVxuIiwiaW1wb3J0IEFsZWFSYW5kb21HZW5lcmF0b3IgZnJvbSAnLi9BbGVhUmFuZG9tR2VuZXJhdG9yJ1xuaW1wb3J0IGNyZWF0ZUFsZWFHZW5lcmF0b3JXaXRoR2VuZXJhdGVkU2VlZCBmcm9tICcuL2NyZWF0ZUFsZWFHZW5lcmF0b3InO1xuXG5leHBvcnQgZGVmYXVsdCBmdW5jdGlvbiBjcmVhdGVSYW5kb20oZ2VuZXJhdG9yKSB7XG4gIC8vIENyZWF0ZSBhIG5vbi1jcnlwdG9ncmFwaGljYWxseSBzZWN1cmUgUFJORyB3aXRoIGEgZ2l2ZW4gc2VlZCAodXNpbmdcbiAgLy8gdGhlIEFsZWEgYWxnb3JpdGhtKVxuICBnZW5lcmF0b3IuY3JlYXRlV2l0aFNlZWRzID0gKC4uLnNlZWRzKSA9PiB7XG4gICAgaWYgKHNlZWRzLmxlbmd0aCA9PT0gMCkge1xuICAgICAgdGhyb3cgbmV3IEVycm9yKCdObyBzZWVkcyB3ZXJlIHByb3ZpZGVkJyk7XG4gICAgfVxuICAgIHJldHVybiBuZXcgQWxlYVJhbmRvbUdlbmVyYXRvcih7IHNlZWRzIH0pO1xuICB9O1xuXG4gIC8vIFVzZWQgbGlrZSBgUmFuZG9tYCwgYnV0IG11Y2ggZmFzdGVyIGFuZCBub3QgY3J5cHRvZ3JhcGhpY2FsbHlcbiAgLy8gc2VjdXJlXG4gIGdlbmVyYXRvci5pbnNlY3VyZSA9IGNyZWF0ZUFsZWFHZW5lcmF0b3JXaXRoR2VuZXJhdGVkU2VlZCgpO1xuXG4gIHJldHVybiBnZW5lcmF0b3I7XG59XG4iXX0=
