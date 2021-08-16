package keeper

import (
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// MinNameFieldLength returns the MinNameFieldLength param
func (k Keeper) MinNameFieldLength(ctx sdk.Context) (res uint64) {
	k.paramSpace.Get(ctx, types.ParamStoreKeyMinNameFieldLength, &res)
	return
}

// MinDescriptionFieldLength returns the MinDescriptionFieldLength param
func (k Keeper) MinDescriptionFieldLength(ctx sdk.Context) (res uint64) {
	k.paramSpace.Get(ctx, types.ParamStoreKeyMinDescriptionFieldLength, &res)
	return
}

// CoinIssuers returns the CoinIssuers param
func (k Keeper) CoinIssuers(ctx sdk.Context) (res []types.CoinIssuer) {
	k.paramSpace.Get(ctx, types.ParamStoreKeyCoinIssuers, &res)
	return
}

// CoinIssuedList returns the CoinIssuedList param
func (k Keeper) CoinIssuedList(ctx sdk.Context) (res []string) {
	coinIssuers := k.CoinIssuers(ctx)
	for _, ci := range coinIssuers {
		res = append(res, ci.CoinDenom)
	}
	return
}

// RecipeFeePercentage returns the RecipeFeePercentage param
func (k Keeper) RecipeFeePercentage(ctx sdk.Context) (res sdk.Dec) {
	k.paramSpace.Get(ctx, types.ParamStoreKeyRecipeFeePercentage, &res)
	return
}

// ItemTransferFeePercentage returns the CoinIssuedList param
func (k Keeper) ItemTransferFeePercentage(ctx sdk.Context) (res sdk.Dec) {
	k.paramSpace.Get(ctx, types.ParamStoreKeyItemTransferFeePercentage, &res)
	return
}

// UpdateItemStringFee returns the UpdateItemStringFee param
func (k Keeper) UpdateItemStringFee(ctx sdk.Context) (res sdk.Dec) {
	k.paramSpace.Get(ctx, types.ParamStoreKeyUpdateItemStringFee, &res)
	return
}

// MinTransferFee returns the MinTransferFee param
func (k Keeper) MinTransferFee(ctx sdk.Context) (res sdk.Dec) {
	k.paramSpace.Get(ctx, types.ParamStoreKeyMinTransferFee, &res)
	return
}

// MaxTransferFee returns the MaxTransferFee param
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
