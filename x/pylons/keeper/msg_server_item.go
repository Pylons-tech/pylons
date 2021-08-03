package keeper

import (
	"context"
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k msgServer) CreateItem(goCtx context.Context, msg *types.MsgCreateItem) (*types.MsgCreateItemResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	// Check if the value already exists
	_, isFound := k.GetItem(ctx, msg.ID)
	if isFound {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, fmt.Sprintf("ID %v already set", msg.ID))
	}

	var item = types.Item{
		ID:         msg.ID,
		Creator:       msg.Creator,
		CookbookID:    msg.CookbookID,
		NodeVersion:   msg.NodeVersion,
		Doubles:       msg.Doubles,
		Longs:         msg.Longs,
		Strings:       msg.Strings,
		OwnerRecipeID: msg.OwnerRecipeID,
		OwnerTradeID:  msg.OwnerTradeID,
		Tradeable:     msg.Tradable,
		LastUpdate:    msg.LastUpdate,
		TransferFee:   msg.TransferFee,
	}

	k.SetItem(
		ctx,
		item,
	)
	return &types.MsgCreateItemResponse{}, nil
}

func (k msgServer) UpdateItem(goCtx context.Context, msg *types.MsgUpdateItem) (*types.MsgUpdateItemResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	// Check if the value exists
	valFound, isFound := k.GetItem(ctx, msg.ID)
	if !isFound {
		return nil, sdkerrors.Wrap(sdkerrors.ErrKeyNotFound, fmt.Sprintf("ID %v not set", msg.ID))
	}

	// Checks if the the msg sender is the same as the current owner
	if msg.Creator != valFound.Creator {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "incorrect owner")
	}

	var item = types.Item{
		ID:            msg.ID,
		Creator:       msg.Creator,
		CookbookID:    msg.CookbookID,
		NodeVersion:   msg.NodeVersion,
		Doubles:       msg.Doubles,
		Longs:         msg.Longs,
		Strings:       msg.Strings,
		OwnerRecipeID: msg.OwnerRecipeID,
		OwnerTradeID:  msg.OwnerTradeID,
		Tradeable:     msg.Tradable,
		LastUpdate:    msg.LastUpdate,
		TransferFee:   msg.TransferFee,
	}

	k.SetItem(ctx, item)

	return &types.MsgUpdateItemResponse{}, nil
}

func (k msgServer) DeleteItem(goCtx context.Context, msg *types.MsgDeleteItem) (*types.MsgDeleteItemResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	// Check if the value exists
	valFound, isFound := k.GetItem(ctx, msg.ID)
	if !isFound {
		return nil, sdkerrors.Wrap(sdkerrors.ErrKeyNotFound, fmt.Sprintf("ID %v not set", msg.ID))
	}

	// Checks if the the msg sender is the same as the current owner
	if msg.Creator != valFound.Creator {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "incorrect owner")
	}

	k.RemoveItem(ctx, msg.ID)

	return &types.MsgDeleteItemResponse{}, nil
}
