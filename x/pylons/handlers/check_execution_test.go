package handlers

import (
	"encoding/json"
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestHandlerMsgCheckExecution(t *testing.T) {
	mockedCoinInput := keep.SetupTestCoinInput()

	sender1, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")

	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender1, types.PremiumTier.Fee)

	// mock cookbook
	cbData := MockCookbook(mockedCoinInput, sender1)

	// mock coin to coin recipe
	c2cRecipeData := MockRecipe(
		mockedCoinInput, "existing recipe",
		types.GenCoinInputList("wood", 5),
		types.ItemInputList{},
		types.GenCoinOnlyEntry("chair"),
		cbData.CookbookID,
		5,
		sender1,
	)

	// mock coin to item recipe
	zeroInOneOutItemRecipeData := MockRecipe(
		mockedCoinInput, "existing recipe",
		types.GenCoinInputList("wood", 5),
		types.ItemInputList{},
		types.GenItemOnlyEntry("Raichu"),
		cbData.CookbookID,
		5,
		sender1,
	)

	// mock 1 input 1 output recipe
	oneInputOneOutputRecipeData := MockRecipe(
		mockedCoinInput, "existing recipe",
		types.GenCoinInputList("wood", 5),
		types.GenItemInputList("Raichu"),
		types.GenItemOnlyEntry("Zombie"),
		cbData.CookbookID,
		10,
		sender1,
	)

	// mock no input 1 coin | 1 item output recipe
	noInput1Coin1ItemRecipeData := MockRecipe(
		mockedCoinInput, "existing recipe",
		types.CoinInputList{},
		types.ItemInputList{},
		types.GenEntries("chaira", "ZombieA"),
		cbData.CookbookID,
		10,
		sender1,
	)

	cases := map[string]struct {
		cookbookId               string
		itemIDs                  []string
		dynamicItemSet           bool
		dynamicItemName          string
		addInputCoin             bool
		recipeID                 string
		recipeDesc               string
		sender                   sdk.AccAddress
		desiredError             string
		showError                bool
		checkCoinName            string
		checkItemName            string
		checkCoinAvailable       bool
		checkItemAvailable       bool
		checkItemOrCoinAvailable bool
	}{
		"coin to coin recipe execution test": {
			itemIDs:            []string{},
			addInputCoin:       true,
			recipeID:           c2cRecipeData.RecipeID, // coin 2 coin Recipe ID
			recipeDesc:         "this has to meet character limits lol",
			sender:             sender1,
			desiredError:       "",
			showError:          false,
			checkCoinName:      "chair",
			checkCoinAvailable: true,
			checkItemName:      "",
			checkItemAvailable: false,
		},
		"zero input item and 1 output item recipe test": {
			itemIDs:            []string{},
			addInputCoin:       true,
			recipeID:           zeroInOneOutItemRecipeData.RecipeID, // available ID
			recipeDesc:         "this has to meet character limits lol",
			sender:             sender1,
			desiredError:       "",
			showError:          false,
			checkItemName:      "Raichu",
			checkItemAvailable: true,
		},
		"1 input item and 1 output item recipe test": {
			itemIDs:            []string{},
			dynamicItemSet:     true,
			dynamicItemName:    "Raichu",
			addInputCoin:       true,
			recipeID:           oneInputOneOutputRecipeData.RecipeID, // available ID
			recipeDesc:         "this has to meet character limits lol",
			sender:             sender1,
			desiredError:       "",
			showError:          false,
			checkItemName:      "Zombie",
			checkItemAvailable: true,
		},
		"randomness test on no input (1 coin | 1) item output recipe": {
			itemIDs:                  []string{},
			dynamicItemSet:           false,
			dynamicItemName:          "Raichu",
			addInputCoin:             true,
			recipeID:                 noInput1Coin1ItemRecipeData.RecipeID, // available ID
			recipeDesc:               "this has to meet character limits lol",
			sender:                   sender1,
			desiredError:             "",
			showError:                false,
			checkCoinName:            "chaira",
			checkItemName:            "ZombieA",
			checkItemOrCoinAvailable: true,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			if tc.addInputCoin {
				mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender1, sdk.Coins{sdk.NewInt64Coin("wood", 50000)})
			}
			if tc.dynamicItemSet {
				dynamicItem := keep.GenItem(cbData.CookbookID, tc.sender, tc.dynamicItemName)
				mockedCoinInput.PlnK.SetItem(mockedCoinInput.Ctx, *dynamicItem)
				tc.itemIDs = []string{dynamicItem.ID}
			}

			msg := msgs.NewMsgExecuteRecipe(tc.recipeID, tc.sender, tc.itemIDs)
			result := HandlerMsgExecuteRecipe(mockedCoinInput.Ctx, mockedCoinInput.PlnK, msg)

			execRcpResponse := ExecuteRecipeResp{}
			err := json.Unmarshal(result.Data, &execRcpResponse)

			require.True(t, err == nil)
			require.True(t, execRcpResponse.Status == "Success")
			require.True(t, execRcpResponse.Message == "scheduled the recipe")

			// coinAvailability := false
			// if tc.checkCoinAvailable || tc.checkItemOrCoinAvailable {
			// 	coinAvailability = mockedCoinInput.PlnK.CoinKeeper.HasCoins(mockedCoinInput.Ctx, tc.sender, sdk.Coins{sdk.NewInt64Coin(tc.checkCoinName, 1)})
			// }

			// // calc generated item availability
			// items, err := mockedCoinInput.PlnK.GetItemsBySender(mockedCoinInput.Ctx, tc.sender)
			// require.True(t, err == nil)

			// itemAvailability := false
			// for _, item := range items {
			// 	if item.Strings["Name"] == tc.checkItemName {
			// 		itemAvailability = true
			// 		break
			// 	}
			// }

			// if tc.checkCoinAvailable {
			// 	require.True(t, coinAvailability)
			// }
			// if tc.checkItemAvailable {
			// 	require.True(t, itemAvailability)
			// }
			// if tc.checkItemOrCoinAvailable {
			// 	require.True(t, itemAvailability || coinAvailability)
			// 	require.True(t, !(itemAvailability && coinAvailability))
			// }

		})
	}
}
