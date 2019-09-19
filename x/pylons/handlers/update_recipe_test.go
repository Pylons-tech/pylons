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

	// mock new recipe
	newRcpMsg := msgs.NewMsgCreateRecipe("existing recipe", cbData.CookbookID, "this has to meet character limits",
		types.CoinInputList{
			types.CoinInput{
				Coin:  "Wood",
				Count: 5,
			},
		},
		types.CoinOutputList{
			types.CoinOutput{
				Coin:  "Chair",
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

	cases := map[string]struct {
		cookbookId   string
		recipeName   string
		recipeID     string
		recipeDesc   string
		sender       sdk.AccAddress
		desiredError string
		showError    bool
	}{
		"update recipe check for not available recipe": {
			cookbookId:   cbData.CookbookID,
			recipeName:   "recipe0001",
			recipeID:     "id001", // not available ID
			recipeDesc:   "this has to meet character limits lol",
			sender:       sender1,
			desiredError: "the owner of the recipe is different then the current sender",
			showError:    true,
		},
		"successful test for update recipe": {
			cookbookId:   cbData.CookbookID,
			recipeName:   "recipe0001",
			recipeID:     recipeData.RecipeID, // available ID
			recipeDesc:   "this has to meet character limits lol",
			sender:       sender1,
			desiredError: "",
			showError:    false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			msg := msgs.NewMsgUpdateRecipe(tc.recipeName, tc.cookbookId, tc.recipeID, tc.recipeDesc,
				types.CoinInputList{
					types.CoinInput{
						Coin:  "Wood",
						Count: 5,
					},
				},
				types.CoinOutputList{
					types.CoinOutput{
						Coin:  "Chair",
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
				}, sender1)

			result := HandlerMsgUpdateRecipe(mockedCoinInput.ctx, mockedCoinInput.plnK, msg)

			if tc.showError == false {
				recipeData := UpdateRecipeResponse{}
				err := json.Unmarshal(result.Data, &recipeData)
				require.True(t, err == nil)
				require.True(t, len(recipeData.RecipeID) > 0)
			} else {
				require.True(t, strings.Contains(result.Log, tc.desiredError))
			}
		})
	}
}
