#!/bin/zsh
arch -x86_64 flutter test --coverage
lcov --remove coverage/lcov.info  'lib/src/generated/*'  -o coverage/new_lcov.info
genhtml coverage/new_lcov.info -o coverage/html
open coverage/html/index.html
