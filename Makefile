#!/usr/bin/make -f

BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
COMMIT := $(shell git log -1 --format='%H')

# don't override user values
ifeq (,$(VERSION))
	VERSION := $(shell git describe --exact-match 2>/dev/null)
	# if version is empty, populate it with branch's name and raw commit hash
	ifeq (,$(VERSION))
		VERSION := $(BRANCH)-$(COMMIT)
	endif
endif

# ./build
BUILD_DIR ?= $(CURDIR)/build
NAME := pylons
APP_NAME := pylonsd
# grab everything after the space in "github.com/tendermint/tendermint v0.34.7"
TM_VERSION := $(shell go list -m github.com/tendermint/tendermint | sed 's:.* ::')

export GO111MODULE = on

ldflags = -X github.com/cosmos/cosmos-sdk/version.Name=$(NAME) \
	-X github.com/cosmos/cosmos-sdk/version.AppName=$(APP_NAME) \
	-X github.com/cosmos/cosmos-sdk/version.Version=$(VERSION) \
	-X github.com/cosmos/cosmos-sdk/version.Commit=$(COMMIT) \
	-X github.com/cosmos/cosmos-sdk/version.TMCoreSemVer=$(TM_VERSION)

# add any user defined link flags
ldflags += $(LDFLAGS)
ldflags := $(strip $(ldflags))

BUILD_FLAGS := -tags "$(build_tags)" -ldflags "$(ldflags)"

all: install

install: go.sum
	@echo Installing pylonsd...
	go install $(BUILD_FLAGS) ./cmd/$(APP_NAME)

build-binary: go.sum $(BUILD_DIR)/
	go build $(BUILD_FLAGS) -o $(BUILD_DIR)/$(APP_NAME) ./cmd/$(APP_NAME)

$(BUILD_DIR)/:
	@mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)/*

go.sum: go.mod
	@go mod verify
	@go mod tidy

.PHONY: build-binary clean install

###############################################################################
###                               Commands                                  ###
###############################################################################

init_accounts:
	@bash ./init_accounts.sh

proto-gen:
	@bash ./scripts/protoc_gen.sh

reset_chain:
	@echo Resetting chain...
	@$(APP_NAME) unsafe-reset-all

.PHONY: init_accounts proto-gen reset_chain

###############################################################################
###                                Testing                                  ###
###############################################################################

test-all: int_tests fixture_tests unit_tests fixture_unit_tests

int_tests:
	@rm ./cmd/test/nonce.json || true
	go test -v ./cmd/test/ ${ARGS}

fixture_tests:
	@rm ./cmd/fixtures_test/nonce.json || true
	go test -v ./cmd/fixtures_test/ ${ARGS}

unit_tests:
	go test -v ./x/... ${ARGS}

fixture_unit_tests:
	go test -v ./test/fixtures_test/ ${ARGS}

.PHONY: int_tests fixture_tests unit_tests fixture_unit_tests

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
