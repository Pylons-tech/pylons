package queriers

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// CheckStripePOrder check if stripe order is given to user with purchase token
func (querier *querierServer) CheckStripeOrder(ctx context.Context, req *types.CheckStripeOrderRequest) (*types.CheckStripeOrderResponse, error) {
	if req.PurchaseToken == "" {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "no item id is provided in path")
	}

	exist := querier.HasStripeOrder(sdk.UnwrapSDKContext(ctx), req.PurchaseToken)

	return &types.CheckStripeOrderResponse{
		PurchaseToken: req.PurchaseToken,
		Exist:         exist,
	}, nil
}
