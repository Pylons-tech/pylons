package keep

import (
	"fmt"
	"strconv"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// KeyEntityCount is an entity key
const KeyEntityCount = "key_entity_count"

// IncreaseEntityCount sets a item in the key store
func (k Keeper) IncreaseEntityCount(ctx sdk.Context) {
	newCount := k.GetEntityCount(ctx) + 1

	store := ctx.KVStore(k.EntityKey)
	store.Set([]byte(KeyEntityCount), []byte(fmt.Sprintf("%d", newCount)))
}

// GetEntityCount returns entity count
func (k Keeper) GetEntityCount(ctx sdk.Context) int {
	if k.EntityKey == nil {
		return 0
	}
	store := ctx.KVStore(k.EntityKey)

	countStr := store.Get([]byte(KeyEntityCount))
	count, err := strconv.Atoi(string(countStr))
	if err != nil {
		count = 0
	}
	return count
}
