package cli_test

import (
	"fmt"
	"testing"

	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	"github.com/stretchr/testify/require"
	tmcli "github.com/tendermint/tendermint/libs/cli"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestListExecutionsByItem(t *testing.T) {
	net, objs := networkWithExecutionObjects(t, 10)

	ctx := net.Validators[0].ClientCtx

	common := []string{
		fmt.Sprintf("--%s=json", tmcli.OutputFlag),
	}
	for _, tc := range []struct {
		desc         string
		id           string
		cookBookID   string
		args         []string
		err          error
		execs        []types.Execution
		pendingExecs []types.Execution
	}{
		{
			desc:         "found1",
			id:           objs[0].ItemOutputIds[0],
			cookBookID:   objs[0].CookbookId,
			args:         common,
			execs:        objs,
			pendingExecs: []types.Execution{},
		},
		{
			desc:         "found2",
			id:           objs[1].ItemOutputIds[0],
			cookBookID:   objs[1].CookbookId,
			args:         common,
			execs:        objs,
			pendingExecs: []types.Execution{},
		},
		{
			desc:         "not found",
			id:           types.GenTestBech32FromString("not_found"),
			cookBookID:   objs[0].CookbookId,
			args:         common,
			execs:        []types.Execution{},
			pendingExecs: []types.Execution{},
		},
		{
			desc: "invalid",
			id:   "not_found",

			args: common,
			err:  status.Error(codes.InvalidArgument, "invalid address"),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{tc.cookBookID, tc.id}
			args = append(args, tc.args...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdListExecutionsByItem(), args)
			if tc.err != nil {
				stat, ok := status.FromError(tc.err)
				require.True(t, ok)
				require.ErrorIs(t, stat.Err(), tc.err)
			} else {
				require.NoError(t, err)
				var resp types.QueryListExecutionsByItemResponse
				require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.NotNil(t, resp.CompletedExecutions)
				require.Equal(t, tc.execs, resp.CompletedExecutions)
			}
		})
	}
}
