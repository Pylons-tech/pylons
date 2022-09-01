package keeper_test

import (
	"encoding/base64"
	"fmt"

	"github.com/cosmos/cosmos-sdk/crypto/keys/ed25519"
	cryptotypes "github.com/cosmos/cosmos-sdk/crypto/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	banktypes "github.com/cosmos/cosmos-sdk/x/bank/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// genTestPaymentInfoSignature generates a signed PaymentInfo message using privKey
func genTestPaymentInfoSignature(purchaseID, address, productID string, amount sdk.Int, privKey cryptotypes.PrivKey) string {
	msg := fmt.Sprintf("{\"purchase_id\":\"%s\",\"address\":\"%s\",\"amount\":\"%s\",\"product_id\":\"%s\"}", purchaseID, address, amount.String(), productID)
	msgBytes := []byte(msg)
	signedMsg, err := privKey.Sign(msgBytes)
	if err != nil {
		panic(err)
	}
	return base64.StdEncoding.EncodeToString(signedMsg)
}

func (suite *IntegrationTestSuite) TestProcessPaymentInfos() {
	k := suite.k
	bk := suite.bankKeeper
	ak := suite.accountKeeper

	feeCollectorAddr := ak.GetModuleAddress(types.FeeCollectorName)
	privKey := ed25519.GenPrivKey()

	// Create a payment infor with id = "1"
	createNPaymentInfo(k, suite.ctx, 1)

	// set up new payment processor using private key
	types.DefaultPaymentProcessors = append(types.DefaultPaymentProcessors, types.PaymentProcessor{
		CoinDenom:            "ustripeusd",
		PubKey:               base64.StdEncoding.EncodeToString(privKey.PubKey().Bytes()),
		ProcessorPercentage:  types.DefaultProcessorPercentage,
		ValidatorsPercentage: types.DefaultValidatorsPercentage,
		Name:                 "TestPayment",
	})

	type args struct {
		pi     []types.PaymentInfo
		sender sdk.AccAddress
	}
	for _, tc := range []struct {
		name    string
		args    args
		wantErr bool
	}{
		{
			name: "Valid",
			args: args{
				pi: []types.PaymentInfo{{
					PurchaseId:    "testPurchaseId",
					ProcessorName: "TestPayment",
					PayerAddr:     types.GenTestBech32FromString("test"),
					Amount:        sdk.NewInt(1_000_000_000), // 1000stripeusd
					ProductId:     "testProductId",
					Signature:     genTestPaymentInfoSignature("testPurchaseId", types.GenTestBech32FromString("test"), "testProductId", sdk.NewInt(1_000_000_000), privKey),
				}},
				sender: types.GenAccAddressFromString("test"),
			},
			wantErr: false,
		},
		{
			name: "Invalid purchase ID",
			args: args{
				pi: []types.PaymentInfo{{
					PurchaseId:    "1",
					ProcessorName: "TestPayment",
					PayerAddr:     types.GenTestBech32FromString("test"),
					Amount:        sdk.NewInt(1_000_000_000), // 1000stripeusd
					ProductId:     "testProductId",
					Signature:     genTestPaymentInfoSignature("testPurchaseId", types.GenTestBech32FromString("test"), "testProductId", sdk.NewInt(1_000_000_000), privKey),
				}},
				sender: types.GenAccAddressFromString("test"),
			},
			wantErr: true,
		},
		{
			name: "Invalid sender address",
			args: args{
				pi: []types.PaymentInfo{{
					PurchaseId:    "testPurchaseId",
					ProcessorName: "TestPayment",
					PayerAddr:     types.GenTestBech32FromString("test"),
					Amount:        sdk.NewInt(1_000_000_000), // 1000stripeusd
					ProductId:     "testProductId",
					Signature:     genTestPaymentInfoSignature("testPurchaseId", types.GenTestBech32FromString("test"), "testProductId", sdk.NewInt(1_000_000_000), privKey),
				}},
				sender: types.GenAccAddressFromString("invalid"),
			},
			wantErr: true,
		},
		{
			name: "Invalid signature",
			args: args{
				pi: []types.PaymentInfo{{
					PurchaseId:    "testPurchaseId",
					ProcessorName: "TestPayment",
					PayerAddr:     types.GenTestBech32FromString("test"),
					Amount:        sdk.NewInt(1_000_000_000), // 1000stripeusd
					ProductId:     "testProductId",
					Signature:     "INVALID_SIGNATURE",
				}},
				sender: types.GenAccAddressFromString("test"),
			},
			wantErr: true,
		},
		{
			name: "Invalid payment processor",
			args: args{
				pi: []types.PaymentInfo{{
					PurchaseId:    "testPurchaseId",
					ProcessorName: "Invalid",
					PayerAddr:     types.GenTestBech32FromString("test"),
					Amount:        sdk.NewInt(1_000_000_000), // 1000stripeusd
					ProductId:     "testProductId",
					Signature:     genTestPaymentInfoSignature("testPurchaseId", types.GenTestBech32FromString("test"), "testProductId", sdk.NewInt(1_000_000_000), privKey),
				}},
				sender: types.GenAccAddressFromString("test"),
			},
			wantErr: true,
		},
	} {
		tc := tc
		suite.Run(tc.name, func() {
			err := k.ProcessPaymentInfos(suite.ctx, tc.args.pi, tc.args.sender)
			if tc.wantErr {
				suite.Require().Error(err)
				suite.Errorf(err, "ProcessPaymentInfos() wantErr %v", tc.name)
			}

			if !tc.wantErr {
				suite.Require().NoError(err)

				// Check balances
				userBalances := bk.SpendableCoins(suite.ctx, types.GenAccAddressFromString("test"))
				feeCollectorBalances := bk.SpendableCoins(suite.ctx, feeCollectorAddr)
				suite.Require().True(userBalances.IsEqual(sdk.NewCoins(sdk.NewCoin(types.StripeCoinDenom, sdk.NewInt(997000000)))))
				suite.Require().True(feeCollectorBalances.IsEqual(sdk.NewCoins(sdk.NewCoin(types.StripeCoinDenom, sdk.NewInt(3000000)))))

			}
		})
	}
	types.DefaultPaymentProcessors = types.DefaultPaymentProcessors[:1]
}

func (suite *IntegrationTestSuite) TestVerifyPaymentInfos() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	correctAddr := "pylo1xn72u3jxlpqx8tfgmjf0xg970q36xensjngsme"
	addr, _ := sdk.AccAddressFromBech32(correctAddr)
	addrInc, _ := sdk.AccAddressFromBech32("tester incorrect")
	amount := sdk.NewIntFromUint64(10020060)
	productID := "recipe/Easel_CookBook_auto_cookbook_2022_06_14_114716_442/Easel_Recipe_auto_recipe_2022_06_14_114722_895"
	signature := "+f11IPGOtgMTpQou8V2anPSK9KCyQbi3UXFvocFDzmUKxcloXavWIzKIhIXg7pHwfRut62l1Jgo/J7a6uyusDQ=="
	purchaseId := "pi_3LFgx7EdpQgutKvr1cp5nqtP"
	incPurchaseId := "pi_3LFgx7EdpQgutKvr1cp5"
	processorName := "Pylons_Inc"
	test_processorName := "testprocessorName"
	for _, tc := range []struct {
		desc    string
		request *types.PaymentInfo
		err     error
		addr    sdk.AccAddress
	}{
		{
			desc: "Valid Payment Info",
			request: &types.PaymentInfo{
				PurchaseId:    purchaseId,
				ProcessorName: processorName,
				PayerAddr:     correctAddr,
				Amount:        amount,
				ProductId:     productID,
				Signature:     signature,
			},
			addr: addr,
		},
		{
			desc: "Address Do Not Match",
			request: &types.PaymentInfo{
				PurchaseId:    purchaseId,
				ProcessorName: processorName,
				PayerAddr:     correctAddr,
				Amount:        amount,
				ProductId:     productID,
				Signature:     signature,
			},
			addr: addrInc,
			err:  sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "address for purchase %s do not match", purchaseId),
		},
		{
			desc: "Signature Invalid",
			request: &types.PaymentInfo{
				PurchaseId:    incPurchaseId,
				ProcessorName: processorName,
				PayerAddr:     correctAddr,
				Amount:        amount,
				ProductId:     productID,
				Signature:     signature,
			},
			addr: addr,
			err:  sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "error validating purchase %s - %s", purchaseId, sdkerrors.Wrapf(sdkerrors.ErrorInvalidSigner, "signature for %s is invalid", processorName).Error()),
		},
		{
			desc: "Invalid Payment processor",
			request: &types.PaymentInfo{
				PurchaseId:    incPurchaseId,
				ProcessorName: test_processorName,
				PayerAddr:     correctAddr,
				Amount:        amount,
				ProductId:     productID,
				Signature:     signature,
			},
			addr: addr,
			err:  sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "could not find %s among valid payment processors", test_processorName),
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			err := k.VerifyPaymentInfos(ctx, tc.request, tc.addr)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.NoError(err)
			}
		})
	}
}
func (suite *IntegrationTestSuite) TestValidatePaymentInfo() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	correctAddr := "pylo1xn72u3jxlpqx8tfgmjf0xg970q36xensjngsme"
	productID := "recipe/Easel_CookBook_auto_cookbook_2022_06_14_114716_442/Easel_Recipe_auto_recipe_2022_06_14_114722_895"
	signature := "+f11IPGOtgMTpQou8V2anPSK9KCyQbi3UXFvocFDzmUKxcloXavWIzKIhIXg7pHwfRut62l1Jgo/J7a6uyusDQ=="
	purchaseId := "pi_3LFgx7EdpQgutKvr1cp5nqtP"
	processorName := "Pylons_Inc"

	req_paymentinfo := make([]types.PaymentInfo, 0)

	enabled := true
	params := banktypes.DefaultParams()

	fooCoin := sdk.NewCoin("ustripeusd", sdk.NewInt(1000))

	params.DefaultSendEnabled = !enabled
	params = params.SetSendEnabledParam(fooCoin.Denom, !enabled)
	suite.pylonsApp.BankKeeper.SetParams(ctx, params)

	toPay_Coins := sdk.NewCoins()
	toPay_Coins = append(toPay_Coins, *&fooCoin)

	for _, tc := range []struct {
		desc    string
		request []types.PaymentInfo
		coin    sdk.Coins
		err     error
	}{
		{
			desc: "Valid Payment Info",
			request: append(req_paymentinfo, types.PaymentInfo{
				PurchaseId:    purchaseId,
				ProcessorName: processorName,
				PayerAddr:     correctAddr,
				Amount:        sdk.NewIntFromUint64(10000),
				ProductId:     productID,
				Signature:     signature,
			}),
			coin: nil,
		},
		{
			desc: "Invalid Payment processor",
			request: append(req_paymentinfo, types.PaymentInfo{
				PurchaseId:    purchaseId,
				ProcessorName: "testprocessorName",
				PayerAddr:     correctAddr,
				Amount:        sdk.NewIntFromUint64(10000),
				ProductId:     productID,
				Signature:     signature,
			}),
			coin: nil,
			err:  sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Not enough recepts",
			request: append(req_paymentinfo, types.PaymentInfo{
				PurchaseId:    purchaseId,
				ProcessorName: processorName,
				PayerAddr:     correctAddr,
				Amount:        sdk.NewIntFromUint64(999),
				ProductId:     productID,
				Signature:     signature,
			}),
			coin: toPay_Coins,
			err:  sdkerrors.ErrInvalidRequest,
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			err := k.ValidatePaymentInfo(ctx, tc.request, tc.coin)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.NoError(err)
			}
		})
	}
}
