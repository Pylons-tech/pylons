package simulation

// DONTCOVER

import (
	"encoding/json"
	"fmt"
	"time"

	"github.com/cosmos/cosmos-sdk/types/module"

	"github.com/Pylons-tech/pylons/x/epochs/types"
)

// RandomizedGenState generates a random GenesisState for mint
func RandomizedGenState(simState *module.SimulationState) {
	epochs := []types.EpochInfo{
		{
			Identifier:            "twentyFourSeconds",
			StartTime:             time.Time{},
			Duration:              time.Second * 24,
			CurrentEpoch:          0,
			CurrentEpochStartTime: time.Time{},
			EpochCountingStarted:  false,
		},
		{
			Identifier:            "minute",
			StartTime:             time.Time{},
			Duration:              time.Minute,
			CurrentEpoch:          0,
			CurrentEpochStartTime: time.Time{},
			EpochCountingStarted:  false,
		},
	}
	epochGenesis := types.NewGenesisState(epochs)

	bz, err := json.MarshalIndent(&epochGenesis, "", " ")
	if err != nil {
		panic(err)
	}

	// TODO: Do some randomization later
	fmt.Printf("Selected deterministically generated epoch parameters:\n%s\n", bz)
	simState.GenState[types.ModuleName] = simState.Cdc.MustMarshalJSON(epochGenesis)
}
