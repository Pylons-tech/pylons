# THIS FILE WORKS IN COMBINATION WITH DOCKER

KEY="validator"
KEYRING_BACKEND="test"
CHAIN_ID="testing"
SLEEP_TIME="10s"
UPGRADE_NAME="sdk-46"

CURRENT_BLOCK_TIME=$(curl http://localhost:26657/abci_info? | jq -r ".result.response.last_block_height")
UPGRADE_HEIGHT=$(($CURRENT_BLOCK_TIME + 50))

echo "UPGRADE_HEIGHT = $UPGRADE_HEIGHT"

RES=$(pylonsd tx gov submit-legacy-proposal software-upgrade $UPGRADE_NAME --upgrade-height $UPGRADE_HEIGHT --title "$UPGRADE_NAME" --description "$UPGRADE_NAME" --from $KEY --keyring-backend=$KEYRING_BACKEND --chain-id=$CHAIN_ID --deposit 10000000upylon --no-validate --broadcast-mode=block -y -o json)

PROPOSAL_ID=$(echo $RES | jq -r ".logs[0].events[4].attributes[2].value")

echo "PROPOSAL_ID = $PROPOSAL_ID"

# sleep for chain to update
sleep "$SLEEP_TIME"

STATUS=$(pylonsd q gov proposal $PROPOSAL_ID -o json | jq -r ".status")

echo "STATUS = $STATUS"

pylonsd tx gov vote $PROPOSAL_ID yes --from=$KEY --keyring-backend=$KEYRING_BACKEND --chain-id=$CHAIN_ID -y

# sleep for chain to update
sleep "$SLEEP_TIME"

STATUS=$(pylonsd q gov proposal $PROPOSAL_ID -o json | jq -r ".status")

echo "STATUS = $STATUS"

# # Check that we have proposal 1 passed, and proposal 2 in deposit period
# pylonsd q gov proposals
# # CHeck that validator commission is under min_commission_rate
# pylonsd q staking validators
# # Wait for upgrade block.
# # Upgrade happened
# # your full node should have crashed with consensus failure

# # Now we test post-upgrade behavior is as intended

# # Everything in deposit stayed in deposit
# pylonsd q gov proposals
# # Check that commissions was bumped to min_commission_rate
# pylonsd q staking validators
# # pushes 2 into voting period
# pylonsd tx gov deposit 2 1valtoken --from=validator --keyring-backend=test --chain-id=testing --yes