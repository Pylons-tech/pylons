package types

import sdk "github.com/cosmos/cosmos-sdk/types"

// GenCoinInputList is a utility function to genearte coin input list
func GenCoinInputList(name string, count int64) CoinInputList {
	return CoinInputList{
		{
			Coin:  name,
			Count: count,
		},
	}
}

// GenItemInputList is a utility function to genearte item input list
func GenItemInputList(names ...string) ItemInputList {
	iiL := ItemInputList{}
	for _, name := range names {
		iiL = append(iiL, ItemInput{
			name,
			DoubleInputParamList{},
			LongInputParamList{},
			StringInputParamList{{"Name", name}},
			FeeInputParam{
				MinValue: 0,
				MaxValue: 10000,
			},
			ConditionList{},
		})
	}
	return iiL
}

// GenTradeItemInputList is a utility function to generate trade item input list
func GenTradeItemInputList(cookbookID string, itemNames []string) TradeItemInputList {
	tiiL := TradeItemInputList{}
	iiL := GenItemInputList(itemNames...)
	for _, ii := range iiL {
		tiiL = append(tiiL, TradeItemInput{
			ii,
			cookbookID,
		})
	}
	return tiiL
}

// GenCoinOnlyEntry is a utility function to genearte coin only entry
func GenCoinOnlyEntry(coinName string) CoinOutput {
	return CoinOutput{
		ID:    coinName,
		Coin:  coinName,
		Count: "1",
	}
}

// GenCoinOnlyEntryRand is a utility function to genearte coin only entry with random count
func GenCoinOnlyEntryRand(ID string, coinName string) CoinOutput {
	return CoinOutput{
		ID:    ID,
		Coin:  coinName,
		Count: `rand(10)+1`,
	}
}

// GenItemNameUpgradeParams is a utility function to generate item name upgrade
func GenItemNameUpgradeParams(desItemName string) ItemModifyParams {
	return ItemModifyParams{
		Doubles: DoubleParamList{},
		Longs:   LongParamList{},
		Strings: StringParamList{
			{
				Key:   "Name",
				Value: desItemName,
			},
		},
	}
}

// GenItemOnlyEntry is a utility function to generate item only entry
func GenItemOnlyEntry(itemName string) ItemOutput {
	item := NewItemOutput(
		itemName,
		DoubleParamList{{Key: "endurance", WeightTable: DoubleWeightTable{WeightRanges: []DoubleWeightRange{
			{
				Lower:  sdk.NewDec(100.00),
				Upper:  sdk.NewDec(500.00),
				Weight: 6,
			},
			{
				Lower:  sdk.NewDec(501.00),
				Upper:  sdk.NewDec(800.00),
				Weight: 2,
			},
		}}, Rate: sdk.NewDec(1.0)}},
		LongParamList{{
			Key:  "HP",
			Rate: sdk.NewDec(1),
			WeightTable: IntWeightTable{WeightRanges: []IntWeightRange{
				{
					Lower:  100,
					Upper:  500,
					Weight: 6,
				},
				{
					Lower:  501,
					Upper:  800,
					Weight: 2,
				},
			}},
		}},
		StringParamList{{Key: "Name", Value: itemName, Rate: sdk.NewDec(1.0), Program: ""}},
		1232,
	)
	return item
}

// GenItemOnlyEntryRand is a function to generate item only entry with random value
func GenItemOnlyEntryRand(ID string, itemName string) ItemOutput {
	return NewItemOutput(
		ID,
		DoubleParamList{{
			Key:     "endurance",
			Program: `500.00`,
			Rate:    sdk.NewDec(1.0),
		}},
		LongParamList{{
			Key:     "HP",
			Program: `500 + rand(300)`,
			Rate:    sdk.NewDec(1.0),
		}},
		StringParamList{{Key: "Name", Value: itemName, Rate: sdk.NewDec(1.0), Program: ""}},
		0,
	)
}

// GenOneOutput is a function to generate output with one from entry list
func GenOneOutput(entryIDs ...string) WeightedOutputsList {
	wol := WeightedOutputsList{}
	for i := 0; i < len(entryIDs); i++ {
		wol = append(wol, WeightedOutputs{
			EntryIDs: []string{entryIDs[i]},
			Weight:   "1",
		})
	}
	return wol
}

// GenAllOutput is a function to generate output with all of entry list
func GenAllOutput(entryIDs ...string) WeightedOutputsList {
	wol := WeightedOutputsList{{
		EntryIDs: entryIDs,
		Weight:   "1",
	}}
	return wol
}

// GenEntries is a function to generate entries from coin name and item name
func GenEntries(coinName string, itemName string) EntriesList {
	return EntriesList{
		CoinOutputs: []CoinOutput{GenCoinOnlyEntry(coinName)},
		ItemOutputs: []ItemOutput{GenItemOnlyEntry(itemName)},
	}
}

// GenEntriesRand is a function to generate entreis from coin name and item name and which has random attributes
func GenEntriesRand(coinName, itemName string) EntriesList {
	return EntriesList{
		CoinOutputs: []CoinOutput{GenCoinOnlyEntryRand(coinName, coinName)},
		ItemOutputs: []ItemOutput{GenItemOnlyEntryRand(itemName, itemName)},
	}
}

// GenEntriesItemNameUpgrade is a function to generate entries that update first item's name
func GenEntriesItemNameUpgrade(inputRef, targetValue string) EntriesList {
	item := NewItemModifyOutput(
		targetValue, inputRef, GenModifyParamsForString("Name", targetValue),
	)
	var t EntriesList
	t.ItemModifyOutputs = append(t.ItemModifyOutputs, item)
	return t
}

// GenEntriesTwoItemNameUpgrade is a function to generate entries that update two items' names
func GenEntriesTwoItemNameUpgrade(inputRef1, targetValue1, inputRef2, targetValue2 string) EntriesList {
	item1 := NewItemModifyOutput(
		targetValue1, inputRef1, GenModifyParamsForString("Name", targetValue1),
	)
	item2 := NewItemModifyOutput(
		targetValue2, inputRef2, GenModifyParamsForString("Name", targetValue2),
	)
	var t EntriesList
	t.ItemModifyOutputs = append(t.ItemModifyOutputs, item1)
	t.ItemModifyOutputs = append(t.ItemModifyOutputs, item2)
	return t
}

// GenModifyParamsForString is a function to generate modify params from string key and value
func GenModifyParamsForString(targetKey, targetValue string) ItemModifyParams {
	return ItemModifyParams{
		Strings: StringParamList{
			{Key: targetKey, Value: targetValue},
		},
	}
}

// GenModifyParamsForLong is a function to generate modify params from long key and value
func GenModifyParamsForLong(targetKey string, upgradeAmount int) ItemModifyParams {
	return ItemModifyParams{
		Longs: LongParamList{
			{
				Key: targetKey,
				WeightTable: IntWeightTable{WeightRanges: []IntWeightRange{
					{
						Lower:  int64(upgradeAmount),
						Upper:  int64(upgradeAmount),
						Weight: 1,
					},
				}},
			},
		},
	}
}

// GenModifyParamsForDouble is a function to generate modify params from double key and value
func GenModifyParamsForDouble(targetKey string, upgradeAmount sdk.Dec) ItemModifyParams {
	return ItemModifyParams{
		Doubles: DoubleParamList{
			{
				Key: targetKey,
				WeightTable: DoubleWeightTable{WeightRanges: []DoubleWeightRange{
					{
						Lower:  upgradeAmount,
						Upper:  upgradeAmount,
						Weight: 1,
					},
				}},
			},
		},
	}
}
