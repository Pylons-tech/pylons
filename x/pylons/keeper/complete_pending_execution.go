package keeper

import (
	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	"github.com/rogpeppe/go-internal/semver"

	"github.com/cosmos/cosmos-sdk/telemetry"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// GenerateExecutionResult generates actual coins and items to be finalized in the store
func (k Keeper) GenerateExecutionResult(ctx sdk.Context, addr sdk.AccAddress, entryIds []string, recipe *v1beta1.Recipe, ec v1beta1.CelEnvCollection, matchedItems []v1beta1.ItemRecord) (sdk.Coins, []v1beta1.Item, []v1beta1.Item, error) {
	coinOutputs, itemOutputs, itemModifyOutputs, err := v1beta1.EntryListsByIDs(entryIds, *recipe)
	if err != nil {
		return nil, nil, nil, err
	}

	// coinPrefix := strings.ReplaceAll(recipe.CookbookId, "_", "")
	coins := make([]sdk.Coin, len(coinOutputs))
	for i, coinOutput := range coinOutputs {
		coins[i].Denom = coinOutput.Coin.Denom
		if coinOutput.Program != "" {
			val, err := ec.EvalInt64(coinOutput.Program)
			if err != nil {
				return nil, nil, nil, err
			}
			coins[i].Amount = sdk.NewInt(val)
		} else {
			coins[i].Amount = coinOutput.Coin.Amount
		}
		if !coins[i].IsValid() {
			return nil, nil, nil, sdkerrors.Wrap(sdkerrors.ErrInvalidCoins, "invalid coinOutputs from execution")
		}
	}

	mintedItems := make([]v1beta1.Item, 0)
	for idx, itemOutput := range itemOutputs {
		if itemOutput.Quantity != 0 && itemOutput.Quantity <= recipe.Entries.ItemOutputs[idx].AmountMinted {
			return nil, nil, nil, sdkerrors.Wrapf(v1beta1.ErrItemQuantityExceeded, "quantity: %d, already minted: %d", itemOutput.Quantity, itemOutput.AmountMinted)
		}
		item, err := itemOutput.Actualize(ctx, recipe.CookbookId, recipe.Id, addr, ec, k.EngineVersion(ctx))
		if err != nil {
			return nil, nil, nil, err
		}
		mintedItems = append(mintedItems, item)
		recipe.Entries.ItemOutputs[idx].AmountMinted++
	}

	modifiedItems := make([]v1beta1.Item, len(itemModifyOutputs))
	for idx, itemModifyOutput := range itemModifyOutputs {
		if itemModifyOutput.Quantity != 0 && itemModifyOutput.Quantity <= recipe.Entries.ItemOutputs[idx].AmountMinted {
			return nil, nil, nil, sdkerrors.Wrapf(v1beta1.ErrItemQuantityExceeded, "quantity: %d, already minted: %d", itemModifyOutput.Quantity, itemModifyOutput.AmountMinted)
		}
		itemInputIdx := 0
		for i, itemInput := range recipe.ItemInputs {
			if itemInput.Id == itemModifyOutput.ItemInputRef {
				itemInputIdx = i
				break
			}
		}
		item, found := k.GetItem(ctx, recipe.CookbookId, matchedItems[itemInputIdx].Id)
		if !found {
			return nil, nil, nil, sdkerrors.Wrapf(sdkerrors.ErrKeyNotFound, "item %s to modify not found", matchedItems[itemInputIdx].Id)
		}
		err := itemModifyOutput.Actualize(&item, ctx, addr, ec)
		if err != nil {
			return nil, nil, nil, err
		}
		modifiedItems[idx] = item
	}

	return coins, mintedItems, modifiedItems, nil
}

// CompletePendingExecution completes the execution
func (k Keeper) CompletePendingExecution(ctx sdk.Context, pendingExecution v1beta1.Execution) (v1beta1.Execution, v1beta1.EventCompleteExecution, bool, error) {
	recipe, _ := k.GetRecipe(ctx, pendingExecution.CookbookId, pendingExecution.RecipeId)
	cookbook, _ := k.GetCookbook(ctx, pendingExecution.CookbookId)
	cookbookOwnerAddr, _ := sdk.AccAddressFromBech32(cookbook.Creator)
	// check if recipe was updated after execution is submitted, and error out in such a case
	if semver.Compare(recipe.Version, pendingExecution.RecipeVersion) != 0 {
		return v1beta1.Execution{}, v1beta1.EventCompleteExecution{}, false, v1beta1.ErrInvalidPendingExecution
	}

	celEnv, err := k.NewCelEnvCollectionFromRecipe(ctx, pendingExecution, recipe)
	if err != nil {
		return v1beta1.Execution{}, v1beta1.EventCompleteExecution{}, false, err
	}

	outputs, err := v1beta1.WeightedOutputsList(recipe.Outputs).Actualize()
	if err != nil {
		return v1beta1.Execution{}, v1beta1.EventCompleteExecution{}, false, err
	}

	creator, err := sdk.AccAddressFromBech32(pendingExecution.Creator)
	if err != nil {
		return v1beta1.Execution{}, v1beta1.EventCompleteExecution{}, false, err
	}

	coins, mintItems, modifyItems, err := k.GenerateExecutionResult(ctx, creator, outputs, &recipe, celEnv, pendingExecution.ItemInputs)
	if err != nil {
		return v1beta1.Execution{}, v1beta1.EventCompleteExecution{}, false, err
	}

	// add coin outputs to accounts
	err = k.MintCoins(ctx, v1beta1.ExecutionsLockerName, coins)
	if err != nil {
		return v1beta1.Execution{}, v1beta1.EventCompleteExecution{}, false, err
	}
	err = k.bankKeeper.SendCoinsFromModuleToAccount(ctx, v1beta1.ExecutionsLockerName, creator, coins)
	if err != nil {
		return v1beta1.Execution{}, v1beta1.EventCompleteExecution{}, false, err
	}
	// add mint items to keeper
	itemOutputIds := make([]string, len(mintItems))
	for i, item := range mintItems {
		id := k.AppendItem(ctx, item)
		itemOutputIds[i] = id
	}
	// update modify items in keeper
	itemModifyOutputIds := make([]string, len(modifyItems))
	for i, item := range modifyItems {
		k.UnlockItemForExecution(ctx, item, pendingExecution.Creator)
		itemModifyOutputIds[i] = item.Id
	}
	// update recipe in keeper to keep track of mintedAmounts
	k.SetRecipe(ctx, recipe)

	// unlock the locked coins and perform payment(s)
	// separate cookbook coins so they can be burned
	burnCoins := sdk.NewCoins()
	payCoins := sdk.NewCoins()
	transferCoins := sdk.NewCoins()
	feeCoins := sdk.NewCoins()

coinLoop:
	for _, coin := range pendingExecution.CoinInputs {
		if v1beta1.IsCookbookDenom(coin.Denom) {
			burnCoins = burnCoins.Add(coin)
			continue coinLoop
		}

		payCoins = payCoins.Add(coin)
		feeAmt := sdk.NewDecFromInt(coin.Amount).Mul(k.RecipeFeePercentage(ctx)).RoundInt()
		coin.Amount = coin.Amount.Sub(feeAmt)
		transferCoins = transferCoins.Add(coin)
		coin.Amount = feeAmt
		feeCoins = feeCoins.Add(coin)
	}
	// burn any cookbook coin and send payment for remaining
	err = k.bankKeeper.BurnCoins(ctx, v1beta1.ExecutionsLockerName, burnCoins)
	if err != nil {
		return v1beta1.Execution{}, v1beta1.EventCompleteExecution{}, false, err
	}
	// perform payments
	err = k.UnLockCoinsForExecution(ctx, creator, payCoins)
	if err != nil {
		return v1beta1.Execution{}, v1beta1.EventCompleteExecution{}, false, err
	}
	err = k.bankKeeper.SendCoins(ctx, creator, cookbookOwnerAddr, transferCoins)
	if err != nil {
		return v1beta1.Execution{}, v1beta1.EventCompleteExecution{}, true, err
	}
	// send fees
	err = k.PayFees(ctx, creator, feeCoins)
	if err != nil {
		return v1beta1.Execution{}, v1beta1.EventCompleteExecution{}, true, err
	}

	pendingExecution.CoinOutputs = coins
	pendingExecution.ItemModifyOutputIds = itemModifyOutputIds
	pendingExecution.ItemOutputIds = itemOutputIds

	event := v1beta1.EventCompleteExecution{
		Creator:       pendingExecution.Creator,
		Id:            pendingExecution.Id,
		BurnCoins:     burnCoins,
		PayCoins:      payCoins,
		TransferCoins: transferCoins,
		FeeCoins:      feeCoins,
		CoinOutputs:   coins,
		MintItems:     mintItems,
		ModifyItems:   modifyItems,
	}

	telemetry.IncrCounter(1, "execution", "cookbookID", pendingExecution.CookbookId, "recipeID", pendingExecution.RecipeId)
	telemetry.IncrCounter(1, "execution", "total")

	return pendingExecution, event, true, nil
}
