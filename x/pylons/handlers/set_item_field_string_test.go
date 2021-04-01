package handlers

import (
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestHandlerMsgUpdateItemString(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	tci.PlnH = NewMsgServerImpl(tci.PlnK)
	sender1, _, _, _ := keep.SetupTestAccounts(t, tci, types.PremiumTier.Fee, nil, nil, nil)

	// mock cookbook
	cbData := MockCookbook(tci, sender1)

	item := keep.GenItem(cbData.CookbookID, sender1, "????????")
	err := tci.PlnK.SetItem(tci.Ctx, item)
	require.NoError(t, err)

	item1 := keep.GenItem(cbData.CookbookID, sender1, "????????")
	item1.OwnerRecipeID = "????????"
	err = tci.PlnK.SetItem(tci.Ctx, item1)
	require.NoError(t, err)

	item2 := keep.GenItem(cbData.CookbookID, sender1, "????????")
	item2.OwnerTradeID = "????????"
	err = tci.PlnK.SetItem(tci.Ctx, item2)
	require.NoError(t, err)

	cases := map[string]struct {
		itemID       string
		field        string
		value        string
		sender       sdk.AccAddress
		addInputCoin bool
		desiredError string
		successMsg   string
		showError    bool
	}{
		"TC1 item id length should be more than 0": {
			itemID:       "",
			field:        "Name",
			value:        "Ben2",
			sender:       sender1,
			addInputCoin: false,
			desiredError: "item id length should be more than 0",
			showError:    true,
		},
		"TC2 field length should be more than 0": {
			itemID:       item.ID,
			field:        "",
			value:        "Ben2",
			sender:       sender1,
			addInputCoin: false,
			desiredError: "field length should be more than 0",
			showError:    true,
		},
		"TC3 value length should be more than 0": {
			itemID:       item.ID,
			field:        "Name",
			value:        "",
			sender:       sender1,
			addInputCoin: false,
			desiredError: "value length should be more than 0",
			showError:    true,
		},
		"TC4 Sender does not have enough coins for this action": {
			itemID:       item.ID,
			field:        "Name",
			value:        "Ben2",
			sender:       sender1,
			addInputCoin: false,
			desiredError: "Sender does not have enough coins for this action",
			showError:    true,
		},
		"TC5 Provided field does not exist within the item": {
			itemID:       item.ID,
			field:        "NickName",
			value:        "Ben1",
			sender:       sender1,
			addInputCoin: true,
			desiredError: "Provided field does not exist within the item",
			showError:    true,
		},
		"TC6 basic flow test": {
			itemID:       item.ID,
			field:        "Name",
			value:        "Ben3",
			sender:       sender1,
			addInputCoin: true,
			successMsg:   "successfully updated the item field",
			showError:    false,
		},
		"TC7 Item is owned by a recipe": {
			itemID:       item1.ID,
			field:        "Name",
			value:        "Ben1",
			sender:       sender1,
			addInputCoin: true,
			desiredError: "Item is owned by a recipe",
			showError:    true,
		},
		"TC8 Item is owned by a trade": {
			itemID:       item2.ID,
			field:        "Name",
			value:        "Ben1",
			sender:       sender1,
			addInputCoin: true,
			desiredError: "Item is owned by a trade",
			showError:    true,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			if tc.addInputCoin {
				err := tci.Bk.AddCoins(tci.Ctx, sender1, types.NewPylon(config.Config.Fee.UpdateItemFieldString))
				require.NoError(t, err)
			}

			msg := msgs.NewMsgUpdateItemString(tc.itemID, tc.field, tc.value, sender1.String())
			result, err := tci.PlnH.UpdateItemString(sdk.WrapSDKContext(tci.Ctx), &msg)

			if tc.showError == false {
				if err != nil {
					t.Log("UpdateItemString.err", err)
				}

				require.NoError(t, err)
				require.True(t, result.Status == "Success")
				require.True(t, result.Message == tc.successMsg)

				item, err := tci.PlnK.GetItem(tci.Ctx, tc.itemID)
				require.NoError(t, err)

				itemName, ok := item.FindString("Name")
				if !ok {
					t.Log("name not available for item=", item)
				}
				require.True(t, ok)
				if itemName != tc.value {
					t.Error("item name does not match after successfully updating the field")
				}
				// TODO should check pylon is reduced correctly
			} else {
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}
