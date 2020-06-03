package queriers

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/require"

	abci "github.com/tendermint/tendermint/abci/types"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

func TestListRecipe(t *testing.T) {
	tci := keep.SetupTestCoinInput()

	sender := "cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337"
	senderAccAddress, _ := sdk.AccAddressFromBech32(sender)

	_, err := tci.Bk.AddCoins(tci.Ctx, senderAccAddress, types.NewPylon(1000000))
	require.True(t, err == nil)

	// mock cookbook
	cbData := handlers.MockCookbook(tci, senderAccAddress)

	handlers.MockPopularRecipe(handlers.RCP_5_BLOCK_DELAYED_5xWOODCOIN_TO_1xCHAIRCOIN, tci,
		"recipe0001", cbData.CookbookID, senderAccAddress)

	cases := map[string]struct {
		path          []string
		desiredError  string
		showError     bool
		desiredRcpCnt int
		firstItemName string
	}{
		"error check when providing invalid address": {
			path:          []string{"invalid_address"},
			showError:     true,
			desiredError:  "decoding bech32 failed: invalid index of 1",
			desiredRcpCnt: 0,
		},
		"error check when not providing address": {
			path:          []string{},
			showError:     true,
			desiredError:  "no address is provided in path",
			desiredRcpCnt: 0,
		},
		"list recipe successful check": {
			path:          []string{sender},
			showError:     false,
			desiredError:  "",
			desiredRcpCnt: 1,
			firstItemName: "recipe0001",
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			result, err := ListRecipe(
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
				rcpList := types.RecipeList{}
				rcpListErr := tci.PlnK.Cdc.UnmarshalJSON(result, &rcpList)

				require.True(t, rcpListErr == nil)
				require.True(t, len(rcpList.Recipes) == tc.desiredRcpCnt)
				require.True(t, rcpList.Recipes[0].Name == tc.firstItemName)
			}
		})
	}
}
