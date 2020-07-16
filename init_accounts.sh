#!/bin/sh

pylonscli config chain-id pylonschain
pylonscli config output json
pylonscli config indent true
pylonscli config trust-node true

pylonscli keys add node0 --keyring-backend=test --recover <<< "cat indoor zoo vivid actress steak female fat shrug payment harvest sadness hazard frown alcohol mountain erode latin symbol peace repair inspire blade supply"
pylonscli keys add michael --keyring-backend=test --recover <<< "primary push only kiwi elephant give nut roast nature fury jaguar certain distance endorse earn reform fatal edge mother submit team neither gaze whip"
pylonscli keys add eugen --keyring-backend=test --recover <<< "shiver pencil sauce original thank real stick armed inform cradle very elder drink planet scheme assault test science kite better chronic visa village order"
pylonscli keys add jose --keyring-backend=test --recover <<< "rib voyage drop call choose frame seven misery reform settle myth shoot skirt night discover critic search thank dolphin couple suspect feed soul patient"

echo "waiting for block height 1 ..."
sleep 6

pylonscli tx send cosmos13p8890funv54hflk82ju0zv47tspglpk373453 $(pylonscli keys show -a michael --keyring-backend=test) 500000pylon,10000node0token,10000stake --keyring-backend=test --node tcp://192.168.10.2:26657 <<< y
echo "finished michael account initialization tx sending; waiting 6 seconds..."
sleep 6
pylonscli query account cosmos13p8890funv54hflk82ju0zv47tspglpk373453 --node tcp://192.168.10.2:26657
pylonscli query account $(pylonscli keys show -a michael --keyring-backend=test) --node tcp://192.168.10.2:26657

pylonscli tx send cosmos13p8890funv54hflk82ju0zv47tspglpk373453 $(pylonscli keys show -a eugen --keyring-backend=test) 500000pylon,10000node0token,10000stake --keyring-backend=test --node tcp://192.168.10.2:26657 <<< y
echo "finished eugen account initialization tx sending; waiting 6 seconds..."
sleep 6

pylonscli tx send cosmos13p8890funv54hflk82ju0zv47tspglpk373453 $(pylonscli keys show -a jose --keyring-backend=test) 500000pylon,10000node0token,10000stake --keyring-backend=test --node tcp://192.168.10.2:26657 <<< y
echo "finished jose account initialization tx sending; waiting 6 seconds..."
sleep 6

pylonscli query account cosmos13p8890funv54hflk82ju0zv47tspglpk373453 --node tcp://192.168.10.2:26657
pylonscli query account $(pylonscli keys show -a michael --keyring-backend=test) --node tcp://192.168.10.2:26657
pylonscli query account $(pylonscli keys show -a eugen --keyring-backend=test) --node tcp://192.168.10.2:26657
pylonscli query account $(pylonscli keys show -a jose --keyring-backend=test) --node tcp://192.168.10.2:26657


# sleep 1000;
