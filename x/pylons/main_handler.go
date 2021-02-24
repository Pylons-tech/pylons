package pylons

import (
	"fmt"
	"math/rand"

	"github.com/Pylons-tech/pylons/x/pylons/config"
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
	msgServer := handlers.NewMsgServerImpl(keeper)

	return func(ctx sdk.Context, msg sdk.Msg) (*sdk.Result, error) {
		// set random seed before running handlers
		rand.Seed(types.RandomSeed(ctx, keeper.GetEntityCount(ctx)))
		// set entropy reader for uuid before running handlers
		uuid.SetRand(types.NewEntropyReader())

		ctx = ctx.WithEventManager(sdk.NewEventManager())

		// handle custom messages
		switch msg := msg.(type) {
		case *msgs.MsgCreateAccount:
			res, err := msgServer.HandlerMsgCreateAccount(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *msgs.MsgGetPylons:
			if config.Config.IsProduction {
				return nil, sdkerrors.Wrap(sdkerrors.ErrUnknownRequest, "MsgGetPylons is only supported on development mode")
			}
			res, err := msgServer.HandlerMsgGetPylons(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *msgs.MsgGoogleIAPGetPylons:
			res, err := msgServer.HandlerMsgGoogleIAPGetPylons(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *msgs.MsgSendCoins:
			res, err := msgServer.HandlerMsgSendCoins(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *msgs.MsgSendItems:
			res, err := msgServer.HandlerMsgSendItems(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *msgs.MsgCreateCookbook:
			res, err := msgServer.HandlerMsgCreateCookbook(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *msgs.MsgUpdateCookbook:
			res, err := msgServer.HandlerMsgUpdateCookbook(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *msgs.MsgCreateRecipe:
			res, err := msgServer.HandlerMsgCreateRecipe(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *msgs.MsgUpdateRecipe:
			res, err := msgServer.HandlerMsgUpdateRecipe(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *msgs.MsgExecuteRecipe:
			res, err := msgServer.HandlerMsgExecuteRecipe(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *msgs.MsgDisableRecipe:
			res, err := msgServer.HandlerMsgDisableRecipe(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *msgs.MsgEnableRecipe:
			res, err := msgServer.HandlerMsgEnableRecipe(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *msgs.MsgCheckExecution:
			res, err := msgServer.HandlerMsgCheckExecution(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *msgs.MsgFiatItem:
			if config.Config.IsProduction {
				return nil, sdkerrors.Wrap(sdkerrors.ErrUnknownRequest, "MsgFiatItem is only supported on development mode")
			}
			res, err := msgServer.HandlerMsgFiatItem(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *msgs.MsgUpdateItemString:
			res, err := msgServer.HandlerMsgUpdateItemString(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *msgs.MsgCreateTrade:
			res, err := msgServer.HandlerMsgCreateTrade(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *msgs.MsgFulfillTrade:
			res, err := msgServer.HandlerMsgFulfillTrade(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *msgs.MsgDisableTrade:
			res, err := msgServer.HandlerMsgDisableTrade(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *msgs.MsgEnableTrade:
			res, err := msgServer.HandlerMsgEnableTrade(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		default:
			return nil, sdkerrors.Wrap(sdkerrors.ErrUnknownRequest, fmt.Sprintf("Unrecognized pylons Msg type: %v", msg.Type()))
		}
	}
}
