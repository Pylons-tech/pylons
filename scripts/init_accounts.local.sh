#!/usr/bin/env bash
#rm -rf $HOME/.pylonsd
#pylonsd init masternode --chain-id=pylonschain --home=$HOME/.pylonsd
#pylonsd keys add node0 --keyring-backend=test  --home=$HOME/.pylonsd --recover <<< "cat indoor zoo vivid actress steak female fat shrug payment harvest sadness hazard frown alcohol mountain erode latin symbol peace repair inspire blade supply"
#pylonsd keys add michael --keyring-backend=test  --home=$HOME/.pylonsd --recover <<< "primary push only kiwi elephant give nut roast nature fury jaguar certain distance endorse earn reform fatal edge mother submit team neither gaze whip"
#pylonsd keys add eugen --keyring-backend=test --home=$HOME/.pylonsd --recover <<< "shiver pencil sauce original thank real stick armed inform cradle very elder drink planet scheme assault test science kite better chronic visa village order"
#pylonsd add-genesis-account cosmos105wr8t6y97rwv90xzhxd4juj4lsajtjaass6h7 10000000000pylon # Pylons LLC validator
#pylonsd add-genesis-account $(pylonsd keys show node0 -a --keyring-backend=test --home=$HOME/.pylonsd) 10000000000pylon,1000000000node0token,1000000000stake,10000000loudcoin
#pylonsd add-genesis-account $(pylonsd keys show michael -a --keyring-backend=test --home=$HOME/.pylonsd) 10000000000pylon,1000000000node0token,1000000000stake,10000000loudcoin
#pylonsd add-genesis-account $(pylonsd keys show eugen -a --keyring-backend=test --home=$HOME/.pylonsd) 10000000000pylon,1000000000node0token,1000000000stake,10000000loudcoin
#pylonsd gentx node0 500000000stake --keyring-backend=test --chain-id=pylonschain --home=$HOME/.pylonsd
#pylonsd collect-gentxs  --home=$HOME/.pylonsd

# sed command for osx
#sed -i '' 's/enable = false/enable = true/g' $HOME/.pylonsd/config/app.toml
#sed -i '' 's/swagger = false/swagger = true/g' $HOME/.pylonsd/config/app.toml
# # sed command for ubuntu
#sed -i 's/enable = false/enable = true/g' $HOME/.pylonsd/config/app.toml
#sed -i 's/swagger = false/swagger = true/g' $HOME/.pylonsd/config/app.toml
pylonsd start --home=$HOME/.pylonsd