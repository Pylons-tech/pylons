package simulation

import (
	"math/rand"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"

	"github.com/cosmos/cosmos-sdk/baseapp"
	"github.com/cosmos/cosmos-sdk/codec"
	simappparams "github.com/cosmos/cosmos-sdk/simapp/params"
	sdk "github.com/cosmos/cosmos-sdk/types"
	simtypes "github.com/cosmos/cosmos-sdk/types/simulation"

	"github.com/cosmos/cosmos-sdk/x/simulation"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// Simulation operation weights constants
const (
	OpWeightMsgSend      = "op_weight_msg_send"
	OpWeightMsgMultiSend = "op_weight_msg_multisend"
)

// WeightedOperations returns all the operations from the module with their respective weights
func WeightedOperations(
	appParams simtypes.AppParams, cdc codec.JSONMarshaler, k keeper.Keeper,
) simulation.WeightedOperations {

	var weightMsgSend int
	appParams.GetOrGenerate(cdc, OpWeightMsgSend, &weightMsgSend, nil,
		func(_ *rand.Rand) {
			weightMsgSend = simappparams.DefaultWeightMsgSend
		},
	)

	return simulation.WeightedOperations{
		simulation.NewWeightedOperation(
			weightMsgSend,
			SimulateOp(k),
		),
	}
}

// SimulateOp needs to be finished
func SimulateOp(k keeper.Keeper) simtypes.Operation {
	return func(
		r *rand.Rand, app *baseapp.BaseApp, ctx sdk.Context,
		accs []simtypes.Account, chainID string,
	) (simtypes.OperationMsg, []simtypes.FutureOperation, error) {

		msg := types.NewMsgCreateAccount("TODO")

		return simtypes.NewOperationMsg(msg, true, "TODO"), nil, nil
	}
}
