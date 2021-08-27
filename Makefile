#!/usr/bin/make -f
PACKAGES=$(shell go list ./... | grep -v '/simulation')
GOBIN ?= $(GOPATH)/bin
DOCKER := $(shell which docker)
VERSION := $(shell echo $(shell git describe --tags 2> /dev/null || echo "dev-$(shell git describe --always)") | sed 's/^v//')
COMMIT := $(shell git log -1 --format='%H')
PROJECT_NAME = $(shell git remote get-url origin | xargs basename -s .git)
ARTIFACT_DIR := ./artifacts

ldflags = -X github.com/cosmos/cosmos-sdk/version.Name=pylons \
	-X github.com/cosmos/cosmos-sdk/version.ServerName=pylonsd \
	-X github.com/cosmos/cosmos-sdk/version.Version=$(VERSION) \
	-X github.com/cosmos/cosmos-sdk/version.Commit=$(COMMIT)

BUILD_FLAGS := -ldflags '$(ldflags)'

###############################################################################
###                               Build                                     ###
###############################################################################

all: install lint test

install: go.sum
	@echo "--> Installing pylonsd"
	@go install -mod=readonly $(BUILD_FLAGS) ./cmd/pylonsd

build: go.sum
	@echo "--> Building pylonsd"
	@go build -o $(ARTIFACT_DIR)/pylonsd -mod=readonly $(BUILD_FLAGS) ./cmd/pylonsd

clean:
	@rm -rf $(ARTIFACT_DIR)

go.sum: go.mod
	@echo "Ensure dependencies have not been modified ..."
	@go mod verify
	@go mod tidy -go=1.17

.PHONY: install, go.sum

###############################################################################
###                               Commands                                  ###
###############################################################################

run:
	starport chain serve --verbose

.PHONY: run

proto-gen:
	starport generate proto-go
.PHONY: proto-gen

###############################################################################
###                                Genesis                                  ###
###############################################################################
.PHONY: genesis
genesis:
	go install github.com/tomwright/dasel/cmd/dasel@master
	starport chain build --release -t linux:amd64
	tar xzvf release/pylons_linux_amd64.tar.gz -C genesis/
	cd genesis && bash generate_genesis.sh

###############################################################################
###                                Testing                                  ###
###############################################################################

test: test-unit

test-unit:
	@go test -mod=readonly -v $(PACKAGES)

test-race:
	@go test -mod=readonly -v -race $(PACKAGES) 

COVERFILE := coverage.txt
COVERHTMLFILE := cover.html

test-cover:
	@go test -mod=readonly -v -timeout 30m -race -coverprofile=$(COVERFILE) -covermode=atomic $(PACKAGES)
	@go tool cover -html=$(COVERFILE) -o $(COVERHTMLFILE)

bench:
	@go test -mod=readonly -v -bench=. $(PACKAGES)


.PHONY: test test-unit test-race test-cover bench

###############################################################################
###                                Linting                                  ###
###############################################################################

markdownLintImage=tmknom/markdownlint
containerMarkdownLint=$(PROJECT_NAME)-markdownlint
containerMarkdownLintFix=$(PROJECT_NAME)-markdownlint-fix

lint:
	@golangci-lint run -c ./.golangci.yml --out-format=tab --issues-exit-code=0
	@# @if $(DOCKER) ps -a --format '{{.Names}}' | grep -Eq "^${containerMarkdownLint}$$"; then $(DOCKER) start -a $(containerMarkdownLint); else $(DOCKER) run --name $(containerMarkdownLint) -i -v "$(CURDIR):/work" $(markdownLintImage); fi


FIND_ARGS := -name '*.go' -type f -not -path "./sample_txs*" -not -path "*.git*" -not -path "./build_report/*" -not -path "./scripts*" -not -name '*.pb.go'

format:
	@find . $(FIND_ARGS) | xargs gofmt -w -s
	@find . $(FIND_ARGS) | xargs goimports -w -local github.com/Pylons-tech/pylons

proto-lint:
	@buf lint --error-format=json


.PHONY: lint format proto-lint
