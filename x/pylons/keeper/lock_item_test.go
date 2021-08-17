package keeper

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestLockItemForExecution(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	orig := createNItem(&keeper, ctx, 1)
	keeper.LockItemForExecution(ctx, orig[0])
	item, _ := keeper.GetItem(ctx, orig[0].CookbookID, orig[0].ID)
	assert.Equal(t, item.Owner, types.ExecutionsLockerName)
}

func TestLockItemForTrade(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	orig := createNItem(&keeper, ctx, 1)
	keeper.LockItemForTrade(ctx, orig[0])
	item, _ := keeper.GetItem(ctx, orig[0].CookbookID, orig[0].ID)
	assert.Equal(t, item.Owner, types.TradesLockerName)
}
