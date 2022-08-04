# Create a genesis.json for testing. The node that you this on will be your "validator"
# It should be on version v3.0.0-rc0
pylonsd init --chain-id=testing testing --home=$HOME/.pylonsd
pylonsd keys add validator --keyring-backend=test --home=$HOME/.pylonsd
pylonsd add-genesis-account $(pylonsd keys show validator -a --keyring-backend=test --home=$HOME/.pylonsd) 1000000000upylon,1000000000valtoken --home=$HOME/.pylonsd
sed -i -e "s/stake/upylon/g" $HOME/.pylonsd/config/genesis.json
pylonsd gentx validator 500000000upylon --commission-rate="0.0" --keyring-backend=test --home=$HOME/.pylonsd --chain-id=testing
pylonsd collect-gentxs --home=$HOME/.pylonsd

cat $HOME/.pylonsd/config/genesis.json | jq '.initial_height="139"' > $HOME/.pylonsd/config/tmp_genesis.json && mv $HOME/.pylonsd/config/tmp_genesis.json $HOME/.pylonsd/config/genesis.json
cat $HOME/.pylonsd/config/genesis.json | jq '.app_state["gov"]["deposit_params"]["min_deposit"]["denom"]="valtoken"' > $HOME/.pylonsd/config/tmp_genesis.json && mv $HOME/.pylonsd/config/tmp_genesis.json $HOME/.pylonsd/config/genesis.json
cat $HOME/.pylonsd/config/genesis.json | jq '.app_state["gov"]["deposit_params"]["min_deposit"]["amount"]="100"' > $HOME/.pylonsd/config/tmp_genesis.json && mv $HOME/.pylonsd/config/tmp_genesis.json $HOME/.pylonsd/config/genesis.json
cat $HOME/.pylonsd/config/genesis.json | jq '.app_state["gov"]["voting_params"]["voting_period"]="120s"' > $HOME/.pylonsd/config/tmp_genesis.json && mv $HOME/.pylonsd/config/tmp_genesis.json $HOME/.pylonsd/config/genesis.json
cat $HOME/.pylonsd/config/genesis.json | jq '.app_state["staking"]["params"]["min_commission_rate"]="0.050000000000000000"' > $HOME/.pylonsd/config/tmp_genesis.json && mv $HOME/.pylonsd/config/tmp_genesis.json $HOME/.pylonsd/config/genesis.json

# Now setup a second full node, and peer it with this v3.0.0-rc0 node.

# start the chain on both machines
pylonsd start
# Create proposals

pylonsd tx gov submit-proposal --title="existing passing prop" --description="passing prop"  --from=test --deposit=1000valtoken --chain-id=testing --keyring-backend=test --broadcast-mode=block  --type="Text"
pylonsd tx gov vote 1 yes --from=validator --keyring-backend=test --chain-id=testing --yes
pylonsd tx gov submit-proposal --title="prop with enough osmo deposit" --description="prop w/ enough deposit"  --from=validator --deposit=500000000upylon --chain-id=testing --keyring-backend=test --broadcast-mode=block  --type="Text"
# Check that we have proposal 1 passed, and proposal 2 in deposit period
pylonsd q gov proposals
# CHeck that validator commission is under min_commission_rate
pylonsd q staking validators
# Wait for upgrade block.
# Upgrade happened
# your full node should have crashed with consensus failure

# Now we test post-upgrade behavior is as intended

# Everything in deposit stayed in deposit
pylonsd q gov proposals
# Check that commissions was bumped to min_commission_rate
pylonsd q staking validators
# pushes 2 into voting period
pylonsd tx gov deposit 2 1valtoken --from=validator --keyring-backend=test --chain-id=testing --yes