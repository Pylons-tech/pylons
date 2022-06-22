package keeper

import (
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k Keeper) SetPaymentProcessHistory(ctx sdk.Context, processHistory types.PaymentProcessHistory) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.PaymentProcessHistoryKey))
	b := k.cdc.MustMarshal(&processHistory)
	store.Set(types.KeyPrefix(processHistory.ExecutionId), b)
}

func (k Keeper) GetPaymentProcessHistory(ctx sdk.Context, executionID string) (val types.PaymentProcessHistory, found bool) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.PaymentProcessHistoryKey))

	b := store.Get(types.KeyPrefix(executionID))
	if b == nil {
		return val, false
	}

	k.cdc.MustUnmarshal(b, &val)
	return val, true
}

func (k Keeper) HasPaymentProcessHistory(ctx sdk.Context, executionID string) bool {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.PaymentProcessHistoryKey))
	return store.Has(types.KeyPrefix(executionID))
}

func (k Keeper) GetAllPaymentProcessHistory(ctx sdk.Context) (list []types.PaymentProcessHistory) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.PaymentProcessHistoryKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val types.PaymentProcessHistory
		k.cdc.MustUnmarshal(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}
