package handlers

import (
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestSetMatchedItemsFromExecMsg(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	sender1, _ := setupTestAccounts(t, tci, types.NewPylon(1000000))

	cbData := MockCookbook(tci, sender1)

	// Generate initial items
	initItemNames := []string{"Knife", "Knife", "Shield"}
	initItemIDs := []string{}
	for _, iN := range initItemNames {
		newItem := keep.GenItem(cbData.CookbookID, sender1, iN)
		err := tci.PlnK.SetItem(tci.Ctx, *newItem)
		require.True(t, err == nil)
		initItemIDs = append(initItemIDs, newItem.ID)
	}

	knifeMergeRecipe := MockPopularRecipe(RCP_2_BLOCK_DELAYED_KNIFE_MERGE, tci,
		"knife merge recipe", cbData.CookbookID, sender1)

	shieldMergeRecipe := MockRecipe(
		tci, "shield merge recipe",
		types.CoinInputList{},
		types.GenItemInputList("Shield", "Shield"),
		types.GenItemOnlyEntry("MRGShield"),
		types.GenOneOutput(1),
		cbData.CookbookID,
		0,
		sender1,
	)

	cases := map[string]struct {
		itemIDs      []string
		recipeID     string
		sender       sdk.AccAddress
		desiredError string
		showError    bool
	}{
		"correct same item merge recipe": {
			itemIDs:      []string{initItemIDs[0], initItemIDs[1]},
			recipeID:     knifeMergeRecipe.RecipeID,
			sender:       sender1,
			desiredError: "",
			showError:    false,
		},
		"wrong same item merge recipe": {
			itemIDs:      []string{initItemIDs[2], initItemIDs[2]},
			recipeID:     shieldMergeRecipe.RecipeID,
			sender:       sender1,
			desiredError: "multiple use of same item as item inputs",
			showError:    true,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			msg := msgs.NewMsgExecuteRecipe(tc.recipeID, tc.sender, tc.itemIDs)
			rcp, err := tci.PlnK.GetRecipe(tci.Ctx, msg.RecipeID)
			require.True(t, err == nil)
			p := ExecProcess{ctx: tci.Ctx, keeper: tci.PlnK, recipe: rcp}
			err = p.SetMatchedItemsFromExecMsg(msg)
			if tc.showError {
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.True(t, err == nil)
			}
		})
	}
}
