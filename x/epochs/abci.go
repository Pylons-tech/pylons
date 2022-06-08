package epochs

import (
	"fmt"
	"time"

	"github.com/cosmos/cosmos-sdk/telemetry"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/epochs/keeper"
	"github.com/Pylons-tech/pylons/x/epochs/types"
)

// BeginBlocker of epochs module
func BeginBlocker(ctx sdk.Context, k keeper.Keeper) {
	defer telemetry.ModuleMeasureSince(types.ModuleName, time.Now(), telemetry.MetricKeyBeginBlocker)
	k.IterateEpochInfo(ctx, func(index int64, epochInfo types.EpochInfo) (stop bool) {
		logger := k.Logger(ctx)

		// Has it not started, and is the block time > initial epoch start time
		shouldInitialEpochStart := !epochInfo.EpochCountingStarted && !epochInfo.StartTime.After(ctx.BlockTime())

		epochEndTime := epochInfo.CurrentEpochStartTime.Add(epochInfo.Duration)
		shouldEpochStart := ctx.BlockTime().After(epochEndTime) && !shouldInitialEpochStart && !epochInfo.StartTime.After(ctx.BlockTime())

		if shouldInitialEpochStart || shouldEpochStart {
			if shouldInitialEpochStart {
				epochInfo.EpochCountingStarted = true
				epochInfo.CurrentEpoch = 1
				epochInfo.CurrentEpochStartTime = epochInfo.StartTime
				logger.Info(fmt.Sprintf("Starting new epoch with identifier %s", epochInfo.Identifier))
			} else {
				epochInfo.CurrentEpoch++
				epochInfo.CurrentEpochStartTime = epochInfo.CurrentEpochStartTime.Add(epochInfo.Duration)
				logger.Info(fmt.Sprintf("Starting epoch with identifier %s", epochInfo.Identifier))
				err := ctx.EventManager().EmitTypedEvent(&types.EventEndEpoch{
					CurrentEpoch: epochInfo.CurrentEpoch,
				})
				if err != nil {
					panic(err)
				}
				k.AfterEpochEnd(ctx, epochInfo.Identifier, epochInfo.CurrentEpoch)
			}
			k.SetEpochInfo(ctx, epochInfo)
			err := ctx.EventManager().EmitTypedEvent(&types.EventBeginEpoch{
				CurrentEpoch: epochInfo.CurrentEpoch,
				StartTime:    epochInfo.CurrentEpochStartTime,
			})
			if err != nil {
				panic(err)
			}
			k.BeforeEpochStart(ctx, epochInfo.Identifier, epochInfo.CurrentEpoch)
		}

		return false
	})
}
