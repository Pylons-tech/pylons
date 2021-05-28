package handlers

import (
	"encoding/json"
	"fmt"
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestHandlerMsgExecuteRecipe(t *testing.T) {
	tci := keeper.SetupTestCoinInput()
	tci.PlnH = NewMsgServerImpl(tci.PlnK)
	sender1, sender2, _, _ := keeper.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)
	fmt.Printf("%+v\n", sender2)
	// mock cookbook
	cbData := MockCookbook(tci, sender1)

	// mock coin to coin recipe
	//c2cRecipeData := MockPopularRecipe(Rcp5xWoodcoinTo1xChaircoin, tci, "existing recipe", cbData.CookbookID, sender1)

	// mock coin to item recipe
	//zeroInOneOutItemRecipeData := MockPopularRecipe(Rcp5xWoodcoinTo1xRaichuItemBuy, tci, "existing recipe", cbData.CookbookID, sender1)

	// mock 1 input 1 output recipe
	// oneInputOneOutputRecipeData := MockRecipe(
	// 	tci, "existing recipe",
	// 	types.GenCoinInputList("wood", 5),
	// 	types.GenItemInputList("Raichu"),
	// 	types.EntriesList{ItemOutputs: []types.ItemOutput{types.GenItemOnlyEntry("Zombie")}},
	// 	types.GenOneOutput("Zombie"),
	// 	cbData.CookbookID,
	// 	0,
	// 	sender1,
	// )

	// mock 1 input 1 output recipe
	usdInputRecipeData := MockRecipe(
		tci, "existing recipe",
		types.GenCoinInputList("USD", 100),
		types.ItemInputList{},
		types.EntriesList{},
		types.WeightedOutputsList{},
		cbData.CookbookID,
		0,
		sender1,
	)

	// mock pylon input recipe
	// pylonInputRecipeData := MockRecipe(
	// 	tci, "existing recipe",
	// 	types.GenCoinInputList(types.Pylon, 100),
	// 	types.ItemInputList{},
	// 	types.EntriesList{},
	// 	types.WeightedOutputsList{},
	// 	cbData.CookbookID,
	// 	0,
	// 	sender1,
	// )

	// genItemModifyOutput := types.NewItemModifyOutput(
	// 	"catalystOutputEntry", "catalyst", types.ItemModifyParams{},
	// )
	// // mock 1 catalyst input 1 output recipe
	// oneCatalystOneOutputRecipeData := MockRecipe(
	// 	tci, "existing recipe",
	// 	types.GenCoinInputList("wood", 5),
	// 	types.GenItemInputList("catalyst"),
	// 	types.EntriesList{
	// 		ItemOutputs:       []types.ItemOutput{types.GenItemOnlyEntry("Catalyst2")},
	// 		ItemModifyOutputs: []types.ItemModifyOutput{genItemModifyOutput},
	// 	},
	// 	types.GenAllOutput("catalystOutputEntry", "Catalyst2"),
	// 	cbData.CookbookID,
	// 	0,
	// 	sender1,
	// )

	// // mock no input 1 coin | 1 item output recipe
	// noInput1Coin1ItemRecipeData := MockRecipe(
	// 	tci, "existing recipe",
	// 	types.CoinInputList{},
	// 	types.ItemInputList{},
	// 	types.GenEntries("chaira", "ZombieA"),
	// 	types.GenOneOutput("chaira", "ZombieA"),
	// 	cbData.CookbookID,
	// 	0,
	// 	sender1,
	// )

	// // mock no input 1 coin | 1 item output recipe
	// noInput1Coin1ItemRandRecipeData := MockRecipe(
	// 	tci, "existing recipe",
	// 	types.CoinInputList{},
	// 	types.ItemInputList{},
	// 	types.GenEntriesRand("zmbr", "ZombieRand"),
	// 	types.GenOneOutput("zmbr", "ZombieRand"),
	// 	cbData.CookbookID,
	// 	0,
	// 	sender1,
	// )

	// // item upgrade recipe
	// itemUpgradeRecipeData := MockPopularRecipe(RcpRaichuNameUpgrade, tci, "existing recipe", cbData.CookbookID, sender1)

	// // item upgrade recipe with catalyst item
	// itemUpgradeWithCatalystRecipeData := MockPopularRecipe(RcpRaichuNameUpgradeWithCatalyst, tci, "existing recipe", cbData.CookbookID, sender1)

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
		paymentId                string
		paymentMethod            string
	}{
		// "insufficient coin balance check": {
		// 	itemIDs:            []string{},
		// 	addInputCoin:       false,
		// 	rcpID:              c2cRecipeData.RecipeID, // coin 2 coin Recipe ID
		// 	sender:             sender2,
		// 	desiredError:       "insufficient coin balance",
		// 	showError:          true,
		// 	checkItemName:      "",
		// 	checkItemAvailable: false,
		// },
		// "the item IDs count doesn't match the recipe input": {
		// 	itemIDs:            []string{"Raichu"},
		// 	addInputCoin:       true,
		// 	rcpID:              c2cRecipeData.RecipeID, // coin 2 coin Recipe ID
		// 	sender:             sender1,
		// 	desiredError:       "the item IDs count doesn't match the recipe input",
		// 	showError:          true,
		// 	checkItemName:      "",
		// 	checkItemAvailable: false,
		// },
		// "coin to coin recipe execution test": {
		// 	itemIDs:            []string{},
		// 	addInputCoin:       true,
		// 	rcpID:              c2cRecipeData.RecipeID, // coin 2 coin Recipe ID
		// 	sender:             sender1,
		// 	desiredError:       "",
		// 	successMsg:         "successfully executed the recipe",
		// 	showError:          false,
		// 	checkCoinName:      "chair",
		// 	checkCoinAvailable: true,
		// 	checkItemName:      "",
		// 	checkItemAvailable: false,
		// },
		// "pylon distribution check on pylon input recipes": {
		// 	itemIDs:                []string{},
		// 	addInputCoin:           false,
		// 	rcpID:                  pylonInputRecipeData.RecipeID, // coin 2 coin Recipe ID
		// 	sender:                 sender1,
		// 	desiredError:           "",
		// 	successMsg:             "successfully executed the recipe",
		// 	showError:              false,
		// 	checkCoinName:          types.Pylon,
		// 	checkCoinAvailable:     true,
		// 	checkItemName:          "",
		// 	checkItemAvailable:     false,
		// 	checkPylonDistribution: true,
		// 	pylonsLLCDistribution:  100 * config.Config.Fee.RecipePercent / 100,
		// },
		// "zero input item and 1 output item recipe test": {
		// 	itemIDs:            []string{},
		// 	addInputCoin:       true,
		// 	rcpID:              zeroInOneOutItemRecipeData.RecipeID, // available ID
		// 	sender:             sender1,
		// 	desiredError:       "",
		// 	successMsg:         "successfully executed the recipe",
		// 	showError:          false,
		// 	checkItemName:      "Raichu",
		// 	checkItemAvailable: true,
		// },
		// "not existing item in input": {
		// 	itemIDs:            []string{"invaliditemID"},
		// 	dynamicItemSet:     false,
		// 	dynamicItemNames:   []string{"Raichu"},
		// 	addInputCoin:       true,
		// 	rcpID:              oneInputOneOutputRecipeData.RecipeID, // available ID
		// 	sender:             sender1,
		// 	desiredError:       "The item doesn't exist",
		// 	showError:          true,
		// 	checkItemName:      "",
		// 	checkItemAvailable: false,
		// },
		// "wrong item in input": {
		// 	itemIDs:            []string{"invaliditemID"},
		// 	dynamicItemSet:     true,
		// 	dynamicItemNames:   []string{"NoRaichu"},
		// 	addInputCoin:       true,
		// 	rcpID:              oneInputOneOutputRecipeData.RecipeID, // available ID
		// 	sender:             sender1,
		// 	desiredError:       "[0]th item does not match",
		// 	successMsg:         "successfully executed the recipe",
		// 	showError:          true,
		// 	checkItemName:      "",
		// 	checkItemAvailable: false,
		// },
		// "1 input item and 1 output item recipe test": {
		// 	itemIDs:            []string{},
		// 	dynamicItemSet:     true,
		// 	dynamicItemNames:   []string{"Raichu"},
		// 	addInputCoin:       true,
		// 	rcpID:              oneInputOneOutputRecipeData.RecipeID, // available ID
		// 	sender:             sender1,
		// 	desiredError:       "",
		// 	successMsg:         "successfully executed the recipe",
		// 	showError:          false,
		// 	checkItemName:      "Zombie",
		// 	checkItemAvailable: true,
		// },
		// "item generation with catalyst item test": {
		// 	itemIDs:            []string{},
		// 	dynamicItemSet:     true,
		// 	dynamicItemNames:   []string{"catalyst"},
		// 	addInputCoin:       true,
		// 	rcpID:              oneCatalystOneOutputRecipeData.RecipeID, // available ID
		// 	sender:             sender1,
		// 	desiredError:       "",
		// 	successMsg:         "successfully executed the recipe",
		// 	showError:          false,
		// 	checkItemName:      "catalyst", // "catalyst" item should be kept
		// 	checkItemAvailable: true,
		// },
		// "randomness test on no input (1 coin | 1) item output recipe": {
		// 	itemIDs:                  []string{},
		// 	dynamicItemSet:           false,
		// 	addInputCoin:             true,
		// 	rcpID:                    noInput1Coin1ItemRecipeData.RecipeID, // available ID
		// 	sender:                   sender1,
		// 	desiredError:             "",
		// 	successMsg:               "successfully executed the recipe",
		// 	showError:                false,
		// 	checkCoinName:            "chaira",
		// 	checkItemName:            "ZombieA",
		// 	checkItemOrCoinAvailable: true,
		// },
		// "random function test on program on no input (1 coin | 1) item output recipe": {
		// 	itemIDs:                  []string{},
		// 	dynamicItemSet:           false,
		// 	addInputCoin:             true,
		// 	rcpID:                    noInput1Coin1ItemRandRecipeData.RecipeID, // available ID
		// 	sender:                   sender1,
		// 	desiredError:             "",
		// 	successMsg:               "successfully executed the recipe",
		// 	showError:                false,
		// 	checkCoinName:            "zmbr",
		// 	checkItemName:            "ZombieRand",
		// 	checkItemOrCoinAvailable: true,
		// },
		// "item upgrade test": {
		// 	itemIDs:            []string{},
		// 	dynamicItemSet:     true,
		// 	dynamicItemNames:   []string{"Raichu"},
		// 	addInputCoin:       true,
		// 	rcpID:              itemUpgradeRecipeData.RecipeID, // available ID
		// 	sender:             sender1,
		// 	desiredError:       "",
		// 	successMsg:         "successfully executed the recipe",
		// 	showError:          false,
		// 	checkItemName:      "RaichuV2",
		// 	checkItemAvailable: true,
		// },
		// "item upgrade with catalyst item test": {
		// 	itemIDs:            []string{},
		// 	dynamicItemSet:     true,
		// 	dynamicItemNames:   []string{"RaichuTC", "catalyst"},
		// 	addInputCoin:       true,
		// 	rcpID:              itemUpgradeWithCatalystRecipeData.RecipeID, // available ID
		// 	sender:             sender1,
		// 	desiredError:       "",
		// 	successMsg:         "successfully executed the recipe",
		// 	showError:          false,
		// 	checkItemName:      "RaichuTCV2",
		// 	checkItemAvailable: true,
		// },
		"pylon distribution check on pylon input recipes": {
			itemIDs:                []string{},
			addInputCoin:           false,
			rcpID:                  usdInputRecipeData.RecipeID, // coin 2 coin Recipe ID
			sender:                 sender1,
			desiredError:           "",
			successMsg:             "successfully executed the recipe",
			showError:              false,
			checkCoinName:          "usd",
			checkCoinAvailable:     false,
			checkItemName:          "",
			checkItemAvailable:     false,
			checkPylonDistribution: true,
			pylonsLLCDistribution:  100 * config.Config.Fee.RecipePercent / 100,
			paymentId:              "pi_1IvphyKw8S6WAC9T2YMFefCO",
			paymentMethod:          "pm_card_visa",
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			if tc.addInputCoin {
				err := tci.Bk.AddCoins(tci.Ctx, sender1, sdk.Coins{sdk.NewInt64Coin("wood", 50000)})
				require.NoError(t, err)
			}
			if tc.dynamicItemSet {
				tc.itemIDs = []string{}
				for _, diN := range tc.dynamicItemNames {
					dynamicItem := keeper.GenItem(cbData.CookbookID, tc.sender, diN)
					err := tci.PlnK.SetItem(tci.Ctx, dynamicItem)
					require.NoError(t, err)
					tc.itemIDs = append(tc.itemIDs, dynamicItem.ID)
				}

			}
			msg := types.NewMsgExecuteRecipe(tc.rcpID, tc.sender.String(), tc.paymentId, tc.paymentMethod, tc.itemIDs)
			result, err := tci.PlnH.ExecuteRecipe(sdk.WrapSDKContext(tci.Ctx), &msg)

			if tc.showError == false {
				require.NoError(t, err)
				require.True(t, result.Status == "Success")
				require.True(t, result.Message == tc.successMsg)

				// calc generated coin availability
				coinAvailability := false
				if tc.checkCoinAvailable || tc.checkItemOrCoinAvailable {
					coinAvailability = keeper.HasCoins(tci.PlnK, tci.Ctx, tc.sender, sdk.Coins{sdk.NewInt64Coin(tc.checkCoinName, 1)})
				}

				// calc generated item availability
				items, err := tci.PlnK.GetItemsBySender(tci.Ctx, tc.sender)
				require.NoError(t, err)

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
					require.NoError(t, err)
					pylonAvailOnLLC := keeper.HasCoins(tci.PlnK, tci.Ctx, pylonsLLCAddress, sdk.Coins{sdk.NewInt64Coin(types.Pylon, tc.pylonsLLCDistribution)})
					require.True(t, pylonAvailOnLLC)
				}
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}

func TestHandlerMsgCheckExecution(t *testing.T) {
	tci := keeper.SetupTestCoinInput()
	tci.PlnH = NewMsgServerImpl(tci.PlnK)

	sender1, sender2, _, _ := keeper.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	// mock cookbook
	cbData := MockCookbook(tci, sender1)

	// mock delayed coin to coin recipe
	c2cRecipeData := MockPopularRecipe(Rcp5BlockDelayed5xWoodcoinTo1xChaircoin, tci, "existing recipe", cbData.CookbookID, sender1, "pi_1DoShv2eZvKYlo2CqsROyFun", "card")

	// mock delayed more than 1 item input recipe
	knifeMergeRecipeData := MockPopularRecipe(Rcp2BlockDelayedKnifeMerge, tci,
		"knife merge recipe", cbData.CookbookID, sender1, "pi_1DoShv2eZvKYlo2CqsROyFun", "card")

	// mock delayed item upgrade recipe
	knifeUpgradeRecipeData := MockPopularRecipe(Rcp2BlockDelayedKnifeUpgrade, tci,
		"knife upgrade recipe", cbData.CookbookID, sender1, "pi_1DoShv2eZvKYlo2CqsROyFun", "card")

	// mock delayed knife buyer recipe
	knifeBuyerRecipeData := MockPopularRecipe(Rcp2BlockDelayedKnifeBuyer, tci,
		"knife upgrade recipe", cbData.CookbookID, sender1, "pi_1DoShv2eZvKYlo2CqsROyFun", "card")

	cases := map[string]struct {
		rcpID               string
		itemIDs             []string
		dynamicItemSet      bool
		dynamicItemNames    []string
		sender              sdk.AccAddress
		payToComplete       bool
		addHeight           int64
		expectedMessage     string
		expectError         bool
		coinAddition        int64
		retryExecution      bool
		retryResMessage     string
		desiredUpgradedName string
		paymentId           string
		paymentMethod       string
	}{
		"coin to coin recipe execution test": {
			rcpID:            c2cRecipeData.RecipeID,
			dynamicItemSet:   false,
			dynamicItemNames: []string{},
			sender:           sender1,
			payToComplete:    false,
			addHeight:        15,
			expectedMessage:  "successfully completed the execution",
			paymentId:        "pi_1DoShv2eZvKYlo2CqsROyFun",
			paymentMethod:    "card",
		},
		"coin to coin early pay recipe execution fail due to insufficient balance": {
			rcpID:            c2cRecipeData.RecipeID,
			dynamicItemSet:   false,
			dynamicItemNames: []string{},
			sender:           sender2,
			payToComplete:    true,
			expectError:      true,
			expectedMessage:  "insufficient balance to complete the execution",
			paymentId:        "pi_1DoShv2eZvKYlo2CqsROyFun",
			paymentMethod:    "card",
		},
		"coin to coin early pay recipe execution test": {
			rcpID:            c2cRecipeData.RecipeID,
			dynamicItemSet:   false,
			dynamicItemNames: []string{},
			sender:           sender2,
			payToComplete:    true,
			expectedMessage:  "successfully paid to complete the execution",
			coinAddition:     300,
			paymentId:        "pi_1DoShv2eZvKYlo2CqsROyFun",
			paymentMethod:    "card",
		},
		"item upgrade recipe success execution test": {
			rcpID:               knifeUpgradeRecipeData.RecipeID,
			dynamicItemSet:      true,
			dynamicItemNames:    []string{"Knife"},
			sender:              sender1,
			payToComplete:       false,
			addHeight:           3,
			expectedMessage:     "successfully completed the execution",
			desiredUpgradedName: "KnifeV2",
			paymentId:           "pi_1DoShv2eZvKYlo2CqsROyFun",
			paymentMethod:       "card",
		},
		"more than 1 item input recipe success execution test": {
			rcpID:            knifeMergeRecipeData.RecipeID,
			dynamicItemSet:   true,
			dynamicItemNames: []string{"Knife1", "Knife2"},
			sender:           sender1,
			payToComplete:    false,
			addHeight:        3,
			expectedMessage:  "successfully completed the execution",
			paymentId:        "pi_1DoShv2eZvKYlo2CqsROyFun",
			paymentMethod:    "card",
		},
		"item generation recipe success execution test": {
			rcpID:           knifeBuyerRecipeData.RecipeID,
			dynamicItemSet:  false,
			sender:          sender1,
			payToComplete:   false,
			addHeight:       3,
			expectedMessage: "successfully completed the execution",
			retryExecution:  true,
			retryResMessage: "execution already completed",
			paymentId:       "pi_1DoShv2eZvKYlo2CqsROyFun",
			paymentMethod:   "card",
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			if tc.dynamicItemSet {
				tc.itemIDs = []string{}
				for _, iN := range tc.dynamicItemNames {
					dynamicItem := keeper.GenItem(cbData.CookbookID, tc.sender, iN)
					err := tci.PlnK.SetItem(tci.Ctx, dynamicItem)
					require.NoError(t, err)
					tc.itemIDs = append(tc.itemIDs, dynamicItem.ID)
				}
			}
			err := tci.Bk.AddCoins(tci.Ctx, tc.sender, sdk.Coins{sdk.NewInt64Coin("wood", 5)})
			require.NoError(t, err)

			execRcpResponse, err := MockExecution(tci, tc.rcpID,
				tc.sender,
				tc.paymentId,
				tc.paymentMethod,
				tc.itemIDs,
			)
			require.NoError(t, err)
			require.True(t, execRcpResponse.Status == "Success")
			require.True(t, execRcpResponse.Message == "scheduled the recipe")

			if tc.coinAddition != 0 {
				err = tci.Bk.AddCoins(tci.Ctx, tc.sender, types.NewPylon(tc.coinAddition))
				require.NoError(t, err)
			}

			scheduleOutput := types.ExecuteRecipeScheduleOutput{}
			err = json.Unmarshal(execRcpResponse.Output, &scheduleOutput)
			require.NoError(t, err)

			if tc.dynamicItemSet && len(tc.itemIDs) > 0 {
				usedItem, err := tci.PlnK.GetItem(tci.Ctx, tc.itemIDs[0])
				require.NoError(t, err)
				require.True(t, usedItem.OwnerRecipeID == tc.rcpID)
			}

			checkExec := types.NewMsgCheckExecution(scheduleOutput.ExecID, tc.payToComplete, tc.sender.String())

			futureContext := tci.Ctx.WithBlockHeight(tci.Ctx.BlockHeight() + tc.addHeight)
			result, err := tci.PlnH.CheckExecution(sdk.WrapSDKContext(futureContext), &checkExec)
			require.NoError(t, err)

			if tc.expectError {
				require.True(t, result.Status == "Failure")
				require.True(t, result.Message == tc.expectedMessage)

			} else {
				require.True(t, result.Status == "Success")
				require.True(t, result.Message == tc.expectedMessage)
			}

			if len(tc.desiredUpgradedName) > 0 && len(tc.itemIDs) > 0 {
				updatedItem, err := tci.PlnK.GetItem(futureContext, tc.itemIDs[0])
				require.NoError(t, err)
				updatedName, ok := updatedItem.FindString("Name")
				require.True(t, ok)
				require.True(t, updatedName == tc.desiredUpgradedName)
			}

			if tc.retryExecution {
				result, _ := tci.PlnH.CheckExecution(sdk.WrapSDKContext(futureContext), &checkExec)
				require.NoError(t, err)
				require.True(t, result.Status == "Completed")
				require.True(t, result.Message == tc.retryResMessage)
			}
		})
	}
}
