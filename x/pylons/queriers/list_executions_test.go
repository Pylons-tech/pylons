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

func TestListExecution(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	sender1, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(1000000))

	_, err := tci.Bk.AddCoins(tci.Ctx, sender1, types.GenCoinInputList("wood", 100).ToCoins())
	require.True(t, err == nil)

	// mock cookbook
	cbData := handlers.MockCookbook(tci, sender1)

	recipeResp := handlers.MockPopularRecipe(handlers.RCP_5_BLOCK_DELAYED_5xWOODCOIN_TO_1xCHAIRCOIN, tci,
		"recipe0001", cbData.CookbookID, sender1)

	_, err = handlers.MockExecution(
		tci, recipeResp.RecipeID,
		sender1,
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
			path:          []string{sender1.String()},
			showError:     false,
			desiredError:  "",
			desiredExcCnt: 1,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			result, err := ListExecutions(
				tci.Ctx,
				tc.path,
				abci.RequestQuery{
					Path: sender1.String(),
					Data: []byte{},
				},
				tci.PlnK,
			)
			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.True(t, err == nil)
				excList := types.ExecutionList{}
				excListErr := tci.PlnK.Cdc.UnmarshalJSON(result, &excList)

				require.True(t, excListErr == nil)
				require.True(t, len(excList.Executions) == tc.desiredExcCnt)
			}
		})
	}
}
