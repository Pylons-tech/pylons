package main

import (
	"fmt"

	// "encoding/base64"
	"encoding/hex"
	"encoding/json"

	clkeys "github.com/cosmos/cosmos-sdk/client/keys"
	"github.com/cosmos/cosmos-sdk/crypto/keys"

	// "github.com/cosmos/cosmos-sdk/crypto/keys/mintkey"
	sdk "github.com/cosmos/cosmos-sdk/types"
	crypto "github.com/tendermint/tendermint/crypto/secp256k1"
)

func ShittySignature(cleartextKey string, hexData string) {
	// generate private key from cleartext
	hexPrivKey := cleartextKey
	privKeyBytes, err := hex.DecodeString(hexPrivKey)
	if err != nil {
		fmt.Printf("error: \n %+v \n", err)
	}
	var privKeyBytes32 [32]byte
	copy(privKeyBytes32[:], privKeyBytes)
	privKey := crypto.PrivKeySecp256k1(privKeyBytes32)
	testDataString := hexData
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
	// Apache signature
	ShittySignature(
		"c85ef7d79691fe79573b1a7064c19c1a9819ebdbd1faaab1a8ec92344438aaf4",
		"5468697320697320616E206578616D706C65206F662061207369676E6564206D6573736167652E")
	// Interop bullshit
	ShittySignature(
		"a96e62ed3955e65be32703f12d87b6b5cf26039ecfa948dc5107a495418e5330",
		"7b22416d6f756e74223a5b7b22616d6f756e74223a22353030222c2264656e6f6d223a2270796c6f6e227d5d2c22526571756573746572223a22636f736d6f733133647a6d39306679763335706671707434326735657672637634736c3673397968736e397668227d")
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
	pubKey.Address()
	fmt.Println("GIRISH", pubKey.Address())
	// bech32PubKey := sdk.MustBech32ifyAccPub(pubKey)
	// fmt.Println("bech32PubKey:", bech32PubKey)

	keybase, err := clkeys.NewKeyBaseFromDir("/home/girish/.plncli")
	if err != nil {
		return
	}
	infott, err := keybase.Get("girish")
	fmt.Println(infott.GetPubKey().Address())
	ttt, _ := json.Marshal(infott)
	tmp := make(map[string]interface{})
	json.Unmarshal(ttt, &tmp)
	// fmt.Println("HEHEHEHEH", tmp["privkey.armor"])
	// lif := info.
	// privKey, err := mintkey.UnarmorDecryptPrivKey(tmp["privkey.armor"].(string), "jack1234")
	// fmt.Println("PrivKey", privKey, sdk.AccAddress(privKey.PubKey().Bytes()).String())
	// tx, _ := privKey.Sign([]byte("{}"))
	// fmt.Println(hex.EncodeToString(tx))
	// fmt.Println(base64.RawStdEncoding.EncodeToString(tx))
}

// localInfo is the public information about a locally stored key
type localInfo struct {
	Name         string `json:"name"`
	PrivKeyArmor string `json:"privkey.armor"`
}
