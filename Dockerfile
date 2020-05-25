# Dockerfile References: https://docs.docker.com/engine/reference/builder/

# Start from the latest golang base image
FROM golang:latest as build

# Add Maintainer Info
LABEL maintainer="Michael Sofaer <m@pylons.tech>"

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY app ./app
COPY cmd ./cmd
COPY x ./x
COPY go.mod .
COPY go.sum .

# Install the daemon
RUN go install ./cmd/pylonsd

# Install the cli
RUN go install ./cmd/pylonscli

# Basic installation for daemon and cli
RUN pylonscli config chain-id pylonschain
RUN pylonscli config output json
RUN pylonscli config indent true
RUN pylonscli config trust-node true

COPY Makefile .
RUN make unit_tests

# Final image
FROM golang:latest as pylonsd

WORKDIR /root
COPY --from=build /go/bin/pylonsd /usr/bin/pylonsd
COPY --from=build /go/bin/pylonscli /usr/bin/pylonscli
COPY --from=build /root/.plncli /root/.plncli
RUN pylonsd init masternode --chain-id pylonschain
CMD /usr/bin/pylonsd start --rpc.laddr tcp://0.0.0.0:26657

#Test server
FROM pylonsd as test_server

# COPY Makefile .
# COPY init_accounts.sh .
# RUN chmod +x init_accounts.sh
# RUN make init_accounts
RUN sed -i 's/timeout_commit = "5s"/timeout_commit = "2s"/g' ~/.pylonsd/config/config.toml
CMD /usr/bin/pylonsd start --rpc.laddr tcp://0.0.0.0:26657 --log_level main:info

#Run the tests
FROM build as integration_test
COPY Makefile .
COPY init_accounts.sh .
RUN chmod +x init_accounts.sh
# RUN make init_accounts
# COPY --from=test_server /root/.plncli/keyring-test-cosmos/ /root/.plncli/keyring-test-cosmos
CMD sleep 5 && make init_accounts && GO111MODULE=on make int_tests ARGS="--node=tcp://192.168.10.2:26657,tcp://192.168.10.3:26657,tcp://192.168.10.4:26657"

FROM build as fixture_test
COPY Makefile .
COPY init_accounts.sh .
RUN chmod +x init_accounts.sh
CMD sleep 5 && make init_accounts && GO111MODULE=on make fixture_tests ARGS="-runserial --node=tcp://192.168.10.2:26657"
