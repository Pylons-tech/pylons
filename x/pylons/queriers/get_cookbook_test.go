package queriers

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/require"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestGetCookbook(t *testing.T) {
	tci := keeper.SetupTestCoinInput()
	tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
	tci.PlnQ = NewQuerierServerImpl(tci.PlnK)

	sender1, _, _, _ := keeper.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	// mock cookbook
	cbData := handlers.MockCookbook(tci, sender1)

	cases := map[string]struct {
		cookbookID    string
		desiredError  string
		showError     bool
		desiredRcpCnt int
		cbName        string
	}{
		"error check when providing invalid cookbook ID": {
			cookbookID:    "invalidCookbookID",
			showError:     true,
			desiredError:  "key invalidCookbookID not present in cookbook store",
			desiredRcpCnt: 0,
		},
		"error check when not providing cookbookID": {
			cookbookID:    "",
			showError:     true,
			desiredError:  "no cookbook id is provided in path",
			desiredRcpCnt: 0,
		},
		"get cookbook successful check": {
			cookbookID:    cbData.CookbookID,
			showError:     false,
			desiredError:  "",
			desiredRcpCnt: 1,
			cbName:        "cookbook-00001",
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			result, err := tci.PlnQ.GetCookbook(
				sdk.WrapSDKContext(tci.Ctx),
				&types.GetCookbookRequest{CookbookID: tc.cookbookID},
			)
			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.NoError(t, err)
				require.Equal(t, result.Name, tc.cbName)
			}
		})
	}
}

func TestListCookbook(t *testing.T) {
	tci := keeper.SetupTestCoinInput()
	tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
	tci.PlnQ = NewQuerierServerImpl(tci.PlnK)

	sender1, _, _, _ := keeper.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	// mock cookbook
	handlers.MockCookbook(tci, sender1)

	cases := map[string]struct {
		address      string
		desiredError string
		showError    bool
	}{
		"error check when providing invalid address": {
			address:      "invalid_address",
			showError:    true,
			desiredError: "decoding bech32 failed: invalid index of 1",
		},
		"error check when not providing address": {
			address:   "",
			showError: false,
		},
		"list cookbook successful check": {
			address:      sender1.String(),
			showError:    false,
			desiredError: "",
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			result, err := tci.PlnQ.ListCookbook(
				sdk.WrapSDKContext(tci.Ctx),
				&types.ListCookbookRequest{
					Address: tc.address,
				},
			)
			if tc.showError {
				require.Error(t, err)
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.NoError(t, err)

				require.True(t, len(result.Cookbooks) == 1)
			}
		})
	}
}
