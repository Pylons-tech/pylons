package pylons

import (
	"fmt"
	"math/rand"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/google/uuid"
)

// NewHandler returns a handler for "pylons" type messages.
func NewHandler(keeper keep.Keeper) sdk.Handler {
	return func(ctx sdk.Context, msg sdk.Msg) (*sdk.Result, error) {
		// set random seed before running handlers
		rand.Seed(types.RandomSeed(ctx, keeper.GetEntityCount(ctx)))
		// set entropy reader for uuid before running handlers
		uuid.SetRand(types.NewEntropyReader())

		// handle custom messages
		switch msg := msg.(type) {
		case msgs.MsgCreateAccount:
			return handlers.HandlerMsgCreateAccount(ctx, keeper, msg)
		case msgs.MsgGetPylons:
			return handlers.HandlerMsgGetPylons(ctx, keeper, msg)
		case msgs.MsgGoogleIAPGetPylons:
			return handlers.HandlerMsgGoogleIAPGetPylons(ctx, keeper, msg)
		case msgs.MsgSendCoins:
			return handlers.HandlerMsgSendCoins(ctx, keeper, msg)
		case msgs.MsgSendItems:
			return handlers.HandlerMsgSendItems(ctx, keeper, msg)
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
			return handlers.HandlerMsgUpdateItemString(ctx, keeper, msg)
		case msgs.MsgCreateTrade:
			return handlers.HandlerMsgCreateTrade(ctx, keeper, msg)
		case msgs.MsgFulfillTrade:
			return handlers.HandlerMsgFulfillTrade(ctx, keeper, msg)
		case msgs.MsgDisableTrade:
			return handlers.HandlerMsgDisableTrade(ctx, keeper, msg)
		case msgs.MsgEnableTrade:
			return handlers.HandlerMsgEnableTrade(ctx, keeper, msg)
		default:
			return nil, sdkerrors.Wrap(sdkerrors.ErrUnknownRequest, fmt.Sprintf("Unrecognized pylons Msg type: %v", msg.Type()))
		}
	}
}
