#!/usr/bin/env bash

rm ~/.pylonsd/* -rf

pylonsd init alpha --chain-id=pylonschain

sed -i 's/stake/bedrock/g' $HOME/.pylonsd/config/genesis.json
sed -i 's/"ed25519"/"secp256k1"/g' $HOME/.pylonsd/config/genesis.json

pylonsd keys add pylonsinc --keyring-backend=test  --recover <<< "achieve patch rabbit delay you stairs flag nation lady outside answer property olive man dwarf used chapter sunset bundle sniff between since review logic"
pylonsd keys add tendermint  --keyring-backend=test  --recover <<< "oil inflict cup nation circle palace cactus uphold clarify vibrant believe stem farm aerobic casino treat early amazing remain produce exhaust bachelor flame own"

# The three initial accounts
pylonsd keys add helder --keyring-backend=test  --recover <<< "stick tennis puppy mechanic pass basic scout number ice ticket cave license scale sugar scout bench correct media danger badge public gauge metal firm"
pylonsd keys add jacob --keyring-backend=test  --recover <<< "fox smart obtain similar west hub long envelope swallow pitch call joke cradle balcony general hint surprise segment total small body park pottery elite"
pylonsd keys add jack --keyring-backend=test  --recover <<< "please hurt play boost stadium pitch someone purity extra victory one story head setup learn trick feed infant monkey ring anxiety now upon piece"

pylonsd add-genesis-account $(pylonsd keys show pylonsinc -a --keyring-backend=test) 9000000000pylon,900000000bedrock
pylonsd add-genesis-account $(pylonsd keys show tendermint -a --keyring-backend=test) 1000000000pylon,100000000bedrock

pylonsd add-genesis-account $(pylonsd keys show helder -a --keyring-backend=test) 1000000pylon,1000000bedrock
pylonsd add-genesis-account $(pylonsd keys show jacob -a --keyring-backend=test) 1000000pylon,1000000bedrock
pylonsd add-genesis-account $(pylonsd keys show jack -a --keyring-backend=test) 1000000pylon,1000000bedrock

mkdir -p $HOME/.pylonsd/config/gentx/

pylonsd gentx helder 1000000bedrock --pubkey $(pylonsd keys show helder --bech cons -p --keyring-backend=test) --keyring-backend=test --chain-id=pylonschain --output-document $HOME/.pylonsd/config/gentx/alpha.json
pylonsd gentx jacob 1000000bedrock --pubkey $(pylonsd keys show jacob --bech cons -p --keyring-backend=test) --keyring-backend=test --chain-id=pylonschain --output-document $HOME/.pylonsd/config/gentx/beta.json
pylonsd gentx jack 1000000bedrock --pubkey $(pylonsd keys show jack --bech cons -p --keyring-backend=test) --keyring-backend=test --chain-id=pylonschain --output-document $HOME/.pylonsd/config/gentx/gamma.json

pylonsd collect-gentxs

# sed command for osx


# # sed command for ubuntu

# sed -i 's/swagger = false/swagger = true/g' $CONFIG_DIR/app.toml

pylonsd start