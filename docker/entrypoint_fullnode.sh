#!/usr/bin/env bash

# Add the seeds to the fullnode to work.
seedinfo="$(curl -s validator:26657/status |jq -r '.result.node_info.id')@validator:26656"

sed -ie "s/seeds = \"\"/seeds = \"$seedinfo\"/" $HOME/.pylonsd/config/config.toml
sed -ie "s/persistent\_peers = \"\"/persistent\_peers = \"$seedinfo\"/" $HOME/.pylonsd/config/config.toml

pylonsd start --home=$HOME/.pylonsd