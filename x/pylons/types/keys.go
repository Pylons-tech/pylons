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
	// AddrCookbookKey is a string key used as a prefix to the KVStore
	AddrCookbookKey = "Address-cookbook-"
	// RecipeKey is a string key used as a prefix to the KVStore
	RecipeKey = "Recipe-value-"
	// RecipeHistory is a string key used as a prefix to the KVStore
	RecipeHistoryKey = "Recipe-History-value-"
	// ItemKey is a string key used as a prefix to the KVStore
	ItemKey = "Item-value-"
	// ItemCountKey is a string key used as a prefix to the KVStore
	ItemCountKey = "Item-count-"
	// AddrItemKey is a string key used as a prefix to the KVStore
	AddrItemKey = "Address-item-"
	// ExecutionKey is a string key used as a prefix to the KVStore
	ExecutionKey = "Execution-value-"
	// ExecutionCountKey is a string key used as a prefix to the KVStore
	ExecutionCountKey = "Execution-count-"
	// RecipeExecutionKey is a string key used as a prefix to the KVStore
	RecipeExecutionKey = "Recipe-execution-"
	// ItemExecutionKey is a string key used as a prefix to the KVStore
	ItemExecutionKey = "Item-execution-"
	// PendingExecutionKey is a string key used as a prefix to the KVStore
	PendingExecutionKey = "PendingExecution-value-"
	// PendingExecutionCountKey is a string key used as a prefix to the KVStore
	PendingExecutionCountKey = "PendingExecution-count-"
	// GoogleInAppPurchaseOrderKey is a string key used as a prefix to the KVStore
	GoogleInAppPurchaseOrderKey = "GoogleInAppPurchaseOrder-value-"
	// GoogleInAppPurchaseOrderCountKey is a string key used as a prefix to the KVStore
	GoogleInAppPurchaseOrderCountKey = "GoogleInAppPurchaseOrder-count-"
	// GlobalEntityCountKey is a string used as prefix to the KVStore
	GlobalEntityCountKey = "GlobalEntity-count-"
	// TradeKey is a string used as prefix to the KVStore
	TradeKey = "Trade-value-"
	// AddrTradeKey is a string key used as a prefix to the KVStore
	AddrTradeKey = "Address-trade-"
	// TradeCountKey is a string used as prefix to the KVStore
	TradeCountKey = "Trade-count-"
	// UsernameKey is a string used as prefix to the KVStore
	UsernameKey = "Username-value-"
	// AccountKey is a string used as prefix to the KVStore
	AccountKey = "PylonsAccount-value-"
)

const (
	PaymentInfoKey = "PaymentInfo-value-"
)

const (
	RedeemInfoKey = "RedeemInfo-value-"
)
