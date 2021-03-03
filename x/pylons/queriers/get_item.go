package queriers

import (
	"context"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// query endpoints supported by the nameservice Querier
const (
	KeyGetItem = "get_item"
)

// GetItem returns a item based on the item id
func (querier *querierServer) GetItem(ctx context.Context, req *types.GetItemRequest) (*types.GetItemResponse, error) {
	if req.ItemID == "" {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "no item id is provided in path")
	}

	item, err := querier.Keeper.GetItem(sdk.UnwrapSDKContext(ctx), req.ItemID)

	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return &types.GetItemResponse{
		Item: &item,
	}, nil
}
