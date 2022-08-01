package simulation

// DONTCOVER

import (
	"encoding/json"
	"fmt"
	"math/rand"

	"cosmossdk.io/math"
	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/module"
)

// cookbook -> recipe -> execution -> item

func randomPercentage(r *rand.Rand) sdk.Dec {
	percent := r.Int63n(101) // range [1 - 100]
	dec := sdk.NewDec(percent)
	return dec.Quo(sdk.NewDec(100))
}

func randomCoinFee(r *rand.Rand) sdk.Coin {
	return sdk.NewCoin("upylon", sdk.NewInt(r.Int63n(10)+1)) // [1, 100]
}

func randomTransferFeePair(r *rand.Rand) (math.Int, math.Int) {
	min := sdk.NewInt(r.Int63n(11))              // [0, 10]
	max := sdk.NewInt(r.Int63n(10) + 1).Add(min) // [min, min + 10]
	return min, max
}

// RandomizedGenState generates a random GenesisState for bank
func RandomizedGenState(simState *module.SimulationState) {
	// TODO add logic for randomizing stateMap
	var recipeFeePercentage sdk.Dec
	simState.AppParams.GetOrGenerate(
		simState.Cdc, string(v1beta1.ParamStoreKeyRecipeFeePercentage),
		&recipeFeePercentage, simState.Rand,
		func(r *rand.Rand) { recipeFeePercentage = randomPercentage(r) })

	var itemTransferFeePercentage sdk.Dec
	simState.AppParams.GetOrGenerate(
		simState.Cdc, string(v1beta1.ParamStoreKeyItemTransferFeePercentage),
		&itemTransferFeePercentage, simState.Rand,
		func(r *rand.Rand) { itemTransferFeePercentage = randomPercentage(r) })

	var updateItemStringFee sdk.Coin
	simState.AppParams.GetOrGenerate(
		simState.Cdc, string(v1beta1.ParamStoreKeyUpdateItemStringFee),
		&updateItemStringFee, simState.Rand,
		func(r *rand.Rand) { updateItemStringFee = randomCoinFee(r) })

	var updateUsernameFee sdk.Coin
	simState.AppParams.GetOrGenerate(
		simState.Cdc, string(v1beta1.ParamStoreKeyUpdateUsernameFee),
		&updateUsernameFee, simState.Rand,
		func(r *rand.Rand) { updateUsernameFee = randomCoinFee(r) })

	minTransferFee, maxTransferFee := randomTransferFeePair(simState.Rand)

	genesis := v1beta1.GenesisState{
		Params: v1beta1.Params{
			CoinIssuers:               v1beta1.DefaultCoinIssuers, // set as default for simplicity
			RecipeFeePercentage:       recipeFeePercentage,
			ItemTransferFeePercentage: itemTransferFeePercentage,
			UpdateItemStringFee:       updateItemStringFee,
			UpdateUsernameFee:         updateUsernameFee,
			MinTransferFee:            minTransferFee,
			MaxTransferFee:            maxTransferFee,
			DistrEpochIdentifier:      "hour",
			MaxTxsInBlock:             uint64(1000),
		},
		EntityCount:                  0,
		GoogleInAppPurchaseOrderList: nil,
		GoogleIapOrderCount:          0,
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
	simState.GenState[v1beta1.ModuleName] = simState.Cdc.MustMarshalJSON(&genesis)
}
