package handlers

import (
	"encoding/json"
	"errors"
	"fmt"
	"strconv"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/google/cel-go/cel"
	"github.com/google/cel-go/checker/decls"
	exprpb "google.golang.org/genproto/googleapis/api/expr/v1alpha1"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// ExecProcess store and handle all the activities of execution
type ExecProcess struct {
	ctx          sdk.Context
	keeper       keeper.Keeper
	recipe       types.Recipe
	matchedItems []types.Item
	ec           types.CelEnvCollection
}

// SetMatchedItemsFromExecMsg calculate matched items into process storage from exec msg
func (p *ExecProcess) SetMatchedItemsFromExecMsg(ctx sdk.Context, msg *types.MsgExecuteRecipe) error {
	if len(msg.ItemIDs) != len(p.recipe.ItemInputs) {
		return errors.New("the item IDs count doesn't match the recipe input")
	}

	sender, _ := sdk.AccAddressFromBech32(msg.Sender)
	items, err := GetItemsFromIDs(p.ctx, p.keeper, msg.ItemIDs, sender)
	if err != nil {
		return err
	}

	// we validate and match items
	var matchedItems []types.Item
	for i, itemInput := range p.recipe.ItemInputs {
		matchedItem := items[i]
		ec, err := p.keeper.EnvCollection(ctx, msg.RecipeID, "", matchedItem)
		if err != nil {
			return fmt.Errorf("error creating env collection for %s item", matchedItem.String())
		}
		matchErr := itemInput.MatchError(matchedItem, ec)
		if matchErr != nil {
			return fmt.Errorf("[%d]th item does not match: %s item_id=%s", i, matchErr.Error(), matchedItem.ID)
		}
		execErr := matchedItem.NewRecipeExecutionError()
		if execErr != nil {
			return fmt.Errorf("[%d]th item is locked: %s item_id=%s", i, execErr.Error(), matchedItem.ID)
		}
		matchedItems = append(matchedItems, matchedItem)
	}
	p.matchedItems = matchedItems
	return nil
}

// GetMatchedItemFromIndex is matched item by index helper
func (p ExecProcess) GetMatchedItemFromIndex(index int) types.Item {
	if index < 0 || index >= len(p.matchedItems) {
		return types.Item{}
	}
	return p.matchedItems[index]
}

// Run execute the process and return result
func (p *ExecProcess) Run(sender sdk.AccAddress) ([]byte, error) {
	err := p.GenerateCelEnvVarFromInputItems()
	if err != nil {
		return []byte{}, err
	}

	outputs, err := types.WeightedOutputsList(p.recipe.Outputs).Actualize(p.ec)
	if err != nil {
		return []byte{}, err
	}
	ersl, err := p.AddExecutedResult(sender, outputs)

	if err != nil {
		return []byte{}, err
	}

	outputSTR, err := json.Marshal(ersl)

	if err != nil {
		return []byte{}, err
	}
	return outputSTR, nil
}

// AddExecutedResult add executed result from ExecProcess
func (p *ExecProcess) AddExecutedResult(sender sdk.AccAddress, entryIDs []string) ([]types.ExecuteRecipeSerialize, error) {
	var ersl []types.ExecuteRecipeSerialize
	usedItemInputIndexes := []int{}
	for _, entryID := range entryIDs {
		output, err := p.recipe.Entries.FindByID(entryID)
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
}

// UpdateItemFromModifyParams is used to update item passed via item input from modify params
func (p *ExecProcess) UpdateItemFromModifyParams(targetItem types.Item, toMod types.ItemModifyOutput) (*types.Item, error) {
	if toMod.Doubles != nil {
		dblKeyValues, err := types.DoubleParamList(toMod.Doubles).Actualize(p.ec)
		if err != nil {
			return &targetItem, errInternal(errors.New("error actualizing double upgrade values: " + err.Error()))
		}
		for idx, dbl := range dblKeyValues {
			dblKey, ok := targetItem.FindDoubleKey(dbl.Key)
			if !ok {
				return &targetItem, errInternal(errors.New("double key does not exist which needs to be upgraded"))
			}
			if len(toMod.Doubles[idx].Program) == 0 { // NO PROGRAM
				originValue := targetItem.Doubles[dblKey].Value
				upgradeAmount := dbl.Value
				targetItem.Doubles[dblKey].Value = originValue.Add(upgradeAmount)
			} else {
				targetItem.Doubles[dblKey].Value = dbl.Value
			}
		}
	}

	if toMod.Longs != nil {
		lngKeyValues, err := types.LongParamList(toMod.Longs).Actualize(p.ec)
		if err != nil {
			return &targetItem, errInternal(errors.New("error actualizing long upgrade values: " + err.Error()))
		}
		for idx, lng := range lngKeyValues {
			lngKey, ok := targetItem.FindLongKey(lng.Key)
			if !ok {
				return &targetItem, errInternal(errors.New("long key does not exist which needs to be upgraded"))
			}
			if len(toMod.Longs[idx].Program) == 0 { // NO PROGRAM
				targetItem.Longs[lngKey].Value += lng.Value
			} else {
				targetItem.Longs[lngKey].Value = lng.Value
			}
		}
	}

	if toMod.Strings != nil {
		strKeyValues, err := types.StringParamList(toMod.Strings).Actualize(p.ec)
		if err != nil {
			return &targetItem, errInternal(errors.New("error actualizing string upgrade values: " + err.Error()))
		}
		for _, str := range strKeyValues {
			strKey, ok := targetItem.FindStringKey(str.Key)
			if !ok {
				return &targetItem, errInternal(errors.New("string key does not exist which needs to be upgraded"))
			}
			targetItem.Strings[strKey].Value = str.Value
		}
	}

	sender, err := sdk.AccAddressFromBech32(targetItem.Sender)
	if err != nil {
		return nil, err
	}

	p.keeper.SetItemHistory(p.ctx, types.ItemHistory{
		ID:       types.KeyGen(sender),
		Owner:    sender,
		ItemID:   targetItem.ID,
		RecipeID: p.recipe.ID,
	})

	// after upgrading is done, OwnerRecipe is not set
	targetItem.OwnerRecipeID = ""
	targetItem.LastUpdate = p.ctx.BlockHeight()
	targetItem.SetTransferFee(targetItem.TransferFee + toMod.TransferFee)

	return &targetItem, nil
}

// AddVariableFromItem collect variables from item inputs
func AddVariableFromItem(varDefs [](*exprpb.Decl), variables map[string]interface{}, prefix string, item types.Item) ([](*exprpb.Decl), map[string]interface{}) {

	varDefs = append(varDefs, decls.NewVar(prefix+"lastUpdate", decls.Int))
	variables[prefix+"lastUpdate"] = item.LastUpdate
	variables[prefix+"transferFee"] = item.TransferFee

	for _, dbli := range item.Doubles {
		varDefs = append(varDefs, decls.NewVar(prefix+dbli.Key, decls.Double))
		fl, _ := strconv.ParseFloat(dbli.Value.String(), 64)
		variables[prefix+dbli.Key] = fl
	}
	for _, inti := range item.Longs {
		varDefs = append(varDefs, decls.NewVar(prefix+inti.Key, decls.Int))
		variables[prefix+inti.Key] = inti.Value
	}
	for _, stri := range item.Strings {
		varDefs = append(varDefs, decls.NewVar(prefix+stri.Key, decls.String))
		variables[prefix+stri.Key] = stri.Value
	}
	return varDefs, variables
}

// GenerateCelEnvVarFromInputItems generate cel env varaible from item inputs
func (p *ExecProcess) GenerateCelEnvVarFromInputItems() error {
	// create environment variables from matched items
	varDefs := types.BasicVarDefs()
	variables := types.BasicVariables(p.ctx.BlockHeight(), p.recipe.ID, "")
	itemInputs := p.recipe.ItemInputs

	for idx, item := range p.matchedItems {
		iPrefix1 := fmt.Sprintf("input%d", idx) + "."

		varDefs, variables = AddVariableFromItem(varDefs, variables, iPrefix1, item) // input0.level, input1.attack, input2.HP
		if itemInputs != nil && len(itemInputs) > idx && itemInputs[idx].ID != "" && itemInputs[idx].IDValidationError() == nil {
			iPrefix2 := itemInputs[idx].ID + "."
			varDefs, variables = AddVariableFromItem(varDefs, variables, iPrefix2, item) // sword.attack, monster.attack
		}
	}

	if len(p.matchedItems) > 0 {
		// first matched item
		varDefs, variables = types.AddVariableFromItem(varDefs, variables, "", p.GetMatchedItemFromIndex(0)) // HP, level, attack
	}

	funcs := cel.Functions(p.keeper.Overloads(p.ctx)...)

	env, err := cel.NewEnv(
		cel.Declarations(
			varDefs...,
		),
	)

	p.ec = types.NewCelEnvCollection(env, variables, funcs)
	return err
}

// GetEnvCollection get env collection
func (p *ExecProcess) GetEnvCollection() types.CelEnvCollection {
	return p.ec
}
