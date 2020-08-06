# Introduction

Using REST interface server is the easiest way to fetch results in REST interface.

## Running rest server
```sh
pylonscli rest-server --chain-id pylonschain --trust-node --keyring-backend=test
```
## Fetching
This describes regular format of REST endpoints and samples for all endpoints.

### cookbooks

Format
```
http://${HOST}/pylons/list_cookbooks/${ownerKeyName}
```
Sample
```
http://localhost:1317/pylons/list_cookbooks/cosmos19vlpdf25cxh0w2s80z44r9ktrgzncf7zsaqey2
```

Sample Result
```json
{
    "Cookbooks": []
}
```

### trades

Format
```
http://${HOST}/pylons/list_trade/${ownerKeyName}
```
Sample
```
http://localhost:1317/pylons/list_trade/cosmos19vlpdf25cxh0w2s80z44r9ktrgzncf7zsaqey2
```

Sample Result
```json
{
    "Trades": []
}
```

Format
```
http://${HOST}/pylons/get_trade/{tradeKeyName}
```
Sample
```
http://localhost:1317/pylons/get_trade/cosmos17gepewvvynfvxslaplzd8xcd8klj6rmh9a6qu7c326e2a1-fc53-4b20-bf02-56707d4fc532
```
Sample Result
```
{
  "height": "0",
  "result": {
    "ID": "cosmos17gepewvvynfvxslaplzd8xcd8klj6rmh9a6qu7c326e2a1-fc53-4b20-bf02-56707d4fc532",
    "CoinInputs": null,
    "ItemInputs": [
      {
        "ItemInput": {
          "Doubles": null,
          "Longs": [
            {
              "Key": "level",
              "MinValue": "1",
              "MaxValue": "1"
            }
          ],
          "Strings": [
            {
              "Key": "Name",
              "Value": "Copper sword"
            }
          ]
        },
        "CookbookID": "LOUD-v0.0.0-1579053457"
      }
    ],
    "CoinOutputs": [
      {
        "denom": "pylon",
        "amount": "200"
      }
    ],
    "ItemOutputs": null,
    "ExtraInfo": "sword to pylon trading created by loud game",
    "Sender": "cosmos17gepewvvynfvxslaplzd8xcd8klj6rmh9a6qu7",
    "FulFiller": "",
    "Disabled": false,
    "Completed": false
  }
}
```

### recipes

Format
```
http://${HOST}/pylons/list_recipe/${ownerKeyName}
```
Sample
```
http://localhost:1317/pylons/list_recipe/cosmos19vlpdf25cxh0w2s80z44r9ktrgzncf7zsaqey2
```

By cookbook
```
http://${HOST}/pylons/list_recipe_by_cookbook/${cookbookID}
```

Sample Result
```json
{
    "Recipes": []
}
```

Shorten recipes
```
http://localhost:1317/pylons/list_shorten_recipe
```
By cookbook
```
http://${HOST}/pylons/list_shorten_recipe_by_cookbook/${cookbookID}
```

Sample Result
```json
{
    "Recipes": [
      {
        "ID": "CosWar-expedition-fight-v0.0.0-1589853721",
        "CookbookID": "coswar-v0.0.0-1589853721",
        "Name": "this recipe is used to do expedition fight.",
        "Description": "this recipe is used to do expedition fight.",
        "Sender": "cosmos1tqvdp4rc28zklnk8mwxh94gdlel0s58tcwdrj9"
      }
    ]
}
```

### items

Format
```
http://${HOST}/pylons/items_by_sender/${ownerKeyName}
```
Sample
```
http://localhost:1317/pylons/items_by_sender/cosmos19vlpdf25cxh0w2s80z44r9ktrgzncf7zsaqey2
```

Sample Result
```json
{
    "Items": []
}
```

### executions

Format
```
http://${HOST}/pylons/list_executions/${ownerKeyName}
```
Sample
```
http://localhost:1317/pylons/list_executions/cosmos19vlpdf25cxh0w2s80z44r9ktrgzncf7zsaqey2
```

Sample Result
```json
{
    "Executions": []
}
```

### locked coins
Format  
```
http://localhost:1317/pylons/get_locked_coin_details
http://localhost:1317/pylons/get_locked_coin_details/cosmos1g5w79thfvt86m6cpa0a7jezfv0sjt0u7y09ldm
```

Sample result
```json
{
  "height": "0",
  "result": {
    "Sender": "cosmos1g5w79thfvt86m6cpa0a7jezfv0sjt0u7y09ldm",
    "Amount": [
      {
        "denom": "pylon",
        "amount": "40200"
      }
    ],
    "LockCoinTrades": [
      {
        "ID": "cosmos1g5w79thfvt86m6cpa0a7jezfv0sjt0u7y09ldm62f01650-af8c-41a5-ae50-9ddfb67ec251",
        "Amount": [
          {
            "denom": "pylon",
            "amount": "200"
          }
        ]
      }
    ],
    "LockCoinExecs": [
      {
        "ID": "cosmos16dkp62c4cu9g6ljxxx8nujple90764xv0l96v4d3379fd6-56a7-4c7c-a072-8c9e71bedd1b",
        "Amount": [
          {
            "denom": "pylon",
            "amount": "40000"
          }
        ]
      }
    ]
  }
}
```

Format  
```
http://localhost:1317/pylons/get_locked_coins
http://localhost:1317/pylons/get_locked_coins/cosmos1g5w79thfvt86m6cpa0a7jezfv0sjt0u7y09ldm
```

Sample result
```json
{
  "height": "0",
  "result": {
    "NodeVersion": "0.0.1",
    "Sender": "cosmos1g5w79thfvt86m6cpa0a7jezfv0sjt0u7y09ldm",
    "Amount": [
      {
        "denom": "pylon",
        "amount": "200"
      }
    ]
  }
}
```
### google iap query
Format
```
http://127.0.0.1:1317/pylons/check_google_iap_order/<purchaseToken>
```

Sample
```
http://127.0.0.1:1317/pylons/check_google_iap_order/agpgcdbplfjjpkbgadnfkmec.AO-J1OxqC40C2YfQkf5jjDqN8gparJ6W-EbGtygUKQlbc_bPn1ZvZz2-a9UnfY3i6HUYk8M5p92uf29pE7ffNwTUg4XmGrR8y3dhz7EKssD6qp-dejCg2Rs
```

Example Response  
```json
{
  "height": "0",
  "result": {
    "exist": true,
    "purchaseToken": "agpgcdbplfjjpkbgadnfkmec.AO-J1OxqC40C2YfQkf5jjDqN8gparJ6W-EbGtygUKQlbc_bPn1ZvZz2-a9UnfY3i6HUYk8M5p92uf29pE7ffNwTUg4XmGrR8y3dhz7EKssD6qp-dejCg2Rs"
  }
}
```