#!/usr/bin/env bash

HOME_DIR=/root/.pylonsd
CONFIG_DIR=/root/.pylonsd/config
GENTX_DIR=/root/.pylonsd/gentxs


pylonsd init pylonsvalidator --chain-id=pylonschain --overwrite

pylonsd add-genesis-account $(pylonsd keys show pylonsinc     -a --keyring-backend=test) 9000000000pylon,900000000bedrock
pylonsd add-genesis-account $(pylonsd keys show tendermint    -a --keyring-backend=test) 1000000000pylon,100000000bedrock
pylonsd add-genesis-account $(pylonsd keys show $ACCOUNT -a --keyring-backend=test) 1000000000pylon,100000000bedrock

mkdir -p $GENTX_DIR

pylonsd gentx $ACCOUNT 1bedrock --offline --account-number 0 --chain-id=pylonschain --moniker="$(hostname)" --min-self-delegation 1 --commission-max-change-rate=0.01 --commission-max-rate=1.0 --commission-rate=0.07

sed -i 's/stake/bedrock/g' $CONFIG_DIR/genesis.json

pylonsd collect-gentxs

# sed command for osx


# # sed command for ubuntu
# sed -i 's/enable = false/enable = true/g' $CONFIG_DIR/app.toml
# sed -i 's/swagger = false/swagger = true/g' $CONFIG_DIR/app.toml

pylonsd start