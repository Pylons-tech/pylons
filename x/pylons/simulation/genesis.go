package simulation

// DONTCOVER

import (
	"encoding/json"
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/module"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// RandomizedGenState generates a random GenesisState for bank
func RandomizedGenState(simState *module.SimulationState) {
	// TODO add logic for randomizing state

	genesis := types.GenesisState{
		EntityCount: 0,
		Params: types.Params{
			MinNameFieldLength:        0,
			MinDescriptionFieldLength: 0,
			CoinIssuers:               nil,
			RecipeFeePercentage:       sdk.Dec{},
			ItemTransferFeePercentage: sdk.Dec{},
			UpdateItemStringFee:       sdk.Coin{},
			MinTransferFee:            sdk.Int{},
			MaxTransferFee:            sdk.Int{},
		},
		GoogleInAppPurchaseOrderList: nil,
		GoogleIAPOrderCount:          0,
		ExecutionList:                nil,
		ExecutionCount:               0,
		PendingExecutionList:         nil,
		PendingExecutionCount:        0,
		ItemList:                     nil,
		RecipeList:                   nil,
		CookbookList:                 nil,
	}

	paramsBytes, err := json.MarshalIndent(&genesis.Params, "", " ")
	if err != nil {
		panic(err)
	}
	fmt.Printf("Selected randomly generated bank parameters:\n%s\n", paramsBytes)
	simState.GenState[types.ModuleName] = simState.Cdc.MustMarshalJSON(&genesis)
}
