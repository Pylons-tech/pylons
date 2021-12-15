package cli

import (
	"fmt"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/spf13/cobra"

	"github.com/spf13/cast"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func CmdCreateCookbook() *cobra.Command {

	longText := fmt.Sprintf(`
Create a new cookbook using the following arguments :

* id : a unique identifier to your cookbook. Only letters, numbers and underscore (should not be the first character) allowed 
* name: a human readable name for your cookbook, with a minimum of %d characters long 
* description : A more detailed description of your cookbook. Minimum %d chars long
* developer : name of the developer
* version : the version of the cookbook in semVer format, ex.: v0.0.0
* support-email : a valid email
* enabled : whether or not the cookbook is enabled

Note that the --from flag is mandatory, as indicates the key to be used to sign the transaction. 

		`, types.DefaultMinFieldLength, types.DefaultMinFieldLength)
	cmd := &cobra.Command{
		Use:   "create-cookbook [id] [name] [description] [developer] [version] [support-email] [enabled]",
		Short: "create new cookbook",
		Long:  longText,
		Example: `
pylonsd tx pylons create-cookbook "loud123456" "Legend of the Undead Dragon" "Cookbook for running pylons recreation of LOUD" "Pylons Inc" v0.3.1 test@pylons.com true --from joe
			`,
		Args: cobra.ExactArgs(7),
		RunE: func(cmd *cobra.Command, args []string) error {
			id := args[0]
			argsName := args[1]
			argsDescription := args[2]
			argsDeveloper := args[3]
			argsVersion := args[4]
			argsSupportEmail := args[5]

			argsEnabled, err := cast.ToBoolE(args[6])
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgCreateCookbook(clientCtx.GetFromAddress().String(), id, argsName, argsDescription, argsDeveloper, argsVersion, argsSupportEmail, argsEnabled)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}

func CmdUpdateCookbook() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "update-cookbook [id] [name] [description] [developer] [version] [support-email] [cost-per-block] [enabled]",
		Short: "update cookbook",
		Args:  cobra.ExactArgs(7),
		RunE: func(cmd *cobra.Command, args []string) error {
			id := args[0]
			argsName := args[1]
			argsDescription := args[2]
			argsDeveloper := args[3]
			argsVersion := args[4]
			argsSupportEmail := args[5]

			argsEnabled, err := cast.ToBoolE(args[6])
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgUpdateCookbook(clientCtx.GetFromAddress().String(), id, argsName, argsDescription, argsDeveloper, argsVersion, argsSupportEmail, argsEnabled)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}
