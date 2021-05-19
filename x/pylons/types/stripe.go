package types

import (
	"github.com/Pylons-tech/pylons/x/pylons/config"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// TypeStripeOrder is a store key for cookbook
const TypeStripeOrder = "stripe_order"

// StripeOrder is a struct that contains all the metadata of a google iap order
type StripeOrder struct {
	NodeVersion       string
	ProductID         string
	PurchaseToken     string
	ReceiptDataBase64 string
	Signature         string
	Sender            sdk.AccAddress
}

// NewStripeOrder return a new Stripe Order
func NewStripeOrder(ProductID, PurchaseToken, ReceiptDataBase64, Signature string, Sender sdk.AccAddress) StripeOrder {
	cb := StripeOrder{
		NodeVersion:       "0.0.1",
		ProductID:         ProductID,
		PurchaseToken:     PurchaseToken,
		ReceiptDataBase64: ReceiptDataBase64,
		Signature:         Signature,
		Sender:            Sender,
	}

	return cb
}

// GetAmount returns pylons amount by product and package
func (iap StripeOrder) GetAmount() sdk.Coins {

	for _, giapProduct := range config.Config.GoogleIAP {	//added by @tian20210519 be able to change googleIAP....
		if giapProduct.ProductID == iap.ProductID {
			return NewPylon(giapProduct.Amount)
		}
	}
	return NewPylon(0)
}
