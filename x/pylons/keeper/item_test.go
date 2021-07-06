package keeper

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/require"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestKeeperSetItem(t *testing.T) {
	tci := SetupTestCoinInput()
	sender, _, _, _ := SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	cbData := GenCookbook(sender, "cookbook-0001", "this has to meet character limits")

	cases := map[string]struct {
		name         string
		desc         string
		sender       sdk.AccAddress
		level        int64
		desiredError string
		showError    bool
	}{
		"empty sender test": {
			sender:       nil,
			level:        1,
			desiredError: "SetItem: the sender cannot be empty",
			showError:    true,
		},
		"successful item test": {
			sender:       sender,
			level:        1,
			desiredError: "",
			showError:    false,
		},
	}

	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			item := GenItem(cbData.ID, tc.sender, "Raichu")
			err := tci.PlnK.SetItem(tci.Ctx, item)

			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.NoError(t, err)
			}
		})
	}
}

func TestKeeperGetItem(t *testing.T) {
	tci := SetupTestCoinInput()
	sender, _, _, _ := SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	cbData := GenCookbook(sender, "cookbook-0001", "this has to meet character limits")
	item := GenItem(cbData.ID, sender, "Raichu")
	err := tci.PlnK.SetItem(tci.Ctx, item)
	require.NoError(t, err)

	cases := map[string]struct {
		itemID       string
		desiredError string
		showError    bool
	}{
		"item not exist": {
			itemID:       "invalidItemID",
			desiredError: "The item doesn't exist",
			showError:    true,
		},
		"successful item test": {
			itemID:       item.ID,
			desiredError: "",
			showError:    false,
		},
	}

	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			gItem, err := tci.PlnK.GetItem(tci.Ctx, tc.itemID)
			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.NoError(t, err)
				require.True(t, item.CookbookID == gItem.CookbookID)
				require.True(t, item.Sender == gItem.Sender)
				require.True(t, item.ID == gItem.ID)
			}
		})
	}
}

func TestKeeperGetItemsBySender(t *testing.T) {
	tci := SetupTestCoinInput()
	sender, sender2, _, _ := SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	cbData := GenCookbook(sender, "cookbook-0001", "this has to meet character limits")

	item := GenItem(cbData.ID, sender, "Raichu")
	err := tci.PlnK.SetItem(tci.Ctx, item)
	require.NoError(t, err)

	cases := map[string]struct {
		sender        sdk.AccAddress
		desiredError  string
		desiredLength int
		showError     bool
	}{
		"sender with no item": {
			sender:        sender2,
			desiredError:  "",
			desiredLength: 0,
			showError:     false,
		},
		"sender with one item test": {
			sender:        sender,
			desiredError:  "",
			desiredLength: 1,
			showError:     false,
		},
	}

	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {

			itemsBySender, err := tci.PlnK.GetItemsBySender(tci.Ctx, tc.sender)
			if tc.showError {
			} else {
				require.NoError(t, err)
				require.True(t, len(itemsBySender) == tc.desiredLength)
			}
		})
	}
}

func TestKeeperUpdateItem(t *testing.T) {
	tci := SetupTestCoinInput()
	sender, _, _, _ := SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	cbData := GenCookbook(sender, "cookbook-0001", "this has to meet character limits")
	item := GenItem(cbData.ID, sender, "Raichu")
	noSenderItem := GenItem(cbData.ID, nil, "Raichu")
	newItem := GenItem(cbData.ID, sender, "Raichu")

	err := tci.PlnK.SetItem(tci.Ctx, item)
	require.NoError(t, err)

	item.SetString("Name", "RC")

	cases := map[string]struct {
		desiredError string
		showError    bool
		item         types.Item
		itemID       string
	}{
		"empty sender of updatedItem": {
			itemID:       item.ID,
			item:         noSenderItem,
			desiredError: "UpdateItem: the sender cannot be empty",
			showError:    true,
		},
		"not existing ID provide check": {
			itemID:       "invalidItemID",
			item:         item,
			desiredError: "The item with gid invalidItemID does not exist",
			showError:    true,
		},
		"updateItem ID different from param item": {
			itemID:       item.ID,
			item:         newItem,
			desiredError: "",
			showError:    false,
		},
		"item name change update": {
			itemID:       item.ID,
			item:         item,
			desiredError: "",
			showError:    false,
		},
	}

	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {

			err := tci.PlnK.UpdateItem(tci.Ctx, tc.itemID, tc.item)
			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.NoError(t, err)
				gItem, err := tci.PlnK.GetItem(tci.Ctx, tc.itemID)
				require.NoError(t, err)
				originItemStr, ok := tc.item.FindString("Name")
				require.True(t, ok == true)
				gotItemStr, ok := gItem.FindString("Name")
				require.True(t, ok == true)
				require.True(t, originItemStr == gotItemStr)
			}
		})
	}
}

func TestKeeperDeleteItem(t *testing.T) {
	tci := SetupTestCoinInput()
	sender, _, _, _ := SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	cbData := GenCookbook(sender, "cookbook-0001", "this has to meet character limits")
	item := GenItem(cbData.ID, sender, "Raichu")
	err := tci.PlnK.SetItem(tci.Ctx, item)
	require.NoError(t, err)

	cases := map[string]struct {
		itemID       string
		desiredError string
		showError    bool
	}{
		"not existing id delete": {
			itemID:       "notExistingID",
			desiredError: "",
			showError:    false,
		},
		"existing id delete": {
			itemID:       item.ID,
			desiredError: "",
			showError:    false,
		},
	}

	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			tci.PlnK.DeleteItem(tci.Ctx, tc.itemID)
			if tc.showError {
			} else {
				_, err := tci.PlnK.GetItem(tci.Ctx, tc.itemID)
				require.True(t, strings.Contains(err.Error(), "The item doesn't exist"))
			}
		})
	}
}

func TestKeeperItemsByCookbook(t *testing.T) {
	tci := SetupTestCoinInput()
	sender, _, _, _ := SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	cbData := GenCookbook(sender, "cookbook-0001", "this has to meet character limits")
	cbData1 := GenCookbook(sender, "cookbook-0002", "this has to meet character limits")

	item := GenItem(cbData.ID, sender, "Raichu")
	err := tci.PlnK.SetItem(tci.Ctx, item)
	require.NoError(t, err)

	cases := map[string]struct {
		cookbookID    string
		desiredError  string
		desiredLength int
		showError     bool
	}{
		"not existing cookbook id": {
			cookbookID:    "invalidCookbookID",
			desiredError:  "",
			desiredLength: 0,
			showError:     false,
		},
		"cookbook with no item": {
			cookbookID:    cbData1.ID,
			desiredError:  "",
			desiredLength: 0,
			showError:     false,
		},
		"cookbook with 1 item": {
			cookbookID:    cbData.ID,
			desiredError:  "",
			desiredLength: 1,
			showError:     false,
		},
	}

	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			cItems, err := tci.PlnK.ItemsByCookbook(tci.Ctx, tc.cookbookID)
			if tc.showError {
			} else {
				require.NoError(t, err)
				require.True(t, len(cItems) == tc.desiredLength)
			}
		})
	}
}
