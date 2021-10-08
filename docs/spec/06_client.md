<!--
order: 6
-->

# Client


## CLI

A user can query and interact with the `pylons` module using the CLI.

### Query

The `query` commands allow users to query `pylons` state.

```bash
pylonsd query pylons --help
```

#### get-address-by-username

```bash
  pylonsd query pylons get-address-by-username [username] [flags]
```

#### get-username-by-address

```bash
  pylonsd query pylons get-username-by-address [address] [flags]
```

#### get-cookbook

```bash
pylonsd query pylons get-cookbook [id] [flags]
```

#### get-execution

```bash
  pylonsd query pylons get-execution [id] [flags]
```

#### get-google-iap-order

```bash
  pylonsd query pylons get-google-iap-order [purchase-token] [flags]
```

#### get-item

```bash
  pylonsd query pylons get-item [cookbook-id] [id] [flags]
```

#### get-recipe

```bash
  pylonsd query pylons get-recipe [cookbook-id] [id] [flags]
```

#### get-trade

```bash
  pylonsd query pylons get-trade [id] [flags]
```

#### list-cookbooks

```bash
  pylonsd query pylons list-cookbooks [addr] [flags]
```

#### list-executions-by-item

```bash
  pylonsd query pylons list-executions-by-item [cookbook-id] [id] [flags]
```

#### list-executions-by-recipe

```bash
  pylonsd query pylons list-executions-by-item [cookbook-id] [id] [flags]
```

#### list-item-by-owner

```bash
  pylonsd query pylons list-item-by-owner [owner] [flags]
```

#### list-recipes-by-cookbook

```bash
  pylonsd query pylons list-recipes-by-cookbook [id] [flags]
```

#### list-trades

```bash
  pylonsd query pylons list-trades [creator] [flags]
```

### Transactions

The `tx` commands allow users to interact with the `pylons` module.

#### create-account

```bash
  pylonsd tx pylons create-account [username] [flags]
```

#### update-account

```bash
  pylonsd tx pylons update-account [username] [flags]
```


#### create-cookbook

```bash
  pylonsd tx pylons create-cookbook [id] [name] [description] [developer] [version] [support-email] [cost-per-block] [enabled] [flags]
```

#### transfer-cookbook

```bash
  pylonsd tx pylons transfer-cookbook [cookbookID] [recipient] [flags]
```

#### update-cookbook

```bash
  pylonsd tx pylons update-cookbook [id] [name] [description] [developer] [version] [support-email] [cost-per-block] [enabled] [flags]
```

#### create-recipe

```bash
  pylonsd tx pylons create-recipe [cookbook-id] [id] [name] [description] [version] [coin-inputs] [item-inputs] [entries] [outputs] [block-interval] [enabled] [extra-info] [flags]
```

#### update-recipe

```bash
  pylonsd tx pylons update-recipe [cookbook-id] [id] [name] [description] [version] [coinInputs] [itemInputs] [entries] [outputs] [blockInterval] [enabled] [extraInfo] [flags]
```

#### execute-recipe

```bash
  pylonsd tx pylons execute-recipe [cookbook-id] [recipe-id] [item-ids] [flags]
```

#### set-item-string

```bash
  pylonsd tx pylons set-item-string [cookbook-id] [id] [field] [value] [flags]
```

#### send-items

```bash
  pylonsd tx pylons send-items [receiver] [items] [flags]
```

#### create-trade

```bash
  pylonsd tx pylons create-trade [coinInputs] [itemInputs] [coinOutputs] [itemOutputs] [extraInfo] [flags]
```

#### cancel-trade

```bash
  pylonsd tx pylons cancel-trade [id] [flags]
```

#### fulfill-trade

```bash
  pylonsd tx pylons fulfill-trade [id] [items] [flags]
```

#### google-iap-get-pylons

```bash
  pylonsd tx pylons google-iap-get-pylons [productID] [purchaseToken] [recieptDataBase64] [signature] [flags]
```

## gRPC

A user can query the `pylons` module using gRPC endpoints.

#### get-address-by-username

Endpoint:
```
Pylonstech.pylons.pylons.Query/AddressByUsername
```

#### get-username-by-address

Endpoint:
```
Pylonstech.pylons.pylons.Query/UsernameByAddress
```

#### get-cookbook

Endpoint:
```
Pylonstech.pylons.pylons.Query/Cookbook
```

#### list-cookbooks

Endpoint:
```
Pylonstech.pylons.pylons.Query/ListCookbooksByCreator
```

#### get-recipe

Endpoint:
```
Pylonstech.pylons.pylons.Query/Recipe
```

#### list-recipes-by-cookbook

Endpoint:
```
Pylonstech.pylons.pylons.Query/ListRecipesByCookbook
```

#### get-execution

Endpoint:
```
Pylonstech.pylons.pylons.Query/Execution
```

#### list-executions-by-item

Endpoint:
```
Pylonstech.pylons.pylons.Query/ListExecutionsByItem
```

#### list-executions-by-recipe

Endpoint:
```
Pylonstech.pylons.pylons.Query/ListExecutionsByRecipe
```

#### get-item

Endpoint:
```
Pylonstech.pylons.pylons.Query/Item
```

#### list-items-by-owner

Endpoint:
```
Pylonstech.pylons.pylons.Query/ListItemByOwner
```

#### get-trade

Endpoint:
```
Pylonstech.pylons.pylons.Query/Trade
```

#### get-google-iap-order

Endpoint:
```
Pylonstech.pylons.pylons.Query/GoogleInAppPurchaseOrder
```

## REST

A user can query the `pylons` module using REST endpoints.  The URL shown below uses "HOST" as the base.  If running a node locally using starport for testing,
"HOST" would be http://0.0.0.0:1317.

#### get-address-by-username

Request: 

```bash
curl -X GET "HOST/pylons/account/username/{username}" -H  "accept: application/json"
```

Example response:

```json
{
  "address": {
    "value": "string"
  }
}
```

#### get-username-by-address

Request:

```bash
curl -X GET "HOST/pylons/account/address/{address}" -H  "accept: application/json"
```

Example response:

```json
{
  "username": {
    "value": "string"
  }
}
```

#### get-cookbook

Request:


```bash
curl -X GET "HOST/pylons/cookbook/{ID}" -H  "accept: application/json"
```

Example response:

```json
{
  "Cookbook": {
    "creator": "string",
    "ID": "string",
    "nodeVersion": "string",
    "name": "string",
    "description": "string",
    "developer": "string",
    "version": "string",
    "supportEmail": "string",
    "costPerBlock": {
      "denom": "string",
      "amount": "string"
    },
    "enabled": true
  }
}
```

#### list-cookbooks

Request:


This query is shown with pagination options.

```bash
curl -X GET "HOST/pylons/cookbooks/{address}?pagination.countTotal=true&pagination.reverse=true" -H  "accept: application/json"
```

Example response:

```json
{
  "Cookbooks": [
    {
      "creator": "string",
      "ID": "string",
      "nodeVersion": "string",
      "name": "string",
      "description": "string",
      "developer": "string",
      "version": "string",
      "supportEmail": "string",
      "costPerBlock": {
        "denom": "string",
        "amount": "string"
      },
      "enabled": true
    }
  ],
  "pagination": {
    "nextKey": "string",
    "total": "string"
  }
}
```

#### get-recipe

Request:


```bash
curl -X GET "HOST/pylons/recipe/{cookbookID}/{ID}" -H  "accept: application/json"
```

Example response:

```json
{
  "Recipe": {
    "cookbookID": "string",
    "ID": "string",
    "nodeVersion": "string",
    "name": "string",
    "description": "string",
    "version": "string",
    "coinInputs": [
      {
        "coins": [
          {
            "denom": "string",
            "amount": "string"
          }
        ]
      }
    ],
    "itemInputs": [
      {
        "ID": "string",
        "doubles": [
          {
            "key": "string",
            "minValue": "string",
            "maxValue": "string"
          }
        ],
        "longs": [
          {
            "key": "string",
            "minValue": "string",
            "maxValue": "string"
          }
        ],
        "strings": [
          {
            "key": "string",
            "value": "string"
          }
        ],
        "conditions": {
          "doubles": [
            {
              "key": "string",
              "minValue": "string",
              "maxValue": "string"
            }
          ],
          "longs": [
            {
              "key": "string",
              "minValue": "string",
              "maxValue": "string"
            }
          ],
          "strings": [
            {
              "key": "string",
              "value": "string"
            }
          ]
        }
      }
    ],
    "entries": {
      "coinOutputs": [
        {
          "ID": "string",
          "coin": {
            "denom": "string",
            "amount": "string"
          },
          "program": "string"
        }
      ],
      "itemOutputs": [
        {
          "ID": "string",
          "doubles": [
            {
              "key": "string",
              "rate": "string",
              "weightRanges": [
                {
                  "lower": "string",
                  "upper": "string",
                  "weight": "string"
                }
              ],
              "program": "string"
            }
          ],
          "longs": [
            {
              "key": "string",
              "rate": "string",
              "weightRanges": [
                {
                  "lower": "string",
                  "upper": "string",
                  "weight": "string"
                }
              ],
              "program": "string"
            }
          ],
          "strings": [
            {
              "key": "string",
              "rate": "string",
              "value": "string",
              "program": "string"
            }
          ],
          "mutableStrings": [
            {
              "Key": "string",
              "Value": "string"
            }
          ],
          "transferFee": [
            {
              "denom": "string",
              "amount": "string"
            }
          ],
          "tradePercentage": "string",
          "quantity": "string",
          "amountMinted": "string",
          "tradeable": true
        }
      ],
      "itemModifyOutputs": [
        {
          "ID": "string",
          "itemInputRef": "string",
          "doubles": [
            {
              "key": "string",
              "rate": "string",
              "weightRanges": [
                {
                  "lower": "string",
                  "upper": "string",
                  "weight": "string"
                }
              ],
              "program": "string"
            }
          ],
          "longs": [
            {
              "key": "string",
              "rate": "string",
              "weightRanges": [
                {
                  "lower": "string",
                  "upper": "string",
                  "weight": "string"
                }
              ],
              "program": "string"
            }
          ],
          "strings": [
            {
              "key": "string",
              "rate": "string",
              "value": "string",
              "program": "string"
            }
          ],
          "mutableStrings": [
            {
              "Key": "string",
              "Value": "string"
            }
          ],
          "transferFee": [
            {
              "denom": "string",
              "amount": "string"
            }
          ],
          "tradePercentage": "string",
          "quantity": "string",
          "amountMinted": "string",
          "tradeable": true
        }
      ]
    },
    "outputs": [
      {
        "entryIDs": [
          "string"
        ],
        "weight": "string"
      }
    ],
    "blockInterval": "string",
    "enabled": true,
    "extraInfo": "string"
  }
}
```

#### list-recipes-by-cookbook

Request:

This query is shown with pagination options.

```bash
curl -X GET "HOST/pylons/recipes/{address}?pagination.countTotal=false&pagination.reverse=true" -H  "accept: application/json"
```

Example response:

```json
{
  "Recipes": [
    {
      "cookbookID": "string",
      "ID": "string",
      "nodeVersion": "string",
      "name": "string",
      "description": "string",
      "version": "string",
      "coinInputs": [
        {
          "coins": [
            {
              "denom": "string",
              "amount": "string"
            }
          ]
        }
      ],
      "itemInputs": [
        {
          "ID": "string",
          "doubles": [
            {
              "key": "string",
              "minValue": "string",
              "maxValue": "string"
            }
          ],
          "longs": [
            {
              "key": "string",
              "minValue": "string",
              "maxValue": "string"
            }
          ],
          "strings": [
            {
              "key": "string",
              "value": "string"
            }
          ],
          "conditions": {
            "doubles": [
              {
                "key": "string",
                "minValue": "string",
                "maxValue": "string"
              }
            ],
            "longs": [
              {
                "key": "string",
                "minValue": "string",
                "maxValue": "string"
              }
            ],
            "strings": [
              {
                "key": "string",
                "value": "string"
              }
            ]
          }
        }
      ],
      "entries": {
        "coinOutputs": [
          {
            "ID": "string",
            "coin": {
              "denom": "string",
              "amount": "string"
            },
            "program": "string"
          }
        ],
        "itemOutputs": [
          {
            "ID": "string",
            "doubles": [
              {
                "key": "string",
                "rate": "string",
                "weightRanges": [
                  {
                    "lower": "string",
                    "upper": "string",
                    "weight": "string"
                  }
                ],
                "program": "string"
              }
            ],
            "longs": [
              {
                "key": "string",
                "rate": "string",
                "weightRanges": [
                  {
                    "lower": "string",
                    "upper": "string",
                    "weight": "string"
                  }
                ],
                "program": "string"
              }
            ],
            "strings": [
              {
                "key": "string",
                "rate": "string",
                "value": "string",
                "program": "string"
              }
            ],
            "mutableStrings": [
              {
                "Key": "string",
                "Value": "string"
              }
            ],
            "transferFee": [
              {
                "denom": "string",
                "amount": "string"
              }
            ],
            "tradePercentage": "string",
            "quantity": "string",
            "amountMinted": "string",
            "tradeable": true
          }
        ],
        "itemModifyOutputs": [
          {
            "ID": "string",
            "itemInputRef": "string",
            "doubles": [
              {
                "key": "string",
                "rate": "string",
                "weightRanges": [
                  {
                    "lower": "string",
                    "upper": "string",
                    "weight": "string"
                  }
                ],
                "program": "string"
              }
            ],
            "longs": [
              {
                "key": "string",
                "rate": "string",
                "weightRanges": [
                  {
                    "lower": "string",
                    "upper": "string",
                    "weight": "string"
                  }
                ],
                "program": "string"
              }
            ],
            "strings": [
              {
                "key": "string",
                "rate": "string",
                "value": "string",
                "program": "string"
              }
            ],
            "mutableStrings": [
              {
                "Key": "string",
                "Value": "string"
              }
            ],
            "transferFee": [
              {
                "denom": "string",
                "amount": "string"
              }
            ],
            "tradePercentage": "string",
            "quantity": "string",
            "amountMinted": "string",
            "tradeable": true
          }
        ]
      },
      "outputs": [
        {
          "entryIDs": [
            "string"
          ],
          "weight": "string"
        }
      ],
      "blockInterval": "string",
      "enabled": true,
      "extraInfo": "string"
    }
  ],
  "pagination": {
    "nextKey": "string",
    "total": "string"
  }
}
```

#### get-execution

Request:

```bash
curl -X GET "HOST/pylons/execution/{ID}" -H  "accept: application/json"
```

Example Response:

```json
{
  "Execution": {
    "creator": "string",
    "ID": "string",
    "recipeID": "string",
    "cookbookID": "string",
    "recipeVersion": "string",
    "nodeVersion": "string",
    "blockHeight": "string",
    "itemInputs": [
      {
        "ID": "string",
        "doubles": [
          {
            "Key": "string",
            "Value": "string"
          }
        ],
        "longs": [
          {
            "Key": "string",
            "Value": "string"
          }
        ],
        "strings": [
          {
            "Key": "string",
            "Value": "string"
          }
        ]
      }
    ],
    "coinInputs": [
      {
        "denom": "string",
        "amount": "string"
      }
    ],
    "coinOutputs": [
      {
        "denom": "string",
        "amount": "string"
      }
    ],
    "itemOutputIDs": [
      "string"
    ],
    "itemModifyOutputIDs": [
      "string"
    ]
  },
  "Completed": true
}
```
#### list-executions-by-item

Request:

This query is shown with pagination options.


```bash
curl -X GET "HOST/pylons/executions/item/{cookbookID}/{ID}?pagination.countTotal=false&pagination.reverse=true" -H  "accept: application/json"
```

Example Response:

```json
{
  "CompletedExecutions": [],
  "PendingExecutions": [],
  "pagination": {
    "next_key": null,
    "total": "0"
  }
}
```
#### list-executions-by-recipe

Request:

This query is shown with pagination options.


```bash
curl -X GET "HOST/pylons/executions/recipe/a/a?pagination.countTotal=true&pagination.reverse=false" -H  "accept: application/json"

```

Example Response:

```json
{
  "CompletedExecutions": [],
  "PendingExecutions": [],
  "pagination": {
    "next_key": null,
    "total": "0"
  }
}
```

#### get-item

Request:

```bash
curl -X GET "HOST/pylons/item/{cookbookID}/{ID}" -H  "accept: application/json"

```

Example Response:

```json
{
  "Item": {
    "owner": "string",
    "cookbookID": "string",
    "ID": "string",
    "nodeVersion": "string",
    "doubles": [
      {
        "Key": "string",
        "Value": "string"
      }
    ],
    "longs": [
      {
        "Key": "string",
        "Value": "string"
      }
    ],
    "strings": [
      {
        "Key": "string",
        "Value": "string"
      }
    ],
    "mutableStrings": [
      {
        "Key": "string",
        "Value": "string"
      }
    ],
    "tradeable": true,
    "lastUpdate": "string",
    "transferFee": [
      {
        "denom": "string",
        "amount": "string"
      }
    ],
    "tradePercentage": "string"
  }
}
```

#### list-items-by-owner

This query is shown with pagination options.

Request:

```bash
curl -X GET "HOST/pylons/items/{address}?pagination.countTotal=true&pagination.reverse=true" -H  "accept: application/json"
```

Example Response:

```json
{
  "Items": [
    {
      "owner": "string",
      "cookbookID": "string",
      "ID": "string",
      "nodeVersion": "string",
      "doubles": [
        {
          "Key": "string",
          "Value": "string"
        }
      ],
      "longs": [
        {
          "Key": "string",
          "Value": "string"
        }
      ],
      "strings": [
        {
          "Key": "string",
          "Value": "string"
        }
      ],
      "mutableStrings": [
        {
          "Key": "string",
          "Value": "string"
        }
      ],
      "tradeable": true,
      "lastUpdate": "string",
      "transferFee": [
        {
          "denom": "string",
          "amount": "string"
        }
      ],
      "tradePercentage": "string"
    }
  ],
  "pagination": {
    "nextKey": "string",
    "total": "string"
  }
}

```

### get-trade

Request:

```bash
curl -X GET "HOST/pylons/trade/{ID}" -H  "accept: application/json"
```

Example Response:

```json
{
  "Trade": {
    "creator": "string",
    "ID": "string",
    "coinInputs": [
      {
        "coins": [
          {
            "denom": "string",
            "amount": "string"
          }
        ]
      }
    ],
    "itemInputs": [
      {
        "ID": "string",
        "doubles": [
          {
            "key": "string",
            "minValue": "string",
            "maxValue": "string"
          }
        ],
        "longs": [
          {
            "key": "string",
            "minValue": "string",
            "maxValue": "string"
          }
        ],
        "strings": [
          {
            "key": "string",
            "value": "string"
          }
        ],
        "conditions": {
          "doubles": [
            {
              "key": "string",
              "minValue": "string",
              "maxValue": "string"
            }
          ],
          "longs": [
            {
              "key": "string",
              "minValue": "string",
              "maxValue": "string"
            }
          ],
          "strings": [
            {
              "key": "string",
              "value": "string"
            }
          ]
        }
      }
    ],
    "coinOutputs": [
      {
        "denom": "string",
        "amount": "string"
      }
    ],
    "itemOutputs": [
      {
        "cookbookID": "string",
        "itemID": "string"
      }
    ],
    "extraInfo": "string",
    "receiver": "string",
    "tradedItemInputs": [
      {
        "cookbookID": "string",
        "itemID": "string"
      }
    ]
  }
}
```

#### get-google-iap-order

Request:

```bash
curl -X GET "HOST/pylons/iap/{purchaseToken}" -H  "accept: application/json"
```

Example Response:

```json
{
  "Order": {
    "creator": "string",
    "productID": "string",
    "purchaseToken": "string",
    "receiptDataBase64": "string",
    "signature": "string"
  }
}
```

