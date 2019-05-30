package handlers

import (
	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

func HandleMsgGetPylons(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgGetPylons) sdk.Result {

	// TODO: filter pylons out of all the coins
	_, _, err := keeper.CoinKeeper.AddCoins(ctx, msg.Requester, msg.Amount) // If so, deduct the Bid amount from the sender
	if err != nil {
		return sdk.ErrInsufficientCoins("Buyer does not have enough coins").Result()
	}
	return sdk.Result{}
}
