package handlers

import (
	"context"
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// CreateRecipe is used to create recipe by a developer
func (srv msgServer) CreateRecipe(ctx context.Context, msg *types.MsgCreateRecipe) (*types.MsgCreateRecipeResponse, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)
	sender, _ := sdk.AccAddressFromBech32(msg.Sender)

	// validate cookbook id
	cookbook, err := srv.GetCookbook(sdkCtx, msg.CookbookID)
	if err != nil {
		return nil, errInternal(err)
	}
	// validate sender
	if cookbook.Sender != msg.Sender {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "cookbook not owned by the sender")
	}

	recipe := types.NewRecipe(
		msg.Name, msg.CookbookID, msg.Description,
		msg.CoinInputs, msg.ItemInputs,
		msg.Entries, msg.Outputs,
		msg.BlockInterval, sender, msg.ExtraInfo,
	)

	if msg.RecipeID != "" {
		if srv.HasRecipeWithCookbookID(sdkCtx, msg.CookbookID, msg.RecipeID) {
			return nil, errInternal(fmt.Errorf("recipeID %s is already present in cookbookID %s", msg.RecipeID, msg.CookbookID))
		}
		recipe.ID = msg.RecipeID
	}
	if err := types.ItemInputList(recipe.ItemInputs).Validate(); err != nil {
		return nil, errInternal(err)
	}

	if err := srv.SetRecipe(sdkCtx, recipe); err != nil {
		return nil, errInternal(err)
	}

	return &types.MsgCreateRecipeResponse{
		RecipeID: recipe.ID,
		Message:  "successfully created a recipe",
		Status:   "Success",
	}, nil
}

// EnableRecipe is used to enable recipe by a developer
func (srv msgServer) EnableRecipe(ctx context.Context, msg *types.MsgEnableRecipe) (*types.MsgEnableRecipeResponse, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)
	sender, _ := sdk.AccAddressFromBech32(msg.Sender)

	recipe, err := srv.GetRecipe(sdkCtx, msg.RecipeID)
	if err != nil {
		return nil, errInternal(err)
	}

	if sender.String() != recipe.Sender {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "msg sender is not the owner of the recipe")
	}

	recipe.Disabled = false

	err = srv.UpdateRecipe(sdkCtx, msg.RecipeID, recipe)
	if err != nil {
		return nil, errInternal(err)
	}

	return &types.MsgEnableRecipeResponse{
		Message: "successfully enabled the recipe",
		Status:  "Success",
	}, nil
}

// DisableRecipe is used to disable recipe by a developer
func (srv msgServer) DisableRecipe(ctx context.Context, msg *types.MsgDisableRecipe) (*types.MsgDisableRecipeResponse, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)
	sender, _ := sdk.AccAddressFromBech32(msg.Sender)

	recipe, err := srv.GetRecipe(sdkCtx, msg.RecipeID)
	if err != nil {
		return nil, errInternal(err)
	}

	if sender.String() != recipe.Sender {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "msg sender is not the owner of the recipe")
	}
	recipe.Disabled = true

	err = srv.UpdateRecipe(sdkCtx, msg.RecipeID, recipe)
	if err != nil {
		return nil, errInternal(err)
	}

	return &types.MsgDisableRecipeResponse{
		Message: "successfully disabled the recipe",
		Status:  "Success",
	}, nil
}

// HandlerMsgUpdateRecipe is used to update recipe by a developer
func (srv msgServer) HandlerMsgUpdateRecipe(ctx context.Context, msg *types.MsgUpdateRecipe) (*types.MsgUpdateRecipeResponse, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)
	sender, _ := sdk.AccAddressFromBech32(msg.Sender)

	rc, err := srv.GetRecipe(sdkCtx, msg.ID)

	// only the original sender (owner) of the cookbook can update the cookbook
	if rc.Sender != sender.String() {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "the owner of the recipe is different then the current sender")
	}

	if err != nil {
		return nil, errInternal(err)
	}

	rc.Description = msg.Description
	rc.CookbookID = msg.CookbookID
	rc.CoinInputs = msg.CoinInputs
	rc.ItemInputs = msg.ItemInputs
	rc.Entries = msg.Entries
	rc.BlockInterval = msg.BlockInterval
	rc.Name = msg.Name
	rc.Outputs = msg.Outputs

	if err := srv.UpdateRecipe(sdkCtx, msg.ID, rc); err != nil {
		return nil, errInternal(err)
	}

	return &types.MsgUpdateRecipeResponse{
		RecipeID: msg.ID,
		Message:  "successfully updated the recipe",
		Status:   "Success",
	}, nil
}
