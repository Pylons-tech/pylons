package keeper

import (
	"fmt"
	"github.com/google/cel-go/cel"
	celTypes "github.com/google/cel-go/common/types"
	"github.com/google/cel-go/common/types/ref"
	"github.com/google/cel-go/interpreter/functions"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// ExecutedByAddrCount is a function to get execution count for a given address
func (k Keeper) ExecutedByAddrCount(ctx sdk.Context, args ...ref.Val) ref.Val {
	// $addr, $cookbook_id, $recipe_id, $item_id
	addr := args[0].Value().(string)
	cookbookID := args[1].Value().(string)
	recipeID := args[2].Value().(string)
	itemID := args[3].Value().(string)
	count := 0
	executions := k.GetExecutionsByItem(ctx, cookbookID, recipeID, itemID)
	for _, exec := range executions {
		if exec.Creator == addr {
			count++
		}
	}
	return celTypes.Int(count)
}

// Overloads returns overloads
func (k Keeper) Overloads(ctx sdk.Context) []*functions.Overload {
	return append(types.BasicOverloads(),
		&functions.Overload{
			// operator for 1 param
			Operator: "block_since",
			Unary: func(arg ref.Val) ref.Val {
				return celTypes.Int(ctx.BlockHeight() - arg.Value().(int64))
			},
		},
		&functions.Overload{
			// operator for 4 params
			Operator: "executed_by_count",
			Function: func(args ...ref.Val) ref.Val {
				return k.ExecutedByAddrCount(ctx, args...)
			},
		},
	)
}

// NewCelEnvCollectionFromItem generate cel env collection for an item
func (k Keeper) NewCelEnvCollectionFromItem(ctx sdk.Context, recipeID, tradeID string, item types.Item) (types.CelEnvCollection, error) {
	varDefs := types.BasicVarDefs()
	variables := types.BasicVariables(ctx.BlockHeight(), recipeID, tradeID)
	varDefs, variables = types.AddVariableFromItem(varDefs, variables, "", item) // HP, level, attack

	funcs := cel.Functions(k.Overloads(ctx)...)

	env, err := cel.NewEnv(
		cel.Declarations(
			varDefs...,
		),
	)

	if err != nil {
		return types.CelEnvCollection{}, err
	}

	ec := types.NewCelEnvCollection(env, variables, funcs)
	return ec, nil
}

// NewCelEnvCollectionFromRecipe generate cel env collection from recipe itemInputs
func (k Keeper) NewCelEnvCollectionFromRecipe(ctx sdk.Context, pendingExecution types.Execution, recipe types.Recipe) (types.CelEnvCollection, error) {
	// create environment variables from matched items
	varDefs := types.BasicVarDefs()
	variables := types.BasicVariables(ctx.BlockHeight(), recipe.ID, "")
	itemInputs := recipe.ItemInputs

	for idx, itemRecord := range pendingExecution.ItemInputs {
		iPrefix1 := fmt.Sprintf("input%d", idx) + "."
		item, _ := k.GetItem(ctx, recipe.CookbookID, recipe.ID, itemRecord.ID)

		varDefs, variables = types.AddVariableFromItem(varDefs, variables, iPrefix1, item) // input0.level, input1.attack, input2.HP
		if itemInputs != nil && len(itemInputs) > idx && itemInputs[idx].ID != "" && itemInputs[idx].IDValidationError() == nil {
			iPrefix2 := itemInputs[idx].ID + "."
			varDefs, variables = types.AddVariableFromItem(varDefs, variables, iPrefix2, item) // sword.attack, monster.attack
		}
		// TODO ELSE???
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

	ec := types.NewCelEnvCollection(env, variables, funcs)
	return ec, err
}