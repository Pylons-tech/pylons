package pylons

import (
	"fmt"

	"github.com/MikeSofaer/pylons/x/pylons/handlers"
	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// NewHandler returns a handler for "pylons" type messages.
func NewHandler(keeper keep.Keeper) sdk.Handler {
	return func(ctx sdk.Context, msg sdk.Msg) sdk.Result {
		switch msg := msg.(type) {
		case msgs.MsgGetPylons:
			return handlers.HandleMsgGetPylons(ctx, keeper, msg)
		case msgs.MsgSendPylons:
			return handlers.HandleMsgSendPylons(ctx, keeper, msg)
		case msgs.MsgCreateCookbook:
			return handlers.HandlerMsgCreateCookbook(ctx, keeper, msg)
		case msgs.MsgUpdateCookbook:
			return handlers.HandlerMsgUpdateCookbook(ctx, keeper, msg)
		default:
			errMsg := fmt.Sprintf("unrecognized pylons Msg type: %v", msg.Type())
			return sdk.ErrUnknownRequest(errMsg).Result()
		}
	}
}
