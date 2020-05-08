package handlers

import (
	"math/rand"
	"encoding/json"
	"errors"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// ExecuteRecipeResp is the response for executeRecipe
type ExecuteRecipeResp struct {
	Message string
	Status  string
	Output  []byte
}

type ExecuteRecipeSerialize struct {
	Type   string `json:"type"`   // COIN or ITEM
	Coin   string `json:"coin"`   // used when type is ITEM
	Amount int64  `json:"amount"` // used when type is COIN
	ItemID string `json:"itemID"` // used when type is ITEM
}

type ExecuteRecipeScheduleOutput struct {
	ExecID string
}

// HandlerMsgExecuteRecipe is used to execute a recipe
func HandlerMsgExecuteRecipe(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgExecuteRecipe) (*sdk.Result, error) {
	// set random seed at the start point of recipe execution
	rand.Seed(RandomSeed(ctx))

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	recipe, err2 := keeper.GetRecipe(ctx, msg.RecipeID)
	if err2 != nil {
		return nil, errInternal(err2)
	}

	p := ExecProcess{ctx: ctx, keeper: keeper, recipe: recipe}

	var cl sdk.Coins
	for _, inp := range recipe.CoinInputs {
		cl = append(cl, sdk.NewCoin(inp.Coin, sdk.NewInt(inp.Count)))
	}

	if len(msg.ItemIDs) != len(recipe.ItemInputs) {
		return nil, errInternal(errors.New("the item IDs count doesn't match the recipe input"))
	}

	err2 = p.SetMatchedItemsFromExecMsg(msg)
	if err2 != nil {
		return nil, errInternal(err2)
	}
	// TODO: validate 1-1 correspondence for item input and output - check ids

	// we set the inputs and outputs for storing the execution
	if recipe.BlockInterval > 0 {
		// set matchedItem's owner recipe
		var rcpOwnMatchedItems []types.Item
		for _, item := range p.matchedItems {
			item.OwnerRecipeID = recipe.ID
			if err := keeper.SetItem(ctx, item); err != nil {
				return nil, errInternal(errors.New("error updating item's owner recipe"))
			}
			rcpOwnMatchedItems = append(rcpOwnMatchedItems, item)
		}
		// store the execution as the interval
		exec := types.NewExecution(recipe.ID, recipe.CookbookID, cl, rcpOwnMatchedItems,
			ctx.BlockHeight()+recipe.BlockInterval, msg.Sender, false)
		err2 := keeper.SetExecution(ctx, exec)

		if err2 != nil {
			return nil, errInternal(err2)
		}
		outputSTR, err3 := json.Marshal(ExecuteRecipeScheduleOutput{
			ExecID: exec.ID,
		})
		if err3 != nil {
			return nil, errInternal(err2)
		}
		return marshalJson(ExecuteRecipeResp{
			Message: "scheduled the recipe",
			Status:  "Success",
			Output:  outputSTR,
		})
	}
	if !keeper.CoinKeeper.HasCoins(ctx, msg.Sender, cl) {
		return nil, errInternal(errors.New("insufficient coin balance"))
	}
	// TODO: send the coins to a master address instead of burning them
	// think about making this adding and subtracting atomic using inputoutputcoins method
	_, err = keeper.CoinKeeper.SubtractCoins(ctx, msg.Sender, cl)
	if err != nil {
		return nil, errInternal(err)
	}

	outputSTR, err2 := p.Run(msg.Sender)
	if err2 != nil {
		return nil, errInternal(err2)
	}

	return marshalJson(ExecuteRecipeResp{
		Message: "successfully executed the recipe",
		Status:  "Success",
		Output:  outputSTR,
	})
}
