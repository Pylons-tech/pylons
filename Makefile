#!/usr/bin/make -f

###############################################################################
###                               Build                                     ###
###############################################################################

PACKAGES=$(shell go list ./... | grep -v '/simulation')

VERSION := $(shell echo $(shell git describe --tags) | sed 's/^v//')
COMMIT := $(shell git log -1 --format='%H')

ldflags = -X github.com/cosmos/cosmos-sdk/version.Name=pylons \
	-X github.com/cosmos/cosmos-sdk/version.ServerName=pylonsd \
	-X github.com/cosmos/cosmos-sdk/version.Version=$(VERSION) \
	-X github.com/cosmos/cosmos-sdk/version.Commit=$(COMMIT)

BUILD_FLAGS := -ldflags '$(ldflags)'

all: install

install: go.sum
	@echo "--> Installing pylonsd"
	@go install -mod=readonly $(BUILD_FLAGS) ./cmd/pylonsd

go.sum: go.mod
	@echo "--> Ensure dependencies have not been modified"
	GO111MODULE=on go mod verify

.PHONY: install, go.sum

###############################################################################
###                               Commands                                  ###
###############################################################################

run:
	starport chain serve --verbose

.PHONY: run

###############################################################################
###                                Testing                                  ###
###############################################################################

test:
	@go test -mod=readonly -v $(PACKAGES)

.PHONY: test

###############################################################################
###                                Linting                                  ###
###############################################################################

lint:
	@golangci-lint run -c ./.golangci.yml --out-format=tab --issues-exit-code=0

FIND_ARGS := -name '*.go' -type f -not -path "./sample_txs*" -not -path "*.git*" -not -path "./build_report/*" -not -path "./scripts*" -not -name '*.pb.go'

format:
	@find . $(FIND_ARGS) | xargs gofmt -w -s
	@find . $(FIND_ARGS) | xargs goimports -w -local github.com/Pylons-tech/pylons

.PHONY: lint format