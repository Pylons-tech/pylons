package types

import sdk "github.com/cosmos/cosmos-sdk/types"

// TypeItemHistory is a store key for item history
const TypeItemHistory = "item_history"

// ItemHistory is a struct to store Item use history
type ItemHistory struct {
	ID       string
	Owner    sdk.AccAddress
	ItemID   string
	RecipeID string
	TradeID  string
}
