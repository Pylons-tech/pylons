package handlers

import (
	"context"
	"encoding/json"
	"errors"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// ExecuteRecipe is used to execute a recipe
func (k msgServer) ExecuteRecipe(ctx context.Context, msg *types.MsgExecuteRecipe) (*types.MsgExecuteRecipeResponse, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)
	sender, _ := sdk.AccAddressFromBech32(msg.Sender)

	recipe, err := k.GetRecipe(sdkCtx, msg.RecipeID)
	if err != nil {
		return nil, errInternal(err)
	}

	p := ExecProcess{ctx: sdkCtx, keeper: k.Keeper, recipe: recipe}

	var cl sdk.Coins
	for _, inp := range recipe.CoinInputs {
		cl = append(cl, sdk.NewCoin(inp.Coin, sdk.NewInt(inp.Count)))
	}

	err = p.SetMatchedItemsFromExecMsg(sdkCtx, msg)
	if err != nil {
		return nil, errInternal(err)
	}

	// we set the inputs and outputs for storing the execution
	if recipe.BlockInterval > 0 {
		// set matchedItem's owner recipe
		var rcpOwnMatchedItems []types.Item
		for _, item := range p.matchedItems {
			item.OwnerRecipeID = recipe.ID
			if err := k.SetItem(sdkCtx, item); err != nil {
				return nil, errInternal(errors.New("error updating item's owner recipe"))
			}
			rcpOwnMatchedItems = append(rcpOwnMatchedItems, item)
		}

		err = k.LockCoin(sdkCtx, types.NewLockedCoin(sender, types.CoinInputList(recipe.CoinInputs).ToCoins()))
		if err != nil {
			return nil, errInternal(err)
		}

		// store the execution as the interval
		exec := types.NewExecution(recipe.ID, recipe.CookbookID, cl, rcpOwnMatchedItems,
			sdkCtx.BlockHeight()+recipe.BlockInterval, sender, false)
		err := k.SetExecution(sdkCtx, exec)

		if err != nil {
			return nil, errInternal(err)
		}
		outputSTR, err := json.Marshal(types.ExecuteRecipeScheduleOutput{
			ExecID: exec.ID,
		})
		if err != nil {
			return nil, errInternal(err)
		}
		return &types.MsgExecuteRecipeResponse{
			Message: "scheduled the recipe",
			Status:  "Success",
			Output:  outputSTR,
		}, nil
	}

	if !keep.HasCoins(k.Keeper, sdkCtx, sender, cl) {
		return nil, errInternal(errors.New("insufficient coin balance"))
	}

	err = ProcessCoinInputs(sdkCtx, k.Keeper, sender, recipe.CookbookID, cl)
	if err != nil {
		return nil, errInternal(err)
	}

	outputSTR, err := p.Run(sender)
	if err != nil {
		return nil, errInternal(err)
	}

	return &types.MsgExecuteRecipeResponse{
		Message: "successfully executed the recipe",
		Status:  "Success",
		Output:  outputSTR,
	}, nil
}
