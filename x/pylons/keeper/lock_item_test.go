package keeper_test

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestLockItemForExecution(t *testing.T) {
	k, ctx := setupKeeper(t)
	orig := createNItem(&k, ctx, 1)
	k.LockItemForExecution(ctx, orig[0])
	item, _ := k.GetItem(ctx, orig[0].CookbookID, orig[0].ID)
	assert.Equal(t, item.Owner, k.ExecutionsLockerAddress().String())
}

func TestLockItemForTrade(t *testing.T) {
	k, ctx := setupKeeper(t)
	orig := createNItem(&k, ctx, 1)
	k.LockItemForTrade(ctx, orig[0])
	item, _ := k.GetItem(ctx, orig[0].CookbookID, orig[0].ID)
	assert.Equal(t, item.Owner, k.TradesLockerAddress().String())
}
