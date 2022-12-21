package keeper

import (
	"cosmossdk.io/math"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	authtypes "github.com/cosmos/cosmos-sdk/x/auth/types"
	bankkeeper "github.com/cosmos/cosmos-sdk/x/bank/keeper"
	stakingtypes "github.com/cosmos/cosmos-sdk/x/staking/types"
)

const (
	ValidatorRewardPercentage     = 10
	BedRockHolderRewardPercentage = 90
)

func (k Keeper) GetRewardsDistributionPercentages(ctx sdk.Context, sk types.StakingKeeper) (distPercentages []types.DistributionPercentage) {
	distrPercentages := make(map[string]sdk.Dec)
	distPercentage := make([]types.DistributionPercentage, 0)
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
		delegatorPercentage := types.DistributionPercentage{}
		validatorPercentage := types.DistributionPercentage{}
		valAddr := delegation.GetValidatorAddr()
		validator := sk.Validator(ctx, valAddr)

		valAccAddr := sdk.AccAddress(valAddr)

		shares := sharesMap[delegation.DelegatorAddress]
		sharesPercentage := shares.Quo(totalShares)

		if _, ok := distrPercentages[delegation.DelegatorAddress]; !ok {
			distrPercentages[delegation.DelegatorAddress] = sdk.ZeroDec()
			delegatorPercentage.SharePercentage = sdk.ZeroDec()
			delegatorPercentage.Address = delegation.DelegatorAddress
		}

		if valAccAddr.String() == delegation.DelegatorAddress {
			distrPercentages[delegation.DelegatorAddress] = distrPercentages[delegation.DelegatorAddress].Add(sharesPercentage)
			delegatorPercentage.SharePercentage = sharesPercentage
			delegatorPercentage.Address = delegation.DelegatorAddress
		} else {
			commission := validator.GetCommission()
			commissionPercentage := sharesPercentage.Mul(commission)
			actualPercentage := sharesPercentage.Sub(commissionPercentage)
			distrPercentages[delegation.DelegatorAddress] = distrPercentages[delegation.DelegatorAddress].Add(actualPercentage)
			delegatorPercentage.SharePercentage = actualPercentage
			delegatorPercentage.Address = delegation.DelegatorAddress
			// we also add the commission percentage to the validator
			if _, ok := distrPercentages[valAccAddr.String()]; !ok {
				// in case the validator was not yet added to the map
				distrPercentages[valAccAddr.String()] = sdk.ZeroDec()
				validatorPercentage.SharePercentage = sdk.ZeroDec()
				validatorPercentage.Address = valAccAddr.String()
			}
			distrPercentages[valAccAddr.String()] = distrPercentages[valAccAddr.String()].Add(commissionPercentage)
			validatorPercentage.SharePercentage = commissionPercentage
			validatorPercentage.Address = valAccAddr.String()
		}
		distPercentage = append(distPercentage, delegatorPercentage)
		distPercentage = append(distPercentage, validatorPercentage)
	}
	return distPercentage
}

func (k Keeper) getTotalSupply(ctx sdk.Context, ak types.AccountKeeper, denom string) sdk.Dec {
	// Get all account balances
	bankBaseKeeper, _ := k.bankKeeper.(bankkeeper.BaseKeeper)
	accs := bankBaseKeeper.GetAccountsBalances(ctx)
	totalAvailable := sdk.ZeroDec()
	moduleAccs := getModuleAccountsWithAddress(ctx, ak)
	for _, acc := range accs {
		found := checkModuleAccount(acc.Address, moduleAccs)
		if !found {
			balance := sdk.NewDec(acc.Coins.AmountOf(denom).Int64())
			// Check if denom token amount GT 0
			if balance.GT(sdk.ZeroDec()) {
				totalAvailable = totalAvailable.Add(balance)
			}
		}

	}
	return totalAvailable
}

func (k Keeper) GetHoldersRewardsDistributionPercentages(ctx sdk.Context, sk types.StakingKeeper, ak types.AccountKeeper) (distrPercentages []types.DistributionPercentage) {
	distrPercentages = make([]types.DistributionPercentage, 0)
	stakingDenom := types.StakingCoinDenom
	// Get all account balances
	bankBaseKeeper, _ := k.bankKeeper.(bankkeeper.BaseKeeper)
	totalSupply := k.getTotalSupply(ctx, ak, stakingDenom)
	moduleAccs := getModuleAccountsWithAddress(ctx, ak)
	accs := bankBaseKeeper.GetAccountsBalances(ctx)
	for _, acc := range accs {
		balance := sdk.NewDec(acc.Coins.AmountOf(stakingDenom).Int64())

		// Check if denom token amount GT 0
		if balance.GT(sdk.ZeroDec()) {
			found := checkModuleAccount(acc.Address, moduleAccs)
			if !found {
				sharePercentage := balance.Quo(totalSupply)
				distPercentage := types.DistributionPercentage{
					Address:         acc.Address,
					SharePercentage: sharePercentage,
				}
				distrPercentages = append(distrPercentages, distPercentage)
			}

		}
	}
	return distrPercentages
}

func calculateAvailableAmount(coin math.Int) sdk.Dec {
	validatorRewardPercentage := sdk.NewDecFromInt(math.NewInt(ValidatorRewardPercentage)).Quo(sdk.NewDec(100))
	return sdk.NewDecFromInt(coin).Mul(validatorRewardPercentage)
}

func calculateHolderAavailableAmount(coin math.Int) sdk.Dec {
	holderPercentage := sdk.NewDec(BedRockHolderRewardPercentage).Quo(sdk.NewDec(100))
	return sdk.NewDecFromInt(coin).Mul(holderPercentage)
}

func (k Keeper) CalculateRewardsHelper(distrPercentages []types.DistributionPercentage, rewardsTotalAmount sdk.Coins) (delegatorsRewards []types.DistributionCoin) {
	if !rewardsTotalAmount.IsZero() {
		delegatorsRewards = make([]types.DistributionCoin, 0)
		for _, percentage := range distrPercentages {
			totalAmountsForAddr := sdk.NewCoins()
			for _, coin := range rewardsTotalAmount {

				availableAmount := calculateAvailableAmount(coin.Amount)
				amountForAddr := availableAmount.Mul(percentage.SharePercentage)
				if amountForAddr.IsPositive() {
					// only add strictly positive amounts
					totalAmountsForAddr = totalAmountsForAddr.Add(sdk.NewCoin(coin.Denom, amountForAddr.RoundInt()))
				}
			}
			if !totalAmountsForAddr.Empty() {
				distrCoins := types.DistributionCoin{
					Address: percentage.Address,
					Coins:   totalAmountsForAddr,
				}
				delegatorsRewards = append(delegatorsRewards, distrCoins)
			}
		}
	} else {
		return nil
	}
	return
}

func (k Keeper) CalculateHolderRewardsHelper(distrPercentages []types.DistributionPercentage, rewardsTotalAmount sdk.Coins) (holdersRewards []types.DistributionCoin) {
	if !rewardsTotalAmount.IsZero() {
		holdersRewards = make([]types.DistributionCoin, 0)
		for _, percentage := range distrPercentages {
			totalAmountsForAddr := sdk.NewCoins()
			for _, coin := range rewardsTotalAmount {

				availableAmount := calculateHolderAavailableAmount(coin.Amount)
				amountForAddr := availableAmount.Mul(percentage.SharePercentage)
				if amountForAddr.IsPositive() {
					// only add strictly positive amounts
					totalAmountsForAddr = totalAmountsForAddr.Add(sdk.NewCoin(coin.Denom, amountForAddr.RoundInt()))
				}
			}
			if !totalAmountsForAddr.Empty() {
				distrCoins := types.DistributionCoin{
					Address: percentage.Address,
					Coins:   totalAmountsForAddr,
				}
				holdersRewards = append(holdersRewards, distrCoins)
			}
		}
	} else {
		return nil
	}
	return
}

func (k Keeper) SendRewards(ctx sdk.Context, delegatorsRewards []types.DistributionCoin) error {
	for _, dist := range delegatorsRewards {
		accAddr, _ := sdk.AccAddressFromBech32(dist.Address)
		err := k.SendRewardsFromFeeCollector(ctx, accAddr, dist.Coins)
		if err != nil {
			return sdkerrors.Wrapf(err, "unable to send coins to %v from %v", dist.Address, k.FeeCollectorAddress().String())
		}
	}
	return nil
}

// Get all module accounts
func getModuleAccountsWithAddress(ctx sdk.Context, ak types.AccountKeeper) []string {
	moduleAddress := []string{}
	accs := ak.GetAllAccounts(ctx)
	for _, acc := range accs {
		_, ok := acc.(*authtypes.ModuleAccount)
		if ok {
			moduleAddress = append(moduleAddress, acc.GetAddress().String())
		}
	}
	return moduleAddress
}

func checkModuleAccount(acc string, modAccs []string) bool {
	found := false
	for _, modacc := range modAccs {
		// check if account address is equal to module account address, if equal do not distribute
		if acc == modacc {
			found = true
			break
		} else {
			// if account address is not equal to module account address, distribute
			found = false
		}
	}
	return found
}

// func convertMapToArray(distrPercentage map[string]sdk.Dec) []types.DistributionPercentage {
// 	distPercentage := make([]types.DistributionPercentage, 0)
// 	for add, percentage := range distrPercentage {
// 		percentage := types.DistributionPercentage{
// 			Address:         add,
// 			SharePercentage: percentage,
// 		}
// 		distPercentage = append(distPercentage, percentage)
// 	}
// 	return distPercentage
// }
