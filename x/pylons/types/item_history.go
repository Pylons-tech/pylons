package types

// TypeItemHistory is a store key for item history
const TypeItemHistory = "item_history"

// ItemHistory is a struct to store Item use history
type ItemHistory struct {
	ID       string
	ItemID   string
	RecipeID string
	TradeID  string
}
