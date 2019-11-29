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