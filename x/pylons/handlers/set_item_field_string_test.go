package handlers

import (
	"encoding/json"
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestHandlerMsgUpdateItemString(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	sender1, _ := keep.SetupTestAccounts(t, tci, types.PremiumTier.Fee)

	// mock cookbook
	cbData := MockCookbook(tci, sender1)

	item := keep.GenItem(cbData.CookbookID, sender1, "????????")
	err := tci.PlnK.SetItem(tci.Ctx, *item)
	require.True(t, err == nil)

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
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			if tc.addInputCoin {
				_, err := tci.Bk.AddCoins(tci.Ctx, sender1, types.NewPylon(int64(len(tc.value))))
				require.True(t, err == nil)
			}

			msg := msgs.NewMsgUpdateItemString(tc.itemID, tc.field, tc.value, sender1)
			result, err := HandlerMsgUpdateItemString(tci.Ctx, tci.PlnK, msg)

			if tc.showError == false {
				resp := UpdateItemStringResp{}
				err := json.Unmarshal(result.Data, &resp)

				if err != nil {
					t.Log(err, result)
				}
				require.True(t, err == nil)
				require.True(t, resp.Status == "Success")
				require.True(t, resp.Message == tc.successMsg)

				item, err := tci.PlnK.GetItem(tci.Ctx, tc.itemID)
				require.True(t, err == nil)

				itemName, ok := item.FindString("Name")
				if !ok {
					t.Log("name not available for item=", item)
				}
				require.True(t, ok)
				if itemName != tc.value {
					t.Error("item name does not match after successfully updating the field")
				}
				// should check pylon is reduced correctly
			} else {
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}
