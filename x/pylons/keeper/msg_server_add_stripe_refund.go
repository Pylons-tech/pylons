package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

func (k msgServer) AddStripeRefund(goCtx context.Context, msg *types.MsgAddStripeRefund) (*types.MsgAddStripeRefundResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	// search is purchase id is already reserved
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
	k.SetStripeRefund(ctx, &types.StripeRefund{
		Payment: msg.Payment,
		Settled: false,
	})

	return &types.MsgAddStripeRefundResponse{}, nil
}
