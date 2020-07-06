#!/bin/sh

# echo '-------config_secrets-----'
# cd /root/.pylonsd/config_secrets
# ls
# echo '-------'
# find . | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/"

# yes | cp -rf /root/.pylonsd/config_secrets/app.toml /root/.pylonsd/config
# yes | cp -rf /root/.pylonsd/config_secrets/priv_validator_key.json /root/.pylonsd/config
# yes | cp -rf /root/.pylonsd/config_secrets/node_key.json /root/.pylonsd/config
# yes | cp -rf /root/.pylonsd/config_secrets/genesis.json /root/.pylonsd/config
# yes | cp -rf /root/.pylonsd/config_secrets/config.toml /root/.pylonsd/config

echo '-------config-----'
cd /root/.pylonsd/config
ls
echo '-------'
find . | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/"

cat /root/.pylonsd/config/genesis.json