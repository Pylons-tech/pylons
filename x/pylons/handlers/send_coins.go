package handlers

import (
	"context"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// SendCoins is used to transact pylons between people
func (k msgServer) SendCoins(ctx context.Context, msg *msgs.MsgSendCoins) (*msgs.MsgSendCoinsResponse, error) {
	err := msg.ValidateBasic()

	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)
	sender, _ := sdk.AccAddressFromBech32(msg.Sender)
	receiver, _ := sdk.AccAddressFromBech32(msg.Receiver)

	if !keep.HasCoins(k.Keeper, sdkCtx, sender, msg.Amount) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInsufficientFunds, "Sender does not have enough coins")
	}

	err = keep.SendCoins(k.Keeper, sdkCtx, sender, receiver, msg.Amount) // If so, deduct the Bid amount from the sender
	if err != nil {
		return nil, errInternal(err)
	}

	return &msgs.MsgSendCoinsResponse{}, nil
}
