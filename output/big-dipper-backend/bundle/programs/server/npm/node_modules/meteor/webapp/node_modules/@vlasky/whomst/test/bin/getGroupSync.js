const v = require('../../index.js').sync.group(process.argv[2]);
console.log(`${v && v.name} ${v && v.gid}`);
