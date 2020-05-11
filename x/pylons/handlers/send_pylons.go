package handlers

import (
	"math/rand"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// HandleMsgSendPylons is used to transact pylons between people
func HandleMsgSendPylons(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgSendPylons) (*sdk.Result, error) {
	// set random seed at the start point of handler
	rand.Seed(types.RandomSeed(ctx))
	
	err := msg.ValidateBasic()

	if err != nil {
		return nil, errInternal(err)
	}

	if !keeper.CoinKeeper.HasCoins(ctx, msg.Sender, msg.Amount) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInsufficientFunds, "Sender does not have enough coins")

	}
	err = keeper.CoinKeeper.SendCoins(ctx, msg.Sender, msg.Receiver, msg.Amount) // If so, deduct the Bid amount from the sender
	if err != nil {
		return nil, errInternal(err)
	}

	return &sdk.Result{}, nil
}
