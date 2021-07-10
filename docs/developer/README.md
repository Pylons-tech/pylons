# Introduction

🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿

The Pylons ecosystem consists of cookbooks, recipes, items, coins, and trades.

This document describes how to use cookbooks, recipes, items, coins, and trades that are compatible with the Pylons ecosystem.

Usually, a cookbook contains all of the recipes and items that are used for the game. The game corresponds to Cookbook 1:1.

Developers create a cookbook along with recipes and the item that is used in the game. 

The recipe can be used to buy items, upgrade items, and merge two items into one. A recipe can also be used to exchange coins, sell items, and trade items between users. 

Players own items, coins, and trade orders. Recipes can be executed only if the user meets the recipe conditions.

Since Pylons is a blockchain-based system, running a recipe takes more than 1 block time. As a developer, consider these factors when writing cookbooks, recipes, and items for your game.

## Cookbook

A cookbook consists of the following fields. The table was generated with the Markdown [Table generator](https://www.tablesgenerator.com/markdown_tables).

| No | Field        | Type   | Sample                                         | Description                                                                                |
|----|--------------|--------|------------------------------------------------|--------------------------------------------------------------------------------------------|
| 1  | NodeVersion  | string | "0.0.1"                                        | NodeVersion is available for all pylons entities like items, recipes, trades etc.          |
| 2  | ID           | string | "submarine-1589853709"                         | ID is the unique identifier of cookbook. This is unique across whole eco system.           |
| 3  | Name         | string | "submarine"                                    | Name of game.                                                                              |
| 4  | Description  | string | "Submarine game is a type of exploration game" | Description of game.                                                                       |
| 5  | Version      | SemVer | "1.0.0"                                        | Version of game.                                                                           |
| 6  | Developer    | string | "SketchyCo"                                    | Developer who created game.                                                                |
| 7  | SupportEmail | Email  | "example@example.com"                          | Email of this game supporter.                                                              |
| 8  | Level        | Level  | "0"                                            | level of this game.                                                                        |
| 9  | Sender       | string | "eugen"                                        | game creator user on pylons eco system.                                                    |
| 10 | CostPerBlock | int    | 2                                              | Pylons per block to charge across this cookbook for delayed execution or early completion |

Sample Cookbook in JSON format:

```json
{
  "NodeVersion": "0.0.1",
  "ID": "submarine-1589853709",
  "Name": "submarine",
  "Description": "this has to meet character limits lol",
  "Developer": "SketchyCo",
  "Level": "0",
  "Sender": "eugen",
  "SupportEmail": "example@example.com",
  "Version": "1.0.0",
  "CostPerBlock": "50"
}
```
### Email Validation Rule

We accept emails that match this `^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z0-9]{2,})$` regular expression pattern.

### Item

An `item` consists of the following fields:


| No | Field         | Type   | Sample                                | Description                                                                       |
|----|---------------|--------|---------------------------------------|-----------------------------------------------------------------------------------|
| 1  | NodeVersion   | string | "0.0.1"                               | NodeVersion is available for all Pylons entities including items, recipes, trades, and so on |
| 2  | ID            | string | "cosmos1yjrrrgt0xfqau9fz3vu6tlm3XXX"  | The unique identifier of cookbook. Must be unique across entire ecosystem.  |
| 3  | CookbookID    | string | "submarine-3942525"                   | The name of cookbook for the item.                                       |
| 4  | Sender        | string | "eugen"                               | The owner of item.                                                       |
| 5  | Doubles       | array  | defence: 1.0,  movement: 1.0          | Double attributes of the item.                                           |
| 6  | Longs         | array  | level: 1                              | Int attributes of the item.                                              |
| 7  | Strings       | array  | name: "shield", use: "defend and run" | String attributes of the item.                                           |
| 8  | OwnerRecipeID | string | ""                                    | Owner recipe id, if not owned, value is ""                               |
| 9  | OwnerTradeID  | string | ""                                    | Owner trade id, if not owned by trade, value is ""                       |
| 10 | Tradable      | bool   | true                                  | Item is tradable flag, always true in this version                               |
| 11 | LastUpdate    | int64  | 5649                                  | Latest update block height                                                        |
| 12 | TransferFee   | int64  | 0                                     | Fee for item transfer and item trade                           |


Sample `Item` in JSON format:

```json
{
  "NodeVersion": "0.0.1",
  "ID": "cosmos1yjrrrgt0xfqau9fz3vu6tlm380m7kjvqmzyd0scd8be417-3d63-4fcc-9fae-d9e98c498c55",
  "Doubles": [{ "Key": "defence", "Value": "1" }],
  "Longs": [{ "Key": "level", "Value": "1" }],
  "Strings": [{ "Key": "Name","Value": "Shield" }],
  "CookbookID": "submarine-3942525",
  "Sender": "eugen",
  "OwnerRecipeID": ""
  "OwnerTradeID": "",
  "Tradable": true,
  "LastUpdate": "5649",
  "TransferFee": 0
}
```

## Recipe

A `recipe` consists of the following fields:

| No | Field         | Type   | Sample                                                       | Description                                                                           |
|----|---------------|--------|--------------------------------------------------------------|---------------------------------------------------------------------------------------|
| 1  | NodeVersion   | string | "0.0.1"                                                      | NodeVersion is available for all pylons entities like cookbooks, recipes, trades, and so on. |
| 2  | ID            | string | "Submarine-knife-recipe-3942525"                             | The unique identifier of recipe, must be unique across entire ecosystem.        |
| 3  | CookbookID    | string | "submarine-3942525"                                          | contains the name of cookbook for the recipe.                                         |
| 4  | Name          | string | "Knife Shield Generation Recipe"                             | name of recipe.                                                                       |
| 5  | Description   | string | "level 1 knife and level 1 shield into level 1 knife-shield" | recipe description                                                                    |
| 6  | Sender        | string | "eugen"                                                      | recipe owner name.                                                                    |
| 7  | CoinInputs    | array  | "goldcoin": 1, "silvercoin": 1                               | required coins to run recipe.                                                         |
| 8  | ItemInputs    | array  | level 1 knife, level 1 shield                                | Items required to run recipe and upgrade an item.                    |
| 9  | Entries       | array  | level 1 knife-shield                                         | Items and coins that can be generated from this recipe.                              |
| 10 | Outputs       | array  | Weight: "100 - HP", Result: chararacter, coin                | The weighted list of results that can be output.                     |
| 11 | BlockInterval | int    | 2                                                            | Recipe is able to produce output after this BlockInterval time.                            |

Sample `Recipe` in JSON format:

```json
{
    "NodeVersion": "0.0.1",
    "ID": "Submarine-knife-shield-generation-recipe-v0.0.0-1583801800",
    "CoinInputs":[],
    "ItemInputs": [
        {
            "ID": "knife_lv1",
            "Ref": "./recipes/submarine/item_input/knife_lv1.json"
        },
        {
            "ID": "shield_lv1",
            "Ref": "./recipes/submarine/item_input/shield_lv1.json"
        }
    ],
    "Entries":{
        "CoinOutputs":[],
        "ItemOutputs":[
            {
                "ID": "knife_shield_lv1",
                "Ref": "./recipes/submarine/item_output/knife_shield_lv1.json"
            }
        ]
    },
    "Outputs": [
        {
            "EntryIDs": ["knife_shield_lv1"],
            "Weight": "1"
        }
    ],
    "Sender":"eugen",
    "Name": "Knife Shield Generation Recipe",
    "CookbookID": "submarine-3942525",
    "Description": "this recipe is merging level 1 knife and level 1 shield into level 1 knife-shield.",
    "BlockInterval":0
}
```

When creating the recipe, on `MsgCreateRecipe`, the `ID` field is optional.
If `ID` field is provided, the provided `ID` is used. If `ID` field is not provided, a new `ID` is generated.

### ItemInputs

This field defines the required items to run the recipe.

| No | Field        | type       | sample              | description                                    |
|----|--------------|------------|---------------------|------------------------------------------------|
| 1  | ID           | string     | "monster"           | required to reference on entries section.      |
| 2  | Doubles      | array      | "attack": 1         | required conditions for double attributes.     |
| 3  | Longs        | array      | "level": 1          | required conditions for int attributes.        |
| 4  | Strings      | array      | "name": "shield"    | required conditions for string attributes.     |
| 5  | TransferFee  | range      | 1-1000              | required condition for transfer fee range.     |

**Warning** `ID` of item input must be empty or fit this pattern: `^[a-zA-Z_][a-zA-Z_0-9]*$`.

| No | Field    | Type       | sample   | description                                                                         |
|----|----------|------------|----------|-------------------------------------------------------------------------------------|
| 1  | Key      | string     | "attack" | attribute of item to check.                                                         |
| 2  | Value    | string     | 1        | item's "Key" attribute shoud be same as this value.                                 |
| 3  | MinValue | int/double | 1        | For int/double values they are checked with range and this describes minimum value. |
| 4  | MaxValue | int/double | 2        | For int/double values they are checked with range and this describes maximum value. |

Sample `ItemInputs` in JSON format:

```json
[{
    "ID": "monster",
    "Doubles": [{"Key": "attack", "MinValue": "1.0", "MaxValue": "2000.0"}],
    "Longs": [{"Key": "level", "MinValue": 1, "MaxValue": 2000}],
    "Strings": [{"Key": "Name", "Value": "Monster"}],
    "TransferFee": {"MinValue": 1, "MaxValue": 2000}
}]
```

### CoinInputs

This field defines the coins required to run the recipe.

| No | Field | type   | sample     | description              |
|----|-------|--------|------------|--------------------------|
| 1  | Coin  | string | "goldcoin" | name of coin             |
| 2  | Count | int    | 1          | required amount of coin. |

Sample `CoinInputs` in JSON format:

```json
[{
    Coin: "goldcoin"
	Count: "1"
}]
```

### Entries

`Entries` consists of coin outputs and item outputs that allow the recipe to generate coins or items.

Sample `Entries` in JSON format:

```json
{
  "CoinOutputs":[],
  "ItemOutputs":[
    {
      "ID": "knife_shield_lv1",
      "Ref": "./recipes/item_output/knife_shield_lv1.json",
    }
  ]
}
```

**Warning** Recipes cannot generate Pylon denom as an output. 

`ID` of each entry must fit this pattern: `^[a-zA-Z_][a-zA-Z_0-9]*$` (coin output, item modify output, and item output).

### ItemOutputs

`ItemOutputs` describes the item that can be generated from the recipe.

| No | Field       | type   | sample                  | description                          |
|----|-------------|--------|-------------------------|--------------------------------------|
| 1  | ID          | string | knife_lv1               | ID to reference at output section    |
| 2  | Doubles     | range  | attack: 0.1-2.1,3.2-3.4 | describe double attributes           |
| 3  | Longs       | range  | level: 1-2,4-1000       | describe int attributes              |
| 4  | Strings     | range  | Name: "Knife"           | describe string attributes           |
| 5  | TransferFee | int    | 1000                    | describe generated item transfer fee |

| No | Field        | type   | sample         | description                                                                                |
|----|--------------|--------|----------------|--------------------------------------------------------------------------------------------|
| 1  | Key          | string | attack         | Attribute to describe.                                                          |
| 2  | Rate         | double | 0.5            | The percentage of the attribute that is available or not available.                        |
| 3  | Value        | string | "Knife Shield" | String attribute of item output.                                                           |
| 4  | Program      | string | "attack x 2"   | Used when output is based on input value; Value is ignored when field is not empty |
| 5  | WeightRanges | array  | 3-5            | The recipe has randomness in output, this field is for int/double attributes.           |

Sample `ItemOutputs` in JSON format:

```json
[{
    "ID": "knife_shield_lv1",
    "Doubles":[
        { "Rate":"1.0", "Key":"attack", "WeightRanges":[{ "Lower":"1", "Upper":"1","Weight":1 }] },
        { "Rate":"1.0", "Key":"defence", "WeightRanges":[{ "Lower":"1", "Upper":"1","Weight":1 }] }
    ],
    "Longs":[
        { "Rate":"1.0", "Key":"level", "WeightRanges":[{ "Lower": 1, "Upper":1,"Weight":1 }] }
    ],
    "Strings":[{ "Key":"Name", "Value":"Knife Shield", "Rate":"1.0" }],
    "TransferFee": 1000
}]
```

Sample `ItemOutputs` in JSON format using `Program`:

```json
[{
    "ID": "knife_shield_lv1"
    "Doubles":[
        { "Rate":"1.0", "Key":"attack", "Program": "input0.attack + input1.attack" },
        { "Rate":"1.0", "Key":"defence", "Program": "input0.defence + input1.defence" }
    ],
    "Longs":[
        { "Rate":"1.0", "Key":"level", "Program": "input0.level + input1.level" }
    ],
    "Strings":[{ "Key":"Name", "Program":"\"Merged \" + input0.name + input1.name", "Rate":"1.0" }],
    "TransferFee": 1000
}]
```

Sample `ItemOutputs` in JSON format using `ModifyItem`:

```json
{
  "ModifyItem": {
    "ID": "modified_monster",
    "ItemInputRef": "monster",
    "Doubles": [{ "Key": "attack", "Program": "attack * 2.0" }],
    "Longs": [{ "Key": "level", "Program": "level + 1" }],
    "Strings": [{ "Key": "LastName", "Program": "\"Upgraded Monster\"" }]
  }
}
```

### Recipes Fee Distribution
 
For every recipe execution that has pylons denom as input, the fee rule is applied. The specific amount of fee percentage is configured as `recipe_fee_percentage` in `pylons.yml`. The fee percentage is distributed to Pylons LLC validator for every recipe execution. 

For example, if a user purchases a game item from cookbook owner at `100pylon`, and the `recipe_fee_percentage` is 10%, `10pylon` is sent to Pylons LLC validator for that transaction and the remaining `90%` is sent to the cookbook owner.

**Warning** If the amount of pylons for the recipe execution is more than `1pylon`, send at least `1pylon` to Pylons LLC validator. For example, if `1pylon` is spent for recipe execution, `1pylon` is sent to Pylons LLC validator and nothing is sent to cookbook owner.

##### ModifyItemOutput

<!-- need description -->

| No | Field        | Type   | Sample               | Description                                |
|----|--------------|--------|----------------------|--------------------------------------------|
| 1  | ID           | string | modified_knife_lv1   | ID to reference at output section          |
| 2  | ItemInputRef | string | attack: +1.0         | ID of item input defined in item inputs    |
| 3  | Doubles      | array  | attack: +1.0         | contains double attributes updates         |
| 4  | Longs        | array  | level: +1            | contains int attributes updates            |
| 5  | Strings      | array  | name: "Level2 Knife" | contains string attributes updates         |
| 6  | TransferFee  | int64  | +200                 | increase the transfer fee value specified  |


Sample `ModifyItemOutput` in JSON format:

```json
{
  "ID": "modified_character",
  "ItemInputRef": "character_acid",
  "Doubles": [{ "Key": "attack", "WeightRanges":[{ "Lower": "2.0", "Upper": "2.0","Weight":1 }] }],
  "Longs": [{ "Key": "level", "WeightRanges":[{ "Lower": 1, "Upper":1,"Weight":1 }] }],
  "Strings": [{"Key": "LastName", "Value": "Upgraded Adventurer"}],
  "TransferFee": 200
}
```

Use this recipe to upgrade the item's level, LastName, and attack.

Sample `ModifyParams` in JSON format with Program:

```json
{
  "ID": "modified_character",
  "ItemInputRef": "character_acid",
  "Doubles": [{ "Key": "attack", "Program": "attack + 1" }],
  "Longs": [{ "Key": "level", "Program": "level + 1" }],
  "Strings": [{"Key": "LastName", "Program": "\"Upgraded Adventurer\""}],
  "TransferFee": 200
}
```

`ItemInputRef` is a string value that is referencing to ID of the item input.

###### ItemModifyParams 

Describes the fields of `ModifyParams` field.

| No | Field        | Type   | Sample               | Description                                |
|----|--------------|--------|----------------------|--------------------------------------------|
| 1  | Doubles      | array  | attack: +1.0         | contains double attributes updates         |
| 2  | Longs        | array  | level: +1            | contains int attributes updates            |
| 3  | Strings      | array  | name: "Level2 Knife" | contains string attributes updates         |
| 4  | TransferFee  | int64  | +200                 | increase the transfer fee value specified  |

| No | Field        | Type   | Sample               | Description                                |
|----|--------------|--------|----------------------|--------------------------------------------|
| 1  | Key          | string | attack               | attribute that needs to be changed        |
| 2  | Value        | string | "Upgraded Knife"     | target value when string attribute is changed   |
| 3  | WeightRanges | array  | 3-5                  | range that describes delta between initial |
| 4  | Program      | string | "attack x 2"         | target value when upgraded by program     |

Upgrade also has random effect and for that, weightRanges are used for Doubles and Longs.

#### CoinOutputs

Describes coin that can be generated from recipe.

| No | Field   | type   | sample       | description                                                         |
|----|---------|--------|--------------|---------------------------------------------------------------------|
| 1  | Coin    | string | "goldcoin"   | name of coin to be generated                        |
| 3  | Count   | string | "attack x 2" |  program string that can use variables from the inputs    |
| 4  | ID      | string | "coin_reward"| ID to reference at outputs section                                  |

Sample `CoinOutputs` in JSON format:

```json
{
  "ID": "coin_reward",
  "Coin": "submcoin",
  "Count": "1"
}
```
Sample `CoinOutputs` in JSON format with variables:
```json
{
  "ID": "coin_reward",
  "Coin":"submcoin",
  "Count":"attack x 2",
}
```

Here when program field is available, Count is ignored.

#### Program 

##### How program works in general
1) For first input, it can be used without setting `attack = input0.attack`
2) For multiple input cases, it can call `input1.attack` etc. If item input has reference ID of `sword`, you can use `sword.attack` variable within program.
3) Have tested `+`, `*`  in double/long and merge string operation using `+` for now
`input0.attack + input1.attack`
`(input0.attack + input1.attack) * 0.7`
`"Old " + "Knife"`

Program field is available for CoinOutputs, Doubles, Longs and Strings (output related fields now).
When Program field is available, other fields like "Value", "Count", "WeightRangeTable" are ignored.

Program field is needed for itemInput also?
Need to discuss and implement if needed.

##### Type conversion

To convert to integer type
`int(2.1) * 2`

To convert to double type
`double(2) * 2.5`

To convert to string type
`string(2.0 + 0.5)`

##### Custom functions within program

- `rand` function

Usecase: generate random value.

Example:  

```code
rand(10)
```
Generates a random number from 0 - 9.

```code
rand()
```
Generates a random number from 0 - 1.

- `min` function

Usecase: get minimum value from two values. 

Values can be integer or double type.

Example:

```code
min(10, 11) //result: 10
min(6.87, 12.32) //result: 6.87
min(20, 2.32) //result: 2.32
min(3.45, 2) //result: 2
```

- `max` function

Usecase: get maximum value from two values.

Values can be integer or double type.

Example:

```code
max(10, 11) //result: 11
max(6.87, 12.32) //result: 12.32
max(20, 2.32) //result: 20
max(3.45, 2) //result: 3.45
```

- `log2` function

Usecase: get log 2 value from one parameter.

The parameter can be integer or double type.

Example:

```code
log2(1024) //result: 10
log2(123.45) //result: 6.947783026255419
log2(0) //result: -Inf
log2(-1) //result: NaN
```

### Outputs

`Outputs` is an array of result sets by weights.

| No | Field    | type   | sample                       | description                                                         |
|----|----------|--------|------------------------------|---------------------------------------------------------------------|
| 1  | EntryIDs | array  | ["coin_reward", "character"] | This contains the result set that is consists of entry ids.         |
| 2  | Weight   | string | "100-HP"                     | This is cel program that determines weight of specific result set. |

Sample `Outputs` in JSON format:

```json
  "Outputs": [
      {
          "EntryIDs": ["knife_shield_v1"],
          "Weight": "1"
      }
  ],
```

When both `CoinOutputs` and `ItemOutputs` are available, indexing starts from `CoinOutputs`.

```json
    "Entries":{
        "CoinOutputs":[
            { "ID": "coin_reward", "Coin":"javecoin", "Count":"100" }
        ],
        "ItemModifyOutputs":[
            {
                "ID": "modified_javelin",
                "ItemInputRef": "javelin",
                "ModifyParamsRef": "./recipes/javelin/upgrader/javelin_program.json"
            }
        ]
    },
    "Outputs": [
        {
            "EntryIDs": ["modified_javelin"],
            "Weight": "1"
        },
        {
            "EntryIDs": ["javecoin", "modified_javelin"],
            "Weight": "int(attack) * 2 + 1"
        }
    ],
```

For example, EntryIDs `["javecoin", "modified_javelin"]` means javecoin + modified_javelin, `["modified_javelin"]` means modified_javelin.

## Execution of recipes

Sample execution in JSON format:

```json
{
    "RecipeID": "Submarine-knife-shield-generation-recipe-v0.0.0-1583801800",
    "Sender":"cosmos1mkk2q586y5pz263u5v8dv59723u58059ytprs9",
    "ItemIDs":[]
}
```

When running recipes, provide the recipe executor address, `RecipeID`, and `ItemIDs` that participate in the recipe execution.

`RecipeID` must be the valid ID of the recipe that is returned when creating a recipe or a valid ID that is returned by the `list_recipes` command.

The result of excution could be two cases.

1. Not delayed recipe

When not delayed, recipes run where BlockInterval is 0. The results are provided directly in the result's output field:

| No | Field   | type       | sample                             | description                                          |
|----|---------|------------|------------------------------------|------------------------------------------------------|
| 1  | Message | String     | "Successfully executed the recipe" | Execution result message                             |
| 2  | Status  | String     | "Success"                          | Execution result status                              |
| 3  | Output  | byte array | char, 200 gold, goblin ear         | Output is providing the result of execution as JSON. |

Output is an array of ExecuteRecipeSerialize and it looks like the following output:

| No | Field  | type   | sample                     | description                                    |
|----|--------|--------|----------------------------|------------------------------------------------|
| 1  | Type   | String | COIN or ITEM               | type of output                                 |
| 2  | Coin   | String | loudcoin                   | generated coin name, valid when type is COIN   |
| 3  | Amount | int64  | char, 200 gold, goblin ear | generated coin amount, valid when type is COIN |
| 4  | ItemID | String | "itemIDXXXX"               | generated item ID, valid when type is ITEM     |

2. Delayed recipe

When delayed, recipes run where BlockInterval is greater than 1. The user must run `MsgCheckExecution` using the `ExecID` that is returned by the execution of recipe. 

Result of check execution is the same as the not delayed recipe execution.

Sample check execution in JSON format:

```
{
    "PayToComplete": false,
    "ExecID": "ValidExecIDXXXX",
    "Sender":"cosmos1mkk2q586y5pz263u5v8dv59723u58059ytprs9"
}
```

For delayed recipes that can take a very long time, the user can use the `PayToComplete` option to pay for the waiting time and get the result before waiting.

## Trading

Trading consists of order creation by using `MsgCreateTrade` and order execution by using `MsgFulfillTrade`.

The order creator can: 

- Set `CoinInputs` for the coin to give on this trading.
- Set `ItemInputs` for the items to give on this trading.
- Set `CoinOutputs` for the coin to receive on this trading.
- Set `ItemOutputs` for the item to receive on this trading.

### Tradings by example

Coin-to-coin trading:

```json
{
  "CoinInputs":[
      {
          "Coin": "pylon",
          "Count": 1
      }
  ],
  "ItemInputs": [],
  "CoinOutputs": [{
      "denom":"node0token",
      "amount": "200"
  }],
  "ItemOutputNames": [],
  "ExtraInfo":"coin to coin trading",
  "Sender":"eugen"  
}
```

Coin-to-item trading:

```json
{
  "CoinInputs":[
      {
          "Coin": "pylon",
          "Count": 1
      }
  ],
  "ItemInputs": null,
  "CoinOutputs": null,
  "ItemOutputNames": ["Trading Knife v1"],
  "ExtraInfo":"coin to item trading",
  "Sender":"eugen"
}
```

Item-to-coin trading:

```json
{
    "CoinInputs":[],
    "ItemInputs": [
        {
            "ID": "trading_knife_v3",
            "Ref": "./trades/item_input/trading_knife_v3.json"
        }
    ],
    "CoinOutputs": [{
        "denom":"node0token",
        "amount": "200"
    }],
    "ItemOutputNames": [],
    "ExtraInfo":"item to coin trading",
    "Sender":"eugen"
}
```

Item-to-item trading:

```json
{
    "CoinInputs":[],
    "ItemInputs": [
        {
            "Ref": "./trades/item_input/trading_knife_v4.json"
        }
    ],
    "CoinOutputs": [],
    "ItemOutputNames": ["Trading Knife v2"],
    "ExtraInfo":"item to item trading",
    "Sender":"eugen"
}
```

Trade orders can be fulfilled by running `MsgFulfillTrade`.

Sample trade order in JSON format:

```json
{
  "TradeID": "ValidTradeIDXXXX",
  "Sender":"cosmos1mkk2q586y5pz263u5v8dv59723u58059ytprs9",
  "ItemIDs":[]
}
```

In this example, `TradeID` is fetched from the `list_trade` command.

- `Sender` is fulfiller address.
- `ItemIDs` field is used to mention which items of fulfiller are going to participate in fulfilling trades.

**Warning** The total amount of pylons participating in coin input and output must be more than `minimum_trade_price` configured in `pylons.yml`. Currently the total amount is set to 10 pylons.

### TradeItemInput

Same `TradeItemInput` in JSON format:

```json
{
    "ItemInput": {
        "Doubles":null,
        "Longs":null,
        "Strings":[
            {
                "Key":"Name",
                "Value":"Trading Knife v3"
            }
        ]
    },
    "CookbookID": "tradecookbook-1589853709"
}
```

`TradeItemInput` = `CookbookID` + `ItemInput`

- Recipe itself is restricted to cookbook, so there's no need to set cookbook ID. 
- With trading items, you must set the cookbook ID because it's not restricted to cookbook ID.

### Trading fee distribution

Specific amount of fee percentage configured as `pylons_trade_percentage` in `pylons.yml` is distributed to Pylons LLC validator for every transaction. For example, if a user sells an item at `100pylon`, and the `pylons_trade_percentage` is 10%, then `10pylon` is sent to Pylons LLC validator for that trade when trading is fulfilled.

## Item transfer fee distribution

Actual item transfer fee is the sum of each item's transfer fee. Each item's transfer fee is determined as:

`min( max(min_item_transfer_fee, item.TransferFee), max_item_transfer_fee)`

where `min_item_transfer_fee` and `max_item_transfer_fee` are global configurations.

## Configuration

The Pylons configuration file is `pylons.yml`. Comments follow the `#` character. 

```yaml
fees:
  recipe_fee_percentage: 10 # Pylons fee percentage
  cookbook_basic_fee: 10000 # Cookbook creation fee
  cookbook_premium_fee: 50000 # Cookbook creation fee
  pylons_trade_percentage: 10 # Pylons trade percentage
  minimum_trade_price: 10 # Minimum trade price
  update_item_string_field_fee: 10 # Item string field update fee
  min_item_transfer_fee: 1 # Basic item transfer fee
  max_item_transfer_fee: 100000
  item_transfer_cookbook_owner_profit_percent: 90 # Cookbook sender item transfer percent
validators:
  pylons_llc: cosmos105wr8t6y97rwv90xzhxd4juj4lsajtjaass6h7 # this should be replaced
google_iap:
  - package_name: com.pylons.loud
    product_id: pylons_1000
    amount: 1000
  - package_name: com.pylons.loud
    product_id: pylons_55000
    amount: 55000
google_iap_pubkey: XXXX
is_production: false
```

- `recipe_fee_percentage` - The percentage of pylons to transfer to Pylons LLC validator address for every pylons denom paid recipe.  
- `cookbook_basic_fee` - The number of pylons to pay to Pylons LLC validator address to create a basic tier cookbook creation.  
- `cookbook_premium_fee` - The amount of pylons to pay to Pylons LLC validator address to create a premium tier cookbook creation.  
- `pylons_trade_percentage` - The percentage of pylons to transfer from pylons incoming trader's side.
- `minimum_trade_price` - The minimum amount of pylons required to participate per trade.
- `update_item_string_field_fee` - String field update fee per field.
- `pylons_llc` - The cosmos address for Pylons LLC validator.
- `min_item_transfer_fee` - The minimum pylons fee per item transfer.
- `max_item_transfer_fee` - The maximum pylons fee per item transfer.
- `item_transfer_cookbook_owner_profit_percent` - The cookbook owner's fee profit percentage.
- `google_iap` - The Google Identity-Aware Proxy (IAP) packages/products and the amount associated with the package/product. 
- `google_iap_pubkey` - The Google IAP public key to verify Google IAP purchase signature.
- `is_production` - Production-enable flag `true`|`false`. Set to `true` to enable production. Default is false.
