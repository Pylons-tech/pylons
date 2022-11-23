#!/bin/bash

OLD_VERSION=0.5.0
UPGRADE_HEIGHT=20
HOME=mytestnet
ROOT=$(pwd)
DENOM=upylons
SOFTWARE_UPGRADE_NAME=v1.1.0

mkdir -p _build/gocache
export GOMODCACHE=$ROOT/_build/gocache

# install old binary
if ! command -v _build/old/pylonsd &> /dev/null
then
    mkdir -p _build/old
    # wget -c "https://github.com/Pylons-tech/pylons/archive/refs/tags/v${OLD_VERSION}.zip" -O _build/v${OLD_VERSION}.zip
    # unzip _build/v${OLD_VERSION}.zip -d _build
    cd ./_build/pylons-${OLD_VERSION}
    GOBIN="$ROOT/_build/old" go install -mod=readonly ./...
    cd ../..
fi

# install new binary
if ! command -v _build/new/pylonsd &> /dev/null
then
    GOBIN="$ROOT/_build/new" go install -mod=readonly ./...
fi

# start old node
screen -dmS node1 bash scripts/run-upgrade-node.sh _build/old/pylonsd $DENOM

sleep 20

./_build/old/pylonsd tx gov submit-proposal software-upgrade "$SOFTWARE_UPGRADE_NAME" --upgrade-height $UPGRADE_HEIGHT --upgrade-info "temp" --title "upgrade" --description "upgrade"  --from test1 --keyring-backend test --chain-id test --home $HOME -y

sleep 3

./_build/old/pylonsd tx gov deposit 1 "20000000${DENOM}" --from test1 --keyring-backend test --chain-id test --home $HOME -y

sleep 3

./_build/old/pylonsd tx gov vote 1 yes --from test --keyring-backend test --chain-id test --home $HOME -y

sleep 3

./_build/old/pylonsd tx gov vote 1 yes --from test1 --keyring-backend test --chain-id test --home $HOME -y

sleep 3

# determine block_height to halt
while true; do 
    BLOCK_HEIGHT=$(./_build/old/pylonsd status | jq '.SyncInfo.latest_block_height' -r)
    if [ $BLOCK_HEIGHT = "$UPGRADE_HEIGHT" ]; then
        # assuming running only 1 pylonsd
        echo "BLOCK HEIGHT = $UPGRADE_HEIGHT REACHED, KILLING OLD ONE"
        pkill pylonsd
        break
    else
        ./_build/old/pylonsd q gov proposal 1 --output=json | jq ".status"
        echo "BLOCK_HEIGHT = $BLOCK_HEIGHT"
        sleep 10
    fi
done

sleep 3

./_build/new/pylonsd start --log_level debug --home $HOME