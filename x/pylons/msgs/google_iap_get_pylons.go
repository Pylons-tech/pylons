package msgs

import (
	"crypto"
	"crypto/rsa"
	"crypto/sha1"
	"crypto/x509"
	"encoding/base64"
	"encoding/json"
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// NewMsgGoogleIAPGetPylons is a function to get MsgGetPylons msg from required params
func NewMsgGoogleIAPGetPylons(ProductID, PurchaseToken, ReceiptDataBase64, Signature string, requester sdk.AccAddress) MsgGoogleIAPGetPylons {
	return MsgGoogleIAPGetPylons{
		ProductID:         ProductID,
		PurchaseToken:     PurchaseToken,
		ReceiptDataBase64: ReceiptDataBase64,
		Signature:         Signature,
		Requester:         requester.String(),
	}
}

// Route should return the name of the module
func (msg MsgGoogleIAPGetPylons) Route() string { return RouterKey }

// Type should return the action
func (msg MsgGoogleIAPGetPylons) Type() string { return "google_iap_get_pylons" }

// ValidateGoogleIAPSignature is function for testing signature on local
func (msg MsgGoogleIAPGetPylons) ValidateGoogleIAPSignature() error {
	// References
	// offline verification JS module https://github.com/voltrue2/in-app-purchase/blob/e966ee1348bd4f67581779abeec59c4bbc2b2ebc/lib/google.js#L788
	// Cordova Plugin code that check offline https://github.com/j3k0/cordova-plugin-purchase/blob/8861bd2392a48d643ffc754b8f59afc1e6afab60/src/android/cc/fovea/Security.java#L94
	// https://stackoverflow.com/questions/31349710/google-play-billing-response-signature-verification

	// We should contact google team to check if this is correct use

	playStorePubKeyBytes, err := base64.StdEncoding.DecodeString(config.Config.GoogleIAPPubKey)
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

	h := sha1.New()
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

// ValidateBasic is a function to validate MsgGoogleIAPGetPylons msg
func (msg MsgGoogleIAPGetPylons) ValidateBasic() error {

	if msg.Requester == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Requester)
	}

	var jsonData map[string]interface{}

	receiptData, err := base64.StdEncoding.DecodeString(msg.ReceiptDataBase64)
	if err != nil {
		return err
	}

	err = json.Unmarshal(receiptData, &jsonData)
	if err != nil {
		return err
	}
	if msg.PurchaseToken != jsonData["purchaseToken"] {
		return fmt.Errorf("purchaseToken does not match with receipt data")
	}
	if msg.ProductID != jsonData["productId"] {
		return fmt.Errorf("productId does not match with receipt data")
	}
	return msg.ValidateGoogleIAPSignature()
}

// GetSignBytes encodes the message for signing
func (msg MsgGoogleIAPGetPylons) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners encodes the message for signing
func (msg MsgGoogleIAPGetPylons) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Requester)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}
