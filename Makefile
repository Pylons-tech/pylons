SHELL := /bin/bash

all: install

install: go.sum
	GO111MODULE=on go install -tags "$(build_tags)" ./cmd/pylonsd
	GO111MODULE=on go install -tags "$(build_tags)" ./cmd/pylonscli

build-binary: go.sum
	GO111MODULE=on go build -tags "$(build_tags)" -o build/pylonsd ./cmd/pylonsd
	GO111MODULE=on go build -tags "$(build_tags)" -o build/pylonscli ./cmd/pylonscli

go.sum: go.mod
	GO111MODULE=on go mod verify

init_accounts:
	bash ./init_accounts.sh

reset_chain:
	pylonsd unsafe-reset-all

int_tests:
	rm ./cmd/test/nonce.json || true
	go test -v ./cmd/test/ ${ARGS}

fixture_tests:
	rm ./cmd/fixtures_test/nonce.json || true
	go test -v ./cmd/fixtures_test/ ${ARGS}

unit_tests:
	go test -v ./x/... ${ARGS}

fixture_unit_tests:
	go test -v ./test/fixtures_test/ ${ARGS}

protoc-gen:
	bash ./protoc_gen.sh