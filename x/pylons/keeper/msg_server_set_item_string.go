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

	// TODO handle UpdateFee

	for i, kv := range item.MutableStrings {
		if msg.Field == kv.Key {
			item.MutableStrings[i].Value = msg.Value
			item.LastUpdate = uint64(ctx.BlockHeight())
			k.SetItem(ctx, item)
			return &types.MsgSetItemStringResponse{}, nil
		}
	}

	return nil, sdkerrors.Wrap(types.ErrInvalidRequestField, "string field not found")
}
