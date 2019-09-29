package keep

import (
	"strings"
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func GenItem(cbID string, sender sdk.AccAddress, name string) *types.Item {
	return types.NewItem(
		cbID,
		(types.DoubleInputParamMap{"endurance": types.DoubleInputParam{DoubleWeightTable: types.DoubleWeightTable{WeightRanges: []types.DoubleWeightRange{
			types.DoubleWeightRange{
				Lower:  100.00,
				Upper:  500.00,
				Weight: 6,
			},
			types.DoubleWeightRange{
				Lower:  501.00,
				Upper:  800.00,
				Weight: 2,
			},
		}}}}).Actualize(),
		(types.LongInputParamMap{"HP": types.LongInputParam{IntWeightTable: types.IntWeightTable{WeightRanges: []types.IntWeightRange{
			types.IntWeightRange{
				Lower:  100,
				Upper:  500,
				Weight: 6,
			},
			types.IntWeightRange{
				Lower:  501,
				Upper:  800,
				Weight: 2,
			},
		}}}}).Actualize(),
		(types.StringInputParamMap{"Name": types.StringInputParam{Value: name}}).Actualize(),
		sender,
	)
}

func TestKeeperSetItem(t *testing.T) {
	mockedCoinInput := SetupTestCoinInput()

	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	cbData := GenCookbook(sender, "cookbook-0001", "this has to meet character limits")

	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender, types.PremiumTier.Fee)

	cases := map[string]struct {
		name         string
		desc         string
		sender       sdk.AccAddress
		level        types.Level
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
			err := mockedCoinInput.PlnK.SetItem(mockedCoinInput.Ctx, *item)

			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.True(t, err == nil)
			}
		})
	}
}

func TestKeeperGetItem(t *testing.T) {
	mockedCoinInput := SetupTestCoinInput()

	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	cbData := GenCookbook(sender, "cookbook-0001", "this has to meet character limits")

	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender, types.PremiumTier.Fee)

	item := GenItem(cbData.ID, sender, "Raichu")
	mockedCoinInput.PlnK.SetItem(mockedCoinInput.Ctx, *item)

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
			gItem, err := mockedCoinInput.PlnK.GetItem(mockedCoinInput.Ctx, tc.itemID)
			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.True(t, err == nil)
				require.True(t, item.CookbookID == gItem.CookbookID)
				require.True(t, item.Sender.String() == gItem.Sender.String())
				require.True(t, item.ID == gItem.ID)
			}
		})
	}
}

func TestKeeperGetItemsBySender(t *testing.T) {
	mockedCoinInput := SetupTestCoinInput()

	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	sender2, _ := sdk.AccAddressFromBech32("cosmos16wfryel63g7axeamw68630wglalcnk3l0zuadc")
	cbData := GenCookbook(sender, "cookbook-0001", "this has to meet character limits")

	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender, types.PremiumTier.Fee)

	item := GenItem(cbData.ID, sender, "Raichu")
	mockedCoinInput.PlnK.SetItem(mockedCoinInput.Ctx, *item)

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

			itemsBySender, err := mockedCoinInput.PlnK.GetItemsBySender(mockedCoinInput.Ctx, tc.sender)
			if tc.showError {
			} else {
				require.True(t, err == nil)
				require.True(t, len(itemsBySender) == tc.desiredLength)
			}
		})
	}
}

func TestKeeperUpdateItem(t *testing.T) {
	mockedCoinInput := SetupTestCoinInput()

	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	cbData := GenCookbook(sender, "cookbook-0001", "this has to meet character limits")

	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender, types.PremiumTier.Fee)

	item := GenItem(cbData.ID, sender, "Raichu")
	noSenderItem := GenItem(cbData.ID, nil, "Raichu")
	newItem := GenItem(cbData.ID, sender, "Raichu")

	mockedCoinInput.PlnK.SetItem(mockedCoinInput.Ctx, *item)
	item.Strings["Name"] = "RC"

	cases := map[string]struct {
		desiredError string
		showError    bool
		item         *types.Item
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
			desiredError: "the item with gid invalidItemID does not exist",
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

			err := mockedCoinInput.PlnK.UpdateItem(mockedCoinInput.Ctx, tc.itemID, *tc.item)
			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.True(t, err == nil)
				gItem, err2 := mockedCoinInput.PlnK.GetItem(mockedCoinInput.Ctx, tc.itemID)
				require.True(t, err2 == nil)
				require.True(t, tc.item.Strings["Name"] == gItem.Strings["Name"])
			}
		})
	}
}

func TestKeeperDeleteItem(t *testing.T) {
	mockedCoinInput := SetupTestCoinInput()

	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	cbData := GenCookbook(sender, "cookbook-0001", "this has to meet character limits")

	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender, types.PremiumTier.Fee)

	item := GenItem(cbData.ID, sender, "Raichu")
	mockedCoinInput.PlnK.SetItem(mockedCoinInput.Ctx, *item)

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
			mockedCoinInput.PlnK.DeleteItem(mockedCoinInput.Ctx, tc.itemID)
			if tc.showError {
			} else {
				_, err := mockedCoinInput.PlnK.GetItem(mockedCoinInput.Ctx, tc.itemID)
				require.True(t, strings.Contains(err.Error(), "The item doesn't exist"))
			}
		})
	}
}

func TestKeeperItemsByCookbook(t *testing.T) {
	mockedCoinInput := SetupTestCoinInput()

	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	cbData := GenCookbook(sender, "cookbook-0001", "this has to meet character limits")
	cbData1 := GenCookbook(sender, "cookbook-0002", "this has to meet character limits")

	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender, types.PremiumTier.Fee)

	item := GenItem(cbData.ID, sender, "Raichu")
	mockedCoinInput.PlnK.SetItem(mockedCoinInput.Ctx, *item)

	cases := map[string]struct {
		cookbookID    string
		desiredError  string
		desiredLength int
		showError     bool
	}{
		"not existing id delete": {
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
			cItems, err := mockedCoinInput.PlnK.ItemsByCookbook(mockedCoinInput.Ctx, tc.cookbookID)
			if tc.showError {
			} else {
				require.True(t, err == nil)
				require.True(t, len(cItems) == tc.desiredLength)
			}
		})
	}
}
