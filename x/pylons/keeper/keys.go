package keeper

// store keys
const (
	KeyPylonsEntity     = "pylons_entity"
	KeyGoogleIAPOrder   = "pylons_google_iap_order"
	KeyPaymentForStripe = "pylons_payment_for_stripe"
	KeyPylonsCookbook   = "pylons_cookbook"
	KeyPylonsRecipe     = "pylons_recipe"
	KeyPylonsItem       = "pylons_item"
	KeyPylonsExecution  = "pylons_execution"
	KeyPylonsTrade      = "pylons_trade"
	KeyPylonsHistory    = "pylons_history"
	KeyPylonsLockedCoin = "pylons_locked_coin"
)

func GetStoreKysList() (string, string, string, string, string, string, string, string, string) {
	return KeyPylonsEntity,
		KeyGoogleIAPOrder,
		KeyPaymentForStripe,
		KeyPylonsCookbook,
		KeyPylonsRecipe,
		KeyPylonsItem,
		KeyPylonsExecution,
		KeyPylonsTrade,
		KeyPylonsLockedCoin
}

// StoreKeyList has keys in ordered array
var StoreKeyList = []string{
	KeyPylonsEntity,
	KeyGoogleIAPOrder,
	KeyPaymentForStripe,
	KeyPylonsCookbook,
	KeyPylonsRecipe,
	KeyPylonsItem,
	KeyPylonsExecution,
	KeyPylonsTrade,
	KeyPylonsHistory,
	KeyPylonsLockedCoin,
}
