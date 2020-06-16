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

	// if !keeper.CoinKeeper.HasCoins(ctx, msg.Sender, msg.Amount) {
	// 	return nil, sdkerrors.Wrap(sdkerrors.ErrInsufficientFunds, "Sender does not have enough coins")

	// }
	// item, err2 := keeper.GetItem(ctx, msg.ItemID)
	// if err2 != nil {
	// 	return nil, errInternal(err)
	// }

	msg.TargetItem.Sender = msg.Sender

	if err := keeper.SetItem(ctx, msg.TargetItem); err != nil {
		return nil, errInternal(errors.New("Error updating item inside keeper"))
	}
	// err = keeper.CoinKeeper.SendCoins(ctx, msg.Sender, msg.Receiver, msg.Amount) // If so, deduct the Bid amount from the sender
	// if err != nil {
	// 	return nil, errInternal(err)
	// }

	return &sdk.Result{}, nil
}
