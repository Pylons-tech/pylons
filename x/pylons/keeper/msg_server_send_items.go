package keeper

import (
	"context"
	"fmt"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k msgServer) SendItems(goCtx context.Context, msg *types.MsgSendItems) (*types.MsgSendItemsResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	// STATEFUL CHECKS
	for _, itemID := range msg.ItemIDs {
		// check it item exists and if it is owned by message creator
		item, found := k.Keeper.GetItem(ctx, msg.CookbookID, itemID)
		if !found {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "item does not exist")
		}

		// check if item is owned by msg.Creator if not ERROR
		if item.Owner != msg.Creator {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, fmt.Sprintf("Item with ID %v not owned by account %v", itemID, msg.Creator))
		}
	}

	// Get item from keeper, change owner to receiver and re-set in store
	for _, itemID := range msg.ItemIDs {
		// get item
		item, _ := k.Keeper.GetItem(ctx, msg.CookbookID, itemID)
		item.Owner = msg.Receiver
		k.Keeper.SetItem(ctx, item)
	}

	return &types.MsgSendItemsResponse{}, nil
}
