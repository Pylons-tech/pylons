package handlers

import (
	"encoding/json"
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestHandlerMsgExecuteRecipe(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	sender1, sender2, _, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	// mock cookbook
	cbData := MockCookbook(tci, sender1)

	// mock coin to coin recipe
	c2cRecipeData := MockPopularRecipe(Rcp5xWoodcoinTo1xChaircoin, tci, "existing recipe", cbData.CookbookID, sender1)

	// mock coin to item recipe
	zeroInOneOutItemRecipeData := MockPopularRecipe(Rcp5xWoodcoinTo1xRaichuItemBuy, tci, "existing recipe", cbData.CookbookID, sender1)

	// mock 1 input 1 output recipe
	oneInputOneOutputRecipeData := MockRecipe(
		tci, "existing recipe",
		types.GenCoinInputList("wood", 5),
		types.GenItemInputList("Raichu"),
		types.GenItemOnlyEntry("Zombie"),
		types.GenOneOutput(1),
		cbData.CookbookID,
		0,
		sender1,
	)

	// mock pylon input recipe
	pylonInputRecipeData := MockRecipe(
		tci, "existing recipe",
		types.GenCoinInputList("pylon", 100),
		types.ItemInputList{},
		types.EntriesList{},
		types.WeightedOutputsList{},
		cbData.CookbookID,
		0,
		sender1,
	)

	// mock 1 catalyst input 1 output recipe
	oneCatalystOneOutputRecipeData := MockRecipe(
		tci, "existing recipe",
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
		tci, "existing recipe",
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
		tci, "existing recipe",
		types.CoinInputList{},
		types.ItemInputList{},
		types.GenEntriesRand("zmbr", "ZombieRand"),
		types.GenOneOutput(2),
		cbData.CookbookID,
		0,
		sender1,
	)

	// item upgrade recipe
	itemUpgradeRecipeData := MockPopularRecipe(RcpRaichuNameUpgrade, tci, "existing recipe", cbData.CookbookID, sender1)

	// item upgrade recipe with catalyst item
	itemUpgradeWithCatalystRecipeData := MockPopularRecipe(RcpRaichuNameUpgradeWithCatalyst, tci, "existing recipe", cbData.CookbookID, sender1)

	cases := map[string]struct {
		cookbookID               string
		itemIDs                  []string
		dynamicItemSet           bool
		dynamicItemNames         []string
		addInputCoin             bool
		rcpID                    string
		sender                   sdk.AccAddress
		desiredError             string
		successMsg               string
		showError                bool
		checkCoinName            string
		checkItemName            string
		checkCoinAvailable       bool
		checkItemAvailable       bool
		checkItemOrCoinAvailable bool
		checkPylonDistribution   bool
		pylonsLLCDistribution    int64
	}{
		"insufficient coin balance check": {
			itemIDs:            []string{},
			addInputCoin:       false,
			rcpID:              c2cRecipeData.RecipeID, // coin 2 coin Recipe ID
			sender:             sender2,
			desiredError:       "insufficient coin balance",
			showError:          true,
			checkItemName:      "",
			checkItemAvailable: false,
		},
		"the item IDs count doesn't match the recipe input": {
			itemIDs:            []string{"Raichu"},
			addInputCoin:       true,
			rcpID:              c2cRecipeData.RecipeID, // coin 2 coin Recipe ID
			sender:             sender1,
			desiredError:       "the item IDs count doesn't match the recipe input",
			showError:          true,
			checkItemName:      "",
			checkItemAvailable: false,
		},
		"coin to coin recipe execution test": {
			itemIDs:            []string{},
			addInputCoin:       true,
			rcpID:              c2cRecipeData.RecipeID, // coin 2 coin Recipe ID
			sender:             sender1,
			desiredError:       "",
			successMsg:         "successfully executed the recipe",
			showError:          false,
			checkCoinName:      "chair",
			checkCoinAvailable: true,
			checkItemName:      "",
			checkItemAvailable: false,
		},
		"pylon distribution check on pylon input recipes": {
			itemIDs:                []string{},
			addInputCoin:           false,
			rcpID:                  pylonInputRecipeData.RecipeID, // coin 2 coin Recipe ID
			sender:                 sender1,
			desiredError:           "",
			successMsg:             "successfully executed the recipe",
			showError:              false,
			checkCoinName:          "pylon",
			checkCoinAvailable:     true,
			checkItemName:          "",
			checkItemAvailable:     false,
			checkPylonDistribution: true,
			pylonsLLCDistribution:  100 * config.Config.Fee.RecipePercent / 100,
		},
		"zero input item and 1 output item recipe test": {
			itemIDs:            []string{},
			addInputCoin:       true,
			rcpID:              zeroInOneOutItemRecipeData.RecipeID, // available ID
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
			rcpID:              oneInputOneOutputRecipeData.RecipeID, // available ID
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
			rcpID:              oneInputOneOutputRecipeData.RecipeID, // available ID
			sender:             sender1,
			desiredError:       "the [0] item input don't match any items provided",
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
			rcpID:              oneInputOneOutputRecipeData.RecipeID, // available ID
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
			rcpID:              oneCatalystOneOutputRecipeData.RecipeID, // available ID
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
			rcpID:                    noInput1Coin1ItemRecipeData.RecipeID, // available ID
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
			rcpID:                    noInput1Coin1ItemRandRecipeData.RecipeID, // available ID
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
			rcpID:              itemUpgradeRecipeData.RecipeID, // available ID
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
			rcpID:              itemUpgradeWithCatalystRecipeData.RecipeID, // available ID
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
				_, err := tci.Bk.AddCoins(tci.Ctx, sender1, sdk.Coins{sdk.NewInt64Coin("wood", 50000)})
				require.True(t, err == nil)
			}
			if tc.dynamicItemSet {
				tc.itemIDs = []string{}
				for _, diN := range tc.dynamicItemNames {
					dynamicItem := keep.GenItem(cbData.CookbookID, tc.sender, diN)
					err := tci.PlnK.SetItem(tci.Ctx, *dynamicItem)
					require.True(t, err == nil)
					tc.itemIDs = append(tc.itemIDs, dynamicItem.ID)
				}
			}

			msg := msgs.NewMsgExecuteRecipe(tc.rcpID, tc.sender, tc.itemIDs)
			result, err := HandlerMsgExecuteRecipe(tci.Ctx, tci.PlnK, msg)

			if tc.showError == false {
				require.True(t, err == nil)
				execRcpResponse := ExecuteRecipeResponse{}
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
					coinAvailability = tci.PlnK.CoinKeeper.HasCoins(tci.Ctx, tc.sender, sdk.Coins{sdk.NewInt64Coin(tc.checkCoinName, 1)})
				}

				// calc generated item availability
				items, err := tci.PlnK.GetItemsBySender(tci.Ctx, tc.sender)
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
				if tc.checkPylonDistribution {
					pylonsLLCAddress, err := sdk.AccAddressFromBech32(config.Config.Validators.PylonsLLC)
					require.True(t, err == nil)
					pylonAvailOnLLC := tci.PlnK.CoinKeeper.HasCoins(tci.Ctx, pylonsLLCAddress, sdk.Coins{sdk.NewInt64Coin(types.Pylon, tc.pylonsLLCDistribution)})
					require.True(t, pylonAvailOnLLC)
				}
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}
