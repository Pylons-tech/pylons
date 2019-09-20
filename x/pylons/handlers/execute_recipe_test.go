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

func TestHandlerMsgUpdateRecipe(t *testing.T) {
	mockedCoinInput := setupTestCoinInput()

	sender1, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")

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

	// mock new recipe
	newRcpMsg := msgs.NewMsgCreateRecipe("existing recipe", cbData.CookbookID, "this has to meet character limits",
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
				types.StringParamMap{"Name": types.StringParam{"Raichu", "1.0"}},
			},
		}, sender1,
	)

	newRcpResult := HandlerMsgCreateRecipe(mockedCoinInput.ctx, mockedCoinInput.plnK, newRcpMsg)
	recipeData := CreateRecipeResponse{}
	json.Unmarshal(newRcpResult.Data, &recipeData)

	// 1) create cookbook - NewMsgCreateCookbook & HandlerCreateCookbook
	// 2) create recipe - NewMsgCreateRecipe & HandlerCreateRecipe
	// 3) create items - NewItem
	// 4) record the items in keeper - SetItem
	// 5) run execute_recipe handler - NewMsgExecuteRecipe & HandlerExecuteRecipe

	cases := map[string]struct {
		cookbookId   string
		itemIDs      []string
		addInputCoin bool
		recipeName   string
		recipeID     string
		recipeDesc   string
		sender       sdk.AccAddress
		desiredError string
		showError    bool
	}{
		// "insufficient coin balance check": {
		// 	recipeName:   "recipe0001",
		// 	itemIDs:      []string{},
		// 	addInputCoin: false,
		// 	recipeID:     c2cRecipeData.RecipeID, // coin 2 coin Recipe ID
		// 	recipeDesc:   "this has to meet character limits lol",
		// 	sender:       sender1,
		// 	desiredError: "insufficient coin balance",
		// 	showError:    true,
		// },
		// "the item IDs count doesn't match the recipe input": {
		// 	recipeName:   "recipe0001",
		// 	itemIDs:      []string{"wood"},
		// 	addInputCoin: true,
		// 	recipeID:     c2cRecipeData.RecipeID, // coin 2 coin Recipe ID
		// 	recipeDesc:   "this has to meet character limits lol",
		// 	sender:       sender1,
		// 	desiredError: "the item IDs count doesn't match the recipe input",
		// 	showError:    true,
		// },
		// "coin to coin recipe execution test": {
		// 	recipeName:   "recipe0001",
		// 	itemIDs:      []string{},
		// 	addInputCoin: true,
		// 	recipeID:     c2cRecipeData.RecipeID, // coin 2 coin Recipe ID
		// 	recipeDesc:   "this has to meet character limits lol",
		// 	sender:       sender1,
		// 	desiredError: "",
		// 	showError:    false,
		// },
		"zero input item and 1 output item recipe test": {
			recipeName:   "recipe0001",
			itemIDs:      []string{},
			addInputCoin: true,
			recipeID:     zeroInOneOutItemRecipeData.RecipeID, // available ID
			recipeDesc:   "this has to meet character limits lol",
			sender:       sender1,
			desiredError: "",
			showError:    false,
		},
		// "successful test for execute recipe": {
		// 	recipeName:   "recipe0001",
		// 	recipeID:     recipeData.RecipeID, // available ID
		// 	recipeDesc:   "this has to meet character limits lol",
		// 	sender:       sender1,
		// 	desiredError: "",
		// 	showError:    false,
		// },
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			if tc.addInputCoin {
				mockedCoinInput.bk.AddCoins(mockedCoinInput.ctx, sender1, sdk.Coins{sdk.NewInt64Coin("wood", 50000)})
			}
			// func NewItem(cookbookID string, doubles map[string]float64, longs map[string]int, strings map[string]string, sender sdk.AccAddress) *Item {
			// 	item := &Item{
			// 		CookbookID: cookbookID,
			// 		Doubles:    doubles,
			// 		Longs:      longs,
			// 		Strings:    strings,
			// 		Sender:     sender,
			// 	}
			// 	item.ID = item.KeyGen()
			// 	return item
			// }
			// (recipeID string, sender sdk.AccAddress, itemIDs []string) MsgExecuteRecipe
			msg := msgs.NewMsgExecuteRecipe(tc.recipeID, tc.sender, tc.itemIDs)
			result := HandlerMsgExecuteRecipe(mockedCoinInput.ctx, mockedCoinInput.plnK, msg)

			t.Errorf("HandlerMsgExecuteRecipe LOG:: %+v", result)

			if tc.showError == false {
				execRcpResponse := ExecuteRecipeResp{}
				err := json.Unmarshal(result.Data, &execRcpResponse)

				require.True(t, err == nil)
				require.True(t, execRcpResponse.Status == "Success")
				require.True(t, execRcpResponse.Message == "successfully executed the recipe")

				require.True(t, mockedCoinInput.plnK.CoinKeeper.HasCoins(mockedCoinInput.ctx, tc.sender, sdk.Coins{sdk.NewInt64Coin("chair", 1)}))
			} else {
				require.True(t, strings.Contains(result.Log, tc.desiredError))
			}
		})
	}
}
