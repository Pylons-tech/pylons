package queriers

import (
	"encoding/json"
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/stretchr/testify/require"
	abci "github.com/tendermint/tendermint/abci/types"
)

func TestQueriersItemsBySender(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	sender1, sender2, _, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	// mock cookbook
	cbData := handlers.MockCookbookByName(tci, sender1, "cookbook-00001")

	item := keep.GenItem(cbData.CookbookID, sender1, "Raichu")
	err := tci.PlnK.SetItem(tci.Ctx, *item)
	require.True(t, err == nil)

	cases := map[string]struct {
		path          []string
		desiredError  string
		desiredLength int
		showError     bool
	}{
		"not existing sender": {
			path:          []string{"invalidSender"},
			desiredError:  "decoding bech32 failed: string not all lowercase or all uppercase",
			desiredLength: 0,
			showError:     true,
		},
		"error check when not providing sender": {
			path:          []string{},
			desiredError:  "no sender is provided in path",
			desiredLength: 0,
			showError:     true,
		},
		"sender with no item": {
			path:          []string{sender2.String()},
			desiredError:  "",
			desiredLength: 0,
			showError:     false,
		},
		"sender with 1 item": {
			path:          []string{sender1.String()},
			desiredError:  "",
			desiredLength: 1,
			showError:     false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			result, err := ItemsBySender(
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

				itemResp := ItemResp{}
				itemRespErr := json.Unmarshal(result, &itemResp)
				require.True(t, itemRespErr == nil)

				cItems := itemResp.Items
				require.True(t, len(cItems) == tc.desiredLength)
			}
		})
	}
}
