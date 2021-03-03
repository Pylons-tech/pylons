package queriers

import (
	"encoding/json"
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestGetExecution(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
	tci.PlnQ = NewQuerierServerImpl(tci.PlnK)

	sender1, _, _, _ := keep.SetupTestAccounts(t, tci, sdk.Coins{
		sdk.NewInt64Coin(types.Pylon, 1000000),
		sdk.NewInt64Coin("wood", 1000000),
	}, nil, nil, nil)
	// mock cookbook
	cbData := handlers.MockCookbook(tci, sender1)
	// mock recipe
	c2cRecipeData := handlers.MockPopularRecipe(handlers.Rcp5BlockDelayed5xWoodcoinTo1xChaircoin, tci,
		"GET_EXECUTION_TEST_RECIPE", cbData.CookbookID, sender1)

	execRcpResponse, err := handlers.MockExecution(tci, c2cRecipeData.RecipeID,
		sender1,
		[]string{}, // empty itemIDs
	)
	require.True(t, err == nil, err)
	require.True(t, execRcpResponse.Status == "Success")
	require.True(t, execRcpResponse.Message == "scheduled the recipe")

	scheduleOutput := handlers.ExecuteRecipeScheduleOutput{}
	err = json.Unmarshal(execRcpResponse.Output, &scheduleOutput)
	require.True(t, err == nil)

	cases := map[string]struct {
		execID        string
		desiredError  string
		showError     bool
		desiredRcpCnt int
		rcpID         string
	}{
		"error check when providing invalid execution ID": {
			execID:        "invalid executionID",
			showError:     true,
			desiredError:  "The execution doesn't exist",
			desiredRcpCnt: 0,
		},
		"error check when not providing executionID": {
			execID:        "",
			showError:     true,
			desiredError:  "no execution id is provided in path",
			desiredRcpCnt: 0,
		},
		"get execution successful check": {
			execID:        scheduleOutput.ExecID,
			showError:     false,
			desiredError:  "",
			desiredRcpCnt: 1,
			rcpID:         c2cRecipeData.RecipeID,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			result, err := tci.PlnQ.GetExecution(
				sdk.WrapSDKContext(tci.Ctx),
				&types.GetExecutionRequest{
					ExecutionID: tc.execID,
				},
			)
			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.True(t, err == nil)
				require.True(t, result.RecipeID == tc.rcpID)
			}
		})
	}
}
