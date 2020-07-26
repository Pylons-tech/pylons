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
	KeyPylonsLockedCoin = "pylons_locked_coin"
)

// StoreKeyList has keys in ordered array
var StoreKeyList = []string{
	KeyPylonsEntity,
	KeyGoogleIAPOrder,
	KeyPylonsCookbook,
	KeyPylonsRecipe,
	KeyPylonsItem,
	KeyPylonsExecution,
	KeyPylonsTrade,
	KeyPylonsLockedCoin,
}
