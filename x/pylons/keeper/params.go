package keeper

import (
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// MinNameFieldLength
func (k Keeper) MinNameFieldLength(ctx sdk.Context) (res uint64) {
	k.paramSpace.Get(ctx, types.ParamStoreKeyMinNameFieldLength, &res)
	return
}

// MinDescriptionFieldLength
func (k Keeper) MinDescriptionFieldLength(ctx sdk.Context) (res uint64) {
	k.paramSpace.Get(ctx, types.ParamStoreKeyMinDescriptionFieldLength, &res)
	return
}

// CoinIssuers
func (k Keeper) CoinIssuers(ctx sdk.Context) (res []types.CoinIssuer) {
	k.paramSpace.Get(ctx, types.ParamStoreKeyCoinIssuers, &res)
	return
}

// CoinIssuedList
func (k Keeper) CoinIssuedList(ctx sdk.Context) (res []string) {
	coinIssuers := k.CoinIssuers(ctx)
	for _, ci := range coinIssuers {
		res = append(res, ci.CoinDenom)
	}
	return
}

//RecipeFeePercentage
func (k Keeper) RecipeFeePercentage(ctx sdk.Context) (res sdk.Dec) {
	k.paramSpace.Get(ctx, types.ParamStoreKeyRecipeFeePercentage, &res)
	return
}

// ItemTransferFeePercentage
func (k Keeper) ItemTransferFeePercentage(ctx sdk.Context) (res sdk.Dec) {
	k.paramSpace.Get(ctx, types.ParamStoreKeyItemTransferFeePercentage, &res)
	return
}

// UpdateItemStringFee
func (k Keeper) UpdateItemStringFee(ctx sdk.Context) (res sdk.Dec) {
	k.paramSpace.Get(ctx, types.ParamStoreKeyUpdateItemStringFee, &res)
	return
}

// MinTransferFee
func (k Keeper) MinTransferFee(ctx sdk.Context) (res sdk.Dec) {
	k.paramSpace.Get(ctx, types.ParamStoreKeyMinTransferFee, &res)
	return
}

// MaxTransferFee
func (k Keeper) MaxTransferFee(ctx sdk.Context) (res sdk.Dec) {
	k.paramSpace.Get(ctx, types.ParamStoreKeyMaxTransferFee, &res)
	return
}


// GetParams returns the total set of slashing parameters.
func (k Keeper) GetParams(ctx sdk.Context) (params types.Params) {
	k.paramSpace.GetParamSet(ctx, &params)
	return params
}

// SetParams sets the slashing parameters to the param space.
func (k Keeper) SetParams(ctx sdk.Context, params types.Params) {
	k.paramSpace.SetParamSet(ctx, &params)
}