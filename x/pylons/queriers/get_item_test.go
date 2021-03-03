package queriers

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	"strings"
	"testing"

	"github.com/stretchr/testify/require"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestGetItem(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
	tci.PlnQ = NewQuerierServerImpl(tci.PlnK)

	sender1, _, _, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	// mock cookbook
	cbData := handlers.MockCookbook(tci, sender1)

	// mock item
	mockItemName := "GET_ITEM_MOCK_TEST_NAME"
	mockedItem := keep.GenItem(cbData.CookbookID, sender1, mockItemName)
	err := tci.PlnK.SetItem(tci.Ctx, *mockedItem)
	require.True(t, err == nil)

	cases := map[string]struct {
		itemID        string
		desiredError  string
		showError     bool
		desiredRcpCnt int
		itemName      string
	}{
		"error check when providing invalid item ID": {
			itemID:        "invalid itemID",
			showError:     true,
			desiredError:  "The item doesn't exist",
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
				require.True(t, err == nil)

				itmName, ok := result.Item.FindString("Name")
				require.True(t, ok)
				require.True(t, itmName == tc.itemName)
			}
		})
	}
}
