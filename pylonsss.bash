#!/bin/bash
# microtick and bitcanna contributed significantly here.
# Pebbledb state sync script.
set -uxe

# Set Golang environment variables.
export GOPATH=~/go
export PATH=$PATH:~/go/bin

# Install Juno with pebbledb 
#go mod edit -replace github.com/tendermint/tm-db=github.com/notional-labs/tm-db@136c7b6
#go mod tidy
#go install -ldflags '-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb' -tags pebbledb ./...

# NOTE: ABOVE YOU CAN USE ALTERNATIVE DATABASES, HERE ARE THE EXACT COMMANDS
# go install -ldflags '-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=rocksdb' -tags rocksdb ./...
# go install -ldflags '-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=badgerdb' -tags badgerdb ./...
# go install -ldflags '-w -s -X github.com/cosmos/cosmos-sdk/types.DBBackend=boltdb' -tags boltdb ./...

# Initialize chain.
pylonsd init test --chain-id pylons-testnet-3

# Get Genesis
curl http://51.79.26.26:26657/genesis | jq .result.genesis > ~/.pylons/config/genesis.json

# Get "trust_hash" and "trust_height".
INTERVAL=1000
LATEST_HEIGHT=$(curl -s "https://rpc-pylons-ia.notional.ventures/block" | jq -r .result.block.header.height)
BLOCK_HEIGHT=$(($LATEST_HEIGHT-$INTERVAL)) 
TRUST_HASH=$(curl -s "https://rpc-pylons-ia.notional.ventures/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

# Print out block and transaction hash from which to sync state.
echo "trust_height: $BLOCK_HEIGHT"
echo "trust_hash: $TRUST_HASH"

# Export state sync variables.
export PYLONSD_STATESYNC_ENABLE=true
export PYLONSD_P2P_MAX_NUM_OUTBOUND_PEERS=200
export PYLONSD_STATESYNC_RPC_SERVERS="https://rpc-pylons-ia.notional.ventures:443,https://rpc-pylons-ia.notional.ventures:443"
export PYLONSD_STATESYNC_TRUST_HEIGHT=$BLOCK_HEIGHT
export PYLONSD_STATESYNC_TRUST_HASH=$TRUST_HASH

# Fetch and set list of seeds from chain registry.
export PYLONSD_P2P_PERSISTENT_PEERS="762470be4082ae197feb82e50f7c50bfd79a0db8@141.95.65.26:44657,2bebe6b738e849ad7355c05c4b645c381e76b774@65.108.203.219:26656"
pylonsd start 
