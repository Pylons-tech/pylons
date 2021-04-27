package pylons

import (
	"fmt"
	"math/rand"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
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
		case *types.MsgCreateAccount:
			res, err := msgServer.CreateAccount(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *types.MsgGetPylons:
			if config.Config.IsProduction {
				return nil, sdkerrors.Wrap(sdkerrors.ErrUnknownRequest, "MsgGetPylons is only supported on development mode")
			}
			res, err := msgServer.GetPylons(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *types.MsgGoogleIAPGetPylons:
			res, err := msgServer.GoogleIAPGetPylons(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *types.MsgSendCoins:
			res, err := msgServer.SendCoins(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *types.MsgSendItems:
			res, err := msgServer.SendItems(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *types.MsgCreateCookbook:
			res, err := msgServer.CreateCookbook(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *types.MsgUpdateCookbook:
			res, err := msgServer.HandlerMsgUpdateCookbook(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *types.MsgCreateRecipe:
			res, err := msgServer.CreateRecipe(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *types.MsgUpdateRecipe:
			res, err := msgServer.HandlerMsgUpdateRecipe(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *types.MsgExecuteRecipe:
			res, err := msgServer.ExecuteRecipe(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *types.MsgDisableRecipe:
			res, err := msgServer.DisableRecipe(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *types.MsgEnableRecipe:
			res, err := msgServer.EnableRecipe(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *types.MsgCheckExecution:
			res, err := msgServer.CheckExecution(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *types.MsgFiatItem:
			if config.Config.IsProduction {
				return nil, sdkerrors.Wrap(sdkerrors.ErrUnknownRequest, "MsgFiatItem is only supported on development mode")
			}
			res, err := msgServer.FiatItem(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *types.MsgUpdateItemString:
			res, err := msgServer.UpdateItemString(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *types.MsgCreateTrade:
			res, err := msgServer.CreateTrade(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *types.MsgFulfillTrade:
			res, err := msgServer.FulfillTrade(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *types.MsgDisableTrade:
			res, err := msgServer.DisableTrade(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		case *types.MsgEnableTrade:
			res, err := msgServer.EnableTrade(sdk.WrapSDKContext(ctx), msg)
			return sdk.WrapServiceResult(ctx, res, err)

		default:
			return nil, sdkerrors.Wrap(sdkerrors.ErrUnknownRequest, fmt.Sprintf("Unrecognized pylons Msg type: %v", msg.Type()))
		}
	}
}
