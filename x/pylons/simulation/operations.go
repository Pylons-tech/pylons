package simulation

import (
	"math/rand"

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
	/* #nosec */
	OpWeightMsgCreateAcc = "op_weight_msg_create_acc"
	/* #nosec */
	OpWeightMsgUpdateAcc = "op_weight_msg_update_acc"
	/* #nosec */
	OpWeightMsgCreateCookbook = "op_weight_msg_create_cookbook"
	/* #nosec */
	OpWeightMsgCreateRecipe = "op_weight_msg_create_recipe"
	/* #nosec */
	OpWeightMsgExecuteRecipe = "op_weight_msg_execute_recipe"
	invalidField             = "invalid"
)

type recipeInfo struct {
	Address    string
	CookbookID string
	ID         string
}

var recipeInfoList []recipeInfo

// map from account address to objects they "own"
type pylonsSimState map[string]accountState

type accountState struct {
	CookbookIDs []string
	RecipeIDs   []string
	ItemIDs     []string
	TradeIDs    []string
}

// global stateMap map
var stateMap pylonsSimState

func init() {
	stateMap = make(pylonsSimState)
	recipeInfoList = make([]recipeInfo, 0)
}

// WeightedOperations returns all the operations from the module with their respective weights
func WeightedOperations(
	appParams simtypes.AppParams, cdc codec.JSONCodec, bk types.BankKeeper, k keeper.Keeper,
) simulation.WeightedOperations {
	var weightMsgCreateAcc int
	var weightMsgUpdateAcc int
	var weightMsgCreateCookbook int
	var weightMsgCreateRecipe int
	var weightMsgExecuteRecipe int

	appParams.GetOrGenerate(cdc, OpWeightMsgCreateAcc, &weightMsgCreateAcc, nil,
		func(_ *rand.Rand) {
			weightMsgCreateAcc = 100
		},
	)

	appParams.GetOrGenerate(cdc, OpWeightMsgUpdateAcc, &weightMsgUpdateAcc, nil,
		func(_ *rand.Rand) {
			weightMsgUpdateAcc = 100
		},
	)

	appParams.GetOrGenerate(cdc, OpWeightMsgCreateCookbook, &weightMsgCreateCookbook, nil,
		func(_ *rand.Rand) {
			weightMsgCreateCookbook = 100
		},
	)

	appParams.GetOrGenerate(cdc, OpWeightMsgCreateRecipe, &weightMsgCreateRecipe, nil,
		func(_ *rand.Rand) {
			weightMsgCreateRecipe = 100
		},
	)

	appParams.GetOrGenerate(cdc, OpWeightMsgExecuteRecipe, &weightMsgExecuteRecipe, nil,
		func(_ *rand.Rand) {
			weightMsgExecuteRecipe = 100
		},
	)

	return simulation.WeightedOperations{
		simulation.NewWeightedOperation(
			weightMsgCreateAcc,
			SimulateCreateAccount(bk, k),
		),
		simulation.NewWeightedOperation(
			weightMsgUpdateAcc,
			SimulateUpdateAccount(bk, k),
		),
		simulation.NewWeightedOperation(
			weightMsgCreateCookbook,
			SimulateCreateCookbook(bk, k),
		),
		simulation.NewWeightedOperation(
			weightMsgCreateRecipe,
			SimulateCreateRecipe(bk, k),
		),
		simulation.NewWeightedOperation(
			weightMsgExecuteRecipe,
			SimulateExecuteRecipe(bk, k),
		),
	}
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
				types.ModuleName, msgType, "Account has no balance"), nil, nil
		}

		// initialize stateMap struct for this address
		stateMap[simAccount.Address.String()] = accountState{
			CookbookIDs: make([]string, 0),
			RecipeIDs:   make([]string, 0),
			TradeIDs:    make([]string, 0),
			ItemIDs:     make([]string, 0),
		}

		username := generateRandomUsername(r)

		msg := types.NewMsgCreateAccount(
			simAccount.Address.String(),
			username, "")

		return simtypes.NewOperationMsg(msg, true, "TODO", nil), nil, nil
	}
}

// SimulateUpdateAccount generates a MsgUpdateAccount with random values
func SimulateUpdateAccount(bk types.BankKeeper, k keeper.Keeper) simtypes.Operation {
	return func(
		r *rand.Rand, app *baseapp.BaseApp, ctx sdk.Context,
		accs []simtypes.Account, chainID string,
	) (simtypes.OperationMsg, []simtypes.FutureOperation, error) {
		simAccount, _ := simtypes.RandomAcc(r, accs)
		simCoins := bk.SpendableCoins(ctx, simAccount.Address)
		msgType := (&types.MsgCreateAccount{}).Type()

		if simCoins.Len() <= 0 {
			return simtypes.NoOpMsg(
				types.ModuleName, msgType, "Account has no balance"), nil, nil
		}

		username := generateRandomUsername(r)

		msg := types.NewMsgCreateAccount(
			simAccount.Address.String(),
			username, "")

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
				types.ModuleName, msgType, "Account has no balance"), nil, nil
		}

		id := generateRandomStringID(r)
		email := generateRandomEmail(r)

		// add cookbook id to global stateMap store
		accState := stateMap[simAccount.Address.String()]
		accState.CookbookIDs = append(accState.CookbookIDs, id)
		stateMap[simAccount.Address.String()] = accState

		msg := &types.MsgCreateCookbook{
			Creator:      simAccount.Address.String(),
			Id:           id,
			Name:         "namenamenamenamename",
			Description:  "descriptiondescriptiondescription",
			Developer:    "developer",
			Version:      "v0.0.1",
			SupportEmail: email,
			Enabled:      true,
		}
		return simtypes.NewOperationMsg(msg, true, "TODO", nil), nil, nil
	}
}

// SimulateCreateRecipe generates a MsgCreateRecipe with random values
func SimulateCreateRecipe(bk types.BankKeeper, k keeper.Keeper) simtypes.Operation {
	return func(
		r *rand.Rand, app *baseapp.BaseApp, ctx sdk.Context,
		accs []simtypes.Account, chainID string,
	) (simtypes.OperationMsg, []simtypes.FutureOperation, error) {
		simAccount, _ := simtypes.RandomAcc(r, accs)
		simCoins := bk.SpendableCoins(ctx, simAccount.Address)
		msgType := (&types.MsgCreateRecipe{}).Type()

		if simCoins.Len() <= 0 {
			return simtypes.NoOpMsg(
				types.ModuleName, msgType, "Account has no balance"), nil, nil
		}

		id := generateRandomStringID(r)

		// add cookbook id to global stateMap store
		cookbookID := ""
		accState := stateMap[simAccount.Address.String()]
		if len(accState.CookbookIDs) > 0 {
			cookbookID = accState.CookbookIDs[0]
			accState.RecipeIDs = append(accState.RecipeIDs, id)
			stateMap[simAccount.Address.String()] = accState

			info := recipeInfo{
				Address:    simAccount.Address.String(),
				CookbookID: accState.CookbookIDs[0],
				ID:         id,
			}
			recipeInfoList = append(recipeInfoList, info)
		}

		msg := &types.MsgCreateRecipe{
			Creator:       simAccount.Address.String(),
			CookbookId:    cookbookID,
			Id:            id,
			Name:          "namenamenamenamenamename",
			Description:   "descriptiondescriptiondescription",
			Version:       "v0.0.1",
			CoinInputs:    nil,
			ItemInputs:    nil,
			Entries:       types.EntriesList{},
			Outputs:       nil,
			BlockInterval: 0,
			CostPerBlock:  sdk.Coin{},
			Enabled:       true,
			ExtraInfo:     "",
		}
		return simtypes.NewOperationMsg(msg, true, "TODO", nil), nil, nil
	}
}

// SimulateExecuteRecipe generates a MsgExecuteRecipe with random values
func SimulateExecuteRecipe(bk types.BankKeeper, k keeper.Keeper) simtypes.Operation {
	return func(
		r *rand.Rand, app *baseapp.BaseApp, ctx sdk.Context,
		accs []simtypes.Account, chainID string,
	) (simtypes.OperationMsg, []simtypes.FutureOperation, error) {
		simAccount, _ := simtypes.RandomAcc(r, accs)
		simCoins := bk.SpendableCoins(ctx, simAccount.Address)
		msgType := (&types.MsgExecuteRecipe{}).Type()

		if simCoins.Len() <= 0 {
			return simtypes.NoOpMsg(
				types.ModuleName, msgType, "Account has no balance"), nil, nil
		}

		// add cookbook id to global stateMap store
		cookbookID := ""
		recipeID := ""

		// find use a recipe created by any account
		if len(recipeInfoList) > 0 {
			index := int(r.Int31n(int32(len(recipeInfoList))))
			info := recipeInfoList[index]
			cookbookID = info.CookbookID
			recipeID = info.ID
		}

		msg := &types.MsgExecuteRecipe{
			Creator:         simAccount.Address.String(),
			CookbookId:      cookbookID,
			RecipeId:        recipeID,
			CoinInputsIndex: 0,
			ItemIds:         nil,
		}

		return simtypes.NewOperationMsg(msg, true, "TODO", nil), nil, nil
	}
}
