#!/usr/bin/env bash

pylonsd keys add alice --keyring-backend=test --home=$HOME/.pylonsd --recover <<< "primary push only kiwi elephant give nut roast nature fury jaguar certain distance endorse earn reform fatal edge mother submit team neither gaze whip"
pylonsd keys add bob --keyring-backend=test --home=$HOME/.pylonsd --recover <<< "shiver pencil sauce original thank real stick armed inform cradle very elder drink planet scheme assault test science kite better chronic visa village order"


sed -i 's/enable = false/enable = true/g' $HOME/.pylonsd/config/app.toml
sed -i 's/swagger = false/swagger = true/g' $HOME/.pylonsd/config/app.toml