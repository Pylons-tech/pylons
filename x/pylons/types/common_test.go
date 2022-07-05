package types

import (
	"bytes"
	"crypto"
	"crypto/rand"
	"crypto/rsa" // #nosec
	"crypto/sha1"
	"crypto/x509"
	"encoding/base64"

	"github.com/cosmos/cosmos-sdk/crypto/keys/ed25519"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

const (
	SampleGoogleInAppPurchasePubKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuMzgsJOZzyZvmOG8T9baGxDR/DWx6dgku7UdDfc6aGKthPGYouOa4KvLGEuNd+YTilwtEEryi3mmYAtl8MNtiAQCiry7HjdRNle8lLUHSKwBLVCswY3WGEAuW+5mo/V6X0klS8se65fIqCv2x/SKjtTZvKO/Oe3uehREMY1b8uWLrD5roubXzmaLsFGIRi5wdg8UWRe639LCNb2ghD2Uw0svBTJqn/ymsPmCfVjmCNNRDxfxzlA8O4EEKCK1qOdwIejMAfFMrN87u+0HTQbCKQ/xUQrR6fUhWT2mqttBGhi1NmTNBlUDyXYU+7ILbfJUVqQcKNDbFQd+xv9wBnXAhwIDAQAB"
)

func GenerateRSAKey() *rsa.PrivateKey {
	privateKey, _ := rsa.GenerateKey(rand.Reader, 1024)

	return privateKey
}

func GenerateRSAPublicKey(privatekey *rsa.PrivateKey) string {
	pubBytes, _ := x509.MarshalPKIXPublicKey(&privatekey.PublicKey)
	publicKey := toBase64(pubBytes)
	return publicKey
}

func toBase64(bytes []byte) string {
	return base64.StdEncoding.EncodeToString(bytes)
}

func GenerateBase64Digest(message string) []byte {
	messageBytes := bytes.NewBufferString(message)
	hash := sha1.New()
	hash.Write(messageBytes.Bytes())
	digest := hash.Sum(nil)
	return digest
}

func SignPKCS1v15(privatekey *rsa.PrivateKey, digest []byte) ([]byte, error) {
	signature, err := rsa.SignPKCS1v15(rand.Reader, privatekey, crypto.SHA1, digest)
	if err != nil {
		return nil, err
	}
	return signature, nil
}

func AccAddress() string {
	pk := ed25519.GenPrivKey().PubKey()
	addr := pk.Address()
	return sdk.AccAddress(addr).String()
}
