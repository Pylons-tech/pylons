# Introduction

🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿

Pylons eco system consists of cookbooks, recipes, items, coins and trades.

Here's a description of how to use cookbooks, recipes, items, coins, and trades that are compatible with the pylons eco system.

Usually, a cookbook contains all recipes and items that are used for the game.
This game corresponds to Cookbook 1:1.

Developers create a cookbook along with recipes and item which is going to be used within the game.
Recipe can be used for buying items, upgrade items, merge two items into one. Also can be used for the exchange of coins, sell items and trading items between users.
And players owe items, coins and trade orders. Recipes can be executed if user fit the recipe conditions.

Since it's a blockchain based system, running recipe is taking more than 1 block time. So developers consider these things when writing cookbooks, recipes and items for their game.

## Cookbook

Cookbook consists of below fields. Reference of [Table generator](https://www.tablesgenerator.com/markdown_tables).

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
| 10 | CostPerBlock | int    | 2                                              | Pylons per block to be charged across this cookbook for delayed execution early completion |

Sample cookbook JSON

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

### Support email validation rule 
We accept emails that fit `^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z0-9]{2,})$` regular expression.

## Item

Item consists of below fields.

| No | Field         | Type   | Sample                                | Description                                                                       |
|----|---------------|--------|---------------------------------------|-----------------------------------------------------------------------------------|
| 1  | NodeVersion   | string | "0.0.1"                               | NodeVersion is available for all pylons entities like items, recipes, trades etc. |
| 2  | ID            | string | "cosmos1yjrrrgt0xfqau9fz3vu6tlm3XXX"  | ID is the unique identifier of cookbook. This is unique across whole eco system.  |
| 3  | CookbookID    | string | "submarine-3942525"                   | contains the name of cookbook for the item.                                       |
| 4  | Sender        | string | "eugen"                               | contains the owner of item.                                                       |
| 5  | Doubles       | array  | defence: 1.0,  movement: 1.0          | contains double attributes of the item.                                           |
| 6  | Longs         | array  | level: 1                              | contains int attributes of the item.                                              |
| 7  | Strings       | array  | name: "shield", use: "defend and run" | contains string attributes of the item.                                           |
| 8  | OwnerRecipeID | string | ""                                    | contains owner recipe id, if not owned, value is ""                               |
| 9  | OwnerTradeID  | string | ""                                    | contains owner trade id, if not owned by trade, value is ""                       |
| 10 | Tradable      | bool   | true                                  | flag for an item is tradable, it's always true now                                |
| 11 | LastUpdate    | int64  | 5649                                  | latest update block height                                                        |
| 12 | TransferFee   | int64  | 0                                     | item transfer fee used for item transfer and item trade                           |


Sample item JSON

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

Recipe consists of below fields.

| No | Field         | Type   | Sample                                                       | Description                                                                           |
|----|---------------|--------|--------------------------------------------------------------|---------------------------------------------------------------------------------------|
| 1  | NodeVersion   | string | "0.0.1"                                                      | NodeVersion is available for all pylons entities like cookbooks, recipes, trades etc. |
| 2  | ID            | string | "Submarine-knife-recipe-3942525"                             | ID is the unique identifier of recipe. This is unique across whole eco system.        |
| 3  | CookbookID    | string | "submarine-3942525"                                          | contains the name of cookbook for the recipe.                                         |
| 4  | Name          | string | "Knife Shield Generation Recipe"                             | name of recipe.                                                                       |
| 5  | Description   | string | "level 1 knife and level 1 shield into level 1 knife-shield" | recipe description                                                                    |
| 6  | Sender        | string | "eugen"                                                      | recipe owner name.                                                                    |
| 7  | CoinInputs    | array  | "goldcoin": 1, "silvercoin": 1                               | required coins to run recipe.                                                         |
| 8  | ItemInputs    | array  | level 1 knife, level 1 shield                                | required items to run recipe. This can also describe item upgrade.                    |
| 9  | Entries       | array  | level 1 knife-shield                                         | Items and coins which can be generated from this recipe.                              |
| 10 | Outputs       | array  | Weight: "100 - HP", Result: chararacter, coin                | This provides the weighted list of results that can be outputted.                     |
| 11 | BlockInterval | int    | 2                                                            | Recipe is able to produce output after BlockInterval time.                            |

Sample Recipe JSON

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

When creating recipe, on MsgCreateRecipe, ID field is optional.
If ID field is provided, it will be using the provided ID and if not, just generate a new ID.

### ItemInputs
This field is showing required items to run recipe.

| No | Field        | type       | sample              | description                                    |
|----|--------------|------------|---------------------|------------------------------------------------|
| 1  | ID           | string     | "monster"           | required to reference on entries section.      |
| 2  | Doubles      | array      | "attack": 1         | required conditions for double attributes.     |
| 3  | Longs        | array      | "level": 1          | required conditions for int attributes.        |
| 4  | Strings      | array      | "name": "shield"    | required conditions for string attributes.     |
| 5  | TransferFee  | range      | 1-1000              | required condition for transfer fee range.     |

**Warn**
ID of item input should be empty or should fit `^[a-zA-Z_][a-zA-Z_0-9]*$`.

| No | Field    | Type       | sample   | description                                                                         |
|----|----------|------------|----------|-------------------------------------------------------------------------------------|
| 1  | Key      | string     | "attack" | attribute of item to check.                                                         |
| 2  | Value    | string     | 1        | item's "Key" attribute shoud be same as this value.                                 |
| 3  | MinValue | int/double | 1        | For int/double values they are checked with range and this describes minimum value. |
| 4  | MaxValue | int/double | 2        | For int/double values they are checked with range and this describes maximum value. |

Sample ItemInputs JSON

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
This field is showing required coins to run recipe.

| No | Field | type   | sample     | description              |
|----|-------|--------|------------|--------------------------|
| 1  | Coin  | string | "goldcoin" | name of coin             |
| 2  | Count | int    | 1          | required amount of coin. |

Sample CoinInput JSON

```json
[{
    Coin: "goldcoin"
	Count: "1"
}]
```
### Entries
Entries consist of coin outputs and item outputs. It means recipe can generate coin or item.

Sample Entries JSON
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
**Warn**  
- There shouldn't be any recipes that generate pylon denom as an output.
- ID of any entry should fit `^[a-zA-Z_][a-zA-Z_0-9]*$` (coin output, item modify output and item output).

#### ItemOutputs
This describes item which can be generated from recipe.

| No | Field       | type   | sample                  | description                          |
|----|-------------|--------|-------------------------|--------------------------------------|
| 1  | ID          | string | knife_lv1               | ID to reference at output section    |
| 2  | Doubles     | range  | attack: 0.1-2.1,3.2-3.4 | describe double attributes           |
| 3  | Longs       | range  | level: 1-2,4-1000       | describe int attributes              |
| 4  | Strings     | range  | Name: "Knife"           | describe string attributes           |
| 5  | TransferFee | int    | 1000                    | describe generated item transfer fee |

| No | Field        | type   | sample         | description                                                                                |
|----|--------------|--------|----------------|--------------------------------------------------------------------------------------------|
| 1  | Key          | string | attack         | attribute which want to describe.                                                          |
| 2  | Rate         | double | 0.5            | This describes the percentage of the attribute is available or not.                        |
| 3  | Value        | string | "Knife Shield" | string attribute of item output.                                                           |
| 4  | Program      | string | "attack x 2"   | Program is used when output is based on input value; Value is ignored when it is not empty |
| 5  | WeightRanges | array  | 3-5            | the recipe has randomness in output and this field is for int/double attributes.           |

Sample ItemOutputs JSON
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

Sample ItemOutputs JSON using Program
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

Sample ItemOutputs JSON using ModifyItem
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

### Recipes Fee distribution
 
For every recipe execution that has pylons denom as input, fee rule is applied.  
Specific amount of fee percentage configured as `recipe_fee_percentage` in `pylons.yml` is distributed to Pylons LLC validator for every recipe execution. e.g. If someone purchase game item from cookbook owner at `100pylon`, `recipe_fee_percentage` is 10%, `10pylon` is sent to Pylons LLC validator for that transaction and the rest `90%` is sent to cookbook owner.
**Warn** If the amount of pylons for the recipe execution is more than `1pylon` at least `1pylon` should be sent to Pylons LLC validator. e.g. if `1pylon` is spent for recipe execution, `1pylon` is sent to Pylons LLC validator and nothing is sent to cookbook owner.

##### ModifyItemOutput

| No | Field        | Type   | Sample               | Description                                |
|----|--------------|--------|----------------------|--------------------------------------------|
| 1  | ID           | string | modified_knife_lv1   | ID to reference at output section          |
| 2  | ItemInputRef | string | attack: +1.0         | ID of item input defined in item inputs    |
| 3  | Doubles      | array  | attack: +1.0         | contains double attributes updates         |
| 4  | Longs        | array  | level: +1            | contains int attributes updates            |
| 5  | Strings      | array  | name: "Level2 Knife" | contains string attributes updates         |
| 6  | TransferFee  | int64  | +200                 | increase the transfer fee value specified  |


Sample ModifyItemOutput JSON

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

This recipe is to upgrade item's level, LastName, and attack.

Sample ModifyParams JSON with Program

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

This describes the fields of ModifyParams field.

| No | Field        | Type   | Sample               | Description                                |
|----|--------------|--------|----------------------|--------------------------------------------|
| 1  | Doubles      | array  | attack: +1.0         | contains double attributes updates         |
| 2  | Longs        | array  | level: +1            | contains int attributes updates            |
| 3  | Strings      | array  | name: "Level2 Knife" | contains string attributes updates         |
| 4  | TransferFee  | int64  | +200                 | increase the transfer fee value specified  |

| No | Field        | Type   | Sample               | Description                                |
|----|--------------|--------|----------------------|--------------------------------------------|
| 1  | Key          | string | attack               | attribute which needs to be changed        |
| 2  | Value        | string | "Upgraded Knife"     | Target value when string attr is changed   |
| 3  | WeightRanges | array  | 3-5                  | range which describe delta between initial |
| 4  | Program      | string | "attack x 2"         | target value when upgraded by program.     |

Upgrade also has random effect and for that, weightRanges are used for Doubles and Longs.

#### CoinOutputs
This describes coin which can be generated from recipe.

| No | Field   | type   | sample       | description                                                         |
|----|---------|--------|--------------|---------------------------------------------------------------------|
| 1  | Coin    | string | "goldcoin"   | This shows the name of coin to be generated.                        |
| 3  | Count   | string | "attack x 2" | This is program string and you can use the variables from inputs    |
| 4  | ID      | string | "coin_reward"| ID to reference at outputs section.                                 |

Sample CoinOutputs JSON
```json
{
  "ID": "coin_reward",
  "Coin": "submcoin",
  "Count": "1"
}
```
Sample CoinOutputs JSON with variables
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
```
rand(10)
```
Above code is for generation of random number from 0 - 9.
```
rand()
```
Above code is for generation of random number from 0 - 1.

- `min` function
Usecase: get minimum value from two values. 
Values can be integer or double type.
Example:
```
min(10, 11) //result: 10
min(6.87, 12.32) //result: 6.87
min(20, 2.32) //result: 2.32
min(3.45, 2) //result: 2
```

- `max` function
Usecase: get maximum value from two values.
Values can be integer or double type.
Example:
```
max(10, 11) //result: 11
max(6.87, 12.32) //result: 12.32
max(20, 2.32) //result: 20
max(3.45, 2) //result: 3.45
```

- `log2` function
Usecase: get log 2 value from one parameter.
The parameter can be integer or double type.
Example:
```
log2(1024) //result: 10
log2(123.45) //result: 6.947783026255419
log2(0) //result: -Inf
log2(-1) //result: NaN
```

### Outputs

Outputs is an array of result sets by weights.

| No | Field    | type   | sample                       | description                                                         |
|----|----------|--------|------------------------------|---------------------------------------------------------------------|
| 1  | EntryIDs | array  | ["coin_reward", "character"] | This contains the result set that is consists of entry ids.         |
| 2  | Weight   | string | "100-HP"                     | This is cel program which determines weight of specific result set. |

Sample Outputs JSON
```json
  "Outputs": [
      {
          "EntryIDs": ["knife_shield_v1"],
          "Weight": "1"
      }
  ],
```

When both CoinOutputs and ItemOutputs are available, indexing start from CoinOutputs.
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
e.g. on above, EntryIDs `["javecoin", "modified_javelin"]` means javecoin + modified_javelin, `["modified_javelin"]` means modified_javelin

## Execution of recipes

Sampe Execution JSON
```json
{
    "RecipeID": "Submarine-knife-shield-generation-recipe-v0.0.0-1583801800",
    "Sender":"cosmos1mkk2q586y5pz263u5v8dv59723u58059ytprs9",
    "ItemIDs":[]
}
```

When running recipes, it needs to provide recipe executor address, RecipeID and ItemIDs which participate in recipe execution.
RecipeID should be valid ID of recipe which is returned when creating recipe or one which is returned by list_recipes command.

The result of excution could be two cases.
1. Not delayed recipe
When not delayed recipes run where BlockInterval is 0, it provide results directly in result's output field.

| No | Field   | type       | sample                             | description                                          |
|----|---------|------------|------------------------------------|------------------------------------------------------|
| 1  | Message | String     | "Successfully executed the recipe" | Execution result message                             |
| 2  | Status  | String     | "Success"                          | Execution result status                              |
| 3  | Output  | byte array | char, 200 gold, goblin ear         | Output is providing the result of execution as JSON. |

Output is an array of ExecuteRecipeSerialize and it looks like below.

| No | Field  | type   | sample                     | description                                    |
|----|--------|--------|----------------------------|------------------------------------------------|
| 1  | Type   | String | COIN or ITEM               | type of output                                 |
| 2  | Coin   | String | loudcoin                   | generated coin name, valid when type is COIN   |
| 3  | Amount | int64  | char, 200 gold, goblin ear | generated coin amount, valid when type is COIN |
| 4  | ItemID | String | "itemIDXXXX"               | generated item ID, valid when type is ITEM     |

2. Delayed recipe
When delayed recipes run where BlockInterval is more than 1, user should run MsgCheckExecution using the ExecID returned by execution of recipe.
Result of check execution is same as Not delayed recipe execution

Sample check execution JSON
```
{
    "PayToComplete": false,
    "ExecID": "ValidExecIDXXXX",
    "Sender":"cosmos1mkk2q586y5pz263u5v8dv59723u58059ytprs9"
}
```

For delayed recipes which can take very long time, user can pay for the waiting time and get the result done before waiting.
PayToComplete is the option for that.

## Trading

Trading consists of order creation by using MsgCreateTrade and order execution by using MsgFulfillTrade.

Order creator can set CoinInputs for the coin he want to give on this trading.
Order creator can set ItemInputs for the items he want to give on this trading.
Order creator can set CoinOutputs for the coin he want to receive on this trading.
Order creator can set ItemOutputs for the item he want to receive on this trading.

Tradings by example

Coin to coin trading
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
Coin to item trading
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
Item to coin trading
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
Item to item trading
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

Trading order can be fulfilled by running MsgFulfillTrade
Sample JSON
```json
{
  "TradeID": "ValidTradeIDXXXX",
  "Sender":"cosmos1mkk2q586y5pz263u5v8dv59723u58059ytprs9",
  "ItemIDs":[]
}
```

Here `TradeID` can be the one fetched from `list_trade` command.
`Sender` is fulfiller address.
`ItemIDs` field is used to mention which items of filfiller is going to participate in fulfilling trades.

**Warn** The total amount of pylons participate in coin input and output should be more than `minimum_trade_price` configured in `pylons.yml`. Currently it's set to 10 pylons.

### TradeItemInput

Same TradeItemInput JSON  
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

TradeItemInput = CookbookID + ItemInput

Recipe itself is restricted to cookbook and there's no need to set cookbook ID.
But with trading items, it is needed to set cookbook ID as it's not restricted to cookbook ID.

### Trading fee distribution

Specific amount of fee percentage configured as `pylons_trade_percentage` in `pylons.yml` is distributed to Pylons LLC validator for every transaction. e.g. If someone sell an item at `100pylon`, `pylons_trade_percentage` is 10%, `10pylon` is sent to Pylons LLC validator for that trade when trading is fulfilled.

## Item transfer fee distribution

Actual item transfer fee is the sum of each item's transfer fee.
And each item's transfer fee is determined as 
`min( max(min_item_transfer_fee, item.TransferFee), max_item_transfer_fee)`

Here `min_item_transfer_fee` and `max_item_transfer_fee` are global configurations.

## Configuration

- File name: `pylons.yml`

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

- `recipe_fee_percentage` refers to the percentage of pylons that needs to be  transfered to Pylons LLC validator address for every pylons denom paid recipe.  
- `cookbook_basic_fee` refers to the amount of pylons that needs to be paid to Pylons LLC validator address to create a basic tier cookbook creation.  
- `cookbook_premium_fee` refers to the amount of pylons that needs to be paid to Pylons LLC validator address to create a premium tier cookbook creation.  
- `pylons_trade_percentage` refers to the percentage of pylons that needs to be transfered from pylons incomer's side.
- `minimum_trade_price` refers to the minimum amount of pylons that needs to participate per trading.
- `update_item_string_field_fee` refers to item string field update fee per field
- `pylons_llc` refers to cosmos address for Pylons LLC validator.
- `min_item_transfer_fee` refers to the minimum pylons per item transfer
- `max_item_transfer_fee` refers to the maximum pylons per item transfer
- `item_transfer_cookbook_owner_profit_percent` refers to cookbook owner's profit percent in fee
- `google_iap` define google iap packages/products along with the amount associated with the package/product.
- `google_iap_pubkey` defines the google iap public key to verify google iap purchase signature
- `is_production` defines the flag to show if this configuration is for production
