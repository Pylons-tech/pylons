package tx

import (
	"encoding/hex"
	"fmt"
	"os"

	"github.com/spf13/cobra"
	"github.com/tendermint/tendermint/crypto/secp256k1"

	"github.com/cosmos/cosmos-sdk/crypto/hd"
	"github.com/cosmos/go-bip39"
)

// ComputePrivateKey returns the transaction sign result from private key.
func ComputePrivateKey() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "compute-private [mnemonic]",
		Short: "Compute private key from mnemonic",
		Long: `Export private key from mnemonic.
				Mnemonic is not being used on mobile side and it'a a pain to have difference.
				This is a helper for mobile side.
		`,
		PreRun: preSignCmd,
		RunE:   makeComputePrivateKeyCmd(),
		Args:   cobra.ExactArgs(1),
	}

	return cmd
}

func makeComputePrivateKeyCmd() func(cmd *cobra.Command, args []string) error {
	return func(cmd *cobra.Command, args []string) error {
		mnemonic := args[0]
		// Generate a Bip32 HD wallet for the mnemonic and a user supplied password
		seed, err := bip39.NewSeedWithErrorChecking(mnemonic, "")
		if err != nil {
			os.Exit(1)
		}

		// This priv get code came from dbKeybase.CreateMnemonic function of cosmos-sdk
		masterPriv, ch := hd.ComputeMastersFromSeed(seed)
		// hdPath := hd.NewFundraiserParams(0, 0).String()
		derivedPriv, err := hd.DerivePrivateKeyForPath(masterPriv, ch, "44'/118'/0'/0/0")
		if err != nil {
			os.Exit(1)
		}
		priv := secp256k1.GenPrivKeySecp256k1(derivedPriv)

		privKeyHex := hex.EncodeToString(priv[:])
		// cosmosAddr := sdk.AccAddress(priv.PubKey().Address().Bytes()).String()
		fmt.Println(privKeyHex)
		return nil
	}
}
