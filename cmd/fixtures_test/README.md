# Introduction

Fixture test is a test to check all the cases are working.
After writing initial test, game developers can easily create new scenarios according to their game specification.

## Basic fields description

Scenario is set of steps and each step is carried out by one transaction.  
Here's sample scenario's step in JSON

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
            "property": [
                {
                    "owner": "account2",
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
            ]
        }
    }
```

First it can check if transaction run successfully and returned value is correct.
And also it can check if transaction fails when params are incorrect.
It is described in `txResult`.

It can also check if user's status is correct after doing a transaction.
Checkable things are items, recipes, cookbooks and coins.

It can make the system to run `create_cookbook`, `create_recipe`, `execute_recipe`, `check_execution`, `fiat_item`.

Detailed params can be found at `./scenarios/submarine.json`.
And to make things easier and to make scenario file smaller, there are references to other files.
For example when creating recipe, recipe spec is in `./recipes` folder.

hint.  
To ignore txResult Message, which is because it's ambitious to get which message to get, can just ignore TxResult.Message field like below.
```
    "txResult": {
        "status": "Success"
    },
```

## How a game producer write test 

Before reading this, he/she should know well about pylons eco system. Please read [DEVELOPER DOC](https://github.com/Pylons-tech/pylons/blob/master/DEVELOPER_DOC.md) and [README](https://github.com/Pylons-tech/pylons/blob/master/README.md) before reading this.

Game producers should create cookbooks, items, recipes, executions, check_executions and scenarios in JSON to test.  
You can check `scenarios`, `cookbooks`, `items`, `recipes`, `executions`, `check_executions` to get sample JSON formats you want to be aware of.

## How fixture test executor work

All the test scenarios are running in parallel. Some scenarios have dependencies and there are waiters.

Each steps have it's own ID like "CREATE_KNIFE_ITEM"
And to execute a recipe which requires this item, it should be done after waiting for this and it has `precondition` field `["CREATE_KNIFE_ITEM"]`.
Steps can wait more than one other steps and all the IDs can be added to the array.

`blockWait` field is number of blocks to wait after precondition is ok.

There's circular dependency checker and it will automatically fail if it's found by testing system.

## fixture test options

- runserial
Run fixture test in serial mode.
```
make fixture_tests ARGS="-runserial"
```

- userest
Send transactions by using rest endpoint.
```
make fixture_tests ARGS="-userest"
```

- use-known-cookbook
ignore create_cookbook message but just do update rest of them
```
make fixture_tests ARGS="-use-known-cookbook"
```
- specific scenarios test
If not specify this param, it tests all scenario files. If specify only do specific tests.
```
make fixture_tests ARGS="--scenarios=multi_msg_tx,double_empty"
```
- set account names to be used for the fixture tests.
The account names will replace all the placeholder account names in the fixture test files.
```
make fixture_tests ARGS="--accounts michael,eugen"
```

## To make fixture test scenarios clean

- Always try to make a new scenario when it is going to increase fixture test running time much.
- Always try to split scenarios to manage tests easily. 
