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

func TestShowCookbook(t *testing.T) {
	net, cookbook := util.NetworkWithCookbookObjects(t, 2)
	ctx := net.Validators[0].ClientCtx

	common := []string{
		fmt.Sprintf("--%s=json", tmcli.OutputFlag),
	}
	for _, tc := range []struct {
		desc       string
		cookbookId string
		args       []string
		err        error
		obj        types.Cookbook
	}{
		{
			desc:       "Found",
			cookbookId: cookbook[0].Id,
			args:       common,
			obj:        cookbook[0],
		},
		{
			desc:       "Not found",
			cookbookId: "Not found",
			args:       common,
			err:        status.Error(codes.InvalidArgument, "not found"),
		},
	} {
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{tc.cookbookId}
			args = append(args, tc.args...)

			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdShowCookbook(), args)
			if tc.err != nil {
				stat, ok := status.FromError(tc.err)
				require.True(t, ok)
				require.ErrorIs(t, stat.Err(), tc.err)
			} else {
				require.NoError(t, err)
				var resp types.QueryGetCookbookResponse
				require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.Equal(t, tc.obj.Id, resp.Cookbook.Id)

			}
		})
	}
}
