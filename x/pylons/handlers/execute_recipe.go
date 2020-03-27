package handlers

import (
	"encoding/json"
	"errors"
	"fmt"
	"math/rand"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/google/cel-go/cel"
	"github.com/google/cel-go/checker/decls"
	celTypes "github.com/google/cel-go/common/types"
	"github.com/google/cel-go/common/types/ref"
	"github.com/google/cel-go/interpreter/functions"
	exprpb "google.golang.org/genproto/googleapis/api/expr/v1alpha1"
)

// ExecuteRecipeResp is the response for executeRecipe
type ExecuteRecipeResp struct {
	Message string
	Status  string
	Output  []byte
}

type ItemUpgradeResult struct {
	ItemID  string
	Doubles struct {
		Key  string
		From float64
		To   float64
	}
	Longs struct {
		Key  string
		From int
		To   int
	}
	Strings struct {
		Key  string
		From string
		To   string
	}
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

func Contains(arr []int, it int) bool {
	for _, a := range arr {
		if a == it {
			return true
		}
	}
	return false
}

func GetMatchedItems(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgExecuteRecipe, recipe types.Recipe) ([]types.Item, error) {
	// TODO: need to check it's working correctly when it is recipe for merging to same items

	var inputItems []types.Item
	keys := make(map[string]bool)

	for _, id := range msg.ItemIDs {
		if _, value := keys[id]; !value {
			keys[id] = true

			item, err := keeper.GetItem(ctx, id)
			if err != nil {
				return nil, err
			}
			if !item.Sender.Equals(msg.Sender) {
				return nil, errors.New("item owner is not same as sender")
			}

			inputItems = append(inputItems, item)
		} else {
			return nil, errors.New("multiple use of same item as item inputs")
		}
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

func AddExecutedResult(ctx sdk.Context, keeper keep.Keeper, matchedItems []types.Item, entries types.EntriesList, outputs []int,
	ec types.CelEnvCollection,
	sender sdk.AccAddress, cbID string,
) ([]ExecuteRecipeSerialize, sdk.Error) {
	var ersl []ExecuteRecipeSerialize
	var err error
	usedItemInputIndexes := []int{}
	for _, outputIndex := range outputs {
		if len(entries) <= outputIndex || outputIndex < 0 {
			return ersl, sdk.ErrInternal(fmt.Sprintf("index out of range entries[%d] with length %d on output", outputIndex, len(entries)))
		}
		output := entries[outputIndex]

		switch output.(type) {
		case types.CoinOutput:
			coinOutput, _ := output.(types.CoinOutput)
			var coinAmount int64
			if len(coinOutput.Count) > 0 {
				val64, err := ec.EvalInt64(coinOutput.Count)
				if err != nil {
					return ersl, sdk.ErrInternal(err.Error())
				}
				coinAmount = val64
			} else {
				return ersl, sdk.ErrInternal("length of coin output program shouldn't be zero")
			}
			ocl := sdk.Coins{sdk.NewCoin(coinOutput.Coin, sdk.NewInt(coinAmount))}

			_, _, err := keeper.CoinKeeper.AddCoins(ctx, sender, ocl)
			if err != nil {
				return ersl, err
			}
			ersl = append(ersl, ExecuteRecipeSerialize{
				Type:   "COIN",
				Coin:   coinOutput.Coin,
				Amount: coinAmount,
			})
		case types.ItemOutput:
			itemOutput, _ := output.(types.ItemOutput)
			var outputItem *types.Item

			if itemOutput.ItemInputRef == -1 {
				outputItem, err = itemOutput.Item(cbID, sender, ec)
				if err != nil {
					return ersl, sdk.ErrInternal(err.Error())
				}
			} else {
				// Collect itemInputRefs that are used on output
				usedItemInputIndexes = append(usedItemInputIndexes, itemOutput.ItemInputRef)

				// Modify item according to ToModify section
				outputItem, err = UpdateItemFromUpgradeParams(matchedItems[itemOutput.ItemInputRef], itemOutput.ToModify)
				if err != nil {
					return ersl, sdk.ErrInternal(err.Error())
				}
			}
			if err = keeper.SetItem(ctx, *outputItem); err != nil {
				return ersl, sdk.ErrInternal(err.Error())
			}
			ersl = append(ersl, ExecuteRecipeSerialize{
				Type:   "ITEM",
				ItemID: outputItem.ID,
			})
		default:
			return ersl, sdk.ErrInternal("no item nor coin type created")
		}
	}

	// Remove items which are not referenced on output
	for idx, ci := range matchedItems {
		if !Contains(usedItemInputIndexes, idx) {
			keeper.DeleteItem(ctx, ci.ID)
		}
	}
	return ersl, nil
}

func GenerateCelEnvVarFromInputItems(matchedItems []types.Item) (types.CelEnvCollection, error) {
	// create environment variables from matched items
	varDefs := [](*exprpb.Decl){}
	variables := map[string]interface{}{}
	for idx, item := range matchedItems {
		iPrefix := fmt.Sprintf("input%d.", idx)
		for _, dbli := range item.Doubles {
			varDefs = append(varDefs, decls.NewIdent(iPrefix+dbli.Key, decls.Double, nil))
			variables[iPrefix+dbli.Key] = dbli.Value.Float() // input0.attack
			if idx == 0 {
				varDefs = append(varDefs, decls.NewIdent(dbli.Key, decls.Double, nil))
				variables[dbli.Key] = dbli.Value.Float() // attack
			}
		}
		for _, inti := range item.Longs {
			varDefs = append(varDefs, decls.NewIdent(iPrefix+inti.Key, decls.Int, nil))
			variables[iPrefix+inti.Key] = inti.Value // input0.level
			if idx == 0 {
				varDefs = append(varDefs, decls.NewIdent(inti.Key, decls.Int, nil))
				variables[inti.Key] = inti.Value // level
			}
		}
		for _, stri := range item.Strings {
			varDefs = append(varDefs, decls.NewIdent(iPrefix+stri.Key, decls.String, nil))
			variables[iPrefix+stri.Key] = stri.Value // input0.name
			if idx == 0 {
				varDefs = append(varDefs, decls.NewIdent(stri.Key, decls.String, nil))
				variables[stri.Key] = stri.Value // name
			}
		}
	}

	varDefs = append(varDefs, decls.NewFunction("randi",
		decls.NewOverload("randi_int",
			[]*exprpb.Type{decls.Int},
			decls.Int),
	))

	funcs := cel.Functions(&functions.Overload{
		// operator for 1 param
		Operator: "randi_int",
		Unary: func(arg ref.Val) ref.Val {
			return celTypes.Int(rand.Intn(int(arg.Value().(int64))))
		},
	})

	env, err := cel.NewEnv(
		cel.Declarations(
			varDefs...,
		),
	)
	return types.NewCelEnvCollection(env, variables, funcs), err
}

func GenerateItemFromRecipe(ctx sdk.Context, keeper keep.Keeper, sender sdk.AccAddress, cbID string, matchedItems []types.Item, recipe types.Recipe) ([]byte, error) {
	// TODO should reset item.OwnerRecipeID to "" when this item is used as catalyst

	ec, err := GenerateCelEnvVarFromInputItems(matchedItems)

	output, err := recipe.Outputs.Actualize(ec)
	if err != nil {
		return []byte{}, err
	}
	ersl, err := AddExecutedResult(ctx, keeper, matchedItems, recipe.Entries, output, ec, sender, cbID)

	if err != nil {
		return []byte{}, err
	}

	outputSTR, err2 := json.Marshal(ersl)

	if err2 != nil {
		return []byte{}, err2
	}
	return outputSTR, nil
}

func HandleItemGeneration(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgExecuteRecipe, recipe types.Recipe, matchedItems []types.Item) sdk.Result {

	outputSTR, err := GenerateItemFromRecipe(ctx, keeper, msg.Sender, recipe.CookbookID, matchedItems, recipe)
	if err != nil {
		return errInternal(err)
	}

	return marshalJson(ExecuteRecipeResp{
		Message: "successfully executed the recipe",
		Status:  "Success",
		Output:  outputSTR,
	})
}

func UpdateItemFromUpgradeParams(targetItem types.Item, ToUpgrade types.ItemModifyParams) (*types.Item, sdk.Error) {
	ec, err := GenerateCelEnvVarFromInputItems([]types.Item{targetItem})

	if err != nil {
		return &targetItem, sdk.ErrInternal("error creating environment for go-cel program" + err.Error())
	}

	if dblKeyValues, err := ToUpgrade.Doubles.Actualize(ec); err != nil {
		return &targetItem, sdk.ErrInternal("error actualizing double upgrade values: " + err.Error())
	} else {
		for idx, dbl := range dblKeyValues {
			dblKey, ok := targetItem.FindDoubleKey(dbl.Key)
			if !ok {
				return &targetItem, sdk.ErrInternal("double key does not exist which needs to be upgraded")
			}
			if len(ToUpgrade.Doubles[idx].Program) == 0 { // NO PROGRAM
				originValue := targetItem.Doubles[dblKey].Value.Float()
				upgradeAmount := dbl.Value.Float()
				targetItem.Doubles[dblKey].Value = types.ToFloatString(originValue + upgradeAmount)
			} else {
				targetItem.Doubles[dblKey].Value = dbl.Value
			}
		}
	}

	if lngKeyValues, err := ToUpgrade.Longs.Actualize(ec); err != nil {
		return &targetItem, sdk.ErrInternal("error actualizing long upgrade values: " + err.Error())
	} else {
		for idx, lng := range lngKeyValues {
			lngKey, ok := targetItem.FindLongKey(lng.Key)
			if !ok {
				return &targetItem, sdk.ErrInternal("long key does not exist which needs to be upgraded")
			}
			if len(ToUpgrade.Longs[idx].Program) == 0 { // NO PROGRAM
				targetItem.Longs[lngKey].Value += lng.Value
			} else {
				targetItem.Longs[lngKey].Value = lng.Value
			}
		}
	}

	if strKeyValues, err := ToUpgrade.Strings.Actualize(ec); err != nil {
		return &targetItem, sdk.ErrInternal("error actualizing string upgrade values: " + err.Error())
	} else {
		for _, str := range strKeyValues {
			strKey, ok := targetItem.FindStringKey(str.Key)
			if !ok {
				return &targetItem, sdk.ErrInternal("string key does not exist which needs to be upgraded")
			}
			targetItem.Strings[strKey].Value = str.Value
		}
	}

	// after upgrading is done, OwnerRecipe is not set
	targetItem.OwnerRecipeID = ""

	return &targetItem, nil
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
		exec := types.NewExecution(recipe.ID, recipe.CookbookID, cl, rcpOwnMatchedItems,
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
		return marshalJson(ExecuteRecipeResp{
			Message: "scheduled the recipe",
			Status:  "Success",
			Output:  outputSTR,
		})
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

	return HandleItemGeneration(ctx, keeper, msg, recipe, matchedItems)
}
