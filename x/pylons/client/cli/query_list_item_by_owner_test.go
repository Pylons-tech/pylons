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

func TestListItemByOwner(t *testing.T) {
	net, objs := networkWithItemObjectsSingleOwner(t, 10)

	ctx := net.Validators[0].ClientCtx

	common := []string{
		fmt.Sprintf("--%s=json", tmcli.OutputFlag),
	}
	for _, tc := range []struct {
		desc    string
		ownerID string
		args    []string
		err     error
		items   []types.Item
	}{
		{
			desc:    "found1",
			ownerID: objs[0].Owner,
			args:    common,
			items:   objs,
		},
		{
			desc:    "found2",
			ownerID: objs[0].Owner,
			args:    common,
			items:   objs,
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
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdListItemByOwner(), args)
			if tc.err != nil {
				stat, ok := status.FromError(tc.err)
				require.True(t, ok)
				require.ErrorIs(t, stat.Err(), tc.err)
			} else {
				require.NoError(t, err)
				var resp types.QueryListItemByOwnerResponse
				require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
				// require.NotNil(t, resp.Items)
				require.Equal(t, tc.items, resp.Items)
			}
		})
	}
}
