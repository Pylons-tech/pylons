package cli_test

import (
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	"github.com/stretchr/testify/require"
)

func TestCmdListItemByOwner(t *testing.T) {
	net, item := settingItemObject(t)
	ctx := net.Validators[0].ClientCtx

	for _, tc := range []struct {
		desc       string
		Owner      string
		CookbookId string
		Id         string
		shouldErr  bool
	}{
		{
			desc:       "Valid",
			Owner:      item.Owner,
			CookbookId: item.CookbookId,
			Id:         item.Id,
			shouldErr:  false,
		},
		{
			desc:       "Invalid - Owner",
			Owner:      "Invalid",
			CookbookId: item.CookbookId,
			Id:         item.Id,
			shouldErr:  true,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{}
			args = append(args, tc.Owner)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdListItemByOwner(), args)
			if tc.shouldErr {
				require.Error(t, err)
				var resp types.QueryListItemByOwnerResponse
				require.Error(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
			} else {
				require.NoError(t, err)
				var resp types.QueryListItemByOwnerResponse
				require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.NotNil(t, resp.Items)
				require.Equal(t, resp.Items[0].CookbookId, tc.CookbookId)
				require.Equal(t, resp.Items[0].Id, tc.Id)
			}
		})
	}
}
