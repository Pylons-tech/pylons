package keeper_test

import (
	"encoding/base64"

	errorsmod "cosmossdk.io/errors"
	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/crypto/keys/ed25519"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

func (suite *IntegrationTestSuite) TestAddStripeRefund() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)

	privKey := ed25519.GenPrivKey()

	addr := types.GenTestBech32List(1)
	correctAddr := "pylo1xn72u3jxlpqx8tfgmjf0xg970q36xensjngsme"
	amount := sdk.NewIntFromUint64(10020060)
	productID := "recipe/Easel_CookBook_auto_cookbook_2022_06_14_114716_442/Easel_Recipe_auto_recipe_2022_06_14_114722_895"
	purchaseId := "pi_3LFdcNEdpQgutKvr1aspFGXh"
	incPurchaseId := "pi_3LFgx7EdpQgutKvr1cp5"
	signature := genTestPaymentInfoSignature(purchaseId, correctAddr, productID, amount, privKey)
	processorName := "TestPayment"
	types.DefaultPaymentProcessors = append(types.DefaultPaymentProcessors, types.PaymentProcessor{
		CoinDenom:            "ustripeusd",
		PubKey:               base64.StdEncoding.EncodeToString(privKey.PubKey().Bytes()),
		ProcessorPercentage:  types.DefaultProcessorPercentage,
		ValidatorsPercentage: types.DefaultValidatorsPercentage,
		Name:                 "TestPayment",
	})
	for _, tc := range []struct {
		desc    string
		request *types.MsgAddStripeRefund
		err     error
	}{
		{
			desc: "Valid Payment Info",
			request: &types.MsgAddStripeRefund{
				Payment: &types.PaymentInfo{
					PurchaseId:    purchaseId,
					ProcessorName: processorName,
					PayerAddr:     correctAddr,
					Amount:        amount,
					ProductId:     productID,
					Signature:     signature,
				},
				Creator: correctAddr,
			},
		},
		{
			desc: "Payment Info Already Used",
			request: &types.MsgAddStripeRefund{
				Payment: &types.PaymentInfo{
					PurchaseId:    purchaseId,
					ProcessorName: processorName,
					PayerAddr:     correctAddr,
					Amount:        amount,
					ProductId:     productID,
					Signature:     signature,
				},
				Creator: correctAddr,
			},
			err: errorsmod.Wrap(sdkerrors.ErrInvalidRequest, "the purchase ID is already being used"),
		},
		{
			desc: "Address Do Not Match",
			request: &types.MsgAddStripeRefund{
				Payment: &types.PaymentInfo{
					PurchaseId:    purchaseId,
					ProcessorName: processorName,
					PayerAddr:     correctAddr,
					Amount:        amount,
					ProductId:     productID,
					Signature:     signature,
				},
				Creator: addr[0],
			},
			err: errorsmod.Wrapf(sdkerrors.ErrInvalidRequest, "address for purchase %s do not match", "pi_3Ju3j843klKuxW9f0JrajT3q"),
		},
		{
			desc: "Signature Invalid",
			request: &types.MsgAddStripeRefund{
				Payment: &types.PaymentInfo{
					PurchaseId:    incPurchaseId,
					ProcessorName: processorName,
					PayerAddr:     correctAddr,
					Amount:        sdk.NewIntFromUint64(1003009027),
					ProductId:     "recipe/loud1234567/recipeNostripe1",
					Signature:     signature,
				},
				Creator: correctAddr,
			},
			err: errorsmod.Wrapf(sdkerrors.ErrInvalidRequest, "error validating purchase %s - %s", "pi_3Ju3j843klKuxW9f0Jra", errorsmod.Wrapf(sdkerrors.ErrorInvalidSigner, "signature for %s is invalid", "Pylons_Inc").Error()),
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			_, err := srv.AddStripeRefund(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.NoError(err)
			}
		})
	}
}
