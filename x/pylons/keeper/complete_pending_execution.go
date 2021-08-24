package keeper

import (
	"fmt"
	"strings"

	"github.com/rogpeppe/go-internal/semver"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// EntryListsByIDs is a function to find an entry by ID
func EntryListsByIDs(idList []string, recipe types.Recipe) ([]types.CoinOutput, map[int]types.ItemOutput, []types.ItemModifyOutput, error) {
	coinOutputs := make([]types.CoinOutput, 0)
	itemOutputs := make(map[int]types.ItemOutput)
	itemModifyOutputs := make([]types.ItemModifyOutput, 0)

Loop:
	for _, id := range idList {
		for _, coinOutput := range recipe.Entries.CoinOutputs {
			if coinOutput.ID == id {
				coinOutputs = append(coinOutputs, coinOutput)
				continue Loop
			}
		}

		for i, itemOutput := range recipe.Entries.ItemOutputs {
			if itemOutput.ID == id {
				itemOutputs[i] = itemOutput
				continue Loop
			}
		}

		for _, itemModifyOutput := range recipe.Entries.ItemModifyOutputs {
			if itemModifyOutput.ID == id {
				itemModifyOutputs = append(itemModifyOutputs, itemModifyOutput)
				continue Loop
			}
		}

		return nil, nil, nil, fmt.Errorf("no entry with the ID %s available", id)
	}

	return coinOutputs, itemOutputs, itemModifyOutputs, nil
}

// GenerateExecutionResult generates actual coins and items to be finalized in the store
func (k Keeper) GenerateExecutionResult(ctx sdk.Context, addr sdk.AccAddress, entryIDs []string, recipe *types.Recipe, ec types.CelEnvCollection, matchedItems []types.ItemRecord) (sdk.Coins, []types.Item, []types.Item, error) {
	coinOutputs, itemOutputs, itemModifyOutputs, err := EntryListsByIDs(entryIDs, *recipe)
	if err != nil {
		return nil, nil, nil, err
	}

	coinPrefix := strings.ReplaceAll(recipe.CookbookID, "_", "")
	coins := make([]sdk.Coin, len(coinOutputs))
	for i, coinOutput := range coinOutputs {
		coins[i].Denom = coinPrefix + "/" + coinOutput.Coin.Denom
		coins[i].Amount = coinOutput.Coin.Amount
		if !coins[i].IsValid() {
			return nil, nil, nil, sdkerrors.Wrap(sdkerrors.ErrInvalidCoins, "invalid coinOutputs from execution")
		}
	}

	mintedItems := make([]types.Item, 0)
	for itemOutputIdx, itemOutput := range itemOutputs {
		if itemOutput.Quantity != 0 && itemOutput.Quantity <= recipe.Entries.ItemOutputs[itemOutputIdx].AmountMinted {
			return nil, nil, nil, sdkerrors.Wrap(types.ErrItemQuantityExceeded, fmt.Sprintf("quantity: %d, already minted: %d", itemOutput.Quantity, itemOutput.AmountMinted))
		}
		item, err := k.Actualize(ctx, recipe.CookbookID, addr, ec, itemOutput)
		if err != nil {
			return nil, nil, nil, err
		}
		mintedItems = append(mintedItems, item)
		recipe.Entries.ItemOutputs[itemOutputIdx].AmountMinted++

	}

	modifiedItems := make([]types.Item, len(itemModifyOutputs))
	for _, itemModifyOutput := range itemModifyOutputs {
		itemInputIdx := 0
		for i, itemInput := range recipe.ItemInputs {
			if itemInput.ID == itemModifyOutput.ItemInputRef {
				itemInputIdx = i
				break
			}
		}
		item, found := k.GetItem(ctx, recipe.CookbookID, matchedItems[itemInputIdx].ID)
		if !found {
			return nil, nil, nil, sdkerrors.Wrap(sdkerrors.ErrKeyNotFound, fmt.Sprintf("item %s to modify not found", matchedItems[itemInputIdx].ID))
		}
		err := itemModifyOutput.Actualize(&item, ctx, addr, ec)
		if err != nil {
			return nil, nil, nil, err
		}
		modifiedItems = append(modifiedItems, item)
	}

	return coins, mintedItems, modifiedItems, nil
}

// CompletePendingExecution completes the execution
func (k Keeper) CompletePendingExecution(ctx sdk.Context, pendingExecution types.Execution) (types.Execution, error) {
	originalRecipe, _ := k.GetRecipe(ctx, pendingExecution.Recipe.CookbookID, pendingExecution.Recipe.ID)
	// check if recipe was updated after execution is submitted, and error out in such a case
	if semver.Compare(originalRecipe.Version, pendingExecution.Recipe.Version) != 0 {
		return types.Execution{}, types.ErrInvalidPendingExecution
	}

	celEnv, err := k.NewCelEnvCollectionFromRecipe(ctx, pendingExecution, pendingExecution.Recipe)
	if err != nil {
		return types.Execution{}, err
	}

	outputs, err := types.WeightedOutputsList(pendingExecution.Recipe.Outputs).Actualize(celEnv)
	if err != nil {
		return types.Execution{}, err
	}

	creator, err := sdk.AccAddressFromBech32(pendingExecution.Creator)
	if err != nil {
		return types.Execution{}, err
	}

	coins, mintItems, modifyItems, err := k.GenerateExecutionResult(ctx, creator, outputs, &pendingExecution.Recipe, celEnv, pendingExecution.ItemInputs)
	if err != nil {
		return types.Execution{}, err
	}

	// add coin outputs to accounts
	err = k.bankKeeper.AddCoins(ctx, creator, coins)
	if err != nil {
		return types.Execution{}, err
	}
	// add mint items to keeper
	itemOutputIDs := make([]string, len(mintItems))
	for i, item := range mintItems {
		id := k.AppendItem(ctx, item)
		itemOutputIDs[i] = id
	}
	// update modify items in keeper
	itemModifyOutputIDs := make([]string, len(mintItems))
	for i, item := range modifyItems {
		k.SetItem(ctx, item)
		itemModifyOutputIDs[i] = item.ID
	}
	// update recipe in keeper to keep track of mintedAmounts
	k.SetRecipe(ctx, pendingExecution.Recipe)

	// TODO unlock the locked coins and perform payment(s)
	// take percentage to send to module account of any non cookbook coin in coininputs

	pendingExecution.CoinOutputs = coins
	pendingExecution.ItemModifyOutputIDs = itemModifyOutputIDs
	pendingExecution.ItemOutputIDs = itemOutputIDs

	return pendingExecution, nil
}

// we should add a message CompleteExecutionEarly that can be called on pendingExecutions
//     compute the cost to pay as remaining blocks*cookbook.costPerBlock
//     distribute payments
// 	   change pendingExecution.blockHeight so that when summed to recipe.BlockInterval it gives the current block

// 3 moduleAccounts "PylonsFeeAccount", "LockedCoinsAccount", "LockedItemsAccount"
