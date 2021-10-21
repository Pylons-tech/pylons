package types

import (
	"encoding/base64"
	"fmt"

	"github.com/cosmos/cosmos-sdk/crypto/keys/ed25519"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// ValidatePaymentInfo validates the payment receipt using the provided signature
func (pp PaymentProcessor) ValidatePaymentInfo(pi PaymentInfo) error {
	msg := fmt.Sprintf("{\"purchaseID\":\"%s\",\"address\":\"%s\",\"amount\":\"%s\",\"productID\":\"%s\"}", pi.PurchaseID, pi.PayerAddr, pi.Amount.String(), pi.ProductID)
	return pp.verifySignature(msg, pi.Signature)
}

// ValidateRedeemInfo validates the payment receipt using the provided signature
func (pp PaymentProcessor) ValidateRedeemInfo(ri RedeemInfo) error {
	msg := fmt.Sprintf("{\"payoutID\":\"%s\",\"address\":\"%s\",\"amount\":\"%s\"}", ri.ID, ri.Address, ri.Amount.String())
	return pp.verifySignature(msg, ri.Signature)
}

func (pp PaymentProcessor) verifySignature(msg, signature string) error {
	pubKeyBytes, err := base64.StdEncoding.DecodeString(pp.PubKey)
	if err != nil {
		return fmt.Errorf("pubKey decoding failure: %s", err.Error())
	}
	pubKey := ed25519.PubKey{Key: pubKeyBytes}
	msgBytes := []byte(msg)
	signatureBytes, err := base64.StdEncoding.DecodeString(signature)
	if err != nil {
		return fmt.Errorf("signature decoding failure: %s", err.Error())
	}

	if !pubKey.VerifySignature(msgBytes, signatureBytes) {
		return sdkerrors.Wrapf(sdkerrors.ErrorInvalidSigner, "signature for %s is invalid", pp.Name)
	}

	return nil
}
