package queriers

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/require"

	abci "github.com/tendermint/tendermint/abci/types"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestListCookbook(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	sender1, _, _, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	// mock cookbook
	handlers.MockCookbook(tci, sender1)

	cases := map[string]struct {
		path         []string
		desiredError string
		showError    bool
	}{
		"error check when providing invalid address": {
			path:         []string{"invalid_address"},
			showError:    true,
			desiredError: "decoding bech32 failed: invalid index of 1",
		},
		"error check when not providing address": {
			path:         []string{},
			showError:    true,
			desiredError: "no address is provided in path",
		},
		"list cookbook successful check": {
			path:         []string{sender1.String()},
			showError:    false,
			desiredError: "",
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			result, err := ListCookbook(
				tci.Ctx,
				tc.path,
				abci.RequestQuery{
					Path: "",
					Data: []byte{},
				},
				tci.PlnK,
			)
			if tc.showError {
				// t.Errorf("ListCookbook err LOG:: %+v", err)
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.True(t, err == nil)
				cbList := types.CookbookList{}
				cbListErr := tci.PlnK.Cdc.UnmarshalJSON(result, &cbList)

				require.True(t, cbListErr == nil)
				require.True(t, len(cbList.Cookbooks) == 1)
			}
		})
	}
}
