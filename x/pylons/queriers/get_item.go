package queriers

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
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
		Item: item,
	}, nil
}

// ItemsBySender returns all items based on the sender address
func (querier *querierServer) ItemsBySender(ctx context.Context, req *types.ItemsBySenderRequest) (*types.ItemsBySenderResponse, error) {
	var err error
	var senderAddr sdk.AccAddress

	if req.Sender != "" {
		senderAddr, err = sdk.AccAddressFromBech32(req.Sender)

		if err != nil {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
	}

	items, err := querier.Keeper.GetItemsBySender(sdk.UnwrapSDKContext(ctx), senderAddr)

	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return &types.ItemsBySenderResponse{Items: items}, nil
}

// ItemsByCookbook returns a cookbook based on the cookbook id
func (querier *querierServer) ItemsByCookbook(ctx context.Context, req *types.ItemsByCookbookRequest) (*types.ItemsByCookbookResponse, error) {
	if req.CookbookID == "" {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "no cookbook id is provided in path")
	}

	items, err := querier.Keeper.ItemsByCookbook(sdk.UnwrapSDKContext(ctx), req.CookbookID)

	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return &types.ItemsByCookbookResponse{
		Items: items,
	}, nil
}
