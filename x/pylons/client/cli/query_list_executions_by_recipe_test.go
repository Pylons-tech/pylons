package cli_test

import (
	"fmt"
	"reflect"
	"testing"

	"google.golang.org/grpc/codes"

	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	"github.com/stretchr/testify/require"
	tmcli "github.com/tendermint/tendermint/libs/cli"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestCmdListExecutionsByRecipe(t *testing.T) {
	net, executions := networkWithExecutionObjects(t, 2)
	t.Cleanup(net.Cleanup)
	ctx := net.Validators[0].ClientCtx
	common := []string{
		fmt.Sprintf("--%s=json", tmcli.OutputFlag),
	}
	for _, tc := range []struct {
		desc       string
		recipeId   string
		cookbookId string
		args       []string
		err        error
		obj        types.QueryListExecutionsByRecipeResponse
	}{
		{
			desc:     "found1",
			recipeId: executions[0].RecipeId,
			args:     common,
			obj:      types.QueryListExecutionsByRecipeResponse{},
		},
		{
			desc:       "found2",
			recipeId:   executions[1].Id,
			cookbookId: executions[1].CookbookId,
			args:       common,
			obj:        types.QueryListExecutionsByRecipeResponse{},
		},
		{
			desc:       "not found",
			recipeId:   types.GenTestBech32FromString("not_found"),
			cookbookId: types.GenTestBech32FromString("not_found"),
			args:       common,
			obj:        types.QueryListExecutionsByRecipeResponse{},
		},
		{
			desc:       "invalid",
			recipeId:   "not_found",
			cookbookId: "not_found",
			args:       common,
			err:        status.Error(codes.InvalidArgument, "invalid address"),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{tc.cookbookId, tc.recipeId}
			args = append(args, tc.args...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdListExecutionsByRecipe(), args)
			if tc.err != nil {
				stat, ok := status.FromError(tc.err)
				require.True(t, ok)
				require.ErrorIs(t, stat.Err(), tc.err)
			} else {
				require.NoError(t, err)
				var resp types.QueryListExecutionsByRecipeResponse
				error := net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp)
				require.NoError(t, error)
				require.NotNil(t, resp)
				require.Equal(t, reflect.ValueOf(resp).Kind(), reflect.ValueOf(tc.obj).Kind())
			}
		})
	}
}
