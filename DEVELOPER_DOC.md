# Introduction

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

| No | Field         | Type   | Sample                                                       | Description                                                |
|----|---------------|--------|--------------------------------------------------------------|------------------------------------------------------------|
| 1  | CookbookName  | string | "submarine"                                                  | contains the name of cookbook for the recipe.              |
| 2  | Name          | string | "Knife Shield Generation Recipe"                             | name of recipe.                                            |
| 3  | Description   | string | "level 1 knife and level 1 shield into level 1 knife-shield" | recipe description                                         |
| 4  | Sender        | string | "eugen"                                                      | recipe owner name.                                         |
| 5  | RType         | Enum   | GENERATION(0) | UPGRADE(1)                                   | type of recipe (create new item or update existing item)   |
| 6  | CoinInputs    | array  | "goldcoin": 1, "silvercoin": 1                               | required coins to run recipe.                              |
| 7  | ItemInputs    | array  | level 1 knife, level 1 shield                                | required items to run recipe.                              |
| 8  | Entries       | array  | level 1 knife-shield                                         | Items and coins which can be generated from this recipe.   |
| 9  | ToUpgrade     | array  | attack: +1, level: +1, name: 'updated item'                  | modification values for all fields which need updates.     |
| 9  | BlockInterval | int    | 2                                                            | Recipe is able to produce output after BlockInterval time. |

Sample generator JSON

```
{
  "RType": "0",
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

Sample upgrader JSON

```
{
  "RType": "1",
  "CoinInputs":[],
  "ItemInputRefs": [
    "./recipes/item_input/adventurer.json"
  ],
  "ToUpgradeRef": "./recipes/upgrader/adventurer.json",
  "ExtraInfo":"",
  "Sender":"eugen",
  "Name": "Adventurer Upgrade Recipe",
  "CookbookName": "helicopter",
  "Description": "this recipe is used to upgrade adventurer which can update all versions of adventurer.",
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

#### ToUpgrade
This describes the fields of ToUpgrade field of item upgrade recipe.

| No | Field         | Type       | Sample               | Description                        |
|----|---------------|------------|----------------------|------------------------------------|
| 1  | Doubles       | array      | attack: +1.0         | contains double attributes updates |
| 2  | Longs         | array      | level: +1            | contains int attributes updates    |
| 3  | Strings       | array      | name: "Level2 Knife" | contains string attributes updates |

Upgrade also has random effect and for that, weightRanges are used for Doubles and Longs.

Sample ToUpgrade JSON

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

#### Program 

1) for first input, it can be used without setting `attack = input0.attack`
2) for multiple input cases, it can call `input1.attack` etc.
3) I have tested `+`, `*`  in double/long and merge string operation using `+` for now
`input0.attack + input1.attack`
`(input0.attack + input1.attack) * 0.7`
`"Old " + "Knife"`