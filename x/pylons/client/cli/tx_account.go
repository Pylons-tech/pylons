package cli

import (
	"strconv"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

var _ = strconv.Itoa(0)

func CmdCreateAccount() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "create-account [token] [referralAddress]",
		Short: "initialize account from address",
		Long: `
Create a new account using an existing key from the keyring.

`,
		Example: `
pylonsd tx pylons create-account app-check-token pylo1tqqp6wmctv0ykatyaefsqy6stj92lnt800lkei --from joe

or 

pylonsd tx pylons create-account app-check-token pylo1tqqp6wmctv0ykatyaefsqy6stj92lnt800lkel --from pylo1tqqp6wmctv0ykatyaefsqy6stj92lnt800lkee 
		`,
		Args: cobra.ExactArgs(2),
		RunE: func(cmd *cobra.Command, args []string) error {
			token := args[0]
			referral := args[1]

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgCreateAccount(clientCtx.GetFromAddress().String(), token, referral)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}

			txf := tx.NewFactoryCLI(clientCtx, cmd.Flags())
			return GenerateOrBroadcastMsgs(clientCtx, txf, []sdk.Msg{msg}...)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}

func CmdSetUsername() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "set-username [username]",
		Short: "set username of account from address",
		Long: `
Set username of an account using an existing key from the keyring.

A valid username must respect the following rules:

	- Contain alphanumeric characters (a-z, A-Z, 0-9)
	- Contain non-repeating underscore (_), hyphen (-), and space characters
	- Cannot begin or end with (_), hyphen (-), or space
	- Cannot be an existing valid Cosmos SDK address

Note that the username and the key name that are used to sign the transaction _are not the same_.
`,
		Example: `
pylonsd tx pylons set-username myusername --from joe

or 

pylonsd tx pylons set-username myusername --from pylo1tqqp6wmctv0ykatyaefsqy6stj92lnt800lkee 
		`,
		Args: cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			username := args[0]

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgSetUsername(clientCtx.GetFromAddress().String(), username)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}

func CmdUpdateAccount() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "update-account [username]",
		Short: "broadcast message update-account",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			argsUsername := args[0]

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgUpdateAccount(clientCtx.GetFromAddress().String(), argsUsername)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}
