#!/usr/bin/env bash

rm -rf $HOME/.pylonsd

pylonsd init pylonsvalidator --chain-id=pylonschain --home=$HOME/.pylonsd


pylonsd keys add pylonsinc --nosort --keyring-backend=test  --home=$HOME/.pylonsd --recover <<< "achieve patch rabbit delay you stairs flag nation lady outside answer property olive man dwarf used chapter sunset bundle sniff between since review logic"
pylonsd keys add tendermint --nosort --keyring-backend=test  --home=$HOME/.pylonsd --recover <<< "oil inflict cup nation circle palace cactus uphold clarify vibrant believe stem farm aerobic casino treat early amazing remain produce exhaust bachelor flame own"

# The three initial accounts
pylonsd keys add helder --nosort --keyring-backend=test  --home=$HOME/.pylonsd --recover <<< "stick tennis puppy mechanic pass basic scout number ice ticket cave license scale sugar scout bench correct media danger badge public gauge metal firm"
pylonsd keys add jacob  --nosort --keyring-backend=test  --home=$HOME/.pylonsd --recover <<< "fox smart obtain similar west hub long envelope swallow pitch call joke cradle balcony general hint surprise segment total small body park pottery elite"
pylonsd keys add jack   --nosort --keyring-backend=test  --home=$HOME/.pylonsd --recover <<< "please hurt play boost stadium pitch someone purity extra victory one story head setup learn trick feed infant monkey ring anxiety now upon piece"


pylonsd add-genesis-account $(pylonsd keys show pylonsinc -a --keyring-backend=test --home=$HOME/.pylonsd) 9000000000pylon,900000000bedrock
pylonsd add-genesis-account $(pylonsd keys show tendermint -a --keyring-backend=test --home=$HOME/.pylonsd) 1000000000pylon,100000000bedrock

pylonsd add-genesis-account $(pylonsd keys show helder -a --keyring-backend=test --home=$HOME/.pylonsd) 1pylon,1bedrock
pylonsd add-genesis-account $(pylonsd keys show jacob -a --keyring-backend=test --home=$HOME/.pylonsd) 1pylon,1bedrock
pylonsd add-genesis-account $(pylonsd keys show jack -a --keyring-backend=test --home=$HOME/.pylonsd) 1pylon,1bedrock

mkdir -p $HOME/.pylonsd/config/gentx/

pylonsd gentx helder --offline --from $(pylonsd keys show helder -a --keyring-backend=test --home=$HOME/.pylonsd)  1bedrock --account-number 2 --chain-id=pylonschain --moniker="alpha" --min-self-delegation 1 --commission-max-change-rate=0.01 --commission-max-rate=1.0 --commission-rate=0.07 --output-document $HOME/.pylonsd/config/gentx/alpha.json
pylonsd gentx jacob --offline --from $(pylonsd keys show jacob -a --keyring-backend=test --home=$HOME/.pylonsd)  1bedrock --account-number 3 --chain-id=pylonschain --moniker="beta" --min-self-delegation 1 --commission-max-change-rate=0.01 --commission-max-rate=1.0 --commission-rate=0.07 --output-document $HOME/.pylonsd/config/gentx/beta.json
pylonsd gentx jack --offline  --from $(pylonsd keys show jack -a --keyring-backend=test --home=$HOME/.pylonsd)  1bedrock --account-number 4 --chain-id=pylonschain --moniker="gamma" --min-self-delegation 1 --commission-max-change-rate=0.01 --commission-max-rate=1.0 --commission-rate=0.07 --output-document $HOME/.pylonsd/config/gentx/gamma.json

sed -i 's/stake/bedrock/g' $HOME/.pylonsd/config/genesis.json



pylonsd collect-gentxs  --home=$HOME/.pylonsd

# sed command for osx


# # sed command for ubuntu
# sed -i 's/enable = false/enable = true/g' $HOME/.pylonsd/config/app.toml
# sed -i 's/swagger = false/swagger = true/g' $HOME/.pylonsd/config/app.toml

pylonsd start --home=$HOME/.pylonsd