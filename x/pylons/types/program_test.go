package types

import (
	"math/rand"
	"testing"

	"github.com/google/cel-go/cel"
	"github.com/google/cel-go/checker/decls"
	"github.com/google/cel-go/common/types"
	"github.com/google/cel-go/common/types/ref"
	"github.com/google/cel-go/interpreter/functions"
	"github.com/stretchr/testify/require"
	exprpb "google.golang.org/genproto/googleapis/api/expr/v1alpha1"
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
			decls.NewFunction("rand10",
				decls.NewOverload("rand10",
					[]*exprpb.Type{},
					decls.Int),
			),
			// global function for 1 param
			decls.NewFunction("randi",
				decls.NewOverload("randi_int",
					[]*exprpb.Type{decls.Int},
					decls.Int),
			),
			// global function for 2 param
			decls.NewFunction("multiply",
				decls.NewOverload("multiply_int_int",
					[]*exprpb.Type{decls.Int, decls.Int},
					decls.Int),
			),
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

	funcs := cel.Functions(&functions.Overload{
		// operator for no param
		Operator: "rand10",
		Function: func(args ...ref.Val) ref.Val {
			return types.Int(rand.Intn(10))
		},
	}, &functions.Overload{
		// operator for 1 param
		Operator: "randi_int",
		Unary: func(arg ref.Val) ref.Val {
			return types.Int(rand.Intn(int(arg.Value().(int64))))
		},
	}, &functions.Overload{
		// operator for 2 param
		Operator: "multiply_int_int",
		Binary: func(lhs ref.Val, rhs ref.Val) ref.Val {
			return types.Int(lhs.Value().(int64) * rhs.Value().(int64))
		},
	})

	// double test
	out, err := CheckAndExecuteProgram(env, variables, funcs, `attack + 2.0`)
	flo64, _ := getFloat(out.Value())
	t.Logf("attack x 2.err %f %v", flo64, err)
	require.True(t, flo64 == 7.0)
	require.True(t, err == nil)

	// integer test
	out, err = CheckAndExecuteProgram(env, variables, funcs, `level + 1`)
	val64, _ := out.Value().(int64)
	t.Logf("attack + 1.err %d %v", val64, err)
	require.True(t, val64 == 4)
	require.True(t, err == nil)

	// string test
	out, err = CheckAndExecuteProgram(env, variables, funcs, `name + "old"`)
	t.Log(`name + "old".err`, out.Value(), err)
	require.True(t, out.Value() == "shieldold")
	require.True(t, err == nil)

	// array env test
	out, err = CheckAndExecuteProgram(env, variables, funcs, `input0.attack + input1.attack`)
	val64, _ = out.Value().(int64)
	t.Log(`input0.attack + input1.attack`, val64, err)
	require.True(t, val64 == 5)
	require.True(t, err == nil)

	// random generation test with no param
	out, err = CheckAndExecuteProgram(env, variables, funcs, `rand10()`)
	t.Log(`rand10`, out, err)
	require.True(t, err == nil)

	// random generation test with 1 param
	out, err = CheckAndExecuteProgram(env, variables, funcs, `randi(11)`)
	t.Log(`randi(11)`, out, err)
	require.True(t, err == nil)

	// multiply function test with 2 param
	out, err = CheckAndExecuteProgram(env, variables, funcs, `multiply(11, 12)`)
	t.Log(`multiply(11, 12)`, out, err)
	require.True(t, out.Value().(int64) == 132)
	require.True(t, err == nil)

	// int type conversion test
	out, err = CheckAndExecuteProgram(env, variables, funcs, `int(2.1) * 2`)
	t.Log(`int(2.1) * 2`, out, err)
	require.True(t, out.Value().(int64) == 4)
	require.True(t, err == nil)

	// float type conversion test
	out, err = CheckAndExecuteProgram(env, variables, funcs, `double(2) * 2.5`)
	t.Log(`double(2) * 2.5`, out, err)
	require.True(t, out.Value().(float64) == 5)
	require.True(t, err == nil)

	// string type conversion test
	out, err = CheckAndExecuteProgram(env, variables, funcs, `string(2.0 + 0.5)`)
	t.Log(`string(2.0 + 0.5)`, out, err)
	require.True(t, out.Value().(string) == "2.5")
	require.True(t, err == nil)

	// randi, double, multiply and int merge test
	out, err = CheckAndExecuteProgram(env, variables, funcs, `int(5.0 * double(randi(2)+4) )`)
	t.Log(`int(5.0 * double(randi(2)+4) )`, out, err)
	val64 = out.Value().(int64)
	require.True(t, val64 == 20 || val64 == 25 || val64 == 30)
	require.True(t, err == nil)

	// failing test
	out, err = CheckAndExecuteProgram(env, variables, funcs, `level + attack`)
	t.Log(`level + attack`, out, err)
	require.True(t, err != nil)
}
