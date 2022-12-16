package types

import (
	"github.com/google/cel-go/cel"
	"github.com/google/cel-go/checker/decls"
	celTypes "github.com/google/cel-go/common/types"
	"github.com/google/cel-go/common/types/ref"
	"github.com/google/cel-go/interpreter/functions"
	exprpb "google.golang.org/genproto/googleapis/api/expr/v1alpha1"
)

func GetDefaultCelEnv() ([]*exprpb.Decl, map[string]interface{}, cel.ProgramOption) {
	varDefs := []*exprpb.Decl{
		decls.NewVar("recipeID", decls.String),
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
	}
	variables := map[string]interface{}{
		"recipeID": "recipeID",
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
	return varDefs, variables, funcs
}

func GetCustomCelEnv(inputItems []ItemInput, varDefs []*exprpb.Decl, variables map[string]interface{}, funcs cel.ProgramOption) CelEnvCollection {
	for _, ii := range inputItems {
		for _, dbli := range ii.Doubles {
			varDefs = append(varDefs, decls.NewVar(dbli.Key, decls.Double))
			variables[dbli.Key] = 0.0
		}
		for _, inti := range ii.Longs {
			varDefs = append(varDefs, decls.NewVar(inti.Key, decls.Int))
			variables[inti.Key] = 0
		}
		for _, stri := range ii.Strings {
			varDefs = append(varDefs, decls.NewVar(stri.Key, decls.String))
			variables[stri.Key] = ""
		}
	}
	env, _ := cel.NewEnv(
		cel.Declarations(varDefs...),
	)
	return NewCelEnvCollection(env, variables, funcs)
}
