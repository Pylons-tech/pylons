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

func AddExecutedResult(ctx sdk.Context, keeper keep.Keeper, output types.WeightedParam, sender sdk.AccAddress, cbID string) (ExecuteRecipeSerialize, sdk.Error) {
	var ers ExecuteRecipeSerialize
	switch output.(type) {
	case types.CoinOutput:
		coinOutput, _ := output.(types.CoinOutput)
		var ocl sdk.Coins
		ocl = append(ocl, sdk.NewCoin(coinOutput.Coin, sdk.NewInt(coinOutput.Count)))

		_, _, err := keeper.CoinKeeper.AddCoins(ctx, sender, ocl)
		if err != nil {
			return ers, err
		}
		ers.Type = "COIN"
		ers.Coin = coinOutput.Coin
		ers.Amount = coinOutput.Count
		return ers, nil
	case types.ItemOutput:
		itemOutput, _ := output.(types.ItemOutput)
		outputItem := *itemOutput.Item(cbID, sender)
		if err := keeper.SetItem(ctx, outputItem); err != nil {
			return ers, sdk.ErrInternal(err.Error())
		}
		ers.Type = "ITEM"
		ers.ItemID = outputItem.ID
		return ers, nil
	default:
		return ers, sdk.ErrInternal("no item nor coin type created")
	}
}

// HandlerMsgExecuteRecipe is used to execute a recipe
func HandlerMsgExecuteRecipe(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgExecuteRecipe) sdk.Result {
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

	// we set the inputs and outputs for storing the execution
	if recipe.BlockInterval > 0 {
		// store the execution as the interval
		exec := types.NewExecution(recipe.ID, recipe.CookbookID, cl, matchedItems, recipe.Entries,
			ctx.BlockHeight()+recipe.BlockInterval, msg.Sender, false)
		err2 := keeper.SetExecution(ctx, exec)

		if err2 != nil {
			return sdk.ErrInternal(err2.Error()).Result()
		}
		outputSTR, err3 := json.Marshal(ExecuteRecipeScheduleOutput{
			ExecID: exec.ID,
		})
		if err3 != nil {
			return sdk.ErrInternal(err2.Error()).Result()
		}
		resp, err4 := json.Marshal(ExecuteRecipeResp{
			Message: "scheduled the recipe",
			Status:  "Success",
			Output:  outputSTR,
		})

		if err4 != nil {
			return sdk.ErrInternal(err2.Error()).Result()
		}
		return sdk.Result{Data: resp}
	}
	if !keeper.CoinKeeper.HasCoins(ctx, msg.Sender, cl) {
		return sdk.ErrInternal("insufficient coin balance").Result()
	}
	// TODO: send the coins to a master address instead of burning them
	// think about making this adding and subtracting atomic using inputoutputcoins method
	_, _, err = keeper.CoinKeeper.SubtractCoins(ctx, msg.Sender, cl)
	if err != nil {
		return err.Result()
	}

	// we delete all the matched items as those get converted to output items
	for _, item := range matchedItems {
		keeper.DeleteItem(ctx, item.ID)
	}

	output, err := recipe.Entries.Actualize()
	if err != nil {
		return err.Result()
	}
	ers, err := AddExecutedResult(ctx, keeper, output, msg.Sender, recipe.CookbookID)

	if err != nil {
		return err.Result()
	}

	outputSTR, err2 := json.Marshal(ers)

	if err2 != nil {
		return sdk.ErrInternal(err2.Error()).Result()
	}

	resp, err3 := json.Marshal(ExecuteRecipeResp{
		Message: "successfully executed the recipe",
		Status:  "Success",
		Output:  outputSTR,
	})

	if err3 != nil {
		return sdk.ErrInternal(err2.Error()).Result()
	}
	return sdk.Result{Data: resp}
}
