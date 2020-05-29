package pylons

const (
	KeyPylonsEntity    = "pylons_entity"
	KeyPylonsCookbook  = "pylons_cookbook"
	KeyPylonsRecipe    = "pylons_recipe"
	KeyPylonsItem      = "pylons_item"
	KeyPylonsExecution = "pylons_exection"
	KeyPylonsTrade     = "pylons_trade"
)

const (
	// ModuleName is the name of the module
	ModuleName = "pylons"

	// StoreKey to be used when creating the KVStore
	StoreKey = ModuleName

	// RouterKey is the module name router key
	RouterKey = ModuleName

	// QuerierRoute to be used for querierer msgs
	QuerierRoute = ModuleName
)
