# Introduction

`pylonsd` is a main command line interface tool to be mainly used by core developers of pylons ecosystem.

# cli basic
```sh
rm -rf ~/.pylonsd

pylonsd init masternode --chain-id=pylonschain

pylonsd keys add jack
pylonsd keys add jack --keyring-backend=test
pylonsd keys remove jack
pylonsd keys remove jack --keyring-backend=test

pylonsd add-genesis-account $(pylonsd keys show node0 -a --keyring-backend=test) 10000000000pylon,1000000000node0token

pylonsd gentx --name node0 --keyring-backend=test
pylonsd collect-gentxs

pylonsd keys add jack --keyring-backend=test
pylonsd tx pylons create-account --from jack --keyring-backend=test
pylonsd tx pylons get-pylons --from jack --keyring-backend=test --amount 50000
pylonsd tx pylons send-pylons
```
## Fetching pylons data

### cookbooks
```sh
pylonsd query pylons list_cookbook
pylonsd query pylons list_cookbook --account cosmos1tqvdp4rc28zklnk8mwxh94gdlel0s58tcwdrj9
```

### items
```sh
pylonsd query pylons items_by_sender
pylonsd query pylons items_by_sender --account cosmos1tqvdp4rc28zklnk8mwxh94gdlel0s58tcwdrj9
```

### recipes
```sh
pylonsd query pylons list_recipe
pylonsd query pylons list_recipe --account cosmos1tqvdp4rc28zklnk8mwxh94gdlel0s58tcwdrj9

pylonsd query pylons list_recipe_by_cookbook
pylonsd query pylons list_recipe_by_cookbook --cookbook-id helicopter-1589853709

pylonsd query pylons list_shorten_recipe
pylonsd query pylons list_shorten_recipe --account cosmos1tqvdp4rc28zklnk8mwxh94gdlel0s58tcwdrj9

pylonsd query pylons list_shorten_recipe_by_cookbook
pylonsd query pylons list_shorten_recipe_by_cookbook --cookbook-id helicopter-1589853709
```

### trades
```sh
pylonsd query pylons list_trade
pylonsd query pylons list_trade --account cosmos1tqvdp4rc28zklnk8mwxh94gdlel0s58tcwdrj9
pylonsd query pylons get_trade cosmos17gepewvvynfvxslaplzd8xcd8klj6rmh9a6qu7c326e2a1-fc53-4b20-bf02-56707d4fc532
```


### executions
```sh
pylonsd query pylons list_executions
pylonsd query pylons list_executions --account cosmos1tqvdp4rc28zklnk8mwxh94gdlel0s58tcwdrj9
```

### locked coins
```sh
pylonsd query pylons get_locked_coins # get all locked coins
pylonsd query pylons get_locked_coins --account cosmos1g5w79thfvt86m6cpa0a7jezfv0sjt0u7y09ldm # get specific account's locked coins

pylonsd query pylons get_locked_coin_details --account cosmos1g5w79thfvt86m6cpa0a7jezfv0sjt0u7y09ldm # get all locked coin details
pylonsd query pylons get_locked_coin_details --account cosmos1g5w79thfvt86m6cpa0a7jezfv0sjt0u7y09ldm # get specific account's locked coin details
```

### item transfer

```sh
# format
pylonsd tx pylons send-items <to_address> <item_id1>,<item_id2>... --from <from_address> keyring-backend=<keyring-backend>

# example
pylonsd tx pylons send-items cosmos1g5w79thfvt86m6cpa0a7jezfv0sjt0u7y09ldm cosmos1yjrrrgt0xfqau9fz3vu6tlm380m7kjvqmzyd0scd8be417-3d63-4fcc-9fae-d9e98c498c55 --from cosmos1k6qm04kxkz7q69lhy80jf562y8d5rj66y8g8t2 --keyring-backend=test
```

### google iap query

```sh
pylonsd query pylons check_google_iap_order "agpgcdbplfjjpkbgadnfkmec.AO-J1OxqC40C2YfQkf5jjDqN8gparJ6W-EbGtygUKQlbc_bPn1ZvZz2-a9UnfY3i6HUYk8M5p92uf29pE7ffNwTUg4XmGrR8y3dhz7EKssD6qp-dejCg2Rs"
```

Example Response  

```json
{
    "exist":true,
    "purchaseToken":"agpgcdbplfjjpkbgadnfkmec.AO-J1OxqC40C2YfQkf5jjDqN8gparJ6W-EbGtygUKQlbc_bPn1ZvZz2-a9UnfY3i6HUYk8M5p92uf29pE7ffNwTUg4XmGrR8y3dhz7EKssD6qp-dejCg2Rs"
}
```