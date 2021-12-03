package keeper

import (
	"context"

	"github.com/rogpeppe/go-internal/semver"

	"github.com/cosmos/cosmos-sdk/telemetry"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k msgServer) CreateRecipe(goCtx context.Context, msg *types.MsgCreateRecipe) (*types.MsgCreateRecipeResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)
	// Check if the value already exists
	_, isFound := k.GetRecipe(ctx, msg.CookbookID, msg.ID)
	if isFound {
		return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "recipe with ID %v in cookbook with ID %v already set", msg.ID, msg.CookbookID)
	}

	// Check if the the msg sender is also the cookbook owner
	cookbook, f := k.GetCookbook(ctx, msg.CookbookID)
	if !f {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "cookbook does not exist")
	}
	if cookbook.Creator != msg.Creator {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "incorrect owner")
	}

	recipe := types.Recipe{
		ID:            msg.ID,
		NodeVersion:   k.EngineVersion(ctx),
		CookbookID:    msg.CookbookID,
		Name:          msg.Name,
		Version:       msg.Version,
		CoinInputs:    msg.CoinInputs,
		ItemInputs:    msg.ItemInputs,
		Entries:       msg.Entries,
		Outputs:       msg.Outputs,
		Description:   msg.Description,
		BlockInterval: msg.BlockInterval,
		CostPerBlock:  msg.CostPerBlock,
		Enabled:       msg.Enabled,
		ExtraInfo:     msg.ExtraInfo,
	}

	b := k.cdc.MustMarshal(&recipe)
	addr, _ := sdk.AccAddressFromBech32(msg.Creator)
	err := k.CalculateTxSizeFeeAndPay(ctx, b, addr)
	if err != nil {
		return nil, err
	}

	k.SetRecipe(
		ctx,
		recipe,
	)

	err = ctx.EventManager().EmitTypedEvent(&types.EventCreateRecipe{
		Creator:    cookbook.Creator,
		CookbookID: recipe.CookbookID,
		ID:         recipe.ID,
	})

	telemetry.IncrCounter(1, "recipe", "create")

	return &types.MsgCreateRecipeResponse{}, err
}

func (k msgServer) UpdateRecipe(goCtx context.Context, msg *types.MsgUpdateRecipe) (*types.MsgUpdateRecipeResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	// Check if the value exists
	origRecipe, isFound := k.GetRecipe(ctx, msg.CookbookID, msg.ID)
	if !isFound {
		return nil, sdkerrors.Wrapf(sdkerrors.ErrKeyNotFound, "recipe with ID %v in cookbook with ID %v not set", msg.ID, msg.CookbookID)
	}

	if semver.Compare(origRecipe.Version, msg.Version) != -1 {
		return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "updated recipe version %s is not newer than current version %s", msg.Version, origRecipe.Version)
	}

	// Check if the the msg sender is also the cookbook owner
	cookbook, f := k.GetCookbook(ctx, msg.CookbookID)
	if !f {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "cookbook does not exist")
	}
	if cookbook.Creator != msg.Creator {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "user does not own the cookbook")
	}

	updatedRecipe := types.Recipe{
		ID:            msg.ID,
		NodeVersion:   k.EngineVersion(ctx),
		CookbookID:    msg.CookbookID,
		Name:          msg.Name,
		Version:       msg.Version,
		CoinInputs:    msg.CoinInputs,
		ItemInputs:    msg.ItemInputs,
		Entries:       msg.Entries,
		Outputs:       msg.Outputs,
		Description:   msg.Description,
		BlockInterval: msg.BlockInterval,
		CostPerBlock:  msg.CostPerBlock,
		Enabled:       msg.Enabled,
		ExtraInfo:     msg.ExtraInfo,
	}

	b := k.cdc.MustMarshal(&updatedRecipe)
	addr, _ := sdk.AccAddressFromBech32(msg.Creator)
	err := k.CalculateTxSizeFeeAndPay(ctx, b, addr)
	if err != nil {
		return nil, err
	}

	modified, err := types.RecipeModified(origRecipe, updatedRecipe)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if modified {
		k.SetRecipe(ctx, updatedRecipe)
	}

	err = ctx.EventManager().EmitTypedEvent(&types.EventUpdateRecipe{
		OriginalRecipe: origRecipe,
	})

	telemetry.IncrCounter(1, "recipe", "update")

	return &types.MsgUpdateRecipeResponse{}, err
}
