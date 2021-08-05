package keeper

import (
	"github.com/google/cel-go/cel"
	celTypes "github.com/google/cel-go/common/types"
	"github.com/google/cel-go/common/types/ref"
	"github.com/google/cel-go/interpreter/functions"

	sdkTypes "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// ExecutedByAddrCount is a function to get execution count
func (k Keeper) ExecutedByAddrCount(ctx sdkTypes.Context, args ...ref.Val) ref.Val {
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
func (k Keeper) Overloads(ctx sdkTypes.Context) []*functions.Overload {
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

// EnvCollection returns env collection for an item
func (k Keeper) EnvCollection(ctx sdkTypes.Context, recipeID, tradeID string, item types.Item) (types.CelEnvCollection, error) {
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
