package cli

import (
	"encoding/json"
	"strconv"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	banktypes "github.com/cosmos/cosmos-sdk/x/bank/types"
	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

var _ = strconv.Itoa(0)

func CmdSetCookbookDenomMetadata() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "set-cookbook-denom-metadata [cookbookID] [denom] [description] [denomUnits] [base] [display]",
		Short: "Broadcast message set-cookbook-denom-metadata",
		Args:  cobra.ExactArgs(6),
		RunE: func(cmd *cobra.Command, args []string) error {
			argsCookbookID := args[0]
			argsDenom := args[1]
			argsDescription := args[2]
			argsDenomUnits := args[3]
			jsonArgsDenomUnits := make([]banktypes.DenomUnit, 0)
			err := json.Unmarshal([]byte(argsDenomUnits), &jsonArgsDenomUnits)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			argsBase := args[4]
			argsDisplay := args[5]

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgSetCookbookDenomMetadata(clientCtx.GetFromAddress().String(), argsCookbookID, argsDenom, argsDescription, jsonArgsDenomUnits, argsBase, argsDisplay)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}
