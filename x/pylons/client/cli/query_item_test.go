package cli_test

import (
	"testing"

	"github.com/Pylons-tech/pylons/testutil/network"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	"github.com/stretchr/testify/require"
)

func settingItemObject(t *testing.T) (*network.Network, *types.Item) {
	t.Helper()
	cfg := network.DefaultConfig()
	state := types.GenesisState{}
	require.NoError(t, cfg.Codec.UnmarshalJSON(cfg.GenesisState[types.ModuleName], &state))
	address := types.GenTestBech32FromString("testAddress")
	item := types.Item{
		Owner:      address,
		CookbookId: "testCookbookId",
		Id:         "testId",
	}
	state.ItemList = append(state.ItemList, item)

	buffer, err := cfg.Codec.MarshalJSON(&state)
	require.NoError(t, err)
	cfg.GenesisState[types.ModuleName] = buffer
	return network.New(t, cfg), &item
}

func TestCmdShowItem(t *testing.T) {
	net, item := settingItemObject(t)
	ctx := net.Validators[0].ClientCtx

	for _, tc := range []struct {
		desc       string
		CookbookId string
		Id         string
		shouldErr  bool
	}{
		{
			desc:       "Valid",
			CookbookId: item.CookbookId,
			Id:         item.Id,
			shouldErr:  false,
		},
		{
			desc:       "Invalid - CookbookId",
			CookbookId: "Invalid",
			Id:         item.Id,
			shouldErr:  true,
		},
		{
			desc:       "Invalid - Id",
			CookbookId: item.CookbookId,
			Id:         "Invalid",
			shouldErr:  true,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{}
			args = append(args, tc.CookbookId, tc.Id)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdShowItem(), args)
			if tc.shouldErr {
				require.Error(t, err)
				var resp types.QueryGetItemResponse
				require.Error(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
			} else {
				require.NoError(t, err)
				var resp types.QueryGetItemResponse
				require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.NotNil(t, resp.Item)
				require.Equal(t, resp.Item.CookbookId, tc.CookbookId)
				require.Equal(t, resp.Item.Id, tc.Id)
			}
		})
	}
}
