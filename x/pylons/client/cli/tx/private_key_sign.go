package tx

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/tx"
	authclient "github.com/cosmos/cosmos-sdk/x/auth/client"
	authsigning "github.com/cosmos/cosmos-sdk/x/auth/signing"

	tmcrypto "github.com/tendermint/tendermint/crypto"

	"github.com/cosmos/cosmos-sdk/client/flags"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

const (
	flagAppend       = "append"
	flagValidateSigs = "validate-signatures"
	flagOffline      = "offline"
	flagSigOnly      = "signature-only"
	flagOutfile      = "output-document"
	flagPrivateKey   = "private-key"
)

// PrivateKeySign returns the transaction sign result from private key.
func PrivateKeySign() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "sign [file]",
		Short: "Sign transactions generated offline",
		Long: `Sign transactions created with the --generate-only flag.
It will read a transaction from [file], sign it, and print its JSON encoding.

If the flag --signature-only flag is set, it will output a JSON representation
of the generated signature only.

If the flag --validate-signatures is set, then the command would check whether all required
signers have signed the transactions, whether the signatures were collected in the right
order, and if the signature is valid over the given transaction. If the --offline
flag is also set, signature validation over the transaction will be not be
performed as that will require RPC communication with a full node.

The --offline flag makes sure that the client will not reach out to full node.
As a result, the account and sequence number queries will not be performed and
it is required to set such parameters manually. Note, invalid values will cause
the transaction to fail.

The --multisig=<multisig_key> flag generates a signature on behalf of a multisig account
key. It implies --signature-only. Full multisig signed transactions may eventually
be generated via the 'multisign' command.
`,
		PreRun: preSignCmd,
		RunE:   makeSignCmd(),
		Args:   cobra.ExactArgs(1),
	}

	cmd.Flags().Bool(
		flagAppend, true,
		"Append the signature to the existing ones. If disabled, old signatures would be overwritten. Ignored if --multisig is on",
	)
	cmd.Flags().Bool(
		flagValidateSigs, false,
		"Print the addresses that must sign the transaction, those who have already signed it, and make sure that signatures are in the correct order",
	)
	cmd.Flags().Bool(flagSigOnly, false, "Print only the generated signature, then exit")
	cmd.Flags().String(flagOutfile, "", "The document will be written to the given file instead of STDOUT")

	cmd.Flags().String(
		flagPrivateKey, "",
		"Private key flag for transaction sign",
	)

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}

func preSignCmd(cmd *cobra.Command, _ []string) {
	// Conditionally mark the account and sequence numbers required as no RPC
	// query will be done.
	if offline, _ := cmd.Flags().GetBool(flags.FlagOffline); offline {
		cmd.MarkFlagRequired(flags.FlagAccountNumber)
		cmd.MarkFlagRequired(flags.FlagSequence)
	}
}

// func populateAccountFromState(
// 	txBldr tx.Factory, clientCtx client.Context, addr sdk.AccAddress,
// ) (tx.Factory, error) {

// 	num, seq, err := clientCtx.AccountRetriever.GetAccountNumberSequence(clientCtx, addr)
// 	if err != nil {
// 		return txBldr, err
// 	}

// 	return txBldr.WithAccountNumber(num).WithSequence(seq), nil
// }

// func isTxSigner(user sdk.AccAddress, signers []sdk.AccAddress) bool {
// 	for _, s := range signers {
// 		if bytes.Equal(user.Bytes(), s.Bytes()) {
// 			return true
// 		}
// 	}

// 	return false
// }

// Sign signs the msg with the named key. It returns an error if the key doesn't
// exist or the decryption fails.
func Sign(priv tmcrypto.PrivKey, msg []byte) (sig []byte, pub tmcrypto.PubKey, err error) {
	sig, err = priv.Sign(msg)
	if err != nil {
		return nil, nil, err
	}

	return sig, priv.PubKey(), nil
}

func makeSignCmd() func(cmd *cobra.Command, args []string) error {
	return func(cmd *cobra.Command, args []string) error {
		clientCtx, err := client.GetClientTxContext(cmd)
		if err != nil {
			return err
		}
		clientCtx, txFactory, stdTx, err := readTxAndInitContexts(clientCtx, cmd, args[0])
		if err != nil {
			return err
		}
		txConfig := clientCtx.TxConfig

		offline, _ := cmd.Flags().GetBool(flagOffline)
		from, _ := cmd.Flags().GetString(flags.FlagFrom)

		if ok, _ := cmd.Flags().GetBool(flagValidateSigs); ok {
			if !printAndValidateSigs(cmd, clientCtx, txFactory.ChainID(), stdTx, offline) {
				return fmt.Errorf("signatures validation failed")
			}

			return nil
		}

		// if --signature-only is on, then override --append
		generateSignatureOnly := viper.GetBool(flagSigOnly)
		txBuilder, err := txConfig.WrapTxBuilder(stdTx)
		if err != nil {
			return err
		}

		err = authclient.SignTx(txFactory, clientCtx, from, txBuilder, offline, true)
		if err != nil {
			return err
		}

		json, err := getSignatureJSON(txConfig, txBuilder, generateSignatureOnly)
		if err != nil {
			return err
		}

		if str, _ := cmd.Flags().GetString(flagOutfile); str == "" {
			fmt.Printf("%s\n", json)
			return nil
		}

		fp, err := os.OpenFile(
			viper.GetString(flagOutfile), os.O_RDWR|os.O_CREATE|os.O_TRUNC, 0644,
		)
		if err != nil {
			return err
		}

		defer fp.Close()
		fmt.Fprintf(fp, "%s\n", json)

		return nil
	}
}

func getSignatureJSON(txConfig client.TxConfig, txBldr client.TxBuilder, generateSignatureOnly bool) ([]byte, error) {
	parsedTx := txBldr.GetTx()
	if generateSignatureOnly {
		sigs, err := parsedTx.GetSignaturesV2()
		if err != nil {
			return nil, err
		}
		return txConfig.MarshalSignatureJSON(sigs)
	}
	return txConfig.TxJSONEncoder()(parsedTx)
}

// printAndValidateSigs will validate the signatures of a given transaction over
// its expected signers. In addition, if offline has not been supplied, the
// signature is verified over the transaction sign bytes.
func printAndValidateSigs(
	cmd *cobra.Command, clientCtx client.Context, chainID string, tx sdk.Tx, offline bool,
) bool {
	sigTx := tx.(authsigning.SigVerifiableTx)
	signModeHandler := clientCtx.TxConfig.SignModeHandler()

	cmd.Println("Signers:")
	signers := sigTx.GetSigners()
	for i, signer := range signers {
		cmd.Printf("  %v: %v\n", i, signer.String())
	}

	success := true
	sigs, err := sigTx.GetSignaturesV2()
	if err != nil {
		panic(err)
	}
	cmd.Println("")
	cmd.Println("Signatures:")

	if len(sigs) != len(signers) {
		success = false
	}

	for i, sig := range sigs {
		var (
			pubKey         = sig.PubKey
			multiSigHeader string
			multiSigMsg    string
			sigAddr        = sdk.AccAddress(pubKey.Address())
			sigSanity      = "OK"
		)

		if i >= len(signers) || !sigAddr.Equals(signers[i]) {
			sigSanity = "ERROR: signature does not match its respective signer"
			success = false
		}

		// validate the actual signature over the transaction bytes since we can
		// reach out to a full node to query accounts.
		if !offline && success {
			accNum, accSeq, err := clientCtx.AccountRetriever.GetAccountNumberSequence(clientCtx, sigAddr)
			if err != nil {
				cmd.Printf("failed to get account: %s\n", sigAddr)
				return false
			}

			signingData := authsigning.SignerData{
				ChainID:       chainID,
				AccountNumber: accNum,
				Sequence:      accSeq,
			}
			err = authsigning.VerifySignature(pubKey, signingData, sig.Data, signModeHandler, sigTx)
			if err != nil {
				return false
			}
		}

		cmd.Printf("  %d: %s\t\t\t[%s]%s%s\n", i, sigAddr.String(), sigSanity, multiSigHeader, multiSigMsg)
	}

	cmd.Println("")

	return success
}

func readTxAndInitContexts(clientCtx client.Context, cmd *cobra.Command, filename string) (client.Context, tx.Factory, sdk.Tx, error) {
	stdTx, err := authclient.ReadTxFromFile(clientCtx, filename)
	if err != nil {
		return clientCtx, tx.Factory{}, nil, err
	}

	txFactory := tx.NewFactoryCLI(clientCtx, cmd.Flags())

	return clientCtx, txFactory, stdTx, nil
}
