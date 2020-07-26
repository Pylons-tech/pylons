package handlers

import (
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// HandlerMsgSendPylons is used to transact pylons between people
func HandlerMsgSendPylons(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgSendPylons) (*sdk.Result, error) {

	err := msg.ValidateBasic()

	if err != nil {
		return nil, errInternal(err)
	}

	if !keep.HasCoins(keeper, ctx, msg.Sender, msg.Amount) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInsufficientFunds, "Sender does not have enough coins")
	}

	err = keep.SendCoins(keeper, ctx, msg.Sender, msg.Receiver, msg.Amount) // If so, deduct the Bid amount from the sender
	if err != nil {
		return nil, errInternal(err)
	}

	return &sdk.Result{}, nil
}
