package cli_test

import (
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	"github.com/stretchr/testify/require"
)

func TestCmdListExecutionsByRecipe(t *testing.T) {
	net, execution, pendingExecution := settingExecutionObject(t)
	_ = pendingExecution
	ctx := net.Validators[0].ClientCtx

	for _, tc := range []struct {
		desc      string
		execution *types.Execution
		completed bool
		shouldErr bool
	}{
		{
			desc:      "Valid - Execution",
			execution: execution,
			completed: true,
			shouldErr: false,
		},
		{
			desc:      "Valid - PendingExecution",
			execution: pendingExecution,
			completed: false,
			shouldErr: false,
		},
		{
			desc: "Invalid - CookbookId",
			execution: &types.Execution{
				CookbookId: "Invalid",
				Id:         "1",
			},
			completed: false,
			shouldErr: true,
		},
		{
			desc: "Invalid - RecipeId",
			execution: &types.Execution{
				RecipeId: "Invalid",
				Id:       "1",
			},
			completed: false,
			shouldErr: true,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{}
			args = append(args, tc.execution.CookbookId, tc.execution.RecipeId)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdListExecutionsByRecipe(), args)
			if tc.shouldErr {
				var resp types.QueryListExecutionsByRecipeResponse
				require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.Equal(t, len(resp.CompletedExecutions), 0)
				require.Equal(t, len(resp.PendingExecutions), 0)
			} else {
				require.NoError(t, err)
				var resp types.QueryListExecutionsByRecipeResponse
				require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
				if tc.completed {
					require.NotNil(t, resp.CompletedExecutions[0])
					require.Equal(t, resp.CompletedExecutions[0].CookbookId, tc.execution.CookbookId)
					require.Equal(t, resp.CompletedExecutions[0].Id, tc.execution.Id)
				} else {
					require.NotNil(t, resp.PendingExecutions[0])
					require.Equal(t, resp.PendingExecutions[0].CookbookId, tc.execution.CookbookId)
					require.Equal(t, resp.PendingExecutions[0].Id, tc.execution.Id)
				}
			}
		})
	}
}
