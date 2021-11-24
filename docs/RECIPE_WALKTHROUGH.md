# Recipe Walkthrough

### About this guide

The core of developing experiences on Pylons is the recipe. This guide provides an example game experience created with recipes on Pylons. We'll look at each recipe in detail, explaining a bit about how they work. This is only a small sample of the experiences one can create - we encourage developers to explore the system and try new things!

### Summary

We will:

1. Create a cookbook for the game
2. Create a recipe to create a character
3. Create a recipe to get cookbook tokens from a "cookbook faucet"
4. Create a recipe to buy a sword item
5. Create a recipe to fight an enemy
6. Execute our recipes to play the game experience!

### Creating the cookbook

When you want to develop on Pylons, the first step is always to create a cookbook. Cookbooks are the "containers" of a set of recipes, typically grouped together for a particular experience. A visual NFT artist will be creating many recipes to mint new image NFTs or a game will contain many recipes that together build the full experience. In both of these cases, all of the recipes would be contained within a single cookbook.

Let's start by creating the following cookbook:

```json
{
  "creator": "pylo1vn4p3v0u7l3c6jqup5j8fmhxnfumzl2094gtrc",
  "ID": "cookbookLOUD",
  "name": "Legend of the Undead Dragon",
  "description": "Cookbook for running pylons game experience LOUD",
  "developer": "Pylons Inc",
  "version": "v0.0.1",
  "supportEmail": "test@email.xyz",
  "enabled": true
}
```

- The "creator" is the string bech32 string of the Pylons address for the owner / creator of the cookbook. Ownership of cookbooks can change via the `transfer-cookbook` transaction.

- The "ID" is the unique identifier string of the cookbook. This is currently chosen by the developer when creating the cookbook.

- The "name", "description", "version" and "supportEmail" strings are additional metadata fields that the can provide users and apps with more details about the experience.

- The "version" is the string form of the cookbook's [semantic version](https://semver.org/). If the cookbook is updated, this version string MUST also be increased.

- The "enabled" field is a boolean to enable or disable the cookbook's functionality. If a cookbook is disabled, new recipes cannot be minted from it and existing recipes will no longer be able to be executed.

### A bit about recipes

The recipe structure is as follows:

```golang
type Recipe struct {
CookbookID    string            `protobuf:"bytes,1,opt,name=cookbookID,proto3" json:"cookbookID,omitempty"`
ID            string            `protobuf:"bytes,2,opt,name=ID,proto3" json:"ID,omitempty"`
NodeVersion   uint64            `protobuf:"varint,3,opt,name=nodeVersion,proto3" json:"nodeVersion,omitempty"`
Name          string            `protobuf:"bytes,4,opt,name=name,proto3" json:"name,omitempty"`
Description   string            `protobuf:"bytes,5,opt,name=description,proto3" json:"description,omitempty"`
Version       string            `protobuf:"bytes,6,opt,name=version,proto3" json:"version,omitempty"`
CoinInputs    []CoinInput       `protobuf:"bytes,7,rep,name=coinInputs,proto3" json:"coinInputs"`
ItemInputs    []ItemInput       `protobuf:"bytes,8,rep,name=itemInputs,proto3" json:"itemInputs"`
Entries       EntriesList       `protobuf:"bytes,9,opt,name=entries,proto3" json:"entries"`
Outputs       []WeightedOutputs `protobuf:"bytes,10,rep,name=outputs,proto3" json:"outputs"`
BlockInterval int64             `protobuf:"varint,11,opt,name=blockInterval,proto3" json:"blockInterval,omitempty"`
CostPerBlock  types.Coin        `protobuf:"bytes,12,opt,name=costPerBlock,proto3" json:"costPerBlock"`
Enabled       bool              `protobuf:"varint,13,opt,name=enabled,proto3" json:"enabled,omitempty"`
ExtraInfo     string            `protobuf:"bytes,14,opt,name=extraInfo,proto3" json:"extraInfo,omitempty"`
}

```

To get a better look at the data structures that comprise a Recipe, check out our technical [spec](https://github.com/Pylons-tech/pylons/x/pylons/spec/README.md). For now, let's briefly detail each field.

- The "CookbookID" field is the ID of the cookbook that _contains_ this recipe
- The "RecipeID" field is the unique identifier for this particular recipe
- The "Name" and "Description" fields are the name and description of the recipe
- The "CoinInputs" are the fields that detail what coins are required to run the recipe
- The "ItemInputs" is the field for items which are required to run the recipe
- The "Entries" field holds a list of the various outputs one could get from the recipe. Items are established with an ID and a set of doubles, longs, and strings to flesh oout the outputs.
- The "Outputs" field calls the unique IDs of the items in entries list and uses them as outputs after the execution of the recipe.
- The "BlockInterval" field indicates what block the recipe will execute. For instance, if blockInterval is at 2, the recipe won't execute until the chain has executed 2 blocks.
- The "CostPerBlock" field is a Cosmos SDK coin that is used to build the fee for paying to do the `execute-recipe` transaction before the recipe's `blockInterval` is met.
- The "Enabled" field is a boolean variable indicating if the recipe is enabled

### Character creation recipe

```json
{
  "cookbookID": "cookbookLOUD",
  "ID": "LOUDGetCharacter123125",
  "name": "LOUD-Get-Character-Recipe",
  "description": "Creates a basic character in LOUD",
  "version": "v0.0.1",
  "coinInputs": [],
  "itemInputs": [],
  "entries": {
    "coinOutputs": [],
    "itemOutputs": [
      {
        "ID": "basic_character_lv1",
        "doubles": [
          {
            "key": "XP",
            "weightRanges": [],
            "program": "1"
          }
        ],
        "longs": [
          {
            "key": "level",
            "weightRanges": [],
            "program": "1"
          },
          {
            "key": "giantKills",
            "weightRanges": [],
            "program": "0"
          },
          {
            "key": "special",
            "weightRanges": [],
            "program": "0"
          },
          {
            "key": "specialDragonKill",
            "weightRanges": [],
            "program": "0"
          },
          {
            "key": "undeadDragonKill",
            "weightRanges": [],
            "program": "0"
          }
        ],
        "strings": [
          {
            "key": "entityType",
            "value": "character"
          }
        ],
        "mutableStrings": [],
        "transferFee": [],
        "tradePercentage": "0.100000000000000000",
        "tradeable": true
      }
    ],
    "itemModifyOutputs": []
  },
  "outputs": [
    {
      "entryIDs": ["basic_character_lv1"],
      "weight": 1
    }
  ],
  "blockInterval": 0,
  "costPerBlock": {
    "denom": "upylon",
    "amount": "1000000"
  },
  "enabled": true,
  "extraInfo": "extraInfo"
}
```

Here we implement a basic recipe, one that builds a unique base character with a few features: level, XP, giant kills, etc. Anything you wish for a character to have in their game utilities or arsenal you place them within the 'item outputs' under their type of output (double, long, string).

Note both coinInputs and itemInputs are empty, so this recipe doesn't require anything to execute. given that this is a basic character, mutableStrings, transferFee and itemModifyOutputs are empty. TradePercentage refers to the percentage of a trade sale retained by the cookbook owner (In the range 0.0 to 1.0) and the boolean field tradable is true (item can be traded).

In the outputs field we return the new character by calling the item output ID. Weight refers how often it will occur and since the character is are only output it'll always return a character.

### Cookbook tokens facuet recipe

```json
{
  "cookbookID": "cookbookLOUD",
  "ID": "LOUD_Get_Coins103120312",
  "name": "LOUD-get-coins",
  "description": "Gives a player 10000 loudCoin",
  "version": "v0.0.1",
  "coinInputs": [],
  "itemInputs": [],
  "entries": {
    "coinOutputs": [
      {
        "ID": "loudCoin",
        "coin": {
          "denom": "cookbookLOUD/loudCoin",
          "amount": "10000"
        }
      }
    ],
    "itemOutputs": [],
    "itemModifyOutputs": []
  },
  "outputs": [
    {
      "entryIDs": ["loudCoin"],
      "weight": 1
    }
  ],
  "blockInterval": 0,
  "costPerBlock": {
    "denom": "upylon",
    "amount": "1000000"
  },
  "enabled": true,
  "extraInfo": "extraInfo"
}
```

This recipe should be even simplier to understand after building a base character. We fill the cookbook info, name, description, etc. with all the info the recipe needs to be identified. coinInputs and itemInputs remain empty because in this game, nothing is required to get LOUD coins. In itemOutputs however, we use a unique field for coin outputs ('coin'). Here we indicate what kind of coin it is through denom, and the amount we wish to output when this recipe is executed. No other field is required to fill in. Again, in outputs we call the item output ID with a weight of 1. In addition we've enabled the recipe.

### Sword purchase recipe

```json
{
  "cookbookID": "cookbookLOUD",
  "ID": "LOUDbuyCopperSword123125",
  "name": "LOUD-Buy-Copper-Sword",
  "description": "Purchases a copper sword for loudCoin",
  "version": "v0.0.1",
  "coinInputs": [
    {
      "coins": [
        {
          "denom": "cookbookLOUD/loudCoin",
          "amount": "10"
        }
      ]
    }
  ],
  "itemInputs": [],
  "entries": {
    "coinOutputs": [],
    "itemOutputs": [
      {
        "ID": "copper_sword_lv1",
        "doubles": [
          {
            "key": "attack",
            "weightRanges": [],
            "program": "10.0"
          }
        ],
        "longs": [
          {
            "key": "level",
            "weightRanges": [],
            "program": "1"
          },
          {
            "key": "value",
            "weightRanges": [],
            "program": "250"
          }
        ],
        "strings": [
          {
            "key": "name",
            "value": "Copper Sword"
          }
        ],
        "mutableStrings": [],
        "transferFee": [],
        "tradePercentage": "0.100000000000000000",
        "tradeable": true
      }
    ],
    "itemModifyOutputs": []
  },
  "outputs": [
    {
      "entryIDs": ["copper_sword_lv1"],
      "weight": 1
    }
  ],
  "blockInterval": 0,
  "costPerBlock": {
    "denom": "upylon",
    "amount": "1000000"
  },
  "enabled": true,
  "extraInfo": "extraInfo"
}
```

Let's see if you can follow along with this more complex recipe. We have all of our identifying information about the recipe in name, id, cookbook, etc. and we are trying to purchase a sword for our character. In coinInputs we can add the coin input to indicate what kind of coin our user ould need to execute this type of recipe, which in this case is the unique LOUD coin from our game. We've also indicated that the user needs at least 10 LOUD coins to execute this recipe. We don't intake any items, just coins.

As we move along to outputs, we can see we don't output any coins but we do have an item called 'copper_sword_lv1'. Let's look at our first output in doubles. We use 'key' to indicate the unique feature from the sword. Our first one is 'attack' which indicates an attack function. weightRanges is empty, but in future can be used to help randomize the attack/how intense it is. Our final field is 'program', which can run a program each time a 'attack' is called from the sword. For now we have '10.0' which means we'll be getting 10.0 point attack from the sword. In long and string output fields, we assign outputs/values to features of the sword, like 'level', 'value', and 'name'.

Finally we have have our tradePercentage, tradeable, and outputs reflecting what we've used in previous recipes.

### Enemy encounter recipe

```json
{
  "cookbookID": "cookbookLOUD",
  "ID": "LOUDFightWolfWithSword123125",
  "name": "LOUD-Fight-Wolf-With-Sword-Recipe",
  "description": "creates a fight instance with a wolf requiring a character and a sword",
  "version": "v0.0.1",
  "coinInputs": [],
  "itemInputs": [
    {
      "ID": "character",
      "doubles": [
        {
          "key": "XP",
          "minValue": "1.000000000000000000",
          "maxValue": "10000000.000000000000000000"
        }
      ],
      "longs": [
        {
          "key": "level",
          "minValue": 1,
          "maxValue": 10000000
        }
      ],
      "strings": [
        {
          "key": "entityType",
          "value": "character"
        }
      ],
      "conditions": {
        "doubles": [],
        "longs": [],
        "strings": []
      }
    },
    {
      "ID": "sword",
      "doubles": [
        {
          "key": "attack",
          "minValue": "1.000000000000000000",
          "maxValue": "10000000.000000000000000000"
        }
      ],
      "longs": [
        {
          "key": "level",
          "minValue": 1,
          "maxValue": 10000000
        }
      ],
      "strings": [],
      "conditions": {
        "doubles": [],
        "longs": [],
        "strings": []
      }
    }
  ],
  "entries": {
    "coinOutputs": [
      {
        "ID": "coin_reward",
        "coin": {
          "denom": "cookbookLOUD/loudCoin",
          "amount": "10"
        }
      }
    ],
    "itemOutputs": [
      {
        "ID": "wolf_tail",
        "doubles": [
          {
            "key": "attack",
            "weightRanges": [],
            "program": "0.0"
          }
        ],
        "longs": [
          {
            "key": "level",
            "weightRanges": [],
            "program": "1"
          },
          {
            "key": "value",
            "weightRanges": [],
            "program": "140"
          }
        ],
        "strings": [
          {
            "key": "name",
            "value": "Wolf Tail"
          }
        ],
        "mutableStrings": [],
        "transferFee": [],
        "tradePercentage": "0.100000000000000000",
        "tradeable": true
      },
      {
        "ID": "wolf_fur",
        "doubles": [
          {
            "key": "attack",
            "weightRanges": [],
            "program": "0.0"
          }
        ],
        "longs": [
          {
            "key": "level",
            "weightRanges": [],
            "program": "1"
          },
          {
            "key": "value",
            "weightRanges": [],
            "program": "140"
          }
        ],
        "strings": [
          {
            "key": "Name",
            "value": "Wolf Fur"
          }
        ],
        "mutableStrings": [],
        "transferFee": [],
        "tradePercentage": "0.100000000000000000",
        "tradeable": true
      }
    ],
    "itemModifyOutputs": [
      {
        "ID": "modified_character",
        "itemInputRef": "character",
        "doubles": [
          {
            "key": "XP",
            "weightRanges": [],
            "program": "XP + double(15 * 3)"
          }
        ],
        "longs": [
          {
            "key": "level",
            "weightRanges": [],
            "program": "level + int(XP / double(level * level * level + 5))"
          }
        ],
        "strings": [],
        "mutableStrings": [],
        "transferFee": [],
        "tradePercentage": "0.100000000000000000",
        "tradeable": true
      },
      {
        "ID": "sword",
        "itemInputRef": "sword",
        "doubles": [],
        "longs": [],
        "strings": [],
        "mutableStrings": [],
        "transferFee": [],
        "tradePercentage": "0.100000000000000000",
        "tradeable": true
      }
    ]
  },
  "outputs": [
    {
      "weight": 3
    },
    {
      "entryIDs": ["coin_reward", "modified_character"],
      "weight": 3
    },
    {
      "entryIDs": ["coin_reward", "modified_character", "sword"],
      "weight": 24
    },
    {
      "entryIDs": ["coin_reward", "modified_character", "sword", "wolf_tail"],
      "weight": 40
    },
    {
      "entryIDs": ["coin_reward", "modified_character", "sword", "wolf_fur"],
      "weight": 30
    }
  ],
  "blockInterval": 0,
  "costPerBlock": {
    "denom": "upylon",
    "amount": "1000000"
  },
  "enabled": true,
  "extraInfo": "extraInfo"
}
```

This recipe is complex, but given what we know from before let's dissect it. We have our identifiying information for the recipe in cookbookID, Id, name, etc. In order for the recipe to execute, we require a 'character' that requires XP at a minimum amount of 1, a level status at least at level 1, and it needs to have the entitiyType of a 'character'. We also need the sword that we created in the recipe earlier on, with the specific features we reference in the double/long/string fields. Conditions can also be used.

Ouputs is where it gets interesting. First we output coins: if you look you can see we're giving back ten LOUD coins. In addition we have some unique items which look similar to the recipes we've toyed with before. We have a wolf tail and wolf fur (both have attacks at 0, level at 1, and value at 140). In ItemModifyOutputs, we can modify one of our inputs. In this case we modify our 'character' which we indicate with 'itemInputRef'. The modification looks the exact same as the other recipes we've built but we can use the program field to actively change our stats on chain. Note that we reference some of the past keys like level and XP. The program takes our previous stats and upgrades them within our program field.

In our output field, we have five options for output. The output is determined by the weight: the higher the weight, the higher the chance of receiving that output. Within our entryIDs we reference which items we want to be outputted by calling the unique IDs.

### Recap

| Field         | Type              | Description                                  |
| --------------| ----------------- | -------------------------------------------- |
| cookbookID    | string            | the cookbook for your application            |
| ID            | string            | the unique identifier for the recipe         |
| name          | string            | name of the recipe                           |
| description   | string            | description of the recipe                    |
| version       | string            | version of recipe                            |
| coinInputs    | []CoinInput       | coins required to run the recipe             |
| itemInputs    | []ItemInput       | items required to run the recipe             |
| entries       | EntriesList       | create the item                              |
| outputs       | []WeightedOutputs | recipe's outputs after execution             |
| blockInterval | int64             | block delay until execution is finalized     |
| costPerBlock  | sdk.Coin          | cost to complete execution early per block   |
| enabled       | boolean           | enabled the recipe for execution             |
| extraInfo     | string            | additional info                              |
