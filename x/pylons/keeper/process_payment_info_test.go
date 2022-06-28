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

	for _, tc := range []struct {
		desc    string
		request *types.PaymentInfo
		err     error
		addr    sdk.AccAddress
	}{
		{
			desc: "Valid Payment Info",
			request: &types.PaymentInfo{
				PurchaseId:    "pi_3LFgx7EdpQgutKvr1cp5nqtP",
				ProcessorName: "Pylons_Inc",
				PayerAddr:     correctAddr,
				Amount:        amount,
				ProductId:     productID,
				Signature:     "LDT82evxVF8oHdPR/h9Dj+B/BbVROvEjJ3wADMk7ow06o9Xv/7R3aRXylMdbhkMX8HciH6RPj+GwJLw8XSJeDQ==",
			},
			addr: addr,
		},
		{
			desc: "Address Do Not Match",
			request: &types.PaymentInfo{
				PurchaseId:    "pi_3LFgx7EdpQgutKvr1cp5nqtP",
				ProcessorName: "Pylons_Inc",
				PayerAddr:     correctAddr,
				Amount:        amount,
				ProductId:     productID,
				Signature:     "LDT82evxVF8oHdPR/h9Dj+B/BbVROvEjJ3wADMk7ow06o9Xv/7R3aRXylMdbhkMX8HciH6RPj+GwJLw8XSJeDQ==",
			},
			addr: addrInc,
			err:  sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "address for purchase %s do not match", "pi_3LFdcNEdpQgutKvr1aspFGXw"),
		},
		{
			desc: "Signature Invalid",
			request: &types.PaymentInfo{
				PurchaseId:    "pi_3Ju3j843klKuxW9f0Jra",
				ProcessorName: "Pylons_Inc",
				PayerAddr:     correctAddr,
				Amount:        sdk.NewIntFromUint64(1003009027),
				ProductId:     "recipe/loud1234567/recipeNostripe1",
				Signature:     "LDT82evxVF8oHdPR/h9Dj+B/BbVROvEjJ3wADMk7ow06o9Xv/7R3aRXylMdbhkMX8HciH6RPj+GwJLw8XSJeDQ==",
			},
			addr: addr,
			err:  sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "error validating purchase %s - %s", "pi_3Ju3j843klKuxW9f0Jra", sdkerrors.Wrapf(sdkerrors.ErrorInvalidSigner, "signature for %s is invalid", "Pylons_Inc").Error()),
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
