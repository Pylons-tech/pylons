package handlers

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/require"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestCustomCreateRecipeValidateBasic(t *testing.T) {
	recipeJSON := `
	{
   "BlockInterval":"0",
   "CoinInputs":[
		{
			"Coin":"pylon",
			"Count":"1"
		}
	],
   "CookbookID":"LOUD-v0.1.0-1579053457",
   "Description":"test recipe from test suite",
   "Entries":{
      "CoinOutputs":null,
      "ItemModifyOutputs":null,
      "ItemOutputs":[
            {
               "Doubles":[
					{
						"Key":"Mass",
						"Program":"",
						"Rate":"1",
						"WeightRanges":[
							{
								"Lower":"50",
								"Upper":"100",
								"Weight":1
							}
						]
					}
				],
               "ID":"a0",
               "Longs": [],
               "Strings":[
					{
						"Key":"Name",
						"Program":"",
						"Rate":"1",
						"Value":"Mars"
					}
				],
               "TransferFee":0
            }
        ],
      "ItemInputs":null,
      "Name":"RTEST_1596513734",
      "Outputs":{
         "List":[
            {
               "EntryIDs":[
                  "a0"
               ],
               "Weight":"1"
            }
         ]
      }
   },
   "Sender":"cosmos1g5w79thfvt86m6cpa0a7jezfv0sjt0u7y09ldm"
}`

	tci := keeper.SetupTestCoinInput()
	msg := types.MsgCreateRecipe{}
	err := tci.Cdc.UnmarshalJSON([]byte(recipeJSON), &msg)
	require.True(t, err == nil, err)
	err = msg.ValidateBasic()
	require.True(t, err == nil, err)
}

func TestHandlerMsgCreateRecipe(t *testing.T) {
	tci := keeper.SetupTestCoinInput()
	tci.PlnH = NewMsgServerImpl(tci.PlnK)
	sender, _, _, _ := keeper.SetupTestAccounts(t, tci, nil, nil, nil, nil)

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
			desiredError:   "key  not present in cookbook store",
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
			cbData := &types.MsgCreateCookbookResponse{}
			if tc.createCookbook {
				err := tci.Bk.AddCoins(tci.Ctx, sender, types.NewPylon(1000000))
				require.NoError(t, err)
				cookbookMsg := types.NewMsgCreateCookbook(
					tc.cookbookName,
					tc.cbID,
					"this has to meet character limits",
					"SketchyCo",
					"1.0.0",
					"example@example.com",
					1,
					types.DefaultCostPerBlock,
					tc.sender.String(),
				)
				cookbookResult, err := tci.PlnH.CreateCookbook(sdk.WrapSDKContext(tci.Ctx), &cookbookMsg)
				require.NoError(t, err)
				cbData = cookbookResult
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

			genCoinList := types.GenCoinInputList("wood", 5)
			msg := types.NewMsgCreateRecipe("name", cbData.CookbookID, "", tc.recipeDesc,
				genCoinList,
				mInputList,
				mEntries,
				mOutputs,
				0,
				tc.sender.String(),
			)

			result, err := tci.PlnH.CreateRecipe(sdk.WrapSDKContext(tci.Ctx), &msg)
			if !tc.showError {
				require.NoError(t, err)
				require.True(t, len(result.RecipeID) > 0)
			} else {
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}

func TestSameRecipeIDCreation(t *testing.T) {
	tci := keeper.SetupTestCoinInput()
	tci.PlnH = NewMsgServerImpl(tci.PlnK)
	sender1, _, _, _ := keeper.SetupTestAccounts(t, tci, types.NewPylon(10000000), nil, nil, nil)

	msg := types.NewMsgCreateCookbook(
		"samecookbookID-0001",
		"samecookbookID-0001",
		"some description with 20 characters",
		"SketchyCo",
		"1.0.0",
		"example@example.com",
		0,
		types.DefaultCostPerBlock,
		sender1.String(),
	)

	result, _ := tci.PlnH.CreateCookbook(sdk.WrapSDKContext(tci.Ctx), &msg)
	require.True(t, len(result.CookbookID) > 0)

	mEntries := types.GenEntries("chair", "Raichu")
	mOutputs := types.GenOneOutput("chair", "Raichu")
	mInputList := types.GenItemInputList("Raichu")

	genCoinsList := types.GenCoinInputList("wood", 5)
	rcpMsg := types.NewMsgCreateRecipe("name", result.CookbookID, "sameRecipeID-0001", "this has to meet character limits",
		genCoinsList,
		mInputList,
		mEntries,
		mOutputs,
		0,
		sender1.String(),
	)

	rcpResult, _ := tci.PlnH.CreateRecipe(sdk.WrapSDKContext(tci.Ctx), &rcpMsg)
	require.True(t, len(rcpResult.RecipeID) > 0)

	// try creating it 2nd time
	_, err := tci.PlnH.CreateRecipe(sdk.WrapSDKContext(tci.Ctx), &rcpMsg)

	require.True(t, strings.Contains(err.Error(), "recipeID sameRecipeID-0001 is already present in cookbookID samecookbookID-0001"))

}

func TestHandlerMsgEnableRecipe(t *testing.T) {
	tci := keeper.SetupTestCoinInput()
	tci.PlnH = NewMsgServerImpl(tci.PlnK)
	sender1, sender2, _, _ := keeper.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	// mock cookbook
	cbData := MockCookbook(tci, sender1)

	// mock recipe
	rcpData := MockPopularRecipe(RcpDefault, tci, "existing recipe", cbData.CookbookID, sender1)

	cases := map[string]struct {
		rcpID        string
		sender       sdk.AccAddress
		desiredError string
		showError    bool
	}{
		"wrong recipe check": {
			rcpID:        "invalidRecipeID",
			sender:       sender1,
			desiredError: "key invalidRecipeID not present in recipe store",
			showError:    true,
		},
		"owner of recipe check": {
			rcpID:        rcpData.RecipeID,
			sender:       sender2,
			desiredError: "msg sender is not the owner of the recipe",
			showError:    true,
		},
		"successful update check": {
			rcpID:        rcpData.RecipeID,
			sender:       sender1,
			desiredError: "",
			showError:    false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			msg := types.NewMsgEnableRecipe(tc.rcpID, tc.sender.String())
			result, err := tci.PlnH.EnableRecipe(sdk.WrapSDKContext(tci.Ctx), &msg)

			if tc.showError == false {
				require.NoError(t, err)
				require.True(t, result.Status == "Success")
				require.True(t, result.Message == "successfully enabled the recipe")

				uRcp, err := tci.PlnK.GetRecipe(tci.Ctx, tc.rcpID)
				require.NoError(t, err)
				require.True(t, uRcp.Disabled == false)
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}

func TestHandlerMsgUpdateRecipe(t *testing.T) {
	tci := keeper.SetupTestCoinInput()
	tci.PlnH = NewMsgServerImpl(tci.PlnK)
	sender1, _, _, _ := keeper.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	// mock cookbook
	cbData := MockCookbook(tci, sender1)

	// mock new recipe
	genCoinList := types.GenCoinInputList("wood", 5)
	genItemInputList := types.GenItemInputList("Raichu")
	genEntries := types.GenEntries("chair", "Raichu")
	genOneOutput := types.GenOneOutput("chair", "Raichu")
	newRcpMsg := types.NewMsgCreateRecipe("existing recipe", cbData.CookbookID, "", "this has to meet character limits",
		genCoinList,
		genItemInputList,
		genEntries,
		genOneOutput,
		0,
		sender1.String(),
	)

	newRcpResult, _ := tci.PlnH.CreateRecipe(sdk.WrapSDKContext(tci.Ctx), &newRcpMsg)

	cases := map[string]struct {
		cbID         string
		recipeName   string
		rcpID        string
		recipeDesc   string
		sender       sdk.AccAddress
		desiredError string
		showError    bool
	}{
		"update recipe check for not available recipe": {
			cbID:         cbData.CookbookID,
			recipeName:   "recipe0001",
			rcpID:        "id001", // not available ID
			recipeDesc:   "this has to meet character limits lol",
			sender:       sender1,
			desiredError: "the owner of the recipe is different then the current sender",
			showError:    true,
		},
		"successful test for update recipe": {
			cbID:         cbData.CookbookID,
			recipeName:   "recipe0001",
			rcpID:        newRcpResult.RecipeID, // available ID
			recipeDesc:   "this has to meet character limits lol",
			sender:       sender1,
			desiredError: "",
			showError:    false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			genCoinList := types.GenCoinInputList("wood", 5)
			genItemInputList := types.GenItemInputList("Raichu")
			genEntries := types.GenEntries("chair", "Raichu")
			genOneOutput := types.GenOneOutput("chair", "Raichu")
			msg := types.NewMsgUpdateRecipe(tc.rcpID, tc.recipeName, tc.cbID, tc.recipeDesc,
				genCoinList,
				genItemInputList,
				genEntries,
				genOneOutput,
				0,
				sender1.String())

			result, err := tci.PlnH.HandlerMsgUpdateRecipe(sdk.WrapSDKContext(tci.Ctx), &msg)

			if tc.showError == false {
				require.True(t, len(result.RecipeID) > 0)
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}

func TestHandlerMsgDisableRecipe(t *testing.T) {
	tci := keeper.SetupTestCoinInput()
	tci.PlnH = NewMsgServerImpl(tci.PlnK)
	sender1, sender2, _, _ := keeper.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	// mock cookbook
	cbData := MockCookbook(tci, sender1)

	// mock recipe
	rcpData := MockPopularRecipe(RcpDefault, tci, "existing recipe", cbData.CookbookID, sender1)

	cases := map[string]struct {
		rcpID        string
		sender       sdk.AccAddress
		desiredError string
		showError    bool
	}{
		"wrong recipe check": {
			rcpID:        "invalidRecipeID",
			sender:       sender1,
			desiredError: "key invalidRecipeID not present in recipe store",
			showError:    true,
		},
		"owner of recipe check": {
			rcpID:        rcpData.RecipeID,
			sender:       sender2,
			desiredError: "msg sender is not the owner of the recipe",
			showError:    true,
		},
		"successful update check": {
			rcpID:        rcpData.RecipeID,
			sender:       sender1,
			desiredError: "",
			showError:    false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			msg := types.NewMsgDisableRecipe(tc.rcpID, tc.sender.String())
			result, err := tci.PlnH.DisableRecipe(sdk.WrapSDKContext(tci.Ctx), &msg)

			if tc.showError == false {
				require.NoError(t, err)
				require.True(t, result.Status == "Success")
				require.True(t, result.Message == "successfully disabled the recipe")

				uRcp, err := tci.PlnK.GetRecipe(tci.Ctx, tc.rcpID)
				require.NoError(t, err)
				require.True(t, uRcp.Disabled == true)
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}
