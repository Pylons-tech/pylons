SHELL := /bin/bash

all: install

install: go.sum
	GO111MODULE=on go install -tags "$(build_tags)" ./cmd/pylonsd

build-binary: go.sum
	GO111MODULE=on go build -tags "$(build_tags)" -o build/pylonsd ./cmd/pylonsd

go.sum: go.mod
	GO111MODULE=on go mod verify

init_accounts:
	bash ./init_accounts.sh

init_accounts_local:
	bash ./init_accounts.local.sh

reset_chain:
	pylonsd unsafe-reset-all

int_tests:
	rm ./cmd/test/nonce.json || true
	go test ./cmd/test/ ${ARGS} -v

fixture_tests:
	rm ./cmd/fixtures_test/nonce.json || true
	go test ./cmd/fixtures_test/ ${ARGS} -v

unit_tests:
	go test ./x/... ${ARGS}

fixture_unit_tests:
	go test -v ./test/fixtures_test/ ${ARGS}

proto-gen:
	bash ./scripts/protoc_gen.sh

