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

func TestGetCookbook(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	sender1, _, _, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	// mock cookbook
	cbData := handlers.MockCookbook(tci, sender1)

	cases := map[string]struct {
		path          []string
		desiredError  string
		showError     bool
		desiredRcpCnt int
		cbName        string
	}{
		"error check when providing invalid cookbook ID": {
			path:          []string{"invalid cookbookID"},
			showError:     true,
			desiredError:  "The cookbook doesn't exist",
			desiredRcpCnt: 0,
		},
		"error check when not providing cookbookID": {
			path:          []string{},
			showError:     true,
			desiredError:  "no cookbook id is provided in path",
			desiredRcpCnt: 0,
		},
		"get cookbook successful check": {
			path:          []string{cbData.CookbookID},
			showError:     false,
			desiredError:  "",
			desiredRcpCnt: 1,
			cbName:        "cookbook-00001",
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			result, err := GetCookbook(
				tci.Ctx,
				tc.path,
				abci.RequestQuery{
					Path: "",
					Data: []byte{},
				},
				tci.PlnK,
			)
			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.True(t, err == nil)
				readCookbook := types.Cookbook{}
				readCookbookErr := tci.PlnK.Cdc.UnmarshalJSON(result, &readCookbook)

				require.True(t, readCookbookErr == nil)
				require.True(t, readCookbook.Name == tc.cbName)
			}
		})
	}
}
