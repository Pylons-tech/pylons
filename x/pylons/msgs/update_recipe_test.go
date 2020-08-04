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
			itemInputs:   nil,
			entries:      nil,
			outputs:      nil,
			sender:       sender,
			showError:    true,
			desiredError: "recipe id is required for this message type",
		},
		"item input ID validation error": { // item input ID validation error
			recipeID:     "recipeID",
			itemInputs:   types.ItemInputList{{ID: "123"}},
			entries:      nil,
			outputs:      nil,
			sender:       sender,
			showError:    true,
			desiredError: "ID is not empty nor fit the regular expression ^[a-zA-Z_][a-zA-Z_0-9]*$: id=123",
		},
		"item input ID validation": { // item input ID validation
			recipeID:     "recipeID",
			itemInputs:   types.ItemInputList{{ID: "heli_knife_lv1"}},
			entries:      nil,
			outputs:      nil,
			sender:       sender,
			showError:    false,
			desiredError: "",
		},
		"same item input ID check error": { // same item input ID check error
			recipeID:     "recipeID",
			itemInputs:   types.ItemInputList{{ID: "a123"}, {ID: "a123"}},
			entries:      nil,
			outputs:      nil,
			sender:       sender,
			showError:    true,
			desiredError: "item input with same ID available: ID=a123",
		},
		"entry ID validation error": { // entry ID validation error
			recipeID:     "recipeID",
			itemInputs:   nil,
			entries:      types.EntriesList{types.CoinOutput{ID: "123"}},
			outputs:      nil,
			sender:       sender,
			showError:    true,
			desiredError: "entryID does not fit the regular expression ^[a-zA-Z_][a-zA-Z_0-9]*$: id=123",
		},
		"length of program code shouldn't be 0": { // length of program code shouldn't be 0
			recipeID:     "recipeID",
			itemInputs:   nil,
			entries:      types.EntriesList{types.CoinOutput{ID: "a123"}},
			outputs:      nil,
			sender:       sender,
			showError:    true,
			desiredError: "length of program code shouldn't be 0",
		},
		"invalid item input ref": { // invalid item input ref
			recipeID:   "recipeID",
			itemInputs: nil,
			entries: types.EntriesList{
				types.ItemModifyOutput{ID: "a123", ItemInputRef: "aaabbb"},
			},
			outputs:      nil,
			sender:       sender,
			showError:    true,
			desiredError: "Invalid item input ref found that does not exist in item inputs",
		},
		"entry same ID available error": { // entry same ID available error
			recipeID:   "recipeID",
			itemInputs: nil,
			entries: types.EntriesList{
				types.CoinOutput{ID: "a123", Coin: "abc", Count: "1"},
				types.CoinOutput{ID: "a123", Coin: "abc", Count: "2"},
			},
			outputs:      nil,
			sender:       sender,
			showError:    true,
			desiredError: "entry with same ID available: ID=a123",
		},
		"coin output denom validation error": { // coin output denom validation error
			recipeID:   "recipeID",
			itemInputs: nil,
			entries: types.EntriesList{
				types.CoinOutput{ID: "a123", Coin: "123$", Count: "1"},
			},
			outputs:      nil,
			sender:       sender,
			showError:    true,
			desiredError: "invalid denom: 123$",
		},
		"does not exist entry ID use on outputs": { // does not exist entry ID use on outputs
			recipeID:   "recipeID",
			itemInputs: nil,
			entries:    nil,
			outputs: types.WeightedOutputsList{{
				EntryIDs: []string{"aaabbb"},
				Weight:   "1",
			}},
			sender:       sender,
			showError:    true,
			desiredError: "no entry with the ID aaabbb available",
		},
		"double use of entries within single output": { // double use of entries within single output
			recipeID:   "recipeID",
			itemInputs: nil,
			entries: types.EntriesList{
				types.CoinOutput{ID: "a123", Coin: "aaa", Count: "1"},
			},
			outputs: types.WeightedOutputsList{{
				EntryIDs: []string{"a123", "a123"},
				Weight:   "1",
			}},
			sender:       sender,
			showError:    true,
			desiredError: "double use of entries within single output",
		},
		"double use of item input within single output result": { // double use of item input within single output result
			recipeID:   "recipeID",
			itemInputs: types.ItemInputList{{ID: "input1"}},
			entries: types.EntriesList{
				types.ItemModifyOutput{ID: "a1", ItemInputRef: "input1"},
				types.ItemModifyOutput{ID: "a2", ItemInputRef: "input1"},
			},
			outputs: types.WeightedOutputsList{{
				EntryIDs: []string{"a1", "a2"},
				Weight:   "1",
			}},
			sender:       sender,
			showError:    true,
			desiredError: "invalid request: double use of item input within single output result",
		},
		"empty sender validation1": { // empty sender validation1
			recipeID:     "recipeID",
			itemInputs:   nil,
			entries:      nil,
			outputs:      nil,
			sender:       nil,
			showError:    true,
			desiredError: "invalid address",
		},
		"empty sender validation2": { // empty sender validation2
			recipeID:     "recipeID",
			itemInputs:   nil,
			entries:      nil,
			outputs:      nil,
			sender:       sdk.AccAddress{},
			showError:    true,
			desiredError: "invalid address",
		},
		"the description should have more than 20 character": { // the description should have more than 20 character
			recipeID:     "recipeID",
			shortDesc:    true,
			sender:       sender,
			showError:    true,
			desiredError: "invalid request: the description should have more than 20 characters",
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			desc := "this has to meet character limits"
			if tc.shortDesc {
				desc = ""
			}
			msg := NewMsgUpdateRecipe(
				"existing recipe",
				"CookbookID",
				tc.recipeID,
				desc,
				types.GenCoinInputList("wood", 5),
				tc.itemInputs,
				tc.entries,
				tc.outputs,
				0,
				tc.sender,
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
