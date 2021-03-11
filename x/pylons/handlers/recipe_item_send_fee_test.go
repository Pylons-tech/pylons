package handlers

import (
	"fmt"
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestRecipeItemTransferFee(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	tci.PlnH = NewMsgServerImpl(tci.PlnK)
	sender1, _, _, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	// mock cookbook
	cbData := MockCookbook(tci, sender1)

	// mock 1 catalyst input 1 output recipe
	genItemModifyOutput := types.NewItemModifyOutput(
		"FeeModifyEntry", "catalyst", types.ItemModifyParams{TransferFee: 300},
	)
	oneCatalystOneOutputRecipeData := MockRecipe(
		tci, "existing recipe",
		types.GenCoinInputList("wood", 5),
		types.GenItemInputList("catalyst"),
		types.EntriesList{
			ItemModifyOutputs: []*types.ItemModifyOutput{&genItemModifyOutput},
			ItemOutputs:       []*types.ItemOutput{types.GenItemOnlyEntry("Catalyst2")},
		},
		types.GenAllOutput("FeeModifyEntry", "Catalyst2"),
		cbData.CookbookID,
		0,
		sender1,
	)

	genItemModifyOutput1 := types.NewItemModifyOutput(
		"FeeModifyEntry", "sword", types.ItemModifyParams{TransferFee: 300},
	)
	oneCatalystOneOutputRecipeData1 := MockRecipe(
		tci, "existing recipe",
		types.CoinInputList{},
		types.GenItemInputList("sword", "knife"),
		types.EntriesList{
			ItemModifyOutputs: []*types.ItemModifyOutput{&genItemModifyOutput1},
		},
		types.GenAllOutput("FeeModifyEntry"),
		cbData.CookbookID,
		0,
		sender1,
	)

	cases := map[string]struct {
		cookbookID          string
		itemIDs             []string
		dynamicItemSet      bool
		dynamicItemNames    []string
		dynamicItemFees     []int64
		addInputCoin        bool
		rcpID               string
		sender              sdk.AccAddress
		desiredError        string
		successMsg          string
		showError           bool
		checkItemName       string
		checkItemAvailable  bool
		checkItemTrasferFee bool
		transferFee         int64
	}{
		"additional item send fee check test": {
			itemIDs:             []string{},
			dynamicItemSet:      true,
			dynamicItemNames:    []string{"catalyst"},
			dynamicItemFees:     []int64{932},
			addInputCoin:        true,
			rcpID:               oneCatalystOneOutputRecipeData.RecipeID, // available ID
			sender:              sender1,
			desiredError:        "",
			successMsg:          "successfully executed the recipe",
			showError:           false,
			checkItemName:       "Catalyst2", // "catalyst" item should be kept
			checkItemAvailable:  true,
			checkItemTrasferFee: true,
			transferFee:         1232,
		},
		"additional item send fee check item upgrade test": {
			itemIDs:             []string{},
			dynamicItemSet:      true,
			dynamicItemNames:    []string{"sword", "knife"},
			dynamicItemFees:     []int64{932, 932},
			rcpID:               oneCatalystOneOutputRecipeData1.RecipeID, // available ID
			sender:              sender1,
			desiredError:        "",
			successMsg:          "successfully executed the recipe",
			showError:           false,
			checkItemTrasferFee: true,
			transferFee:         1232,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			if tc.addInputCoin {
				err := tci.Bk.AddCoins(tci.Ctx, sender1, sdk.Coins{sdk.NewInt64Coin("wood", 50000)})
				require.True(t, err == nil)
			}
			if tc.dynamicItemSet {
				tc.itemIDs = []string{}
				for idx, diN := range tc.dynamicItemNames {
					dynamicItem := keep.GenItem(cbData.CookbookID, tc.sender, diN)

					if len(tc.dynamicItemFees) > idx {
						dynamicItem.SetTransferFee(tc.dynamicItemFees[idx])
					}
					err := tci.PlnK.SetItem(tci.Ctx, dynamicItem)
					require.True(t, err == nil)
					tc.itemIDs = append(tc.itemIDs, dynamicItem.ID)
				}
			}

			msg := msgs.NewMsgExecuteRecipe(tc.rcpID, tc.sender, tc.itemIDs)
			result, err := tci.PlnH.ExecuteRecipe(sdk.WrapSDKContext(tci.Ctx), &msg)

			if tc.showError == false {
				fmt.Println(err)
				require.True(t, err == nil)
				require.True(t, result.Status == "Success")
				require.True(t, result.Message == tc.successMsg)

				// calc generated item availability
				items, err := tci.PlnK.GetItemsBySender(tci.Ctx, tc.sender)
				require.True(t, err == nil)

				itemAvailability := false
				itemTransferFeeCorrect := true

				for _, item := range items {
					itemName, ok := item.FindString("Name")
					if !ok {
						fmt.Println("name not available for item=", item)
					}
					require.True(t, ok)
					if itemName == tc.checkItemName {
						itemAvailability = true
						break
					}
				}

				for _, item := range items {

					if item.TransferFee != tc.transferFee {
						itemTransferFeeCorrect = false
					}
				}

				if tc.checkItemAvailable {
					require.True(t, itemAvailability)
					fmt.Println(itemAvailability)
				}

				if tc.checkItemTrasferFee {
					require.True(t, itemTransferFeeCorrect)
				}
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}
