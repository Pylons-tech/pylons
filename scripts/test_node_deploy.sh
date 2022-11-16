#!/bin/bash

KEY="test"
CHAINID="pylons-testnet-1"
KEYRING="test"
MONIKER="localtestnet"
KEYALGO="secp256k1"
LOGLEVEL="info"

rm -rf ~/.pylon*
# retrieve all args
WILL_START_FRESH=0
WILL_RECOVER=0
WILL_INSTALL=0
WILL_CONTINUE=0
# $# is to check number of arguments
if [ $# -gt 0 ];
then
    # $@ is for getting list of arguments
    for arg in "$@"; do
        case $arg in
        --fresh)
            WILL_START_FRESH=1
            shift
            ;;
        --recover)
            WILL_RECOVER=1
            shift
            ;;
        --install)
            WILL_INSTALL=1
            shift
            ;;
        --continue)
            WILL_CONTINUE=1
            shift
            ;;
        *)
            printf >&2 "wrong argument somewhere"; exit 1;
            ;;
        esac
    done
fi

# continue running if everything is configured
if [ $WILL_CONTINUE -eq 1 ];
then
    # Start the node (remove the --pruning=nothing flag if historical queries are not needed)
    pylonsd start --pruning=nothing --log_level $LOGLEVEL --minimum-gas-prices=0.0001upylon
    exit 1;
fi

# validate dependencies are installed
command -v jq > /dev/null 2>&1 || { echo >&2 "jq not installed. More info: https://stedolan.github.io/jq/download/"; exit 1; }

if [ $WILL_START_FRESH -eq 1 ];
then
    rm -rf $HOME/.pylons*
fi

# install pylonsd if not exist
if [ $WILL_INSTALL -eq 0 ];
then 
    command -v pylonsd > /dev/null 2>&1 || { echo >&1 "installing pylonsd"; make install; }
else
    echo >&1 "installing pylonsd"
    rm -rf $HOME/.pylons*
    go install ./...
fi

pylonsd config keyring-backend $KEYRING
pylonsd config chain-id $CHAINID

# determine if user wants to recorver or create new
rm debug/keys.txt

if [ $WILL_RECOVER -eq 0 ];
then
    KEY_INFO=$(pylonsd keys add $KEY --keyring-backend $KEYRING --algo $KEYALGO)
    echo $KEY_INFO >> debug/keys.txt
else
    KEY_INFO=$(pylonsd keys add $KEY --keyring-backend $KEYRING --algo $KEYALGO --recover)
    echo $KEY_INFO >> debug/keys.txt
fi

echo >&1 "\n"

# init chain
pylonsd init $MONIKER --chain-id $CHAINID

# Change parameter token denominations to upylon
cat $HOME/.pylons/config/genesis.json | jq '.app_state["staking"]["params"]["bond_denom"]="upylon"' > $HOME/.pylons/config/tmp_genesis.json && mv $HOME/.pylons/config/tmp_genesis.json $HOME/.pylons/config/genesis.json
cat $HOME/.pylons/config/genesis.json | jq '.app_state["crisis"]["constant_fee"]["denom"]="upylon"' > $HOME/.pylons/config/tmp_genesis.json && mv $HOME/.pylons/config/tmp_genesis.json $HOME/.pylons/config/genesis.json
cat $HOME/.pylons/config/genesis.json | jq '.app_state["gov"]["deposit_params"]["min_deposit"][0]["denom"]="upylon"' > $HOME/.pylons/config/tmp_genesis.json && mv $HOME/.pylons/config/tmp_genesis.json $HOME/.pylons/config/genesis.json
cat $HOME/.pylons/config/genesis.json | jq '.app_state["mint"]["params"]["mint_denom"]="upylon"' > $HOME/.pylons/config/tmp_genesis.json && mv $HOME/.pylons/config/tmp_genesis.json $HOME/.pylons/config/genesis.json

# Set gas limit in genesis
# cat $HOME/.pylons/config/genesis.json | jq '.consensus_params["block"]["max_gas"]="10000000"' > $HOME/.pylons/config/tmp_genesis.json && mv $HOME/.pylons/config/tmp_genesis.json $HOME/.pylons/config/genesis.json

# enable rest server and swagger
toml set --toml-path $HOME/.pylons/config/app.toml api.swagger true
toml set --toml-path $HOME/.pylons/config/app.toml api.enable true

# Allocate genesis accounts (cosmos formatted addresses)
pylonsd add-genesis-account $KEY 1000000000000upylon --keyring-backend $KEYRING

# Sign genesis transaction
pylonsd gentx $KEY 1000000upylon --keyring-backend $KEYRING --chain-id $CHAINID

# Collect genesis tx
pylonsd collect-gentxs

# Run this to ensure everything worked and that the genesis file is setup correctly
pylonsd validate-genesis

# Start the node (remove the --pruning=nothing flag if historical queries are not needed)
pylonsd start --pruning=nothing --log_level $LOGLEVEL --minimum-gas-prices=0.0001upylon --rpc.laddr tcp://0.0.0.0:26657
