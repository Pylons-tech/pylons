package handlers

import (
	"encoding/json"
	"fmt"
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestHandlerMsgExecuteRecipe1(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	sender1, _, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil)

	// mock cookbook
	cbData := MockCookbook(tci, sender1)

	// mock 1 catalyst input 1 output recipe
	oneCatalystOneOutputRecipeData := MockRecipe(
		tci, "existing recipe",
		types.GenCoinInputList("wood", 5),
		types.GenItemInputList("catalyst"),

		types.EntriesList{
			types.NewInputRefOutput(
				0, types.ItemModifyParams{AdditionalItemSendFee: 300},
			),
			types.GenItemOnlyEntry("Catalyst2")[0],
		},
		types.GenAllOutput(2),
		cbData.CookbookID,
		0,
		sender1,
	)

	oneCatalystOneOutputRecipeData1 := MockRecipe(
		tci, "existing recipe",
		types.CoinInputList{},
		types.GenItemInputList("sword", "knife"),

		types.EntriesList{
			types.NewInputRefOutput(
				0, types.ItemModifyParams{AdditionalItemSendFee: 300},
			),
		},
		types.GenAllOutput(1),
		cbData.CookbookID,
		0,
		sender1,
	)

	cases := map[string]struct {
		cookbookID                 string
		itemIDs                    []string
		dynamicItemSet             bool
		dynamicItemNames           []string
		dynamicItemFees            []int64
		addInputCoin               bool
		rcpID                      string
		sender                     sdk.AccAddress
		desiredError               string
		successMsg                 string
		showError                  bool
		checkItemName              string
		checkItemAvailable         bool
		checkAdditionalItemSendFee bool
		additionalItemSendFees     int64
	}{
		"item generation with catalyst item test": {
			itemIDs:                    []string{},
			dynamicItemSet:             true,
			dynamicItemNames:           []string{"catalyst"},
			dynamicItemFees:            []int64{932},
			addInputCoin:               true,
			rcpID:                      oneCatalystOneOutputRecipeData.RecipeID, // available ID
			sender:                     sender1,
			desiredError:               "",
			successMsg:                 "successfully executed the recipe",
			showError:                  false,
			checkItemName:              "Catalyst2", // "catalyst" item should be kept
			checkItemAvailable:         true,
			checkAdditionalItemSendFee: true,
			additionalItemSendFees:     1232,
		},
		"modify items test with one dynamic item": {
			itemIDs:                    []string{},
			dynamicItemSet:             true,
			dynamicItemNames:           []string{"sword", "knife"},
			dynamicItemFees:            []int64{932, 932},
			rcpID:                      oneCatalystOneOutputRecipeData1.RecipeID, // available ID
			sender:                     sender1,
			desiredError:               "",
			successMsg:                 "successfully executed the recipe",
			showError:                  false,
			checkAdditionalItemSendFee: true,
			additionalItemSendFees:     1232,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			if tc.addInputCoin {
				_, err := tci.Bk.AddCoins(tci.Ctx, sender1, sdk.Coins{sdk.NewInt64Coin("wood", 50000)})
				require.True(t, err == nil)
			}
			if tc.dynamicItemSet {
				tc.itemIDs = []string{}
				for idx, diN := range tc.dynamicItemNames {
					dynamicItem := keep.GenItem(cbData.CookbookID, tc.sender, diN)

					if len(tc.dynamicItemFees) > idx {
						dynamicItem.AdditionalItemSendFee = tc.dynamicItemFees[idx]
					}
					err := tci.PlnK.SetItem(tci.Ctx, *dynamicItem)
					require.True(t, err == nil)
					tc.itemIDs = append(tc.itemIDs, dynamicItem.ID)
				}
			}

			msg := msgs.NewMsgExecuteRecipe(tc.rcpID, tc.sender, tc.itemIDs)
			result, err := HandlerMsgExecuteRecipe(tci.Ctx, tci.PlnK, msg)

			if tc.showError == false {
				fmt.Print(err)
				require.True(t, err == nil)
				execRcpResponse := ExecuteRecipeResponse{}
				err := json.Unmarshal(result.Data, &execRcpResponse)

				if err != nil {
					fmt.Print(err, result)
				}
				require.True(t, err == nil)
				require.True(t, execRcpResponse.Status == "Success")
				require.True(t, execRcpResponse.Message == tc.successMsg)

				// calc generated item availability
				items, err := tci.PlnK.GetItemsBySender(tci.Ctx, tc.sender)
				require.True(t, err == nil)

				itemAvailability := false
				additionalItemSendFeeCorrect := true

				for _, item := range items {
					itemName, ok := item.FindString("Name")
					if !ok {
						fmt.Print("name not available for item=", item)
					}
					require.True(t, ok)
					if itemName == tc.checkItemName {
						itemAvailability = true
						break
					}
				}

				for _, item := range items {

					if item.AdditionalItemSendFee != tc.additionalItemSendFees {
						additionalItemSendFeeCorrect = false
					}
				}

				if tc.checkItemAvailable {
					require.True(t, itemAvailability)
					fmt.Print(itemAvailability)
				}

				if tc.checkAdditionalItemSendFee {
					require.True(t, additionalItemSendFeeCorrect)
				}
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}
