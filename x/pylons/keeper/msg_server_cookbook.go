package keeper

import (
	"context"

	"github.com/cosmos/cosmos-sdk/telemetry"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k msgServer) CreateCookbook(goCtx context.Context, msg *types.MsgCreateCookbook) (*types.MsgCreateCookbookResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)
	// Check if the value already exists
	_, isFound := k.GetCookbook(ctx, msg.ID)
	if isFound {
		return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "ID %v already set", msg.ID)
	}

	cookbook := types.Cookbook{
		ID:           msg.ID,
		Creator:      msg.Creator,
		NodeVersion:  k.EngineVersion(ctx),
		Name:         msg.Name,
		Description:  msg.Description,
		Developer:    msg.Developer,
		Version:      msg.Version,
		SupportEmail: msg.SupportEmail,
		Enabled:      msg.Enabled,
	}

	b := k.cdc.MustMarshal(&cookbook)
	addr, _ := sdk.AccAddressFromBech32(cookbook.Creator)
	fee := types.CalculateTxSizeFee(b, types.DefaultSizeLimitBytes, types.DefaultFeePerBytes)
	if fee > 0 {
		// charge fee
		coins := sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(int64(fee))))
		err := k.bankKeeper.SendCoinsFromAccountToModule(ctx, addr, types.FeeCollectorName, coins)
		if err != nil {
			return nil, sdkerrors.Wrapf(sdkerrors.ErrInsufficientFunds, "unable to pay sizeOver fee of %d%s", fee, types.PylonsCoinDenom)
		}
	}

	k.SetCookbook(
		ctx,
		cookbook,
	)

	err := ctx.EventManager().EmitTypedEvent(&types.EventCreateCookbook{
		Creator: cookbook.Creator,
		ID:      cookbook.ID,
	})

	telemetry.IncrCounter(1, "cookbook", "create")

	return &types.MsgCreateCookbookResponse{}, err
}

func (k msgServer) UpdateCookbook(goCtx context.Context, msg *types.MsgUpdateCookbook) (*types.MsgUpdateCookbookResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	// Check if the value exists
	origCookbook, isFound := k.GetCookbook(ctx, msg.ID)
	if !isFound {
		return nil, sdkerrors.Wrapf(sdkerrors.ErrKeyNotFound, "ID %v not set", msg.ID)
	}

	// Check if the msg sender is the same as the current owner
	if msg.Creator != origCookbook.Creator {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "incorrect owner")
	}

	updatedCookbook := types.Cookbook{
		ID:           msg.ID,
		Creator:      msg.Creator,
		NodeVersion:  k.EngineVersion(ctx),
		Name:         msg.Name,
		Description:  msg.Description,
		Developer:    msg.Developer,
		Version:      msg.Version,
		SupportEmail: msg.SupportEmail,
	}

	b := k.cdc.MustMarshal(&updatedCookbook)
	addr, _ := sdk.AccAddressFromBech32(updatedCookbook.Creator)
	fee := types.CalculateTxSizeFee(b, types.DefaultSizeLimitBytes, types.DefaultFeePerBytes)
	if fee > 0 {
		// charge fee
		coins := sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(int64(fee))))
		err := k.bankKeeper.SendCoinsFromAccountToModule(ctx, addr, types.FeeCollectorName, coins)
		if err != nil {
			return nil, sdkerrors.Wrapf(sdkerrors.ErrInsufficientFunds, "unable to pay sizeOver fee of %d%s", fee, types.PylonsCoinDenom)
		}
	}

	modified, err := types.CookbookModified(origCookbook, updatedCookbook)
	if err != nil {
		return nil, err
	}

	if modified {
		k.SetCookbook(ctx, updatedCookbook)
	}

	err = ctx.EventManager().EmitTypedEvent(&types.EventUpdateCookbook{
		OriginalCookbook: origCookbook,
	})

	telemetry.IncrCounter(1, "cookbook", "update")

	return &types.MsgUpdateCookbookResponse{}, err
}
