package main

import (
	"fmt"

	"encoding/hex"

	clkeys "github.com/cosmos/cosmos-sdk/client/keys"
	"github.com/cosmos/cosmos-sdk/crypto/keys"
	sdk "github.com/cosmos/cosmos-sdk/types"
	crypto "github.com/tendermint/tendermint/crypto/secp256k1"
)

// GenerateCoinKey returns the address of a public key, along with the secret
// phrase to recover the private key.
func GenerateCoinKey() (keys.Info, string, error) {

	// generate a private key, with recovery phrase
	info, secret, err := clkeys.NewInMemoryKeyBase().CreateMnemonic(
		"name", keys.English, "pass", keys.Secp256k1)
	if err != nil {
		return info, "", err
	}

	return info, secret, nil
}

func main() {
	info, secret, _ := GenerateCoinKey()
	fmt.Printf("Secret: %+v\n", secret)
	fmt.Printf("Info: %+v\n", info.GetPubKey())
	t, err := hex.DecodeString("0283e197461d60d77d3b40e854646583ffebdcb12fa7f0327c4cd1c68b316e80f5")
	fmt.Println(err)
	fmt.Printf("%+v\n", t)
	fmt.Printf("%+v\n", sdk.AccAddress(info.GetPubKey().Address().Bytes()).String())
	kf, _ := keys.Bech32KeyOutput(info)
	fmt.Printf("%+v\n\n", kf)

	hexPubKey := "03950E1CDFCB133D6024109FD489F734EEB4502418E538C28481F22BCE276F248C"

	pubKeyBytes, err := hex.DecodeString(hexPubKey)
	if err != nil {
		fmt.Printf("error: \n %+v \n", err)

	}

	var pubKeyBytes33 [33]byte
	copy(pubKeyBytes33[:], pubKeyBytes)
	pubKey := crypto.PubKeySecp256k1(pubKeyBytes33)

	bech32PubKey := sdk.MustBech32ifyAccPub(pubKey)
	fmt.Println("bech32PubKey:", bech32PubKey)
}
