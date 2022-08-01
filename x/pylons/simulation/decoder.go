package simulation

import (
	"bytes"
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/types/kv"
)

// NewDecodeStore returns a decoder function closure that unmarshals the KVPair's
// Value to the corresponding pylons type.
func NewDecodeStore(cdc codec.Codec) func(kvA, kvB kv.Pair) string {
	return func(kvA, kvB kv.Pair) string {
		switch {
		case bytes.Equal(kvA.Key[:1], v1beta1.KeyPrefix(v1beta1.CookbookKey)):
			var cookbookA, cookbookB v1beta1.Cookbook
			cdc.MustUnmarshal(kvA.Value, &cookbookA)
			cdc.MustUnmarshal(kvB.Value, &cookbookB)
			return fmt.Sprintf("%v\n%v", cookbookA, cookbookB)

		// TODO
		case bytes.Equal(kvA.Key[:1], v1beta1.KeyPrefix(v1beta1.AddrCookbookKey)):
			var cookbookA, cookbookB v1beta1.Cookbook
			cdc.MustUnmarshal(kvA.Value, &cookbookA)
			cdc.MustUnmarshal(kvB.Value, &cookbookB)
			return fmt.Sprintf("%v\n%v", cookbookA, cookbookB)

		case bytes.Equal(kvA.Key[:1], v1beta1.KeyPrefix(v1beta1.RecipeKey)):
			var recipeA, recipeB v1beta1.Recipe
			cdc.MustUnmarshal(kvA.Value, &recipeA)
			cdc.MustUnmarshal(kvB.Value, &recipeB)
			return fmt.Sprintf("%v\n%v", recipeA, recipeB)

		case bytes.Equal(kvA.Key[:1], v1beta1.KeyPrefix(v1beta1.ItemKey)):
			var itemA, itemB v1beta1.Item
			cdc.MustUnmarshal(kvA.Value, &itemA)
			cdc.MustUnmarshal(kvB.Value, &itemB)
			return fmt.Sprintf("%v\n%v", itemA, itemB)

		case bytes.Equal(kvA.Key[:1], v1beta1.KeyPrefix(v1beta1.AddrItemKey)):
			var itemA, itemB v1beta1.Item
			cdc.MustUnmarshal(kvA.Value, &itemA)
			cdc.MustUnmarshal(kvB.Value, &itemB)
			return fmt.Sprintf("%v\n%v", itemA, itemB)

		case bytes.Equal(kvA.Key[:1], v1beta1.KeyPrefix(v1beta1.ExecutionKey)):
			var execA, execB v1beta1.Execution
			cdc.MustUnmarshal(kvA.Value, &execA)
			cdc.MustUnmarshal(kvB.Value, &execB)
			return fmt.Sprintf("%v\n%v", execA, execB)

		case bytes.Equal(kvA.Key[:1], v1beta1.KeyPrefix(v1beta1.RecipeExecutionKey)):
			var execA, execB v1beta1.Execution
			cdc.MustUnmarshal(kvA.Value, &execA)
			cdc.MustUnmarshal(kvB.Value, &execB)
			return fmt.Sprintf("%v\n%v", execA, execB)

		case bytes.Equal(kvA.Key[:1], v1beta1.KeyPrefix(v1beta1.ItemExecutionKey)):
			var execA, execB v1beta1.Execution
			cdc.MustUnmarshal(kvA.Value, &execA)
			cdc.MustUnmarshal(kvB.Value, &execB)
			return fmt.Sprintf("%v\n%v", execA, execB)

		case bytes.Equal(kvA.Key[:1], v1beta1.KeyPrefix(v1beta1.PendingExecutionKey)):
			var execA, execB v1beta1.Execution
			cdc.MustUnmarshal(kvA.Value, &execA)
			cdc.MustUnmarshal(kvB.Value, &execB)
			return fmt.Sprintf("%v\n%v", execA, execB)

		case bytes.Equal(kvA.Key[:1], v1beta1.KeyPrefix(v1beta1.GoogleInAppPurchaseOrderKey)):
			var giapA, giapB v1beta1.GoogleInAppPurchaseOrder
			cdc.MustUnmarshal(kvA.Value, &giapA)
			cdc.MustUnmarshal(kvB.Value, &giapB)
			return fmt.Sprintf("%v\n%v", giapA, giapB)

		case bytes.Equal(kvA.Key[:1], v1beta1.KeyPrefix(v1beta1.TradeKey)):
			var tradeA, tradeB v1beta1.Trade
			cdc.MustUnmarshal(kvA.Value, &tradeA)
			cdc.MustUnmarshal(kvB.Value, &tradeB)
			return fmt.Sprintf("%v\n%v", tradeA, tradeB)

		default:
			panic(fmt.Sprintf("invalid pylons key prefix %X", kvA.Key[:1]))
		}
	}
}
