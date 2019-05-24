package pylons

import (
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// NewHandler returns a handler for "pylons" type messages.
func NewHandler(keeper Keeper) sdk.Handler {
	return func(ctx sdk.Context, msg sdk.Msg) sdk.Result {
		switch msg := msg.(type) {
		case MsgGetPylons:
			return handleMsgGetPylons(ctx, keeper, msg)
		default:
			errMsg := fmt.Sprintf("Unrecognized pylons Msg type: %v", msg.Type())
			return sdk.ErrUnknownRequest(errMsg).Result()
		}
	}
}

func handleMsgGetPylons(ctx sdk.Context, keeper Keeper, msg MsgGetPylons) sdk.Result {

	// TODO: filter pylons out of all the coins
	_, _, err := keeper.coinKeeper.AddCoins(ctx, msg.Requester, msg.Amount) // If so, deduct the Bid amount from the sender
	if err != nil {
		return sdk.ErrInsufficientCoins("Buyer does not have enough coins").Result()
	}
	return sdk.Result{}
}
