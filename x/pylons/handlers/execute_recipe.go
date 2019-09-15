package handlers

import (
	"encoding/json"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// ExecuteRecipeResp is the response for executeRecipe
type ExecuteRecipeResp struct {
	Message string
	Status  string
}

// HandlerMsgExecuteRecipe is used to create cookbook by a developer
func HandlerMsgExecuteRecipe(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgExecuteRecipe) sdk.Result {
	var exec types.Execution
	err := msg.ValidateBasic()
	if err != nil {
		return err.Result()
	}

	recipe, err2 := keeper.GetRecipe(ctx, msg.RecipeID)
	if err2 != nil {
		return sdk.ErrInternal(err2.Error()).Result()
	}

	var cl sdk.Coins
	for _, inp := range recipe.CoinInputs {
		cl = append(cl, sdk.NewCoin(inp.Coin, sdk.NewInt(inp.Count)))
	}

	// output coins to the sender
	var ocl sdk.Coins

	for _, out := range recipe.CoinOutputs {
		ocl = append(ocl, sdk.NewCoin(out.Coin, sdk.NewInt(out.Count)))
	}

	// store the execution as the interval
	if recipe.BlockInterval > 0 {
		exec.RecipeID = recipe.ID
		exec.CoinInputs = cl
		exec.CoinOutputs = ocl
		exec.BlockHeight = ctx.BlockHeight() + recipe.BlockInterval
	} else {

		if !keeper.CoinKeeper.HasCoins(ctx, msg.Sender, cl) {
			return sdk.ErrInternal("insufficient coin balance").Result()
		}
		// TODO: send the coins to a master address instead of burning them
		// think about making this adding and subtracting atomic using inputoutputcoins method
		_, _, err = keeper.CoinKeeper.SubtractCoins(ctx, msg.Sender, cl)
		if err != nil {
			return err.Result()
		}
		_, _, err = keeper.CoinKeeper.AddCoins(ctx, msg.Sender, ocl)
		if err != nil {
			return err.Result()
		}

	}

	// Item transaction
	// first lets handle all item to item transactions
	// lets check if the Item IDs provided matches the recipe constraints

	if len(msg.ItemIDs) != len(recipe.ItemInputs) {
		return sdk.ErrInternal("the item IDs count doesn't match the recipe input").Result()
	}

	var inputItems []types.Item

	for _, id := range msg.ItemIDs {
		item, err := keeper.GetItem(ctx, id)
		if err != nil {
			return sdk.ErrInternal(err.Error()).Result()
		}
		if !item.Sender.Equals(msg.Sender) {
			return sdk.ErrInternal("item owner is not same as sender").Result()
		}

		inputItems = append(inputItems, item)
	}

	// we validate and match items
	var matchedItems []types.Item
	var matches bool
	for _, itemInput := range recipe.ItemInputs {
		matches = false

		for _, item := range inputItems {
			if itemInput.Matches(item) {
				matchedItems = append(matchedItems, item)
				matches = true
				break
			}
		}

		if !matches {
			return sdk.ErrInternal("the item inputs dont match any items provided").Result()
		}

	}

	// TODO: validate 1-1 correspondence for item input and output - check ids
	var outputItems []types.Item
	for _, item := range recipe.ItemOutputs {
		outputItems = append(outputItems, *item.Item(recipe.CookbookName, msg.Sender))
	}

	// we set the inputs and outputs for storing the execution
	if recipe.BlockInterval > 0 {
		exec.ItemInputs = matchedItems
		exec.ItemOutputs = outputItems
		exec.ID = exec.KeyGen()
		err2 := keeper.SetExecution(ctx, exec)

		if err2 != nil {
			return sdk.ErrInternal(err2.Error()).Result()
		}
		resp, err2 := json.Marshal(ExecuteRecipeResp{
			Message: "scheduled the recipe",
			Status:  "Success",
		})

		if err2 != nil {
			return sdk.ErrInternal(err2.Error()).Result()

		}
		return sdk.Result{Data: resp}
	}

	// we delete all the matched items as those get converted to output items
	for _, item := range matchedItems {
		keeper.DeleteItem(ctx, item.ID)
	}

	for _, item := range outputItems {
		if err := keeper.SetItem(ctx, item); err != nil {
			return sdk.ErrInternal(err.Error()).Result()
		}
	}

	resp, err2 := json.Marshal(ExecuteRecipeResp{
		Message: "successfully executed the recipe",
		Status:  "Success",
	})

	if err2 != nil {
		return sdk.ErrInternal(err2.Error()).Result()

	}
	return sdk.Result{Data: resp}
}
