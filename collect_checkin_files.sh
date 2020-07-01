#!/bin/sh
​
pylonsd testnet --v 3 --output-dir ./build --starting-ip-address 192.168.10.2 --keyring-backend=test
​
cp ./build/node0/pylonsd/config/pylonsd.toml ./production_config
cp ./build/node0/pylonsd/config/config.toml ./production_config
cp ./build/node0/pylonsd/config/genesis.json ./production_config
​
# check if copied correctly
head ./production_config/pylonsd.toml
echo '-----'
head ./production_config/config.toml
echo '-----'
head ./production_config/genesis.json
echo '-----'
​
# upload secrets to kubernetes secrets
​
# ./build/node0/pylonsd/config/node_key.json
# ./build/node0/pylonsd/config/priv_validator_key.json
​
# ./build/node1/pylonsd/config/node_key.json
# ./build/node1/pylonsd/config/priv_validator_key.json
​
# ./build/node2/pylonsd/config/node_key.json
# ./build/node2/pylonsd/config/priv_validator_key.json