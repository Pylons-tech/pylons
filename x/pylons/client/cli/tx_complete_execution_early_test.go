package cli_test

import (
	"encoding/json"
	"strconv"
	"testing"
	"time"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/cosmos/cosmos-sdk/testutil/network"

	"github.com/Pylons-tech/pylons/x/pylons/types"

	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	"github.com/stretchr/testify/require"

	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
)

func TestCmdCompleteExecutionEarly(t *testing.T) {
	net := network.New(t)

	val := net.Validators[0]
	ctx := val.ClientCtx

	address, err := GenerateAddressWithAccount(ctx, t, net)
	require.NoError(t, err)
	var resp sdk.TxResponse

	cookbookID := "testCookbookID"
	recipeID := "testRecipeID"

	// Create a cookbook

	cbFields := []string{
		"testCookbookName",
		"DescriptionDescriptionDescription",
		"testDeveloper",
		"v0.0.1",
		"test@email.com",
		"true",
	}

	// Common arguments
	common := CommonArgs(val.Address.String(), net)
	args := []string{cookbookID}
	args = append(args, cbFields...)
	args = append(args, common...)
	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateCookbook(), args)
	require.NoError(t, err)

	coinInputsJson, _ := json.Marshal([]types.CoinInput{
		{
			Coins: sdk.NewCoins(sdk.NewCoin("node0token", sdk.NewInt(1))),
		},
		{
			Coins: sdk.NewCoins(sdk.NewCoin("node0token", sdk.NewInt(1))),
		},
	},
	)

	// Create a recipe
	recipeFields := []string{
		"testRecipeName",
		"DescriptionDescriptionDescriptionDescription",
		"v0.0.1",
		string(coinInputsJson),
		"[]",
		"{}",
		"[]",
		"100",
		"{\"denom\": \"node0token\", \"amount\": \"1\"}",
		"true",
		"extraInfo",
	}
	args = []string{cookbookID, recipeID}
	args = append(args, recipeFields...)
	args = append(args, common...)
	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateRecipe(), args)

	require.NoError(t, err)

	// create execution
	common = CommonArgs(address, net)
	args = []string{cookbookID, recipeID, "1", "[]", "[]"} // empty list for item-ids since there is no item input
	args = append(args, common...)
	out, err2 := clitestutil.ExecTestCLICmd(ctx, cli.CmdExecuteRecipe(), args)
	require.NoError(t, err2)
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
	require.Equal(t, uint32(0), resp.Code, resp.RawLog)

	var executionsResponse types.QueryListExecutionsByRecipeResponse
	args = []string{cookbookID, recipeID, "--output=json"}
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdListExecutionsByRecipe(), args)
	require.NoError(t, err)
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &executionsResponse))
	require.NotEmpty(t, executionsResponse.PendingExecutions)

	testedExecution := executionsResponse.PendingExecutions[0]

	t.Run("Test Complete Execution Early, existing cookbook", func(t *testing.T) {
		testedExecutionId := testedExecution.Id
		args = []string{testedExecutionId}
		args = append(args, common...)

		out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCompleteExecutionEarly(), args)
		require.NoError(t, err)

		// simulate a wait
		height, err := net.LatestHeight()
		targetHeight := height + 1
		// build execID from the execution height
		completedExecID := strconv.Itoa(int(height+0)) + "-" + strconv.Itoa(0)
		require.NoError(t, err)
		_, err = net.WaitForHeightWithTimeout(targetHeight, 60*time.Second)
		require.NoError(t, err)

		var resp sdk.TxResponse
		require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
		require.Equal(t, uint32(0), resp.Code)

		// Check whether the execution has the completed state or not
		var executionsResponse types.QueryGetExecutionResponse
		args = []string{completedExecID, "--output=json"}
		out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdShowExecution(), args)

		require.NoError(t, err)
		require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &executionsResponse))
		require.True(t, executionsResponse.Completed)
	})
}
