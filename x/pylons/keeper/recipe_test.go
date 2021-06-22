package keeper

import (
	"encoding/json"
	"testing"

	"github.com/stretchr/testify/require"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func GenRecipe(sender sdk.AccAddress, cbID string, name string, desc string) types.Recipe {
	return types.NewRecipe(name, cbID, desc,
		types.GenCoinInputList("wood", 5),
		types.GenItemInputList("Raichu"),
		types.GenEntries("chair", "Raichu"),
		types.GenOneOutput("chair", "Raichu"),
		0,
		sender,
		"",
	)
}

func TestKeeperGetRecipe(t *testing.T) {
	tci := SetupTestCoinInput()
	sender, _, _, _ := SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	cases := map[string]struct {
		cookbookName string
		recipeName   string
		desc         string
		sender       sdk.AccAddress
		level        int64
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
				"example@example.com", // SupportEmail,
				tc.sender,             // Sender,
				"1.0.0",               // Version,
				tc.cookbookName,       // Name,
				tc.desc,               // Description,
				"SketchyCo",           // Developer,
				50,                    // CostPerBlock,
			)
			err := tci.PlnK.SetCookbook(tci.Ctx, cb)
			require.NoError(t, err)

			recipe := GenRecipe(tc.sender, cb.ID, tc.recipeName, tc.desc)
			err = tci.PlnK.SetRecipe(tci.Ctx, recipe)
			require.NoError(t, err)

			readRecipe, err := tci.PlnK.GetRecipe(tci.Ctx, recipe.ID)
			require.NoError(t, err)

			recipeBytes, err := json.Marshal(recipe)
			require.NoError(t, err)
			readBytes, err := json.Marshal(readRecipe)
			require.NoError(t, err)
			require.EqualValues(t, string(recipeBytes), string(readBytes))
		})
	}
}
