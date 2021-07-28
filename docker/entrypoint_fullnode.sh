#!/usr/bin/env bash

# Add the seeds to the fullnode to work.
seedinfo="$(curl -s validator:26657/status |jq -r '.result.node_info.id')@validator:26657"

sed -c -i "s/\(seeds *= *\).*/\1$seedinfo/" $HOME/.pylonsd/config/config.toml
sed -c -i "s/\(persistent_peers *= *\).*/\1$seedinfo/" $HOME/.pylonsd/config/config.toml

pylonsd start --home=$HOME/.pylonsd