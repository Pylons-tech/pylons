package v1beta1

import (
	"crypto"
	"crypto/rsa"
	"crypto/sha1" // #nosec
	"crypto/x509"
	"encoding/base64"
	"fmt"
)

// ValidateGoogleIAPSignature is function for testing signature on local
func ValidateGoogleIAPSignature(msg *MsgGoogleInAppPurchaseGetCoins, coinIssuer CoinIssuer) error {
	// References
	// offline verification JS module https://github.com/voltrue2/in-app-purchase/blob/e966ee1348bd4f67581779abeec59c4bbc2b2ebc/lib/google.js#L788
	// Cordova Plugin code that check offline https://github.com/j3k0/cordova-plugin-purchase/blob/8861bd2392a48d643ffc754b8f59afc1e6afab60/src/android/cc/fovea/Security.java#L94
	// https://stackoverflow.com/questions/31349710/google-play-billing-response-signature-verification

	playStorePubKeyBytes, err := base64.StdEncoding.DecodeString(coinIssuer.GoogleInAppPurchasePubKey)
	if err != nil {
		return fmt.Errorf("play store base64 public key decoding failure: %s", err.Error())
	}
	re, err := x509.ParsePKIXPublicKey(playStorePubKeyBytes)
	if err != nil {
		return err
	}
	pub := re.(*rsa.PublicKey)
	receiptData, err := base64.StdEncoding.DecodeString(msg.ReceiptDataBase64)
	if err != nil {
		return err
	}

	// Google forces us to use unsafe sha1 for IAP verification
	h := sha1.New() // nolint:gosec
	_, err = h.Write(receiptData)
	if err != nil {
		return err
	}
	digest := h.Sum(nil)

	ds, err := base64.StdEncoding.DecodeString(msg.Signature)
	if err != nil {
		return fmt.Errorf("msg signature base64 decoding failure: %s", err.Error())
	}
	err = rsa.VerifyPKCS1v15(pub, crypto.SHA1, digest, ds)
	return err
}
