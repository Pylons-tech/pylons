package cli_test

import (
	"testing"

	"github.com/Pylons-tech/pylons/testutil/network"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	"github.com/stretchr/testify/require"
)

func settingExecutionObject(t *testing.T) (*network.Network, *types.Execution, *types.Execution) {
	t.Helper()
	cfg := network.DefaultConfig()
	state := types.GenesisState{}
	require.NoError(t, cfg.Codec.UnmarshalJSON(cfg.GenesisState[types.ModuleName], &state))

	execution := types.Execution{
		CookbookId: "testCookbookId",
		RecipeId:   "testRecipeId",
		Id:         "1",
	}
	state.ExecutionList = append(state.ExecutionList, execution)
	state.ExecutionCount = 1

	pendingExecution := types.Execution{
		CookbookId: "testCookbookId",
		RecipeId:   "testRecipeId",
		Id:         "2",
	}
	state.PendingExecutionList = append(state.PendingExecutionList, pendingExecution)
	state.PendingExecutionCount = 1

	buffer, err := cfg.Codec.MarshalJSON(&state)
	require.NoError(t, err)
	cfg.GenesisState[types.ModuleName] = buffer
	return network.New(t, cfg), &execution, &pendingExecution
}

func TestCmdShowExecution(t *testing.T) {
	net, execution, pendingExecution := settingExecutionObject(t)
	ctx := net.Validators[0].ClientCtx

	for _, tc := range []struct {
		desc        string
		executionId string
		completed   bool
		shouldErr   bool
	}{
		{
			desc:        "Valid - execution",
			executionId: execution.Id,
			completed:   true,
			shouldErr:   false,
		},
		{
			desc:        "Valid - pendingExecution",
			executionId: pendingExecution.Id,
			completed:   false,
			shouldErr:   false,
		},
		{
			desc:        "Invalid - executionId Invalid",
			executionId: "Invalid",
			shouldErr:   true,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{tc.executionId}
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdShowExecution(), args)
			if tc.shouldErr {
				require.Error(t, err)
				var resp types.QueryGetExecutionResponse
				require.Error(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.NotNil(t, resp.Execution)
			} else {
				require.NoError(t, err)
				var resp types.QueryGetExecutionResponse
				require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.NotNil(t, resp.Execution)
				require.Equal(t, resp.Execution.Id, tc.executionId)
				require.Equal(t, resp.Completed, tc.completed)
			}
		})
	}
}
