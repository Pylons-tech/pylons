package types

// GenCoinInputList is a utility function to genearte coin input list
func GenCoinInputList(name string, count int64) CoinInputList {
	return CoinInputList{
		CoinInput{
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
			nil,
			nil,
			StringInputParamList{StringInputParam{"Name", name}},
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
func GenCoinOnlyEntry(coinName string) EntriesList {
	return EntriesList{
		CoinOutput{
			ID:    coinName,
			Coin:  coinName,
			Count: "1",
		},
	}
}

// GenCoinOnlyEntryRand is a utility function to genearte coin only entry with random count
func GenCoinOnlyEntryRand(ID string, coinName string) EntriesList {
	return EntriesList{
		CoinOutput{
			ID:    ID,
			Coin:  coinName,
			Count: `rand(10)+1`,
		},
	}
}

// GenItemNameUpgradeParams is a utility function to generate item name upgrade
func GenItemNameUpgradeParams(desItemName string) ItemModifyParams {
	return ItemModifyParams{
		Doubles: DoubleParamList{},
		Longs:   LongParamList{},
		Strings: StringParamList{
			StringParam{
				Key:   "Name",
				Value: desItemName,
			},
		},
	}
}

// GenItemOnlyEntry is a utility function to generate item only entry
func GenItemOnlyEntry(itemName string) EntriesList {
	return EntriesList{
		NewItemOutput(
			itemName,
			DoubleParamList{DoubleParam{Key: "endurance", DoubleWeightTable: DoubleWeightTable{WeightRanges: []DoubleWeightRange{
				{
					Lower:  "100.00",
					Upper:  "500.00",
					Weight: 6,
				},
				{
					Lower:  "501.00",
					Upper:  "800.00",
					Weight: 2,
				},
			}}, Rate: "1.0"}},
			LongParamList{LongParam{Key: "HP", IntWeightTable: IntWeightTable{WeightRanges: []IntWeightRange{
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
			}}}},
			StringParamList{StringParam{Key: "Name", Value: itemName, Rate: "1.0", Program: ""}},
			1232,
		),
	}
}

// GenItemOnlyEntryRand is a function to generate item only entry with random value
func GenItemOnlyEntryRand(ID string, itemName string) EntriesList {
	return EntriesList{
		NewItemOutput(
			ID,
			DoubleParamList{DoubleParam{
				Key:     "endurance",
				Program: `500.00`,
				Rate:    "1.0",
			}},
			LongParamList{LongParam{
				Key:     "HP",
				Program: `500 + rand(300)`,
				Rate:    "1.0",
			}},
			StringParamList{StringParam{Key: "Name", Value: itemName, Rate: "1.0", Program: ""}},
			0,
		),
	}
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
	wol := WeightedOutputsList{
		WeightedOutputs{
			EntryIDs: entryIDs,
			Weight:   "1",
		},
	}
	return wol
}

// GenEntries is a function to generate entries from coin name and item name
func GenEntries(coinName string, itemName string) EntriesList {
	return EntriesList{
		GenCoinOnlyEntry(coinName)[0],
		GenItemOnlyEntry(itemName)[0],
	}
}

// GenEntriesRand is a function to generate entreis from coin name and item name and which has random attributes
func GenEntriesRand(coinName, itemName string) EntriesList {
	return EntriesList{
		GenCoinOnlyEntryRand(coinName, coinName)[0],
		GenItemOnlyEntryRand(itemName, itemName)[0],
	}
}

// GenEntriesItemNameUpgrade is a function to generate entries that update first item's name
func GenEntriesItemNameUpgrade(inputRef, targetValue string) EntriesList {
	return EntriesList{
		NewItemModifyOutput(
			targetValue, inputRef, GenModifyParamsForString("Name", targetValue),
		),
	}
}

// GenEntriesTwoItemNameUpgrade is a function to generate entries that update two items' names
func GenEntriesTwoItemNameUpgrade(inputRef1, targetValue1, inputRef2, targetValue2 string) EntriesList {
	return EntriesList{
		NewItemModifyOutput(
			targetValue1, inputRef1, GenModifyParamsForString("Name", targetValue1),
		),
		NewItemModifyOutput(
			targetValue2, inputRef2, GenModifyParamsForString("Name", targetValue2),
		),
	}
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
		Longs: []LongParam{
			{
				Key: targetKey,
				IntWeightTable: IntWeightTable{WeightRanges: []IntWeightRange{
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

// GenModifyParamsForDouble is a function to generate modify params from double key and value
func GenModifyParamsForDouble(targetKey string, upgradeAmount FloatString) ItemModifyParams {
	return ItemModifyParams{
		Doubles: []DoubleParam{
			{
				Key: targetKey,
				DoubleWeightTable: DoubleWeightTable{WeightRanges: []DoubleWeightRange{
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
