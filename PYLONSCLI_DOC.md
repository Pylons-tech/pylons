# Introduction

Pylonscli is a main command line interface tool to be mainly used by core developers of pylons ecosystem.

# cli basic
```sh
rm -rf ~/.pylonsd
rm -rf ~/.pylonscli

pylonsd init masternode --chain-id pylonschain
pylonscli config chain-id pylonschain
pylonscli config output json
pylonscli config indent true
pylonscli config trust-node true

pylonscli keys add jack
pylonscli keys add jack --keyring-backend=test
pylonscli keys remove jack
pylonscli keys remove jack --keyring-backend=test

pylonsd add-genesis-account $(pylonscli keys show node0 -a --keyring-backend=test) 10000000000pylon,1000000000node0token

pylonsd gentx --name node0 --keyring-backend=test
pylonsd collect-gentxs

pylonscli keys add jack --keyring-backend=test
pylonscli tx pylons create-account --from jack --keyring-backend=test
pylonscli tx pylons get-pylons --from jack --keyring-backend=test --amount 50000
pylonscli tx pylons send-pylons
```
## Fetching pylons data

### cookbooks
```sh
pylonscli query pylons list_cookbook
pylonscli query pylons list_cookbook --account cosmos1tqvdp4rc28zklnk8mwxh94gdlel0s58tcwdrj9
```

### items
```sh
pylonscli query pylons items_by_sender
pylonscli query pylons items_by_sender --account cosmos1tqvdp4rc28zklnk8mwxh94gdlel0s58tcwdrj9
```

### recipes
```sh
pylonscli query pylons list_recipe
pylonscli query pylons list_recipe --account cosmos1tqvdp4rc28zklnk8mwxh94gdlel0s58tcwdrj9

pylonscli query pylons list_recipe_by_cookbook
pylonscli query pylons list_recipe_by_cookbook --cookbook-id helicopter-1589853709

pylonscli query pylons list_shorten_recipe
pylonscli query pylons list_shorten_recipe --account cosmos1tqvdp4rc28zklnk8mwxh94gdlel0s58tcwdrj9

pylonscli query pylons list_shorten_recipe_by_cookbook
pylonscli query pylons list_shorten_recipe_by_cookbook --cookbook-id helicopter-1589853709
```

### trades
```sh
pylonscli query pylons list_trade
pylonscli query pylons list_trade --account cosmos1tqvdp4rc28zklnk8mwxh94gdlel0s58tcwdrj9
pylonscli query pylons get_trade cosmos17gepewvvynfvxslaplzd8xcd8klj6rmh9a6qu7c326e2a1-fc53-4b20-bf02-56707d4fc532
```


### executions
```sh
pylonscli query pylons list_executions
pylonscli query pylons list_executions --account cosmos1tqvdp4rc28zklnk8mwxh94gdlel0s58tcwdrj9
```

### locked coins
```sh

pylonscli query pylons get_locked_coins # get all locked coins
pylonscli query pylons get_locked_coins --account cosmos1g5w79thfvt86m6cpa0a7jezfv0sjt0u7y09ldm # get specific account's locked coins

pylonscli query pylons get_locked_coin_details --account cosmos1g5w79thfvt86m6cpa0a7jezfv0sjt0u7y09ldm # get all locked coin details
pylonscli query pylons get_locked_coin_details --account cosmos1g5w79thfvt86m6cpa0a7jezfv0sjt0u7y09ldm # get specific account's locked coin details
```