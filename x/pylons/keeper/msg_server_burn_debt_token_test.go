package keeper_test

import (
	"encoding/base64"
	"fmt"

	"github.com/cosmos/cosmos-sdk/crypto/keys/ed25519"
	cryptotypes "github.com/cosmos/cosmos-sdk/crypto/types"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
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

func (suite *IntegrationTestSuite) TestBurnDebtToken() {
	k := suite.k
	bk := suite.bankKeeper

	srv := keeper.NewMsgServerImpl(k)

	privKey := ed25519.GenPrivKey()

	// Create a payment infor with id = "1"
	createNRedeemInfo(k, suite.ctx, 1)

	// set up new payment processor using private key
	params := k.GetParams(suite.ctx)
	types.DefaultPaymentProcessors = append(params.PaymentProcessors, types.PaymentProcessor{
		CoinDenom:            "ustripeusd",
		PubKey:               base64.StdEncoding.EncodeToString(privKey.PubKey().Bytes()),
		ProcessorPercentage:  types.DefaultProcessorPercentage,
		ValidatorsPercentage: types.DefaultValidatorsPercentage,
		Name:                 "Test",
	})
	k.SetParams(suite.ctx, params)

	type args struct {
		ri     types.RedeemInfo
		sender string
	}
	for _, tc := range []struct {
		name    string
		args    args
		wantErr bool
	}{
		{
			name: "Valid",
			args: args{
				ri: types.RedeemInfo{
					Id:            "testId",
					ProcessorName: "Test",
					Address:       types.GenTestBech32FromString("test"),
					Amount:        sdk.NewInt(1_000_000_000), // 1000stripeusd
					Signature:     genTestRedeemInfoSignature("testId", types.GenTestBech32FromString("test"), sdk.NewInt(1_000_000_000), privKey),
				},
				sender: types.GenTestBech32FromString("test"),
			},
			wantErr: false,
		},
		{
			name: "Invalid purchase ID",
			args: args{
				ri: types.RedeemInfo{
					Id:            "1",
					ProcessorName: "Test",
					Address:       types.GenTestBech32FromString("test"),
					Amount:        sdk.NewInt(1_000_000_000), // 1000stripeusd
					Signature:     genTestRedeemInfoSignature("testId", types.GenTestBech32FromString("test"), sdk.NewInt(1_000_000_000), privKey),
				},
				sender: types.GenTestBech32FromString("test"),
			},
			wantErr: true,
		},
		{
			name: "Invalid signature",
			args: args{
				ri: types.RedeemInfo{
					Id:            "testId",
					ProcessorName: "Test",
					Address:       types.GenTestBech32FromString("test"),
					Amount:        sdk.NewInt(1_000_000_000), // 1000stripeusd
					Signature:     "INVALID_SIGNATURE",
				},
				sender: types.GenTestBech32FromString("test"),
			},
			wantErr: true,
		},
		{
			name: "Invalid payment processor",
			args: args{
				ri: types.RedeemInfo{
					Id:            "testId",
					ProcessorName: "Invalid",
					Address:       types.GenTestBech32FromString("test"),
					Amount:        sdk.NewInt(1_000_000_000), // 1000stripeusd
					Signature:     genTestRedeemInfoSignature("testId", types.GenTestBech32FromString("test"), sdk.NewInt(1_000_000_000), privKey),
				},
				sender: types.GenTestBech32FromString("test"),
			},
			wantErr: true,
		},
		{
			name: "Insufficient amount",
			args: args{
				ri: types.RedeemInfo{
					Id:            "testId",
					ProcessorName: "Test",
					Address:       types.GenTestBech32FromString("test"),
					Amount:        sdk.NewInt(1_200_000_000), // 1000stripeusd
					Signature:     genTestRedeemInfoSignature("testId", types.GenTestBech32FromString("test"), sdk.NewInt(1_000_000_000), privKey),
				},
				sender: types.GenTestBech32FromString("test"),
			},
			wantErr: true,
		},
	} {
		tc := tc
		suite.Run(tc.name, func() {
			// Fund stripe usd to addr for testing
			suite.FundAccount(suite.ctx, types.GenAccAddressFromString("test"), sdk.NewCoins(sdk.NewCoin(types.StripeCoinDenom, sdk.NewInt(1_000_000_000))))

			msg := types.MsgBurnDebtToken{
				Creator:    tc.args.sender,
				RedeemInfo: tc.args.ri,
			}
			wctx := sdk.WrapSDKContext(suite.ctx)
			_, err := srv.BurnDebtToken(wctx, &msg)
			if tc.wantErr {
				suite.Require().Error(err)
				suite.Errorf(err, "ProcessRedeemInfos() wantErr %v", tc.name)
			}

			if !tc.wantErr {
				suite.Require().NoError(err)

				// Check balances
				userBalances := bk.SpendableCoins(suite.ctx, types.GenAccAddressFromString("test"))
				suite.Require().True(userBalances.IsEqual(sdk.NewCoins(sdk.NewCoin(types.StripeCoinDenom, sdk.NewInt(0)))))

			}
		})
	}
}
