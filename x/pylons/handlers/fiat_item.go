package handlers

import (
	"encoding/json"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

type FiatItemResponse struct {
	ItemID string `json:"ItemID"`
}

// HandlerMsgFiatItem is used to get item within 1 block execution
func HandlerMsgFiatItem(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgFiatItem) sdk.Result {
	err := msg.ValidateBasic()
	if err != nil {
		return err.Result()
	}
	cook, err2 := keeper.GetCookbook(ctx, msg.CookbookID)
	if !cook.Sender.Equals(msg.Sender) {
		return sdk.ErrUnauthorized("cookbook not owned by the sender").Result()
	}

	item := types.NewItem(msg.CookbookID, msg.Doubles, msg.Longs, msg.Strings, msg.Sender)

	if err := keeper.SetItem(ctx, *item); err != nil {
		return sdk.ErrInternal(err.Error()).Result()
	}

	mItem, err2 := json.Marshal(map[string]string{
		"ItemID": item.ID,
	})

	if err2 != nil {
		return sdk.ErrInternal(err2.Error()).Result()
	}

	return sdk.Result{Data: mItem}
}
