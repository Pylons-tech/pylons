package inttest

import (
	originT "testing"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	testing "github.com/Pylons-tech/pylons_sdk/cmd/fixtures_test/evtesting"

	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/handlers"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/msgs"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

func TestSendItemsViaCLI(originT *originT.T) {
	t := testing.NewT(originT)
	t.Parallel()

	tests := []struct {
		name            string
		itemNames       []string
		transferFees    []int64
		differPylonsLLC int64
		differCBOwner   int64
	}{
		{
			"basic send items test",
			[]string{"SEND_ITEMS_TEST_ITEM1", "SEND_ITEMS_TEST_ITEM2"},
			[]int64{700, 700},
			200,
			1800,
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {

			pylonsLLCAddress, err := sdk.AccAddressFromBech32(config.Config.Validators.PylonsLLC)
			t.MustNil(err, "error converting string address to AccAddress struct")
			pylonsLLCAccInfo := inttestSDK.GetAccountInfoFromAddr(pylonsLLCAddress.String(), t)

			mCB := GetMockedCookbook("node0", true, t)

			itemIDs := make([]string, len(tc.itemNames))

			for idx, itemName := range tc.itemNames {
				itemID := MockItemGUIDWithFee(mCB.ID, "michael", itemName, tc.transferFees[idx], t)
				itemIDs[idx] = itemID
			}

			node0Addr := inttestSDK.GetAccountAddr("node0", t)
			node0SdkAddr, err := sdk.AccAddressFromBech32(node0Addr)
			t.MustNil(err, "error converting string address to AccAddress struct")

			// TODO should be reverted after SetupTestAccounts upgrade
			// node0AccInfo := inttestSDK.GetAccountInfoFromAddr(node0SdkAddr.String(), t)

			mikeAddr := inttestSDK.GetAccountAddr("michael", t)
			mikeSdkAddr, err := sdk.AccAddressFromBech32(mikeAddr)
			t.MustNil(err, "error converting string address to AccAddress struct")
			txhash, err := inttestSDK.TestTxWithMsgWithNonce(
				t,
				msgs.NewMsgSendItems(itemIDs, mikeSdkAddr, node0SdkAddr),
				"michael",
				false,
			)
			if err != nil {
				TxBroadcastErrorCheck(txhash, err, t)
				return
			}

			WaitOneBlockWithErrorCheck(t)

			txHandleResBytes := GetTxHandleResult(txhash, t)
			resp := handlers.SendItemsResponse{}
			err = inttestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
			TxResBytesUnmarshalErrorCheck(txhash, err, txHandleResBytes, t)
			TxResultStatusMessageCheck(txhash, resp.Status, resp.Message, "Success", "successfully sent the items", t)

			for _, itemID := range itemIDs {
				item, err := inttestSDK.GetItemByGUID(itemID)
				t.MustNil(err)
				t.MustTrue(item.Sender.String() == node0SdkAddr.String())
			}

			pylonsLLCAccInfoAfter := inttestSDK.GetAccountInfoFromAddr(pylonsLLCAddress.String(), t)
			originPylonAmount := pylonsLLCAccInfo.Coins.AmountOf(types.Pylon)

			pylonAvailOnLLC := pylonsLLCAccInfoAfter.Coins.AmountOf(types.Pylon).GTE(sdk.NewInt(originPylonAmount.Int64() + tc.differPylonsLLC))
			t.MustTrue(pylonAvailOnLLC, "Pylons LLC should get correct revenue")

			// TODO should be reverted after SetupTestAccounts upgrade
			// node0AccInfoAfter := inttestSDK.GetAccountInfoFromAddr(node0SdkAddr.String(), t)
			// originNode0Amount := node0AccInfo.Coins.AmountOf(types.Pylon)

			// availOnEugen := node0AccInfoAfter.Coins.AmountOf(types.Pylon).GTE(sdk.NewInt(originNode0Amount.Int64() + tc.differCBOwner))
			// t.MustTrue(availOnEugen, "Cookbook sender should get correct revenue")
		})
	}
}
