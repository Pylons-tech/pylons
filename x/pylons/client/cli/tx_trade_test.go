package cli_test

import (
	"testing"

	util "github.com/Pylons-tech/pylons/testutil/cli"
	"github.com/Pylons-tech/pylons/testutil/network"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestCmdCreateTrade(t *testing.T) {
	net := network.New(t)
	ctx := net.Validators[0].ClientCtx

	acc := createAccountInKeyring(ctx, t, net, 1)

	common := util.CommonArgs(acc[0].String(), net)

	coinInputs := "[]"
	itemInputs := "[]"
	coinOutputs := "[]"
	itemOutputs := "[]"
	extraInfo := "extra info"

	for _, tc := range []struct {
		desc        string
		coinInputs  string
		itemInputs  string
		coinOutputs string
		itemOutputs string
		extraInfo   string
		shouldFail  bool
	}{
		{
			desc:        "Invalid coinInputs",
			coinInputs:  "invalid",
			itemInputs:  itemInputs,
			coinOutputs: coinOutputs,
			itemOutputs: itemOutputs,
			extraInfo:   extraInfo,
			shouldFail:  true,
		},
		{
			desc:        "Invalid itemInputs",
			coinInputs:  coinInputs,
			itemInputs:  "invalid",
			coinOutputs: coinOutputs,
			itemOutputs: itemOutputs,
			extraInfo:   extraInfo,
			shouldFail:  true,
		},
		{
			desc:        "Invalid coinOutputs",
			coinInputs:  coinInputs,
			itemInputs:  itemInputs,
			coinOutputs: "invalid",
			itemOutputs: itemOutputs,
			extraInfo:   extraInfo,
			shouldFail:  true,
		},
		{
			desc:        "Invalid itemOutputs",
			coinInputs:  coinInputs,
			itemInputs:  itemInputs,
			coinOutputs: coinOutputs,
			itemOutputs: "invalid",
			extraInfo:   extraInfo,
			shouldFail:  true,
		},
		{
			desc:        "Valid",
			coinInputs:  coinInputs,
			itemInputs:  itemInputs,
			coinOutputs: coinOutputs,
			itemOutputs: itemOutputs,
			extraInfo:   extraInfo,
			shouldFail:  false,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{}
			args = append(args, tc.coinInputs)
			args = append(args, tc.itemInputs)
			args = append(args, tc.coinOutputs)
			args = append(args, tc.itemOutputs)
			args = append(args, tc.extraInfo)
			args = append(args, common...)

			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateTrade(), args)
			if tc.shouldFail {
				if err != nil { // Error returned from Message validate
					require.Error(t, err)
				} else { // Error returned from Keeper
					var resp sdk.TxResponse
					ctx.Codec.UnmarshalJSON(out.Bytes(), &resp)
					require.NotEqual(t, resp.Code, 0)
				}
			} else {
				require.NoError(t, err)
				var resp sdk.TxResponse
				require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.Equal(t, 0, int(resp.Code))
			}
		})
	}

	types.UpdateAppCheckFlagTest(types.FlagFalse)
}

func TestCmdCancelTrade(t *testing.T) {
	net := network.New(t)
	ctx := net.Validators[0].ClientCtx

	acc := createAccountInKeyring(ctx, t, net, 2)
	common := util.CommonArgs(acc[0].String(), net)

	args := []string{}

	coinInputs := "[]"
	itemInputs := "[]"
	coinOutputs := "[]"
	itemOutputs := "[]"
	extraInfo := "extra info"

	args = append(args, common...)
	args = append(args, coinInputs)
	args = append(args, itemInputs)
	args = append(args, coinOutputs)
	args = append(args, itemOutputs)
	args = append(args, extraInfo)

	_, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateTrade(), args)
	require.NoError(t, err)

	for _, tc := range []struct {
		desc       string
		tradeId    string
		common     []string
		shouldFail bool
	}{
		{
			desc:       "Invalid tradeId",
			tradeId:    "invalid",
			common:     util.CommonArgs(acc[0].String(), net),
			shouldFail: true,
		},
		{
			desc:       "Trade not found",
			tradeId:    "10000000",
			common:     util.CommonArgs(acc[0].String(), net),
			shouldFail: true,
		},
		{
			desc:       "Incorrect owner",
			tradeId:    "0",
			common:     util.CommonArgs(acc[1].String(), net),
			shouldFail: true,
		},
		{
			desc:       "Valid",
			tradeId:    "0",
			common:     util.CommonArgs(acc[0].String(), net),
			shouldFail: false,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{}
			args = append(args, tc.tradeId)
			args = append(args, tc.common...)

			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCancelTrade(), args)
			if tc.shouldFail {
				if err != nil { // Error returned from Message validate
					require.Error(t, err)
				} else { // Error returned from Keeper
					var resp sdk.TxResponse
					ctx.Codec.UnmarshalJSON(out.Bytes(), &resp)
					require.NotEqual(t, resp.Code, 0)
				}
			} else {
				require.NoError(t, err)
				var resp sdk.TxResponse
				require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.Equal(t, 0, int(resp.Code))
			}
		})
	}

	types.UpdateAppCheckFlagTest(types.FlagFalse)
}
