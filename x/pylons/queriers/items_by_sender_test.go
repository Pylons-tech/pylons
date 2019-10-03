package queriers

import (
	"strings"
	"testing"
	"encoding/json"

	"github.com/stretchr/testify/require"

	abci "github.com/tendermint/tendermint/abci/types"

	"github.com/MikeSofaer/pylons/x/pylons/handlers"
	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

func TestQueriersItemsBySender(t *testing.T) {
	mockedCoinInput := keep.SetupTestCoinInput()

	sender := "cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337"
	senderAccAddress, _ := sdk.AccAddressFromBech32(sender)
	sender2 := "cosmos16wfryel63g7axeamw68630wglalcnk3l0zuadc"

	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, senderAccAddress, types.PremiumTier.Fee)

	// mock cookbook
	cbData := handlers.MockCookbookByName(mockedCoinInput, senderAccAddress, "cookbook-00001")

	item := keep.GenItem(cbData.CookbookID, senderAccAddress, "Raichu")
	mockedCoinInput.PlnK.SetItem(mockedCoinInput.Ctx, *item)

	cases := map[string]struct {
		path    []string
		desiredError  string
		desiredLength int
		showError     bool
	}{
		"not existing sender": {
			path:    []string{"invalidSender"},
			desiredError:  "decoding bech32 failed: string not all lowercase or all uppercase",
			desiredLength: 0,
			showError:     true,
		},
		"error check when not providing sender": {
			path:    []string{},
			desiredError:  "no cookbook id is provided in path",
			desiredLength: 0,
			showError:     true,
		},
		"sender with no item": {
			path:    []string{sender2},
			desiredError:  "",
			desiredLength: 0,
			showError:     false,
		},
		"sender with 1 item": {
			path:    []string{sender},
			desiredError:  "",
			desiredLength: 1,
			showError:     false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			result, err := ItemsBySender(
				mockedCoinInput.Ctx,
				tc.path,
				abci.RequestQuery{
					Path: "",
					Data: []byte{},
				},
				mockedCoinInput.PlnK,
			)

			// t.Errorf("Querier.ItemsByCookbookTest LOG:: %+v", err)

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
