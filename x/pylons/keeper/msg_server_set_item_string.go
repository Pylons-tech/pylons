package keeper

import (
	"context"

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
		return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "Item with ID %v not owned by account %v", msg.ID, msg.Creator)
	}

	for i, kv := range item.MutableStrings {
		if msg.Field == kv.Key {
			item.MutableStrings[i].Value = msg.Value
			item.LastUpdate = ctx.BlockHeight()
		}
	}

	k.SetItem(ctx, item)

	// perform payment after update
	updateFee := k.Keeper.UpdateItemStringFee(ctx)
	addr, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}
	err = k.PayFees(ctx, addr, sdk.NewCoins(updateFee))
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	// TODO should this event be more fleshed out?
	err = ctx.EventManager().EmitTypedEvent(&types.EventSetItemString{
		Creator:    msg.Creator,
		CookbookID: msg.CookbookID,
		ID:         msg.ID,
	})

	return &types.MsgSetItemStringResponse{}, err
}
