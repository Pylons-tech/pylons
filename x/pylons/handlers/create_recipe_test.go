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

func TestHandlerMsgCreateRecipe(t *testing.T) {
	mockedCoinInput := setupTestCoinInput()

	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	mockedCoinInput.bk.AddCoins(mockedCoinInput.ctx, sender, types.PremiumTier.Fee)

	cases := map[string]struct {
		cookbookName   string
		createCookbook bool
		recipeDesc     string
		sender         sdk.AccAddress
		desiredError   string
		showError      bool
	}{
		"cookbook owner check": {
			cookbookName:   "book000001",
			createCookbook: false,
			recipeDesc:     "this has to meet character limits",
			sender:         sender,
			desiredError:   "cookbook not owned by the sender",
			showError:      true,
		},
		"successful check": {
			cookbookName:   "book000001",
			createCookbook: true,
			recipeDesc:     "this has to meet character limits",
			sender:         sender,
			desiredError:   "",
			showError:      false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			cbData := CreateCBResponse{}
			if tc.createCookbook {
				cookbookMsg := msgs.NewMsgCreateCookbook(tc.cookbookName, "this has to meet character limits", "SketchyCo", "1.0.0", "example@example.com", 1, tc.sender)
				cookbookResult := HandlerMsgCreateCookbook(mockedCoinInput.ctx, mockedCoinInput.plnK, cookbookMsg)

				err := json.Unmarshal(cookbookResult.Data, &cbData)
				require.True(t, err == nil)
				require.True(t, len(cbData.CookbookID) > 0)
			}

			msg := msgs.NewMsgCreateRecipe("name", cbData.CookbookID, tc.recipeDesc,
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
				}, tc.sender,
			)

			result := HandlerMsgCreateRecipe(mockedCoinInput.ctx, mockedCoinInput.plnK, msg)
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
