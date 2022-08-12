# @vlasky/whomst

@vlasky/whomst is an updated fork of [whomst](https://github.com/stuartpb/whomst). It provides missing Node.js functionality to retrieve UNIX user and group info.

![whomst](https://user-images.githubusercontent.com/572196/42921299-331bb322-8ad0-11e8-8cc2-b0713b1871fe.jpg)

## Background

Node doesn't have a built-in function to resolve an OS username or groupname to a UID or GID (or vice versa). There are a few native modules that expose the functions necessary to get this information, but native modules can't always be relied upon (in environments where the toolchain isn't present, or the architecture isn't supported, or the targeted ABI is unmaintained, or any of a number of other possible ways native modules can break).

There are other ways to get this information, but they've all got possible pitfalls themselves. You can query the system database with the `getent` binary, but that will fail if `getent` isn't present. You can try reading the contents of `/etc/passwd`, but that will fail if the current user doesn't have permission to access `/etc/passwd` (or if user IDs are coming from a different source, such as LDAP). You can exploit the locations in Node's code where it calls out to the relevant functions as a side effect (namely `process.setuid` and `os.userInfo`, which both incorporate `getpwnam` under the hood), but this requires the user to have permission to setuid to the user being queried, not to mention being *incredibly* hacky. (Nonetheless, this last technique is the approach [actually used internally by npm][uid-number].)

[uid-number]: https://github.com/npm/uid-number

For a program to truly be resilient against all these possible contingencies, it should be ready to try *all* of the possible techniques.

## Implementation

whomst will try obtaining info, in order of availability, from:

- the `getpwnam`and `getgrnam` functions from the [posix][] module
- the functions from the [userid][] module (if installed)
- the `getent(1)` binary
- the contents of `/etc/passwd` and `/etc/group`
- the results of doing a `setuid` or `setgid` with the given name (as used by   the [uid-number][] module)
- as a last-ditch effort, seeing if the uid matches the current user's info

[posix]: https://github.com/ohmu/node-posix
[userid]: https://github.com/jandre/node-userid

As of v0.1.2, not all of these code paths have been tested (though they are all believed to be implemented).

## API

`whomst.user` and`whomst.group` take a number or string and return a promise. `whomst.sync.user` and `whomst.sync.group` do the same thing, but synchronously instead of via promises.

These functions return objects compatible with the return values of the corresponding functions from the `posix` package. See the documentation for [posix.getpwnam][] and [posix.getgrnam][] for examples of returns from whomst.user and whomst.group, respectively.

[posix.getpwnam]: https://github.com/ohmu/node-posix#posixgetpwnamuser
[posix.getgrnam]: https://github.com/ohmu/node-posix#posixgetgrnamgroup

Note that not all fields are guaranteed: if `whomst.group` has to fall back to the `setgid` hack method for determining a group's gid, the return value may only contain `name` and `gid` (or even only `gid`, if the name wasn't provided). This means that *you may not be able to determine a group's name from its gid*, if all the more-reliable mechanisms fail.

## Tips

Unlike some similar modules like `uid-number`, `whomst` does not cache any results between calls (as these results could, in theory, change between two separate invocations). If you wish to cache results between calls to this function (say, if you're going to make thousands of calls to it in the space of a very short time), you may wish to implement a memoization layer like [fast-memoize][] around `whomst`.

[fast-memoize]: https://www.npmjs.com/package/fast-memoize
