package main

import (
	"fmt"

	"encoding/hex"

	clkeys "github.com/cosmos/cosmos-sdk/client/keys"
	"github.com/cosmos/cosmos-sdk/crypto/keys"
	sdk "github.com/cosmos/cosmos-sdk/types"
	crypto "github.com/tendermint/tendermint/crypto/secp256k1"
)

func ShittySignature () {
	// generate private key from cleartext
	hexPrivKey := "c85ef7d79691fe79573b1a7064c19c1a9819ebdbd1faaab1a8ec92344438aaf4"
	privKeyBytes, err := hex.DecodeString(hexPrivKey)
	if err != nil {
		fmt.Printf("error: \n %+v \n", err)
	}
	var privKeyBytes32 [32]byte
	copy(privKeyBytes32[:], privKeyBytes)
	privKey := crypto.PrivKeySecp256k1(privKeyBytes32)
	testDataString := "5468697320697320616E206578616D706C65206F662061207369676E6564206D6573736167652E"
	signable, err := hex.DecodeString(testDataString)
	if err != nil {
		fmt.Printf("error: \n %+v \n", err)
	}
	signature, err := privKey.Sign(signable)
	if err != nil {
		fmt.Printf("error: \n %+v \n", err)
	}
	fmt.Printf("test signature for cleartext key and test data: \n %+v \n", hex.EncodeToString(signature))
}

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
	ShittySignature()
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
