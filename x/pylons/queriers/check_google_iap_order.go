package queriers

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// query endpoints supported by the nameservice Querier
const (
	KeyCheckGoogleIAPOrder = "check_google_iap_order"
)

// CheckGoogleIAPOrder check if google iap order is given to user with purchase token
func (querier *querierServer) CheckGoogleIAPOrder(ctx context.Context, req *types.CheckGoogleIAPOrderRequest) (*types.CheckGoogleIAPOrderResponse, error) {
	if req.PurchaseToken == "" {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "no item id is provided in path")
	}

	exist := querier.HasGoogleIAPOrder(sdk.UnwrapSDKContext(ctx), req.PurchaseToken)

	return &types.CheckGoogleIAPOrderResponse{
		PurchaseToken: req.PurchaseToken,
		Exist:         exist,
	}, nil
}
