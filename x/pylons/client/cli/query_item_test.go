package cli_test

import (
	"fmt"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"strconv"
	"testing"

	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	"github.com/stretchr/testify/require"
	tmcli "github.com/tendermint/tendermint/libs/cli"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/testutil/network"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func networkWithItemObjects(t *testing.T, n int) (*network.Network, []*types.Item) {
	t.Helper()
	cfg := network.DefaultConfig()
	state := types.GenesisState{}
	require.NoError(t, cfg.Codec.UnmarshalJSON(cfg.GenesisState[types.ModuleName], &state))

	for i := 0; i < n; i++ {
		state.ItemList = append(state.ItemList,
			&types.Item{
				Owner:          "ANY",
				ID:             strconv.Itoa(i),
				CookbookID:     "testCookbookID",
				NodeVersion:    "0.0.1",
				Doubles:        make([]types.DoubleKeyValue, 0),
				Longs:          make([]types.LongKeyValue, 0),
				Strings:        make([]types.StringKeyValue, 0),
				MutableStrings: make([]types.StringKeyValue, 0),
				Tradeable:      false,
				LastUpdate:     0,
				TransferFee:    sdk.ZeroDec(),
			})
	}
	buf, err := cfg.Codec.MarshalJSON(&state)
	require.NoError(t, err)
	cfg.GenesisState[types.ModuleName] = buf
	return network.New(t, cfg), state.ItemList
}

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
		obj        *types.Item
	}{
		{
			desc:       "found",
			cookbookID: objs[0].CookbookID,
			id:         objs[0].ID,
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
