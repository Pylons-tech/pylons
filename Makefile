all: install

install: go.sum
    GO111MODULE=on go install -tags "$(build_tags)" ./cmd/pylonsd
    GO111MODULE=on go install -tags "$(build_tags)" ./cmd/pylonscli

go.sum: go.mod
    GO111MODULE=on go mod verify