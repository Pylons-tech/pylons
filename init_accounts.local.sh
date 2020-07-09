#!/bin/sh

pylonscli config chain-id pylons
pylonscli config output json
pylonscli config indent true
pylonscli config trust-node true
pylonscli config keyring-backend test

pylonscli keys add node0 --keyring-backend=test --recover <<< "cat indoor zoo vivid actress steak female fat shrug payment harvest sadness hazard frown alcohol mountain erode latin symbol peace repair inspire blade supply"
pylonscli keys add michael --keyring-backend=test
pylonscli keys add eugen --keyring-backend=test
pylonscli keys add jose --keyring-backend=test

pylonsd add-genesis-account cosmos105wr8t6y97rwv90xzhxd4juj4lsajtjaass6h7 10000000000pylon # Pylons LLC validator
pylonsd add-genesis-account $(pylonscli keys show node0 -a --keyring-backend=test) 10000000000pylon,1000000000node0token,1000000000stake,10000000loudcoin
pylonsd add-genesis-account $(pylonscli keys show michael -a --keyring-backend=test) 10000000000pylon,1000000000node0token,1000000000stake,10000000loudcoin
pylonsd add-genesis-account $(pylonscli keys show eugen -a --keyring-backend=test) 10000000000pylon,1000000000node0token,1000000000stake,10000000loudcoin
pylonsd add-genesis-account $(pylonscli keys show jose -a --keyring-backend=test) 10000000000pylon,1000000000node0token,1000000000stake,10000000loudcoin

pylonsd gentx --name llc --pubkey=cosmosvalconspub1zcjduepqyyvyc256u35pjnrsghkjp7e678w924jwmyjmd6grlfdakrmrfr5spnstqh --keyring-backend=test
pylonsd collect-gentxs
