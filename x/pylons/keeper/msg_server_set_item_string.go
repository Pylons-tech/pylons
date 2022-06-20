package keeper

import (
	"context"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k msgServer) SetItemString(goCtx context.Context, msg *types.MsgSetItemString) (*types.MsgSetItemStringResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)
	item, found := k.GetItem(ctx, msg.CookbookId, msg.Id)
	if !found {
		return nil, sdkerrors.Wrap(sdkerrors.ErrKeyNotFound, "item not found")
	}

	// check if item owned by msg.Creator
	if item.Owner != msg.Creator {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "unauthorized")
	}

	originalMutableStrings := make([]types.StringKeyValue, len(item.MutableStrings))
	copy(originalMutableStrings, item.MutableStrings)

	for i, kv := range originalMutableStrings {
		if msg.Field == kv.Key {
			item.MutableStrings[i].Value = msg.Value
			item.LastUpdate = ctx.BlockHeight()
		}
	}

	k.SetItem(ctx, item)

	// perform payment after update
	updateFee := k.Keeper.UpdateItemStringFee(ctx)
	addr, _ := sdk.AccAddressFromBech32(msg.Creator)
	err := k.PayFees(ctx, addr, sdk.NewCoins(updateFee))
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	err = ctx.EventManager().EmitTypedEvent(&types.EventSetItemString{
		Creator:                msg.Creator,
		CookbookId:             msg.CookbookId,
		Id:                     msg.Id,
		OriginalMutableStrings: originalMutableStrings,
	})

	return &types.MsgSetItemStringResponse{}, err
}
