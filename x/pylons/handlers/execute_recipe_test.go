package handlers

import (
	"encoding/json"
	"strings"
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestHandlerMsgExecuteRecipe(t *testing.T) {
	mockedCoinInput := setupTestCoinInput()

	sender1, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	sender2, _ := sdk.AccAddressFromBech32("cosmos16wfryel63g7axeamw68630wglalcnk3l0zuadc")

	mockedCoinInput.bk.AddCoins(mockedCoinInput.ctx, sender1, types.PremiumTier.Fee)

	// mock cookbook
	cookbookName := "cookbook-00001"
	cookbookDesc := "this has to meet character limits"
	msg := msgs.NewMsgCreateCookbook(cookbookName, cookbookDesc, "SketchyCo", "1.0.0", "example@example.com", 1, sender1)
	cbResult := HandlerMsgCreateCookbook(mockedCoinInput.ctx, mockedCoinInput.plnK, msg)
	cbData := CreateCBResponse{}
	json.Unmarshal(cbResult.Data, &cbData)

	// mock coin to coin recipe
	newC2CRcpMsg := msgs.NewMsgCreateRecipe("existing recipe", cbData.CookbookID, "this has to meet character limits",
		types.CoinInputList{
			types.CoinInput{
				Coin:  "wood",
				Count: 5,
			},
		},
		types.CoinOutputList{
			types.CoinOutput{
				Coin:  "chair",
				Count: 1,
			},
		},
		types.ItemInputList{},
		types.ItemOutputList{},
		sender1,
	)
	newC2CRcpResult := HandlerMsgCreateRecipe(mockedCoinInput.ctx, mockedCoinInput.plnK, newC2CRcpMsg)
	c2cRecipeData := CreateRecipeResponse{}
	json.Unmarshal(newC2CRcpResult.Data, &c2cRecipeData)

	// mock coin to coin recipe
	newZeroInOneOutItemRcpMsg := msgs.NewMsgCreateRecipe("existing recipe", cbData.CookbookID, "this has to meet character limits",
		types.CoinInputList{
			types.CoinInput{
				Coin:  "wood",
				Count: 5,
			},
		},
		types.CoinOutputList{
			types.CoinOutput{
				Coin:  "chair",
				Count: 1,
			},
		},
		types.ItemInputList{},
		types.ItemOutputList{
			types.ItemOutput{
				types.DoubleParamMap{"endurance": types.DoubleParam{"0.70", "1.0", "1.0"}},
				types.LongParamMap{"HP": types.LongParam{100, 140, "1.0"}},
				types.StringParamMap{"Name": types.StringParam{"Raichu", "1.0"}},
			},
		},
		sender1,
	)
	newZeroInOneOutItemRcpResult := HandlerMsgCreateRecipe(mockedCoinInput.ctx, mockedCoinInput.plnK, newZeroInOneOutItemRcpMsg)
	zeroInOneOutItemRecipeData := CreateRecipeResponse{}
	json.Unmarshal(newZeroInOneOutItemRcpResult.Data, &zeroInOneOutItemRecipeData)

	// mock 1 input 1 output recipe
	newOneInputOneOutputItemRcpMsg := msgs.NewMsgCreateRecipe("existing recipe", cbData.CookbookID, "this has to meet character limits",
		types.CoinInputList{
			types.CoinInput{
				Coin:  "wood",
				Count: 5,
			},
		},
		types.CoinOutputList{
			types.CoinOutput{
				Coin:  "chair",
				Count: 1,
			},
		},
		types.ItemInputList{
			types.ItemInput{
				types.DoubleInputParamMap{"endurance": types.DoubleInputParam{"0.70", "1.0"}},
				types.LongInputParamMap{"HP": types.LongInputParam{100, 140}},
				types.StringInputParamMap{"Name": types.StringInputParam{"Raichu"}},
			},
		},
		types.ItemOutputList{
			types.ItemOutput{
				types.DoubleParamMap{"endurance": types.DoubleParam{"0.70", "1.0", "1.0"}},
				types.LongParamMap{"HP": types.LongParam{100, 140, "1.0"}},
				types.StringParamMap{"Name": types.StringParam{"Zombie", "1.0"}},
			},
		}, sender1,
	)
	newOneInputOneOutputItemRcpResult := HandlerMsgCreateRecipe(mockedCoinInput.ctx, mockedCoinInput.plnK, newOneInputOneOutputItemRcpMsg)
	oneInputOneOutputRecipeData := CreateRecipeResponse{}
	json.Unmarshal(newOneInputOneOutputItemRcpResult.Data, &oneInputOneOutputRecipeData)

	cases := map[string]struct {
		cookbookId         string
		itemIDs            []string
		dynamicItemSet     bool
		dynamicItemName    string
		addInputCoin       bool
		recipeID           string
		recipeDesc         string
		sender             sdk.AccAddress
		desiredError       string
		showError          bool
		checkItemName      string
		checkItemAvailable bool
	}{
		"insufficient coin balance check": {
			itemIDs:            []string{},
			addInputCoin:       false,
			recipeID:           c2cRecipeData.RecipeID, // coin 2 coin Recipe ID
			recipeDesc:         "this has to meet character limits lol",
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
			recipeDesc:         "this has to meet character limits lol",
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
			recipeDesc:         "this has to meet character limits lol",
			sender:             sender1,
			desiredError:       "",
			showError:          false,
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
		"not existing item in input": {
			itemIDs:            []string{"invaliditemID"},
			dynamicItemSet:     false,
			dynamicItemName:    "Raichu",
			addInputCoin:       true,
			recipeID:           oneInputOneOutputRecipeData.RecipeID, // available ID
			recipeDesc:         "this has to meet character limits lol",
			sender:             sender1,
			desiredError:       "The item doesn't exist",
			showError:          true,
			checkItemName:      "",
			checkItemAvailable: false,
		},
		"Wrong item in input": {
			itemIDs:            []string{"invaliditemID"},
			dynamicItemSet:     true,
			dynamicItemName:    "NoRaichu",
			addInputCoin:       true,
			recipeID:           oneInputOneOutputRecipeData.RecipeID, // available ID
			recipeDesc:         "this has to meet character limits lol",
			sender:             sender1,
			desiredError:       "the item inputs dont match any items provided",
			showError:          true,
			checkItemName:      "",
			checkItemAvailable: false,
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
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			if tc.addInputCoin {
				mockedCoinInput.bk.AddCoins(mockedCoinInput.ctx, sender1, sdk.Coins{sdk.NewInt64Coin("wood", 50000)})
			}
			if tc.dynamicItemSet {
				dynamicItem := types.NewItem(
					cbData.CookbookID,
					(types.DoubleInputParamMap{"endurance": types.DoubleInputParam{"0.70", "1.0"}}).Actualize(),
					(types.LongInputParamMap{"HP": types.LongInputParam{100, 140}}).Actualize(),
					(types.StringInputParamMap{"Name": types.StringInputParam{tc.dynamicItemName}}).Actualize(),
					tc.sender,
				)
				mockedCoinInput.plnK.SetItem(mockedCoinInput.ctx, *dynamicItem)
				tc.itemIDs = []string{dynamicItem.ID}
			}

			msg := msgs.NewMsgExecuteRecipe(tc.recipeID, tc.sender, tc.itemIDs)
			result := HandlerMsgExecuteRecipe(mockedCoinInput.ctx, mockedCoinInput.plnK, msg)

			if tc.showError == false {
				execRcpResponse := ExecuteRecipeResp{}
				err := json.Unmarshal(result.Data, &execRcpResponse)

				require.True(t, err == nil)
				require.True(t, execRcpResponse.Status == "Success")
				require.True(t, execRcpResponse.Message == "successfully executed the recipe")

				require.True(t, mockedCoinInput.plnK.CoinKeeper.HasCoins(mockedCoinInput.ctx, tc.sender, sdk.Coins{sdk.NewInt64Coin("chair", 1)}))

				if tc.checkItemAvailable {
					items, err := mockedCoinInput.plnK.GetItemsBySender(mockedCoinInput.ctx, tc.sender)
					require.True(t, err == nil)

					itemAvailable := false
					for _, item := range items {
						if item.Strings["Name"] == tc.checkItemName {
							itemAvailable = true
							break
						}
					}
					require.True(t, itemAvailable == true)
				}
			} else {
				require.True(t, strings.Contains(result.Log, tc.desiredError))
			}
		})
	}
}
