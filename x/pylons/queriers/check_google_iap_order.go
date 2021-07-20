package queriers

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// CheckGoogleIapOrder check if google iap order is given to user with purchase token
func (querier *querierServer) CheckGoogleIapOrder(ctx context.Context, req *types.CheckGoogleIapOrderRequest) (*types.CheckGoogleIapOrderResponse, error) {
	if req.PurchaseToken == "" {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "no item id is provided in path")
	}

	exist := querier.HasGoogleIAPOrder(sdk.UnwrapSDKContext(ctx), req.PurchaseToken)

	return &types.CheckGoogleIapOrderResponse{
		PurchaseToken: req.PurchaseToken,
		Exist:         exist,
	}, nil
}
