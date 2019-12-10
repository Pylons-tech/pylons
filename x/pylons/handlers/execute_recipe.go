package handlers

import (
	"encoding/json"
	"errors"

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

func GetMatchedItems(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgExecuteRecipe, recipe types.Recipe) ([]types.Item, error) {
	// TODO: need to check it's working correctly when it is recipe for merging to same items

	var inputItems []types.Item

	for _, id := range msg.ItemIDs {
		item, err := keeper.GetItem(ctx, id)
		if err != nil {
			return nil, err
		}
		if !item.Sender.Equals(msg.Sender) {
			return nil, errors.New("item owner is not same as sender")
		}

		inputItems = append(inputItems, item)
	}

	// we validate and match items
	var matchedItems []types.Item
	var matches bool
	for _, itemInput := range recipe.ItemInputs {
		matches = false

		for _, item := range inputItems {
			if itemInput.Matches(item) && len(item.OwnerRecipeID) == 0 {
				matchedItems = append(matchedItems, item)
				matches = true
				break
			}
		}

		if !matches {
			return nil, errors.New("the item inputs dont match any items provided")
		}
	}
	return matchedItems, nil
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

		outputItem, err := itemOutput.Item(cbID, sender)
		if err != nil {
			return ers, sdk.ErrInternal(err.Error())
		}
		if err = keeper.SetItem(ctx, *outputItem); err != nil {
			return ers, sdk.ErrInternal(err.Error())
		}
		ers.Type = "ITEM"
		ers.ItemID = outputItem.ID
		return ers, nil
	default:
		return ers, sdk.ErrInternal("no item nor coin type created")
	}
}

func GenerateItemFromRecipe(ctx sdk.Context, keeper keep.Keeper, sender sdk.AccAddress, cbID string, matchedItems []types.Item, entries types.WeightedParamList) ([]byte, error) {
	// TODO should reset item.OwnerRecipeID to "" when this item is used as catalyst

	// we delete all the matched items as those get converted to output items
	for _, item := range matchedItems {
		keeper.DeleteItem(ctx, item.ID)
	}

	output, err := entries.Actualize()
	if err != nil {
		return []byte{}, err
	}
	ers, err := AddExecutedResult(ctx, keeper, output, sender, cbID)

	if err != nil {
		return []byte{}, err
	}

	outputSTR, err2 := json.Marshal(ers)

	if err2 != nil {
		return []byte{}, err2
	}
	return outputSTR, nil
}

func HandlerItemGenerationRecipe(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgExecuteRecipe, recipe types.Recipe, matchedItems []types.Item) sdk.Result {
	// we delete all the matched items as those get converted to output items
	outputSTR, err := GenerateItemFromRecipe(ctx, keeper, msg.Sender, recipe.CookbookID, matchedItems, recipe.Entries)
	if err != nil {
		return errInternal(err)
	}

	resp, err3 := json.Marshal(ExecuteRecipeResp{
		Message: "successfully executed the recipe",
		Status:  "Success",
		Output:  outputSTR,
	})

	if err3 != nil {
		return errInternal(err3)
	}
	return sdk.Result{Data: resp}
}

func UpdateItemFromUpgradeParams(targetItem types.Item, ToUpgrade types.ItemUpgradeParams) (types.Item, sdk.Error) {
	for _, dbl := range ToUpgrade.Doubles {
		dblKey, ok := targetItem.FindDoubleKey(dbl.Key)
		if !ok {
			return targetItem, sdk.ErrInternal("double key does not exist which needs to be upgraded")
		}
		targetItem.Doubles[dblKey].Value += dbl.UpgradeAmount
	}

	for _, lng := range ToUpgrade.Longs {
		lngKey, ok := targetItem.FindLongKey(lng.Key)
		if !ok {
			return targetItem, sdk.ErrInternal("long key does not exist which needs to be upgraded")
		}
		targetItem.Longs[lngKey].Value += lng.UpgradeAmount
	}

	for _, str := range ToUpgrade.Strings {
		strKey, ok := targetItem.FindStringKey(str.Key)
		if !ok {
			return targetItem, sdk.ErrInternal("string key does not exist which needs to be upgraded")
		}
		targetItem.Strings[strKey].Value = str.UpgradeValue
	}
	return targetItem, nil
}

func HandlerItemUpgradeRecipe(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgExecuteRecipe, recipe types.Recipe, matchedItems []types.Item) sdk.Result {

	if len(matchedItems) != 1 {
		return sdk.ErrInternal("matched items shouldn't be 0 or more than one for upgrade recipe").Result()
	}

	targetItem := matchedItems[0]
	targetItem, err := UpdateItemFromUpgradeParams(targetItem, recipe.ToUpgrade)
	if err != nil {
		return errInternal(err)
	}

	if err := keeper.SetItem(ctx, targetItem); err != nil {
		return errInternal(err)
	}

	resp, err3 := json.Marshal(ExecuteRecipeResp{
		Message: "successfully upgraded the item",
		Status:  "Success",
	})

	if err3 != nil {
		return errInternal(err3)
	}
	return sdk.Result{Data: resp}
}

// HandlerMsgExecuteRecipe is used to execute a recipe
func HandlerMsgExecuteRecipe(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgExecuteRecipe) sdk.Result {
	err := msg.ValidateBasic()
	if err != nil {
		return err.Result()
	}

	recipe, err2 := keeper.GetRecipe(ctx, msg.RecipeID)
	if err2 != nil {
		return errInternal(err2)
	}

	var cl sdk.Coins
	for _, inp := range recipe.CoinInputs {
		cl = append(cl, sdk.NewCoin(inp.Coin, sdk.NewInt(inp.Count)))
	}

	if len(msg.ItemIDs) != len(recipe.ItemInputs) {
		return sdk.ErrInternal("the item IDs count doesn't match the recipe input").Result()
	}

	matchedItems, err2 := GetMatchedItems(ctx, keeper, msg, recipe)
	if err2 != nil {
		return errInternal(err2)
	}
	// TODO: validate 1-1 correspondence for item input and output - check ids

	// we set the inputs and outputs for storing the execution
	if recipe.BlockInterval > 0 {
		// set matchedItem's owner recipe
		var rcpOwnMatchedItems []types.Item
		for _, item := range matchedItems {
			item.OwnerRecipeID = recipe.ID
			if err := keeper.SetItem(ctx, item); err != nil {
				return sdk.ErrInternal("error updating item's owner recipe").Result()
			}
			rcpOwnMatchedItems = append(rcpOwnMatchedItems, item)
		}
		// store the execution as the interval
		exec := types.NewExecution(recipe.ID, recipe.CookbookID, cl, rcpOwnMatchedItems, recipe.Entries,
			ctx.BlockHeight()+recipe.BlockInterval, msg.Sender, false)
		err2 := keeper.SetExecution(ctx, exec)

		if err2 != nil {
			return errInternal(err2)
		}
		outputSTR, err3 := json.Marshal(ExecuteRecipeScheduleOutput{
			ExecID: exec.ID,
		})
		if err3 != nil {
			return errInternal(err2)
		}
		resp, err4 := json.Marshal(ExecuteRecipeResp{
			Message: "scheduled the recipe",
			Status:  "Success",
			Output:  outputSTR,
		})

		if err4 != nil {
			return errInternal(err2)
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

	if recipe.Type == types.GENERATION {
		return HandlerItemGenerationRecipe(ctx, keeper, msg, recipe, matchedItems)
	} else {
		return HandlerItemUpgradeRecipe(ctx, keeper, msg, recipe, matchedItems)
	}
}
