package query

import (
	"errors"
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/queriers"

	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/keys"
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

// GetPylonsBalance queries the pylons balance
func GetPylonsBalance(queryRoute string, cdc *codec.Codec) *cobra.Command {
	ccb := &cobra.Command{
		Use:   "balance [name]",
		Short: "get pylons balance",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			cliCtx := context.NewCLIContext().WithCodec(cdc)

			kb, err := keys.NewKeyBaseFromDir(viper.GetString(flags.FlagHome))

			if err != nil {
				return errors.New("cannot get the keys from home")
			}

			info, err := kb.Get(args[0])
			if err != nil {
				return errors.New(err.Error())
			}

			res, _, err := cliCtx.QueryWithData(fmt.Sprintf("custom/%s/balance/%s", queryRoute, info.GetAddress()), nil)
			if err != nil {
				return fmt.Errorf(err.Error())
			}

			var out queriers.QueryResBalance
			cdc.MustUnmarshalJSON(res, &out)
			return cliCtx.PrintOutput(out)
		},
	}
	return ccb
}
