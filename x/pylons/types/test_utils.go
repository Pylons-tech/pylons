package types

import sdk "github.com/cosmos/cosmos-sdk/types"

func GenCoinInputList(name string, count int64) CoinInputList {
	return CoinInputList{
		CoinInput{
			Coin:  name,
			Count: count,
		},
	}
}

func GenItemInputList(name string) ItemInputList {
	return ItemInputList{
		ItemInput{
			DoubleInputParamList{DoubleInputParam{Key: "endurance",
				MinValue: "100.00",
				MaxValue: "500.00",
			}},
			LongInputParamList{LongInputParam{Key: "HP", MinValue: 100, MaxValue: 500}},
			StringInputParamList{StringInputParam{"Name", name}},
		},
	}
}

func GenCoinOnlyEntry(coinName string) WeightedParamList {
	return WeightedParamList{
		CoinOutput{
			Coin:   coinName,
			Count:  1,
			Weight: 1,
		},
	}
}

func GenItemOnlyEntry(itemName string) WeightedParamList {
	return WeightedParamList{
		ItemOutput{
			DoubleParamList{DoubleParam{Key: "endurance", DoubleWeightTable: DoubleWeightTable{WeightRanges: []DoubleWeightRange{
				DoubleWeightRange{
					Lower:  "100.00",
					Upper:  "500.00",
					Weight: 6,
				},
				DoubleWeightRange{
					Lower:  "501.00",
					Upper:  "800.00",
					Weight: 2,
				},
			}}, Rate: "1.0"}},
			LongParamList{LongParam{Key: "HP", IntWeightTable: IntWeightTable{WeightRanges: []IntWeightRange{
				IntWeightRange{
					Lower:  100,
					Upper:  500,
					Weight: 6,
				},
				IntWeightRange{
					Lower:  501,
					Upper:  800,
					Weight: 2,
				},
			}}}},
			StringParamList{StringParam{"Name", itemName, "1.0"}},
			1,
		},
	}
}

func GenEntries(coinName string, itemName string) WeightedParamList {
	return WeightedParamList{
		GenCoinOnlyEntry(coinName)[0],
		GenItemOnlyEntry(itemName)[0],
	}
}

// NewItem create a new item without auto generated ID
func NewItemWithGUID(GUID string, cookbookID string, doubles []DoubleKeyValue, longs []LongKeyValue, strings []StringKeyValue, sender sdk.AccAddress) *Item {
	// TODO if user send same GUID what to do? fail or random GUID generate internally?
	item := NewItem(cookbookID, doubles, longs, strings, sender)
	if len(GUID) == 0 {
		item.ID = item.KeyGen()
	} else {
		item.ID = GUID
	}
	return item
}

// NewCookbook return a new Cookbook
func NewCookbookWithGUID(GUID string, sEmail Email, sender sdk.AccAddress, version SemVer, name, description, developer string, cpb int) Cookbook {
	// TODO if user send same GUID what to do? fail or random GUID generate internally?
	cb := NewCookbook(sEmail, sender, version, name, description, developer, cpb)
	if len(GUID) == 0 {
		cb.ID = cb.KeyGen()
	} else {
		cb.ID = GUID
	}
	return cb
}

// NewRecipeWithGUID creates a new recipe with GUID
func NewRecipeWithGUID(GUID, recipeName, cookbookID, description string,
	coinInputs CoinInputList, // coinOutputs CoinOutputList,
	itemInputs ItemInputList, // itemOutputs ItemOutputList,
	entries WeightedParamList, // newly created param instead of coinOutputs and itemOutputs
	execTime int64, sender sdk.AccAddress) Recipe {
	// TODO if user send same GUID what to do? fail or random GUID generate internally?
	rcp := NewRecipe(recipeName, cookbookID, description, coinInputs, itemInputs, entries, execTime, sender)

	if len(GUID) == 0 {
		rcp.ID = rcp.KeyGen()
	} else {
		rcp.ID = GUID
	}
	return rcp
}

// NewExecutionWithGUID return a new Execution from GUID
func NewExecutionWithGUID(GUID string, rcpID string, cbID string, ci sdk.Coins,
	itemInputs []Item, entries WeightedParamList,
	blockHeight int64, sender sdk.AccAddress,
	completed bool) Execution {

	// TODO if user send same GUID what to do? fail or random GUID generate internally?
	exec := NewExecution(rcpID, cbID, ci, itemInputs, entries, blockHeight, sender, completed)
	if len(GUID) == 0 {
		exec.ID = exec.KeyGen()
	} else {
		exec.ID = GUID
	}
	return exec
}
