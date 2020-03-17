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

func TestHandlerMsgCreateRecipe(t *testing.T) {

	mockedCoinInput := keep.SetupTestCoinInput()

	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")

	cases := map[string]struct {
		cookbookName   string
		createCookbook bool
		recipeID       string
		recipeDesc     string
		isUpgrdRecipe  bool
		sender         sdk.AccAddress
		numItemInput   int // 0 | 1 | 2
		desiredError   string
		showError      bool
	}{
		"cookbook not exist": {
			cookbookName:   "book000001",
			createCookbook: false,
			recipeDesc:     "this has to meet character limits",
			numItemInput:   1,
			sender:         sender,
			desiredError:   "The cookbook doesn't exist",
			showError:      true,
		},
		"successful check": {
			cookbookName:   "book000001",
			createCookbook: true,
			recipeDesc:     "this has to meet character limits",
			numItemInput:   1,
			sender:         sender,
			desiredError:   "",
			showError:      false,
		},
		"item upgrade recipe successful check": {
			cookbookName:   "book000001",
			createCookbook: true,
			recipeDesc:     "this has to meet character limits",
			isUpgrdRecipe:  true,
			numItemInput:   1,
			sender:         sender,
			desiredError:   "",
			showError:      false,
		},
		"item upgrade recipe no input failure check": {
			cookbookName:   "book000001",
			createCookbook: true,
			recipeDesc:     "this has to meet character limits",
			isUpgrdRecipe:  true,
			numItemInput:   0,
			sender:         sender,
			desiredError:   "For item upgrade recipe, item input should be at least one",
			showError:      true,
		},
		// TODO should add case for multiple input item upgrade test
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			cbData := CreateCBResponse{}
			if tc.createCookbook {
				mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender, types.PremiumTier.Fee)
				cookbookMsg := msgs.NewMsgCreateCookbook(tc.cookbookName, tc.recipeID, "this has to meet character limits", "SketchyCo", "1.0.0", "example@example.com", 1, msgs.DefaultCostPerBlock, tc.sender)
				cookbookResult := HandlerMsgCreateCookbook(mockedCoinInput.Ctx, mockedCoinInput.PlnK, cookbookMsg)

				err := json.Unmarshal(cookbookResult.Data, &cbData)
				if err != nil {
					t.Log("cookbook result log", cookbookResult.Log)
				}
				require.True(t, err == nil)
				require.True(t, len(cbData.CookbookID) > 0)
			}

			mEntries := types.WeightedParamList{}
			mUpgrades := types.ItemUpgradeParams{}
			alivePercent := 0
			if !tc.isUpgrdRecipe {
				mEntries = types.GenEntries("chair", "Raichu")
			} else {
				mUpgrades = types.GenToUpgradeForString("Name", "RaichuV2")
				alivePercent = 100
			}
			mInputList := types.ItemInputList{}
			if tc.numItemInput == 1 {
				if tc.isUpgrdRecipe {
					mInputList = types.GenDetailedItemInputList(
						alivePercent,
						[]types.ItemUpgradeParams{mUpgrades},
						"Raichu",
					)
				} else {
					mInputList = types.GenItemInputList(alivePercent, "Raichu")
				}
			} else if tc.numItemInput != 0 { // > 1
				if tc.isUpgrdRecipe {
					mInputList = types.GenDetailedItemInputList(
						alivePercent,
						[]types.ItemUpgradeParams{mUpgrades},
						"Raichu", "Knife",
					)
				} else {
					mInputList = types.GenItemInputList(alivePercent, "Raichu", "Knife")
				}
			}

			msg := msgs.NewMsgCreateRecipe("name", cbData.CookbookID, "", tc.recipeDesc,
				types.GenCoinInputList("wood", 5),
				mInputList,
				mEntries,
				0,
				tc.sender,
			)

			result := HandlerMsgCreateRecipe(mockedCoinInput.Ctx, mockedCoinInput.PlnK, msg)
			if !tc.showError {
				recipeData := CreateRecipeResponse{}
				err := json.Unmarshal(result.Data, &recipeData)
				require.True(t, err == nil)
				require.True(t, len(recipeData.RecipeID) > 0)
			} else {
				require.True(t, strings.Contains(result.Log, tc.desiredError))
			}
		})
	}
}

func TestSameRecipeIDCreation(t *testing.T) {
	mockedCoinInput := keep.SetupTestCoinInput()
	sender1, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	msg := msgs.NewMsgCreateCookbook("samecookbookID-0001", "samecookbookID-0001", "some description with 20 characters", "SketchyCo", "1.0.0", "example@example.com", 0, msgs.DefaultCostPerBlock, sender1)
	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender1, types.NewPylon(10000000))

	result := HandlerMsgCreateCookbook(mockedCoinInput.Ctx, mockedCoinInput.PlnK, msg)
	cbData := CreateCBResponse{}
	err := json.Unmarshal(result.Data, &cbData)
	require.True(t, err == nil)
	require.True(t, len(cbData.CookbookID) > 0)

	mEntries := types.GenEntries("chair", "Raichu")
	mInputList := types.GenItemInputList(0, "Raichu")

	rcpMsg := msgs.NewMsgCreateRecipe("name", cbData.CookbookID, "sameRecipeID-0001", "this has to meet character limits",
		types.GenCoinInputList("wood", 5),
		mInputList,
		mEntries,
		0,
		sender1,
	)

	rcpResult := HandlerMsgCreateRecipe(mockedCoinInput.Ctx, mockedCoinInput.PlnK, rcpMsg)

	recipeData := CreateRecipeResponse{}
	err = json.Unmarshal(rcpResult.Data, &recipeData)
	require.True(t, err == nil)
	require.True(t, len(recipeData.RecipeID) > 0)

	// try creating it 2nd time
	secondRcpResult := HandlerMsgCreateRecipe(mockedCoinInput.Ctx, mockedCoinInput.PlnK, rcpMsg)
	require.True(t, strings.Contains(secondRcpResult.Log, "The recipeID sameRecipeID-0001 is already present in CookbookID samecookbookID-0001"))

}
