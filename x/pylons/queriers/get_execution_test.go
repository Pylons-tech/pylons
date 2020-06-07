package queriers

import (
	"encoding/json"
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	abci "github.com/tendermint/tendermint/abci/types"

	"github.com/stretchr/testify/require"
)

func TestGetExecution(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	sender1, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(1000000))

	// mock cookbook
	cbData := handlers.MockCookbook(tci, sender1)
	// mock recipe
	c2cRecipeData := handlers.MockPopularRecipe(handlers.Rcp5BlockDelayed5xWoodcoinTo1xChaircoin, tci,
		"GET_EXECUTION_TEST_RECIPE", cbData.CookbookID, sender1)

	execRcpResponse, err := handlers.MockExecution(tci, c2cRecipeData.RecipeID,
		sender1,
		[]string{}, // empty itemIDs
	)
	require.True(t, err == nil)
	require.True(t, execRcpResponse.Status == "Success")
	require.True(t, execRcpResponse.Message == "scheduled the recipe")

	scheduleOutput := handlers.ExecuteRecipeScheduleOutput{}
	err = json.Unmarshal(execRcpResponse.Output, &scheduleOutput)
	require.True(t, err == nil)

	cases := map[string]struct {
		path          []string
		desiredError  string
		showError     bool
		desiredRcpCnt int
		rcpID         string
	}{
		"error check when providing invalid execution ID": {
			path:          []string{"invalid executionID"},
			showError:     true,
			desiredError:  "The execution doesn't exist",
			desiredRcpCnt: 0,
		},
		"error check when not providing executionID": {
			path:          []string{},
			showError:     true,
			desiredError:  "no execution id is provided in path",
			desiredRcpCnt: 0,
		},
		"get execution successful check": {
			path:          []string{scheduleOutput.ExecID},
			showError:     false,
			desiredError:  "",
			desiredRcpCnt: 1,
			rcpID:         c2cRecipeData.RecipeID,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			result, err := GetExecution(
				tci.Ctx,
				tc.path,
				abci.RequestQuery{
					Path: "",
					Data: []byte{},
				},
				tci.PlnK,
			)
			// t.Errorf("GetExecutionTEST LOG:: %+v", err)
			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.True(t, err == nil)
				readExecution := types.Execution{}
				readExecutionErr := tci.PlnK.Cdc.UnmarshalJSON(result, &readExecution)

				require.True(t, readExecutionErr == nil)
				require.True(t, readExecution.RecipeID == tc.rcpID)
			}
		})
	}
}
