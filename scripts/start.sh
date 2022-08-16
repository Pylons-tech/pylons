#! /bin/bash
source ./state_sync_vars.sh
source ./peers.sh
echo "trust_height: $BLOCK_HEIGHT"
echo "trust_hash: $TRUST_HASH"
echo "rpc servers: $PYLONSD_STATESYNC_RPC_SERVERS"
echo "peers: $PYLONSD_P2P_PERSISTENT_PEERS"

# enable rest server and swagger
toml set --toml-path $HOME/.pylons/config/app.toml api.swagger true
toml set --toml-path $HOME/.pylons/config/app.toml api.enable true

# explicitly set rpc to 0.0.0.0 so that docker expose port would work
exec pylonsd start --rpc.laddr tcp://0.0.0.0:26657 --trace-store /tmp/trace/trace.fifo
