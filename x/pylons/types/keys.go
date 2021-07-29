package types

const (
	// ModuleName defines the module name
	ModuleName = "pylons"

	// StoreKey defines the primary module store key
	StoreKey = ModuleName

	// RouterKey is the message route for slashing
	RouterKey = ModuleName

	// QuerierRoute defines the module's query routing key
	QuerierRoute = ModuleName

	// MemStoreKey defines the in-memory store key
	MemStoreKey = "mem_pylons"

	// this line is used by starport scaffolding # ibc/keys/name
)

// this line is used by starport scaffolding # ibc/keys/port

func KeyPrefix(p string) []byte {
	return []byte(p)
}

const (
	// CookbookKey is a string key used as a prefix to the KVStore
	CookbookKey = "Cookbook-value-"
)

const (
	// RecipeKey is a string key used as a prefix to the KVStore
	RecipeKey = "Recipe-value-"
)
