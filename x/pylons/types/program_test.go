package types

import (
	"math"
	"testing"

	"github.com/google/cel-go/cel"
	"github.com/google/cel-go/checker/decls"
	"github.com/stretchr/testify/require"
)

func TestProgramWorkAsExpected(t *testing.T) {
	env, err := cel.NewEnv(
		cel.Declarations(
			decls.NewIdent("attack", decls.Double, nil),
			decls.NewIdent("level", decls.Int, nil),
			decls.NewIdent("name", decls.String, nil),
			decls.NewIdent("input0.attack", decls.Int, nil),
			decls.NewIdent("input1.attack", decls.Int, nil),
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
		),
	)
	t.Log("NewEnv.err", err)
	variables := map[string]interface{}{
		"name":          "shield",
		"attack":        5.0,
		"level":         3,
		"input0.attack": 2,
		"input1.attack": 3,
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
	)

	ec := NewCelEnvCollection(env, variables, funcs)

	// double test
	flo64, err := ec.EvalFloat64(`attack + 2.0`)
	t.Logf("attack x 2.err %f %v", flo64, err)
	require.True(t, flo64 == 7.0)
	require.True(t, err == nil)

	// integer test
	val64, err := ec.EvalInt64(`level + 1`)
	t.Logf("attack + 1.err %d %v", val64, err)
	require.True(t, val64 == 4)
	require.True(t, err == nil)

	// string test
	valstr, err := ec.EvalString(`name + "old"`)
	t.Log(`name + "old".err`, valstr, err)
	require.True(t, valstr == "shieldold")
	require.True(t, err == nil)

	// array env test
	val64, err = ec.EvalInt64(`input0.attack + input1.attack`)
	t.Log(`input0.attack + input1.attack`, val64, err)
	require.True(t, val64 == 5)
	require.True(t, err == nil)

	// random generation test with no param
	val64, err = ec.EvalInt64(`rand10()`)
	t.Log(`rand10`, val64, err)
	require.True(t, err == nil)

	// random generation test with 1 param
	val64, err = ec.EvalInt64(`rand(11)`)
	t.Log(`rand(11)`, val64, err)
	require.True(t, err == nil)

	flo64, err = ec.EvalFloat64(`rand()`)
	t.Log(`rand()`, flo64, err)
	require.True(t, err == nil)

	// random generation test with 1 param
	flo64, err = ec.EvalFloat64(`log2(1024.0)`)
	t.Log(`log2(1024.0)`, flo64, err)
	require.True(t, flo64 == 10)
	require.True(t, err == nil)

	flo64, err = ec.EvalFloat64(`log2(1024)`)
	t.Log(`log2(1024)`, flo64, err)
	require.True(t, flo64 == 10)
	require.True(t, err == nil)

	// error check
	flo64, err = ec.EvalFloat64(`log2(0)`)
	t.Log(`log2(0)`, flo64, err)
	require.True(t, flo64 == math.Inf(-1))
	require.True(t, err == nil)

	// error check
	flo64, err = ec.EvalFloat64(`log2(-1.0)`)
	t.Log(`log2(-1.0)`, flo64, err)
	require.True(t, math.IsNaN(flo64))
	require.True(t, err == nil)

	// multiply function test with 2 param
	val64, err = ec.EvalInt64(`multiply(11, 12)`)
	t.Log(`multiply(11, 12)`, val64, err)
	require.True(t, val64 == 132)
	require.True(t, err == nil)

	// min function test with 2 param
	val64, err = ec.EvalInt64(`min(10, 11)`)
	t.Log(`min(10, 11)`, val64, err)
	require.True(t, val64 == 10)
	require.True(t, err == nil)

	flo64, err = ec.EvalFloat64(`min(9.67, 10)`)
	t.Log(`min(9.67, 10)`, flo64, err)
	require.True(t, flo64 == 9.67)
	require.True(t, err == nil)

	flo64, err = ec.EvalFloat64(`min(12.322, 8)`)
	t.Log(`min(12.322, 8)`, flo64, err)
	require.True(t, flo64 == 8)
	require.True(t, err == nil)

	flo64, err = ec.EvalFloat64(`min(7.86, 8.9)`)
	t.Log(`min(7.86, 8.9)`, flo64, err)
	require.True(t, flo64 == 7.86)
	require.True(t, err == nil)

	// max function test with 2 param
	val64, err = ec.EvalInt64(`max(10, 11)`)
	t.Log(`max(10, 11)`, val64, err)
	require.True(t, val64 == 11)
	require.True(t, err == nil)

	flo64, err = ec.EvalFloat64(`max(9.67, 10)`)
	t.Log(`max(9.67, 10)`, flo64, err)
	require.True(t, flo64 == 10)
	require.True(t, err == nil)

	flo64, err = ec.EvalFloat64(`max(12.322, 8)`)
	t.Log(`max(12.322, 8)`, flo64, err)
	require.True(t, flo64 == 12.322)
	require.True(t, err == nil)

	flo64, err = ec.EvalFloat64(`max(7.86, 8.9)`)
	t.Log(`max(7.86, 8.9)`, flo64, err)
	require.True(t, flo64 == 8.9)
	require.True(t, err == nil)

	// int type conversion test
	val64, err = ec.EvalInt64(`int(2.1) * 2`)
	t.Log(`int(2.1) * 2`, val64, err)
	require.True(t, val64 == 4)
	require.True(t, err == nil)

	// float type conversion test
	flo64, err = ec.EvalFloat64(`double(2) * 2.5`)
	t.Log(`double(2) * 2.5`, flo64, err)
	require.True(t, flo64 == 5)
	require.True(t, err == nil)

	// string type conversion test
	valstr, err = ec.EvalString(`string(2.0 + 0.5)`)
	t.Log(`string(2.0 + 0.5)`, valstr, err)
	require.True(t, valstr == "2.5")
	require.True(t, err == nil)

	// rand, double, multiply and int merge test
	val64, err = ec.EvalInt64(`int(5.0 * double(rand(2)+4) )`)
	t.Log(`int(5.0 * double(rand(2)+4) )`, val64, err)
	require.True(t, val64 == 20 || val64 == 25 || val64 == 30)
	require.True(t, err == nil)

	// failing test
	out, err := ec.Eval(`level + attack`)
	t.Log(`level + attack`, out, err)
	require.True(t, err != nil)
}
