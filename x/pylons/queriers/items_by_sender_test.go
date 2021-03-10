package queriers

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/stretchr/testify/require"
)

func TestQueriersItemsBySender(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
	tci.PlnQ = NewQuerierServerImpl(tci.PlnK)

	sender1, sender2, _, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	// mock cookbook
	cbData := handlers.MockCookbookByName(tci, sender1, "cookbook-00001")

	item := keep.GenItem(cbData.CookbookID, sender1, "Raichu")
	err := tci.PlnK.SetItem(tci.Ctx, item)
	require.True(t, err == nil)

	cases := map[string]struct {
		sender        string
		desiredError  string
		desiredLength int
		showError     bool
	}{
		"not existing sender": {
			sender:        "invalidSender",
			desiredError:  "decoding bech32 failed: string not all lowercase or all uppercase",
			desiredLength: 0,
			showError:     true,
		},
		"error check when not providing sender": {
			sender:        "",
			desiredError:  "no sender is provided in path",
			desiredLength: 0,
			showError:     true,
		},
		"sender with no item": {
			sender:        sender2.String(),
			desiredError:  "",
			desiredLength: 0,
			showError:     false,
		},
		"sender with 1 item": {
			sender:        sender1.String(),
			desiredError:  "",
			desiredLength: 1,
			showError:     false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			result, err := tci.PlnQ.ItemsBySender(
				sdk.WrapSDKContext(tci.Ctx),
				&types.ItemsBySenderRequest{
					Sender: tc.sender,
				},
			)

			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.True(t, err == nil)

				cItems := result.Items
				require.True(t, len(cItems) == tc.desiredLength)
			}
		})
	}
}
