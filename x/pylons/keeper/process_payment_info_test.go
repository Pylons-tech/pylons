package keeper_test

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

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
