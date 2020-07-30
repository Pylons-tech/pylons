package tx

import (
	"bufio"
	"bytes"
	"encoding/hex"
	"fmt"
	"os"
	"strings"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"github.com/tendermint/tendermint/crypto/multisig"
	"github.com/tendermint/tendermint/crypto/secp256k1"

	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/codec"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/x/auth/client/utils"
	"github.com/cosmos/cosmos-sdk/x/auth/types"
	tmcrypto "github.com/tendermint/tendermint/crypto"
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
func PrivateKeySign(codec *codec.Codec) *cobra.Command {
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
		RunE:   makeSignCmd(codec),
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
	cmd.Flags().Bool(
		flagOffline, false,
		"Offline mode; Do not query a full node. --account and --sequence options would be required if offline is set",
	)
	cmd.Flags().String(flagOutfile, "", "The document will be written to the given file instead of STDOUT")

	cmd.Flags().String(
		flagPrivateKey, "",
		"Private key flag for transaction sign",
	)

	// TODO this can be possible out of array range
	cmd = flags.PostCommands(cmd)[0]

	return cmd
}

func preSignCmd(cmd *cobra.Command, _ []string) {
	// Conditionally mark the account and sequence numbers required as no RPC
	// query will be done.
	if viper.GetBool(flagOffline) {
		err := cmd.MarkFlagRequired(flags.FlagAccountNumber)
		if err != nil {
			fmt.Printf("%s as required flag set failure", flags.FlagAccountNumber)
			os.Exit(1)
		}
		err = cmd.MarkFlagRequired(flags.FlagSequence)
		if err != nil {
			fmt.Printf("%s as required flag set failure", flags.FlagSequence)
			os.Exit(1)
		}
	}
}

func populateAccountFromState(
	txBldr types.TxBuilder, cliCtx context.CLIContext, addr sdk.AccAddress,
) (types.TxBuilder, error) {

	num, seq, err := types.NewAccountRetriever(cliCtx).GetAccountNumberSequence(addr)
	if err != nil {
		return txBldr, err
	}

	return txBldr.WithAccountNumber(num).WithSequence(seq), nil
}

func isTxSigner(user sdk.AccAddress, signers []sdk.AccAddress) bool {
	for _, s := range signers {
		if bytes.Equal(user.Bytes(), s.Bytes()) {
			return true
		}
	}

	return false
}

// SignStdTx appends a signature to a StdTx and returns a copy of it. If appendSig
// is false, it replaces the signatures already attached with the new signature.
// Don't perform online validation or lookups if offline is true.
func SignStdTx(
	txBldr types.TxBuilder, cliCtx context.CLIContext,
	stdTx types.StdTx, appendSig bool, offline bool,
) (types.StdTx, error) {

	privHex := viper.GetString(flagPrivateKey)
	privBytes, err := hex.DecodeString(privHex)
	if err != nil {
		return types.StdTx{}, fmt.Errorf("error decoding private key hex value")
	}

	var privBytes32 [32]byte
	copy(privBytes32[0:32], privBytes)

	priv := secp256k1.PrivKeySecp256k1(privBytes32)

	var signedStdTx types.StdTx

	addr := priv.PubKey().Address()

	// check whether the address is a signer
	if !isTxSigner(sdk.AccAddress(addr), stdTx.GetSigners()) {
		return signedStdTx, fmt.Errorf("%s: %s", errInvalidSigner, sdk.AccAddress(addr.Bytes()).String())
	}

	if !offline {
		txBldr, err = populateAccountFromState(txBldr, cliCtx, sdk.AccAddress(addr))
		if err != nil {
			return signedStdTx, err
		}
	}

	if txBldr.ChainID() == "" {
		return types.StdTx{}, fmt.Errorf("chain ID required but not specified")
	}

	stdSignature, err := MakeSignature(priv, types.StdSignMsg{
		ChainID:       txBldr.ChainID(),
		AccountNumber: txBldr.AccountNumber(),
		Sequence:      txBldr.Sequence(),
		Fee:           stdTx.Fee,
		Msgs:          stdTx.GetMsgs(),
		Memo:          stdTx.GetMemo(),
	})
	if err != nil {
		return types.StdTx{}, fmt.Errorf("error making signature")
	}

	sigs := stdTx.Signatures
	if len(sigs) == 0 || !appendSig {
		sigs = []types.StdSignature{stdSignature}
	} else {
		sigs = append(sigs, stdSignature)
	}
	return types.NewStdTx(stdTx.GetMsgs(), stdTx.Fee, sigs, stdTx.GetMemo()), nil
}

// Sign signs the msg with the named key. It returns an error if the key doesn't
// exist or the decryption fails.
func Sign(priv tmcrypto.PrivKey, msg []byte) (sig []byte, pub tmcrypto.PubKey, err error) {
	sig, err = priv.Sign(msg)
	if err != nil {
		return nil, nil, err
	}

	return sig, priv.PubKey(), nil
}

// MakeSignature builds a StdSignature given keybase, key name, passphrase, and a StdSignMsg.
func MakeSignature(priv tmcrypto.PrivKey, msg types.StdSignMsg) (sig types.StdSignature, err error) {

	sigBytes, pubkey, err := Sign(priv, msg.Bytes())
	if err != nil {
		return
	}
	return types.StdSignature{
		PubKey:    pubkey,
		Signature: sigBytes,
	}, nil
}

func makeSignCmd(cdc *codec.Codec) func(cmd *cobra.Command, args []string) error {
	return func(cmd *cobra.Command, args []string) error {
		stdTx, err := utils.ReadStdTxFromFile(cdc, args[0])
		if err != nil {
			return err
		}

		inBuf := bufio.NewReader(cmd.InOrStdin())
		offline := viper.GetBool(flagOffline)
		cliCtx := context.NewCLIContextWithInput(inBuf).WithCodec(cdc)
		txBldr := types.NewTxBuilderFromCLI(inBuf)

		if viper.GetBool(flagValidateSigs) {
			if !printAndValidateSigs(cliCtx, txBldr.ChainID(), stdTx, offline) {
				return fmt.Errorf("signatures validation failed")
			}

			return nil
		}

		// if --signature-only is on, then override --append
		var newTx types.StdTx
		generateSignatureOnly := viper.GetBool(flagSigOnly)

		newTx, err = SignStdTx(txBldr, cliCtx, stdTx, true, offline)

		if err != nil {
			return err
		}

		json, err := getSignatureJSON(cdc, newTx, cliCtx.Indent, generateSignatureOnly)
		if err != nil {
			return err
		}

		if viper.GetString(flagOutfile) == "" {
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

func getSignatureJSON(cdc *codec.Codec, newTx types.StdTx, indent, generateSignatureOnly bool) ([]byte, error) {
	switch generateSignatureOnly {
	case true:
		switch indent {
		case true:
			return cdc.MarshalJSONIndent(newTx.Signatures[0], "", "  ")

		default:
			return cdc.MarshalJSON(newTx.Signatures[0])
		}
	default:
		switch indent {
		case true:
			return cdc.MarshalJSONIndent(newTx, "", "  ")

		default:
			return cdc.MarshalJSON(newTx)
		}
	}
}

// printAndValidateSigs will validate the signatures of a given transaction over
// its expected signers. In addition, if offline has not been supplied, the
// signature is verified over the transaction sign bytes.
func printAndValidateSigs(
	cliCtx context.CLIContext, chainID string, stdTx types.StdTx, offline bool,
) bool {

	fmt.Println("Signers:")

	signers := stdTx.GetSigners()
	for i, signer := range signers {
		fmt.Printf("  %v: %v\n", i, signer.String())
	}

	success := true
	sigs := stdTx.Signatures

	fmt.Println("")
	fmt.Println("Signatures:")

	if len(sigs) != len(signers) {
		success = false
	}

	for i, sig := range sigs {
		sigAddr := sdk.AccAddress(sig.Address())
		sigSanity := "OK"

		var (
			multiSigHeader string
			multiSigMsg    string
		)

		if i >= len(signers) || !sigAddr.Equals(signers[i]) {
			sigSanity = "ERROR: signature does not match its respective signer"
			success = false
		}

		// Validate the actual signature over the transaction bytes since we can
		// reach out to a full node to query accounts.
		if !offline && success {
			acc, err := types.NewAccountRetriever(cliCtx).GetAccount(sigAddr)
			if err != nil {
				fmt.Printf("failed to get account: %s\n", sigAddr)
				return false
			}

			sigBytes := types.StdSignBytes(
				chainID, acc.GetAccountNumber(), acc.GetSequence(),
				stdTx.Fee, stdTx.GetMsgs(), stdTx.GetMemo(),
			)

			if ok := sig.VerifyBytes(sigBytes, sig.Signature); !ok {
				sigSanity = "ERROR: signature invalid"
				success = false
			}
		}

		multiPK, ok := sig.PubKey.(multisig.PubKeyMultisigThreshold)
		if ok {
			var multiSig multisig.Multisignature
			cliCtx.Codec.MustUnmarshalBinaryBare(sig.Signature, &multiSig)

			var b strings.Builder
			b.WriteString("\n  MultiSig Signatures:\n")

			for i := 0; i < multiSig.BitArray.Size(); i++ {
				if multiSig.BitArray.GetIndex(i) {
					addr := sdk.AccAddress(multiPK.PubKeys[i].Address().Bytes())
					b.WriteString(fmt.Sprintf("    %d: %s (weight: %d)\n", i, addr, 1))
				}
			}

			multiSigHeader = fmt.Sprintf(" [multisig threshold: %d/%d]", multiPK.K, len(multiPK.PubKeys))
			multiSigMsg = b.String()
		}

		fmt.Printf("  %d: %s\t\t\t[%s]%s%s\n", i, sigAddr.String(), sigSanity, multiSigHeader, multiSigMsg)
	}

	fmt.Println("")
	return success
}
