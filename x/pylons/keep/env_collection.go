package keep

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/google/cel-go/cel"
	celTypes "github.com/google/cel-go/common/types"
	"github.com/google/cel-go/common/types/ref"
	"github.com/google/cel-go/interpreter/functions"
)

// ExecutedByCount is a function to get execution count
func (keeper Keeper) ExecutedByCount(ctx sdk.Context, args ...ref.Val) ref.Val {
	// $owner, $recipe_id, $item_id
	owner := args[0].Value().(string)
	recipeID := args[1].Value().(string)
	itemID := args[2].Value().(string)
	matchingCount := 0
	iterator := keeper.GetItemHistoryIterator(ctx)
	for ; iterator.Valid(); iterator.Next() {
		historyID := string(iterator.Key())
		itemHistory, err := keeper.GetItemHistory(ctx, historyID)
		if err != nil {
			panic(err)
		}
		if itemHistory.Owner.String() == owner &&
			itemHistory.RecipeID == recipeID &&
			itemHistory.ItemID == itemID {
			matchingCount++
		}
	}
	return celTypes.Int(matchingCount)
}

// Overloads returns overloads
func (keeper Keeper) Overloads(ctx sdk.Context) []*functions.Overload {
	return append(types.BasicOverloads(),
		&functions.Overload{
			// operator for 1 param
			Operator: "block_since",
			Unary: func(arg ref.Val) ref.Val {
				return celTypes.Int(ctx.BlockHeight() - arg.Value().(int64))
			},
		},
		&functions.Overload{
			// operator for 3 params
			Operator: "executed_by_count",
			Function: func(args ...ref.Val) ref.Val {
				return keeper.ExecutedByCount(ctx, args...)
			},
		},
	)
}

// EnvCollection returns env collection for an item
func (keeper Keeper) EnvCollection(ctx sdk.Context, recipeID, tradeID string, item types.Item) (types.CelEnvCollection, error) {
	varDefs := types.BasicVarDefs()
	variables := types.BasicVariables(ctx.BlockHeight(), recipeID, tradeID)
	varDefs, variables = types.AddVariableFromItem(varDefs, variables, "", item) // HP, level, attack

	funcs := cel.Functions(keeper.Overloads(ctx)...)

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
