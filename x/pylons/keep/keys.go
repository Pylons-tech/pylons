package keep

// store keys
const (
	KeyPylonsEntity     = "pylons_entity"
	KeyGoogleIAPOrder   = "pylons_google_iap_order"
	KeyPylonsCookbook   = "pylons_cookbook"
	KeyPylonsRecipe     = "pylons_recipe"
	KeyPylonsItem       = "pylons_item"
	KeyPylonsExecution  = "pylons_exection"
	KeyPylonsTrade      = "pylons_trade"
	KeyPylonsHistory    = "pylons_history"
	KeyPylonsLockedCoin = "pylons_locked_coin"
)

func GetStoreKysList() (string, string, string, string, string, string, string, string) {
	return KeyPylonsEntity,
		KeyGoogleIAPOrder,
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
	KeyPylonsCookbook,
	KeyPylonsRecipe,
	KeyPylonsItem,
	KeyPylonsExecution,
	KeyPylonsTrade,
	KeyPylonsHistory,
	KeyPylonsLockedCoin,
}
