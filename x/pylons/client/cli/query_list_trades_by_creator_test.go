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

func TestListTradesByCreator(t *testing.T) {
	net, objs := networkWithTradeObjectsSingleOwner(t, 10)
	ctx := net.Validators[0].ClientCtx

	common := []string{
		fmt.Sprintf("--%s=json", tmcli.OutputFlag),
	}
	for _, tc := range []struct {
		desc    string
		ownerID string
		args    []string
		err     error
		trades  []types.Trade
	}{
		{
			desc:    "found1",
			ownerID: objs[0].Creator,
			args:    common,
			trades:  objs,
		},
		{
			desc:    "found2",
			ownerID: objs[0].Creator,
			args:    common,
			trades:  objs,
		},
		{
			desc:    "invalid",
			ownerID: "not_found",
			args:    common,
			err:     status.Error(codes.InvalidArgument, "invalid address"),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{tc.ownerID}
			args = append(args, tc.args...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdListTradesByCreator(), args)
			if tc.err != nil {
				stat, ok := status.FromError(tc.err)
				require.True(t, ok)
				require.ErrorIs(t, stat.Err(), tc.err)
			} else {
				require.NoError(t, err)
				var resp types.QueryListTradesByCreatorResponse
				require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
				// require.NotNil(t, resp.Items)
				require.Equal(t, tc.trades, resp.Trades)
			}
		})
	}
}
