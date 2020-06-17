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

func TestHandlerMsgSendItems(t *testing.T) {
	tci := keep.SetupTestCoinInput()

	sender1, sender2 := keep.SetupTestAccounts(t, tci, types.PremiumTier.Fee)

	cbData := MockCookbook(tci, sender1)

	item1 := keep.GenItem(cbData.CookbookID, sender1, "sword")
	item2 := keep.GenItem(cbData.CookbookID, sender1, "axe")
	item3 := keep.GenItem(cbData.CookbookID, sender1, "spear")
	item3.OwnerRecipeID = "????????"

	err := tci.PlnK.SetItem(tci.Ctx, *item1)
	require.True(t, err == nil)

	err = tci.PlnK.SetItem(tci.Ctx, *item2)
	require.True(t, err == nil)

	err = tci.PlnK.SetItem(tci.Ctx, *item3)
	require.True(t, err == nil)

	cases := map[string]struct {
		itemIDs      []string
		fromAddress  sdk.AccAddress
		toAddress    sdk.AccAddress
		desiredError string
		showError    bool
	}{
		"successful check": {
			itemIDs:      []string{item1.ID, item2.ID},
			fromAddress:  sender1,
			toAddress:    sender2,
			desiredError: "",
			showError:    false,
		},
		"empty item id check": {
			itemIDs:      []string{item1.ID, item2.ID, ""},
			fromAddress:  sender1,
			toAddress:    sender2,
			desiredError: "ItemID is invalid",
			showError:    true,
		},
		"same sender and receiver check": {
			itemIDs:      []string{item1.ID, item2.ID},
			fromAddress:  sender1,
			toAddress:    sender1,
			desiredError: "Sender and receiver should be different",
			showError:    true,
		},
		"wrong item sender check": {
			itemIDs:      []string{item1.ID, item2.ID},
			fromAddress:  sender1,
			toAddress:    sender2,
			desiredError: "Item is not the sender's one",
			showError:    true,
		},
		"owner receiper id check": {
			itemIDs:      []string{item3.ID},
			fromAddress:  sender1,
			toAddress:    sender2,
			desiredError: "Item is owned by a receipe",
			showError:    true,
		},
		"duplicate item check": {
			itemIDs:      []string{item1.ID, item1.ID},
			fromAddress:  sender1,
			toAddress:    sender2,
			desiredError: "Duplicated items",
			showError:    true,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			msg := msgs.NewMsgSendItems(tc.itemIDs, tc.fromAddress, tc.toAddress)
			_, err := HandlerMsgSendItems(tci.Ctx, tci.PlnK, msg)

			if !tc.showError {
				for _, itemID := range tc.itemIDs {
					item, err := tci.PlnK.GetItem(tci.Ctx, itemID)
					require.True(t, err == nil)
					require.True(t, item.Sender.String() == sender2.String())
				}
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}
