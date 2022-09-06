package cli_test

import (
	"testing"

	"github.com/Pylons-tech/pylons/testutil/network"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func settingListTradesByCreatorObject(t *testing.T, n int) (*network.Network, []types.Trade, string) {
	t.Helper()
	cfg := network.DefaultConfig()
	state := types.GenesisState{}
	require.NoError(t, cfg.Codec.UnmarshalJSON(cfg.GenesisState[types.ModuleName], &state))

	addresses := types.GenTestBech32List(1)
	for i := 0; i < n; i++ {
		state.TradeList = append(state.TradeList, types.Trade{
			Creator:          addresses[0],
			Id:               uint64(i),
			CoinInputs:       []types.CoinInput{{Coins: sdk.NewCoins()}},
			ItemInputs:       make([]types.ItemInput, 0),
			CoinOutputs:      sdk.NewCoins(),
			ItemOutputs:      make([]types.ItemRef, 0),
			ExtraInfo:        "extra info",
			Receiver:         "receiver",
			TradedItemInputs: make([]types.ItemRef, 0),
		})
	}
	buf, err := cfg.Codec.MarshalJSON(&state)
	require.NoError(t, err)
	cfg.GenesisState[types.ModuleName] = buf
	return network.New(t, cfg), state.TradeList, addresses[0]
}

func TestListTradesByCreator(t *testing.T) {
	net, tradeList, address := settingListTradesByCreatorObject(t, 2)
	ctx := net.Validators[0].ClientCtx
	for _, tc := range []struct {
		desc      string
		adress    string
		tradeList []types.Trade
		shouldErr bool
	}{
		{
			desc:      "Valid",
			adress:    address,
			tradeList: tradeList,
			shouldErr: false,
		},
		{
			desc:      "Invalid creator",
			adress:    "invalid",
			shouldErr: true,
		},
	} {
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{}
			args = append(args, tc.adress)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdListTradesByCreator(), args)
			println("check out: ", out.Bytes())

			if tc.shouldErr {
				require.Error(t, err)
				var resp types.QueryListTradesByCreatorResponse
				require.Error(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
			} else {
				require.NoError(t, err)
				var resp types.QueryListTradesByCreatorResponse
				require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.NotNil(t, resp.Trades)
				require.Equal(t, resp.Trades, tc.tradeList)
			}
		})
	}
}
