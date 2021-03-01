package handlers

import (
	"context"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// HandlerMsgFiatItem is used to create item within 1 block execution
func (k msgServer) HandlerMsgFiatItem(ctx context.Context, msg *msgs.MsgFiatItem) (*msgs.MsgFiatItemResponse, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)
	sender, _ := sdk.AccAddressFromBech32(msg.Sender)

	// TODO: should enable it if fiat_item should only be signed by game dev
	// cook, err := keeper.GetCookbook(ctx, msg.CookbookID)
	// if err != nil {
	// 	return nil, errInternal(err)
	// }
	// if !cook.Sender.Equals(msg.Sender) {
	// 	return sdkerrors.Wrap(sdkerrors.ErrUnauthorized,"cookbook not owned by the sender")
	// }

	item := types.NewItem(msg.CookbookID, msg.Doubles, msg.Longs, msg.Strings, sender, sdkCtx.BlockHeight(), msg.TransferFee)

	if err := k.SetItem(sdkCtx, *item); err != nil {
		return nil, errInternal(err)
	}

	return &msgs.MsgFiatItemResponse{
		ItemID:  item.ID,
		Message: "successfully created an item",
		Status:  "Success",
	}, nil
}
