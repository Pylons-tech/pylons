#!/bin/sh

pylonscli config chain-id pylons
pylonscli config output json
pylonscli config indent true
pylonscli config trust-node true
pylonscli config keyring-backend test

pylonscli keys add llc --recover <<< "cat indoor zoo vivid actress steak female fat shrug payment harvest sadness hazard frown alcohol mountain erode latin symbol peace repair inspire blade supply"
pylonsd add-genesis-account cosmos13p8890funv54hflk82ju0zv47tspglpk373453 10000000000stake # Pylons LLC validator

pylonsd gentx --name llc --pubkey=cosmosvalconspub1zcjduepqyyvyc256u35pjnrsghkjp7e678w924jwmyjmd6grlfdakrmrfr5spnstqh --keyring-backend=test
pylonsd collect-gentxs
