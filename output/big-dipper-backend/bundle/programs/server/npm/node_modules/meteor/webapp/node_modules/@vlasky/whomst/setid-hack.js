// inspired by the technique used by https://github.com/npm/uid-number
//
// This exploits the [built-in calls to `get{pw,gr}nam_r`][1] within Node's
// `set{u,g}id` implementation to, if we can set(g|u)id to the (user|group)
// being queried, read back what info it resolves to.
//
// [1]: https://github.com/nodejs/node/blob/cf37945b121d23c044cd04ac79cd5ab312a34cbe/src/node_process.cc#L255-L291
//
// This is a pretty ugly hack, so we avoid using it unless absolutely all else
// fails.

if (module !== require.main) {
  throw new Error("This file should not be loaded with require()");
}

if (!process.getuid || !process.getgid) {
  throw new Error("this file should not be called without uid/gid support");
}

const argv = process.argv.slice(2);
let user = argv[0] || process.getuid();
let group = argv[1] || process.getgid();

if (!isNaN(user)) user = +user;
if (!isNaN(group)) group = +group;

try {
  process.setgid(group);
  process.setuid(user);
  const info = require('os').userInfo();
  info.gid = process.getgid();

  console.log(JSON.stringify(info));
} catch (ex) {
  console.log(JSON.stringify({error:ex.message,errno:ex.errno}));
}
