package keeper

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/x/distribution/types"

	epochstypes "github.com/Pylons-tech/pylons/x/epochs/types"
)

func (k Keeper) BeforeEpochStart(ctx sdk.Context, epochIdentifier string, epochNumber int64, sk types.StakingKeeper) {
}

func (k Keeper) AfterEpochEnd(ctx sdk.Context, epochIdentifier string, epochNumber int64, sk types.StakingKeeper) {
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
	sk types.StakingKeeper
}

var _ epochstypes.EpochHooks = Hooks{}

// Hooks returns the wrapper struct
func (k Keeper) Hooks(sk types.StakingKeeper) Hooks {
	return Hooks{k: k, sk: sk}
}

func (h Hooks) BeforeEpochStart(ctx sdk.Context, epochIdentifier string, epochNumber int64) {
	h.k.BeforeEpochStart(ctx, epochIdentifier, epochNumber, h.sk)
}

func (h Hooks) AfterEpochEnd(ctx sdk.Context, epochIdentifier string, epochNumber int64) {
	h.k.AfterEpochEnd(ctx, epochIdentifier, epochNumber, h.sk)
}
