# Introduction

🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿🌿

Pylons eco system consists of cookbooks, items, coin and recipes.

Here's detailed description of how to use cookbooks, items, coins and recipes which are compatible with pylons eco system.

Usually, cookbook contains all recipes and items which is used for game.
The game is corresponding to Cookbook 1: 1.

Developers create a cookbook along with recipes and item which is going to be used within the game.
Recipe can be used for buying items, upgrade items, merge two items into one. Also can be used for exchange of coins, sell items and trading items between users.
And users owe items, coins and recipes. Recipes can be executed when user want.

Since it's a blockchain based system, running recipe is taking more than 1 block time. So developers consider these things when writing cookbooks, recipes and items for their game.

## Cookbook

Cookbook consists of below fields. Reference of [Table generator](https://www.tablesgenerator.com/markdown_tables).

| No |     Field    |  Type  |                     Sample                     |                                         Description                                        |
|---:|:------------:|:------:|:----------------------------------------------:|:------------------------------------------------------------------------------------------:|
|  1 |     Name     | string |                   "submarine"                  |                                        Name of game.                                       |
|  2 |  Description | string | "Submarine game is a type of exploration game" |                                    Description of game.                                    |
|  3 |    Version   | SemVer |                     "1.0.0"                    |                                      Version of game.                                      |
|  4 |   Developer  | string |                   "SketchyCo"                  |                                 Developer who created game.                                |
|  5 | SupportEmail |  Email |              "example@example.com"             |                                Email of this game supporter.                               |
|  6 |     Level    |  Level |                       "0"                      |                                     level of this game.                                    |
|  7 |    Sender    | string |                     "eugen"                    |                           game creator user on pylons eco system.                          |
|  8 | CostPerBlock |   int  |                        2                       | Pylons per block to be charged across this cookbook for delayed execution early completion |

Sample cookbook JSON

```
{
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

## Item

Item consists of below fields.

| No | Field         | Type   | Sample                                | Description                                         |
|----|---------------|--------|---------------------------------------|-----------------------------------------------------|
| 1  | CookbookName  | string | "submarine"                           | contains the name of cookbook for the item.         |
| 2  | Sender        | string | "eugen"                               | contains the owner of item.                         |
| 3  | Doubles       | array  | defence: 1.0,  movement: 1.0          | contains double attributes of the item.             |
| 4  | Longs         | array  | level: 1                              | contains int attributes of the item.                |
| 5  | Strings       | array  | name: "shield", use: "defend and run" | contains string attributes of the item.             |
| 6  | OwnerRecipeID | string | ""                                    | Contains owner recipe id, if not owned, value is "" |

Sample item JSON

```
{
  "Doubles": [{ "Key": "defence", "Value": "1" }],
  "Longs": [{ "Key": "level", "Value": "1" }],
  "Strings": [{ "Key": "Name","Value": "Shield" }],
  "CookbookName": "submarine",
  "Sender": "eugen",
  "OwnerRecipeID": ""
}
```

## Recipe

Recipe consists of below fields.

| No | Field         | Type   | Sample                                                       | Description                                                        |
|----|---------------|--------|--------------------------------------------------------------|--------------------------------------------------------------------|
| 1  | CookbookName  | string | "submarine"                                                  | contains the name of cookbook for the recipe.                      |
| 2  | Name          | string | "Knife Shield Generation Recipe"                             | name of recipe.                                                    |
| 3  | Description   | string | "level 1 knife and level 1 shield into level 1 knife-shield" | recipe description                                                 |
| 4  | Sender        | string | "eugen"                                                      | recipe owner name.                                                 |
| 5  | CoinInputs    | array  | "goldcoin": 1, "silvercoin": 1                               | required coins to run recipe.                                      |
| 6  | ItemInputs    | array  | level 1 knife, level 1 shield                                | required items to run recipe. This can also describe item upgrade. |
| 7  | Entries       | array  | level 1 knife-shield                                         | Items and coins which can be generated from this recipe.           |
| 8  | Outputs       | array  | Weight: "100 - HP", Result: chararacter, coin                | This provides the weighted list of results that can be outputted.  |
| 9  | BlockInterval | int    | 2                                                            | Recipe is able to produce output after BlockInterval time.         |

Sample Recipe JSON

```
{
    "ID": "Submarine-knife-shield-generation-recipe-v0.0.0-1583801800",
    "CoinInputs":[],
    "ItemInputRefs": [
        "./recipes/submarine/item_input/knife_lv1.json",
        "./recipes/submarine/item_input/shield_lv1.json"
    ],
    "Entries":{
        "CoinOutputs":[],
        "ItemOutputs":[
            {
                "Ref": "./recipes/submarine/item_output/knife_shield_lv1.json"
            }
        ]
    },
    "Outputs": [
        {
            "ResultEntries": ["0"],
            "Weight": "1"
        }
    ],
    "ExtraInfo":"",
    "Sender":"eugen",
    "Name": "Knife Shield Generation Recipe",
    "CookbookName": "submarine",
    "Description": "this recipe is merging level 1 knife and level 1 shield into level 1 knife-shield.",
    "BlockInterval":"0"
}
```

When creating recipe, on MsgCreateRecipe, ID field is optional.
If ID field is provided, it will be using the provided ID and if not, just generate a new ID.

### ItemInputs
This field is showing required items to run recipe.

| No | Field        | type       | sample              | description                                    |
|----|--------------|------------|---------------------|------------------------------------------------|
| 1  | Doubles      | array      | "attack": 1         | required conditions for double attributes.     |
| 2  | Longs        | array      | "level": 1          | required conditions for int attributes.        |
| 3  | Strings      | array      | "name": "shield"    | required conditions for string attributes.     |

| No | Field    | Type       | sample   | description                                                                         |
|----|----------|------------|----------|-------------------------------------------------------------------------------------|
| 1  | Key      | string     | "attack" | attribute of item to check.                                                         |
| 2  | Value    | string     | 1        | item's "Key" attribute shoud be same as this value.                                 |
| 3  | MinValue | int/double | 1        | For int/double values they are checked with range and this describes minimum value. |
| 4  | MaxValue | int/double | 2        | For int/double values they are checked with range and this describes maximum value. |

Sample ItemInputs JSON

```
[{
    "Doubles": [{"Key": "attack", "MinValue": "1", "MaxValue": "2000"}],
    "Longs": [{"Key": "level", "MinValue": "1", "MaxValue": "2000"}],
    "Strings": [{"Key": "Name", "Value": "Monster"}],
}]
```

### CoinInputs
This field is showing required coins to run recipe.

| No | Field | type   | sample     | description              |
|----|-------|--------|------------|--------------------------|
| 1  | Coin  | string | "goldcoin" | name of coin             |
| 2  | Count | int    | 1          | required amount of coin. |

Sample CoinInput JSON

```
[{
  Coin: "goldcoin"
	Count: "1"
}]
```
### Entries
Entries consist of coin outputs and item outputs. It means recipe can generate coin or item.

Sample Entries JSON
```
{
  "CoinOutputs":[],
  "ItemOutputs":[
    {
      "Ref": "./recipes/item_output/knife_shield_lv1.json",
    }
  ]
}
```
#### ItemOutputs
This describes item which can be generated from recipe.

| No | Field        | type   | sample         | description                                                                                |
|----|--------------|--------|----------------|--------------------------------------------------------------------------------------------|
| 1  | Key          | string | attack         | attribute which want to describe.                                                          |
| 2  | Rate         | double | 0.5            | This describes the percentage of the attribute is available or not.                        |
| 3  | Value        | string | "Knife Shield" | string attribute of item output.                                                           |
| 4  | Program      | string | "attack x 2"   | Program is used when output is based on input value; Value is ignored when it is not empty |
| 5  | WeightRanges | array  | 3-5            | the recipe has randomness in output and this field is for int/double attributes.           |

Sample ItemOutputs JSON
```
[{
    "Doubles":[
        {
            "Rate":"1.0",
            "Key":"attack",
            "WeightRanges":[{ "Lower":"1", "Upper":"1","Weight":1 }]
        },
        {
            "Rate":"1.0",
            "Key":"defence",
            "WeightRanges":[{ "Lower":"1", "Upper":"1","Weight":1 }]
        }
    ],
    "Longs":[
        {
            "Rate":"1.0",
            "Key":"level",
            "WeightRanges":[{ "Lower": 1, "Upper":1,"Weight":1 }]
        }
    ],
    "Strings":[{ "Key":"Name", "Value":"Knife Shield", "Rate":"1.0" }]
}]
```

Sample ItemOutputs JSON using Program
```
[{
    "Doubles":[
        {
            "Rate":"1.0",
            "Key":"attack",
            "Program": "input0.attack + input1.attack"
        },
        {
            "Rate":"1.0",
            "Key":"defence",
            "Program": "input0.defence + input1.defence"
        }
    ],
    "Longs":[
        {
            "Rate":"1.0",
            "Key":"level",
            "Program": "input0.level + input1.level"
        }
    ],
    "Strings":[{ "Key":"Name", "Program":"\"Merged \" + input0.name + input1.name", "Rate":"1.0" }]
}]
```

Sample ItemOutputs JSON using ModifyItem
```
{
  "ModifyItem": {
    "ItemInputRef": 0,
    "Doubles": [{
        "Key": "attack", 
        "Program": "attack * 2.0"
    }],
    "Longs": [{
        "Key": "level", 
        "Program": "level + 1"
    }],
    "Strings": [{
        "Key": "LastName",
        "Program": "\"Upgraded Monster\""
    }]
  }
}
```

##### ModifyItem

###### ItemInputRef

`ItemInputRef` is referencing to index of item input starting from 0.
When `ItemInputRef` is -1, it means it's generating item without from input item.
For JSON, if you don't specify a field for ItemInputRef, it's default value is set to -1.

###### ModifyParams 

This describes the fields of ModifyParams field.

| No | Field        | Type   | Sample               | Description                                |
|----|--------------|--------|----------------------|--------------------------------------------|
| 1  | Doubles      | array  | attack: +1.0         | contains double attributes updates         |
| 2  | Longs        | array  | level: +1            | contains int attributes updates            |
| 3  | Strings      | array  | name: "Level2 Knife" | contains string attributes updates         |
| 4  | Key          | string | attack               | attribute which needs to be changed        |
| 5  | Value        | string | "Upgraded Knife"     | Target value when string attr is changed   |
| 6  | WeightRanges | array  | 3-5                  | range which describe delta between initial |
| 7  | Program      | string | "attack x 2"         | target value when upgraded by program.     |

Upgrade also has random effect and for that, weightRanges are used for Doubles and Longs.

Sample ModifyParams JSON

```
{
  "Doubles": [{
    "Key": "attack", 
    "WeightRanges":[{ "Lower": "2.0", "Upper": "2.0","Weight":1 }]
  }],
  "Longs": [{
    "Key": "level", 
    "WeightRanges":[{ "Lower": 1, "Upper":1,"Weight":1 }]
  }],
  "Strings": [{"Key": "LastName", "Value": "Upgraded Adventurer"}]
}
```

This recipe is to upgrade item's level, LastName, and attack.

Sample ModifyParams JSON with Program

```
{
  "Doubles": [{
    "Key": "attack", 
    "Program": "attack + 1"
  }],
  "Longs": [{
    "Key": "level", 
    "Program": "level + 1"
  }],
  "Strings": [{"Key": "LastName", "Program": "\"Upgraded Adventurer\""}]
}
```

#### CoinOutputs
This describes coin which can be generated from recipe.

| No | Field   | type   | sample       | description                                                         |
|----|---------|--------|--------------|---------------------------------------------------------------------|
| 1  | Coin    | string | "goldcoin"   | This shows the name of coin to be generated.                        |
| 2  | Count   | int    | 1            | This shows the number of coins to be generated.                     |
| 3  | Program | string | "attack x 2" | This is showing that user will collect attack x 2 amount of gold    |
| 4  | Weight  | int    | 1            | This is used to describe the percentage of coin could be generated. |

Sample CoinOutputs JSON
```
{
  "Coin":"submcoin",
  "Count":1,
  "Weight":1
}
```
Sample CoinOutputs JSON with Program
```
{
  "Coin":"submcoin",
  "Program":"attack x 2",
  "Weight":1
}
```

Here when program field is available, Count is ignored.

#### Program 

##### How program works in general
1) For first input, it can be used without setting `attack = input0.attack`
2) For multiple input cases, it can call `input1.attack` etc.
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

- `rand_int` function
Usecase: generate random value.
Example:  
```
rand_int(10)
```
Above code is for generation of random number from 0 - 9.

- `min_int` function
Usecase: get minimum value from two integer values
Example:
```
min_int(10, 11)
```
Above code's return value is 10

- `max_int` function
Usecase: get maximum value from two integer values
Example:
```
max_int(10, 11)
```
Above code's return value is 11

### Outputs

Outputs is an array of result sets by weights.

| No | Field         | type   | sample   | description                                                         |
|----|---------------|--------|----------|---------------------------------------------------------------------|
| 1  | ResultEntries | array  | [0, 1]   | This contains the result set that is consists of entry indexes.     |
| 2  | Weight        | string | "100-HP" | This is cel program which determines weight of specific result set. |

Sample Outputs JSON
```
  "Outputs": [
      {
          "ResultEntries": ["0"],
          "Weight": "1"
      }
  ],
```

When both CoinOutputs and ItemOutputs are available, indexing start from CoinOutputs.
```
    "Entries":{
        "CoinOutputs":[
            {
                "Coin":"javecoin",
                "Count":"100"
            }
        ],
        "ItemOutputs":[
            {
                "ModifyItem": {
                    "ItemInputRef": 0,
                    "ModifyParamsRef": "./recipes/javelin/upgrader/javelin_program.json"
                }
            }
        ]
    },
    "Outputs": [
        {
            "ResultEntries": ["1"],
            "Weight": "1"
        },
        {
            "ResultEntries": ["0", "1"],
            "Weight": "int(attack) * 2 + 1"
        }
    ],
```
e.g. on above, ResultEntries `[0, 1]` means javecoin + javelin, `[1]` means javelin

## Execution of recipes

Sampe Execution JSON
```
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
```
{
  "CoinInputs":[
      {
          "Coin": "pylon",
          "Count": "1"
      }
  ],
  "ItemInputRefs": [],
  "CoinOutputs": [{
      "denom":"eugencoin",
      "amount": "200"
  }],
  "ItemOutputNames": [],
  "ExtraInfo":"coin to coin trading",
  "Sender":"eugen"  
}
```
Coin to item trading
```
{
  "CoinInputs":[
      {
          "Coin": "pylon",
          "Count": "1"
      }
  ],
  "ItemInputRefs": null,
  "CoinOutputs": null,
  "ItemOutputNames": ["Trading Knife v1"],
  "ExtraInfo":"coin to item trading",
  "Sender":"eugen"
}
```
Item to coin trading
```
{
    "CoinInputs":[],
    "ItemInputRefs": [
        "./trades/item_input/trading_knife_v3.json"
    ],
    "CoinOutputs": [{
        "denom":"eugencoin",
        "amount": "200"
    }],
    "ItemOutputNames": [],
    "ExtraInfo":"item to coin trading",
    "Sender":"eugen"
}
```
Item to item trading
```
{
    "CoinInputs":[],
    "ItemInputRefs": [
        "./trades/item_input/trading_knife_v4.json"
    ],
    "CoinOutputs": [],
    "ItemOutputNames": ["Trading Knife v2"],
    "ExtraInfo":"item to item trading",
    "Sender":"eugen"
}
```

Trading order can be fulfilled by running MsgFulfillTrade
Sample JSON
```
{
  "TradeID": "ValidTradeIDXXXX",
  "Sender":"cosmos1mkk2q586y5pz263u5v8dv59723u58059ytprs9",
  "ItemIDs":[]
}
```

Here `TradeID` can be the one fetched from `list_trade` command.
`Sender` is fulfiller address.
`ItemIDs` field is used to mention which items of filfiller is going to participate in fulfilling trades.