package keeper

import (
	"context"
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k msgServer) SetItemString(goCtx context.Context, msg *types.MsgSetItemString) (*types.MsgSetItemStringResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)
	item, found := k.GetItem(ctx, msg.CookbookID, msg.ID)
	if !found {
		return nil, sdkerrors.Wrap(sdkerrors.ErrKeyNotFound, "item not found")
	}

	// check if item is owned by msg.Creator if not ERROR
	if item.Owner != msg.Creator {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, fmt.Sprintf("Item with ID %v not owned by account %v", msg.ID, msg.Creator))
	}

	for i, kv := range item.MutableStrings {
		if msg.Field == kv.Key {
			item.MutableStrings[i].Value = msg.Value
			item.LastUpdate = uint64(ctx.BlockHeight())
			k.SetItem(ctx, item)
			return &types.MsgSetItemStringResponse{}, nil
		}
	}

	// perform payment after update
	updateFee := k.Keeper.UpdateItemStringFee(ctx)
	addr, _ := sdk.AccAddressFromBech32(msg.Creator)
	err := k.PayFees(ctx, addr, sdk.NewCoins(updateFee))
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return nil, sdkerrors.Wrap(types.ErrInvalidRequestField, "string field not found")
}
