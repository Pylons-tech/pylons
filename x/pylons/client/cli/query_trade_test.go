package cli_test

import (
	"fmt"
	"testing"

	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	"github.com/stretchr/testify/require"
	tmcli "github.com/tendermint/tendermint/libs/cli"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	util "github.com/Pylons-tech/pylons/testutil/cli"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestShowTrade(t *testing.T) {
	net, tradeList := util.NetworkWithTradeObjects(t, 2)
	ctx := net.Validators[0].ClientCtx
	common := []string{
		fmt.Sprintf("--%s=json", tmcli.OutputFlag),
	}
	for _, tc := range []struct {
		desc string
		id   uint64
		args []string
		err  error
		obj  types.Trade
	}{
		{
			desc: "Found",
			id:   tradeList[0].Id,
			args: common,
			obj:  tradeList[0],
		},
		{
			desc: "Not Found",
			id:   10,
			args: common,
			err:  status.Error(codes.InvalidArgument, "not found"),
		},
	} {
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{fmt.Sprint(tc.id)}
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
				require.Equal(t, tc.obj, resp.Trade)
			}
		})
	}
}
