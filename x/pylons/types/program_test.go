package types

import (
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
		),
	)
	variables := map[string]interface{}{
		"name":   "shield",
		"attack": 5.0,
		"level":  3,
	}
	t.Log("NewEnv.err", err)
	out, err := CheckAndExecuteProgram(env, variables, `attack + 2.0`)
	flo64, _ := getFloat(out.Value())
	t.Logf("attack x 2.err %f %v", flo64, err)
	require.True(t, err == nil)
	out, err = CheckAndExecuteProgram(env, variables, `level + 1`)
	val64, _ := out.Value().(int64)
	t.Logf("attack + 1.err %d %v", val64, err)
	require.True(t, err == nil)
	out, err = CheckAndExecuteProgram(env, variables, `name + "old"`)
	t.Log(`name + "old".err`, out.Value(), err)
	require.True(t, err == nil)
	out, err = CheckAndExecuteProgram(env, variables, `level + attack`)
	t.Log(`level + attack`, out, err)
	require.True(t, err != nil)
}
