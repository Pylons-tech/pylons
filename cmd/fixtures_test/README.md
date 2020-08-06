# Introduction

Fixture test is a test to check the actions step by step written in json.
After building recipes, game developers can easily create new scenarios according to their game specification.

## Basic fields description

Scenario is set of steps and each step is carried out by one or more transactions.  
Here's sample scenario's step in JSON

```json
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

First it can check if transaction ran successfully and returned value is correct.
And also it can check transaction failure when params are incorrect.
It is described in `txResult`.

It can also check if users' statuses are correct after doing a transaction.
Checkable things are coins items, cookbooks, recipes and trades.

Action types are determined by the message types and combined messages that are commonly used together.
As long as more actions are added, this should be modified

```go
	"create_account" // create account on chain
	"get_pylons" // get pylons faucet
	"mock_account" // create_account + get_pylons
	"send_coins" // send coins
	"fiat_item" // generate item
	"update_item_string" // update item's string field
	"send_items" // send item
	"create_cookbook" // create cookbook
	"mock_cookbook" // mock_account + create_cookbook
	"create_recipe" // create recipe
	"execute_recipe" // execute recipe
	"check_execution" // finish the scheduled execution
	"create_trade" // create trade
	"fulfill_trade" // fulfill trade
	"disable_trade" // disable trade
	"multi_msg_tx" // merge all the above actions into one transaction
```

Details can be found at `./scenarios/submarine.json`.
And to make things easier and to make scenario file shorter, there are references to other files.
For example for recipe, recipe spec is in `./recipes` folder.

Hint.  
To ignore txResult Message, which is because it's ambitious to get which message to get, can just ignore TxResult.Message field like below.
```json
    "txResult": {
        "status": "Success"
    },
```

## How a game producer write test 

Before reading this, he/she should know well about pylons eco system. Please read [DEVELOPER DOC](https://github.com/Pylons-tech/pylons/blob/master/DEVELOPER_DOC.md) and [README](https://github.com/Pylons-tech/pylons/blob/master/README.md) before reading this.

Game producers should create cookbooks, items, recipes, executions, check_executions and scenarios in JSON to test.  
You can check `scenarios`, `cookbooks`, `items`, `recipes`, `executions`, `check_executions` to get sample JSON formats you want to be aware of.

## How fixture test executor work

There are two ways to run fixture test. 
One in parallel and the other in sequential.
Some scenarios have dependencies and there are waiters.

Each steps have it's own ID like "CREATE_KNIFE_ITEM"
And to execute a recipe which requires this item, it should be done after waiting for this and it has `precondition` field `["CREATE_KNIFE_ITEM"]`.
Steps can wait more than one other steps and all the IDs can be added to the array.

`blockWait` field is number of blocks to wait after precondition is ok.

There's circular dependency checker and it will automatically fail if it's found by testing system.

## fixture test options

- set account names to be used for the fixture tests.
The account names will replace all the placeholder account names in the fixture test files.
```
make fixture_tests ARGS="--accounts=michael,eugen"
```

- runserial
Run fixture test in serial mode. (sequential order)
```sh
make fixture_tests ARGS="-runserial --accounts=michael,eugen"
```

- userest
Send transactions by using rest endpoint.
```sh
make fixture_tests ARGS="-userest --accounts=michael,eugen"
```

- use-known-cookbook
Ignore create_cookbook message but just do update rest of them
```sh
make fixture_tests ARGS="-use-known-cookbook --accounts=michael,eugen"
```
- verify-only
Verification stuff for fixture test
```sh
make fixture_tests ARGS="-verify-only --accounts=michael,eugen"
```
- specific scenarios test
If not specify this param, it tests all scenario files. If specify only do specific tests.
```sh
make fixture_tests ARGS="--scenarios=multi_msg_tx,double_empty --accounts=michael,eugen"
```

## To make fixture test scenarios clean

- Always try to make a new scenario when it is going to increase fixture test running time much for dependencies.
- Always try to split scenarios to manage tests easily. 
- Always use different account per scenario
- Always make a test does not interact with another test when running in parallel
