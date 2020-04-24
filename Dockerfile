# Dockerfile References: https://docs.docker.com/engine/reference/builder/

# Start from the latest golang base image
FROM golang:latest

# Add Maintainer Info
LABEL maintainer="Michael Sofaer <m@pylons.tech>"

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY . .

# Build the daemon
RUN go build ./cmd/pylonsd/

# Build the cli
RUN go build ./cmd/pylonscli

# Install the daemon
RUN go install ./cmd/pylonsd

# Install the cli
RUN go install ./cmd/pylonscli

# Unit test
RUN GO111MODULE=on make unit_tests

# Basic installation for daemon and cli
RUN ./pylonsd init masternode --chain-id pylonschain
RUN make init_accounts
RUN pylonscli config chain-id pylonschain
RUN pylonscli config output json
RUN pylonscli config indent true
RUN pylonscli config trust-node true

# Run daemon and do integration test
RUN ./pylonsd start > pylonsd.log & (sleep 5 && GO111MODULE=on make int_tests)

# Run fixture test
RUN ./pylonsd start > pylonsd.log & (sleep 5 && GO111MODULE=on make fixture_tests ARGS="-runserial")


# Command to run the executable
#Run please, GCB
CMD ["/app/pylonsd", "start", "--rpc.laddr", "tcp://0.0.0.0:26657"]
