package simulation

// DONTCOVER

import (
	"math/rand"

	simtypes "github.com/cosmos/cosmos-sdk/types/simulation"
)

// ParamChanges defines the parameters that can be modified by param change proposals
// on the simulation
func ParamChanges(r *rand.Rand) []simtypes.ParamChange {
	/*
		return []simtypes.ParamChange{
			simulation.NewSimParamChange(v1beta1.ModuleName, string(v1beta1.ParamStoreKeyItemTransferFeePercentage),
				func(r *rand.Rand) string {

					return "TODO"
				},
			),
			simulation.NewSimParamChange(v1beta1.ModuleName, string(v1beta1.ParamStoreKeyMaxTransferFee),
				func(r *rand.Rand) string {

					return "TODO"
				},
			),
		}
	*/
	return []simtypes.ParamChange{} // TODO
}
