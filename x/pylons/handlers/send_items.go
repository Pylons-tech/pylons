package handlers

import (
	"errors"
	"strings"

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

	itemIDsArray := strings.Split(msg.ItemID, ",")

	for _, val := range itemIDsArray {
		item, err2 := keeper.GetItem(ctx, val)
		if err2 != nil {
			return nil, errInternal(err)
		}

		if item.Sender.String() != msg.Sender.String() {
			return nil, errInternal(errors.New("Item is not the Sender's one"))
		}

		item.Sender = msg.Receiver
		if err := keeper.SetItem(ctx, item); err != nil {
			return nil, errInternal(errors.New("Error updating item inside keeper"))
		}
	}

	return &sdk.Result{}, nil
}
