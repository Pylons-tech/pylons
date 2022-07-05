package keeper_test

import (
	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

func (suite *IntegrationTestSuite) TestAddStripeRefund() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)

	addr := types.GenTestBech32List(1)
	correctAddr := "pylo1xn72u3jxlpqx8tfgmjf0xg970q36xensjngsme"
	amount := sdk.NewIntFromUint64(10020060)
	productID := "recipe/Easel_CookBook_auto_cookbook_2022_06_14_114716_442/Easel_Recipe_auto_recipe_2022_06_14_114722_895"
	signature := "8lZsKTOdMuJSoFn0RCGEUGpPXl4YzLmhJMrEiAd4qZh99S4IIGbvcsXyOcOHdlKi6Yys9NhmkLN4LqSlq8Y1Cw=="
	purchaseId := "pi_3LFdcNEdpQgutKvr1aspFGXh"
	incPurchaseId := "pi_3LFgx7EdpQgutKvr1cp5"
	processorName := "Pylons_Inc"
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
			err: sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the purchase ID is already being used"),
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
			err: sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "address for purchase %s do not match", "pi_3Ju3j843klKuxW9f0JrajT3q"),
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
			err: sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "error validating purchase %s - %s", "pi_3Ju3j843klKuxW9f0Jra", sdkerrors.Wrapf(sdkerrors.ErrorInvalidSigner, "signature for %s is invalid", "Pylons_Inc").Error()),
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
