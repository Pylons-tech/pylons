#!/usr/bin/env bash

# Add the seeds to the fullnode to work.
seedinfo="$(curl -s validator:26657/status |jq -r '.result.node_info.id')@validator:26656"

pylonsd start \
  --home=$HOME/.pylonsd \
  --p2p.seeds $seedinfo
  --p2p.persistent_peers $seedinfo
