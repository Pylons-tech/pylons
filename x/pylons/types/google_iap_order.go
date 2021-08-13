package types

import (
	"github.com/Pylons-tech/pylons/x/pylons/config"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// GetAmount returns pylons amount by product and package
func (iap GoogleIAPOrder) GetAmount() sdk.Coins {

	for _, giapProduct := range config.Config.GoogleIAP {
		if giapProduct.ProductID == iap.ProductID {
			return sdk.Coins{sdk.NewInt64Coin(config.PylonsCoinDenom, giapProduct.Amount)}
		}
	}
	return sdk.Coins{sdk.NewInt64Coin(config.PylonsCoinDenom, 0)}
}
