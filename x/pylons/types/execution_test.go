package types

import (
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/stretchr/testify/require"
)

func TestEntryListByIDs(t *testing.T) {
	for _, tc := range []struct {
		desc      string
		entryList EntriesList
		idList    []string
		valid     bool
	}{
		{
			desc:      "Lack of Entries",
			entryList: EntriesList{},
			idList:    []string{"id"},
			valid:     false,
		},
		{
			desc: "Lack of id",
			entryList: EntriesList{
				CoinOutputs: []CoinOutput{
					{
						Id:      "id0",
						Coin:    sdk.NewInt64Coin("coin", 10),
						Program: "",
					},
				},
				ItemOutputs: []ItemOutput{
					{
						Id: "id2",
					},
				},
				ItemModifyOutputs: []ItemModifyOutput{
					{
						Id: "id3",
					},
				},
			},
			idList: []string{"id1", "id2", "id3"},
			valid:  false,
		},
		{
			desc:      "Valid with empty entryList and idList",
			entryList: EntriesList{},
			idList:    []string{},
			valid:     true,
		},
		{
			desc: "Valid with FULL entryList and idList",
			entryList: EntriesList{
				CoinOutputs: []CoinOutput{
					{
						Id:      "id1",
						Coin:    sdk.NewInt64Coin("coin", 10),
						Program: "",
					},
				},
				ItemOutputs: []ItemOutput{
					{
						Id: "id2",
					},
				},
				ItemModifyOutputs: []ItemModifyOutput{
					{
						Id: "id3",
					},
				},
			},
			idList: []string{"id1", "id2", "id3"},
			valid:  true,
		},
		{
			desc: "Valid with FULL entryList and LACK of one id in idList",
			entryList: EntriesList{
				CoinOutputs: []CoinOutput{
					{
						Id:      "id1",
						Coin:    sdk.NewInt64Coin("coin", 10),
						Program: "",
					},
				},
				ItemOutputs: []ItemOutput{
					{
						Id: "id2",
					},
				},
				ItemModifyOutputs: []ItemModifyOutput{
					{
						Id: "id3",
					},
				},
			},
			idList: []string{"id1", "id2"},
			valid:  true,
		},
	} {
		recipe := Recipe{
			Entries: tc.entryList,
		}
		idList := tc.idList
		coinOutputs, itemOutputs, itemModifyOutputs, err := EntryListsByIDs(idList, recipe)

		if tc.valid {
			require.NoError(t, err)
			if len(coinOutputs) != 0 {
				require.Equal(t, tc.entryList.CoinOutputs, coinOutputs)
			}
			if len(itemOutputs) != 0 {
				require.Equal(t, tc.entryList.ItemOutputs[0].Id, itemOutputs[0].Id)
			}
			if len(itemModifyOutputs) != 0 {
				require.Equal(t, tc.entryList.ItemModifyOutputs, itemModifyOutputs)
			}
		} else {
			require.Error(t, err)
		}
	}
}
