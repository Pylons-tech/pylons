package queriers

import (
	"encoding/json"
	"strings"
	"testing"

	"github.com/stretchr/testify/require"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestGetExecution(t *testing.T) {
	tci := keeper.SetupTestCoinInput()
	tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
	tci.PlnQ = NewQuerierServerImpl(tci.PlnK)

	sender1, _, _, _ := keeper.SetupTestAccounts(t, tci, sdk.Coins{
		sdk.NewInt64Coin(types.Pylon, 1000000),
		sdk.NewInt64Coin("wood", 1000000),
	}, nil, nil, nil)
	// mock cookbook
	cbData := handlers.MockCookbook(tci, sender1)
	// mock recipe
	c2cRecipeData := handlers.MockPopularRecipe(handlers.Rcp5BlockDelayed5xWoodcoinTo1xChaircoin, tci,
		"GET_EXECUTION_TEST_RECIPE", cbData.CookbookID, sender1, "pi_1DoShv2eZvKYlo2CqsROyFun", "card")
	execRcpResponse, err := handlers.MockExecution(tci, c2cRecipeData.RecipeID,
		sender1, "pi_1DoShv2eZvKYlo2CqsROyFun", "pm_card_visa",
		[]string{}, // empty itemIDs
	)
	require.True(t, err == nil, err)
	require.True(t, execRcpResponse.Status == "Success")
	require.True(t, execRcpResponse.Message == "scheduled the recipe")

	scheduleOutput := types.ExecuteRecipeScheduleOutput{}
	err = json.Unmarshal(execRcpResponse.Output, &scheduleOutput)
	require.NoError(t, err)

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
				require.NoError(t, err)
				require.Equal(t, result.RecipeID, tc.rcpID)
			}
		})
	}
}

func TestListExecution(t *testing.T) {
	tci := keeper.SetupTestCoinInput()
	tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
	tci.PlnQ = NewQuerierServerImpl(tci.PlnK)

	sender1, _, _, _ := keeper.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	err := tci.Bk.AddCoins(tci.Ctx, sender1, types.GenCoinInputList("wood", 100).ToCoins())
	require.NoError(t, err)

	// mock cookbook
	cbData := handlers.MockCookbook(tci, sender1)

	recipeResp := handlers.MockPopularRecipe(handlers.Rcp5BlockDelayed5xWoodcoinTo1xChaircoin, tci,
		"recipe0001", cbData.CookbookID, sender1, "pi_1DoShv2eZvKYlo2CqsROyFun", "pm_card_visa")

	_, err = handlers.MockExecution(
		tci, recipeResp.RecipeID,
		sender1, "pi_1DoShv2eZvKYlo2CqsROyFun", "pm_card_visa",
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
