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

func TestShowItem(t *testing.T) {
	net, objs := networkWithItemObjects(t, 2)

	ctx := net.Validators[0].ClientCtx
	common := []string{
		fmt.Sprintf("--%s=json", tmcli.OutputFlag),
	}
	for _, tc := range []struct {
		desc       string
		cookbookID string
		id         string
		args       []string
		err        error
		obj        types.Item
	}{
		{
			desc:       "found",
			cookbookID: objs[0].CookbookId,
			id:         objs[0].Id,
			args:       common,
			obj:        objs[0],
		},
		{
			desc:       "not found",
			cookbookID: "not_found",
			id:         "not_found",
			args:       common,
			err:        status.Error(codes.InvalidArgument, "not found"),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{tc.cookbookID, tc.id}
			args = append(args, tc.args...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdShowItem(), args)
			if tc.err != nil {
				stat, ok := status.FromError(tc.err)
				require.True(t, ok)
				require.ErrorIs(t, stat.Err(), tc.err)
			} else {
				require.NoError(t, err)
				var resp types.QueryGetItemResponse
				require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.NotNil(t, resp.Item)
				require.Equal(t, tc.obj, resp.Item)
			}
		})
	}
}
