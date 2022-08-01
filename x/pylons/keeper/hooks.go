package keeper

import (
	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

func (k Keeper) BeforeEpochStart(ctx sdk.Context, epochIdentifier string, epochNumber int64, sk v1beta1.StakingKeeper) {
}

func (k Keeper) AfterEpochEnd(ctx sdk.Context, epochIdentifier string, epochNumber int64, sk v1beta1.StakingKeeper) {
	if epochIdentifier == k.DistrEpochIdentifier(ctx) {
		distrPercentages := k.GetRewardsDistributionPercentages(ctx, sk)
		delegatorsRewards := k.CalculateDelegatorsRewards(ctx, distrPercentages)
		if delegatorsRewards != nil {
			err := k.SendRewards(ctx, delegatorsRewards)
			if err != nil {
				panic(err)
			}
		}
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
	sk v1beta1.StakingKeeper
}

// Hooks returns the wrapper struct
func (k Keeper) Hooks(sk v1beta1.StakingKeeper) Hooks {
	return Hooks{k: k, sk: sk}
}
