package keeper

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"	
	
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k Keeper) GetRewardsDistributionPercentages(ctx sdk.Context, sk types.StakingKeeper) (distrPercentages map[string]sdk.Dec) {
	distrPercentages = make(map[string]sdk.Dec)
	// get all delegations
	delegations := sk.GetAllSDKDelegations(ctx)
	// create a map to efficiently store validatorShares so it's not fetched more than once
	validatorSharesMap := make(map[string]sdk.Dec)
	for _, delegation := range delegations {
		validatorAddr := delegation.GetValidatorAddr()
		delegatorAddr := delegation.GetDelegatorAddr()
		valShares, ok := validatorSharesMap[validatorAddr.String()]
		if !ok {
			// retrieve validator share if not done before
			validator := sk.Validator(ctx, validatorAddr)
			valShares = validator.GetDelegatorShares()
			validatorSharesMap[validatorAddr.String()] = valShares
		}
		// the shares of a delegaror represent the relative shares percentage of the total shares of the validator
		// calculate absolute percentage as totalValidatorShares / relativeDelegatorShares

		delegatorAbsolutePercentage := valShares.Quo((delegation.GetShares()))
		if _, ok := distrPercentages[delegatorAddr.String()]; !ok {
			distrPercentages[delegatorAddr.String()] = sdk.ZeroDec()
		}
		distrPercentages[delegatorAddr.String()] = distrPercentages[delegatorAddr.String()].Add(delegatorAbsolutePercentage)
	}

	return
}

func (k Keeper) CalculateDelegatorsRewards(ctx sdk.Context, distrPercentages map[string]sdk.Dec) (delegatorsRewards map[string]sdk.Coins) {
	delegatorsRewards = make(map[string]sdk.Coins)
	// get the balance of the feeCollector moduleAcc
	rewardsTotalAmount := k.bankKeeper.SpendableCoins(ctx, k.FeeCollectorAddress())
	for addr, percentage := range distrPercentages {
		totalAmountsForAddr := sdk.NewCoins()
		for _, coin := range rewardsTotalAmount {
			amountForAddr := coin.Amount.ToDec().Mul(percentage).TruncateInt()
			if amountForAddr.IsPositive() {
				// only add strictly positive amounts
				totalAmountsForAddr = totalAmountsForAddr.Add(sdk.NewCoin(coin.Denom, amountForAddr))
			}
		}
		delegatorsRewards[addr] = totalAmountsForAddr
	}

	return
}

func (k Keeper) SendRewards(ctx sdk.Context, delegatorsRewards map[string]sdk.Coins) error {
	for addr, amount := range delegatorsRewards {
		accAddr, _ := sdk.AccAddressFromBech32(addr)
		err := k.SendRewardsFromFeeCollector(ctx, accAddr, amount)
		if err != nil {
			return sdkerrors.Wrapf(err, "unable to send coins to %v from %v", addr, k.FeeCollectorAddress().String())
		}
	}
	return nil
}
