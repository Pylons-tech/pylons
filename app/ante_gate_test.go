package app_test

import (
	"fmt"
	"testing"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/testutil"
	sdk "github.com/cosmos/cosmos-sdk/types"
	bank "github.com/cosmos/cosmos-sdk/x/bank/client/cli"

	"github.com/Pylons-tech/pylons/testutil/network"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	"github.com/stretchr/testify/require"
)

var OutRes testutil.BufferWriter

const errCode = uint32(19)

func TestPreventSpamTx(t *testing.T) {
	// Set MaxTxsInBlock  = 2
	numberTxsinBlocks := 2
	config := network.ConfigWithMaxTxsInBlock(uint64(numberTxsinBlocks))
	net := network.New(t, config)

	val := net.Validators[0]
	ctx := val.ClientCtx
	for i := 0; i < numberTxsinBlocks+1; i++ {
		go executeSendTx(ctx, net)
	}
	net.WaitForNextBlock()
	var resp sdk.TxResponse
	require.NoError(t, ctx.Codec.UnmarshalJSON(OutRes.Bytes(), &resp))
	require.Equal(t, errCode, resp.Code)
}

func CommonArgs(address string, net *network.Network) []string {
	return []string{
		fmt.Sprintf("--%s=%s", flags.FlagFrom, address),
		fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
		fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastSync),
		fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
	}
}

func executeSendTx(ctx client.Context, net *network.Network) {
	common := CommonArgs(net.Validators[0].Address.String(), net)
	args := []string{net.Validators[0].Address.String(), net.Validators[0].Address.String(), "10stake"}
	args = append(args, common...)
	OutRes, _ = clitestutil.ExecTestCLICmd(ctx, bank.NewSendTxCmd(), args)
}
