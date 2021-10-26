package keeper

import (
	// "fmt"
	// "github.com/cosmos/cosmos-sdk/telemetry"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/x/distribution/types"

	// "github.com/cosmos/cosmos-sdk/x/mint/types"

	epochstypes "github.com/Pylons-tech/pylons/x/epochs/types"
)

func (k Keeper) BeforeEpochStart(ctx sdk.Context, epochIdentifier string, epochNumber int64, sk types.StakingKeeper) {
}

func (k Keeper) AfterEpochEnd(ctx sdk.Context, epochIdentifier string, epochNumber int64, sk types.StakingKeeper) {
	distrPercentages := k.GetRewardsDistributionPercentages(ctx, sk)
	delegatorsRewards := k.CalculateDelegatorsRewards(ctx, distrPercentages)
	err := k.SendRewards(ctx, delegatorsRewards)
	if err != nil {
		panic(err)
	}
}

// ___________________________________________________________________________________________________

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
