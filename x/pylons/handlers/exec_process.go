package handlers

import (
	"encoding/json"
	"errors"
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/google/cel-go/cel"
	"github.com/google/cel-go/checker/decls"
	"github.com/google/cel-go/common/types/ref"
	"github.com/google/cel-go/interpreter/functions"

	celTypes "github.com/google/cel-go/common/types"
	exprpb "google.golang.org/genproto/googleapis/api/expr/v1alpha1"
)

// ExecProcess store and handle all the activities of execution
type ExecProcess struct {
	ctx          sdk.Context
	keeper       keep.Keeper
	recipe       types.Recipe
	matchedItems []types.Item
	ec           types.CelEnvCollection
}

// SetMatchedItemsFromExecMsg calculate matched items into process storage from exec msg
func (p *ExecProcess) SetMatchedItemsFromExecMsg(msg msgs.MsgExecuteRecipe) error {
	if len(msg.ItemIDs) != len(p.recipe.ItemInputs) {
		return errors.New("the item IDs count doesn't match the recipe input")
	}

	items, err := GetItemsFromIDs(p.ctx, p.keeper, msg.ItemIDs, msg.Sender)
	if err != nil {
		return err
	}

	// we validate and match items
	var matchedItems []types.Item
	for i, itemInput := range p.recipe.ItemInputs {
		matchedItem := items[i]
		matchErr := itemInput.MatchError(matchedItem)
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

	outputs, err := p.recipe.Outputs.Actualize(p.ec)
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
func (p *ExecProcess) AddExecutedResult(sender sdk.AccAddress, entryIDs []string) ([]ExecuteRecipeSerialize, error) {
	var ersl []ExecuteRecipeSerialize
	usedItemInputIndexes := []int{}
	for _, entryID := range entryIDs {
		output, err := p.recipe.Entries.FindByID(entryID)
		if err != nil {
			return ersl, err
		}

		switch output := output.(type) {
		case types.CoinOutput:
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

			_, err := p.keeper.CoinKeeper.AddCoins(p.ctx, sender, ocl)
			if err != nil {
				return ersl, err
			}
			ersl = append(ersl, ExecuteRecipeSerialize{
				Type:   "COIN",
				Coin:   coinOutput.Coin,
				Amount: coinAmount,
			})
		case types.ItemModifyOutput:
			var outputItem *types.Item

			itemInputIndex := p.recipe.GetItemInputRefIndex(output.ItemInputRef)
			if itemInputIndex < 0 {
				return ersl, errInternal(fmt.Errorf("no item input with ID=%s exist", output.ItemInputRef))
			}
			inputItem := p.GetMatchedItemFromIndex(itemInputIndex)

			// Collect itemInputRefs that are used on output
			usedItemInputIndexes = append(usedItemInputIndexes, itemInputIndex)

			// Modify item according to ModifyParams section
			outputItem, err = p.UpdateItemFromModifyParams(inputItem, output)
			if err != nil {
				return ersl, errInternal(err)
			}
			if err = p.keeper.SetItem(p.ctx, *outputItem); err != nil {
				return ersl, errInternal(err)

			}
			ersl = append(ersl, ExecuteRecipeSerialize{
				Type:   "ITEM",
				ItemID: outputItem.ID,
			})
		case types.ItemOutput:
			itemOutput := output
			outputItem, err := itemOutput.Item(p.recipe.CookbookID, sender, p.ec)
			if err != nil {
				return ersl, errInternal(err)
			}
			if err = p.keeper.SetItem(p.ctx, *outputItem); err != nil {
				return ersl, errInternal(err)
			}
			ersl = append(ersl, ExecuteRecipeSerialize{
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
	dblKeyValues, err := toMod.Doubles.Actualize(p.ec)
	if err != nil {
		return &targetItem, errInternal(errors.New("error actualizing double upgrade values: " + err.Error()))
	}
	for idx, dbl := range dblKeyValues {
		dblKey, ok := targetItem.FindDoubleKey(dbl.Key)
		if !ok {
			return &targetItem, errInternal(errors.New("double key does not exist which needs to be upgraded"))
		}
		if len(toMod.Doubles[idx].Program) == 0 { // NO PROGRAM
			originValue := targetItem.Doubles[dblKey].Value.Float()
			upgradeAmount := dbl.Value.Float()
			targetItem.Doubles[dblKey].Value = types.ToFloatString(originValue + upgradeAmount)
		} else {
			targetItem.Doubles[dblKey].Value = dbl.Value
		}
	}

	lngKeyValues, err := toMod.Longs.Actualize(p.ec)
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

	strKeyValues, err := toMod.Strings.Actualize(p.ec)
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
		variables[prefix+dbli.Key] = dbli.Value.Float()
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
	varDefs := [](*exprpb.Decl){}
	variables := map[string]interface{}{}

	varDefs = append(varDefs, decls.NewVar("lastBlockHeight", decls.Int))
	variables["lastBlockHeight"] = p.ctx.BlockHeight()

	for idx, item := range p.matchedItems {
		iPrefix := fmt.Sprintf("input%d.", idx)

		varDefs, variables = AddVariableFromItem(varDefs, variables, iPrefix, item) // input0.level, input1.attack, input2.HP
	}

	if len(p.matchedItems) > 0 {
		// first matched item
		varDefs, variables = AddVariableFromItem(varDefs, variables, "", p.GetMatchedItemFromIndex(0)) // HP, level, attack
	}

	varDefs = append(varDefs,
		types.RandFuncDecls,
		types.Log2FuncDecls,
		types.MinFuncDecls,
		types.MaxFuncDecls,
		decls.NewFunction("block_since",
			decls.NewOverload("block_since",
				[]*exprpb.Type{decls.Int},
				decls.Int),
		),
	)

	funcs := cel.Functions(
		types.RandIntFunc,
		types.RandFunc,
		types.Log2DoubleFunc,
		types.Log2IntFunc,
		types.MinIntIntFunc,
		types.MinIntDoubleFunc,
		types.MinDoubleIntFunc,
		types.MinDoubleDoubleFunc,
		types.MaxIntIntFunc,
		types.MaxIntDoubleFunc,
		types.MaxDoubleIntFunc,
		types.MaxDoubleDoubleFunc,
		&functions.Overload{
			// operator for 1 param
			Operator: "block_since",
			Unary: func(arg ref.Val) ref.Val {
				return celTypes.Int(p.ctx.BlockHeight() - arg.Value().(int64))
			},
		})

	env, err := cel.NewEnv(
		cel.Declarations(
			varDefs...,
		),
	)

	p.ec = types.NewCelEnvCollection(env, variables, funcs)
	return err
}
