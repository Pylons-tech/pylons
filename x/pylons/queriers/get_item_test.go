package queriers

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/require"

	abci "github.com/tendermint/tendermint/abci/types"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

func TestGetItem(t *testing.T) {
	mockedCoinInput := keep.SetupTestCoinInput()

	sender := "cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337"
	senderAccAddress, _ := sdk.AccAddressFromBech32(sender)

	_, err := mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, senderAccAddress, types.NewPylon(1000000))
	require.True(t, err == nil)

	// mock cookbook
	cbData := handlers.MockCookbook(mockedCoinInput, senderAccAddress)

	// mock item
	mockItemName := "GET_ITEM_MOCK_TEST_NAME"
	mockedItem := keep.GenItem(cbData.CookbookID, senderAccAddress, mockItemName)
	err = mockedCoinInput.PlnK.SetItem(mockedCoinInput.Ctx, *mockedItem)
	require.True(t, err == nil)

	cases := map[string]struct {
		path          []string
		desiredError  string
		showError     bool
		desiredRcpCnt int
		itemName      string
	}{
		"error check when providing invalid item ID": {
			path:          []string{"invalid itemID"},
			showError:     true,
			desiredError:  "The item doesn't exist",
			desiredRcpCnt: 0,
		},
		"error check when not providing itemID": {
			path:          []string{},
			showError:     true,
			desiredError:  "no item id is provided in path",
			desiredRcpCnt: 0,
		},
		"get item successful check": {
			path:          []string{mockedItem.ID},
			showError:     false,
			desiredError:  "",
			desiredRcpCnt: 1,
			itemName:      mockItemName,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			result, err := GetItem(
				mockedCoinInput.Ctx,
				tc.path,
				abci.RequestQuery{
					Path: "",
					Data: []byte{},
				},
				mockedCoinInput.PlnK,
			)
			// t.Errorf("GetItemTEST LOG:: %+v", err)
			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.True(t, err == nil)
				readItem := types.Item{}
				readItemErr := mockedCoinInput.PlnK.Cdc.UnmarshalJSON(result, &readItem)

				require.True(t, readItemErr == nil)

				itmName, ok := readItem.FindString("Name")
				require.True(t, ok)
				require.True(t, itmName == tc.itemName)
			}
		})
	}
}
