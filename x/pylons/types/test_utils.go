package types

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
			DoubleInputParamMap{"endurance": DoubleInputParam{DoubleWeightTable: DoubleWeightTable{WeightRanges: []DoubleWeightRange{
				DoubleWeightRange{
					Lower:  100.00,
					Upper:  500.00,
					Weight: 6,
				},
				DoubleWeightRange{
					Lower:  501.00,
					Upper:  800.00,
					Weight: 2,
				},
			}}}},
			LongInputParamMap{"HP": LongInputParam{IntWeightTable: IntWeightTable{WeightRanges: []IntWeightRange{
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
			StringInputParamMap{"Name": StringInputParam{name}},
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
			DoubleParamMap{"endurance": DoubleParam{DoubleWeightTable: DoubleWeightTable{WeightRanges: []DoubleWeightRange{
				DoubleWeightRange{
					Lower:  100.00,
					Upper:  500.00,
					Weight: 6,
				},
				DoubleWeightRange{
					Lower:  501.00,
					Upper:  800.00,
					Weight: 2,
				},
			}}, Rate: "1.0"}},
			LongParamMap{"HP": LongParam{IntWeightTable: IntWeightTable{WeightRanges: []IntWeightRange{
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
			StringParamMap{"Name": StringParam{itemName, "1.0"}},
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
