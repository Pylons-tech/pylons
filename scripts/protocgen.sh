#!/bin/bash

set -eo pipefail

cd proto
buf mod update
cd ..

buf generate

# move proto files to the right places
cp -r github.com/Pylons-tech/pylons/* ./
rm -rf github.com