package queriers

import (
	"strings"
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/stretchr/testify/require"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestListExecution(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
	tci.PlnQ = NewQuerierServerImpl(tci.PlnK)

	sender1, _, _, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	err := tci.Bk.AddCoins(tci.Ctx, sender1, types.GenCoinInputList("wood", 100).ToCoins())
	require.NoError(t, err)

	// mock cookbook
	cbData := handlers.MockCookbook(tci, sender1)

	recipeResp := handlers.MockPopularRecipe(handlers.Rcp5BlockDelayed5xWoodcoinTo1xChaircoin, tci,
		"recipe0001", cbData.CookbookID, sender1)

	_, err = handlers.MockExecution(
		tci, recipeResp.RecipeID,
		sender1,
		[]string{},
	)
	require.True(t, err == nil, err)

	cases := map[string]struct {
		sender        string
		desiredError  string
		showError     bool
		desiredExcCnt int
	}{
		"error check when providing invalid address": {
			sender:        "invalid_address",
			showError:     true,
			desiredError:  "decoding bech32 failed: invalid index of 1",
			desiredExcCnt: 0,
		},
		"error check when not providing address": {
			sender:        "",
			showError:     true,
			desiredError:  "no address is provided in path",
			desiredExcCnt: 0,
		},
		"list recipe successful check": {
			sender:        sender1.String(),
			showError:     false,
			desiredError:  "",
			desiredExcCnt: 1,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			result, err := tci.PlnQ.ListExecutions(
				sdk.WrapSDKContext(tci.Ctx),
				&types.ListExecutionsRequest{
					Sender: tc.sender,
				},
			)
			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.NoError(t, err)
				require.Equal(t, len(result.Executions), tc.desiredExcCnt)
			}
		})
	}
}
