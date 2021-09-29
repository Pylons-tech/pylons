package simulation

import (
	"bytes"
	"fmt"

	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/types/kv"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// NewDecodeStore returns a decoder function closure that unmarshals the KVPair's
// Value to the corresponding pylons type.
func NewDecodeStore(cdc codec.Codec) func(kvA, kvB kv.Pair) string {
	return func(kvA, kvB kv.Pair) string {
		switch {
		case bytes.Equal(kvA.Key[:1], types.KeyPrefix(types.CookbookKey)):
			var cookbookA, cookbookB types.Cookbook
			cdc.MustUnmarshal(kvA.Value, &cookbookA)
			cdc.MustUnmarshal(kvB.Value, &cookbookB)
			return fmt.Sprintf("%v\n%v", cookbookA, cookbookB)

		// TODO
		case bytes.Equal(kvA.Key[:1], types.KeyPrefix(types.AddrCookbookKey)):
			var cookbookA, cookbookB types.Cookbook
			cdc.MustUnmarshal(kvA.Value, &cookbookA)
			cdc.MustUnmarshal(kvB.Value, &cookbookB)
			return fmt.Sprintf("%v\n%v", cookbookA, cookbookB)

		case bytes.Equal(kvA.Key[:1], types.KeyPrefix(types.RecipeKey)):
			var recipeA, recipeB types.Recipe
			cdc.MustUnmarshal(kvA.Value, &recipeA)
			cdc.MustUnmarshal(kvB.Value, &recipeB)
			return fmt.Sprintf("%v\n%v", recipeA, recipeB)

		case bytes.Equal(kvA.Key[:1], types.KeyPrefix(types.ItemKey)):
			var itemA, itemB types.Item
			cdc.MustUnmarshal(kvA.Value, &itemA)
			cdc.MustUnmarshal(kvB.Value, &itemB)
			return fmt.Sprintf("%v\n%v", itemA, itemB)

		case bytes.Equal(kvA.Key[:1], types.KeyPrefix(types.AddrItemKey)):
			var itemA, itemB types.Item
			cdc.MustUnmarshal(kvA.Value, &itemA)
			cdc.MustUnmarshal(kvB.Value, &itemB)
			return fmt.Sprintf("%v\n%v", itemA, itemB)

		case bytes.Equal(kvA.Key[:1], types.KeyPrefix(types.ExecutionKey)):
			var execA, execB types.Execution
			cdc.MustUnmarshal(kvA.Value, &execA)
			cdc.MustUnmarshal(kvB.Value, &execB)
			return fmt.Sprintf("%v\n%v", execA, execB)

		case bytes.Equal(kvA.Key[:1], types.KeyPrefix(types.RecipeExecutionKey)):
			var execA, execB types.Execution
			cdc.MustUnmarshal(kvA.Value, &execA)
			cdc.MustUnmarshal(kvB.Value, &execB)
			return fmt.Sprintf("%v\n%v", execA, execB)

		case bytes.Equal(kvA.Key[:1], types.KeyPrefix(types.ItemExecutionKey)):
			var execA, execB types.Execution
			cdc.MustUnmarshal(kvA.Value, &execA)
			cdc.MustUnmarshal(kvB.Value, &execB)
			return fmt.Sprintf("%v\n%v", execA, execB)

		case bytes.Equal(kvA.Key[:1], types.KeyPrefix(types.PendingExecutionKey)):
			var execA, execB types.Execution
			cdc.MustUnmarshal(kvA.Value, &execA)
			cdc.MustUnmarshal(kvB.Value, &execB)
			return fmt.Sprintf("%v\n%v", execA, execB)

		case bytes.Equal(kvA.Key[:1], types.KeyPrefix(types.GoogleInAppPurchaseOrderKey)):
			var giapA, giapB types.GoogleInAppPurchaseOrder
			cdc.MustUnmarshal(kvA.Value, &giapA)
			cdc.MustUnmarshal(kvB.Value, &giapB)
			return fmt.Sprintf("%v\n%v", giapA, giapB)

		case bytes.Equal(kvA.Key[:1], types.KeyPrefix(types.TradeKey)):
			var tradeA, tradeB types.Trade
			cdc.MustUnmarshal(kvA.Value, &tradeA)
			cdc.MustUnmarshal(kvB.Value, &tradeB)
			return fmt.Sprintf("%v\n%v", tradeA, tradeB)

		default:
			panic(fmt.Sprintf("invalid pylons key prefix %X", kvA.Key[:1]))
		}
	}
}
