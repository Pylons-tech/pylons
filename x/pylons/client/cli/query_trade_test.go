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

func TestShowTrade(t *testing.T) {
	net, objs := networkWithTradeObjects(t, 2)
	t.Cleanup(net.Cleanup)
	ctx := net.Validators[0].ClientCtx
	common := []string{
		fmt.Sprintf("--%s=json", tmcli.OutputFlag),
	}
	for _, tc := range []struct {
		desc string
		id   string
		args []string
		err  error
		obj  types.Trade
	}{
		{
			desc: "found1",
			id:   fmt.Sprintf("%d", objs[0].ID),
			args: common,
			obj:  objs[0],
		},
		{
			desc: "found2",
			id:   fmt.Sprintf("%d", objs[1].ID),
			args: common,
			obj:  objs[1],
		},
		{
			desc: "not found",
			id:   fmt.Sprintf("%d", objs[1].ID+1),
			args: common,
			err:  status.Error(codes.InvalidArgument, "not found"),
		},
		{
			desc: "invalid ID",
			id:   "not_found",
			args: common,
			err:  status.Error(codes.InvalidArgument, "not found"),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{tc.id}
			args = append(args, tc.args...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdShowTrade(), args)
			if tc.err != nil {
				stat, ok := status.FromError(tc.err)
				require.True(t, ok)
				require.ErrorIs(t, stat.Err(), tc.err)
			} else {
				require.NoError(t, err)
				var resp types.QueryGetTradeResponse
				require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.NotNil(t, resp.Trade)
				require.Equal(t, tc.obj, resp.Trade)
			}
		})
	}
}
