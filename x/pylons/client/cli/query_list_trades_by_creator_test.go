package cli_test

import (
	"testing"

	"github.com/cosmos/cosmos-sdk/client"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	util "github.com/Pylons-tech/pylons/testutil/cli"
	"github.com/Pylons-tech/pylons/testutil/network"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func createAccountInKeyring(ctx client.Context, t *testing.T, net *network.Network, n int) []sdk.AccAddress {
	acc := util.GenerateAddressesInKeyring(ctx.Keyring, 2)

	for i := 0; i < n; i++ {
		common := util.CommonArgs(acc[0].String(), net)
		args := []string{}
		args = append(args, "")
		args = append(args, "")
		args = append(args, common...)

		_, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateAccount(), args)
		require.NoError(t, err)
	}

	return acc
}

func TestCmdListTradesByCreator(t *testing.T) {
	net := network.New(t)
	ctx := net.Validators[0].ClientCtx

	types.UpdateAppCheckFlagTest(types.FlagTrue)

	acc := createAccountInKeyring(ctx, t, net, 1)

	common := util.CommonArgs(acc[0].String(), net)
	args := []string{}

	args = append(args, "[]")
	args = append(args, "[]")
	args = append(args, "[]")
	args = append(args, "[]")
	args = append(args, "extra info")
	args = append(args, common...)

	_, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateTrade(), args)
	require.NoError(t, err)

	for _, tc := range []struct {
		desc        string
		id          uint64
		creator     string
		err         error
		shouldFound bool
	}{
		{
			desc:        "Found",
			id:          0,
			creator:     acc[0].String(),
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
				var resp types.QueryListTradesByCreatorResponse
				require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.Equal(t, tc.id, resp.Trades[0].Id)
				require.NoError(t, err)
			} else {

			}
		})
	}
}
