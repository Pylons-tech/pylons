package types

import (
	"github.com/google/cel-go/checker/decls"
	"github.com/google/cel-go/interpreter/functions"
	exprpb "google.golang.org/genproto/googleapis/api/expr/v1alpha1"
)

// BasicVarDefs collect basic variable definitions
func BasicVarDefs() [](*exprpb.Decl) {
	varDefs := [](*exprpb.Decl){}

	varDefs = append(varDefs,
		decls.NewVar("lastBlockHeight", decls.Int),
		decls.NewVar("recipeID", decls.String),
		decls.NewVar("tradeID", decls.String),
	)

	varDefs = append(varDefs,
		RandFuncDecls,
		Log2FuncDecls,
		MinFuncDecls,
		MaxFuncDecls,
		BlockSinceDecls,
		ExecutedByCountDecls,
	)
	return varDefs
}

// BasicVariables initialize default variables
func BasicVariables(blockHeight int64, recipeID, tradeID string) map[string]interface{} {
	variables := map[string]interface{}{}
	variables["lastBlockHeight"] = blockHeight
	variables["recipeID"] = recipeID
	variables["tradeID"] = tradeID
	return variables
}

// BasicFunctions collect basic functions
func BasicFunctions() [](*functions.Overload) {
	return [](*functions.Overload){
		RandIntFunc,
		RandFunc,
		Log2DoubleFunc,
		Log2IntFunc,
		MinIntIntFunc,
		MinIntDoubleFunc,
		MinDoubleIntFunc,
		MinDoubleDoubleFunc,
		MaxIntIntFunc,
		MaxIntDoubleFunc,
		MaxDoubleIntFunc,
		MaxDoubleDoubleFunc,
	}
}

// AddVariableFromItem collect variables from item inputs
func AddVariableFromItem(varDefs [](*exprpb.Decl), variables map[string]interface{}, prefix string, item Item) ([](*exprpb.Decl), map[string]interface{}) {
	varDefs = append(varDefs, decls.NewVar(prefix+"lastUpdate", decls.Int))
	variables[prefix+"owner"] = item.Sender.String()
	variables[prefix+"itemID"] = item.ID
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
