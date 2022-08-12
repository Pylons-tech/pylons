const v = require('../../index.js').sync.user(process.argv[2]);
console.log(`${v && v.name} ${v && v.uid}`);
