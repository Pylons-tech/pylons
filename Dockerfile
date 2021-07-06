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
COPY test ./test
COPY go.mod .
COPY go.sum .

# Install the daemon
RUN go install ./cmd/pylonsd

COPY Makefile .
RUN make unit_tests
RUN make fixture_unit_tests

# Final image
FROM golang:latest as pylonsd

WORKDIR /root
COPY --from=build /go/bin/pylonsd /usr/bin/pylonsd
COPY --from=build /root/.pylonsd /root/.pylonsd
# RUN pylonsd init masternode --chain-id pylonschain
 
COPY scripts/init_accounts.local.sh ./

EXPOSE 1317/tcp
 
#Run the tests
FROM build as integration_test
COPY Makefile .
COPY scripts/init_accounts.local.sh .
RUN chmod +x init_accounts.local.sh 
RUN rm -rf $HOME/.pylonsd
#RUN sh ./init_accounts.local.sh
RUN pylonsd init masternode --chain-id=pylonschain --home=$HOME/.pylonsd
RUN pylonsd keys add node0 --keyring-backend=test  --home=$HOME/.pylonsd 
#--recover <<< "cat indoor zoo vivid actress steak female fat shrug payment harvest sadness hazard frown alcohol mountain erode latin symbol peace repair inspire blade supply"
RUN pylonsd keys add michael --keyring-backend=test  --home=$HOME/.pylonsd 
#--recover <<< "primary push only kiwi elephant give nut roast nature fury jaguar certain distance endorse earn reform fatal edge mother submit team neither gaze whip"
RUN pylonsd keys add eugen --keyring-backend=test --home=$HOME/.pylonsd 
#--recover <<< "shiver pencil sauce original thank real stick armed inform cradle very elder drink planet scheme assault test science kite better chronic visa village order"
RUN pylonsd add-genesis-account cosmos105wr8t6y97rwv90xzhxd4juj4lsajtjaass6h7 10000000000pylon # Pylons LLC validator
RUN pylonsd add-genesis-account $(pylonsd keys show node0 -a --keyring-backend=test --home=$HOME/.pylonsd) 10000000000pylon,1000000000node0token,1000000000stake,10000000loudcoin
RUN pylonsd add-genesis-account $(pylonsd keys show michael -a --keyring-backend=test --home=$HOME/.pylonsd) 10000000000pylon,1000000000node0token,1000000000stake,10000000loudcoin
RUN pylonsd add-genesis-account $(pylonsd keys show eugen -a --keyring-backend=test --home=$HOME/.pylonsd) 10000000000pylon,1000000000node0token,1000000000stake,10000000loudcoin
RUN pylonsd gentx node0 500000000stake --keyring-backend=test --chain-id=pylonschain --home=$HOME/.pylonsd
RUN pylonsd collect-gentxs  --home=$HOME/.pylonsd
RUN sed -i 's/enable = false/enable = true/g' $HOME/.pylonsd/config/app.toml
RUN sed -i 's/swagger = false/swagger = true/g' $HOME/.pylonsd/config/app.toml
#RUN pylonsd start --home=$HOME/.pylonsd
CMD sleep 5 && make init_accounts_local
EXPOSE 1317/tcp
#CMD sleep 5 && make init_accounts_local && GO111MODULE=on make int_tests ARGS="--node=tcp://192.168.10.2:1317,tcp://192.168.10.3:1317,tcp://192.168.10.4:1317 --timeout=30m"
