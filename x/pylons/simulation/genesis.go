package simulation

// DONTCOVER

import (
	"encoding/json"
	"fmt"
	"math/rand"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/module"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// cookbook -> recipe -> execution -> item

func randomLengthField(r *rand.Rand) uint64 {
	return uint64(r.Int63n(101) + 10) // range [10 - 110]
}

func randomPercentage(r *rand.Rand) sdk.Dec {
	percent := r.Int63n(101) + 1 // range [1 - 100]
	return sdk.NewDec(percent)
}

func randomCoinFee(r *rand.Rand) sdk.Coin {
	return sdk.NewCoin("upylon", sdk.NewInt(r.Int63n(10)+1)) // [1, 100]
}

func randomTransferFeePair() (sdk.Int, sdk.Int) {
	min := sdk.NewInt(rand.Int63n(11))              // [0, 10]
	max := sdk.NewInt(rand.Int63n(10) + 1).Add(min) // [min, min + 10]
	return min, max
}

// RandomizedGenState generates a random GenesisState for bank
func RandomizedGenState(simState *module.SimulationState) {
	// TODO add logic for randomizing state
	var minNameFieldLength uint64
	simState.AppParams.GetOrGenerate(
		simState.Cdc, string(types.ParamStoreKeyMinNameFieldLength),
		&minNameFieldLength, simState.Rand,
		func(r *rand.Rand) { minNameFieldLength = randomLengthField(r) })

	var minDescriptionFieldLength uint64
	simState.AppParams.GetOrGenerate(
		simState.Cdc, string(types.ParamStoreKeyMinDescriptionFieldLength),
		&minDescriptionFieldLength, simState.Rand,
		func(r *rand.Rand) { minDescriptionFieldLength = randomLengthField(r) })

	var recipeFeePercentage sdk.Dec
	simState.AppParams.GetOrGenerate(
		simState.Cdc, string(types.ParamStoreKeyRecipeFeePercentage),
		&recipeFeePercentage, simState.Rand,
		func(r *rand.Rand) { recipeFeePercentage = randomPercentage(r) })

	var itemTransferFeePercentage sdk.Dec
	simState.AppParams.GetOrGenerate(
		simState.Cdc, string(types.ParamStoreKeyItemTransferFeePercentage),
		&itemTransferFeePercentage, simState.Rand,
		func(r *rand.Rand) { itemTransferFeePercentage = randomPercentage(r) })

	var updateItemStringFee sdk.Coin
	simState.AppParams.GetOrGenerate(
		simState.Cdc, string(types.ParamStoreKeyUpdateItemStringFee),
		&updateItemStringFee, simState.Rand,
		func(r *rand.Rand) { updateItemStringFee = randomCoinFee(r) })

	var updateUsernameFee sdk.Coin
	simState.AppParams.GetOrGenerate(
		simState.Cdc, string(types.ParamStoreKeyUpdateUsernameFee),
		&updateUsernameFee, simState.Rand,
		func(r *rand.Rand) { updateUsernameFee = randomCoinFee(r) })

	minTransferFee, maxTransferFee := randomTransferFeePair()

	genesis := types.GenesisState{
		Params: types.Params{
			MinNameFieldLength:        minNameFieldLength,
			MinDescriptionFieldLength: minDescriptionFieldLength,
			CoinIssuers:               types.DefaultCoinIssuers, // set as default for simplicity
			RecipeFeePercentage:       recipeFeePercentage,
			ItemTransferFeePercentage: itemTransferFeePercentage,
			UpdateItemStringFee:       updateItemStringFee,
			UpdateUsernameFee:         updateUsernameFee,
			MinTransferFee:            minTransferFee,
			MaxTransferFee:            maxTransferFee,
		},
		EntityCount:                  0,
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
