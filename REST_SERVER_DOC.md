# Introduction

Using REST interface server is the easiest way to fetch results in REST interface.

## Running rest server
```
pylonscli rest-server --chain-id pylonschain --trust-node
```
## Fetching
This describes regular format of REST endpoints and samples for all endpoints.

### recipes

Format
```
http://${HOST}/pylons/list_recipe/${ownerKeyName}
```
Sample
```
http://localhost:1317/pylons/list_recipe/cosmos19vlpdf25cxh0w2s80z44r9ktrgzncf7zsaqey2
```

Sample Result
```
{
    "Recipes": [
        {
            "ID": "cosmos19vlpdf25cxh0w2s80z44r9ktrgzncf7zsaqey211e97497-0c94-4fa1-94af-424b89630abc",
            "CookbookID": "cosmos19vlpdf25cxh0w2s80z44r9ktrgzncf7zsaqey20d876595-0a51-4584-8293-dfecb5874d55",
            "Name": "Helicopter's Straight Attack Knife Generation Recipe",
            "CoinInputs": null,
            "ItemInputs": null,
            "Entries": {
                "CoinOutputs": null,
                "ItemOutputs": [
                    {
                        "Doubles": [
                            {
                                "Rate": "1.0",
                                "Key": "endurance",
                                "WeightRanges": [
                                    {
                                        "Lower": "100.00",
                                        "Upper": "500.00",
                                        "Weight": 6
                                    },
                                    {
                                        "Lower": "501.00",
                                        "Upper": "800.00",
                                        "Weight": 2
                                    }
                                ]
                            }
                        ],
                        "Longs": [
                            {
                                "Key": "HP",
                                "Rate": "",
                                "WeightRanges": [
                                    {
                                        "Lower": 100,
                                        "Upper": 500,
                                        "Weight": 6
                                    },
                                    {
                                        "Lower": 501,
                                        "Upper": 800,
                                        "Weight": 2
                                    }
                                ]
                            }
                        ],
                        "Strings": [
                            {
                                "Key": "Name",
                                "Value": "Helicopter's Straight Attack Knife",
                                "Rate": "1.0"
                            }
                        ],
                        "Weight": 1
                    }
                ]
            },
            "Description": "this has to meet character limits lol",
            "BlockInterval": "0",
            "Sender": "cosmos19vlpdf25cxh0w2s80z44r9ktrgzncf7zsaqey2",
            "Disabled": false
        }
    ]
}
```