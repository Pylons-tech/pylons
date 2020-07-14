#!/bin/sh

rm -rf ~/.pylonsd
rm -rf ~/.pylonscli

pylonsd init masternode --chain-id pylonschain
pylonscli config chain-id pylonschain
pylonscli config output json
pylonscli config indent true
pylonscli config trust-node true

pylonscli keys add node0 --keyring-backend=test --recover <<< "cat indoor zoo vivid actress steak female fat shrug payment harvest sadness hazard frown alcohol mountain erode latin symbol peace repair inspire blade supply"
pylonscli keys add michael --keyring-backend=test --recover <<< "primary push only kiwi elephant give nut roast nature fury jaguar certain distance endorse earn reform fatal edge mother submit team neither gaze whip"
pylonscli keys add eugen --keyring-backend=test --recover <<< "shiver pencil sauce original thank real stick armed inform cradle very elder drink planet scheme assault test science kite better chronic visa village order"
pylonscli keys add jose --keyring-backend=test --recover <<< "rib voyage drop call choose frame seven misery reform settle myth shoot skirt night discover critic search thank dolphin couple suspect feed soul patient"

pylonsd add-genesis-account cosmos105wr8t6y97rwv90xzhxd4juj4lsajtjaass6h7 10000000000pylon # Pylons LLC validator
pylonsd add-genesis-account $(pylonscli keys show node0 -a --keyring-backend=test) 10000000000pylon,1000000000node0token,1000000000stake,10000000loudcoin
pylonsd add-genesis-account $(pylonscli keys show michael -a --keyring-backend=test) 10000000000pylon,1000000000node0token,1000000000stake,10000000loudcoin
pylonsd add-genesis-account $(pylonscli keys show eugen -a --keyring-backend=test) 10000000000pylon,1000000000node0token,1000000000stake,10000000loudcoin
pylonsd add-genesis-account $(pylonscli keys show jose -a --keyring-backend=test) 10000000000pylon,1000000000node0token,1000000000stake,10000000loudcoin

pylonsd gentx --name node0 --keyring-backend=test
pylonsd collect-gentxs