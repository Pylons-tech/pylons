package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestGetStripeRefund() {
	goCtx := sdk.WrapSDKContext(suite.ctx)

	correctAddr := "pylo1xn72u3jxlpqx8tfgmjf0xg970q36xensjngsme"
	amount := sdk.NewIntFromUint64(10020060)
	productID := "recipe/Easel_CookBook_auto_cookbook_2022_06_14_114716_442/Easel_Recipe_auto_recipe_2022_06_14_114722_895"
	signature := "8lZsKTOdMuJSoFn0RCGEUGpPXl4YzLmhJMrEiAd4qZh99S4IIGbvcsXyOcOHdlKi6Yys9NhmkLN4LqSlq8Y1Cw=="
	purchaseId := "pi_3LFdcNEdpQgutKvr1aspFGXh"
	processorName := "Pylons_Inc"

	payment := types.PaymentInfo{
		PurchaseId:    purchaseId,
		ProcessorName: processorName,
		PayerAddr:     correctAddr,
		Amount:        amount,
		ProductId:     productID,
		Signature:     signature,
	}

	stripeRefund := types.StripeRefund{
		Payment: &payment,
		Settled: false,
	}

	suite.k.SetStripeRefund(suite.ctx, &stripeRefund)

	stripeRefunds := make([]*types.StripeRefund, 1)
	stripeRefunds[0] = &stripeRefund

	for _, tc := range []struct {
		desc string
		req  *types.QueryGetStripeRefundRequest
		res  *types.QueryGetStripeRefundResponse
		err  error
	}{
		{
			desc: "Success",
			req:  &types.QueryGetStripeRefundRequest{},
			res: &types.QueryGetStripeRefundResponse{
				Refunds: stripeRefunds,
			},
			err: nil,
		},
		{
			desc: "Invalid Request",
			req:  nil,
			res:  nil,
			err:  status.Error(codes.InvalidArgument, "invalid request"),
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			res, err := suite.k.GetStripeRefund(goCtx, tc.req)
			if tc.err != nil {
				suite.Require().ErrorIs(err, tc.err)
			} else {
				suite.Require().Equal(res, tc.res)
			}
		})
	}
}
