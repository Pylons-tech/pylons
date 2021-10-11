#!/usr/bin/make -f
PACKAGES=$(shell go list ./... | grep -v '/simulation')
GOBIN ?= $(GOPATH)/bin
DOCKER := $(shell which docker)
VERSION := $(shell echo $(shell git describe --tags 2> /dev/null || echo "dev-$(shell git describe --always)") | sed 's/^v//')
COMMIT := $(shell git log -1 --format='%H')
PROJECT_NAME = $(shell git remote get-url origin | xargs basename -s .git)
ARTIFACT_DIR := ./artifacts

export GO111MODULE = on

# process build tags

build_tags = netgo
ifeq ($(LEDGER_ENABLED),true)
  ifeq ($(OS),Windows_NT)
    GCCEXE = $(shell where gcc.exe 2> NUL)
    ifeq ($(GCCEXE),)
      $(error gcc.exe not installed for ledger support, please install or set LEDGER_ENABLED=false)
    else
      build_tags += ledger
    endif
  else
    UNAME_S = $(shell uname -s)
    ifeq ($(UNAME_S),OpenBSD)
      $(warning OpenBSD detected, disabling ledger support (https://github.com/cosmos/cosmos-sdk/issues/1988))
    else
      GCC = $(shell command -v gcc 2> /dev/null)
      ifeq ($(GCC),)
        $(error gcc not installed for ledger support, please install or set LEDGER_ENABLED=false)
      else
        build_tags += ledger
      endif
    endif
  endif
endif

ifeq (cleveldb,$(findstring cleveldb,$(OSMOSIS_BUILD_OPTIONS)))
  build_tags += gcc
endif
build_tags += $(BUILD_TAGS)
build_tags := $(strip $(build_tags))

whitespace :=
whitespace += $(whitespace)
comma := ,
build_tags_comma_sep := $(subst $(whitespace),$(comma),$(build_tags))

ldflags = -X github.com/cosmos/cosmos-sdk/version.Name=pylons \
	-X github.com/cosmos/cosmos-sdk/version.ServerName=pylonsd \
	-X github.com/cosmos/cosmos-sdk/version.Version=$(VERSION) \
	-X github.com/cosmos/cosmos-sdk/version.Commit=$(COMMIT) \
	-X "github.com/cosmos/cosmos-sdk/version.BuildTags=$(build_tags_comma_sep)"

ifeq (cleveldb,$(findstring cleveldb,$(OSMOSIS_BUILD_OPTIONS)))
  ldflags += -X github.com/cosmos/cosmos-sdk/types.DBBackend=cleveldb
endif
ifeq (,$(findstring nostrip,$(OSMOSIS_BUILD_OPTIONS)))
  ldflags += -w -s
endif
ldflags += $(LDFLAGS)
ldflags := $(strip $(ldflags))

BUILD_FLAGS := -tags "$(build_tags)" -ldflags '$(ldflags)'
# check for nostrip option
ifeq (,$(findstring nostrip,$(OSMOSIS_BUILD_OPTIONS)))
  BUILD_FLAGS += -trimpath
endif

# The below include contains the tools target.
include contrib/devtools/Makefile

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

build-linux: go.sum
	LEDGER_ENABLED=false GOOS=linux GOARCH=amd64 $(MAKE) build

build-reproducible: go.sum
	$(DOCKER) rm latest-build || true
	$(DOCKER) run --volume=$(CURDIR):/sources:ro \
        --env TARGET_PLATFORMS='linux/amd64 darwin/amd64 linux/arm6' \
        --env APP=pylonsd \
        --env VERSION=$(VERSION) \
        --env COMMIT=$(COMMIT) \
        --env LEDGER_ENABLED=$(LEDGER_ENABLED) \
        --name latest-build cosmossdk/rbuilder:latest
	$(DOCKER) cp -a latest-build:/home/builder/artifacts/ $(CURDIR)/

clean:
	@rm -rf $(ARTIFACT_DIR)

go.sum: go.mod
	@echo "Ensure dependencies have not been modified ..."
	@go mod verify
	@go mod tidy -go=1.17

.PHONY: install go.sum clean build build-linux build-reproducible

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

include sims.mk

test: test-unit

test-unit:
	@VERSION=$(VERSION) go test -mod=readonly -v -timeout 30m $(PACKAGES)

test-race:
	@VERSION=$(VERSION) go test -mod=readonly -v -race -timeout 30m  $(PACKAGES)

COVER_FILE := coverage.txt
COVER_HTML_FILE := cover.html

test-cover:
	@VERSION=$(VERSION) go test -mod=readonly -v -timeout 30m -coverprofile=$(COVER_FILE) -covermode=atomic $(PACKAGES)
	@go tool cover -html=$(COVER_FILE) -o $(COVER_HTML_FILE)

bench:
	@VERSION=$(VERSION) go test -mod=readonly -v -timeout 30m -bench=. $(PACKAGES)


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
