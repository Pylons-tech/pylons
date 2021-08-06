#!/usr/bin/env bash

rm -rf alpha && mkdir alpha
rm -rf beta && mkdir beta
rm -rf gamma && mkdir gamma
rm -rf ~/.pylonsd

ALPHA_HOME=./alpha
BETA_HOME=./beta
GAMMA_HOME=./gamma

pylonsd init alpha --chain-id=pylonschain --home $ALPHA_HOME
pylonsd init beta --chain-id=pylonschain --home $BETA_HOME
pylonsd init gamma --chain-id=pylonschain --home $GAMMA_HOME

# I am going to generate the first genesis in the default dir
pylonsd init masternode --chain-id=pylonschain

# Change the bond denom to the staking token (bedrock)
sed -i 's/stake/bedrock/g' $HOME/.pylonsd/config/genesis.json
#sed -i 's/"ed25519"/"secp256k1"/g' $HOME/.pylonsd/config/genesis.json

# Create all accounts
pylonsd keys add pylonsinc --keyring-backend=test  --recover <<< "achieve patch rabbit delay you stairs flag nation lady outside answer property olive man dwarf used chapter sunset bundle sniff between since review logic"
pylonsd keys add tendermint  --keyring-backend=test  --recover <<< "oil inflict cup nation circle palace cactus uphold clarify vibrant believe stem farm aerobic casino treat early amazing remain produce exhaust bachelor flame own"
pylonsd keys add helder --keyring-backend=test  --recover <<< "stick tennis puppy mechanic pass basic scout number ice ticket cave license scale sugar scout bench correct media danger badge public gauge metal firm"
pylonsd keys add jacob --keyring-backend=test  --recover <<< "fox smart obtain similar west hub long envelope swallow pitch call joke cradle balcony general hint surprise segment total small body park pottery elite"
pylonsd keys add jack --keyring-backend=test  --recover <<< "please hurt play boost stadium pitch someone purity extra victory one story head setup learn trick feed infant monkey ring anxiety now upon piece"

pylonsd add-genesis-account $(pylonsd keys show pylonsinc -a --keyring-backend=test) 9000000000pylon,900000000bedrock
pylonsd add-genesis-account $(pylonsd keys show tendermint -a --keyring-backend=test) 1000000000pylon,100000000bedrock

pylonsd add-genesis-account $(pylonsd keys show helder -a --keyring-backend=test) 1000000pylon,1000000bedrock
pylonsd add-genesis-account $(pylonsd keys show jacob -a --keyring-backend=test) 1000000pylon,1000000bedrock
pylonsd add-genesis-account $(pylonsd keys show jack -a --keyring-backend=test) 1000000pylon,1000000bedrock

mkdir -p $HOME/.pylonsd/config/gentx/

pylonsd gentx helder 1000000bedrock --ip alpha --node-id $(pylonsd tendermint show-node-id --home $ALPHA_HOME)   --moniker="alpha" --pubkey $(pylonsd tendermint show-validator --home $ALPHA_HOME) --keyring-backend=test --chain-id=pylonschain --output-document $HOME/.pylonsd/config/gentx/alpha.json
pylonsd gentx jacob  1000000bedrock --ip beta --node-id $(pylonsd tendermint show-node-id --home $BETA_HOME)    --moniker="beta" --pubkey $(pylonsd tendermint show-validator --home $BETA_HOME) --keyring-backend=test --chain-id=pylonschain --output-document $HOME/.pylonsd/config/gentx/beta.json
pylonsd gentx jack   1000000bedrock --ip gamma --node-id $(pylonsd tendermint show-node-id --home $GAMMA_HOME)   --moniker="gamma" --pubkey $(pylonsd tendermint show-validator --home $GAMMA_HOME) --keyring-backend=test --chain-id=pylonschain --output-document $HOME/.pylonsd/config/gentx/gamma.json

# Now I copy the genesis and gentx to each node

mkdir -p $ALPHA_HOME/config/gentx/
mkdir -p $BETA_HOME/config/gentx/
mkdir -p $GAMMA_HOME/config/gentx/

cp $HOME/.pylonsd/config/genesis.json  $ALPHA_HOME/config/
cp $HOME/.pylonsd/config/genesis.json  $BETA_HOME/config/
cp $HOME/.pylonsd/config/genesis.json  $GAMMA_HOME/config/

cp $HOME/.pylonsd/config/gentx/*  $ALPHA_HOME/config/gentx/
cp $HOME/.pylonsd/config/gentx/*  $BETA_HOME/config/gentx/
cp $HOME/.pylonsd/config/gentx/*  $GAMMA_HOME/config/gentx/


##### Set values in config files #######
directories="alpha beta gamma"

for directory in $directories; do

  pylonsd collect-gentxs --home $directory

  # Change parameters to make localnet to work

  dasel put string -p toml -f $directory/config/config.toml           "rpc.laddr"           "tcp://127.0.0.1:26657"
  dasel put string -p toml -f $directory/config/config.toml           "rpc.pprof_laddr"     "0.0.0.0:6060"
  dasel put string -p toml -f $directory/config/config.toml           "rpc.laddr"           "tcp://0.0.0.0:26657"
  dasel put object -p toml -t string -f $directory/config/config.toml "rpc" cors_allowed_origins = ["*"]



  dasel put bool -p toml -f $directory/config/app.toml ".api.enable"              true
  dasel put bool -p toml -f $directory/config/app.toml ".api.enabled-unsafe-cors"     true
  dasel put bool -p toml -f $directory/config/app.toml ".api.swagger"             true
  dasel put object -p toml -t string -f $directory/config/app.toml "rpc" cors_allowed_origins = ["*"]


done


METEOR_SETTINGS=$(cat settings.json) docker-compose up -d --build --force-recreate