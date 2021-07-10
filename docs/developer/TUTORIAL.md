# Introduction

Pylons SDK can be used for blockchain game developers to build their own games that run on blockchain involving game characters and items.

This document is basic tutorial for beginners.
For more detailed and deeper tutorial, please check [developer doc](https://github.com/Pylons-tech/pylons_sdk/blob/master/DEVELOPER_DOC.md).

Important points in pylons SDK are:

- item: Item is an important concept in Pylons sdk. It can simply be considered as the items in original games. Items will have properties in the format of Double, String, Integer etc. Characters can be created as items either.
- recipe: in this sdk, recipes will decide and generate everything like item generation and modification, combination of items. Recipes can be used to get result of some action between items and characters. Every action related to items are taken by recipes.
- trade: Pylons SDK enables accounts to trade their coins themselves. Trade includes items - items trading, coins - coins trading and mixed trading.

It's helpful if you know something about `cosmos-sdk` as our Pylons is based on [cosmos-sdk](https://cosmos.network/sdk).

# Setup Local Environment

## Install Golang
  
Refer to the [technical setup page](../TECHNICAL-SETUP.md) for instructions.

## Start pylons daemon

You need to start pylons daemon to make the sdk work. Download binary files for `pylonsd` and copy this into GOPATH/bin.
And run the following command.

```
cd PATH/TO/pylons_sdk
sh init_accounts.local.sh
pylonsd start
```

`init_accounts.local.sh` will create initial test accounts named `node0`, `michael`, `eugen`. These accounts will be used in cli tests.

# CLI commands

Now you are ready to use cli commands. Open a new terminal window other than the pylons daemon terminal window. Try to run the pylonsd command.

```
pylonsd
```
This command will give you the overall help for all available commands in pylonsd.
The result should be like the following.

```
The Pylons Client

Usage:
  pylonsd [command]

Available Commands:
  status      Query remote node for status
  config      Create or query an application CLI configuration file
  query       Querying subcommands
  tx          Transactions subcommands
              
  rest-server Start LCD (light-client daemon), a local REST server
              
  keys        Add or view local private keys
              
  help        Help about any command

Flags:
      --chain-id string          Chain ID of tendermint node
  -e, --encoding string          Binary encoding (hex|b64|btc) (default "hex")
  -h, --help                     help for pylonsd
      --home string              directory for config and data (default "/Users/ghostprince/.pylonsd")
      --keyring-backend string   keyring backend of tendermint node
  -o, --output string            Output format (text|json) (default "text")
      --trace                    print out full stack trace on errors

Use "pylonsd [command] --help" for more information about a command.
```

Now let's move forward with some important cli commands one by one.

All the pylpylonsdonscli commands require user password for keyring-backend. 
If you set `--keyring-backend=test` flag, it use testing keyring and which does not require password, on our tutorial, we will be using test keyring for most of the commands.

### Local keys

`pylonsd keys` command will let you add or view local keys in the chain.

- Add your first local key
  ```
  pylonsd keys add jack --keyring-backend=test
  ```

  You can replace the local key that is set `jack` in the example with any key you want.

  This command will create a local key with the name given as the argument. The result will be like following.

  ```
  {
    "name": "jack",
    "type": "local",
    "address": "cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm7",
    "pubkey": "cosmospub1addwnpepqv6ppfkfu7cm62a2n3qfjr6r2h5dcssrywly59n699v9g6gykccq55hzewf",
    "mnemonic": "choose crater shift until worth wasp win pilot again piece canyon habit mercy come crisp next captain street horn inmate word vapor cake pledge"
  }
  ```

  The `address` value `cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm7` will be used for the other cli commands.

- Show the local key
  ```
  pylonsd keys show jack --keyring-backend=test
  ```
  This will show the info of the local key `jack` that is just added.
  The result will be like following.
  ```
  {
    "name": "jack",
    "type": "local",
    "address": "cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm7",
    "pubkey": "cosmospub1addwnpepqv6ppfkfu7cm62a2n3qfjr6r2h5dcssrywly59n699v9g6gykccq55hzewf"
  }
  ```
  **Warn**  
  If you don't set keyring backend like `pylonsd keys show jack` it will default keyring as `os` and will require your computer password. But in the end, keys are not stored in os backend, it will not show you the same key that is created right now.

- List all the keys available
  ```
  pylonsd keys list --keyring-backend=test
  ```
  This command will list all the local keys that are available in the chain.
  The result will be like the following.
  ```
  [
    {
      "name": "eugen",
      "type": "local",
      "address": "cosmos1g5w79thfvt86m6cpa0a7jezfv0sjt0u7y09ldm",
      "pubkey": "cosmospub1addwnpepqgmz48l2urqa69zd9djrah2qlc4u7n6gp98ch3ydkyfpm78ktn6xuf7w2rh"
    },
    {
      "name": "michael",
      "type": "local",
      "address": "cosmos1k6qm04kxkz7q69lhy80jf562y8d5rj66y8g8t2",
      "pubkey": "cosmospub1addwnpepqdap2dhf7aj98mgewqjn94t9gfujt4k8u3ztdyeaqsaslfd98eqr2ed8z55"
    },
    {
      "name": "node0",
      "type": "local",
      "address": "cosmos13p8890funv54hflk82ju0zv47tspglpk373453",
      "pubkey": "cosmospub1addwnpepq2ht7s5t3kp7058w2kntx9ha8av396xv78nhs6lszqtcwtf6kwdm20axerv"
    },
    {
      "name": "jack",
      "type": "local",
      "address": "cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm7",
      "pubkey": "cosmospub1addwnpepqv6ppfkfu7cm62a2n3qfjr6r2h5dcssrywly59n699v9g6gykccq55hzewf"
    }
  ]
  ```

### Create an account on chain

We already added key on local. But this does not mean that this account is registerd on pylons chain. Now we can register an account with the key added.

We can use `pylonsd tx pylons create-account` command for this.

```
pylonsd tx pylons create-account --from cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm7 --keyring-backend=test
```

For the `from` flag, you should give the address of the key genereated. We used the address of `jack` key.

Press `y` for the confirm line.

The result should be like the following.

```
{
  "chain_id": "pylonschain",
  "account_number": "0",
  "sequence": "0",
  "fee": {
    "amount": [],
    "gas": "200000"
  },
  "msgs": [
    {
      "type": "pylons/CreateAccount",
      "value": {
        "Requester": "cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm7"
      }
    }
  ],
  "memo": ""
}

confirm transaction before signing and broadcasting [y/N]: y
{
  "height": "0",
  "txhash": "D0C59E5F5255B706ACCD42FBE69F168758F82683C6BA4A3BD86CB8B45CC34D7C",
  "raw_log": "[]"
}
```

### Get test pylon coins for the created account

`pylon` is basic token on pylons ecosystem and the account should have some amount of `pylon`. 

We can use `pylonsd tx pylons get-pylons` command to get some `pylon`. 
This is for test and on mainnet, this feature will not be available. Instead there's a method called Google IAP get pylons that buy pylons by paying from google play account.

```
pylonsd tx pylons get-pylons --amount 500000 --from cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm7 --keyring-backend=test
```
`from` flag sets the address of the account to get pylons and `amount` flag sets the amount of `pylon` to get. In this command, we are getting 500 pylons for the account `jack`. You should press `y` to the confirmation line.

The result will be like the following.

```
{
  "chain_id": "pylonschain",
  "account_number": "8",
  "sequence": "3",
  "fee": {
    "amount": [],
    "gas": "200000"
  },
  "msgs": [
    {
      "type": "pylons/GetPylons",
      "value": {
        "Amount": [
          {
            "denom": "pylon",
            "amount": "500000"
          }
        ],
        "Requester": "cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm7"
      }
    }
  ],
  "memo": ""
}

confirm transaction before signing and broadcasting [y/N]: y
{
  "height": "0",
  "txhash": "E7A728AD9A3C49DF1B8FDD077A50800F58C200FF5F2EC68675F8AFD4D69FF876",
  "raw_log": "[]"
}
```

### Create cookbook

A cookbook is a game. And to build recipes and items, you need to have cookbooks.

`pylonsd tx sign` command will be used to create signature for cookbook. This command let you sign transactions before broadcast.

Create a new json file in your local folder and name it `tx_cook.json`. Write cookbook information in the json file. Sample cookbook json is like the following.

```
{
  "type": "cosmos-sdk/StdTx",
  "value": {
    "msg": [
      {
        "type": "pylons/CreateCookbook",
        "value": {
          "CookbookID": "<Unique id for this cookbook, it's optional>",
          "Name": "<Name of the cookbook>",
          "Description": "<Description>",
          "Developer": "<Developer name>",
          "Level": "0",
          "Sender": "<Address for the owner account>",
          "SupportEmail": "<Support email>",
          "Version": "1.0.0",
          "CostPerBlock": "50"
        }
      }
    ],
    "fee": {
      "amount": [],
      "gas": "200000"
    },
    "signatures": null,
    "memo": ""
  }
}
```

For the owner account of this cookbook, we can use the `jack` account we created above.
The address of the `jack` account is `cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm7`.
So let's replace `<Address for the sender account>` with `cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm7`.

```
pylonsd tx sign tx_cook.json --from jack --keyring-backend=test > tx_cook_signed.json
```
This command signs the transaction written in the `tx_cook.json` file and creates `tx_cook_signed.json` file with the signed transaction result. It will include `signature` field.

The content of `tx_cook_signed.json` will be like the following.

```
{
  "type": "cosmos-sdk/StdTx",
  "value": {
    "msg": [
      {
        "type": "pylons/CreateCookbook",
        "value": {
          "CookbookID": "LOUD-v0.1.0-1579053457",
          "Name": "Legend of Undead Dragon",
          "Description": "This is prototype game built to run on pylons eco system.",
          "Version": "1.0.0",
          "Developer": "Pylons/LOUD Team",
          "SupportEmail": "stalepresh121@outlook.com",
          "Level": "0",
          "Sender": "cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm7",
          "CostPerBlock": "50"
        }
      }
    ],
    "fee": {
      "amount": [],
      "gas": "200000"
    },
    "signatures": [
      {
        "pub_key": {
          "type": "tendermint/PubKeySecp256k1",
          "value": "AzQQpsnnsb0rqpxAmQ9DVejcQgMjvkoWeilYVGkEtjAK"
        },
        "signature": "CYFNq94GXXobyVO/8Yq+rxmUqYVgK2soJT/zZsJ/5OBIr3h+9FSJWfVn3IScOzECzXewGChXyPZlVjv2nw5s2g=="
      }
    ],
    "memo": ""
  }
}
```

After the signature is created, you should broadcast this transaction to the chain.
```
pylonsd tx broadcast tx_cook_signed.json 
```
The result will be like the following.
```
{
  "height": "0",
  "txhash": "D2DCBAEAB99CD8CA627F5A7C987A72C7B5D30458D2768DA09B2088CCB9BDA524",
  "raw_log": "[]"
}
```

You need to wait more than 1 block until this transaction to be confirmed.

To check the created cookbook we can use `pylonsd query pylons list_cookbook` command.

```
pylonsd query pylons list_cookbook
```

You can check if your cookbook is listed in the result.

The result will be like the following:
```
{
  "Cookbooks": [
    {
      "NodeVersion": "0.0.1",
      "ID": "LOUD-v0.1.0-1579053457",
      "Name": "Legend of Undead Dragon",
      "Description": "This is prototype game built to run on pylons eco system.",
      "Version": "1.0.0",
      "Developer": "Pylons/LOUD Team",
      "Level": "0",
      "SupportEmail": "stalepresh121@outlook.com",
      "CostPerBlock": "50",
      "Sender": "cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm7"
    }
  ]
}
```

### Create recipe

Recipe defines actions like generate items and modify items, generate coins etc.

First, create `tx_recipe.json` file and write recipe json in the file.
Sample transaction is similar to the following.

```
{
  "type": "cosmos-sdk/StdTx",
  "value": {
    "msg": [
      {
        "type": "pylons/CreateRecipe",
        "value": {
          "RecipeID": "<ID of the recipe>",
          "Name": "<Name of the recipe>",
          "CookbookID": "<Cookbook ID to be used in the recipe>",
          "CoinInputs": [
            {
              "Coin": "pylon",
              "Count": 1
            }
          ],
          "ItemInputs": null,
          "Entries": {
            "CoinOutputs": null,
            "ItemModifyOutputs": null,
            "ItemOutputs": [
              {
                "Doubles": [
                  {
                    "Rate": "1",
                    "Key": "Mass",
                    "WeightRanges": [
                      {
                        "Lower": "50",
                        "Upper": "100",
                        "Weight": 1
                      }
                    ],
                    "Program": ""
                  }
                ],
                "Longs": null,
                "Strings": [
                  {
                    "Rate": "1",
                    "Key": "Name",
                    "Value": "Mars",
                    "Program": ""
                  }
                ],
                "TransferFee": 0
              }
            ]
          },
          "Outputs": [
            {
              "ResultEntries": [
                "0"
              ],
              "Weight": "1"
            }
          ],
          "BlockInterval": 2,
          "Sender": "<Address of the sender account>",
          "Description": "<Recipe description>"
        }
      }
    ],
    "fee": {
      "amount": [],
      "gas": "200000"
    },
    "signatures": null,
    "memo": ""
  }
}
```

The progress to create recipe is similar to cookbook.

```
pylonsd tx sign tx_recipe.json --from jack --keyring-backend=test > tx_recipe_signed.json
pylonsd tx broadcast tx_recipe_signed.json 
```

The content of the `tx_recipe_signed.json` will be like the following.

```
{
  "type": "cosmos-sdk/StdTx",
  "value": {
    "msg": [
      {
        "type": "pylons/CreateRecipe",
        "value": {
          "RecipeID": "RTEST_1596078885",
          "Name": "RTEST_1596078885",
          "CookbookID": "LOUD-v0.1.0-1579053457",
          "CoinInputs": [
            {
              "Coin": "pylon",
              "Count": 1
            }
          ],
          "ItemInputs": null,
          "Entries": {
            "CoinOutputs": null,
            "ItemModifyOutputs": null,
            "ItemOutputs": [
              {
                "Doubles": [
                  {
                    "Rate": "1",
                    "Key": "Mass",
                    "WeightRanges": [
                      {
                        "Lower": "50",
                        "Upper": "100",
                        "Weight": 1
                      }
                    ],
                    "Program": ""
                  }
                ],
                "Longs": null,
                "Strings": [
                  {
                    "Rate": "1",
                    "Key": "Name",
                    "Value": "Mars",
                    "Program": ""
                  }
                ],
                "TransferFee": 0
              }
            ]
          },
          "Outputs": [
            {
              "ResultEntries": [
                "0"
              ],
              "Weight": "1"
            }
          ],
          "BlockInterval": 2,
          "Sender": "cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm7",
          "Description": "test recipe from test suite"
        }
      }
    ],
    "fee": {
      "amount": [],
      "gas": "200000"
    },
    "signatures": [
      {
        "pub_key": {
          "type": "tendermint/PubKeySecp256k1",
          "value": "AzQQpsnnsb0rqpxAmQ9DVejcQgMjvkoWeilYVGkEtjAK"
        },
        "signature": "e9q8Cck+k+3WIFGAw/vREa6vV2dAbMSqbYjjrWB3O613j77KkkYn4Bgk7hnBKpRiywzob994i6/20PGHkzIL6A=="
      }
    ],
    "memo": ""
  }
}
```

The result of the broadcast command will be like the following.

```
{
  "height": "0",
  "txhash": "19A6F66F3E8FB9843BF60B26C6CA7CC970CFB8A033C035C49AC883C6293C3525",
  "raw_log": "[]"
}
```

You can check the created recipe with `list_recipe` command.

```
pylonsd query pylons list_recipe
```

The result of this command will be like the following:

```
{
  "Recipes": [
    {
      "NodeVersion": "0.0.1",
      "ID": "RTEST_1596078885",
      "CookbookID": "LOUD-v0.1.0-1579053457",
      "Name": "RTEST_1596078885",
      "CoinInputs": [
        {
          "Coin": "pylon",
          "Count": 1
        }
      ],
      "ItemInputs": null,
      "Entries": {
        "CoinOutputs": null,
        "ItemModifyOutputs": null,
        "ItemOutputs": [
          {
            "Doubles": [
              {
                "Rate": "1",
                "Key": "Mass",
                "WeightRanges": [
                  {
                    "Lower": "50",
                    "Upper": "100",
                    "Weight": 1
                  }
                ],
                "Program": ""
              }
            ],
            "Longs": null,
            "Strings": [
              {
                "Rate": "1",
                "Key": "Name",
                "Value": "Mars",
                "Program": ""
              }
            ],
            "TransferFee": 0
          }
        ]
      },
      "Outputs": [
        {
          "ResultEntries": [
            "0"
          ],
          "Weight": "1"
        }
      ],
      "Description": "test recipe from test suite",
      "BlockInterval": 2,
      "Sender": "cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm7",
      "Disabled": false
    }
  ]
}
```

### Execute the recipe

The recipe is created. We need to execute the created recipe now.

To execute recipe, we need to sign execute transaction. Create `tx_execte.json`

```
{
  "type": "cosmos-sdk/StdTx",
  "value": {
    "msg": [
      {
        "type": "pylons/ExecuteRecipe",
        "value": {
          "RecipeID": "<ID of the recipe to execute>",
          "Sender": "<Address of the sender>",
          "Items": []
        }
      }
    ],
    "fee": {
      "amount": [],
      "gas": "200000"
    },
    "signatures": null,
    "memo": ""
  }
}
```

The signature and broadcast commands are the same.

```
pylonsd tx sign tx_execute.json --from jack --keyring-backend=test > tx_execute_signed.json
pylonsd tx broadcast tx_execute_signed.json
```

The content of `tx_execute_signed.json` will be like the following:
```
{
  "type": "cosmos-sdk/StdTx",
  "value": {
    "msg": [
      {
        "type": "pylons/ExecuteRecipe",
        "value": {
          "RecipeID": "RTEST_1596078885",
          "Sender": "cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm7",
          "ItemIDs": null
        }
      }
    ],
    "fee": {
      "amount": [],
      "gas": "200000"
    },
    "signatures": [
      {
        "pub_key": {
          "type": "tendermint/PubKeySecp256k1",
          "value": "AzQQpsnnsb0rqpxAmQ9DVejcQgMjvkoWeilYVGkEtjAK"
        },
        "signature": "hxRkTt//Jo5yEFtGlXwWr8erX62xq3AgHMokKtvHR9tEFozargpbiinQ9IVmcaeT6Nna8bTO6FUR7iMfrxNVrg=="
      }
    ],
    "memo": ""
  }
}
```

Check the created execute with `list_executions` command.

```
pylonsd query pylons list_executions
```

The result will be like the following:

```
{
  "Executions": [
    {
      "NodeVersion": "0.0.1",
      "ID": "cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm71f81f466-cbab-4a48-b763-76e1ba1d359c",
      "RecipeID": "RTEST_1596078885",
      "CookbookID": "LOUD-v0.1.0-1579053457",
      "CoinInputs": [
        {
          "denom": "pylon",
          "amount": "1"
        }
      ],
      "ItemInputs": null,
      "BlockHeight": "4346",
      "Sender": "cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm7",
      "Completed": false
    }
  ]
}
```

### Check execution

Now the execution is created. Execution is only created when block interval of recipe is more than 1.
To run this execution, we should run check_excution for the execution ID.
Create `tx_check.json` file and write check execution transaction.

```
{
  "type": "cosmos-sdk/StdTx",
  "value": {
    "msg": [
      {
        "type": "pylons/CheckExecution",
        "value": {
          "ExecID": "<ID of the execution>",
          "Sender": "<Address of the sender>",
          "PayToComplete": true
        }
      }
    ],
    "fee": {
      "amount": [],
      "gas": "200000"
    },
    "signatures": null,
    "memo": ""
  }
}
```

Run commands to sign and broadcast the transaction.

```
pylonsd tx sign tx_check.json --from jack --keyring-backend=test > tx_check_signed.json
pylonsd tx broadcast tx_check_signed.json
```

The content of `tx_check_signed.json` will be like the following:

```
{
  "type": "cosmos-sdk/StdTx",
  "value": {
    "msg": [
      {
        "type": "pylons/CheckExecution",
        "value": {
          "ExecID": "cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm71f81f466-cbab-4a48-b763-76e1ba1d359c",
          "Sender": "cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm7",
          "PayToComplete": true
        }
      }
    ],
    "fee": {
      "amount": [],
      "gas": "200000"
    },
    "signatures": [
      {
        "pub_key": {
          "type": "tendermint/PubKeySecp256k1",
          "value": "AzQQpsnnsb0rqpxAmQ9DVejcQgMjvkoWeilYVGkEtjAK"
        },
        "signature": "HE+R3XNhcCLyKqvAI7B1F3TibP0yutBmV2XupJ+ImhIavyqmSmUbsB3LJFGfNKLkpJvW6sFgF4t7YZ6Wp1e98Q=="
      }
    ],
    "memo": ""
  }
}
```

The result of the broadcast command will be like the following:
```
{
  "height": "0",
  "txhash": "581D71778742BFE506F65222AA712749FA1FEBCE2265DF2F65F60509736D866A",
  "raw_log": "[]"
}
```

You can check if the execution's already completed with `list_executions` command .

```
pylonsd query pylons list_executions
```

The result will be like the following:
```
{
  "Executions": [
    {
      "NodeVersion": "0.0.1",
      "ID": "cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm71f81f466-cbab-4a48-b763-76e1ba1d359c",
      "RecipeID": "RTEST_1596078885",
      "CookbookID": "LOUD-v0.1.0-1579053457",
      "CoinInputs": [
        {
          "denom": "pylon",
          "amount": "1"
        }
      ],
      "ItemInputs": null,
      "BlockHeight": "4346",
      "Sender": "cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm7",
      "Completed": true
    }
  ]
}
```

Check if the `Completed` field is updated to `true`.

To get the result of executed transaction, you can use `pylonsd query tx <txHash>` command.
Set the `txHash` arg as the txHash field you get from the broadcast command.

```
pylonsd query tx 581D71778742BFE506F65222AA712749FA1FEBCE2265DF2F65F60509736D866A
```

The result will be like the following:

```
{
  "height": "4455",
  "txhash": "581D71778742BFE506F65222AA712749FA1FEBCE2265DF2F65F60509736D866A",
  "data": "7B224D657373616765223A227375636365737366756C6C7920636F6D706C657465642074686520657865637574696F6E222C22537461747573223A2253756363657373222C224F7574707574223A225733736964486C775A534936496B6C55525530694C434A6A62326C75496A6F69496977695957317664573530496A6F774C434A7064475674535551694F694A6A62334E7462334D785A6E56754F47786C4D6D5234636D4E73636A597A4D33427A646A646E613255326433527365574E31626D35744F475273625463344F5759314F5749784E4330354F4449334C545132597A597459574D354E4330785A446C69595451785A6A49784D5441696656303D227D",
  "raw_log": "[{\"msg_index\":0,\"log\":\"\",\"events\":[{\"type\":\"message\",\"attributes\":[{\"key\":\"action\",\"value\":\"check_execution\"}]}]}]",
  "logs": [
    {
      "msg_index": 0,
      "log": "",
      "events": [
        {
          "type": "message",
          "attributes": [
            {
              "key": "action",
              "value": "check_execution"
            }
          ]
        }
      ]
    }
  ],
  "gas_wanted": "200000",
  "gas_used": "95805",
  "tx": {
    "type": "cosmos-sdk/StdTx",
    "value": {
      "msg": [
        {
          "type": "pylons/CheckExecution",
          "value": {
            "ExecID": "cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm71f81f466-cbab-4a48-b763-76e1ba1d359c",
            "Sender": "cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm7",
            "PayToComplete": true
          }
        }
      ],
      "fee": {
        "amount": [],
        "gas": "200000"
      },
      "signatures": [
        {
          "pub_key": {
            "type": "tendermint/PubKeySecp256k1",
            "value": "AzQQpsnnsb0rqpxAmQ9DVejcQgMjvkoWeilYVGkEtjAK"
          },
          "signature": "HE+R3XNhcCLyKqvAI7B1F3TibP0yutBmV2XupJ+ImhIavyqmSmUbsB3LJFGfNKLkpJvW6sFgF4t7YZ6Wp1e98Q=="
        }
      ],
      "memo": ""
    }
  },
  "timestamp": "2020-07-31T18:06:05Z"
}
```

In this result, `data` field contains the result of the transaction as hex format. You can convert the hex data into string if you want to see the result.

You can use online [hex to string converter](https://codebeautify.org/hex-string-converter).

In the above example, the data is the following.

```
{
  "Message": "successfully completed the execution",
  "Status": "Success",
  "Output": "W3sidHlwZSI6IklURU0iLCJjb2luIjoiIiwiYW1vdW50IjowLCJpdGVtSUQiOiJjb3Ntb3MxZnVuOGxlMmR4cmNscjYzM3Bzdjdna2U2d3RseWN1bm5tOGRsbTc4OWY1OWIxNC05ODI3LTQ2YzYtYWM5NC0xZDliYTQxZjIxMTAifV0="
}
```

The output has more details and it's in base64. It's all managed by amino codec. Sorry for inconvenience.
If you decode the base64 output into string via [base64 decoder](https://www.base64decode.org)

```
[{"type":"ITEM","coin":"","amount":0,"itemID":"cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm789f59b14-9827-46c6-ac94-1d9ba41f2110"}]
```

### Create Trade

Let's try trading between accounts.  
Create `tx_trade.json` file and write create trade msg in the file.

```
{
  "type": "cosmos-sdk/StdTx",
  "value": {
    "msg": [
      {
        "type": "pylons/CreateTrade",
        "value": {
          "CoinInputs":[
              {
                  "Coin": "pylon",
                  "Count": 10
              }
          ],
          "ItemInputRefs": [],
          "CoinOutputs": [{
              "denom":"pylon",
              "amount": "200"
          }],
          "ItemOutputNames": [],
          "ExtraInfo":"coin to coin trading",
          "Sender":"cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm7"
        }
      }
    ],
    "fee": {
      "amount": [],
      "gas": "200000"
    },
    "signatures": null,
    "memo": ""
  }
}
```

`Sender` field defines the creator of this trade. We use `jack` account's address in this file.

In this example, the trade creator will send 200 pylon to the fulfiller and get 10 pylon for that. It's simple coin-coin trade.

Run the same commands to sign and broadcast transactions.

```
pylonsd tx sign tx_trade.json --from jack --keyring-backend=test > tx_trade_signed.json
pylonsd tx broadcast tx_trade_signed.json 
```

The content of the `tx_trade_signed.json` file will be like the following:
```
{
  "type": "cosmos-sdk/StdTx",
  "value": {
    "msg": [
      {
        "type": "pylons/CreateTrade",
        "value": {
          "CoinInputs": [
            {
              "Coin": "pylon",
              "Count": 10
            }
          ],
          "ItemInputs": null,
          "CoinOutputs": [
            {
              "denom": "pylon",
              "amount": "200"
            }
          ],
          "ItemOutputs": null,
          "ExtraInfo": "coin to coin trading",
          "Sender": "cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm7"
        }
      }
    ],
    "fee": {
      "amount": [],
      "gas": "200000"
    },
    "signatures": [
      {
        "pub_key": {
          "type": "tendermint/PubKeySecp256k1",
          "value": "AzQQpsnnsb0rqpxAmQ9DVejcQgMjvkoWeilYVGkEtjAK"
        },
        "signature": "qvvZswRWr4nmmRzftMyT6GNz9+5WSOwVsVXvQk1P0PlIL0li2yty5BIscdFM2OgU8zbEHXAK5EBTw8Wn0zMJjA=="
      }
    ],
    "memo": ""
  }
}
```

You can check the created trade with `list_trade` cli command.

```
pylonsd query pylons list_trade
```

The result will be like the following: 
```
{
  "Trades": [
    {
      "NodeVersion": "0.0.1",
      "ID": "cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm7bb9dfffb-6969-4626-960a-0689e3d37de1",
      "CoinInputs": [
        {
          "Coin": "pylon",
          "Count": 10
        }
      ],
      "ItemInputs": null,
      "CoinOutputs": [
        {
          "denom": "pylon",
          "amount": "200"
        }
      ],
      "ItemOutputs": null,
      "ExtraInfo": "coin to coin trading",
      "Sender": "cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm7",
      "FulFiller": "",
      "Disabled": false,
      "Completed": false
    }
  ]
}
```

Now we've successfully created the trade. It's time to fulfill this trade.

### Fulfill Trade

From the above `list_trade` cli, you need to keep `ID` field of the trade. We will make fulfill trade with this ID.

The ID is `cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm7bb9dfffb-6969-4626-960a-0689e3d37de1`

We will use `eugen` account which is created by `init_accounts.local.sh` file at first. The address of `eugen` account is `cosmos1g5w79thfvt86m6cpa0a7jezfv0sjt0u7y09ldm`.

Create `tx_fulfill_trade.json` file and write fulfill trade msg in the file.

```
{
  "type": "cosmos-sdk/StdTx",
  "value": {
    "msg": [
      {
        "type": "pylons/FulfillTrade",
        "value": {
          "TradeID": "cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm7bb9dfffb-6969-4626-960a-0689e3d37de1",
          "Sender":"cosmos1g5w79thfvt86m6cpa0a7jezfv0sjt0u7y09ldm",
          "ItemIDs": []
        }
      }
    ],
    "fee": {
      "amount": [],
      "gas": "200000"
    },
    "signatures": null,
    "memo": ""
  }
}
```

We gave the `TradeID` as the ID of the trade we've created and `Sender` as the address of `eugen` account.

We don't trade items in this example, so `ItemIDs` is set empty.

Run the commands to sign and broadcast the transaction.

```
pylonsd tx sign tx_fulfill_trade.json --from eugen --keyring-backend=test > tx_fulfill_trade_signed.json
pylonsd tx broadcast tx_fulfill_trade_signed.json 
```

The content of the `tx_fulfill_trade_signed.json` file will be like the following:

```
{
  "type": "cosmos-sdk/StdTx",
  "value": {
    "msg": [
      {
        "type": "pylons/FulfillTrade",
        "value": {
          "TradeID": "cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm7bb9dfffb-6969-4626-960a-0689e3d37de1",
          "Sender": "cosmos1g5w79thfvt86m6cpa0a7jezfv0sjt0u7y09ldm",
          "ItemIDs": null
        }
      }
    ],
    "fee": {
      "amount": [],
      "gas": "200000"
    },
    "signatures": [
      {
        "pub_key": {
          "type": "tendermint/PubKeySecp256k1",
          "value": "AjYqn+rgwd0UTStkPt1A/ivPT0gJT4vEjbESHfj2XPRu"
        },
        "signature": "u3I477UJLgjErVRI1TP9rZXPwQG9jxLS9T/5bQmoM5gG4u5KWLi36IA09a1ynQs2nB5rCL8g9un9BVJVf5YZWQ=="
      }
    ],
    "memo": ""
  }
}
```

After you run the commands, you can check the `list_trade` cli again to check if the transaction is completed.

```
{
  "Trades": [
    {
      "NodeVersion": "0.0.1",
      "ID": "cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm7bb9dfffb-6969-4626-960a-0689e3d37de1",
      "CoinInputs": [
        {
          "Coin": "pylon",
          "Count": 10
        }
      ],
      "ItemInputs": null,
      "CoinOutputs": [
        {
          "denom": "pylon",
          "amount": "200"
        }
      ],
      "ItemOutputs": null,
      "ExtraInfo": "coin to coin trading",
      "Sender": "cosmos1fun8le2dxrclr633psv7gke6wtlycunnm8dlm7",
      "FulFiller": "cosmos1g5w79thfvt86m6cpa0a7jezfv0sjt0u7y09ldm",
      "Disabled": false,
      "Completed": true
    }
  ]
}
```

You can check if `FulFiller` field is set and `Completed` field is set true.

So the trade is fulfilled correctly.

Now you have successfully executed the recipe, trades and you probably understood pylons about 30%.
And you are ready to go into the deep level of pylons ecosystem.

## Conclusion

Please suggest some feedbacks on this document from game developer's perspective before going into more details.
