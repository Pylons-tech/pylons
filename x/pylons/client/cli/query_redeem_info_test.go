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

func TestListRedeemInfo(t *testing.T) {
	net, redeemInfos := util.NetworkWithRedeemInfoObjects(t, 2)
	ctx := net.Validators[0].ClientCtx
	common := []string{
		fmt.Sprintf("--%s=json", tmcli.OutputFlag),
	}
	for _, tc := range []struct {
		desc    string
		address string
		id      string
		args    []string
		err     error
		obj     types.RedeemInfo
	}{
		{
			desc:    "Found",
			address: redeemInfos[0].Address,
			id:      redeemInfos[0].Id,
			args:    common,
			obj:     redeemInfos[0],
		},
		{
			desc:    "Not Found",
			address: "Not Found",
			id:      "Not Found",
			args:    common,
			err:     status.Error(codes.InvalidArgument, "not found"),
		},
	} {
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{tc.address, tc.id}
			args = append(args, tc.args...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdListRedeemInfo(), args)
			if tc.err != nil {
				stat, ok := status.FromError(tc.err)
				require.True(t, ok)
				require.ErrorIs(t, stat.Err(), tc.err)
			} else {
				require.NoError(t, err)
				var resp types.QueryAllRedeemInfoResponse
				require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.NotNil(t, resp.RedeemInfo[0])
				require.Equal(t, tc.obj, resp.RedeemInfo[0])
			}
		})
	}
}
