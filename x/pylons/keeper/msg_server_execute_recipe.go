package keeper

import (
	"context"
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// MatchItem checks if all the constraint match the given item
func MatchItem(item types.Item, itemInput types.ItemInput, ec types.CelEnvCollection) error {
	if itemInput.Doubles != nil {
		for _, param := range itemInput.Doubles {
			double, ok := item.FindDouble(param.Key)
			if !ok {
				return sdkerrors.Wrapf(types.ErrItemMatch, "%s key is not available on the item: item_id=%s", param.Key, item.ID)
			}

			if !param.Has(double) {
				return sdkerrors.Wrapf(types.ErrItemMatch, "%s key range does not match: item_id=%s", param.Key, item.ID)
			}
		}
	}

	if itemInput.Longs != nil {
		for _, param := range itemInput.Longs {
			long, ok := item.FindLong(param.Key)
			if !ok {
				return sdkerrors.Wrapf(types.ErrItemMatch, "%s key is not available on the item: item_id=%s", param.Key, item.ID)
			}

			if !param.Has(long) {
				return sdkerrors.Wrapf(types.ErrItemMatch, "%s key range does not match: item_id=%s", param.Key, item.ID)
			}
		}
	}

	if itemInput.Strings != nil {
		for _, param := range itemInput.Strings {
			str, ok := item.FindString(param.Key)
			if !ok {
				return sdkerrors.Wrapf(types.ErrItemMatch, "%s key is not available on the item: item_id=%s", param.Key, item.ID)
			}
			if str != param.Value {
				return sdkerrors.Wrapf(types.ErrItemMatch, "%s key value does not match: item_id=%s", param.Key, item.ID)
			}
		}
	}

	for _, param := range itemInput.Conditions.Doubles {
		double, err := ec.EvalFloat64(param.Key)
		if err != nil {
			return sdkerrors.Wrapf(types.ErrItemMatch, "%s expression is invalid: item_id=%s, %+v", param.Key, item.ID, err.Error())
		}

		dec, err := sdk.NewDecFromStr(fmt.Sprintf("%v", double))
		if err != nil {
			return err
		}

		if !param.Has(dec) {
			return sdkerrors.Wrapf(types.ErrItemMatch, "%s expression range does not match: item_id=%s", param.Key, item.ID)
		}
	}

	for _, param := range itemInput.Conditions.Longs {
		long, err := ec.EvalInt64(param.Key)
		if err != nil {
			return sdkerrors.Wrapf(types.ErrItemMatch, "%s expression is invalid: item_id=%s, %+v", param.Key, item.ID, err.Error())
		}

		if !param.Has(int(long)) {
			return sdkerrors.Wrapf(types.ErrItemMatch, "%s expression range does not match: item_id=%s", param.Key, item.ID)
		}
	}

	for _, param := range itemInput.Conditions.Strings {
		str, err := ec.EvalString(param.Key)
		if err != nil {
			return sdkerrors.Wrapf(types.ErrItemMatch, "%s expression is invalid: item_id=%s, %+v", param.Key, item.ID, err.Error())
		}
		if str != param.Value {
			return sdkerrors.Wrapf(types.ErrItemMatch, "%s expression value does not match: item_id=%s", param.Key, item.ID)
		}
	}
	return nil
}

func (k msgServer) MatchItemInputs(ctx sdk.Context, creatorAddr string, inputItemsIDs []string, recipe types.Recipe) ([]types.Item, error) {
	if len(inputItemsIDs) != len(recipe.ItemInputs) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "size mismatch between provided input items and items required by recipe")
	}
	matchedItems := make([]types.Item, len(recipe.ItemInputs))

	// build Item list from inputItemIDs
	inputItemMap := make(map[string]types.Item)
	checkedInputItems := make([]bool, len(inputItemsIDs))

	for i, recipeItemInput := range recipe.ItemInputs {
		var err error
		for j, id := range inputItemsIDs {
			if checkedInputItems[j] {
				continue
			}
			inputItem, found := inputItemMap[id]
			if !found {
				inputItem, found = k.GetItem(ctx, recipe.CookbookID, id)
				if !found {
					return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "item with id %v not found", id)
				}
				if inputItem.Owner != creatorAddr {
					return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "item with id %s not owned by sender", inputItem.ID)
				}
			}
			inputItemMap[id] = inputItem
			// match
			var ec types.CelEnvCollection
			ec, err = k.NewCelEnvCollectionFromItem(ctx, recipe.ID, "", inputItem)
			if err != nil {
				return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			err = MatchItem(inputItem, recipeItemInput, ec)
			if err != nil {
				matchedItems[i] = inputItem
				checkedInputItems[j] = true
				break
			}
		}
		if err != nil {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "cannot find match for recipe input item ")
		}
	}
	return matchedItems, nil
}

func (k msgServer) ExecuteRecipe(goCtx context.Context, msg *types.MsgExecuteRecipe) (*types.MsgExecuteRecipeResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	recipe, found := k.GetRecipe(ctx, msg.CookbookID, msg.RecipeID)
	if !found {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "requested recipe not found")
	}

	cookbook, found := k.GetCookbook(ctx, msg.CookbookID)
	if !found {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "main cookbook not found")
	}

	if !recipe.Enabled || !cookbook.Enabled {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "this recipe or its parent cookbook are disabled")
	}

	matchedItems, err := k.MatchItemInputs(ctx, msg.Creator, msg.ItemIDs, recipe)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	addr, _ := sdk.AccAddressFromBech32(msg.Creator)
	err = k.LockCoinsForExecution(ctx, addr, recipe.CoinInputs)
	if err != nil {
		return nil, err
	}

	// create ItemRecord list
	itemRecords := make([]types.ItemRecord, len(matchedItems))
	for i, item := range matchedItems {
		itemRecords[i] = types.ItemRecord{
			ID:      item.ID,
			Doubles: item.Doubles,
			Longs:   item.Longs,
			Strings: item.Strings,
		}

		// lock input item for the execution - they are not unlocked if execution completes successfully, which means
		// items given as input are never returned to the owner when not modified, by design
		k.LockItemForExecution(ctx, item)
	}

	// create PendingExecution passing the current blockHeight
	execution := types.Execution{
		Creator:       msg.Creator,
		NodeVersion:   types.GetNodeVersionString(),
		BlockHeight:   ctx.BlockHeight(),
		ItemInputs:    itemRecords,
		RecipeID:      recipe.ID,
		CookbookID:    recipe.CookbookID,
		RecipeVersion: recipe.Version,
		CoinInputs:    recipe.CoinInputs,
	}

	id := k.AppendPendingExecution(ctx, execution, recipe.BlockInterval)

	// TODO should this event be more fleshed out?
	err = ctx.EventManager().EmitTypedEvent(&types.EventCreateExecution{
		Creator: execution.Creator,
		ID:      id,
	})

	return &types.MsgExecuteRecipeResponse{ID: id}, err
}
