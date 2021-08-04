package queriers

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

func (querier *querierServer) CheckPayment(ctx context.Context, req *types.CheckPaymentRequest) (*types.CheckPaymentResponse, error) {
	if req.PaymentID == "" {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "no item id is provided in path")
	}

	exist := querier.HasGoogleIAPOrder(sdk.UnwrapSDKContext(ctx), req.PaymentID)

	return &types.CheckPaymentResponse{
		PaymentID: req.PaymentID,
		Exist:     exist,
	}, nil
}
