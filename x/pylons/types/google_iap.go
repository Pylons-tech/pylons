package types

import (
	"github.com/Pylons-tech/pylons/x/pylons/config"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// TypeGoogleIAPOrder is a store key for cookbook
const TypeGoogleIAPOrder = "google_iap_order"

// GoogleIAPOrder is a struct that contains all the metadata of a google iap order
type GoogleIAPOrder struct {
	NodeVersion       string
	ProductID         string
	PurchaseToken     string
	ReceiptDataBase64 string
	Signature         string
	Sender            sdk.AccAddress
}

// NewGoogleIAPOrder return a new Google IAP Order
func NewGoogleIAPOrder(productID, PurchaseToken, ReceiptDataBase64, Signature string, Sender sdk.AccAddress) GoogleIAPOrder {
	cb := GoogleIAPOrder{
		NodeVersion:       "0.0.1",
		ProductID:         productID,
		PurchaseToken:     PurchaseToken,
		ReceiptDataBase64: ReceiptDataBase64,
		Signature:         Signature,
		Sender:            Sender,
	}

	return cb
}

// GetAmount returns pylons amount by product and package
func (iap GoogleIAPOrder) GetAmount() sdk.Coins {

	for _, giapProduct := range config.Config.GoogleIAP {
		if giapProduct.ProductID == iap.ProductID {
			return NewPylon(giapProduct.Amount)
		}
	}
	return NewPylon(0)
}
