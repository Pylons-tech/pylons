package handlers

import (
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

type FiatItemResponse struct {
	ItemID string `json:"ItemID"`
}

// HandlerMsgFiatItem is used to create item within 1 block execution
func HandlerMsgFiatItem(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgFiatItem) (*sdk.Result, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	// TODO: should enable it if fiat_item should only be signed by game dev
	// cook, err2 := keeper.GetCookbook(ctx, msg.CookbookID)
	// if err2 != nil {
	// 	return nil, errInternal(err2)
	// }
	// if !cook.Sender.Equals(msg.Sender) {
	// 	return sdkerrors.Wrap(sdkerrors.ErrUnauthorized,"cookbook not owned by the sender")
	// }

	item := types.NewItem(msg.CookbookID, msg.Doubles, msg.Longs, msg.Strings, msg.Sender, ctx.BlockHeight())

	if err := keeper.SetItem(ctx, *item); err != nil {
		return nil, errInternal(err)
	}

	return marshalJson(FiatItemResponse{
		item.ID,
	})
}
