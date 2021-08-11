package keeper

import (
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// EntryListsByIDs is a function to find an entry by ID
func EntryListsByIDs(idList []string, recipe types.Recipe) ([]types.CoinOutput, []types.ItemOutput, []types.ItemModifyOutput, error) {
	coinOutputs := make([]types.CoinOutput, 0)
	itemOutputs := make([]types.ItemOutput, 0)
	itemModifyOutputs := make([]types.ItemModifyOutput, 0)

Loop:
	for _, id := range idList {
		for _, coinOutput := range recipe.Entries.CoinOutputs {
			if coinOutput.ID == id {
				coinOutputs = append(coinOutputs, coinOutput)
				continue Loop
			}
		}

		for _, itemOutput := range recipe.Entries.ItemOutputs {
			if itemOutput.ID == id {
				itemOutputs = append(itemOutputs, itemOutput)
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

// AddExecutedResult add executed result from ExecProcess
func (k Keeper) AddExecutedResult(ctx sdk.Context, addr sdk.AccAddress, entryIDs []string, recipe types.Recipe, ec types.CelEnvCollection) ([]string, error) {
	coinOutputs, itemOutputs, itemModifyOutputs, err := EntryListsByIDs(entryIDs, recipe)
	if err != nil {
		return nil, err
	}

	coinPrefix := recipe.CookbookID
	coins := make([]sdk.Coin, len(coinOutputs))
	for i, coinOutput := range coinOutputs {
		coins[i].Denom = coinPrefix + "/" + coinOutput.Coin.Denom
		coins[i].Amount = coinOutput.Coin.Amount
	}
	err = k.bankKeeper.AddCoins(ctx, addr, coins)
	if err != nil {
		return nil, err
	}

	itemIDs := make([]string, len(itemOutputs))
	for i, itemOutput := range itemOutputs {
		item, err := itemOutput.Actualize(ctx, recipe.CookbookID, recipe.ID, addr, ec)
		if err != nil {
			return nil, err
		}
		itemIDs[i] = k.AppendItem(ctx, item)
	}

	itemModifyIDs := make([]string, len(itemModifyOutputs))
	for i, itemModifyOutput := range itemModifyOutputs {
		itemModifyIDs[i] = itemModifyOutput.ID // TODO add actualize logic
	}

	// TODO
	// are we checking if there are any unused IDs in
	// between entryIDs and [itemOutputs, itemModifyOutputs, coinOutputs] ???

	// usedItemInputIndexes := []int{}
	for _, entryID := range entryIDs {
		panic(entryID)
	}
	/*
			output, err :=
			if err != nil {
				return ersl, err
			}

			switch output := output.(type) {
			case *types.CoinOutput:
				coinOutput := output
				var coinAmount int64
				if len(coinOutput.Count) > 0 {
					val64, err := p.ec.EvalInt64(coinOutput.Count)
					if err != nil {
						return ersl, errInternal(err)
					}
					coinAmount = val64
				} else {
					return ersl, errInternal(errors.New("length of coin output program shouldn't be zero"))
				}
				ocl := sdk.Coins{sdk.NewCoin(coinOutput.Coin, sdk.NewInt(coinAmount))}

				err := p.keeper.CoinKeeper.AddCoins(p.ctx, sender, ocl)
				if err != nil {
					return ersl, err
				}
				ersl = append(ersl, types.ExecuteRecipeSerialize{
					Type:   "COIN",
					Coin:   coinOutput.Coin,
					Amount: coinAmount,
				})
			case *types.ItemModifyOutput:
				var outputItem *types.Item

				itemInputIndex := p.recipe.GetItemInputRefIndex(output.ItemInputRef)
				if itemInputIndex < 0 {
					return ersl, errInternal(fmt.Errorf("no item input with ID=%s exist", output.ItemInputRef))
				}
				inputItem := p.GetMatchedItemFromIndex(itemInputIndex)

				// Collect itemInputRefs that are used on output
				usedItemInputIndexes = append(usedItemInputIndexes, itemInputIndex)

				// Modify item according to ModifyParams section
				outputItem, err = p.UpdateItemFromModifyParams(inputItem, *output)
				if err != nil {
					return ersl, errInternal(err)
				}
				if err = p.keeper.SetItem(p.ctx, *outputItem); err != nil {
					return ersl, errInternal(err)

				}
				ersl = append(ersl, types.ExecuteRecipeSerialize{
					Type:   "ITEM",
					ItemID: outputItem.ID,
				})
			case *types.ItemOutput:
				itemOutput := output
				outputItem, err := itemOutput.Item(p.recipe.CookbookID, sender, p.ec)
				if err != nil {
					return ersl, errInternal(err)
				}
				if err = p.keeper.SetItem(p.ctx, outputItem); err != nil {
					return ersl, errInternal(err)
				}
				ersl = append(ersl, types.ExecuteRecipeSerialize{
					Type:   "ITEM",
					ItemID: outputItem.ID,
				})
			default:
				return ersl, errInternal(errors.New("no item nor coin type created"))
			}
		}

		// Remove items which are not referenced on output
		for idx, ci := range p.matchedItems {
			if !Contains(usedItemInputIndexes, idx) {
				p.keeper.DeleteItem(p.ctx, ci.ID)
			}
		}
		return ersl, nil
	*/

	return nil, nil
}

// func CompletePendingExecution
//    Unlock coins
//    "Run"
//			GenerateCelEnvVarFromInputItems()
//          Actualize values for both ItemOutput and ItemModifyOutput
//          Mint Items or Modify existing with the computed value
//	  send coins owed

// CompletePendingExecution
func (k Keeper) CompletePendingExecution(ctx sdk.Context, pendingExecution types.Execution, recipe types.Recipe) error {
	celEnv, err := k.NewCelEnvCollectionFromRecipe(ctx, pendingExecution, recipe)
	if err != nil {
		return err
	}

	outputs, err := types.WeightedOutputsList(recipe.Outputs).Actualize(celEnv)
	if err != nil {
		return err
	}

	creator, err := sdk.AccAddressFromBech32(pendingExecution.Creator)
	if err != nil {
		return err
	}

	// TODO use this output list
	_, err = k.AddExecutedResult(ctx, creator, outputs, recipe, celEnv)
	if err != nil {
		return err
	}

	// TODO unlock the locked coins and perform payment

	return nil
}

// we should add a message CompleteExecutionEarly that can be called on pendingExecutions
//     compute the cost to pay as remaining blocks*cookbook.costPerBlock
//     distribute payments
// 	   change pendingExecution.blockHeight so that when summed to recipe.BlockInterval it gives the current block

// 3 moduleAccounts "PylonsFeeAccount", "LockedCoinsAccount", "LockedItemsAccount"
