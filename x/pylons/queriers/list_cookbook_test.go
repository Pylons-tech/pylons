package queriers

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	"strings"
	"testing"

	"github.com/stretchr/testify/require"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestListCookbook(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
	tci.PlnQ = NewQuerierServerImpl(tci.PlnK)

	sender1, _, _, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

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
			address:      "",
			showError:    true,
			desiredError: "no address is provided in path",
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
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.True(t, err == nil)

				require.True(t, len(result.Cookbooks) == 1)
			}
		})
	}
}
