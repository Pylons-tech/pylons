package handlers

import (
	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

func HandleMsgSendPylons(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgSendPylons) sdk.Result {

	if !keeper.CoinKeeper.HasCoins(ctx, msg.Sender, msg.Amount) {
		return sdk.ErrInsufficientCoins("Sender does not have enough coins").Result()

	}
	_, _, err := keeper.CoinKeeper.SubtractCoins(ctx, msg.Sender, msg.Amount) // If so, deduct the Bid amount from the sender
	if err != nil {
		return err.Result()
	}

	// rollback the above call if this fails
	_, _, err = keeper.CoinKeeper.AddCoins(ctx, msg.Receiver, msg.Amount) // If so, deduct the Bid amount from the sender
	if err != nil {
		return err.Result()
	}
	return sdk.Result{}
}
