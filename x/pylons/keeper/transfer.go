package keeper

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	transfertypes "github.com/cosmos/ibc-go/v2/modules/apps/transfer/types"
)

func (k Keeper) GetDenomTrace(ctx sdk.Context, coin sdk.Coin) (transfertypes.DenomTrace, bool) {

	var denomTrace transfertypes.DenomTrace
	traces := k.transferKeeper.GetAllDenomTraces(ctx)

	for _, trace := range traces {

		if coin.Denom == trace.BaseDenom {
			return trace, true
		}
	}

	return denomTrace, false
}

func (k Keeper) SetDenomTrace(ctx sdk.Context, denomTrace transfertypes.DenomTrace) {

	k.transferKeeper.SetDenomTrace(ctx, denomTrace)
}
