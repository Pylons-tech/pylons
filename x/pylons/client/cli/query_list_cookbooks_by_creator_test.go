package cli_test

import (
	"testing"

	"github.com/Pylons-tech/pylons/testutil/network"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	"github.com/stretchr/testify/require"
)

func settingCookbookObject(t *testing.T) (*network.Network, *types.Cookbook) {
	t.Helper()
	cfg := network.DefaultConfig()
	state := types.GenesisState{}
	require.NoError(t, cfg.Codec.UnmarshalJSON(cfg.GenesisState[types.ModuleName], &state))
	accountAddr := types.GenTestBech32FromString("testCookbook")
	cookbook := types.Cookbook{
		Creator: accountAddr,
		Id:      "testCookbook",
	}
	state.CookbookList = append(state.CookbookList, cookbook)

	buffer, err := cfg.Codec.MarshalJSON(&state)
	require.NoError(t, err)
	cfg.GenesisState[types.ModuleName] = buffer
	return network.New(t, cfg), &cookbook
}

func TestCmdListCookbooksByCreator(t *testing.T) {
	net, cookbook := settingCookbookObject(t)
	ctx := net.Validators[0].ClientCtx

	for _, tc := range []struct {
		desc      string
		Creator   string
		Id        string
		shouldErr bool
	}{
		{
			desc:      "Valid",
			Creator:   cookbook.Creator,
			Id:        cookbook.Id,
			shouldErr: false,
		},
		{
			desc:      "Invalid - Creator",
			Creator:   "Invalid",
			Id:        cookbook.Id,
			shouldErr: true,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{}
			args = append(args, tc.Creator)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdListCookbooksByCreator(), args)
			if tc.shouldErr {
				require.Error(t, err)
				var resp types.QueryListCookbooksByCreatorResponse
				require.Error(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
			} else {
				require.NoError(t, err)
				var resp types.QueryListCookbooksByCreatorResponse
				require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.NotNil(t, resp.Cookbooks)
				require.Equal(t, resp.Cookbooks[0].Id, tc.Id)
			}
		})
	}
}
