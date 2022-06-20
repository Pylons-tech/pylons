package main

import (
	"bytes"
	"fmt"
	"log"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
)

const (
	badPLC  = "bad.plc"
	goodPLC = "good.plc"
	badPLR  = "bad.plr"
	goodPLR = "good.plr"
)

const badCookbookLiteral = `{
    "cookbookID": "cookbookLoudTest",

    "description": "this isn't a cookbook! that's the point! don't fix it!",
    "version": "v0.0.1",
    "coinInputs": [],
    "itemInputs": [],
    "entries": "nar",
    "outputs": [
        {
            "entryIDs": [
                "loudCoin"
            ],
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
}`
const goodCookbookLiteral = `{
	"creator": "pylo199cq5r46uqsjxqv05c5x7nx22yxdawne550hsy",
	"ID": "cookbookLoudTest",
	"name": "Legend of the Undead Dragon",
	"description": "Cookbook for running pylons game experience LOUD",
	"developer": "Pylons Inc",
	"version": "v0.0.1",
	"supportEmail": "noreply@pylons.tech",
	"enabled": true
  }`
const badRecipeLiteral = `{
    "cookbookID": "cookbookLoudTest",
    "ID": "LOUDGetCharacter",
    "name": "LOUD-Get-Character-Recipe",
    "description": "Creates a basic character in LOUD (but don't b/c it doesn't work)",
    "version": "v0.0.1",
    "coinInputs": [],
	"beef": "edible",
    "itemInputs": [],
    "entries": {
        "coinOutputs": [],
        "itemOutputs": [
            {
                "ID": "character",
                "doubles": [
                    {
                        "key": "XP",
                        "weightRanges": [],
                        "program": "1"
                    }
                ],
                "longs": [
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
            "entryIDs": [
                "character"
            ],
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
}`
const goodRecipeLiteral = `{
    "cookbookID": "cookbookLoudTest",
    "ID": "LOUDGetCharacter",
    "name": "LOUD-Get-Character-Recipe",
    "description": "Creates a basic character in LOUD",
    "version": "v0.0.1",
    "coinInputs": [],
    "itemInputs": [],
    "entries": {
        "coinOutputs": [],
        "itemOutputs": [
            {
                "ID": "character",
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
                        "key": "goblinKills",
                        "weightRanges": [],
                        "program": "0"
                    },
                    {
                        "key": "trollKills",
                        "weightRanges": [],
                        "program": "0"
                    },
                    {
                        "key": "dragonKills",
                        "weightRanges": [],
                        "program": "0"
                    },
                    {
                        "key": "chestState_00",
                        "weightRanges": [],
                        "program": "0"
                    },
                    {
                        "key": "chestState_01",
                        "weightRanges": [],
                        "program": "0"
                    },
                    {
                        "key": "chestState_02",
                        "weightRanges": [],
                        "program": "0"
                    },
                    {
                        "key": "chestState_03",
                        "weightRanges": [],
                        "program": "0"
                    },
                    {
                        "key": "chestState_04",
                        "weightRanges": [],
                        "program": "0"
                    },
                    {
                        "key": "chestState_05",
                        "weightRanges": [],
                        "program": "0"
                    },
                    {
                        "key": "chestState_06",
                        "weightRanges": [],
                        "program": "0"
                    },
                    {
                        "key": "chestState_07",
                        "weightRanges": [],
                        "program": "0"
                    },
                    {
                        "key": "foeState_00",
                        "weightRanges": [],
                        "program": "0"
                    },
                    {
                        "key": "foeState_01",
                        "weightRanges": [],
                        "program": "0"
                    },
                    {
                        "key": "foeState_02",
                        "weightRanges": [],
                        "program": "0"
                    },
                    {
                        "key": "foeState_03",
                        "weightRanges": [],
                        "program": "0"
                    },
                    {
                        "key": "foeState_04",
                        "weightRanges": [],
                        "program": "0"
                    },
                    {
                        "key": "foeState_05",
                        "weightRanges": [],
                        "program": "0"
                    },
                    {
                        "key": "foeState_06",
                        "weightRanges": [],
                        "program": "0"
                    },
                    {
                        "key": "foeState_07",
                        "weightRanges": [],
                        "program": "0"
                    },
                    {
                        "key": "vendorState_00",
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
            "entryIDs": [
                "character"
            ],
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
}`

func TestValidate(t *testing.T) {
	preTestValidate(t)

	t.Run("Bad cookbook", func(t *testing.T) {
		var buf bytes.Buffer
		Out = &buf
		defer func() { Out = os.Stdout }()
		cmd := CmdDevValidate()
		cmd.SetArgs([]string{badPLC})
		cmd.Execute()
		log.SetOutput(os.Stderr)
		str := buf.String()
		assert.NotEqual(t, "bad.plc is a valid cookbook\n", str)
		t.Log(str)
	})

	t.Run("Good cookbook", func(t *testing.T) {
		var buf bytes.Buffer
		Out = &buf
		defer func() { Out = os.Stdout }()
		fmt.Print()
		cmd := CmdDevValidate()
		cmd.SetArgs([]string{goodPLC})
		cmd.Execute()
		log.SetOutput(os.Stderr)
		str := buf.String()
		assert.Equal(t, "good.plc is a valid cookbook\n", str)
		t.Log(str)
	})

	t.Run("Bad recipe", func(t *testing.T) {
		var buf bytes.Buffer
		Out = &buf
		defer func() { Out = os.Stdout }()
		cmd := CmdDevValidate()
		cmd.SetArgs([]string{badPLR})
		cmd.Execute()
		log.SetOutput(os.Stderr)
		str := buf.String()
		assert.NotEqual(t, "bad.plr is a valid recipe\n", str)
		t.Log(str)
	})

	t.Run("Good recipe", func(t *testing.T) {
		var buf bytes.Buffer
		Out = &buf
		defer func() { Out = os.Stdout }()
		fmt.Print()
		cmd := CmdDevValidate()
		cmd.SetArgs([]string{goodPLR})
		cmd.Execute()
		log.SetOutput(os.Stderr)
		str := buf.String()
		assert.Equal(t, "good.plr is a valid recipe\n", str)
		t.Log(str)
	})
}

// Generates the test files in the appropriate paths under the current working directory.
// This is kinda icky, but it lets us test the entire production implementation w/o having to
// deal w/ finding the testdata from an unknown state.
func preTestValidate(t *testing.T) {
	file, err := os.Create(badPLC)
	if err != nil {
		file.WriteString(badCookbookLiteral)
		file.Close()
	}
	file, err = os.Create(goodPLC)
	if err != nil {
		file.WriteString(goodCookbookLiteral)
		file.Close()
	}
	file, err = os.Create(badPLR)
	if err != nil {
		file.WriteString(badRecipeLiteral)
		file.Close()
	}
	file, err = os.Create(goodPLR)
	if err != nil {
		file.WriteString(goodRecipeLiteral)
		file.Close()
	}
}
