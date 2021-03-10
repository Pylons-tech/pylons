package keep

import (
	"reflect"
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func GenCookbook(sender sdk.AccAddress, name string, desc string) types.Cookbook {
	return types.NewCookbook(
		types.Email{"example@example.com"}, // msg.SupportEmail,
		sender,                             // msg.Sender,
		types.SemVer{"1.0.0"},              // msg.Version,
		name,                               // msg.Name,
		desc,                               // msg.Description,
		"SketchyCo",                        // msg.Developer,
		50,                                 // msg.CostPerBlock
	)
}

func TestKeeperGetCookbook(t *testing.T) {
	tci := SetupTestCoinInput()
	sender, _, _, _ := SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	cb := GenCookbook(sender, "cookbook-00001", "this has to meet character limits")
	err := tci.PlnK.SetCookbook(tci.Ctx, cb)
	require.True(t, err == nil)

	cases := map[string]struct {
		cbID         string
		desiredError string
		showError    bool
	}{
		"basic flow test": {
			cbID:         cb.ID,
			desiredError: "",
			showError:    false,
		},
		"not existing cookbookID test": {
			cbID:         "INVALID-CookbookID",
			desiredError: "The cookbook doesn't exist",
			showError:    true,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {

			readCookbook, err := tci.PlnK.GetCookbook(tci.Ctx, tc.cbID)
			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.True(t, err == nil)
				require.True(t, cb.SupportEmail == readCookbook.SupportEmail)
				require.True(t, reflect.DeepEqual(cb, readCookbook))
			}
		})
	}
}
