package keeper_test

import (
	"encoding/base64"
	"fmt"

	"github.com/cosmos/cosmos-sdk/crypto/keys/ed25519"
	cryptotypes "github.com/cosmos/cosmos-sdk/crypto/types"
	"github.com/cosmos/cosmos-sdk/types"
	pylonstypes "github.com/Pylons-tech/pylons/x/pylons/types"
)

// genTestPaymentInfoSignature generates a signed PaymentInfo message using privKey
func genTestPaymentInfoSignature(purchaseID, address, productID string, amount types.Int, privKey cryptotypes.PrivKey) string {
	msg := fmt.Sprintf("{\"purchase_id\":\"%s\",\"address\":\"%s\",\"amount\":\"%s\",\"product_id\":\"%s\"}", purchaseID, address, amount.String(), productID)
	msgBytes := []byte(msg)
	signedMsg, err := privKey.Sign(msgBytes)
	if err != nil {
		panic(err)
	}
	return base64.StdEncoding.EncodeToString(signedMsg)
}

func (suite *IntegrationTestSuite) TestA() {
	k := suite.k
	privKey := ed25519.GenPrivKey()
	type args struct {
		pi []pylonstypes.PaymentInfo
		toPay types.Coins
	}
	for _, tc := range []struct {
		name    string
		args    args
		wantErr bool
	}{
		{
			name: "Valid",
			args: args{
				pi: []pylonstypes.PaymentInfo{{
					PurchaseId:    "testPurchaseId",
					ProcessorName: "Pylons_Inc",
					PayerAddr:     pylonstypes.GenTestBech32FromString("test"),
					Amount:        types.NewInt(1_000_000_000), // 1000stripeusd
					ProductId:     "testProductId",
					Signature:     genTestPaymentInfoSignature("testPurchaseId", pylonstypes.GenTestBech32FromString("test"), "testProductId", types.NewInt(1_000_000_000), privKey),
				}},
				toPay: types.NewCoins(types.NewCoin(pylonstypes.StripeCoinDenom, types.NewInt(997_000_000))),
			},
			wantErr: false,
		},
		{
			name: "Invalid payment processors",
			args: args{
				pi: []pylonstypes.PaymentInfo{{
					PurchaseId:    "testPurchaseId",
					ProcessorName: "Invalid",
					PayerAddr:     pylonstypes.GenTestBech32FromString("test"),
					Amount:        types.NewInt(1_000_000_000), // 1000stripeusd
					ProductId:     "testProductId",
					Signature:     genTestPaymentInfoSignature("testPurchaseId", pylonstypes.GenTestBech32FromString("test"), "testProductId", types.NewInt(1_000_000_000), privKey),
				}},
				toPay: types.NewCoins(types.NewCoin(pylonstypes.StripeCoinDenom, types.NewInt(997_000_000))),
			},
			wantErr: true,
		},
		{
			name: "Insufficient anount",
			args: args{
				pi: []pylonstypes.PaymentInfo{{
					PurchaseId:    "testPurchaseId",
					ProcessorName: "Pylons_Inc",
					PayerAddr:     pylonstypes.GenTestBech32FromString("test"),
					Amount:        types.NewInt(1_000_000_000), // 1000stripeusd
					ProductId:     "testProductId",
					Signature:     genTestPaymentInfoSignature("testPurchaseId", pylonstypes.GenTestBech32FromString("test"), "testProductId", types.NewInt(1_000_000_000), privKey),
				}},
				toPay: types.NewCoins(types.NewCoin(pylonstypes.StripeCoinDenom, types.NewInt(1_000_000_000))),
			},
			wantErr: true,
		},
	} {
		tc := tc
		suite.Run(tc.name, func() {			
			err := k.ValidatePaymentInfo(suite.ctx,tc.args.pi, tc.args.toPay);
			if tc.wantErr {
				suite.Require().Error(err)
				suite.Errorf(err, "ValidatePaymentInfo() wantErr %v", tc.name)
			}

			if !tc.wantErr {
				suite.Require().NoError(err)
			}
		})
	}
}

func (suite *IntegrationTestSuite) TestProcessPaymentInfos() {
	k := suite.k
	bk := suite.bankKeeper
	ak := suite.accountKeeper

	feeCollectorAddr := ak.GetModuleAddress(pylonstypes.FeeCollectorName)
	privKey := ed25519.GenPrivKey()

	// Create a payment infor with id = "1"
	createNPaymentInfo(k, suite.ctx, 1)

	// set up new payment processor using private key
	params := k.GetParams(suite.ctx)
	params.PaymentProcessors = append(params.PaymentProcessors, pylonstypes.PaymentProcessor{
		CoinDenom:            "ustripeusd",
		PubKey:               base64.StdEncoding.EncodeToString(privKey.PubKey().Bytes()),
		ProcessorPercentage:  pylonstypes.DefaultProcessorPercentage,
		ValidatorsPercentage: pylonstypes.DefaultValidatorsPercentage,
		Name:                 "Test",
	})
	k.SetParams(suite.ctx, params)
	

	type args struct {
		pi []pylonstypes.PaymentInfo
		sender types.AccAddress
	}
	for _, tc := range []struct {
		name    string
		args    args
		wantErr bool
	}{
		{
			name: "Valid",
			args: args{
				pi: []pylonstypes.PaymentInfo{{
					PurchaseId:    "testPurchaseId",
					ProcessorName: "Test",
					PayerAddr:     pylonstypes.GenTestBech32FromString("test"),
					Amount:        types.NewInt(1_000_000_000), // 1000stripeusd
					ProductId:     "testProductId",
					Signature:     genTestPaymentInfoSignature("testPurchaseId", pylonstypes.GenTestBech32FromString("test"), "testProductId", types.NewInt(1_000_000_000), privKey),
				}},
				sender: pylonstypes.GenAccAddressFromString("test"),
			},
			wantErr: false,
		},
		{
			name: "Invalid purchase ID",
			args: args{
				pi: []pylonstypes.PaymentInfo{{
					PurchaseId:    "1",
					ProcessorName: "Test",
					PayerAddr:     pylonstypes.GenTestBech32FromString("test"),
					Amount:        types.NewInt(1_000_000_000), // 1300stripeusd
					ProductId:     "testProductId",
					Signature:     genTestPaymentInfoSignature("testPurchaseId", pylonstypes.GenTestBech32FromString("test"), "testProductId", types.NewInt(1_000_000_000), privKey),
				}},
				sender: pylonstypes.GenAccAddressFromString("test"),
			},
			wantErr: true,
		},
		{
			name: "Invalid sender address",
			args: args{
				pi: []pylonstypes.PaymentInfo{{
					PurchaseId:    "testPurchaseId",
					ProcessorName: "Test",
					PayerAddr:     pylonstypes.GenTestBech32FromString("test"),
					Amount:        types.NewInt(1_000_000_000), // 1000stripeusd
					ProductId:     "testProductId",
					Signature:     genTestPaymentInfoSignature("testPurchaseId", pylonstypes.GenTestBech32FromString("test"), "testProductId", types.NewInt(1_000_000_000), privKey),
				}},
				sender: pylonstypes.GenAccAddressFromString("invalid"),
			},
			wantErr: true,
		},
		{
			name: "Invalid signature",
			args: args{
				pi: []pylonstypes.PaymentInfo{{
					PurchaseId:    "testPurchaseId",
					ProcessorName: "Test",
					PayerAddr:     pylonstypes.GenTestBech32FromString("test"),
					Amount:        types.NewInt(1_000_000_000), // 1000stripeusd
					ProductId:     "testProductId",
					Signature:     "INVALID_SIGNATURE",
				}},
				sender: pylonstypes.GenAccAddressFromString("test"),
			},
			wantErr: true,
		},
		{
			name: "Invalid payment processor",
			args: args{
				pi: []pylonstypes.PaymentInfo{{
					PurchaseId:    "testPurchaseId",
					ProcessorName: "Invalid",
					PayerAddr:     pylonstypes.GenTestBech32FromString("test"),
					Amount:        types.NewInt(1_000_000_000), // 1000stripeusd
					ProductId:     "testProductId",
					Signature:     genTestPaymentInfoSignature("testPurchaseId", pylonstypes.GenTestBech32FromString("test"), "testProductId", types.NewInt(1_000_000_000), privKey),
				}},
				sender: pylonstypes.GenAccAddressFromString("test"),
			},
			wantErr: true,
		},
	} {
		tc := tc
		suite.Run(tc.name, func() {
			
			err := k.ProcessPaymentInfos(suite.ctx,tc.args.pi, tc.args.sender);
			if tc.wantErr {
				suite.Require().Error(err)
				suite.Errorf(err, "ProcessPaymentInfos() wantErr %v", tc.name)
			}

			if !tc.wantErr {
				suite.Require().NoError(err)

				//Check balances
				userBalances := bk.SpendableCoins(suite.ctx, pylonstypes.GenAccAddressFromString("test"))
				feeCollectorBalances := bk.SpendableCoins(suite.ctx, feeCollectorAddr)
				suite.Require().True(userBalances.IsEqual(types.NewCoins(types.NewCoin(pylonstypes.StripeCoinDenom, types.NewInt(997000000)))))
				suite.Require().True(feeCollectorBalances.IsEqual(types.NewCoins(types.NewCoin(pylonstypes.StripeCoinDenom, types.NewInt(3000000)))))

			}
		})
	}
}

