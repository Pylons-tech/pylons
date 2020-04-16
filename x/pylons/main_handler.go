package pylons

import (
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"

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
		case msgs.MsgCreateRecipe:
			return handlers.HandlerMsgCreateRecipe(ctx, keeper, msg)
		case msgs.MsgUpdateRecipe:
			return handlers.HandlerMsgUpdateRecipe(ctx, keeper, msg)
		case msgs.MsgExecuteRecipe:
			return handlers.HandlerMsgExecuteRecipe(ctx, keeper, msg)
		case msgs.MsgDisableRecipe:
			return handlers.HandlerMsgDisableRecipe(ctx, keeper, msg)
		case msgs.MsgEnableRecipe:
			return handlers.HandlerMsgEnableRecipe(ctx, keeper, msg)
		case msgs.MsgCheckExecution:
			return handlers.HandlerMsgCheckExecution(ctx, keeper, msg)
		case msgs.MsgFiatItem:
			return handlers.HandlerMsgFiatItem(ctx, keeper, msg)
		case msgs.MsgUpdateItemString:
			return handlers.HandleMsgUpdateItemString(ctx, keeper, msg)
		case msgs.MsgCreateTrade:
			return handlers.HandlerMsgCreateTrade(ctx, keeper, msg)
		case msgs.MsgFulfillTrade:
			return handlers.HandlerMsgFulfillTrade(ctx, keeper, msg)
		case msgs.MsgDisableTrade:
			return handlers.HandlerMsgDisableTrade(ctx, keeper, msg)
		case msgs.MsgEnableTrade:
			return handlers.HandlerMsgEnableTrade(ctx, keeper, msg)
		default:
			errMsg := fmt.Sprintf("unrecognized pylons Msg type: %v", msg.Type())
			return sdk.ErrUnknownRequest(errMsg).Result()
		}
	}
}
