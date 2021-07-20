#!/usr/bin/env bash

COSMOS_VERSION=$(go list -m github.com/cosmos/cosmos-sdk | sed 's:.* ::')
TEMPDIR="github.com/Pylons-tech/pylons/"
GOPATH=$(go env GOPATH)

PROTO_DIRS=$(find ./proto -path -prune -o -name '*.proto')
for dir in $PROTO_DIRS; do
  protoc \
    -I ./proto \
    -I ${GOPATH}/pkg/mod/github.com/cosmos/cosmos-sdk@${COSMOS_VERSION}/proto \
    -I ${GOPATH}/pkg/mod/github.com/cosmos/cosmos-sdk@${COSMOS_VERSION}/third_party/proto \
    --gocosmos_out=plugins=interfacetype+grpc,Mgoogle/protobuf/any.proto=github.com/cosmos/cosmos-sdk/codec/types:. \
    ${dir}

  protoc \
    -I ./proto \
    -I ${GOPATH}/pkg/mod/github.com/cosmos/cosmos-sdk@${COSMOS_VERSION}/proto \
    -I ${GOPATH}/pkg/mod/github.com/cosmos/cosmos-sdk@${COSMOS_VERSION}/third_party/proto \
    --js_out=import_style=commonjs,binary:gen \
    ${dir}
done

$(cp -R ${TEMPDIR}x/* ./x)
$(rm -r ./github.com)
