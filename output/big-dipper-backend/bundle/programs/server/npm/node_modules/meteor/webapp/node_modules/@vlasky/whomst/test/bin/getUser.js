require('../../index.js').user(process.argv[2])
  .then(v => console.log(`${v && v.name} ${v && v.uid}`));
