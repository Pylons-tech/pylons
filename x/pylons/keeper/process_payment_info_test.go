package keeper_test

import (
	"encoding/base64"
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	"github.com/cosmos/cosmos-sdk/crypto/keys/ed25519"
	cryptotypes "github.com/cosmos/cosmos-sdk/crypto/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
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

	feeCollectorAddr := ak.GetModuleAddress(v1beta1.FeeCollectorName)
	privKey := ed25519.GenPrivKey()

	// Create a payment infor with id = "1"
	createNPaymentInfo(k, suite.ctx, 1)

	// set up new payment processor using private key
	params := k.GetParams(suite.ctx)
	params.PaymentProcessors = append(params.PaymentProcessors, v1beta1.PaymentProcessor{
		CoinDenom:            "ustripeusd",
		PubKey:               base64.StdEncoding.EncodeToString(privKey.PubKey().Bytes()),
		ProcessorPercentage:  v1beta1.DefaultProcessorPercentage,
		ValidatorsPercentage: v1beta1.DefaultValidatorsPercentage,
		Name:                 "TestPayment",
	})
	k.SetParams(suite.ctx, params)

	type args struct {
		pi     []v1beta1.PaymentInfo
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
				pi: []v1beta1.PaymentInfo{{
					PurchaseId:    "testPurchaseId",
					ProcessorName: "TestPayment",
					PayerAddr:     v1beta1.GenTestBech32FromString("test"),
					Amount:        sdk.NewInt(1_000_000_000), // 1000stripeusd
					ProductId:     "testProductId",
					Signature:     genTestPaymentInfoSignature("testPurchaseId", v1beta1.GenTestBech32FromString("test"), "testProductId", sdk.NewInt(1_000_000_000), privKey),
				}},
				sender: v1beta1.GenAccAddressFromString("test"),
			},
			wantErr: false,
		},
		{
			name: "Invalid purchase ID",
			args: args{
				pi: []v1beta1.PaymentInfo{{
					PurchaseId:    "1",
					ProcessorName: "TestPayment",
					PayerAddr:     v1beta1.GenTestBech32FromString("test"),
					Amount:        sdk.NewInt(1_000_000_000), // 1000stripeusd
					ProductId:     "testProductId",
					Signature:     genTestPaymentInfoSignature("testPurchaseId", v1beta1.GenTestBech32FromString("test"), "testProductId", sdk.NewInt(1_000_000_000), privKey),
				}},
				sender: v1beta1.GenAccAddressFromString("test"),
			},
			wantErr: true,
		},
		{
			name: "Invalid sender address",
			args: args{
				pi: []v1beta1.PaymentInfo{{
					PurchaseId:    "testPurchaseId",
					ProcessorName: "TestPayment",
					PayerAddr:     v1beta1.GenTestBech32FromString("test"),
					Amount:        sdk.NewInt(1_000_000_000), // 1000stripeusd
					ProductId:     "testProductId",
					Signature:     genTestPaymentInfoSignature("testPurchaseId", v1beta1.GenTestBech32FromString("test"), "testProductId", sdk.NewInt(1_000_000_000), privKey),
				}},
				sender: v1beta1.GenAccAddressFromString("invalid"),
			},
			wantErr: true,
		},
		{
			name: "Invalid signature",
			args: args{
				pi: []v1beta1.PaymentInfo{{
					PurchaseId:    "testPurchaseId",
					ProcessorName: "TestPayment",
					PayerAddr:     v1beta1.GenTestBech32FromString("test"),
					Amount:        sdk.NewInt(1_000_000_000), // 1000stripeusd
					ProductId:     "testProductId",
					Signature:     "INVALID_SIGNATURE",
				}},
				sender: v1beta1.GenAccAddressFromString("test"),
			},
			wantErr: true,
		},
		{
			name: "Invalid payment processor",
			args: args{
				pi: []v1beta1.PaymentInfo{{
					PurchaseId:    "testPurchaseId",
					ProcessorName: "Invalid",
					PayerAddr:     v1beta1.GenTestBech32FromString("test"),
					Amount:        sdk.NewInt(1_000_000_000), // 1000stripeusd
					ProductId:     "testProductId",
					Signature:     genTestPaymentInfoSignature("testPurchaseId", v1beta1.GenTestBech32FromString("test"), "testProductId", sdk.NewInt(1_000_000_000), privKey),
				}},
				sender: v1beta1.GenAccAddressFromString("test"),
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
				userBalances := bk.SpendableCoins(suite.ctx, v1beta1.GenAccAddressFromString("test"))
				feeCollectorBalances := bk.SpendableCoins(suite.ctx, feeCollectorAddr)
				suite.Require().True(userBalances.IsEqual(sdk.NewCoins(sdk.NewCoin(v1beta1.StripeCoinDenom, sdk.NewInt(997000000)))))
				suite.Require().True(feeCollectorBalances.IsEqual(sdk.NewCoins(sdk.NewCoin(v1beta1.StripeCoinDenom, sdk.NewInt(3000000)))))

			}
		})
	}
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
	for _, tc := range []struct {
		desc    string
		request *v1beta1.PaymentInfo
		err     error
		addr    sdk.AccAddress
	}{
		{
			desc: "Valid Payment Info",
			request: &v1beta1.PaymentInfo{
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
			request: &v1beta1.PaymentInfo{
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
			request: &v1beta1.PaymentInfo{
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
