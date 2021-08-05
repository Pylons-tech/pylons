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

# Adjust persistent peers info in each node
sed -i "s/^\(addr_book_strict\s*=\s*\).*$/\1false/g" $ALPHA_HOME/config/config.toml
sed -i "s/^\(addr_book_strict\s*=\s*\).*$/\1false/g" $BETA_HOME/config/config.toml
sed -i "s/^\(addr_book_strict\s*=\s*\).*$/\1false/g" $GAMMA_HOME/config/config.toml

#alpha_persistent_info="$(pylonsd tendermint show-node-id --home=$ALPHA_HOME)@192.168.2.118:26656"
#beta_persistent_info="$(pylonsd tendermint show-node-id --home=$BETA_HOME)@192.168.2.119:26656"
#gamma_persistent_info="$(pylonsd tendermint show-node-id --home=$GAMMA_HOME)@192.168.2.120:26656"
#
#sed -i "s/^\(persistent_peers\s*=\s*\).*$/\1\"$beta_persistent_info,$gamma_persistent_info\"/g" $ALPHA_HOME/config/config.toml
#sed -i "s/^\(persistent_peers\s*=\s*\).*$/\1\"$alpha_persistent_info,$gamma_persistent_info\"/g" $BETA_HOME/config/config.toml
#sed -i "s/^\(persistent_peers\s*=\s*\).*$/\1\"$alpha_persistent_info,$beta_persistent_info\"/g" $GAMMA_HOME/config/config.toml

pylonsd collect-gentxs --home $ALPHA_HOME
pylonsd collect-gentxs --home $BETA_HOME
pylonsd collect-gentxs --home $GAMMA_HOME

docker-compose up -d --build

