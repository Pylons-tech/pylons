package types

import (
	"math"
	"testing"

	"github.com/google/cel-go/cel"
	"github.com/google/cel-go/checker/decls"
	celTypes "github.com/google/cel-go/common/types"
	"github.com/google/cel-go/common/types/ref"
	"github.com/google/cel-go/interpreter/functions"
	"github.com/stretchr/testify/require"
)

func TestProgramWorkAsExpected(t *testing.T) {
	env, err := cel.NewEnv(
		cel.Declarations(
			decls.NewVar("recipeID", decls.String),
			decls.NewVar("attack", decls.Double),
			decls.NewVar("level", decls.Int),
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
	t.Log("NewEnv.err", err)
	variables := map[string]interface{}{
		"recipeID":      "recipeID",
		"name":          "shield",
		"attack":        5.0,
		"level":         3,
		"input0.attack": 2,
		"input1.attack": 3,
		"input0.owner":  "cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337",
		"input0.itemID": "shieldID",
	}

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

	ec := NewCelEnvCollection(env, variables, funcs)

	// double test
	flo64, err := ec.EvalFloat64(`attack + 2.0`)
	t.Logf("attack x 2.err %f %v", flo64, err)
	require.True(t, flo64 == 7.0)
	require.NoError(t, err)

	// integer test
	val64, err := ec.EvalInt64(`level + 1`)
	t.Logf("attack + 1.err %d %v", val64, err)
	require.True(t, val64 == 4)
	require.NoError(t, err)

	// string test
	valstr, err := ec.EvalString(`name + "old"`)
	t.Log(`name + "old".err`, valstr, err)
	require.True(t, valstr == "shieldold")
	require.NoError(t, err)

	// array env test
	val64, err = ec.EvalInt64(`input0.attack + input1.attack`)
	t.Log(`input0.attack + input1.attack`, val64, err)
	require.Equal(t, val64, int64(5))
	require.NoError(t, err)

	// random generation test with no param
	val64, err = ec.EvalInt64(`rand10()`)
	t.Log(`rand10`, val64, err)
	require.NoError(t, err)

	// random generation test with 1 param
	val64, err = ec.EvalInt64(`rand(11)`)
	t.Log(`rand(11)`, val64, err)
	require.NoError(t, err)

	flo64, err = ec.EvalFloat64(`rand()`)
	t.Log(`rand()`, flo64, err)
	require.NoError(t, err)

	// random generation test with 1 param
	flo64, err = ec.EvalFloat64(`log2(1024.0)`)
	t.Log(`log2(1024.0)`, flo64, err)
	require.True(t, flo64 == 10)
	require.NoError(t, err)

	flo64, err = ec.EvalFloat64(`log2(1024)`)
	t.Log(`log2(1024)`, flo64, err)
	require.True(t, flo64 == 10)
	require.NoError(t, err)

	// error check
	flo64, err = ec.EvalFloat64(`log2(0)`)
	t.Log(`log2(0)`, flo64, err)
	require.True(t, flo64 == math.Inf(-1))
	require.NoError(t, err)

	// error check
	flo64, err = ec.EvalFloat64(`log2(-1.0)`)
	t.Log(`log2(-1.0)`, flo64, err)
	require.True(t, math.IsNaN(flo64))
	require.NoError(t, err)

	// multiply function test with 2 param
	val64, err = ec.EvalInt64(`multiply(11, 12)`)
	t.Log(`multiply(11, 12)`, val64, err)
	require.True(t, val64 == 132)
	require.NoError(t, err)

	// min function test with 2 param
	val64, err = ec.EvalInt64(`min(10, 11)`)
	t.Log(`min(10, 11)`, val64, err)
	require.True(t, val64 == 10)
	require.NoError(t, err)

	flo64, err = ec.EvalFloat64(`min(9.67, 10)`)
	t.Log(`min(9.67, 10)`, flo64, err)
	require.True(t, flo64 == 9.67)
	require.NoError(t, err)

	flo64, err = ec.EvalFloat64(`min(12.322, 8)`)
	t.Log(`min(12.322, 8)`, flo64, err)
	require.True(t, flo64 == 8)
	require.NoError(t, err)

	flo64, err = ec.EvalFloat64(`min(7.86, 8.9)`)
	t.Log(`min(7.86, 8.9)`, flo64, err)
	require.True(t, flo64 == 7.86)
	require.NoError(t, err)

	// max function test with 2 param
	val64, err = ec.EvalInt64(`max(10, 11)`)
	t.Log(`max(10, 11)`, val64, err)
	require.True(t, val64 == 11)
	require.NoError(t, err)

	flo64, err = ec.EvalFloat64(`max(9.67, 10)`)
	t.Log(`max(9.67, 10)`, flo64, err)
	require.True(t, flo64 == 10)
	require.NoError(t, err)

	flo64, err = ec.EvalFloat64(`max(12.322, 8)`)
	t.Log(`max(12.322, 8)`, flo64, err)
	require.True(t, flo64 == 12.322)
	require.NoError(t, err)

	flo64, err = ec.EvalFloat64(`max(7.86, 8.9)`)
	t.Log(`max(7.86, 8.9)`, flo64, err)
	require.True(t, flo64 == 8.9)
	require.NoError(t, err)

	// int type conversion test
	val64, err = ec.EvalInt64(`int(2.1) * 2`)
	t.Log(`int(2.1) * 2`, val64, err)
	require.True(t, val64 == 4)
	require.NoError(t, err)

	// float type conversion test
	flo64, err = ec.EvalFloat64(`double(2) * 2.5`)
	t.Log(`double(2) * 2.5`, flo64, err)
	require.True(t, flo64 == 5)
	require.NoError(t, err)

	// string type conversion test
	valstr, err = ec.EvalString(`string(2.0 + 0.5)`)
	t.Log(`string(2.0 + 0.5)`, valstr, err)
	require.True(t, valstr == "2.5")
	require.NoError(t, err)

	// rand, double, multiply and int merge test
	val64, err = ec.EvalInt64(`int(5.0 * double(rand(2)+4) )`)
	t.Log(`int(5.0 * double(rand(2)+4) )`, val64, err)
	require.True(t, val64 == 20 || val64 == 25 || val64 == 30)
	require.NoError(t, err)

	// executed_by_count(owner, recipeID, itemID)
	val64, err = ec.EvalInt64(`executed_by_count(input0.owner, recipeID, input0.itemID)`)
	require.Equal(t, val64, int64(len(
		variables["recipeID"].(string)+variables["input0.owner"].(string)+variables["input0.itemID"].(string),
	)))
	require.NoError(t, err)

	// failing test
	_, err = ec.Eval(`level + attack`)
	require.True(t, err != nil)
}
