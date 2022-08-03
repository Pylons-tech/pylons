#!/bin/bash

KEY="validator"
KEYRING_BACKEND="test"
CHAIN_ID="testing"

rm -rf $HOME/.pylons

pylonsd init --chain-id=$CHAIN_ID testing
pylonsd keys add $KEY --keyring-backend=$KEYRING_BACKEND 
pylonsd add-genesis-account $(pylonsd keys show $KEY -a --keyring-backend=$KEYRING_BACKEND) 1000000000upylon
sed -i -e "s/stake/upylon/g" $HOME/.pylons/config/genesis.json
pylonsd gentx $KEY 500000000upylon --commission-rate="0.05" --keyring-backend=$KEYRING_BACKEND  --chain-id=$CHAIN_ID
pylonsd collect-gentxs

cat $HOME/.pylons/config/genesis.json | jq '.initial_height="100"' > $HOME/.pylons/config/tmp_genesis.json && mv $HOME/.pylons/config/tmp_genesis.json $HOME/.pylons/config/genesis.json
cat $HOME/.pylons/config/genesis.json | jq '.app_state["gov"]["deposit_params"]["min_deposit"][0]["denom"]="upylon"' > $HOME/.pylons/config/tmp_genesis.json && mv $HOME/.pylons/config/tmp_genesis.json $HOME/.pylons/config/genesis.json
cat $HOME/.pylons/config/genesis.json | jq '.app_state["gov"]["deposit_params"]["min_deposit"][0]["amount"]="100"' > $HOME/.pylons/config/tmp_genesis.json && mv $HOME/.pylons/config/tmp_genesis.json $HOME/.pylons/config/genesis.json
cat $HOME/.pylons/config/genesis.json | jq '.app_state["gov"]["voting_params"]["voting_period"]="120s"' > $HOME/.pylons/config/tmp_genesis.json && mv $HOME/.pylons/config/tmp_genesis.json $HOME/.pylons/config/genesis.json
cat $HOME/.pylons/config/genesis.json | jq '.app_state["staking"]["params"]["bond_denom"]="upylon"' > $HOME/.pylons/config/tmp_genesis.json && mv $HOME/.pylons/config/tmp_genesis.json $HOME/.pylons/config/genesis.json
cat $HOME/.pylons/config/genesis.json | jq '.app_state["crisis"]["constant_fee"]["denom"]="upylon"' > $HOME/.pylons/config/tmp_genesis.json && mv $HOME/.pylons/config/tmp_genesis.json $HOME/.pylons/config/genesis.json
cat $HOME/.pylons/config/genesis.json | jq '.app_state["mint"]["params"]["mint_denom"]="upylon"' > $HOME/.pylons/config/tmp_genesis.json && mv $HOME/.pylons/config/tmp_genesis.json $HOME/.pylons/config/genesis.json

pylonsd start