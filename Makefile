SHELL := /bin/bash

all: install

install: go.sum
	GO111MODULE=on go install -tags "$(build_tags)" ./cmd/pylonsd
	GO111MODULE=on go install -tags "$(build_tags)" ./cmd/pylonscli

go.sum: go.mod
	GO111MODULE=on go mod verify

init_accounts:
	pylonscli keys add michael <<< 11111111
	pylonscli keys add iain <<< 11111111
	pylonscli keys add afti <<< 11111111
	pylonscli keys add girish <<< 11111111
	pylonscli keys add eugen <<< 11111111
	ACCOUNT=$(shell pylonscli keys show michael -a); pylonsd add-genesis-account $$ACCOUNT 10000000pylon,10000000michaelcoin
	ACCOUNT=$(shell pylonscli keys show iain -a); pylonsd add-genesis-account $$ACCOUNT 10000000pylon,10000000iaincoin
	ACCOUNT=$(shell pylonscli keys show afti -a); pylonsd add-genesis-account $$ACCOUNT 10000000pylon,10000000afticoin
	ACCOUNT=$(shell pylonscli keys show girish -a); pylonsd add-genesis-account $$ACCOUNT 10000000pylon,10000000girishcoin
	ACCOUNT=$(shell pylonscli keys show eugen -a); pylonsd add-genesis-account $$ACCOUNT 10000000pylon,10000000eugencoin

int_tests:
	rm ./cmd/test/nonce.json || true
	go test -v ./cmd/test/

fixture_tests:
	rm ./cmd/fixtures_test/nonce.json || true
	go test -v ./cmd/fixtures_test/

unit_tests:
	go test -v ./x/...
