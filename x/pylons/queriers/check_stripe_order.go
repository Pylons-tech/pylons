package queriers

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// CheckStripePOrder check if stripe order is given to user with purchase token
func (querier *querierServer) CheckStripeOrder(ctx context.Context, req *types.CheckStripeOrderRequest) (*types.CheckStripeOrderResponse, error) {
	if req.PaymentId == "" {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "no item id is provided in path")
	}

	if req.PaymentMethod == "" {
		req.PaymentMethod = "card"
	}

	exist := querier.HasStripeOrder(sdk.UnwrapSDKContext(ctx), req.PaymentId)

	return &types.CheckStripeOrderResponse{
		PaymentId:     req.PaymentId,
		PaymentMethod: req.PaymentMethod,
		Exist:         exist,
	}, nil
}
