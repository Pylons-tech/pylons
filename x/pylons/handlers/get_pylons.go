package handlers

import (
	"math/rand"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// HandleMsgGetPylons is used to send pylons to requesters. This handler is part of the
// faucet
func HandleMsgGetPylons(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgGetPylons) (*sdk.Result, error) {
	// set random seed at the start point of handler
	rand.Seed(types.RandomSeed(ctx))
	
	err := msg.ValidateBasic()

	if err != nil {
		return nil, errInternal(err)
	}
	// TODO: filter pylons out of all the coins
	_, err = keeper.CoinKeeper.AddCoins(ctx, msg.Requester, msg.Amount) // If so, deduct the Bid amount from the sender
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInsufficientFunds, "Buyer does not have enough coins")
	}

	return &sdk.Result{}, nil
}
