package keep

import (
	"reflect"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func GenRecipe(sender sdk.AccAddress, cbID string, name string, desc string) types.Recipe {
	return types.NewRecipe(name, cbID, desc,
		types.GenCoinInputList("wood", 5),
		types.GenItemInputList("Raichu"),
		types.GenEntries("chair", "Raichu"),
		types.GenOneOutput(2),
		0,
		sender,
	)
}

func TestKeeperGetRecipe(t *testing.T) {
	mockedCoinInput := SetupTestCoinInput()

	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")

	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender, types.NewPylon(1000000))

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
				"SketchyCo",           // msg.Developer,
				50,                    // msg.CostPerBlock,
			)
			err := mockedCoinInput.PlnK.SetCookbook(mockedCoinInput.Ctx, cb)
			require.True(t, err == nil)

			recipe := GenRecipe(tc.sender, cb.ID, tc.recipeName, tc.desc)
			mockedCoinInput.PlnK.SetRecipe(mockedCoinInput.Ctx, recipe)
			readRecipe, err2 := mockedCoinInput.PlnK.GetRecipe(mockedCoinInput.Ctx, recipe.ID)
			// t.Errorf("recipe_test err LOG:: %+v %+v", readRecipe, err2)

			require.True(t, err2 == nil)
			require.True(t, err2 == nil)
			require.True(t, reflect.DeepEqual(recipe, readRecipe))
		})
	}
}
