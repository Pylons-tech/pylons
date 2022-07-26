package v046

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	v1 "github.com/Pylons-tech/pylons/x/pylons/types/v1"
)

// ConvertToLegacyProposal takes a new proposal and attempts to convert it to the
// legacy proposal format. This conversion is best effort. New proposal types that
// don't have a legacy message will return a "nil" content

func convertToNewAppleInAppPurchaseOrder(oldProp v1.OldAppleInAppPurchaseOrder) (types.AppleInAppPurchaseOrder, error) {

	return types.AppleInAppPurchaseOrder{
		Quantity:     oldProp.Quantity,
		ProductId:    oldProp.ProductID,
		PurchaseId:   oldProp.PurchaseID,
		PurchaseDate: oldProp.PurchaseDate,
		Creator:      oldProp.Creator,
	}, nil
}
