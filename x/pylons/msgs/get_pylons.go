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

// MsgGetPylons defines a GetPylons message
type MsgGetPylons struct {
	ProductID     string
	PurchaseToken string
	ReceiptData   string
	Signature     string
	Requester     sdk.AccAddress
}

// NewMsgGetPylons is a function to get MsgGetPylons msg from required params
func NewMsgGetPylons(ProductID, PurchaseToken, ReceiptData, Signature string, requester sdk.AccAddress) MsgGetPylons {
	return MsgGetPylons{
		ProductID:     ProductID,
		PurchaseToken: PurchaseToken,
		ReceiptData:   ReceiptData,
		Signature:     Signature,
		Requester:     requester,
	}
}

// Route should return the name of the module
func (msg MsgGetPylons) Route() string { return RouterKey }

// Type should return the action
func (msg MsgGetPylons) Type() string { return "get_pylons" }

// ValidateSignatureLocally is function for testing signature on local
func (msg MsgGetPylons) ValidateSignatureLocally() error {
	playStorePubKeyBytes, err := base64.StdEncoding.DecodeString(config.Config.GoogleIAPPubKey)
	if err != nil {
		return fmt.Errorf("play store base64 public key decoding failure: %s", err.Error())
	}
	re, err := x509.ParsePKIXPublicKey(playStorePubKeyBytes)
	if err != nil {
		return err
	}
	pub := re.(*rsa.PublicKey)
	text := []byte(msg.ReceiptData)

	h := sha1.New()
	_, err = h.Write(text)
	if err != nil {
		return err
	}
	digest := h.Sum(nil)

	ds, _ := base64.StdEncoding.DecodeString(msg.Signature)
	err = rsa.VerifyPKCS1v15(pub, crypto.SHA1, digest, ds)
	return err
}

// ValidateBasic is a function to validate MsgGetPylons msg
func (msg MsgGetPylons) ValidateBasic() error {

	if msg.Requester.Empty() {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Requester.String())
	}

	// References
	// offline verification JS module https://github.com/voltrue2/in-app-purchase/blob/e966ee1348bd4f67581779abeec59c4bbc2b2ebc/lib/google.js#L788
	// Cordova Plugin code that check offline https://github.com/j3k0/cordova-plugin-purchase/blob/8861bd2392a48d643ffc754b8f59afc1e6afab60/src/android/cc/fovea/Security.java#L94
	// https://stackoverflow.com/questions/31349710/google-play-billing-response-signature-verification

	// We should research are ask google for offline verification from public key
	// should contact google team to check if this is correct use

	// TODO: should validate the purchaseToken and productId match with the receiptData
	return msg.ValidateSignatureLocally()
}

// GetSignBytes encodes the message for signing
func (msg MsgGetPylons) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners encodes the message for signing
func (msg MsgGetPylons) GetSigners() []sdk.AccAddress {
	return []sdk.AccAddress{msg.Requester}
}
