package cli

import (
	"encoding/json"
	"strconv"

	"github.com/spf13/cast"

	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

var _ = strconv.Itoa(0)

func CmdExecuteRecipe() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "execute-recipe [cookbook-id] [recipe-id] [coin-inputs-index] [item-ids] [payment-info]",
		Short: "execute recipe",
		Args:  cobra.ExactArgs(5),
		RunE: func(cmd *cobra.Command, args []string) error {
			argsCookbookID := args[0]
			argsRecipeID := args[1]
			argsCoinInputsIndex, err := cast.ToUint64E(args[2])
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			argsItemIDs := args[3]
			jsonArgsItemIDs := make([]string, 0)
			err = json.Unmarshal([]byte(argsItemIDs), &jsonArgsItemIDs)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			argsPaymentInfo := args[4]
			jsonArgsPaymentInfo := make([]types.PaymentInfo, 0)
			err = json.Unmarshal([]byte(argsPaymentInfo), &jsonArgsPaymentInfo)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgExecuteRecipe(clientCtx.GetFromAddress().String(), argsCookbookID, argsRecipeID, argsCoinInputsIndex, jsonArgsItemIDs, jsonArgsPaymentInfo)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}
