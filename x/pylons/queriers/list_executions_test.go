package queriers

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/require"

	abci "github.com/tendermint/tendermint/abci/types"

	"github.com/MikeSofaer/pylons/x/pylons/handlers"
	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

func TestListExecution(t *testing.T) {
	mockedCoinInput := keep.SetupTestCoinInput()

	sender := "cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337"
	senderAccAddress, _ := sdk.AccAddressFromBech32(sender)

	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, senderAccAddress, types.PremiumTier.Fee)
	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, senderAccAddress, types.GenCoinInputList("wood", 100).ToCoins())
	// mock cookbook
	cbData := handlers.MockCookbook(mockedCoinInput, senderAccAddress)

	recipeResp := handlers.MockRecipe(
		mockedCoinInput, "recipe0001",
		types.GenCoinInputList("wood", 5),
		types.ItemInputList{},
		types.GenEntries("chair", "Raichu"),
		cbData.CookbookID,
		5,
		senderAccAddress,
	)

	_, err := handlers.MockExecution(
		mockedCoinInput, recipeResp.RecipeID,
		senderAccAddress,
		[]string{},
	)
	require.True(t, err == nil)

	cases := map[string]struct {
		path          []string
		desiredError  string
		showError     bool
		desiredExcCnt int
	}{
		"error check when providing invalid address": {
			path:          []string{"invalid_address"},
			showError:     true,
			desiredError:  "decoding bech32 failed: invalid index of 1",
			desiredExcCnt: 0,
		},
		"error check when not providing address": {
			path:          []string{},
			showError:     true,
			desiredError:  "no address is provided in path",
			desiredExcCnt: 0,
		},
		"list recipe successful check": {
			path:          []string{sender},
			showError:     false,
			desiredError:  "",
			desiredExcCnt: 1,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			result, err := ListExecutions(
				mockedCoinInput.Ctx,
				tc.path,
				abci.RequestQuery{
					Path: sender,
					Data: []byte{},
				},
				mockedCoinInput.PlnK,
			)
			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.True(t, err == nil)
				excList := types.ExecutionList{}
				excListErr := mockedCoinInput.PlnK.Cdc.UnmarshalJSON(result, &excList)

				require.True(t, excListErr == nil)
				require.True(t, len(excList.Executions) == tc.desiredExcCnt)
			}
		})
	}
}
