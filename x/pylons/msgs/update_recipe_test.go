package msgs

import (
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestUpdateRecipeValidateBasic(t *testing.T) {
	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")

	cases := map[string]struct {
		recipeID     string
		itemInputs   types.ItemInputList
		entries      types.EntriesList
		outputs      types.WeightedOutputsList
		sender       sdk.AccAddress
		shortDesc    bool
		showError    bool
		desiredError string
	}{
		"successful update recipe": {
			recipeID:   "recipeID",
			itemInputs: types.GenItemInputList("Raichu"),
			entries:    types.GenEntries("chair", "Raichu"),
			outputs:    types.GenOneOutput("chair", "Raichu"),
			sender:     sender,
			showError:  false,
		},
		"recipe ID validation error": {
			recipeID:     "",
			itemInputs:   types.ItemInputList{},
			entries:      types.EntriesList{},
			outputs:      types.WeightedOutputsList{},
			sender:       sender,
			showError:    true,
			desiredError: "recipe id is required for this message type",
		},
		"item input ID validation error": { // item input ID validation error
			recipeID:     "recipeID",
			itemInputs:   types.ItemInputList{List: []types.ItemInput{{ID: "123"}}},
			entries:      types.EntriesList{},
			outputs:      types.WeightedOutputsList{},
			sender:       sender,
			showError:    true,
			desiredError: "ID is not empty nor fit the regular expression ^[a-zA-Z_][a-zA-Z_0-9]*$: id=123",
		},
		"item input ID validation": { // item input ID validation
			recipeID:     "recipeID",
			itemInputs:   types.ItemInputList{[]types.ItemInput{{ID: "heli_knife_lv1"}}},
			entries:      types.EntriesList{},
			outputs:      types.WeightedOutputsList{},
			sender:       sender,
			showError:    false,
			desiredError: "",
		},
		"same item input ID check error": { // same item input ID check error
			recipeID:     "recipeID",
			itemInputs:   types.ItemInputList{[]types.ItemInput{{ID: "a123"}, {ID: "a123"}}},
			entries:      types.EntriesList{},
			outputs:      types.WeightedOutputsList{},
			sender:       sender,
			showError:    true,
			desiredError: "item input with same ID available: ID=a123",
		},
		"entry ID validation error": { // entry ID validation error
			recipeID:     "recipeID",
			itemInputs:   types.ItemInputList{},
			entries:      types.EntriesList{CoinOutputs: []types.CoinOutput{{ID: "123"}}},
			outputs:      types.WeightedOutputsList{},
			sender:       sender,
			showError:    true,
			desiredError: "entryID does not fit the regular expression ^[a-zA-Z_][a-zA-Z_0-9]*$: id=123",
		},
		"length of program code shouldn't be 0": { // length of program code shouldn't be 0
			recipeID:     "recipeID",
			itemInputs:   types.ItemInputList{},
			entries:      types.EntriesList{CoinOutputs: []types.CoinOutput{{ID: "a123"}}},
			outputs:      types.WeightedOutputsList{},
			sender:       sender,
			showError:    true,
			desiredError: "length of program code shouldn't be 0",
		},
		"invalid item input ref": { // invalid item input ref
			recipeID:   "recipeID",
			itemInputs: types.ItemInputList{},
			entries: types.EntriesList{
				ItemModifyOutputs: []types.ItemModifyOutput{{ID: "a123", ItemInputRef: "aaabbb"}},
			},
			outputs:      types.WeightedOutputsList{},
			sender:       sender,
			showError:    true,
			desiredError: "Invalid item input ref found that does not exist in item inputs",
		},
		"entry same ID available error": { // entry same ID available error
			recipeID:   "recipeID",
			itemInputs: types.ItemInputList{},
			entries: types.EntriesList{
				CoinOutputs: []types.CoinOutput{
					{ID: "a123", Coin: "abc", Count: "1"},
					{ID: "a123", Coin: "abc", Count: "2"},
				}},
			outputs:      types.WeightedOutputsList{},
			sender:       sender,
			showError:    true,
			desiredError: "entry with same ID available: ID=a123",
		},
		"coin output denom validation error": { // coin output denom validation error
			recipeID:   "recipeID",
			itemInputs: types.ItemInputList{},
			entries: types.EntriesList{
				CoinOutputs: []types.CoinOutput{{ID: "a123", Coin: "123$", Count: "1"}},
			},
			outputs:      types.WeightedOutputsList{},
			sender:       sender,
			showError:    true,
			desiredError: "invalid denom: 123$",
		},
		"does not exist entry ID use on outputs": { // does not exist entry ID use on outputs
			recipeID:   "recipeID",
			itemInputs: types.ItemInputList{},
			entries:    types.EntriesList{},
			outputs: types.WeightedOutputsList{List: []types.WeightedOutputs{{
				EntryIDs: []string{"aaabbb"},
				Weight:   "1",
			}}},
			sender:       sender,
			showError:    true,
			desiredError: "no entry with the ID aaabbb available",
		},
		"double use of entries within single output": { // double use of entries within single output
			recipeID:   "recipeID",
			itemInputs: types.ItemInputList{},
			entries: types.EntriesList{
				CoinOutputs: []types.CoinOutput{{ID: "a123", Coin: "aaa", Count: "1"}},
			},
			outputs: types.WeightedOutputsList{List: []types.WeightedOutputs{{
				EntryIDs: []string{"a123", "a123"},
				Weight:   "1",
			}}},
			sender:       sender,
			showError:    true,
			desiredError: "double use of entries within single output",
		},
		"double use of item input within single output result": { // double use of item input within single output result
			recipeID:   "recipeID",
			itemInputs: types.ItemInputList{List: []types.ItemInput{{ID: "input1"}}},
			entries: types.EntriesList{
				ItemModifyOutputs: []types.ItemModifyOutput{
					{ID: "a1", ItemInputRef: "input1"},
					{ID: "a2", ItemInputRef: "input1"},
				}},
			outputs: types.WeightedOutputsList{List: []types.WeightedOutputs{{
				EntryIDs: []string{"a1", "a2"},
				Weight:   "1",
			}}},
			sender:       sender,
			showError:    true,
			desiredError: "double use of item input within single output result: invalid request",
		},
		"empty sender validation1": { // empty sender validation1
			recipeID:     "recipeID",
			itemInputs:   types.ItemInputList{},
			entries:      types.EntriesList{},
			outputs:      types.WeightedOutputsList{},
			sender:       nil,
			showError:    true,
			desiredError: "invalid address",
		},
		"empty sender validation2": { // empty sender validation2
			recipeID:     "recipeID",
			itemInputs:   types.ItemInputList{},
			entries:      types.EntriesList{},
			outputs:      types.WeightedOutputsList{},
			sender:       sdk.AccAddress{},
			showError:    true,
			desiredError: "invalid address",
		},
		"the description should have more than 20 character": { // the description should have more than 20 character
			recipeID:     "recipeID",
			shortDesc:    true,
			sender:       sender,
			showError:    true,
			desiredError: "the description should have more than 20 characters: invalid request",
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			desc := "this has to meet character limits"
			if tc.shortDesc {
				desc = ""
			}
			msg := NewMsgUpdateRecipe(
				tc.recipeID,
				"existing recipe",
				"CookbookID",
				desc,
				types.GenCoinInputList("wood", 5),
				tc.itemInputs,
				tc.entries,
				tc.outputs,
				0,
				tc.sender.String(),
			)

			err := msg.ValidateBasic()
			if !tc.showError {
				require.True(t, err == nil, err)
			} else {
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.desiredError), err.Error())
			}
		})
	}
}
