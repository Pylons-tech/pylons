package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

func (k msgServer) AddStripeRefund(goCtx context.Context, msg *v1beta1.MsgAddStripeRefund) (*v1beta1.MsgAddStripeRefundResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	// search if purchase id is already reserved
	if k.HasPaymentInfo(ctx, msg.Payment.PurchaseId) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the purchase ID is already being used")
	}

	// it is checked previously hence no need to check error
	addr, _ := sdk.AccAddressFromBech32(msg.Creator)

	err := k.VerifyPaymentInfos(ctx, msg.Payment, addr)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	// now the payment info is verified we will store it in our store
	k.SetStripeRefund(ctx, &v1beta1.StripeRefund{
		Payment: msg.Payment,
		Settled: false,
	})

	return &v1beta1.MsgAddStripeRefundResponse{}, nil
}
