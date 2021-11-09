package cli

import (
	"encoding/base64"
	"errors"
	"strconv"

	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

var _ = strconv.Itoa(0)

func CmdGenerateSignedAPIToken() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "sign-api-token [api-token]",
		Short: "generate signature for provided API token (used for external identification)",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			apiToken := args[0]

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			if clientCtx.GetFromAddress().Empty() {
				return errors.New("must use an identity to sign (use '--from' flag)")
			}

			txf := tx.NewFactoryCLI(clientCtx, cmd.Flags())
			sigBytes, err := SignAPIToken(txf, clientCtx.GetFromName(), apiToken)
			if err != nil {
				return err
			}

			sigBase64 := base64.StdEncoding.EncodeToString(sigBytes)

			return printOutput(clientCtx, apiToken, sigBase64)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}

func SignAPIToken(txf tx.Factory, name, apiToken string) ([]byte, error) {
	if txf.Keybase() == nil {
		return nil, errors.New("keybase must be set prior to signing a transaction")
	}

	bytesToSign := []byte(apiToken)

	// Sign those bytes
	sigBytes, _, err := txf.Keybase().Sign(name, bytesToSign)
	if err != nil {
		return nil, err
	}

	return sigBytes, nil
}

func printOutput(ctx client.Context, token, sigBase64 string) error {
	msg := types.CreatePaymentAccount{
		Address:   ctx.GetFromAddress().String(),
		Token:     token,
		Signature: sigBase64,
	}

	return ctx.PrintProto(&msg)
}
