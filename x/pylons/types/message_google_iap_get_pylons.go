package types

import (
	"crypto"
	"crypto/rsa"

	// Google forces us to use unsafe sha1 for IAP verification
	"crypto/sha1" // nolint: gosec
	"crypto/x509"
	"encoding/base64"
	"encoding/json"
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/config"
)

var _ sdk.Msg = &MsgGoogleIAPGetPylons{}

func NewMsgGoogleIAPGetPylons(creator string, productID string, purchaseToken string, receiptDataBase64 string, signature string) *MsgGoogleIAPGetPylons {
	return &MsgGoogleIAPGetPylons{
		Creator:           creator,
		ProductID:         productID,
		PurchaseToken:     purchaseToken,
		ReceiptDataBase64: receiptDataBase64,
		Signature:         signature,
	}
}

func (msg *MsgGoogleIAPGetPylons) Route() string {
	return RouterKey
}

func (msg *MsgGoogleIAPGetPylons) Type() string {
	return "GoogleIAPGetPylons"
}

func (msg *MsgGoogleIAPGetPylons) GetSigners() []sdk.AccAddress {
	creator, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{creator}
}

func (msg *MsgGoogleIAPGetPylons) GetSignBytes() []byte {
	bz := ModuleCdc.MustMarshalJSON(msg)
	return sdk.MustSortJSON(bz)
}

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

	// Google forces us to use unsafe sha1 for IAP verification
	h := sha1.New() // nolint: gosec
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

func (msg *MsgGoogleIAPGetPylons) ValidateBasic() error {
	_, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidAddress, "invalid address (%s)", err)
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
