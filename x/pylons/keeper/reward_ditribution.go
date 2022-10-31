package keeper

import (
	"time"

	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k Keeper) GetRewardDistribution(ctx sdk.Context, addr string) types.RewardHistory {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.RewardEventKey))
	var rewardOrder types.RewardHistory
	k.cdc.MustUnmarshal(store.Get(types.KeyPrefix(addr)), &rewardOrder)
	return rewardOrder
}
func (k Keeper) SetRewardDistribution(ctx sdk.Context, reward types.RewardHistory) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.RewardEventKey))
	b := k.cdc.MustMarshal(&reward)
	store.Set(types.KeyPrefix(reward.Receiver+time.Now().String()), b)
}

// GetAllAppleIAPOrder returns all AppleIAPOrder
func (k Keeper) GetAllRewardDistribution(ctx sdk.Context, addr string) (list []*types.RewardHistory) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.RewardEventKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val types.RewardHistory
		k.cdc.MustUnmarshal(iterator.Value(), &val)
		if val.Receiver == addr {
			list = append(list, &val)
		}
	}

	return
}
