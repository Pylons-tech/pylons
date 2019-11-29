# Introduction

Pylons eco system consists of cookbooks, items, coin and recipes.

Here's detailed description of how to use create cookbooks, items, coins and recipes which are compatible with pylons eco system.

## Cookbook

Cookbook consists of below fields.

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

| No | Field        | Type   | Sample                                | Description                                 |
|----|--------------|--------|---------------------------------------|---------------------------------------------|
| 1  | CookbookName | string | "submarine"                           | contains the name of cookbook for the item. |
| 2  | Sender       | string | "eugen"                               | contains the owner of item.                 |
| 3  | Doubles      | array  | defence: 1.0,  movement: 1.0          | contains double attributes of the item.     |
| 4  | Longs        | array  | level: 1                              | contains int attributes of the item.        |
| 5  | Strings      | array  | name: "shield", use: "defend and run" | contains string attributes of the item.     |

Sample item JSON

```
{
  "Doubles": [{ "Key": "defence", "Value": "1" }],
  "Longs": [{ "Key": "level", "Value": "1" }],
  "Strings": [{ "Key": "Name","Value": "Shield" }],
  "CookbookName": "submarine",
  "Sender": "eugen"
}
```

## Recipe

Recipe consists of below fields.

| No | Field         | Type   | Sample                                                       | Description                                                |
|----|---------------|--------|--------------------------------------------------------------|------------------------------------------------------------|
| 1  | CookbookName  | string | "submarine"                                                  | contains the name of cookbook for the recipe.              |
| 2  | Name          | string | "Knife Shield Generation Recipe"                             | name of recipe.                                            |
| 3  | Description   | string | "level 1 knife and level 1 shield into level 1 knife-shield" | recipe description                                         |
| 4  | Sender        | string | "eugen"                                                      | recipe owner name.                                         |
| 5  | CoinInputs    | array  | "goldcoin": 1, "silvercoin": 1                               | required coins to run recipe.                              |
| 6  | ItemInputs    | array  | level 1 knife, level 1 shield                                | required items to run recipe.                              |
| 7  | Entries       | array  | level 1 knife-shield                                         | Items and coins which can be generated from this recipe.   |
| 8  | BlockInterval | int    | 2                                                            | Recipe is able to produce output after BlockInterval time. |

Sample recipe JSON

```
{
  "CoinInputs":[],
  "ItemInputRefs": [
    "./recipes/item_input/knife_lv1.json",
    "./recipes/item_input/shield_lv1.json"
  ],
  "Entries":{
    "CoinOutputs":[],
    "ItemOutputs":[
      {
        "Ref": "./recipes/item_output/knife_shield_lv1.json",
        "Weight":1
      }
    ]
  },
  "ExtraInfo":"",
  "Sender":"eugen",
  "Name": "Knife Shield Generation Recipe",
  "CookbookName": "submarine",
  "Description": "this recipe is merging level 1 knife and level 1 shield into level 1 knife-shield.",
  "BlockInterval":"0"
}
```

### ItemInputs
This field is showing required items to run recipe.

| No | Field   | type  | sample           | description                                |
|----|---------|-------|------------------|--------------------------------------------|
| 1  | Doubles | array | "attack": 1      | required conditions for double attributes. |
| 2  | Longs   | array | "level": 1       | required conditions for int attributes.    |
| 3  | Strings | array | "name": "shield" | required conditions for string attributes. |

| No | Field    | Type       | sample   | description                                                                         |
|----|----------|------------|----------|-------------------------------------------------------------------------------------|
| 1  | Key      | string     | "attack" | attribute of item to check.                                                         |
| 2  | Value    | string     | 1        | item's "Key" attribute shoud be same as this value.                                 |
| 3  | MinValue | int/double | 1        | For int/double values they are checked with range and this describes minimum value. |
| 4  | MaxValue | int/double | 2        | For int/double values they are checked with range and this describes maximum value. |

Sample ItemInputs JSON

```
[{
  "Doubles": [{"Key": "attack", "MinValue": "1", "MaxValue": "1"}],
  "Longs": [{"Key": "level", "MinValue": "1", "MaxValue": "1"}],
  "Strings": [{"Key": "Name", "Value": "Knife"}]
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
      "Weight":1
    }
  ]
}
```
#### ItemOutputs
This describes item which can be generated from recipe.

| No | Field        | type   | sample         | description                                                                      |
|----|--------------|--------|----------------|----------------------------------------------------------------------------------|
| 1  | Key          | string | attack         | attribute which want to describe.                                                |
| 2  | Rate         | double | 0.5            | This describes the percentage of the attribute is available or not.              |
| 3  | Value        | string | "Knife Shield" | string attribute of item output.                                                 |
| 4  | WeightRanges | array  | 3-5            | the recipe has randomness in output and this field is for int/double attributes. |

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
#### CoinOutputs
This describes coin which can be generated from recipe.

| No | Field  | type   | sample     | description                                                         |
|----|--------|--------|------------|---------------------------------------------------------------------|
| 1  | Coin   | string | "goldcoin" | This shows the name of coin to be generated.                        |
| 2  | Count  | int    | 1          | This shows the number of coins to be generated.                     |
| 3  | Weight | int    | 1          | This is used to describe the percentage of coin could be generated. |

Sample CoinOutputs JSON
```
{
  "Coin":"submcoin",
  "Count":1,
  "Weight":1
}
```