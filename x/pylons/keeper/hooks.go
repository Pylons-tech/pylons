package keeper

import (
	sdk "github.com/cosmos/cosmos-sdk/types"

	epochstypes "github.com/Pylons-tech/pylons/x/epochs/types"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k Keeper) sendValidatorRewards(ctx sdk.Context, sk types.StakingKeeper, totalRewardCoins sdk.Coins) {
	distrPercentages := k.GetValidatorRewardsDistributionPercentages(ctx, sk)
	delegatorsRewards := k.CalculateValidatorRewardsHelper(distrPercentages, totalRewardCoins)
	if delegatorsRewards != nil {
		err := k.SendRewards(ctx, delegatorsRewards)
		if err != nil {
			panic(err)
		}
	}
}

func (k Keeper) sendDelegatorRewards(ctx sdk.Context, sk types.StakingKeeper, ak types.AccountKeeper, totalRewardCoins sdk.Coins) {
	distrPercentages := k.GetDelegatorRewardsDistributionPercentages(ctx, sk, ak)
	delegatorsRewards := k.CalculateDelegatorRewardsHelper(distrPercentages, totalRewardCoins)
	if delegatorsRewards != nil {
		err := k.SendRewards(ctx, delegatorsRewards)
		if err != nil {
			panic(err)
		}
	}
}

func (k Keeper) BeforeEpochStart(ctx sdk.Context, epochIdentifier string, epochNumber int64, sk types.StakingKeeper) {
}

func (k Keeper) AfterEpochEnd(ctx sdk.Context, epochIdentifier string, epochNumber int64, sk types.StakingKeeper, ak types.AccountKeeper) {
	if epochIdentifier == k.DistrEpochIdentifier(ctx) {
		// get the balance of the feeCollector moduleAcc
		rewardsTotalAmount := k.bankKeeper.SpendableCoins(ctx, k.FeeCollectorAddress())
		k.sendValidatorRewards(ctx, sk, rewardsTotalAmount)
		k.sendDelegatorRewards(ctx, sk, ak, rewardsTotalAmount)
	}
}

// ___________________________________________________________________________________________________

/*
network with some validators, various coins in the module account, set an epoc in genesis that triggers after 1 min
check if expected distribution corresponds


1. network is created with some validators and a 30 seconds epoch
2. create a list of delegators for each validator, amounts are randomly generated
3. send delegate messages to the network
4. simulate a recipe execution so fees are collected

*/

// Hooks wrapper struct for incentives keeper

type Hooks struct {
	k  Keeper
	sk types.StakingKeeper
	ak types.AccountKeeper
}

var _ epochstypes.EpochHooks = Hooks{}

// Hooks returns the wrapper struct
func (k Keeper) Hooks(sk types.StakingKeeper, ak types.AccountKeeper) Hooks {
	return Hooks{k: k, sk: sk, ak: ak}
}

func (h Hooks) BeforeEpochStart(ctx sdk.Context, epochIdentifier string, epochNumber int64) {
	h.k.BeforeEpochStart(ctx, epochIdentifier, epochNumber, h.sk)
}

func (h Hooks) AfterEpochEnd(ctx sdk.Context, epochIdentifier string, epochNumber int64) {
	h.k.AfterEpochEnd(ctx, epochIdentifier, epochNumber, h.sk, h.ak)
}
