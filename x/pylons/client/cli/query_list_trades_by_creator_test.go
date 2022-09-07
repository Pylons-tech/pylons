package cli_test

import (
	"testing"

	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	"github.com/stretchr/testify/require"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	util "github.com/Pylons-tech/pylons/testutil/cli"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestCmdListTradesByCreator(t *testing.T) {
	net, tradeList := util.NetworkWithTradeObjects(t, 2)
	ctx := net.Validators[0].ClientCtx

	for _, tc := range []struct {
		desc        string
		id          uint64
		creator     string
		err         error
		shouldFound bool
	}{
		{
			desc:        "Found",
			id:          tradeList[0].Id,
			creator:     tradeList[0].Creator,
			shouldFound: true,
			err:         nil,
		},
		{
			desc:        "Not Found",
			creator:     types.GenTestBech32FromString("NotFound"),
			shouldFound: false,
			err:         nil,
		},
		{
			desc:    "Invalid creator",
			creator: "Invalid",
			err:     status.Error(codes.InvalidArgument, "invalid address"),
		},
	} {
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{}
			args = append(args, tc.creator)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdListTradesByCreator(), args)
			if tc.err != nil {
				stat, ok := status.FromError(tc.err)
				require.True(t, ok)
				require.ErrorIs(t, stat.Err(), tc.err)
			} else if tc.shouldFound {
				require.NoError(t, err)
				var resp types.QueryListTradesByCreatorResponse
				require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.Equal(t, tc.id, resp.Trades[0].Id)
			} else {

			}
		})
	}
}
