#! /usr/bin/env bash

testdir="$(dirname "${BASH_SOURCE[0]}")"

# create a new search directory to test with commands like `getent` broken
hole="$(mktemp -d)"
export PATH="$hole:$PATH"

disable_posix () {
  if [[ -e node_modules/posix ]]; then
    mv node_modules/posix node_modules/posix~
  fi
}
disable_getent () {
  touch "$hole/getent"
  chmod -x "$hole/getent"
}

reset () {
  # reverse disable_posix
  # If there's a backed-up posix module to cleanup
  if [[ -e node_modules/posix~ ]]; then
    # if the real posix module exists (maybe it was reinstalled?)
    if [[ -e node_modules/posix ]]; then
      # delete the backed up module
      rm -rf node_modules/posix~
    # if the real posix module is missing (what we'd expect)
    else
      # move the backed-up module back to the original location
      mv node_modules/posix~ node_modules/posix
    fi
  fi

  # reverse disable_getent
  if [[ -e "$hole/getent" ]]; then
    rm "$hole/getent"
  fi
}

cleanup () {
  reset

  # clean up temporary directories
  rmdir "$hole"
}

catch () {
  echo "Error on line $1"
  cleanup
  exit 1
}

trap 'catch $LINENO' ERR

test_user () {
  [ "$(node "$testdir/bin/getUser.js" "$1")" == "$1 $2" ]
  [ "$(node "$testdir/bin/getUser.js" "$2")" == "$1 $2" ]
  [ "$(node "$testdir/bin/getUserSync.js" "$1")" == "$1 $2" ]
  [ "$(node "$testdir/bin/getUserSync.js" "$2")" == "$1 $2" ]
}

test_group () {
  [ "$(node "$testdir/bin/getGroup.js" "$1")" == "$1 $2" ]
  [ "$(node "$testdir/bin/getGroup.js" "$2")" == "$1 $2" ]
  [ "$(node "$testdir/bin/getGroupSync.js" "$1")" == "$1 $2" ]
  [ "$(node "$testdir/bin/getGroupSync.js" "$2")" == "$1 $2" ]
}

stress_test_user () {
  test_user "$@"
  disable_posix
  test_user "$@"
  disable_getent
  test_user "$@"
  reset
}

stress_test_group () {
  test_group "$@"
  disable_posix
  test_group "$@"
  disable_getent
  test_group "$@"
  reset
}

reset

getent passwd | shuf -n 5 | sed -r 's/^([^:]*):[^:]:([^:]*):.*/\1 \2/' | \
   while read name uid; do stress_test_user "$name" "$uid"; done
getent group | shuf -n 5 | sed -r 's/^([^:]*):[^:]:([^:]*):.*/\1 \2/' | \
   while read name gid; do stress_test_group "$name" "$gid"; done

cleanup
