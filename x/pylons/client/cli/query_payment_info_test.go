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

func TestListPaymentInfo(t *testing.T) {
	net, paymentInfos := util.NetworkWithPaymentInfoObjects(t, 2)
	ctx := net.Validators[0].ClientCtx
	common := []string{
		fmt.Sprintf("--%s=json", tmcli.OutputFlag),
	}
	for _, tc := range []struct {
		desc string
		args []string
		err  error
		obj  []types.PaymentInfo
	}{
		{
			desc: "Valid",
			args: common,
			obj:  paymentInfos,
		},
	} {
		t.Run(tc.desc, func(t *testing.T) {

			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdListPaymentInfo(), tc.args)
			require.NoError(t, err)
			var resp types.QueryAllPaymentInfoResponse
			require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
			require.NotNil(t, resp.PaymentInfo)
			require.Equal(t, tc.obj, resp.PaymentInfo)
		})
	}
}

func TestShowPaymentInfo(t *testing.T) {
	net, paymentInfos := util.NetworkWithPaymentInfoObjects(t, 2)
	ctx := net.Validators[0].ClientCtx
	common := []string{
		fmt.Sprintf("--%s=json", tmcli.OutputFlag),
	}
	for _, tc := range []struct {
		desc       string
		purchaseId string
		args       []string
		err        error
		obj        types.PaymentInfo
	}{
		{
			desc:       "Found",
			purchaseId: paymentInfos[0].PurchaseId,
			args:       common,
			obj:        paymentInfos[0],
		},
		{
			desc:       "Not Found",
			purchaseId: "Not Found",
			args:       common,
			err:        status.Error(codes.InvalidArgument, "not found"),
		},
	} {
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{tc.purchaseId}
			args = append(args, tc.args...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdShowPaymentInfo(), args)
			if tc.err != nil {
				stat, ok := status.FromError(tc.err)
				require.True(t, ok)
				require.ErrorIs(t, stat.Err(), tc.err)
			} else {
				require.NoError(t, err)
				var resp types.QueryGetPaymentInfoResponse
				require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.Equal(t, tc.obj, resp.PaymentInfo)
			}
		})
	}
}
