package queriers

import (
	"encoding/json"
	"strings"
	"testing"

	"github.com/stretchr/testify/require"

	abci "github.com/tendermint/tendermint/abci/types"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

func TestQueriersItemsByCookbook(t *testing.T) {
	mockedCoinInput := keep.SetupTestCoinInput()

	sender := "cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337"
	senderAccAddress, _ := sdk.AccAddressFromBech32(sender)

	_, err := mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, senderAccAddress, types.NewPylon(1000000))
	require.True(t, err == nil)

	// mock cookbook
	cbData := handlers.MockCookbookByName(mockedCoinInput, senderAccAddress, "cookbook-00001")
	cbData1 := handlers.MockCookbookByName(mockedCoinInput, senderAccAddress, "cookbook-00002")

	item := keep.GenItem(cbData.CookbookID, senderAccAddress, "Raichu")
	err = mockedCoinInput.PlnK.SetItem(mockedCoinInput.Ctx, *item)
	require.True(t, err == nil)

	cases := map[string]struct {
		path          []string
		desiredError  string
		desiredLength int
		showError     bool
	}{
		"not existing cookbook id": {
			path:          []string{"invalidCookbookID"},
			desiredError:  "",
			desiredLength: 0,
			showError:     false,
		},
		"error check when not providing cookbookID": {
			path:          []string{},
			desiredError:  "no cookbook id is provided in path",
			desiredLength: 0,
			showError:     true,
		},
		"cookbook with no item": {
			path:          []string{cbData1.CookbookID},
			desiredError:  "",
			desiredLength: 0,
			showError:     false,
		},
		"cookbook with 1 item": {
			path:          []string{cbData.CookbookID},
			desiredError:  "",
			desiredLength: 1,
			showError:     false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			result, err := ItemsByCookbook(
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
