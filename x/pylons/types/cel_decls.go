package types

import (
	"math"
	"math/rand"

	"github.com/google/cel-go/checker/decls"
	"github.com/google/cel-go/common/types"
	"github.com/google/cel-go/common/types/ref"
	"github.com/google/cel-go/interpreter/functions"
	exprpb "google.golang.org/genproto/googleapis/api/expr/v1alpha1"
)

// RandFuncDecls is a global function for 1 param
var RandFuncDecls = decls.NewFunction("rand",
	decls.NewOverload("rand_int",
		[]*exprpb.Type{decls.Int},
		decls.Int),
	decls.NewOverload("rand",
		[]*exprpb.Type{},
		decls.Double),
)

// RandIntFunc is a overload function
var RandIntFunc = &functions.Overload{
	// operator for 1 param
	Operator: "rand_int",
	Unary: func(arg ref.Val) ref.Val {
		return types.Int(rand.Intn(int(arg.Value().(int64))))
	},
}

// RandFunc is a overload function
var RandFunc = &functions.Overload{
	// operator for 1 param
	Operator: "rand",
	Function: func(args ...ref.Val) ref.Val {
		return types.Double(rand.Float64())
	},
}

// Log2FuncDecls is a global function for 1 param
var Log2FuncDecls = decls.NewFunction("log2",
	decls.NewOverload("log2_double",
		[]*exprpb.Type{decls.Double},
		decls.Double),
	decls.NewOverload("log2_int",
		[]*exprpb.Type{decls.Int},
		decls.Double),
)

// Log2DoubleFunc is a global function for 1 param
var Log2DoubleFunc = &functions.Overload{
	// operator for 1 param
	Operator: "log2_double",
	Unary: func(arg ref.Val) ref.Val {
		return types.Double(math.Log2(arg.Value().(float64)))
	},
}

// Log2IntFunc is a global function for 1 param
var Log2IntFunc = &functions.Overload{
	// operator for 1 param
	Operator: "log2_int",
	Unary: func(arg ref.Val) ref.Val {
		return types.Double(math.Log2(float64(arg.Value().(int64))))
	},
}

// MinFuncDecls is a global function for 2 params
var MinFuncDecls = decls.NewFunction("min",
	decls.NewOverload("min_int_int",
		[]*exprpb.Type{decls.Int, decls.Int},
		decls.Int),
	decls.NewOverload("min_double_double",
		[]*exprpb.Type{decls.Double, decls.Double},
		decls.Double),
	decls.NewOverload("min_int_double",
		[]*exprpb.Type{decls.Int, decls.Double},
		decls.Double),
	decls.NewOverload("min_double_int",
		[]*exprpb.Type{decls.Double, decls.Int},
		decls.Double),
)

// MaxFuncDecls is a global function for 2 params
var MaxFuncDecls = decls.NewFunction("max",
	decls.NewOverload("max_int_int",
		[]*exprpb.Type{decls.Int, decls.Int},
		decls.Int),
	decls.NewOverload("max_double_double",
		[]*exprpb.Type{decls.Double, decls.Double},
		decls.Double),
	decls.NewOverload("max_int_double",
		[]*exprpb.Type{decls.Int, decls.Double},
		decls.Double),
	decls.NewOverload("max_double_int",
		[]*exprpb.Type{decls.Double, decls.Int},
		decls.Double),
)

// MinIntIntFunc is a global function for 2 params
var MinIntIntFunc = &functions.Overload{
	// operator for 2 param
	Operator: "min_int_int",
	Binary: func(lhs ref.Val, rhs ref.Val) ref.Val {
		lftInt64 := lhs.Value().(int64)
		rgtInt64 := rhs.Value().(int64)
		if lftInt64 > rgtInt64 {
			return types.Int(rgtInt64)
		}
		return types.Int(lftInt64)
	},
}

// MinDoubleDoubleFunc is a global function for 2 params
var MinDoubleDoubleFunc = &functions.Overload{
	// operator for 2 param
	Operator: "min_double_double",
	Binary: func(lhs ref.Val, rhs ref.Val) ref.Val {
		lftInt64 := lhs.Value().(float64)
		rgtInt64 := rhs.Value().(float64)
		if lftInt64 > rgtInt64 {
			return types.Double(rgtInt64)
		}
		return types.Double(lftInt64)
	},
}

// MinIntDoubleFunc is a global function for 2 params
var MinIntDoubleFunc = &functions.Overload{
	// operator for 2 param
	Operator: "min_int_double",
	Binary: func(lhs ref.Val, rhs ref.Val) ref.Val {
		lftInt64 := float64(lhs.Value().(int64))
		rgtInt64 := rhs.Value().(float64)
		if lftInt64 > rgtInt64 {
			return types.Double(rgtInt64)
		}
		return types.Double(lftInt64)
	},
}

// MinDoubleIntFunc is a global function for 2 params
var MinDoubleIntFunc = &functions.Overload{
	// operator for 2 param
	Operator: "min_double_int",
	Binary: func(lhs ref.Val, rhs ref.Val) ref.Val {
		lftInt64 := lhs.Value().(float64)
		rgtInt64 := float64(rhs.Value().(int64))
		if lftInt64 > rgtInt64 {
			return types.Double(rgtInt64)
		}
		return types.Double(lftInt64)
	},
}

// MaxIntIntFunc is a global function for 2 params
var MaxIntIntFunc = &functions.Overload{
	// operator for 2 param
	Operator: "max_int_int",
	Binary: func(lhs ref.Val, rhs ref.Val) ref.Val {
		lftInt64 := lhs.Value().(int64)
		rgtInt64 := rhs.Value().(int64)
		if lftInt64 < rgtInt64 {
			return types.Int(rgtInt64)
		}
		return types.Int(lftInt64)
	},
}

// MaxDoubleDoubleFunc is a global function for 2 params
var MaxDoubleDoubleFunc = &functions.Overload{
	// operator for 2 param
	Operator: "max_double_double",
	Binary: func(lhs ref.Val, rhs ref.Val) ref.Val {
		lftInt64 := lhs.Value().(float64)
		rgtInt64 := rhs.Value().(float64)
		if lftInt64 < rgtInt64 {
			return types.Double(rgtInt64)
		}
		return types.Double(lftInt64)
	},
}

// MaxIntDoubleFunc is a global function for 2 params
var MaxIntDoubleFunc = &functions.Overload{
	// operator for 2 param
	Operator: "max_int_double",
	Binary: func(lhs ref.Val, rhs ref.Val) ref.Val {
		lftInt64 := float64(lhs.Value().(int64))
		rgtInt64 := rhs.Value().(float64)
		if lftInt64 < rgtInt64 {
			return types.Double(rgtInt64)
		}
		return types.Double(lftInt64)
	},
}

// MaxDoubleIntFunc is a global function for 2 params
var MaxDoubleIntFunc = &functions.Overload{
	// operator for 2 param
	Operator: "max_double_int",
	Binary: func(lhs ref.Val, rhs ref.Val) ref.Val {
		lftInt64 := lhs.Value().(float64)
		rgtInt64 := float64(rhs.Value().(int64))
		if lftInt64 < rgtInt64 {
			return types.Double(rgtInt64)
		}
		return types.Double(lftInt64)
	},
}

// Rand10FuncDecls is a global function
var Rand10FuncDecls = decls.NewFunction("rand10",
	decls.NewOverload("rand10",
		[]*exprpb.Type{},
		decls.Int),
)

// Rand10Func is a global function
var Rand10Func = &functions.Overload{
	// operator for no param
	Operator: "rand10",
	Function: func(args ...ref.Val) ref.Val {
		return types.Int(rand.Intn(10))
	},
}

// MultiplyFuncDecls is a global function
var MultiplyFuncDecls = decls.NewFunction("multiply",
	decls.NewOverload("multiply_int_int",
		[]*exprpb.Type{decls.Int, decls.Int},
		decls.Int),
)

// MultiplyFunc is a global function
var MultiplyFunc = &functions.Overload{
	// operator for 2 param
	Operator: "multiply_int_int",
	Binary: func(lhs ref.Val, rhs ref.Val) ref.Val {
		return types.Int(lhs.Value().(int64) * rhs.Value().(int64))
	},
}

// BlockSinceDecls is a global function
var BlockSinceDecls = decls.NewFunction("block_since",
	decls.NewOverload("block_since",
		[]*exprpb.Type{decls.Int},
		decls.Int),
)

// ExecutedByCountDecls is a global function
var ExecutedByCountDecls = decls.NewFunction("executed_by_count",
	decls.NewOverload("executed_by_count",
		[]*exprpb.Type{decls.String, decls.String, decls.String},
		decls.Int),
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

// BasicOverloads collect basic functions
func BasicOverloads() [](*functions.Overload) {
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
	varDefs = append(varDefs,
		decls.NewVar(prefix+"lastUpdate", decls.Int),
		decls.NewVar(prefix+"itemID", decls.String),
		decls.NewVar(prefix+"owner", decls.String),
		decls.NewVar(prefix+"transferFee", decls.Int),
	)

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
