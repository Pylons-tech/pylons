package cli_test

import (
	"encoding/json"
	"fmt"
	"github.com/Pylons-tech/pylons/testutil/network"
	"github.com/cosmos/cosmos-sdk/client/flags"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"strconv"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/types"

	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	"github.com/stretchr/testify/require"

	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
)

func TestCmdCompleteExecutionEarly(t *testing.T) {

	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx
	cookbookID := "testCookbookID"
	recipeID := "testRecipeID"

	// Create a cookbook

	cbFields := []string{
		"testCookbookName",
		"DescriptionDescriptionDescription",
		"testDeveloper",
		"v0.0.1",
		"test@email.com",
		"{\"denom\": \"node0token\", \"amount\": \"1\"}",
		"true",
	}

	//Common arguments
	common := []string{
		fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
		fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
		fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
		fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
	}
	args := []string{cookbookID}
	args = append(args, cbFields...)
	args = append(args, common...)
	_, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateCookbook(), args)
	require.NoError(t, err)


	coinInputsJson, _ := json.Marshal([] types.CoinInput{
		types.CoinInput{
			Coins: sdk.NewCoins(sdk.NewCoin(sdk.DefaultBondDenom, sdk.NewInt(1))),
		},
		types.CoinInput{
			Coins: sdk.NewCoins(sdk.NewCoin(sdk.DefaultBondDenom, sdk.NewInt(1))),
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
		"true",
		"extraInfo",
	}
	args = []string{cookbookID, recipeID}
	args = append(args, recipeFields...)
	args = append(args, common...)
	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateRecipe(), args)

	require.NoError(t, err)

	// create execution
	args = []string{cookbookID, recipeID,"1", "[]"} // empty list for item-ids since there is no item input
	args = append(args, common...)
	out, err2 := clitestutil.ExecTestCLICmd(ctx, cli.CmdExecuteRecipe(), args)
	require.NoError(t, err2)
	var resp sdk.TxResponse
	require.NoError(t, ctx.JSONMarshaler.UnmarshalJSON(out.Bytes(), &resp))
	require.Equal(t, uint32(0), resp.Code)

	var executionsResponse types.QueryListExecutionsByRecipeResponse
	args = []string{cookbookID, recipeID, "--output=json"} // empty list for item-ids since there is no item input
	out,err = clitestutil.ExecTestCLICmd(ctx,cli.CmdListExecutionsByRecipe(),args)
	require.NoError(t, err)
	require.NoError(t, ctx.JSONMarshaler.UnmarshalJSON(out.Bytes(), &executionsResponse))
	require.NotEmpty(t, executionsResponse.PendingExecutions)

	var testedExecution = executionsResponse.PendingExecutions[0]

	t.Run("Test Complete Execution Early, existing cookbook", func(t *testing.T) {

		testedExecutionId := testedExecution.ID
		args = []string{testedExecutionId}
		args = append(args,common...)
		out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCompleteExecutionEarly(), args)
		require.NoError(t, err)
		height, _:= net.LatestHeight()
		execID := strconv.Itoa(int(height)) + "-" + "0"
		var resp sdk.TxResponse
		require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
		require.Equal(t, uint32(0), resp.Code)

		// Check whether the execution has the completed state or not
		var executionsResponse types.QueryGetExecutionResponse
		args = []string{execID, "--output=json"} // empty list for item-ids since there is no item input
		out,err = clitestutil.ExecTestCLICmd(ctx,cli.CmdShowExecution(),args)
		require.NoError(t, err)
		require.NoError(t, ctx.JSONMarshaler.UnmarshalJSON(out.Bytes(), &executionsResponse))
		require.True(t, executionsResponse.Completed)

	})

}
