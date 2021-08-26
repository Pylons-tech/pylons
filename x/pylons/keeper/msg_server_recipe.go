package keeper

import (
	"context"
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k msgServer) CreateRecipe(goCtx context.Context, msg *types.MsgCreateRecipe) (*types.MsgCreateRecipeResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	if len(msg.Name) < int(k.MinNameFieldLength(ctx)) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "recipe name should have more than 8 characters")
	}

	if len(msg.Description) < int(k.MinDescriptionFieldLength(ctx)) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "recipe description should have more than 20 characters")
	}

	// check if coin outputs are not valid
	coinDenoms := k.GetBasicCoinDenoms(ctx)
	for _, denom := range coinDenoms {
		for _, outCoin := range msg.Entries.CoinOutputs {
			if outCoin.Coin.Denom == denom {
				return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "recipe cannot have %v as output coin", denom)
			}
		}
	}

	// Check if the value already exists
	_, isFound := k.GetRecipe(ctx, msg.CookbookID, msg.ID)
	if isFound {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, fmt.Sprintf("recipe with ID %v in cookbook with ID %v already set", msg.ID, msg.CookbookID))
	}

	// Check if the the msg sender is also the cookbook owner
	cookbook, f := k.GetCookbook(ctx, msg.CookbookID)
	if !f {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "cookbook does not exist")
	}
	if cookbook.Creator != msg.Creator {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "incorrect owner")
	}

	var recipe = types.Recipe{
		ID:            msg.ID,
		NodeVersion:   types.GetNodeVersionString(),
		CookbookID:    msg.CookbookID,
		Name:          msg.Name,
		Version:       msg.Version,
		CoinInputs:    msg.CoinInputs,
		ItemInputs:    msg.ItemInputs,
		Entries:       msg.Entries,
		Outputs:       msg.Outputs,
		Description:   msg.Description,
		BlockInterval: msg.BlockInterval,
		Enabled:       msg.Enabled,
		ExtraInfo:     msg.ExtraInfo,
	}

	k.SetRecipe(
		ctx,
		recipe,
	)

	// TODO should this event be more fleshed out?
	err := ctx.EventManager().EmitTypedEvent(&types.EventCreateRecipe{
		Creator:    cookbook.Creator,
		CookbookID: recipe.ID,
		ID:         recipe.ID,
	})

	return &types.MsgCreateRecipeResponse{}, err
}

func (k msgServer) UpdateRecipe(goCtx context.Context, msg *types.MsgUpdateRecipe) (*types.MsgUpdateRecipeResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	if len(msg.Name) < int(k.MinNameFieldLength(ctx)) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "recipe name should have more than 8 characters")
	}

	if len(msg.Description) < int(k.MinDescriptionFieldLength(ctx)) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "recipe description should have more than 20 characters")
	}

	// check if coin outputs are not valid
	coinDenoms := k.GetBasicCoinDenoms(ctx)
	for _, denom := range coinDenoms {
		for _, outCoin := range msg.Entries.CoinOutputs {
			if outCoin.Coin.Denom == denom {
				return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "recipe cannot have %v as output coin", denom)
			}
		}
	}

	// Check if the value exists
	origRecipe, isFound := k.GetRecipe(ctx, msg.CookbookID, msg.ID)
	if !isFound {
		return nil, sdkerrors.Wrap(sdkerrors.ErrKeyNotFound, fmt.Sprintf("recipe with ID %v in cookbook with ID %v not set", msg.ID, msg.CookbookID))
	}

	// Check if the the msg sender is also the cookbook owner
	cookbook, f := k.GetCookbook(ctx, msg.CookbookID)
	if !f {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "cookbook does not exist")
	}
	if cookbook.Creator != msg.Creator {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "user does not own the cookbook")
	}

	var updatedRecipe = types.Recipe{
		ID:            msg.ID,
		NodeVersion:   types.GetNodeVersionString(),
		CookbookID:    msg.CookbookID,
		Name:          msg.Name,
		Version:       msg.Version,
		CoinInputs:    msg.CoinInputs,
		ItemInputs:    msg.ItemInputs,
		Entries:       msg.Entries,
		Outputs:       msg.Outputs,
		Description:   msg.Description,
		BlockInterval: msg.BlockInterval,
		Enabled:       msg.Enabled,
		ExtraInfo:     msg.ExtraInfo,
	}

	modified, err := types.RecipeModified(origRecipe, updatedRecipe)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if modified {
		k.SetRecipe(ctx, updatedRecipe)
	}

	// TODO should this event be more fleshed out?
	err = ctx.EventManager().EmitTypedEvent(&types.EventUpdateRecipe{
		Creator:    cookbook.Creator,
		CookbookID: updatedRecipe.ID,
		ID:         updatedRecipe.ID,
	})

	return &types.MsgUpdateRecipeResponse{}, err
}
