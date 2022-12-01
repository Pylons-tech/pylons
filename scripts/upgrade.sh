#!/bin/bash
# microtick and bitcanna contributed significantly here.
# Pebbledb state sync script.
set -uxe

# Set Golang environment variables.
export GOPATH=~/go
export PATH=$PATH:~/go/bin

# Required valiables for initialization
CHAINID = "pylons-mainnet-1"

# Install Juno with pebbledb 
#go mod edit -replace github.com/tendermint/tm-db=github.com/notional-labs/tm-db@136c7b6
#go mod tidy
#go install -ldflags '-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb' -tags pebbledb ./...

# NOTE: ABOVE YOU CAN USE ALTERNATIVE DATABASES, HERE ARE THE EXACT COMMANDS
# go install -ldflags '-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=rocksdb' -tags rocksdb ./...
# go install -ldflags '-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=badgerdb' -tags badgerdb ./...
# go install -ldflags '-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=boltdb' -tags boltdb ./...


# Updating Chain ID
pylonsd config chain-id $CHAINID

# Get Genesis
curl http://58.65.160.225:26687/genesis | jq .result.genesis > ~/.pylons/config/genesis.json

# Get "trust_hash" and "trust_height".
INTERVAL=100
LATEST_HEIGHT=$(curl -s "http://58.65.160.225:26687/block" | jq -r .result.block.header.height)
BLOCK_HEIGHT=$(($LATEST_HEIGHT-$INTERVAL)) 
TRUST_HASH=$(curl -s "http://58.65.160.225:26687/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

# Print out block and transaction hash from which to sync state.
echo "trust_height: $BLOCK_HEIGHT"
echo "trust_hash: $TRUST_HASH"

# Reduce block time
command -v toml > /dev/null 2>&1 || { echo >&2 "toml-cli not installed. More info: https://pypi.org/project/toml-cli/"; exit 1; }
toml set --toml-path $HOME/.pylons/config/config.toml consensus.timeout_commit 1.5s

# Export state sync variables.
export PYLONSD_STATESYNC_ENABLE=true
export PYLONSD_P2P_MAX_NUM_OUTBOUND_PEERS=200
export PYLONSD_STATESYNC_RPC_SERVERS="http://58.65.160.225:26687,http://58.65.160.225:26687"
export PYLONSD_STATESYNC_TRUST_HEIGHT=$BLOCK_HEIGHT
export PYLONSD_STATESYNC_TRUST_HASH=$TRUST_HASH

# Fetch and set list of seeds from chain registry.
export PYLONSD_P2P_PERSISTENT_PEERS="b5f354db4339c374c9f7b206298f32f4744fa5f9@58.65.160.225:26686"
pylonsd start --rpc.laddr tcp://0.0.0.0:26657