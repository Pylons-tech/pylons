package cli_test

import (
	"fmt"
	"testing"

	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	"github.com/stretchr/testify/require"
	tmcli "github.com/tendermint/tendermint/libs/cli"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestListRecipesByCookbook(t *testing.T) {
	net, objsPtr, _ := networkWithRecipeObjects(t, 2)
	objs := make([]types.Recipe, len(objsPtr))
	for i := range objsPtr {
		objs[i] = *objsPtr[i]
	}
	ctx := net.Validators[0].ClientCtx
	common := []string{
		fmt.Sprintf("--%s=json", tmcli.OutputFlag),
	}
	for _, tc := range []struct {
		desc       string
		cookbookID string
		recipeID   string
		args       []string
		err        error
		obj        []types.Recipe
	}{
		{
			desc:       "found",
			cookbookID: objs[0].CookbookID,
			recipeID:   objs[0].ID,
			args:       common,
			obj:        []types.Recipe{objs[0]},
		},
		{
			desc:       "not found",
			cookbookID: "not found",
			recipeID:   "not found",
			args:       common,
			obj:        []types.Recipe{},
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{tc.cookbookID}
			args = append(args, tc.args...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdListRecipesByCookbook(), args)
			if tc.err != nil {
				stat, ok := status.FromError(tc.err)
				require.True(t, ok)
				require.ErrorIs(t, stat.Err(), tc.err)
			} else {
				require.NoError(t, err)
				var resp types.QueryListRecipesByCookbookResponse
				require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.NotNil(t, resp.Recipes)
				require.Equal(t, tc.obj, resp.Recipes)
			}
		})
	}
}
