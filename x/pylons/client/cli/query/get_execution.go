package query

import (
	"fmt"

	"github.com/MikeSofaer/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/spf13/cobra"
)

// GetExecution get an execution by GUID
func GetExecution(queryRoute string, cdc *codec.Codec) *cobra.Command {
	return &cobra.Command{
		Use:   "get_execution <id>",
		Short: "get an execution by id",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			cliCtx := context.NewCLIContext().WithCodec(cdc)

			res, err := cliCtx.QueryWithData(fmt.Sprintf("custom/%s/get_execution/%s", queryRoute, args[0]), nil)
			if err != nil {
				return fmt.Errorf(err.Error())
			}

			var out types.Cookbook
			cdc.MustUnmarshalJSON(res, &out)
			return cliCtx.PrintOutput(out)
		},
	}
}
