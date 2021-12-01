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
	OpWeightMsgCreateAcc              = "op_weight_msg_create_acc"
	OpWeightMsgUpdateAcc              = "op_weight_msg_update_acc"
	OpWeightMsgCreateCookbook         = "op_weight_msg_create_cookbook"
	OpWeightMsgCreateRecipe           = "op_weight_msg_create_recipe"
	OpWeightMsgUpdateCookbook         = "op_weight_msg_update_cookbook"   // TODO
	OpWeightMsgTransferCookbook       = "op_weight_msg_transfer_cookbook" // TODO
	OpWeightMsgUpdateRecipe           = "op_weight_msg_update_recipe"     // TODO
	OpWeightMsgExecuteRecipe          = "op_weight_msg_execute_recipe"
	OpWeightMsgCompleteExecutionEarly = "op_weight_msg_complete_execution_early" // TODO
	OpWeightMsgCreateTrade            = "op_weight_msg_create_trade"             // TODO
	OpWeightMsgCancelTrade            = "op_weight_msg_cancel_trade"             // TODO
	OpWeightMsgFulfillTrade           = "op_weight_msg_fulfill_trade"            // TODO
	OpWeightMsgSendItems              = "op_weight_msg_send_items"
	OpWeightMsgSetItemString          = "op_weight_msg_set_item_string"          // TODO

	invalidField = "invalid"
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
	ItemRefs     []types.ItemRef
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
	var weightMsgCreateTrade int
	var weightMsgCancelTrade int
	var weightMsgSendItems int
	var weightMsgSetItemString int

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

	appParams.GetOrGenerate(cdc, OpWeightMsgCreateTrade, &weightMsgCreateTrade, nil,
		func(_ *rand.Rand) {
			weightMsgCreateTrade = 100
		},
	)

	appParams.GetOrGenerate(cdc, OpWeightMsgCancelTrade, &weightMsgCancelTrade, nil,
		func(_ *rand.Rand) {
			weightMsgCancelTrade = 100
		},
	)

	appParams.GetOrGenerate(cdc, OpWeightMsgSendItems, &weightMsgSendItems, nil,
		func(_ *rand.Rand) {
			weightMsgSendItems = 100
		},
	)

	appParams.GetOrGenerate(cdc, OpWeightMsgSetItemString, &weightMsgSetItemString, nil,
		func(_ *rand.Rand) {
			weightMsgSetItemString = 100
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
		simulation.NewWeightedOperation(
			weightMsgCreateTrade,
			SimulateCreateTrade(bk, k),
		),
		simulation.NewWeightedOperation(
			weightMsgCancelTrade,
			SimulateCancelTrade(bk, k),
		),
		simulation.NewWeightedOperation(
			weightMsgSendItems,
			SimulateSendItems(bk, k),
		),
		simulation.NewWeightedOperation(
			weightMsgSetItemString,
			SimulateSetItemString(bk, k),
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
			ItemRefs:    make([]types.ItemRef, 0),
		}

		username := generateRandomUsername(r)

		msg := types.NewMsgCreateAccount(
			simAccount.Address.String(),
			username)

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

		msg := types.NewMsgUpdateAccount(
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
			ID:           id,
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
			CookbookID:    cookbookID,
			ID:            id,
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
			CookbookID:      cookbookID,
			RecipeID:        recipeID,
			CoinInputsIndex: 0,
			ItemIDs:         nil,
		}

		return simtypes.NewOperationMsg(msg, true, "TODO", nil), nil, nil
	}
}


// SimulateCreateTrade generates a MsgCreateTrade with random values
func SimulateCreateTrade(bk types.BankKeeper, k keeper.Keeper) simtypes.Operation {
	return func(
		r *rand.Rand, app *baseapp.BaseApp, ctx sdk.Context,
		accs []simtypes.Account, chainID string,
	) (simtypes.OperationMsg, []simtypes.FutureOperation, error) {

		simAccount, _ := simtypes.RandomAcc(r, accs)
		simCoins := bk.SpendableCoins(ctx, simAccount.Address)
		msgType := (&types.MsgCreateTrade{}).Type()

		if simCoins.Len() <= 0 {
			return simtypes.NoOpMsg(
				types.ModuleName, msgType, "Account has no balance"), nil, nil
		}

		// add trade id to global stateMap store
		// accState := stateMap[simAccount.Address.String()]
		// accState.CookbookIDs = append(accState.TradeIDs, id)
		// stateMap[simAccount.Address.String()] = accState

		coinInputs := make([]types.CoinInput, 0)
		itemInputs := make([]types.ItemInput, 0)
		coinOutputs := sdk.Coins{}
		itemOutputs := make([]types.ItemRef, 0)
		extraInfo := "extraInfo"

		msg := &types.MsgCreateTrade{
			Creator:     simAccount.Address.String(),
			CoinInputs:  coinInputs,
			ItemInputs:  itemInputs,
			CoinOutputs: coinOutputs,
			ItemOutputs: itemOutputs,
			ExtraInfo:   extraInfo,
		}

		return simtypes.NewOperationMsg(msg, true, "TODO", nil), nil, nil
	}
}

// SimulateCancelTrade generates a MsgCancelTrade with random values
func SimulateCancelTrade(bk types.BankKeeper, k keeper.Keeper) simtypes.Operation {
	return func(
		r *rand.Rand, app *baseapp.BaseApp, ctx sdk.Context,
		accs []simtypes.Account, chainID string,
	) (simtypes.OperationMsg, []simtypes.FutureOperation, error) {

		simAccount, _ := simtypes.RandomAcc(r, accs)
		simCoins := bk.SpendableCoins(ctx, simAccount.Address)
		msgType := (&types.MsgCancelTrade{}).Type()

		if simCoins.Len() <= 0 {
			return simtypes.NoOpMsg(
				types.ModuleName, msgType, "Account has no balance"), nil, nil
		}

		id := generateRandomUint64(r)

		// remove trade id to global stateMap store
		// accState := stateMap[simAccount.Address.String()]
		// accState.CookbookIDs = append(accState.CookbookIDs, id)
		// stateMap[simAccount.Address.String()] = accState

		msg := &types.MsgCancelTrade{
			ID:      id,
			Creator: simAccount.Address.String(),
		}
		return simtypes.NewOperationMsg(msg, true, "TODO", nil), nil, nil
	}
}

// SimulateSendItems generates a MsgSendItems with random values
func SimulateSendItems(bk types.BankKeeper, k keeper.Keeper) simtypes.Operation {
	return func(
		r *rand.Rand, app *baseapp.BaseApp, ctx sdk.Context,
		accs []simtypes.Account, chainID string,
	) (simtypes.OperationMsg, []simtypes.FutureOperation, error) {

		simAccount, _ := simtypes.RandomAcc(r, accs)
		toAccount, _ := simtypes.RandomAcc(r, accs)
		simCoins := bk.SpendableCoins(ctx, simAccount.Address)
		msgType := (&types.MsgCancelTrade{}).Type()

		if simCoins.Len() <= 0 {
			return simtypes.NoOpMsg(
				types.ModuleName, msgType, "Account has no balance"), nil, nil
		}

		// add cookbook id to global stateMap store
		items := make([]types.ItemRef, 0)
		accState := stateMap[simAccount.Address.String()]
		if len(accState.ItemRefs) > 0 {
			items = accState.ItemRefs
		}

		msg := &types.MsgSendItems{
			Creator:  simAccount.Address.String(),
			Receiver: toAccount.Address.String(),
			Items:    items,
		}
		return simtypes.NewOperationMsg(msg, true, "TODO", nil), nil, nil
	}
}

// SimulateSetItemString generates a MsgSetItemString with random values
func SimulateSetItemString(bk types.BankKeeper, k keeper.Keeper) simtypes.Operation {
	return func(
		r *rand.Rand, app *baseapp.BaseApp, ctx sdk.Context,
		accs []simtypes.Account, chainID string,
	) (simtypes.OperationMsg, []simtypes.FutureOperation, error) {

		simAccount, _ := simtypes.RandomAcc(r, accs)
		simCoins := bk.SpendableCoins(ctx, simAccount.Address)
		msgType := (&types.MsgCancelTrade{}).Type()

		if simCoins.Len() <= 0 {
			return simtypes.NoOpMsg(
				types.ModuleName, msgType, "Account has no balance"), nil, nil
		}

		// add cookbook id to global stateMap store
		item := types.ItemRef{
			CookbookID: "",
			ItemID: "",
		}
		accState := stateMap[simAccount.Address.String()]
		if len(accState.ItemRefs) > 0 {
			item = accState.ItemRefs[0]
		}

		// TODO
		msg := &types.MsgSetItemString{
			Creator:    simAccount.Address.String(),
			CookbookID: item.CookbookID,
			ID:         item.ItemID,
			Field:      "test",
			Value:      "test",
		}
		return simtypes.NewOperationMsg(msg, true, "TODO", nil), nil, nil
	}
}
