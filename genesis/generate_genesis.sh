#!/usr/bin/env bash

rm -rf alpha && mkdir alpha
rm -rf beta && mkdir beta
rm -rf gamma && mkdir gamma
rm -rf ~/.pylons

ALPHA_HOME=./alpha
BETA_HOME=./beta
GAMMA_HOME=./gamma

pylonsd init alpha --chain-id=pylonschain --home $ALPHA_HOME
pylonsd init beta --chain-id=pylonschain --home $BETA_HOME
pylonsd init gamma --chain-id=pylonschain --home $GAMMA_HOME

# I am going to generate the first genesis in the default dir
pylonsd init masternode --chain-id=pylonschain

# Change the bond denom to the staking token (ubedrock)
sed -i 's/stake/ubedrock/g' $HOME/.pylons/config/genesis.json
#sed -i 's/"ed25519"/"secp256k1"/g' $HOME/.pylons/config/genesis.json

# Create all accounts
pylonsd keys add pylonsinc --keyring-backend=test  --recover <<< "achieve patch rabbit delay you stairs flag nation lady outside answer property olive man dwarf used chapter sunset bundle sniff between since review logic"
pylonsd keys add tendermint  --keyring-backend=test  --recover <<< "oil inflict cup nation circle palace cactus uphold clarify vibrant believe stem farm aerobic casino treat early amazing remain produce exhaust bachelor flame own"
pylonsd keys add helder --keyring-backend=test  --recover <<< "stick tennis puppy mechanic pass basic scout number ice ticket cave license scale sugar scout bench correct media danger badge public gauge metal firm"
pylonsd keys add jacob --keyring-backend=test  --recover <<< "fox smart obtain similar west hub long envelope swallow pitch call joke cradle balcony general hint surprise segment total small body park pottery elite"
pylonsd keys add jack --keyring-backend=test  --recover <<< "please hurt play boost stadium pitch someone purity extra victory one story head setup learn trick feed infant monkey ring anxiety now upon piece"

pylonsd add-genesis-account $(pylonsd keys show pylonsinc -a --keyring-backend=test) 9000000000upylon,900000000ubedrock
pylonsd add-genesis-account $(pylonsd keys show tendermint -a --keyring-backend=test) 1000000000upylon,100000000ubedrock

pylonsd add-genesis-account $(pylonsd keys show helder -a --keyring-backend=test) 1000000upylon,1000000ubedrock
pylonsd add-genesis-account $(pylonsd keys show jacob -a --keyring-backend=test) 1000000upylon,1000000ubedrock
pylonsd add-genesis-account $(pylonsd keys show jack -a --keyring-backend=test) 1000000upylon,1000000ubedrock

mkdir -p $HOME/.pylons/config/gentx/

pylonsd gentx helder 1000000ubedrock --ip alpha --node-id $(pylonsd tendermint show-node-id --home $ALPHA_HOME)   --moniker="alpha" --pubkey $(pylonsd tendermint show-validator --home $ALPHA_HOME) --keyring-backend=test --chain-id=pylonschain --output-document $HOME/.pylons/config/gentx/alpha.json
pylonsd gentx jacob  1000000ubedrock --ip beta --node-id $(pylonsd tendermint show-node-id --home $BETA_HOME)    --moniker="beta" --pubkey $(pylonsd tendermint show-validator --home $BETA_HOME) --keyring-backend=test --chain-id=pylonschain --output-document $HOME/.pylons/config/gentx/beta.json
pylonsd gentx jack   1000000ubedrock --ip gamma --node-id $(pylonsd tendermint show-node-id --home $GAMMA_HOME)   --moniker="gamma" --pubkey $(pylonsd tendermint show-validator --home $GAMMA_HOME) --keyring-backend=test --chain-id=pylonschain --output-document $HOME/.pylons/config/gentx/gamma.json



##### Set values in config files #######
nodes="alpha beta gamma"

for node in $nodes; do

  # Copy the genesis and gentx to each node

  mkdir -p $node/config/gentx/
  cp $HOME/.pylons/config/genesis.json  $node/config/
  cp $HOME/.pylons/config/gentx/*  $node/config/gentx/



  pylonsd collect-gentxs --home $node

  # Change parameters to make localnet to work

  dasel put string -p toml -f $node/config/config.toml "rpc.laddr"                   "tcp://127.0.0.1:26657"
  dasel put string -p toml -f $node/config/config.toml "rpc.pprof_laddr"             "0.0.0.0:6060"
  dasel put string -p toml -f $node/config/config.toml "rpc.laddr"                   "tcp://0.0.0.0:26657"
  dasel put string -p toml -f $node/config/config.toml -s ".rpc.cors_allowed_origins.[]" "*"

  dasel put bool -p toml -f $node/config/app.toml ".api.enable"                  true
  dasel put bool -p toml -f $node/config/app.toml ".api.enabled-unsafe-cors"     true
  dasel put bool -p toml -f $node/config/app.toml ".api.swagger"                 true
  dasel put string -p toml -f $node/config/app.toml "minimum-gas-prices"                 "0.025ubedrock"

  dasel put string -p toml -f $node/config/app.toml -s ".rpc.cors_allowed_origins.[]" "*"


done


# Uncomment this if you want start the three nodes network in docker compose
METEOR_SETTINGS=$(cat settings.json) docker-compose up -d --build --force-recreate