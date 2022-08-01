package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	"github.com/rogpeppe/go-internal/semver"

	"github.com/cosmos/cosmos-sdk/telemetry"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

func (k msgServer) CreateRecipe(goCtx context.Context, msg *v1beta1.MsgCreateRecipe) (*v1beta1.MsgCreateRecipeResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)
	var err error
	// Check if the value already exists
	_, isFound := k.GetRecipe(ctx, msg.CookbookId, msg.Id)
	if isFound {
		return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "recipe with ID %v in cookbook with ID %v already set", msg.Id, msg.CookbookId)
	}

	// Check if the the msg sender is also the cookbook owner
	cookbook, f := k.GetCookbook(ctx, msg.CookbookId)
	if !f {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "cookbook does not exist")
	}
	if cookbook.Creator != msg.Creator {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "incorrect owner")
	}

	recipe := v1beta1.Recipe{
		Id:            msg.Id,
		NodeVersion:   k.EngineVersion(ctx),
		CookbookId:    msg.CookbookId,
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
		CreatedAt:     ctx.BlockTime().Unix(),
		UpdatedAt:     ctx.BlockTime().Unix(),
	}

	k.SetRecipe(
		ctx,
		recipe,
	)

	err = ctx.EventManager().EmitTypedEvent(&v1beta1.EventCreateRecipe{
		Creator:    cookbook.Creator,
		CookbookId: recipe.CookbookId,
		Id:         recipe.Id,
	})

	telemetry.IncrCounter(1, "recipe", "create")

	return &v1beta1.MsgCreateRecipeResponse{}, err
}

func (k msgServer) UpdateRecipe(goCtx context.Context, msg *v1beta1.MsgUpdateRecipe) (*v1beta1.MsgUpdateRecipeResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	// Check if the value exists
	origRecipe, isFound := k.GetRecipe(ctx, msg.CookbookId, msg.Id)
	if !isFound {
		return nil, sdkerrors.Wrapf(sdkerrors.ErrKeyNotFound, "recipe with ID %v in cookbook with ID %v not set", msg.Id, msg.CookbookId)
	}

	if semver.Compare(origRecipe.Version, msg.Version) != -1 {
		return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "updated recipe version %s is not newer than current version %s", msg.Version, origRecipe.Version)
	}

	// Check if the the msg sender is also the cookbook owner
	cookbook, f := k.GetCookbook(ctx, msg.CookbookId)
	if !f {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "cookbook does not exist")
	}
	if cookbook.Creator != msg.Creator {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "user does not own the cookbook")
	}

	updatedRecipe := v1beta1.Recipe{
		Id:            msg.Id,
		NodeVersion:   k.EngineVersion(ctx),
		CookbookId:    msg.CookbookId,
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
		CreatedAt:     origRecipe.CreatedAt,
		UpdatedAt:     ctx.BlockTime().Unix(),
	}

	modified, err := v1beta1.RecipeModified(origRecipe, updatedRecipe)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if modified {
		k.SetRecipe(ctx, updatedRecipe)
	}

	err = ctx.EventManager().EmitTypedEvent(&v1beta1.EventUpdateRecipe{
		OriginalRecipe: origRecipe,
	})

	telemetry.IncrCounter(1, "recipe", "update")

	return &v1beta1.MsgUpdateRecipeResponse{}, err
}
