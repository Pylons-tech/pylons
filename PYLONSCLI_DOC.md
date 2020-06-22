# Introduction

Pylonscli is a main command line interface tool to be mainly used by core developers of pylons ecosystem.

# cli basic
```
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

pylonscli tx pylons get-pylons
pylonscli tx pylons send-pylons
```
## Fetching pylons data

### cookbooks
```
pylonscli query pylons list_cookbook
pylonscli query pylons list_cookbook --account cosmos1tqvdp4rc28zklnk8mwxh94gdlel0s58tcwdrj9
```

### items
```
pylonscli query pylons items_by_sender
pylonscli query pylons items_by_sender --account cosmos1tqvdp4rc28zklnk8mwxh94gdlel0s58tcwdrj9
```

### recipes
```
pylonscli query pylons list_recipe
pylonscli query pylons list_recipe --account cosmos1tqvdp4rc28zklnk8mwxh94gdlel0s58tcwdrj9

pylonscli query pylons list_shorten_recipe
pylonscli query pylons list_shorten_recipe --account cosmos1tqvdp4rc28zklnk8mwxh94gdlel0s58tcwdrj9
```

### trades
```
pylonscli query pylons list_trade
pylonscli query pylons list_trade --account cosmos1tqvdp4rc28zklnk8mwxh94gdlel0s58tcwdrj9
pylonscli query pylons get_trade cosmos17gepewvvynfvxslaplzd8xcd8klj6rmh9a6qu7c326e2a1-fc53-4b20-bf02-56707d4fc532
```


### executions
```
pylonscli query pylons list_executions
pylonscli query pylons list_executions --account cosmos1tqvdp4rc28zklnk8mwxh94gdlel0s58tcwdrj9
```