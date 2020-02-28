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
		"attack": 1.5,
		"level":  1,
	}
	t.Log("NewEnv.err", err)
	out, err := CheckAndExecuteProgram(env, variables, `attack * 2.0`)
	t.Log("attack x 2.err", out, err)
	require.True(t, err == nil)
	out, err = CheckAndExecuteProgram(env, variables, `level + 1`)
	t.Log("attack + 1.err", out, err)
	require.True(t, err == nil)
	out, err = CheckAndExecuteProgram(env, variables, `name + "old"`)
	t.Log(`name + "old".err`, out, err)
	require.True(t, err == nil)
	out, err = CheckAndExecuteProgram(env, variables, `level + attack`)
	t.Log(`level + attack`, out, err)
	require.True(t, err != nil)
}
