package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

func (k Keeper) MatchItemInputsForExecution(ctx sdk.Context, creatorAddr string, inputItemsIds []string, recipe v1beta1.Recipe) ([]v1beta1.Item, error) {
	if len(inputItemsIds) != len(recipe.ItemInputs) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "size mismatch between provided input items and items required by recipe")
	}
	matchedItems := make([]v1beta1.Item, len(recipe.ItemInputs))

	// build Item list from inputItemIds
	inputItemMap := make(map[string]v1beta1.Item)
	checkedInputItems := make([]bool, len(inputItemsIds))

	for i, recipeItemInput := range recipe.ItemInputs {
		var err error
		for j, id := range inputItemsIds {
			if checkedInputItems[j] {
				continue
			}
			inputItem, found := inputItemMap[id]
			if !found {
				inputItem, found = k.GetItem(ctx, recipe.CookbookId, id)
				if !found {
					return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "item with id %v not found", id)
				}
				if inputItem.Owner != creatorAddr {
					modAcc := k.accountKeeper.GetModuleAddress(v1beta1.ExecutionsLockerName)
					if inputItem.Owner == modAcc.String() {
						return nil, sdkerrors.Wrapf(v1beta1.ErrItemLocked, "item with id %s locked", inputItem.Id)
					}
					return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "item with id %s not owned by sender", inputItem.Id)
				}
			}
			inputItemMap[id] = inputItem
			// match
			var ec v1beta1.CelEnvCollection
			ec, err = k.NewCelEnvCollectionFromItem(ctx, recipe.Id, "", inputItem)
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
func (k msgServer) ExecuteRecipe(goCtx context.Context, msg *v1beta1.MsgExecuteRecipe) (*v1beta1.MsgExecuteRecipeResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	cookbook, found := k.GetCookbook(ctx, msg.CookbookId)
	if !found {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "main cookbook not found")
	}

	recipe, found := k.GetRecipe(ctx, msg.CookbookId, msg.RecipeId)
	if !found {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "requested recipe not found")
	}

	// check if the recipe creator and the recipe executor are same
	if msg.Creator == cookbook.Creator {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "Recipe Executor Cannot Be Same As Creator")
	}

	if !recipe.Enabled || !cookbook.Enabled {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "this recipe or its parent cookbook are disabled")
	}

	matchedItems, err := k.MatchItemInputsForExecution(ctx, msg.Creator, msg.ItemIds, recipe)
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

	// calling helper function check item quantity
	// case: no more available return err
	for _, item := range recipe.Entries.ItemOutputs {
		if item.Quantity != 0 && item.Quantity <= item.AmountMinted {
			// returning error not found in case recipe is no more available
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "Amount minted reached maximum limit")
		}
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
	itemRecords := make([]v1beta1.ItemRecord, len(matchedItems))
	for i, item := range matchedItems {
		itemRecords[i] = v1beta1.ItemRecord{
			Id:      item.Id,
			Doubles: item.Doubles,
			Longs:   item.Longs,
			Strings: item.Strings,
		}

		// lock input item for the execution - they are not unlocked if execution completes successfully, which means
		// items given as input are never returned to the owner when not modified, by design
		k.LockItemForExecution(ctx, item)
	}

	// create PendingExecution passing the current blockHeight
	execution := v1beta1.Execution{
		Creator:       msg.Creator,
		NodeVersion:   k.EngineVersion(ctx),
		BlockHeight:   ctx.BlockHeight(),
		ItemInputs:    itemRecords,
		RecipeId:      recipe.Id,
		CookbookId:    recipe.CookbookId,
		RecipeVersion: recipe.Version,
		CoinInputs:    coinInputs,
	}

	id := k.AppendPendingExecution(ctx, execution, recipe.BlockInterval)

	// converted typed event to regular event for event management purpose
	paymentInfo := ""
	for _, i := range msg.PaymentInfos {
		paymentInfo += i.String() + " "
	}
	// emit to register an execution event
	ctx.EventManager().EmitEvent(
		sdk.NewEvent(
			v1beta1.CreateExecutionKey,
			sdk.NewAttribute("creator", execution.Creator),
			sdk.NewAttribute("ID", id),
			sdk.NewAttribute("paymentInfos", paymentInfo),
		),
	)
	// query sender name by address
	// found is true if found
	senderName, found := k.GetUsernameByAddress(ctx, msg.Creator)
	if !found {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "user account username not found")
	}

	// event to register execution history details history of a recipe
	ctx.EventManager().EmitEvent(
		sdk.NewEvent(
			v1beta1.CreateItemKey,
			sdk.NewAttribute("itemID", id),
			sdk.NewAttribute("cookbookID", recipe.CookbookId),
			sdk.NewAttribute("recipeID", recipe.Id),
			sdk.NewAttribute("sender", msg.Creator),
			sdk.NewAttribute("receiver", cookbook.Creator),
			sdk.NewAttribute("senderName", senderName.GetValue()),
			sdk.NewAttribute("amount", coinInputs.String()),
			sdk.NewAttribute("createdAt", ctx.BlockTime().String()),
		),
	)

	executionTrack := v1beta1.RecipeHistory{
		ItemId:     id,
		CookbookId: recipe.CookbookId,
		RecipeId:   recipe.Id,
		Sender:     msg.Creator,
		Receiver:   cookbook.Creator,
		SenderName: senderName.GetValue(),
		Amount:     coinInputs.String(),
		CreatedAt:  ctx.BlockTime().Unix(),
	}

	k.SetExecuteRecipeHis(ctx, executionTrack)

	return &v1beta1.MsgExecuteRecipeResponse{Id: id}, err
}
