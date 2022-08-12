const readFile = require('fs').promises.readFile;
const readFileSync = require('fs').readFileSync;
const execa = require('execa');
const execFileSync = require('child_process').execFileSync;
const userInfo = require('os').userInfo;

let posix = null;
try {
  posix = require('posix');
} catch(err) {
  try {
    // attempt to replicate posix functionality with another module
    const userid = require('userid');
    posix = {
      getpwnam: name => isNaN(name)
        ? {name: name, uid: userid.uid(name)}
        : {uid: +name, name: userid.username(+name)},
      getgrnam: name => isNaN(name)
        ? {name: name, gid: userid.gid(name)}
        : {uid: +name, name: userid.groupname(+name)}
    };
  } catch(e) {
    // will fall back
  }
}

function mapToFields(content, func) {
  return content.trim().split('\n').map(
    line => func(line.split(':')));
}

function dbifyPasswd(content) {
  return mapToFields(content, line => ({
    name: line[0],
    passwd: line[1],
    uid: +line[2],
    gid: +line[3],
    gecos: line[4],
    dir: line[5],
    shell: line[6]
  }));
}

function dbifyGroup(content) {
  return mapToFields(content, line => ({
    name: line[0],
    passwd: line[1],
    gid: +line[2],
    members: line[3].split(',')
  }));
}

function userInfoToPosixStruct(info) {
  return {
    name: info.username,
    uid: info.uid,
    gid: info.gid,
    dir: info.homedir,
    shell: info.shell
  };
}

function currentUserOrBust(name) {
  const current = userInfo();
  return (current.username == name || current.uid == name) ?
    userInfoToPosixStruct(current) : null;
}

const setidHackScript = require.resolve("./setid-hack.js");

function setidHack(uid, gid) {
  if (process.setuid && process.getuid) {
    return execa(process.execPath, [setidHackScript, uid, gid])
      .then(output => JSON.parse(output))
      .then(result=>{
        if (result.error) throw new Error(result.error);
        else return userInfoToPosixStruct(result);
      });
  } else return Promise.reject();
}

function setidHackSync(uid, gid) {
  if (process.setuid && process.getuid) {
    let result = execFileSync(process.execPath, [setidHackScript, uid, gid]);
    result = JSON.parse(result);
    if (result.error) throw new Error(result.error);
    else return userInfoToPosixStruct(result);
  } else throw null;
}

function getUser(name) {
  if (posix) {
    try {
      return Promise.resolve(posix.getpwnam(isNaN(name) ? name : +name));
    } catch(e) {
      return Promise.resolve(null);
    }
  } else {
    return execa('getent', ['passwd', name])
      .catch(e=>readFile('/etc/passwd'))
      .then(dbifyPasswd)
      .then(db=>db.find(r=>r.name == name || r.uid == name))
      .then(user=>{if (user) return user; else throw null;})
      .catch(e=>setidHack(name,''))
      .catch(e=>currentUserOrBust(name));
  }
}

function getUserSync(name) {
  if (posix) {
    try {
      return posix.getpwnam(isNaN(name) ? name : +name);
    } catch (e) {
      return null;
    }
  } else {
    let passwd;
    try {
      passwd = execFileSync('getent', ['passwd', name]);
    } catch (e) {
      try {
        passwd = readFileSync('/etc/passwd');
      } catch (e) {}
    }
    try {
      if (passwd) {
        const user = dbifyPasswd(passwd)
          .find(r=>r.name == name || r.uid == name);
        if (user) return user;
        else throw null;
      } else {
        return setidHackSync(name, '');
      }
    } catch (e) {
      return currentUserOrBust(name);
    }
  }
}

function getGroup(name) {
  if (posix) {
    try {
      return Promise.resolve(posix.getgrnam(isNaN(name) ? name : +name));
    }
    catch (e) {
      return Promise.resolve(null);
    }
  } else {
    return execa('getent', ['group', name])
      .catch(e=>readFile('/etc/group'))
      .then(dbifyGroup)
      .then(db=>db.find(r=>r.name == name || r.gid == name))
      .catch(e=>setidHack('', name)
        .then(r=>(name == r.gid ? {gid: r.gid} : {name: name, gid: r.gid}))
        .catch(e=>null))
      .then(group=>group || null);
  }
}

function getGroupSync(name) {
  if (posix) {
    try {
      return posix.getgrnam(isNaN(name) ? name : +name);
    } catch (e) {
      return null;
    }
  } else {
    let groupDb;
    try {
      groupDb = execFileSync('getent', ['group', name]);
    } catch (e) {
      try {
        groupDb = readFileSync('/etc/group');
      } catch (e) {}
    }
    try {
      if (groupDb) {
        const group = dbifyGroup(groupDb)
          .find(r=>r.name == name || r.gid == name);
        if (group) return group;
        else throw null;
      } else {
        const r = setidHackSync('', name);
        return name == r.gid ? {gid: r.gid} : {name: name, gid: r.gid};
      }
    } catch (e) {
      return null;
    }
  }
}

module.exports = {
  user: getUser,
  group: getGroup,
  sync: {
    user: getUserSync,
    group: getGroupSync
  }
};
