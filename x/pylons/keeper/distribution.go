package keeper

import (
	"cosmossdk.io/math"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	bankkeeper "github.com/cosmos/cosmos-sdk/x/bank/keeper"
	stakingtypes "github.com/cosmos/cosmos-sdk/x/staking/types"
)

const (
	VALIDATORS_REWARD_PERCENTAGE     = 1
	BEDROCK_HOLDER_REWARD_PERCENTAGE = 9
)

func (k Keeper) GetRewardsDistributionPercentages(ctx sdk.Context, sk types.StakingKeeper) (distrPercentages map[string]sdk.Dec) {
	distrPercentages = make(map[string]sdk.Dec)
	sharesMap := make(map[string]sdk.Dec)
	validators := make(map[string]bool)
	totalShares := sdk.ZeroDec()

	// get all delegations
	delegations := sk.GetAllSDKDelegations(ctx)
	prunedDelegations := make([]stakingtypes.Delegation, 0)
	for _, delegation := range delegations {
		valAddr := delegation.GetValidatorAddr()
		validator := sk.Validator(ctx, valAddr)
		if !validator.IsBonded() {
			// skip unbonded validators
			continue
		}

		if _, ok := validators[valAddr.String()]; !ok {
			validators[valAddr.String()] = true
			totalShares = totalShares.Add(validator.GetDelegatorShares())
		}

		delegatorAddr := delegation.GetDelegatorAddr()
		// the shares of a delegator represents already the absolute shares percentage of the total shares (not just relative to the validator)
		if _, ok := sharesMap[delegatorAddr.String()]; !ok {
			sharesMap[delegatorAddr.String()] = sdk.ZeroDec()
		}
		sharesMap[delegatorAddr.String()] = sharesMap[delegatorAddr.String()].Add(delegation.GetShares())
		prunedDelegations = append(prunedDelegations, delegation)
	}

	for _, delegation := range prunedDelegations {
		valAddr := delegation.GetValidatorAddr()
		validator := sk.Validator(ctx, valAddr)

		valAccAddr := sdk.AccAddress(valAddr)

		shares := sharesMap[delegation.DelegatorAddress]
		sharesPercentage := shares.Quo(totalShares)

		if _, ok := distrPercentages[delegation.DelegatorAddress]; !ok {
			distrPercentages[delegation.DelegatorAddress] = sdk.ZeroDec()
		}

		if valAccAddr.String() == delegation.DelegatorAddress {
			distrPercentages[delegation.DelegatorAddress] = distrPercentages[delegation.DelegatorAddress].Add(sharesPercentage)
		} else {
			commission := validator.GetCommission()
			commissionPercentage := sharesPercentage.Mul(commission)
			actualPercentage := sharesPercentage.Sub(commissionPercentage)
			distrPercentages[delegation.DelegatorAddress] = distrPercentages[delegation.DelegatorAddress].Add(actualPercentage)
			// we also add the commission percentage to the validator
			if _, ok := distrPercentages[valAccAddr.String()]; !ok {
				// in case the validator was not yet added to the map
				distrPercentages[valAccAddr.String()] = sdk.ZeroDec()
			}
			distrPercentages[valAccAddr.String()] = distrPercentages[valAccAddr.String()].Add(commissionPercentage)
		}
	}

	return distrPercentages
}

func (k Keeper) getTotalSupply(ctx sdk.Context, denom string) math.Int {

	// Get all account balances
	bankBaseKeeper, _ := k.bankKeeper.(bankkeeper.BaseKeeper)
	accs := bankBaseKeeper.GetAccountsBalances(ctx)

	totalAvailable := math.ZeroInt()

	for _, acc := range accs {
		balance := acc.Coins.AmountOf(denom)
		// Check if denom token amount GT 0
		if balance.GT(math.ZeroInt()) {

			totalAvailable = totalAvailable.Add(balance)
		}
	}

	return totalAvailable
}

func (k Keeper) GetHoldersRewardsDistributionPercentages(ctx sdk.Context, sk types.StakingKeeper) map[string]sdk.Dec {

	distrPercentages := make(map[string]sdk.Dec)
	stakingDenom := types.StakingCoinDenom
	// Get all account balances
	bankBaseKeeper, _ := k.bankKeeper.(bankkeeper.BaseKeeper)
	totalSupply := k.getTotalSupply(ctx, stakingDenom)

	accs := bankBaseKeeper.GetAccountsBalances(ctx)

	for _, acc := range accs {
		balance := acc.Coins.AmountOf(stakingDenom)
		// Check if denom token amount GT 0
		if balance.GT(math.ZeroInt()) {

			sharePercentage := balance.Quo(totalSupply)
			distrPercentages[acc.Address] = sdk.Dec(sharePercentage)
		}
	}
	return distrPercentages
}

func calculateAvailableAmount(coin math.Int) math.Int {

	validatorRewardPercentage := sdk.NewDecFromInt(math.NewInt(VALIDATORS_REWARD_PERCENTAGE))
	return sdk.NewDecFromInt(coin).Mul(validatorRewardPercentage).TruncateInt()

}

func calculateDelegatorAvailableAmount(coin math.Int) math.Int {

	validatorRewardPercentage := sdk.NewDecFromInt(math.NewInt(BEDROCK_HOLDER_REWARD_PERCENTAGE))
	return sdk.NewDecFromInt(coin).Mul(validatorRewardPercentage).TruncateInt()

}
func CalculateRewardsHelper(distrPercentages map[string]sdk.Dec, rewardsTotalAmount sdk.Coins) (delegatorsRewards map[string]sdk.Coins) {
	delegatorsRewards = make(map[string]sdk.Coins)
	for addr, percentage := range distrPercentages {
		totalAmountsForAddr := sdk.NewCoins()
		for _, coin := range rewardsTotalAmount {

			availableAmount := calculateAvailableAmount(coin.Amount)
			amountForAddr := sdk.NewDecFromInt(availableAmount).Mul(percentage).TruncateInt()
			if amountForAddr.IsPositive() {
				// only add strictly positive amounts
				totalAmountsForAddr = totalAmountsForAddr.Add(sdk.NewCoin(coin.Denom, amountForAddr))
			}
		}
		if !totalAmountsForAddr.Empty() {
			delegatorsRewards[addr] = totalAmountsForAddr
		}
	}
	return
}

func CalculateHolderRewardsHelper(distrPercentages map[string]sdk.Dec, rewardsTotalAmount sdk.Coins) (delegatorsRewards map[string]sdk.Coins) {
	delegatorsRewards = make(map[string]sdk.Coins)
	for addr, percentage := range distrPercentages {
		totalAmountsForAddr := sdk.NewCoins()
		for _, coin := range rewardsTotalAmount {

			availableAmount := calculateDelegatorAvailableAmount(coin.Amount)
			amountForAddr := sdk.NewDecFromInt(availableAmount).Mul(percentage).TruncateInt()
			if amountForAddr.IsPositive() {
				// only add strictly positive amounts
				totalAmountsForAddr = totalAmountsForAddr.Add(sdk.NewCoin(coin.Denom, amountForAddr))
			}
		}
		if !totalAmountsForAddr.Empty() {
			delegatorsRewards[addr] = totalAmountsForAddr
		}
	}
	return
}

func (k Keeper) CalculateDelegatorsRewards(ctx sdk.Context, distrPercentages map[string]sdk.Dec) map[string]sdk.Coins {
	// get the balance of the feeCollector moduleAcc
	rewardsTotalAmount := k.bankKeeper.SpendableCoins(ctx, k.FeeCollectorAddress())
	if !rewardsTotalAmount.IsZero() {
		return CalculateRewardsHelper(distrPercentages, rewardsTotalAmount)
	}
	return nil
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

func (k Keeper) CalculateHolderRewards(ctx sdk.Context, distrPercentages map[string]sdk.Dec) map[string]sdk.Coins {
	// get the balance of the feeCollector moduleAcc
	rewardsTotalAmount := k.bankKeeper.SpendableCoins(ctx, k.FeeCollectorAddress())
	if !rewardsTotalAmount.IsZero() {
		return CalculateHolderRewardsHelper(distrPercentages, rewardsTotalAmount)
	}
	return nil
}
