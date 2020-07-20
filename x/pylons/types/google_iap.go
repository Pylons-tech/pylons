package types

import (
	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// TypeGoogleIAPOrder is a store key for cookbook
const TypeGoogleIAPOrder = "google_iap_order"

// GoogleIAPOrder is a struct that contains all the metadata of a google iap order
type GoogleIAPOrder struct {
	ID            string // the iap order guid
	PackageName   string
	ProductID     string
	PurchaseTime  int64
	PurchaseState int64
	PurchaseToken string
	Signature     string
	Sender        sdk.AccAddress
}

// NewGoogleIAPOrder return a new Google IAP Order
func NewGoogleIAPOrder(ID, PackageName, ProductID string, PurchaseTime, PurchaseState int64, PurchaseToken, Signature string, Sender sdk.AccAddress) GoogleIAPOrder {
	cb := GoogleIAPOrder{
		ID:            ID,
		PackageName:   PackageName,
		ProductID:     ProductID,
		PurchaseTime:  PurchaseTime,
		PurchaseState: PurchaseState,
		PurchaseToken: PurchaseToken,
		Signature:     Signature,
		Sender:        Sender,
	}

	return cb
}

// GetAmount returns pylons amount by product and package
func (iap GoogleIAPOrder) GetAmount() sdk.Coins {

	for _, giapProduct := range config.Config.GoogleIAP {
		if giapProduct.PackageName == iap.PackageName && giapProduct.ProductID == iap.ProductID {
			return types.NewPylon(giapProduct.Amount)
		}
	}
	return types.NewPylon(50000)
}
