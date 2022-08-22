package cmd

import (
	"strconv"

	"github.com/google/cel-go/cel"
	"github.com/spf13/cobra"
)

func DevCelCheck() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "cel-check [expresssion] [type] [[var_type, var_name, var_value]...]",
		Short: "Compiles and runs a cel expression with the provided variables and return type",
		Args:  cobra.MinimumNArgs(2),
		Run: func(cmd *cobra.Command, args []string) {
			if (len(args)-2)%3 != 0 {
				panic("cel variables seem wrong - cel variables are provided as [type] [name] [value]")
			}
			returnType := args[1]
			rawArgs := args[2:]
			celVars := []cel.EnvOption{}
			varVals := map[string]interface{}{}
			var err error
			for i := 0; i < len(rawArgs); i += 3 {
				typeHint := rawArgs[i]
				varName := rawArgs[i+1]
				value := rawArgs[i+2]
				switch typeHint {
				case "string":
					celVars = append(celVars, cel.Variable(varName, cel.StringType))
					varVals[varName] = value
				case "long":
					celVars = append(celVars, cel.Variable(varName, cel.IntType))
					varVals[varName], err = strconv.Atoi(value)
				case "double":
					celVars = append(celVars, cel.Variable(varName, cel.DoubleType))
					varVals[varName], err = strconv.ParseFloat(value, 64)
				}
				if err != nil {
					panic(err)
				}
			}
			env, err := cel.NewEnv(celVars...)
			if err != nil {
				panic(err)
			}
			ast, iss := env.Parse(args[0])
			if iss.Err() != nil {
				panic(iss.Err())
			}
			checked, iss := env.Check(ast)
			// Report semantic errors, if present.
			if iss.Err() != nil {
				panic(iss.Err())
			}
			program, err := env.Program(checked)
			if err != nil {
				panic(err)
			}
			out, _, err := program.Eval(varVals)
			if err != nil {
				panic(err)
			}
			println("Result:")
			switch returnType {
			case "long":
				println(out.Value().(int64))
			case "double":
				println(out.Value().(float64))
			case "string":
				println(out.Value().(string))
			}

		},
	}
	return cmd
}
