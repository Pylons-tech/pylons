#!/usr/bin/make -f


###############################################################################
###                               Build                                     ###
###############################################################################

build:
	starport chain build --verbose

.PHONY: build

###############################################################################
###                               Commands                                  ###
###############################################################################



###############################################################################
###                                Testing                                  ###
###############################################################################

test:
	go test -v ./x/... ${ARGS}

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