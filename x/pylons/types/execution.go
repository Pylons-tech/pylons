package types

import (
	fmt "fmt"
)

// EntryListsByIDs is a function to find an entry by ID
func EntryListsByIDs(idList []string, recipe Recipe) ([]CoinOutput, map[int]ItemOutput, []ItemModifyOutput, error) {
	coinOutputs := make([]CoinOutput, 0)
	itemOutputs := make(map[int]ItemOutput)
	itemModifyOutputs := make([]ItemModifyOutput, 0)

Loop:
	for _, id := range idList {
		for _, coinOutput := range recipe.Entries.CoinOutputs {
			if coinOutput.ID == id {
				coinOutputs = append(coinOutputs, coinOutput)
				continue Loop
			}
		}

		for i, itemOutput := range recipe.Entries.ItemOutputs {
			if itemOutput.ID == id {
				itemOutputs[i] = itemOutput
				continue Loop
			}
		}

		for _, itemModifyOutput := range recipe.Entries.ItemModifyOutputs {
			if itemModifyOutput.ID == id {
				itemModifyOutputs = append(itemModifyOutputs, itemModifyOutput)
				continue Loop
			}
		}

		return nil, nil, nil, fmt.Errorf("no entry with the ID %s available", id)
	}

	return coinOutputs, itemOutputs, itemModifyOutputs, nil
}
