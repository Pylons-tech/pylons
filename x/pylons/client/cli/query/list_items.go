package query

import (
	"encoding/json"
	"fmt"

	"github.com/MikeSofaer/pylons/x/pylons/queriers"
	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/spf13/cobra"
)

// ItemsBySender queries the items
func ItemsBySender(queryRoute string, cdc *codec.Codec) *cobra.Command {
	return &cobra.Command{
		Use:   "items_by_sender",
		Short: "get all items for a user",
		Args:  cobra.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			cliCtx := context.NewCLIContext().WithCodec(cdc)

			res, err := cliCtx.QueryWithData(fmt.Sprintf("custom/%s/items_by_sender/%s", queryRoute, cliCtx.GetFromAddress().String()), nil)
			if err != nil {
				return fmt.Errorf(err.Error())
			}

			// fmt.Println("queryWithData", string(res))

			var out queriers.ItemResp
			err = json.Unmarshal(res, &out)
			if err != nil {
				return fmt.Errorf(err.Error())
			}
			// cdc.MustUnmarshalJSON(res, &out)
			return cliCtx.PrintOutput(out)
		},
	}
}
