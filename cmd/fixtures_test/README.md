# Introduction

Fixture test is a test to check all the cases are working.
After writing initial test, game developers can easily customize this scenarios since it is based in JSON.

## What can be tested with this

Here's sample step in JSON

```
    {
        "ID": "EXECUTE_HELI_STRAIGHT_ATTACK_KNIFE_RECIPE",        
        "runAfter": {
            "precondition": ["CREATE_HELI_STRAIGHT_ATTACK_KNIFE_RECIPE"],
            "blockWait": 0
        },
        "action": "execute_recipe",
        "paramsRef": "./executions/heli_straight_attack_knife.json",
        "output": {
            "txResult": {
                "status": "Success",
                "message": "successfully executed the recipe"
            },
            "property": {
                "owner": "eugen",
                "items": [
                    {
                        "stringKeys": [],
                        "stringValues": { "Name": "Helicopter's Straight Attack Knife" },
                        "dblKeys": [],
                        "dblValues": {},
                        "longKeys": [],
                        "longValues": {}
                    }
                ]
            }
        }
    }
```

First it can check if transaction run successfully and returned value is correct.
It is described in `txResult`.

It can also check if user's status is correct after doing a transaction.
Checkable things are items, recipes, cookbooks and coins.

It can make the system to run `create_cookbook`, `create_recipe`, `execute_recipe`, `check_execution`, `fiat_item`.

Detailed params can be found at `./scenarios/submarine.json`.
And to make things easier and to make scenario file smaller, there are references to other files.
For example when creating recipe, recipe spec is in `./recipes` folder.

## How it is working in background

All the test scenarios are running in parallel. Some scenarios have dependencies and there are waiters.

Each steps have it's own ID like "CREATE_KNIFE_ITEM"
And to execute a recipe which requires this item, it should be done after waiting for this and it has `precondition` field `["CREATE_KNIFE_ITEM"]`.
Steps can wait more than one other steps and all the IDs can be added to the array.

`blockWait` field is number of blocks to wait after precondition is ok.

There's circular dependency checker and it will automatically fail if it's found by testing system.