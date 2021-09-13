package keeper

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// RandomSeed calculate random seed from context and entity count
func (k Keeper) RandomSeed(ctx sdk.Context) int64 {
	entityCount := k.GetEntityCount(ctx)
	header := ctx.BlockHeader()
	appHash := header.AppHash
	seedValue := 0
	for i, bytv := range appHash { // len(appHash) = 11
		intv := int(bytv)
		seedValue += (i*i + 1) * intv
	}
	return int64(seedValue) + int64(entityCount)
}
