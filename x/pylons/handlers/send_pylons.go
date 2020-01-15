package handlers

import (
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// HandleMsgSendPylons is used to transact pylons between people
func HandleMsgSendPylons(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgSendPylons) sdk.Result {

	err := msg.ValidateBasic()

	if err != nil {
		return err.Result()
	}

	if !keeper.CoinKeeper.HasCoins(ctx, msg.Sender, msg.Amount) {
		return sdk.ErrInsufficientCoins("Sender does not have enough coins").Result()

	}
	_, err = keeper.CoinKeeper.SendCoins(ctx, msg.Sender, msg.Receiver, msg.Amount) // If so, deduct the Bid amount from the sender
	if err != nil {
		return err.Result()
	}

	return sdk.Result{}
}
