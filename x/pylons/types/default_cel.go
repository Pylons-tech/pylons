package types

import (
	"github.com/google/cel-go/cel"
	"github.com/google/cel-go/checker/decls"
	celTypes "github.com/google/cel-go/common/types"
	"github.com/google/cel-go/common/types/ref"
	"github.com/google/cel-go/interpreter/functions"
	expr "google.golang.org/genproto/googleapis/api/expr/v1alpha1"
	exprpb "google.golang.org/genproto/googleapis/api/expr/v1alpha1"
)

func GetDefaultCelEnv(vars []*CelVariable) CelEnvCollection {
	varDefs := make([]*exprpb.Decl, 0)
	for _, elem := range vars {
		varDefs = append(varDefs, decls.NewVar(elem.Variable, elem.Type))
	}
	env, _ := cel.NewEnv(
		cel.Declarations(
			varDefs...,
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
	}
	for _, elem := range vars {
		variables[elem.Variable] = elem.Value
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

type CelVariable struct {
	Variable string
	Type     *expr.Type
	Value    any
}

const (
	BasicVariableBlockHeight = "lastBlockHeight"
	BasicVariableRecipeID    = "recipeID"
	BasicVariableTradeID     = "tradeID"
)
