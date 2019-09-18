package keep

import (
	"reflect"
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestKeeperGetRecipe(t *testing.T) {
	mockedCoinInput := setupTestCoinInput()

	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")

	mockedCoinInput.bk.AddCoins(mockedCoinInput.ctx, sender, types.PremiumTier.Fee)

	cases := map[string]struct {
		cookbookName string
		recipeName   string
		desc         string
		sender       sdk.AccAddress
		level        types.Level
		desiredError string
		showError    bool
	}{
		"basic flow test": {
			cookbookName: "cookbook-00001",
			recipeName:   "recipe-00001",
			desc:         "this has to meet character limits",
			sender:       sender,
			level:        1,
			desiredError: "",
			showError:    false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			cb := types.NewCookbook(
				"example@example.com", // msg.SupportEmail,
				tc.sender,             // msg.Sender,
				"1.0.0",               // msg.Version,
				tc.cookbookName,       // msg.Name,
				tc.desc,               // msg.Description,
				"SketchyCo",           // msg.Developer
			)
			err := mockedCoinInput.plnK.SetCookbook(mockedCoinInput.ctx, cb)
			require.True(t, err == nil)

			recipe := types.NewRecipe(tc.recipeName, cb.ID, tc.desc,
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
				},
				0, tc.sender)
			mockedCoinInput.plnK.SetRecipe(mockedCoinInput.ctx, recipe)
			readRecipe, err2 := mockedCoinInput.plnK.GetRecipe(mockedCoinInput.ctx, recipe.ID)
			require.True(t, err2 == nil)

			require.True(t, err2 == nil)
			require.True(t, reflect.DeepEqual(recipe, readRecipe))
		})
	}
}
