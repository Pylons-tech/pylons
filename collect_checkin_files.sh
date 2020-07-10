#!/bin/sh
echo "pylonsd testnet --v 3 --output-dir ./build --keyring-backend=test --starting-ip-address $1 --node-ip-addresses $2"

pylonsd testnet --v 3 --output-dir ./build --keyring-backend=test \
    --starting-ip-address $1 \
    --node-ip-addresses $2

# public configurations
cp ./build/node0/pylonsd/config/config.toml /root/production_config
echo '----config.toml-----'
head /root/production_config/config.toml

cp ./build/node0/pylonsd/config/genesis.json /root/production_config
echo '----genesis.json----'
head /root/production_config/genesis.json
​
# copy secrets
yes | cp -rf ./build/node0 /root/production_config/node0
yes | cp -rf ./build/node1 /root/production_config/node1
yes | cp -rf ./build/node2 /root/production_config/node2
​
echo '-------config tree-----'
cd /root/production_config
ls
echo '-------'
find . | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/"