#!/bin/sh

rm -rf ~/.pylonsd
rm -rf ~/.pylonscli

pylonsd init masternode --chain-id pylonschain
pylonscli config chain-id pylonschain
pylonscli config output json
pylonscli config indent true
pylonscli config trust-node true

pylonscli keys add node0 --keyring-backend=test --recover <<< "cat indoor zoo vivid actress steak female fat shrug payment harvest sadness hazard frown alcohol mountain erode latin symbol peace repair inspire blade supply"
pylonscli keys add michael --keyring-backend=test
pylonscli keys add eugen --keyring-backend=test

pylonsd add-genesis-account $(pylonscli keys show node0 -a --keyring-backend=test) 10000000000pylon,1000000000node0token,1000000000stake,10000000loudcoin
pylonsd add-genesis-account $(pylonscli keys show michael -a --keyring-backend=test) 10000000000pylon,1000000000node0token,1000000000stake,10000000loudcoin
pylonsd add-genesis-account $(pylonscli keys show eugen -a --keyring-backend=test) 10000000000pylon,1000000000node0token,1000000000stake,10000000loudcoin

pylonsd gentx --name node0 --keyring-backend=test
pylonsd collect-gentxs