package keeper

import (
	"context"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k Keeper) MatchItemInputsForExecution(ctx sdk.Context, creatorAddr string, inputItemsIDs []string, recipe types.Recipe) ([]types.Item, error) {
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
					modAcc := k.accountKeeper.GetModuleAddress(types.ExecutionsLockerName)
					if inputItem.Owner == modAcc.String() {
						return nil, sdkerrors.Wrapf(types.ErrItemLocked, "item with id %s locked", inputItem.ID)
					}
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
			err = recipeItemInput.MatchItem(inputItem, ec)
			if err == nil {
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

// ExecuteRecipe will excute the recipe provided in msg
// We will update coins of during locking if user did not have enough normal coin
// But user have enough IBC coins
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

	matchedItems, err := k.MatchItemInputsForExecution(ctx, msg.Creator, msg.ItemIDs, recipe)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	coinInputsIndex := int(msg.CoinInputsIndex)
	coinInputs, err := k.GetCoinsInputsByIndex(ctx, recipe, coinInputsIndex)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	addr, _ := sdk.AccAddressFromBech32(msg.Creator)

	coinInputs, err = k.UpdateCoinsDenom(ctx, addr, coinInputs)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	// check that coinInputs does not contain an unsendable paymentProcessor coin without a receipt
	err = k.ValidatePaymentInfo(ctx, msg.PaymentInfos, coinInputs)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if len(msg.PaymentInfos) != 0 {
		// client is providing payments receipts
		err = k.ProcessPaymentInfos(ctx, msg.PaymentInfos, addr)
		if err != nil {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
	}

	err = k.LockCoinsForExecution(ctx, addr, coinInputs)
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
		NodeVersion:   k.EngineVersion(ctx),
		BlockHeight:   ctx.BlockHeight(),
		ItemInputs:    itemRecords,
		RecipeID:      recipe.ID,
		CookbookID:    recipe.CookbookID,
		RecipeVersion: recipe.Version,
		CoinInputs:    coinInputs,
	}

	id := k.AppendPendingExecution(ctx, execution, recipe.BlockInterval)

	err = ctx.EventManager().EmitTypedEvent(&types.EventCreateExecution{
		Creator:      execution.Creator,
		ID:           id,
		PaymentInfos: msg.PaymentInfos,
	})

	//to do
	// creater Name
	// recipient address

	err = ctx.EventManager().EmitTypedEvent(&types.EventItemCreation{
		ItemID:           id,
		CookbookID:       recipe.CookbookID,
		RecipeID:         recipe.ID,
		PaymentInfos:     msg.PaymentInfos,
		CreaterAddress:   msg.Creator,
		CreaterName:      "Temp-Creator-Name",
		RecipientAddress: cookbook.Creator,
	})

	return &types.MsgExecuteRecipeResponse{ID: id}, err
}
