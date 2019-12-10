package types

func GenCoinInputList(name string, count int64) CoinInputList {
	return CoinInputList{
		CoinInput{
			Coin:  name,
			Count: count,
		},
	}
}

func GenItemInputList(names ...string) ItemInputList {
	iiL := ItemInputList{}
	for _, name := range names {
		iiL = append(iiL, ItemInput{
			DoubleInputParamList{DoubleInputParam{Key: "endurance",
				MinValue: "100.00",
				MaxValue: "500.00",
			}},
			LongInputParamList{LongInputParam{Key: "HP", MinValue: 100, MaxValue: 500}},
			StringInputParamList{StringInputParam{"Name", name}},
		})
	}
	return iiL
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

func GenToUpgradeForString(targetKey, targetValue string) ItemUpgradeParams {
	return ItemUpgradeParams{
		Strings: []StringUpgradeParam{
			{Key: targetKey, UpgradeValue: targetValue},
		},
	}
}

func GenToUpgradeForLong(targetKey string, upgradeAmount int) ItemUpgradeParams {
	return ItemUpgradeParams{
		Longs: []LongUpgradeParam{
			{Key: targetKey, UpgradeAmount: upgradeAmount},
		},
	}
}

func GenToUpgradeForDouble(targetKey string, upgradeAmount FloatString) ItemUpgradeParams {
	return ItemUpgradeParams{
		Doubles: []DoubleUpgradeParam{
			{Key: targetKey, UpgradeAmount: upgradeAmount},
		},
	}
}
