package handlers

import (
	"encoding/json"
	"strings"
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestHandlerMsgCreateRecipe(t *testing.T) {

	mockedCoinInput := keep.SetupTestCoinInput()

	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender, types.PremiumTier.Fee)

	cases := map[string]struct {
		cookbookName   string
		createCookbook bool
		recipeDesc     string
		recipeType     types.RecipeType
		sender         sdk.AccAddress
		numItemInput   int // 0 | 1 | 2
		desiredError   string
		showError      bool
	}{
		"cookbook not exist": {
			cookbookName:   "book000001",
			createCookbook: false,
			recipeDesc:     "this has to meet character limits",
			recipeType:     types.GENERATION,
			numItemInput:   1,
			sender:         sender,
			desiredError:   "The cookbook doesn't exist",
			showError:      true,
		},
		"successful check": {
			cookbookName:   "book000001",
			createCookbook: true,
			recipeDesc:     "this has to meet character limits",
			recipeType:     types.GENERATION,
			numItemInput:   1,
			sender:         sender,
			desiredError:   "",
			showError:      false,
		},
		"item upgrade recipe successful check": {
			cookbookName:   "book000001",
			createCookbook: true,
			recipeDesc:     "this has to meet character limits",
			recipeType:     types.UPGRADE,
			numItemInput:   1,
			sender:         sender,
			desiredError:   "",
			showError:      false,
		},
		"item upgrade recipe more than 2 input failure check": {
			cookbookName:   "book000001",
			createCookbook: true,
			recipeDesc:     "this has to meet character limits",
			recipeType:     types.UPGRADE,
			numItemInput:   2,
			sender:         sender,
			desiredError:   "For item upgrade recipe, item input should be one",
			showError:      true,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			cbData := CreateCBResponse{}
			if tc.createCookbook {
				cookbookMsg := msgs.NewMsgCreateCookbook(tc.cookbookName, "this has to meet character limits", "SketchyCo", "1.0.0", "example@example.com", 1, msgs.DefaultCostPerBlock, tc.sender)
				cookbookResult := HandlerMsgCreateCookbook(mockedCoinInput.Ctx, mockedCoinInput.PlnK, cookbookMsg)

				err := json.Unmarshal(cookbookResult.Data, &cbData)
				require.True(t, err == nil)
				require.True(t, len(cbData.CookbookID) > 0)
			}

			mEntries := types.WeightedParamList{}
			mUpgrades := types.ItemUpgradeParams{}
			if tc.recipeType == types.GENERATION {
				mEntries = types.GenEntries("chair", "Raichu")
			} else {
				mUpgrades = types.GenToUpgradeForString("Name", "RaichuV2")
			}
			mInputList := types.ItemInputList{}
			if tc.numItemInput == 1 {
				mInputList = types.GenItemInputList("Raichu")
			} else {
				mInputList = types.GenItemInputList("Raichu", "Knife")
			}

			msg := msgs.NewMsgCreateRecipe("name", cbData.CookbookID, tc.recipeDesc,
				tc.recipeType,
				types.GenCoinInputList("wood", 5),
				mInputList,
				mEntries,
				mUpgrades,
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
