package cli_test

import (
	"encoding/base64"
	"encoding/json"
	"fmt"

	"testing"

	cryptotypes "github.com/cosmos/cosmos-sdk/crypto/types"

	"github.com/cosmos/cosmos-sdk/client/flags"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/testutil/network"

	"github.com/Pylons-tech/pylons/x/pylons/types"

	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	"github.com/stretchr/testify/require"

	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
)

// genTestRedeemInfoSignature generates a signed RedeemInfo message using privKey
func genTestRedeemInfoSignature(payoutID, address string, amount sdk.Int, privKey cryptotypes.PrivKey) string {
	msg := fmt.Sprintf("{\"payout_id\":\"%s\",\"address\":\"%s\",\"amount\":\"%s\"}", payoutID, address, amount.String())
	msgBytes := []byte(msg)
	signedMsg, err := privKey.Sign(msgBytes)
	if err != nil {
		panic(err)
	}
	return base64.StdEncoding.EncodeToString(signedMsg)
}

func TestCmdBurnDebtToken(t *testing.T) {
	net := network.New(t)

	val := net.Validators[0]
	ctx := val.ClientCtx

	address, err := GenerateAddressWithAccount(ctx, t, net)
	fmt.Println(address)
	require.NoError(t, err)

	type field struct {
		ri     types.RedeemInfo
		sender string
	}
	for _, tc := range []struct {
		name    string
		args    field
		wantErr bool
	}{
		{
			name: "Valid",
			args: field{
				ri: types.RedeemInfo{
					Id:            "testId",
					ProcessorName: "Test",
					Address:       address,
					Amount:        sdk.NewInt(1000), // 1000node0token
					Signature:     genTestRedeemInfoSignature("testId", address, sdk.NewInt(1000), types.DefaultTestPrivateKey),
				},
				sender: address,
			},
			wantErr: false,
		},
		{
			name: "Invalid signature",
			args: field{
				ri: types.RedeemInfo{
					Id:            "testId",
					ProcessorName: "Test",
					Address:       address,
					Amount:        sdk.NewInt(1000), // 1000node0token
					Signature:     "INVALID_SIGNATURE",
				},
				sender: address,
			},
			wantErr: true,
		},
		{
			name: "Invalid payment processor",
			args: field{
				ri: types.RedeemInfo{
					Id:            "testId",
					ProcessorName: "Invalid",
					Address:       address,
					Amount:        sdk.NewInt(1000), // 1000node0token
					Signature:     genTestRedeemInfoSignature("testId", address, sdk.NewInt(1000), types.DefaultTestPrivateKey),
				},
				sender: address,
			},
			wantErr: true,
		},
		{
			name: "Insufficient amount",
			args: field{
				ri: types.RedeemInfo{
					Id:            "testId",
					ProcessorName: "Test",
					Address:       types.GenTestBech32FromString("test"),
					Amount:        sdk.NewInt(1100), // 1100node0token
					Signature:     genTestRedeemInfoSignature("testId", address, sdk.NewInt(1000), types.DefaultTestPrivateKey),
				},
				sender: address,
			},
			wantErr: true,
		},
	} {
		tc := tc
		t.Run(tc.name, func(t *testing.T) {
			common := []string{
				fmt.Sprintf("--%s=%s", flags.FlagFrom, tc.args.sender),
				fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
				fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
				fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
			}
			redeemInfoBytes, _ := json.Marshal(tc.args.ri)
			args := []string{string(redeemInfoBytes)}
			args = append(args, common...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdBurnDebtToken(), args)
			fmt.Println(err, out)
			if tc.wantErr {
				var resp sdk.TxResponse
				ctx.Codec.UnmarshalJSON(out.Bytes(), &resp)
				require.NotEqual(t, resp.Code, 0) // failed to execute message
			} else {
				require.NoError(t, err)
				var resp sdk.TxResponse
				require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
			}
		})
	}
}
