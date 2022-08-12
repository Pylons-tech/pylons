require('../../index.js').group(process.argv[2])
  .then(v => console.log(`${v && v.name} ${v && v.gid}`));
