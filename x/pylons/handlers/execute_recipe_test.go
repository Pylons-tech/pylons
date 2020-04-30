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

func TestHandlerMsgExecuteRecipe(t *testing.T) {
	mockedCoinInput := keep.SetupTestCoinInput()

	sender1, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	sender2, _ := sdk.AccAddressFromBech32("cosmos16wfryel63g7axeamw68630wglalcnk3l0zuadc")

	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender1, types.NewPylon(1000000))

	// mock cookbook
	cbData := MockCookbook(mockedCoinInput, sender1)

	// mock coin to coin recipe
	c2cRecipeData := MockPopularRecipe(RCP_5xWOODCOIN_TO_1xCHAIRCOIN, mockedCoinInput, "existing recipe", cbData.CookbookID, sender1)

	// mock coin to item recipe
	zeroInOneOutItemRecipeData := MockPopularRecipe(RCP_5xWOODCOIN_1xRAICHU_BUY, mockedCoinInput, "existing recipe", cbData.CookbookID, sender1)

	// mock 1 input 1 output recipe
	oneInputOneOutputRecipeData := MockRecipe(
		mockedCoinInput, "existing recipe",
		types.GenCoinInputList("wood", 5),
		types.GenItemInputList("Raichu"),
		types.GenItemOnlyEntry("Zombie"),
		types.GenOneOutput(1),
		cbData.CookbookID,
		0,
		sender1,
	)

	// mock 1 catalyst input 1 output recipe
	oneCatalystOneOutputRecipeData := MockRecipe(
		mockedCoinInput, "existing recipe",
		types.GenCoinInputList("wood", 5),
		types.GenItemInputList("catalyst"),

		types.EntriesList{
			types.NewInputRefOutput(
				0, types.ItemModifyParams{},
			),
			types.GenItemOnlyEntry("Catalyst2")[0],
		},
		types.GenAllOutput(2),
		cbData.CookbookID,
		0,
		sender1,
	)

	// mock no input 1 coin | 1 item output recipe
	noInput1Coin1ItemRecipeData := MockRecipe(
		mockedCoinInput, "existing recipe",
		types.CoinInputList{},
		types.ItemInputList{},
		types.GenEntries("chaira", "ZombieA"),
		types.GenOneOutput(2),
		cbData.CookbookID,
		0,
		sender1,
	)

	// mock no input 1 coin | 1 item output recipe
	noInput1Coin1ItemRandRecipeData := MockRecipe(
		mockedCoinInput, "existing recipe",
		types.CoinInputList{},
		types.ItemInputList{},
		types.GenEntriesRand("zmbr", "ZombieRand"),
		types.GenOneOutput(2),
		cbData.CookbookID,
		0,
		sender1,
	)

	// item upgrade recipe
	itemUpgradeRecipeData := MockPopularRecipe(RCP_RAICHU_NAME_UPGRADE, mockedCoinInput, "existing recipe", cbData.CookbookID, sender1)

	// item upgrade recipe with catalyst item
	itemUpgradeWithCatalystRecipeData := MockPopularRecipe(RCP_RAICHU_NAME_UPGRADE_WITH_CATALYST, mockedCoinInput, "existing recipe", cbData.CookbookID, sender1)

	cases := map[string]struct {
		cookbookID               string
		itemIDs                  []string
		dynamicItemSet           bool
		dynamicItemNames         []string
		addInputCoin             bool
		recipeID                 string
		sender                   sdk.AccAddress
		desiredError             string
		successMsg               string
		showError                bool
		checkCoinName            string
		checkItemName            string
		checkCoinAvailable       bool
		checkItemAvailable       bool
		checkItemOrCoinAvailable bool
	}{
		"insufficient coin balance check": {
			itemIDs:            []string{},
			addInputCoin:       false,
			recipeID:           c2cRecipeData.RecipeID, // coin 2 coin Recipe ID
			sender:             sender2,
			desiredError:       "insufficient coin balance",
			showError:          true,
			checkItemName:      "",
			checkItemAvailable: false,
		},
		"the item IDs count doesn't match the recipe input": {
			itemIDs:            []string{"Raichu"},
			addInputCoin:       true,
			recipeID:           c2cRecipeData.RecipeID, // coin 2 coin Recipe ID
			sender:             sender1,
			desiredError:       "the item IDs count doesn't match the recipe input",
			showError:          true,
			checkItemName:      "",
			checkItemAvailable: false,
		},
		"coin to coin recipe execution test": {
			itemIDs:            []string{},
			addInputCoin:       true,
			recipeID:           c2cRecipeData.RecipeID, // coin 2 coin Recipe ID
			sender:             sender1,
			desiredError:       "",
			successMsg:         "successfully executed the recipe",
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
			sender:             sender1,
			desiredError:       "",
			successMsg:         "successfully executed the recipe",
			showError:          false,
			checkItemName:      "Raichu",
			checkItemAvailable: true,
		},
		"not existing item in input": {
			itemIDs:            []string{"invaliditemID"},
			dynamicItemSet:     false,
			dynamicItemNames:   []string{"Raichu"},
			addInputCoin:       true,
			recipeID:           oneInputOneOutputRecipeData.RecipeID, // available ID
			sender:             sender1,
			desiredError:       "The item doesn't exist",
			showError:          true,
			checkItemName:      "",
			checkItemAvailable: false,
		},
		"Wrong item in input": {
			itemIDs:            []string{"invaliditemID"},
			dynamicItemSet:     true,
			dynamicItemNames:   []string{"NoRaichu"},
			addInputCoin:       true,
			recipeID:           oneInputOneOutputRecipeData.RecipeID, // available ID
			sender:             sender1,
			desiredError:       "the item inputs dont match any items provided",
			successMsg:         "successfully executed the recipe",
			showError:          true,
			checkItemName:      "",
			checkItemAvailable: false,
		},
		"1 input item and 1 output item recipe test": {
			itemIDs:            []string{},
			dynamicItemSet:     true,
			dynamicItemNames:   []string{"Raichu"},
			addInputCoin:       true,
			recipeID:           oneInputOneOutputRecipeData.RecipeID, // available ID
			sender:             sender1,
			desiredError:       "",
			successMsg:         "successfully executed the recipe",
			showError:          false,
			checkItemName:      "Zombie",
			checkItemAvailable: true,
		},
		"item generation with catalyst item test": {
			itemIDs:            []string{},
			dynamicItemSet:     true,
			dynamicItemNames:   []string{"catalyst"},
			addInputCoin:       true,
			recipeID:           oneCatalystOneOutputRecipeData.RecipeID, // available ID
			sender:             sender1,
			desiredError:       "",
			successMsg:         "successfully executed the recipe",
			showError:          false,
			checkItemName:      "catalyst", // "catalyst" item should be kept
			checkItemAvailable: true,
		},
		"randomness test on no input (1 coin | 1) item output recipe": {
			itemIDs:                  []string{},
			dynamicItemSet:           false,
			addInputCoin:             true,
			recipeID:                 noInput1Coin1ItemRecipeData.RecipeID, // available ID
			sender:                   sender1,
			desiredError:             "",
			successMsg:               "successfully executed the recipe",
			showError:                false,
			checkCoinName:            "chaira",
			checkItemName:            "ZombieA",
			checkItemOrCoinAvailable: true,
		},
		"random function test on program on no input (1 coin | 1) item output recipe": {
			itemIDs:                  []string{},
			dynamicItemSet:           false,
			addInputCoin:             true,
			recipeID:                 noInput1Coin1ItemRandRecipeData.RecipeID, // available ID
			sender:                   sender1,
			desiredError:             "",
			successMsg:               "successfully executed the recipe",
			showError:                false,
			checkCoinName:            "zmbr",
			checkItemName:            "ZombieRand",
			checkItemOrCoinAvailable: true,
		},
		"item upgrade test": {
			itemIDs:            []string{},
			dynamicItemSet:     true,
			dynamicItemNames:   []string{"Raichu"},
			addInputCoin:       true,
			recipeID:           itemUpgradeRecipeData.RecipeID, // available ID
			sender:             sender1,
			desiredError:       "",
			successMsg:         "successfully executed the recipe",
			showError:          false,
			checkItemName:      "RaichuV2",
			checkItemAvailable: true,
		},
		"item upgrade with catalyst item test": {
			itemIDs:            []string{},
			dynamicItemSet:     true,
			dynamicItemNames:   []string{"RaichuTC", "catalyst"},
			addInputCoin:       true,
			recipeID:           itemUpgradeWithCatalystRecipeData.RecipeID, // available ID
			sender:             sender1,
			desiredError:       "",
			successMsg:         "successfully executed the recipe",
			showError:          false,
			checkItemName:      "RaichuTCV2",
			checkItemAvailable: true,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			if tc.addInputCoin {
				mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender1, sdk.Coins{sdk.NewInt64Coin("wood", 50000)})
			}
			if tc.dynamicItemSet {
				tc.itemIDs = []string{}
				for _, diN := range tc.dynamicItemNames {
					dynamicItem := keep.GenItem(cbData.CookbookID, tc.sender, diN)
					mockedCoinInput.PlnK.SetItem(mockedCoinInput.Ctx, *dynamicItem)
					tc.itemIDs = append(tc.itemIDs, dynamicItem.ID)
				}
			}

			msg := msgs.NewMsgExecuteRecipe(tc.recipeID, tc.sender, tc.itemIDs)
			result, err := HandlerMsgExecuteRecipe(mockedCoinInput.Ctx, mockedCoinInput.PlnK, msg)

			if tc.showError == false {
				execRcpResponse := ExecuteRecipeResp{}
				err := json.Unmarshal(result.Data, &execRcpResponse)

				if err != nil {
					t.Log(err, result)
				}
				require.True(t, err == nil)
				require.True(t, execRcpResponse.Status == "Success")
				require.True(t, execRcpResponse.Message == tc.successMsg)

				// calc generated coin availability
				coinAvailability := false
				if tc.checkCoinAvailable || tc.checkItemOrCoinAvailable {
					coinAvailability = mockedCoinInput.PlnK.CoinKeeper.HasCoins(mockedCoinInput.Ctx, tc.sender, sdk.Coins{sdk.NewInt64Coin(tc.checkCoinName, 1)})
				}

				// calc generated item availability
				items, err := mockedCoinInput.PlnK.GetItemsBySender(mockedCoinInput.Ctx, tc.sender)
				require.True(t, err == nil)

				itemAvailability := false
				for _, item := range items {
					itemName, ok := item.FindString("Name")
					if !ok {
						t.Log("name not available for item=", item)
					}
					require.True(t, ok)
					if itemName == tc.checkItemName {
						itemAvailability = true
						break
					}
				}

				if tc.checkCoinAvailable {
					require.True(t, coinAvailability)
				}
				if tc.checkItemAvailable {
					require.True(t, itemAvailability)
				}
				if tc.checkItemOrCoinAvailable {
					require.True(t, itemAvailability || coinAvailability)
					require.True(t, !(itemAvailability && coinAvailability))
				}
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}
