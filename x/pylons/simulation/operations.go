package simulation

import (
	"math/rand"

	regen "github.com/zach-klippenstein/goregen"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"

	"github.com/cosmos/cosmos-sdk/baseapp"
	"github.com/cosmos/cosmos-sdk/codec"
	sdk "github.com/cosmos/cosmos-sdk/types"
	simtypes "github.com/cosmos/cosmos-sdk/types/simulation"

	"github.com/cosmos/cosmos-sdk/x/simulation"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// Simulation operation weights constants
const (
	OpWeightMsgCreatAcc       = "op_weight_msg_create_acc"
	OpWeightMsgCreateCookbook = "op_weight_msg_create_cookbook"
	invalidField              = "invalid"
)

// WeightedOperations returns all the operations from the module with their respective weights
func WeightedOperations(
	appParams simtypes.AppParams, cdc codec.JSONCodec, bk types.BankKeeper, k keeper.Keeper,
) simulation.WeightedOperations {

	var weightMsgCreateAcc int
	var weightMsgCreateCookbook int
	appParams.GetOrGenerate(cdc, OpWeightMsgCreatAcc, &weightMsgCreateAcc, nil,
		func(_ *rand.Rand) {
			weightMsgCreateAcc = 100
		},
	)

	appParams.GetOrGenerate(cdc, OpWeightMsgCreateCookbook, &weightMsgCreateCookbook, nil,
		func(_ *rand.Rand) {
			weightMsgCreateCookbook = 100
		},
	)

	return simulation.WeightedOperations{
		simulation.NewWeightedOperation(
			weightMsgCreateAcc,
			SimulateCreateAccount(bk, k),
		),
		simulation.NewWeightedOperation(
			weightMsgCreateCookbook,
			SimulateCreateCookbook(bk, k),
		),
	}
}

func generateRandomUsername(r *rand.Rand) (ret string) {
	if r.Int63n(100) > 9 {
		ret, _ = regen.Generate("^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$")
	} else {
		ret = invalidField
	}
	return
}

func generateRandomStringID(r *rand.Rand) (ret string) {
	if r.Int63n(100) > 9 {
		ret, _ = regen.Generate("^[a-zA-Z_][a-zA-Z_0-9]*$")
	} else {
		ret = invalidField
	}
	return
}

func generateRandomEmail(r *rand.Rand) (ret string) {
	if r.Int63n(100) > 9 {
		ret, _ = regen.Generate("^([a-zA-Z0-9_\\-.]+)@([a-zA-Z0-9_\\-.]+)\\.([a-zA-Z0-9]{2,})$")
	} else {
		ret = invalidField
	}
	return
}

// SimulateCreateAccount generates a MsgCreateAccount with random values
func SimulateCreateAccount(bk types.BankKeeper, k keeper.Keeper) simtypes.Operation {
	return func(
		r *rand.Rand, app *baseapp.BaseApp, ctx sdk.Context,
		accs []simtypes.Account, chainID string,
	) (simtypes.OperationMsg, []simtypes.FutureOperation, error) {

		simAccount, _ := simtypes.RandomAcc(r, accs)
		simCoins := bk.SpendableCoins(ctx, simAccount.Address)
		msgType := (&types.MsgCreateAccount{}).Type()

		if simCoins.Len() <= 0 {
			return simtypes.NoOpMsg(
				types.ModuleName, msgType, "Account have no coin"), nil, nil
		}

		username := generateRandomUsername(r)

		msg := types.NewMsgCreateAccount(
			simAccount.Address.String(),
			username)

		return simtypes.NewOperationMsg(msg, true, "TODO", nil), nil, nil
	}
}

// SimulateCreateCookbook generates a MsgCreateCookbook with random values
func SimulateCreateCookbook(bk types.BankKeeper, k keeper.Keeper) simtypes.Operation {
	return func(
		r *rand.Rand, app *baseapp.BaseApp, ctx sdk.Context,
		accs []simtypes.Account, chainID string,
	) (simtypes.OperationMsg, []simtypes.FutureOperation, error) {

		simAccount, _ := simtypes.RandomAcc(r, accs)
		simCoins := bk.SpendableCoins(ctx, simAccount.Address)
		msgType := (&types.MsgCreateCookbook{}).Type()

		if simCoins.Len() <= 0 {
			return simtypes.NoOpMsg(
				types.ModuleName, msgType, "Account have no coin"), nil, nil
		}

		id := generateRandomStringID(r)
		email := generateRandomEmail(r)

		msg := &types.MsgCreateCookbook{
			Creator:      simAccount.Address.String(),
			ID:           id,
			Name:         "namenamenamenamename",
			Description:  "descriptiondescriptiondescription",
			Developer:    "developer",
			Version:      "v0.0.1",
			SupportEmail: email,
			CostPerBlock: sdk.Coin{},
			Enabled:      true,
		}
		return simtypes.NewOperationMsg(msg, true, "TODO", nil), nil, nil
	}
}
