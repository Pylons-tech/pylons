#!/bin/sh

# node0 = cosmos13p8890funv54hflk82ju0zv47tspglpk373453
pylonsd keys add node0 --keyring-backend=test --home=$HOME/.pylonsd --recover <<< "cat indoor zoo vivid actress steak female fat shrug payment harvest sadness hazard frown alcohol mountain erode latin symbol peace repair inspire blade supply"
pylonsd keys add michael --keyring-backend=test --home=$HOME/.pylonsd --recover <<< "primary push only kiwi elephant give nut roast nature fury jaguar certain distance endorse earn reform fatal edge mother submit team neither gaze whip"
pylonsd keys add eugen --keyring-backend=test --home=$HOME/.pylonsd --recover <<< "shiver pencil sauce original thank real stick armed inform cradle very elder drink planet scheme assault test science kite better chronic visa village order"

echo "waiting for block height 1 ..."
sleep 6

pylonsd tx pylons send $(pylonsd keys show -a michael --keyring-backend=test --home=$HOME/.pylonsd) 500000pylon,10000node0token,10000stake --from=node0 --keyring-backend=test --node tcp://192.168.10.2:26657 <<< y
echo "finished michael account initialization tx sending; waiting 6 seconds..."
sleep 6
pylonsd query account cosmos13p8890funv54hflk82ju0zv47tspglpk373453 --node tcp://192.168.10.2:26657
pylonsd query account $(pylonsd keys show -a michael --keyring-backend=test --home=$HOME/.pylonsd) --node tcp://192.168.10.2:26657

pylonsd tx pylons send $(pylonsd keys show -a eugen --keyring-backend=test --home=$HOME/.pylonsd) 500000pylon,10000node0token,10000stake --from=node0 --keyring-backend=test --node tcp://192.168.10.2:26657 <<< y
echo "finished eugen account initialization tx sending; waiting 6 seconds..."
sleep 6

pylonsd query account cosmos13p8890funv54hflk82ju0zv47tspglpk373453 --node tcp://192.168.10.2:26657
pylonsd query account $(pylonsd keys show -a michael --keyring-backend=test --home=$HOME/.pylonsd) --node tcp://192.168.10.2:26657
pylonsd query account $(pylonsd keys show -a eugen --keyring-backend=test --home=$HOME/.pylonsd) --node tcp://192.168.10.2:26657


# sleep 1000;
