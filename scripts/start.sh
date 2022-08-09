#! /bin/bash
source ./state_sync_vars.sh
source ./peers.sh
echo "trust_height: $BLOCK_HEIGHT"
echo "trust_hash: $TRUST_HASH"
echo "rpc servers: $PYLONSD_STATESYNC_RPC_SERVERS"
echo "peers: $PYLONSD_P2P_PEERS"
exec pylonsd start
