package queriers

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/require"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestGetItem(t *testing.T) {
	tci := keeper.SetupTestCoinInput()
	tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
	tci.PlnQ = NewQuerierServerImpl(tci.PlnK)

	sender1, _, _, _ := keeper.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	// mock cookbook
	cbData := handlers.MockCookbook(tci, sender1)

	// mock item
	mockItemName := "GET_ITEM_MOCK_TEST_NAME"
	mockedItem := keeper.GenItem(cbData.CookbookID, sender1, mockItemName)
	err := tci.PlnK.SetItem(tci.Ctx, mockedItem)
	require.NoError(t, err)

	cases := map[string]struct {
		itemID        string
		desiredError  string
		showError     bool
		desiredRcpCnt int
		itemName      string
	}{
		"error check when providing invalid item ID": {
			itemID:        "invalidItemID",
			showError:     true,
			desiredError:  "key invalidItemID not present in item store",
			desiredRcpCnt: 0,
		},
		"error check when not providing itemID": {
			itemID:        "",
			showError:     true,
			desiredError:  "no item id is provided in path",
			desiredRcpCnt: 0,
		},
		"get item successful check": {
			itemID:        mockedItem.ID,
			showError:     false,
			desiredError:  "",
			desiredRcpCnt: 1,
			itemName:      mockItemName,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			result, err := tci.PlnQ.GetItem(
				sdk.WrapSDKContext(tci.Ctx),
				&types.GetItemRequest{
					ItemID: tc.itemID,
				},
			)
			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.NoError(t, err)

				itmName, ok := result.Item.FindString("Name")
				require.True(t, ok)
				require.True(t, itmName == tc.itemName)
			}
		})
	}
}

func TestQueriersItemsBySender(t *testing.T) {
	tci := keeper.SetupTestCoinInput()
	tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
	tci.PlnQ = NewQuerierServerImpl(tci.PlnK)

	sender1, sender2, _, _ := keeper.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	// mock cookbook
	cbData := handlers.MockCookbookByName(tci, sender1, "cookbook-00001")

	item := keeper.GenItem(cbData.CookbookID, sender1, "Raichu")
	err := tci.PlnK.SetItem(tci.Ctx, item)
	require.NoError(t, err)

	cases := map[string]struct {
		sender        string
		desiredError  string
		desiredLength int
		showError     bool
	}{
		"not existing sender": {
			sender:        "invalidSender",
			desiredError:  "decoding bech32 failed: string not all lowercase or all uppercase",
			desiredLength: 0,
			showError:     true,
		},
		"error check when not providing sender": {
			sender:        "",
			desiredError:  "",
			desiredLength: 1,
			showError:     false,
		},
		"sender with no item": {
			sender:        sender2.String(),
			desiredError:  "",
			desiredLength: 0,
			showError:     false,
		},
		"sender with 1 item": {
			sender:        sender1.String(),
			desiredError:  "",
			desiredLength: 1,
			showError:     false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			result, err := tci.PlnQ.ItemsBySender(
				sdk.WrapSDKContext(tci.Ctx),
				&types.ItemsBySenderRequest{
					Sender: tc.sender,
				},
			)

			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.NoError(t, err)

				cItems := result.Items
				require.True(t, len(cItems) == tc.desiredLength)
			}
		})
	}
}

func TestQueriersItemsByCookbook(t *testing.T) {
	tci := keeper.SetupTestCoinInput()
	tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
	tci.PlnQ = NewQuerierServerImpl(tci.PlnK)

	sender1, _, _, _ := keeper.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	// mock cookbook
	cbData := handlers.MockCookbookByName(tci, sender1, "cookbook-00001")
	cbData1 := handlers.MockCookbookByName(tci, sender1, "cookbook-00002")

	item := keeper.GenItem(cbData.CookbookID, sender1, "Raichu")
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
		"error check when not providing cookbookID": {
			cookbookID:    "",
			desiredError:  "no cookbook id is provided in path",
			desiredLength: 0,
			showError:     true,
		},
		"cookbook with no item": {
			cookbookID:    cbData1.CookbookID,
			desiredError:  "",
			desiredLength: 0,
			showError:     false,
		},
		"cookbook with 1 item": {
			cookbookID:    cbData.CookbookID,
			desiredError:  "",
			desiredLength: 1,
			showError:     false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			result, err := tci.PlnQ.ItemsByCookbook(
				sdk.WrapSDKContext(tci.Ctx),
				&types.ItemsByCookbookRequest{
					CookbookID: tc.cookbookID,
				},
			)

			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.NoError(t, err)

				cItems := result.Items
				require.True(t, len(cItems) == tc.desiredLength)
			}
		})
	}
}
