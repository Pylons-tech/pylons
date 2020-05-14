#!/bin/sh

pylonscli config chain-id pylonschain
pylonscli config output json
pylonscli config indent true
pylonscli config trust-node true

pylonscli keys add node0 --keyring-backend=test --recover <<< "cat indoor zoo vivid actress steak female fat shrug payment harvest sadness hazard frown alcohol mountain erode latin symbol peace repair inspire blade supply"
pylonscli keys add michael --keyring-backend=test
pylonscli keys add iain --keyring-backend=test
pylonscli keys add afti --keyring-backend=test
pylonscli keys add girish --keyring-backend=test
pylonscli keys add eugen --keyring-backend=test

# pylonsd unsafe-reset-all --home ./testnet/node0/pylonsd
# pylonsd unsafe-reset-all --home ./testnet/node1/pylonsd
# pylonsd unsafe-reset-all --home ./testnet/node2/pylonsd

pylonscli tx pylons send-pylons $(pylonscli keys show -a michael --keyring-backend=test) 100000 --from cosmos13p8890funv54hflk82ju0zv47tspglpk373453 --keyring-backend=test --node tcp://169.254.0.3:26657 <<< y
pylonscli tx pylons send-pylons $(pylonscli keys show -a eugen --keyring-backend=test) 100000 --from cosmos13p8890funv54hflk82ju0zv47tspglpk373453 --keyring-backend=test --node tcp://169.254.0.3:26657 <<< y
pylonscli tx pylons send-pylons $(pylonscli keys show -a iain --keyring-backend=test) 100000 --from cosmos13p8890funv54hflk82ju0zv47tspglpk373453 --keyring-backend=test --node tcp://169.254.0.3:26657 <<< y
pylonscli tx pylons send-pylons $(pylonscli keys show -a afti --keyring-backend=test) 100000 --from cosmos13p8890funv54hflk82ju0zv47tspglpk373453 --keyring-backend=test --node tcp://169.254.0.3:26657 <<< y
pylonscli tx pylons send-pylons $(pylonscli keys show -a girish --keyring-backend=test) 100000 --from cosmos13p8890funv54hflk82ju0zv47tspglpk373453 --keyring-backend=test --node tcp://169.254.0.3:26657 <<< y
pylonscli query account cosmos13p8890funv54hflk82ju0zv47tspglpk373453 --node tcp://169.254.0.3:26657
# sleep 1000;