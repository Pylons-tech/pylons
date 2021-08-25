package cli_test

import (
	"fmt"
	"google.golang.org/grpc/codes"
	"testing"

	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	"github.com/stretchr/testify/require"
	tmcli "github.com/tendermint/tendermint/libs/cli"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestListCookbooksByCreator(t *testing.T) {
	net, objs := networkWithCookbookObjects(t, 2)
	ctx := net.Validators[0].ClientCtx
	common := []string{
		fmt.Sprintf("--%s=json", tmcli.OutputFlag),
	}
	for _, tc := range []struct {
		desc string
		id   string
		args []string
		err  error
		obj  []types.Cookbook
	}{
		{
			desc: "found1",
			id:   objs[0].Creator,
			args: common,
			obj:  []types.Cookbook{objs[0]},
		},
		{
			desc: "found2",
			id:   objs[1].Creator,
			args: common,
			obj:  []types.Cookbook{objs[1]},
		},
		{
			desc: "not found",
			id:   types.GenTestBech32FromString("not_found"),
			args: common,
			obj:  []types.Cookbook{},
		},
		{
			desc: "invalid",
			id:   "not_found",
			args: common,
			err: status.Error(codes.InvalidArgument, "invalid address"),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{tc.id}
			args = append(args, tc.args...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdListCookbooksByCreator(), args)
			if tc.err != nil {
				stat, ok := status.FromError(tc.err)
				require.True(t, ok)
				require.ErrorIs(t, stat.Err(), tc.err)
			} else {
				require.NoError(t, err)
				var resp types.QueryListCookbooksByCreatorResponse
				require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.NotNil(t, resp.Cookbooks)
				require.Equal(t, tc.obj, resp.Cookbooks)
			}
		})
	}
}
