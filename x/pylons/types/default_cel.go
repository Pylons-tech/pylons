package types

import (
	"github.com/google/cel-go/cel"
	"github.com/google/cel-go/checker/decls"
	celTypes "github.com/google/cel-go/common/types"
	"github.com/google/cel-go/common/types/ref"
	"github.com/google/cel-go/interpreter/functions"
)

func GetDefaultCelEnv() CelEnvCollection {
	env, _ := cel.NewEnv(
		cel.Declarations(
			decls.NewVar("recipeID", decls.String),
			decls.NewVar("attack", decls.Double),
			decls.NewVar("level", decls.Int),
			decls.NewVar("wins", decls.Int),
			decls.NewVar("name", decls.String),
			decls.NewVar("input0.attack", decls.Int),
			decls.NewVar("input0.owner", decls.String),
			decls.NewVar("input0.itemID", decls.String),
			decls.NewVar("input1.attack", decls.Int),
			// global function for no param
			Rand10FuncDecls,
			// global function for 1 param
			RandFuncDecls,
			// global function for 1 param
			Log2FuncDecls,
			// global function for 2 param
			MultiplyFuncDecls,
			MinFuncDecls,
			MaxFuncDecls,
			ExecutedByCountDecls,
		),
	)
	variables := map[string]interface{}{
		"recipeID":      "recipeID",
		"name":          "shield",
		"attack":        5.0,
		"level":         3,
		"input0.attack": 2,
		"input1.attack": 3,
		"input0.owner":  "pylo1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337",
		"input0.itemID": "shieldID",
		"wins":          1,
	}

	//nolint:staticcheck // TODO: FIX THIS VIA A REFACTOR OF THIS LINE, WHICH WILL REQUIRE MORE CODE
	funcs := cel.Functions(
		Rand10Func,
		RandIntFunc,
		RandFunc,
		Log2DoubleFunc,
		Log2IntFunc,
		MaxDoubleDoubleFunc,
		MaxDoubleIntFunc,
		MaxIntDoubleFunc,
		MaxIntIntFunc,
		MinDoubleDoubleFunc,
		MinDoubleIntFunc,
		MinIntDoubleFunc,
		MinIntIntFunc,
		MultiplyFunc,
		&functions.Overload{
			// operator for 3 params
			Operator: "executed_by_count",
			Function: func(args ...ref.Val) ref.Val {
				// $owner, $recipe_id, $item_id
				owner := args[0].Value().(string)
				recipeID := args[1].Value().(string)
				itemID := args[2].Value().(string)
				matchingCount := len(owner) + len(recipeID) + len(itemID)
				return celTypes.Int(matchingCount)
			},
		},
	)
	return NewCelEnvCollection(env, variables, funcs)
}
