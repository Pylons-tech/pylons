set -o xtrace
set -e
# Get "trust_hash" and "trust_height".
INTERVAL=1000
LATEST_HEIGHT=$(curl -s https://rpc-pylons-ia.notional.ventures/status | jq -r .result.sync_info.latest_block_height)
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
