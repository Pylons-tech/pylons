#!/bin/sh

pylonscli config chain-id pylonschain
pylonscli config output json
pylonscli config indent true
pylonscli config trust-node true

pylonscli keys add node0 --keyring-backend=test --recover <<< "cat indoor zoo vivid actress steak female fat shrug payment harvest sadness hazard frown alcohol mountain erode latin symbol peace repair inspire blade supply"
pylonscli keys add michael --keyring-backend=test <<< y
pylonscli keys add iain --keyring-backend=test <<< y
pylonscli keys add afti --keyring-backend=test <<< y
pylonscli keys add girish --keyring-backend=test <<< y
pylonscli keys add eugen --keyring-backend=test <<< y

pylonsd add-genesis-account $(pylonscli keys show michael -a --keyring-backend=test) 10000000pylon,10000000michaelcoin,10000000node0token
pylonsd add-genesis-account $(pylonscli keys show iain -a --keyring-backend=test) 10000000pylon,10000000iaincoin,10000000node0token
pylonsd add-genesis-account $(pylonscli keys show afti -a --keyring-backend=test) 10000000pylon,10000000afticoin,10000000node0token
pylonsd add-genesis-account $(pylonscli keys show girish -a --keyring-backend=test) 10000000pylon,10000000girishcoin,10000000node0token
pylonsd add-genesis-account $(pylonscli keys show eugen -a --keyring-backend=test) 10000000pylon,10000000eugencoin,10000000node0token