# Send SoftwareUpgrade proposal - Upgrade Name: v2.0.0
$pylonsd tx gov submit-proposal software-upgrade sdk-47 --title v2.0.0 --description v2.0.0 --upgrade-height 1020 --from validator --yes --chain-id pylons-testnet-1

# Deposit for the proposal - Proposal ID: 1
$pylonsd tx gov deposit 1 10000000atoken --from validator --yes --chain-id pylons-testnet-1

# Vote for the proposal
$pylonsd tx gov vote 1 yes --from validator --yes --chain-id pylons-testnet-1