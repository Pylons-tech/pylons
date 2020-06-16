package handlers

import (
	"errors"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// HandlerMsgSendItems is used to send items between people
func HandlerMsgSendItems(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgSendItems) (*sdk.Result, error) {

	err := msg.ValidateBasic()

	if err != nil {
		return nil, errInternal(err)
	}

	for _, val := range msg.ItemIDs {
		item, err := keeper.GetItem(ctx, val)
		if err != nil {
			return nil, errInternal(err)
		}

		if item.Sender.String() != msg.Sender.String() {
			return nil, errInternal(errors.New("Item is not the sender's one"))
		}

		item.Sender = msg.Receiver
		if err := keeper.SetItem(ctx, item); err != nil {
			return nil, errInternal(errors.New("Error updating item inside keeper"))
		}
	}

	return &sdk.Result{}, nil
}
