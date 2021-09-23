package types

import (
	"encoding/base64"
	"fmt"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/tendermint/tendermint/crypto/secp256k1"
)

// ValidatePaymentInfo validates the payment receipt using the provided signature
func (pp PaymentProcessor) ValidatePaymentInfo(pi PaymentInfo) error {
	msg := fmt.Sprintf("{\"purchaseID\":\"%s\",\"payerAddr\":\"%s\",\"amount\":\"%s\",\"productID\":\"%s\"}", pi.PurchaseID, pi.Amount, pi.PayerAddr, pi.ProductID)
	return pp.verifySignature(msg, pi.Signature)
}

// ValidateRedeemInfo validates the payment receipt using the provided signature
func (pp PaymentProcessor) ValidateRedeemInfo(ri RedeemInfo) error {
	msg := fmt.Sprintf("{\"payoutID\":\"%s\",\"address\":\"%s\",\"amount\":\"%s\"}", ri.ID, ri.Address, ri.Amount)
	return pp.verifySignature(msg, ri.Signature)
}

func (pp PaymentProcessor) verifySignature(msg, signature string) error {
	pubKeyBytes, err := base64.StdEncoding.DecodeString(pp.PubKey)
	if err != nil {
		return fmt.Errorf("payment processor public key decoding failure: %s", err.Error())
	}
	msgBytes, err := base64.StdEncoding.DecodeString(msg)
	if err != nil {
		return fmt.Errorf("message decoding failure: %s", err.Error())
	}
	signatureBytes, err := base64.StdEncoding.DecodeString(signature)
	if err != nil {
		return fmt.Errorf("signature decoding failure: %s", err.Error())
	}

	pubKey := secp256k1.PubKey(pubKeyBytes)
	if !pubKey.VerifySignature(msgBytes, signatureBytes) {
		return sdkerrors.Wrapf(sdkerrors.ErrorInvalidSigner, "signature for %s is invalid", pp.Name)
	}

	return nil
}
