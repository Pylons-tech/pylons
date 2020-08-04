package handlers

import (
	"encoding/json"
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestCustomCreateRecipeValidateBasic(t *testing.T) {
	recipeJSON := `
		{
			"BlockInterval": "0",
			"CoinInputs": [
			  {
				"Coin": "pylon",
				"Count": "1"
			  }
			],
			"CookbookID": "LOUD-v0.1.0-1579053457",
			"Description": "test recipe from test suite",
			"Entries": {
			  "CoinOutputs": null,
			  "ItemModifyOutputs": null,
			  "ItemOutputs": [
				{
				  "Doubles": [
					{
					  "Key": "Mass",
					  "Program": "",
					  "Rate": "1",
					  "WeightRanges": [
						{
						  "Lower": "50",
						  "Upper": "100",
						  "Weight": 1
						}
					  ]
					}
				  ],
				  "ID": "a0",
				  "Longs": null,
				  "Strings": [
					{
					  "Key": "Name",
					  "Program": "",
					  "Rate": "1",
					  "Value": "Mars"
					}
				  ],
				  "TransferFee": 0
				}
			  ]
			},
			"ItemInputs": null,
			"Name": "RTEST_1596513734",
			"Outputs": [
			  {
				"EntryIDs": ["a0"],
				"Weight": "1"
			  }
			],
			"Sender": "cosmos1g5w79thfvt86m6cpa0a7jezfv0sjt0u7y09ldm"
		}`

	tci := keep.SetupTestCoinInput()
	msg := msgs.MsgCreateRecipe{}
	err := tci.Cdc.UnmarshalJSON([]byte(recipeJSON), &msg)
	require.True(t, err == nil, err)
	err = msg.ValidateBasic()
	require.True(t, err == nil, err)
}

func TestHandlerMsgCreateRecipe(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	sender, _, _, _ := keep.SetupTestAccounts(t, tci, nil, nil, nil, nil)

	cases := map[string]struct {
		cookbookName   string
		createCookbook bool
		cbID           string
		recipeDesc     string
		outputDenom    string
		isUpgrdRecipe  bool
		sender         sdk.AccAddress
		numItemInput   int // 0 | 1 | 2
		numItemOutput  int // 0 | 1 | 2
		desiredError   string
		showError      bool
	}{
		"cookbook not exist": {
			cookbookName:   "book000001",
			createCookbook: false,
			recipeDesc:     "this has to meet character limits",
			outputDenom:    "chair",
			numItemInput:   1,
			sender:         sender,
			desiredError:   "The cookbook doesn't exist",
			showError:      true,
		},
		"successful check": {
			cookbookName:   "book000001",
			createCookbook: true,
			recipeDesc:     "this has to meet character limits",
			outputDenom:    "chair",
			numItemInput:   1,
			sender:         sender,
			desiredError:   "",
			showError:      false,
		},
		"item upgrade recipe successful check": {
			cookbookName:   "book000001",
			createCookbook: true,
			recipeDesc:     "this has to meet character limits",
			outputDenom:    "chair",
			isUpgrdRecipe:  true,
			numItemInput:   1,
			sender:         sender,
			desiredError:   "",
			showError:      false,
		},
		"recipe with pylon denom as output": {
			cookbookName:   "book000001",
			createCookbook: true,
			recipeDesc:     "this has to meet character limits",
			outputDenom:    types.Pylon,
			numItemInput:   1,
			sender:         sender,
			desiredError:   "There should not be a recipe which generate pylon denom as an output",
			showError:      true,
		},
		"no item upgrade test": {
			cookbookName:   "book000001",
			createCookbook: true,
			recipeDesc:     "this has to meet character limits",
			outputDenom:    "chair",
			isUpgrdRecipe:  true,
			numItemInput:   0,
			sender:         sender,
			desiredError:   "Invalid item input ref found that does not exist in item inputs",
			showError:      true,
		},
		"multiple item upgrade recipe success creation test": {
			cookbookName:   "book000001",
			createCookbook: true,
			recipeDesc:     "this has to meet character limits",
			outputDenom:    "chair",
			isUpgrdRecipe:  true,
			numItemInput:   2,
			sender:         sender,
			desiredError:   "",
			showError:      false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			cbData := CreateCookbookResponse{}
			if tc.createCookbook {
				_, err := tci.Bk.AddCoins(tci.Ctx, sender, types.NewPylon(1000000))
				require.True(t, err == nil)
				cookbookMsg := msgs.NewMsgCreateCookbook(tc.cookbookName, tc.cbID, "this has to meet character limits", "SketchyCo", "1.0.0", "example@example.com", 1, msgs.DefaultCostPerBlock, tc.sender)
				cookbookResult, err := HandlerMsgCreateCookbook(tci.Ctx, tci.PlnK, cookbookMsg)
				require.True(t, err == nil)
				err = json.Unmarshal(cookbookResult.Data, &cbData)
				if err != nil {
					t.Log("cookbook result log", cookbookResult.Log)
				}
				require.True(t, err == nil)
				require.True(t, len(cbData.CookbookID) > 0)
			}

			mInputList := types.ItemInputList{}
			if tc.numItemInput == 1 {
				mInputList = types.GenItemInputList("Raichu")
			} else if tc.numItemInput == 2 {
				mInputList = types.GenItemInputList("Raichu", "Pikachu")
			}

			var mEntries types.EntriesList
			var mOutputs types.WeightedOutputsList
			if !tc.isUpgrdRecipe {
				mEntries = types.GenEntries(tc.outputDenom, "Raichu")
				mOutputs = types.GenOneOutput(tc.outputDenom, "Raichu")
			} else {
				if tc.numItemOutput == 2 {
					mEntries = types.GenEntriesTwoItemNameUpgrade("Raichu", "RaichuV2", "Pikachu", "PikachuV2")
					mOutputs = types.GenOneOutput("RaichuV2", "PikachuV2")
				} else {
					mEntries = types.GenEntriesItemNameUpgrade("Raichu", "RaichuV2")
					mOutputs = types.GenOneOutput("RaichuV2")
				}
			}

			msg := msgs.NewMsgCreateRecipe("name", cbData.CookbookID, "", tc.recipeDesc,
				types.GenCoinInputList("wood", 5),
				mInputList,
				mEntries,
				mOutputs,
				0,
				tc.sender,
			)

			result, err := HandlerMsgCreateRecipe(tci.Ctx, tci.PlnK, msg)
			if !tc.showError {
				require.True(t, err == nil)
				recipeData := CreateRecipeResponse{}
				err := json.Unmarshal(result.Data, &recipeData)
				require.True(t, err == nil)
				require.True(t, len(recipeData.RecipeID) > 0)
			} else {
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.desiredError), err.Error())
			}
		})
	}
}

func TestSameRecipeIDCreation(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	sender1, _, _, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(10000000), nil, nil, nil)

	msg := msgs.NewMsgCreateCookbook("samecookbookID-0001", "samecookbookID-0001", "some description with 20 characters", "SketchyCo", "1.0.0", "example@example.com", 0, msgs.DefaultCostPerBlock, sender1)

	result, _ := HandlerMsgCreateCookbook(tci.Ctx, tci.PlnK, msg)
	cbData := CreateCookbookResponse{}
	err := json.Unmarshal(result.Data, &cbData)
	require.True(t, err == nil)
	require.True(t, len(cbData.CookbookID) > 0)

	mEntries := types.GenEntries("chair", "Raichu")
	mOutputs := types.GenOneOutput("chair", "Raichu")
	mInputList := types.GenItemInputList("Raichu")

	rcpMsg := msgs.NewMsgCreateRecipe("name", cbData.CookbookID, "sameRecipeID-0001", "this has to meet character limits",
		types.GenCoinInputList("wood", 5),
		mInputList,
		mEntries,
		mOutputs,
		0,
		sender1,
	)

	rcpResult, _ := HandlerMsgCreateRecipe(tci.Ctx, tci.PlnK, rcpMsg)

	recipeData := CreateRecipeResponse{}
	err = json.Unmarshal(rcpResult.Data, &recipeData)
	require.True(t, err == nil)
	require.True(t, len(recipeData.RecipeID) > 0)

	// try creating it 2nd time
	_, err = HandlerMsgCreateRecipe(tci.Ctx, tci.PlnK, rcpMsg)
	require.True(t, strings.Contains(err.Error(), "The recipeID sameRecipeID-0001 is already present in CookbookID samecookbookID-0001"))

}
