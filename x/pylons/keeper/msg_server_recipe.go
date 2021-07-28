package keeper

import (
	"context"
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

func (k msgServer) CreateRecipe(goCtx context.Context, msg *types.MsgCreateRecipe) (*types.MsgCreateRecipeResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	// Check if the value already exists
	_, isFound := k.GetRecipe(ctx, msg.CookbookID, msg.ID)
	if isFound {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, fmt.Sprintf("recipe with ID %v in cookbook with ID %v already set", msg.ID, msg.CookbookID))
	}

	// verify that the Creator is owner of the cookbook
	cookbook, f := k.GetCookbook(ctx, msg.CookbookID)
	if !f {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "cookbook does not exist")
	}
	if cookbook.Creator != msg.Creator {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "user does not own this cookbook")
	}

	var recipe = types.Recipe{
		ID:              msg.ID,
		Creator:         msg.Creator,
		NodeVersion:     "", //TODO add logic for getting configured node version
		CookbookID:      msg.CookbookID,
		Name:            msg.Name,
		CoinInputs:      msg.CoinInputs,
		ItemInputs:      msg.ItemInputs,
		Entries:         msg.Entries,
		Outputs: 		 msg.Outputs,
		Description:     msg.Description,
		BlockInterval:   msg.BlockInterval,
		Enabled:         msg.Enabled,
		ExtraInfo:       msg.ExtraInfo,
	}

	k.SetRecipe(
		ctx,
		recipe,
	)
	return &types.MsgCreateRecipeResponse{}, nil
}

func (k msgServer) UpdateRecipe(goCtx context.Context, msg *types.MsgUpdateRecipe) (*types.MsgUpdateRecipeResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	// Check if the value exists
	valFound, isFound := k.GetRecipe(ctx, msg.CookbookID, msg.ID)
	if !isFound {
		return nil, sdkerrors.Wrap(sdkerrors.ErrKeyNotFound, fmt.Sprintf("recipe with ID %v in cookbook with ID %v not set", msg.ID, msg.CookbookID))
	}

	// Checks if the the msg sender is the same as the current owner
	if msg.Creator != valFound.Creator {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "incorrect owner")
	}

	// verify that the Creator is owner of the cookbook
	cookbook, f := k.GetCookbook(ctx, msg.CookbookID)
	if !f {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "cookbook does not exist")
	}
	if cookbook.Creator != msg.Creator {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "user does not own this cookbook")
	}

	var recipe = types.Recipe{
		ID:              msg.ID,
		Creator:         msg.Creator,
		NodeVersion:     "", //TODO add logic for getting configured node version
		CookbookID:      msg.CookbookID,
		Name:            msg.Name,
		CoinInputs:      msg.CoinInputs,
		ItemInputs:      msg.ItemInputs,
		Entries:         msg.Entries,
		Outputs: 		 msg.Outputs,
		Description:     msg.Description,
		BlockInterval:   msg.BlockInterval,
		Enabled:         msg.Enabled,
		ExtraInfo:       msg.ExtraInfo,
	}

	k.SetRecipe(ctx, recipe)

	return &types.MsgUpdateRecipeResponse{}, nil
}

