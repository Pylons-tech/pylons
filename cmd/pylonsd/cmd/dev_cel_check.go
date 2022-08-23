package cmd

import (
	"strconv"

	"github.com/Pylons-tech/pylons/x/pylons/types"
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

			env, err := cel.NewEnv(append(celVars, cel.Declarations(types.BasicVarDefs()...))...)
			if err != nil {
				panic(err)
			}
			ec := types.NewCelEnvCollection(env, varVals, cel.Functions())
			println("Result:")
			switch returnType {
			case "long":
				r, err := ec.EvalInt64(args[0])
				if err != nil {
					panic(err)
				}
				println(r)
			case "double":
				r, err := ec.EvalFloat64(args[0])
				if err != nil {
					panic(err)
				}
				println(r)
			case "string":
				r, err := ec.EvalString(args[0])
				if err != nil {
					panic(err)
				}
				println(r)
			}

		},
	}
	return cmd
}
