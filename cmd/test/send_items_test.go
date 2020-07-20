package inttest

import (
	"fmt"
	originT "testing"
	"time"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	testing "github.com/Pylons-tech/pylons_sdk/cmd/evtesting"

	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test_utils"
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
			[]int64{1000, 1000},
			200,
			1800,
		},
	}

	for tcNum, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			cbOwnerKey := fmt.Sprintf("TestSendItemsViaCLI_CBOwner%d_%d", tcNum, time.Now().Unix())
			MockAccount(cbOwnerKey, t) // mock account with initial balance
			itemSenderKey := fmt.Sprintf("TestSendItemsViaCLI_itemSender%d_%d", tcNum, time.Now().Unix())
			MockAccount(itemSenderKey, t) // mock account with initial balance

			pylonsLLCAddress, err := sdk.AccAddressFromBech32(config.Config.Validators.PylonsLLC)
			t.MustNil(err, "error converting string address to AccAddress struct")
			pylonsLLCAccInfo := inttestSDK.GetAccountInfoFromAddr(pylonsLLCAddress.String(), t)

			mCB := GetMockedCookbook(cbOwnerKey, true, t)

			itemIDs := make([]string, len(tc.itemNames))

			for idx, itemName := range tc.itemNames {
				itemID := MockItemGUIDWithFee(mCB.ID, itemSenderKey, itemName, tc.transferFees[idx], t)
				itemIDs[idx] = itemID
			}

			cbOwnerAddr := inttestSDK.GetAccountAddr(cbOwnerKey, t)
			cbOwnerSdkAddr, err := sdk.AccAddressFromBech32(cbOwnerAddr)
			t.MustNil(err, "error converting string address to AccAddress struct")

			itemSenderAddr := inttestSDK.GetAccountAddr(itemSenderKey, t)
			itemSenderSdkAddr, err := sdk.AccAddressFromBech32(itemSenderAddr)
			t.MustNil(err, "error converting string address to AccAddress struct")

			cbOwnerAccInfo := inttestSDK.GetAccountInfoFromAddr(cbOwnerSdkAddr.String(), t)

			txhash, err := inttestSDK.TestTxWithMsgWithNonce(
				t,
				msgs.NewMsgSendItems(itemIDs, itemSenderSdkAddr, cbOwnerSdkAddr),
				itemSenderKey,
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
				t.MustTrue(item.Sender.String() == cbOwnerSdkAddr.String())
			}

			pylonsLLCAccInfoAfter := inttestSDK.GetAccountInfoFromAddr(pylonsLLCAddress.String(), t)
			originPylonAmount := pylonsLLCAccInfo.Coins.AmountOf(types.Pylon)

			balanceOk := pylonsLLCAccInfoAfter.Coins.AmountOf(types.Pylon).GTE(sdk.NewInt(originPylonAmount.Int64() + tc.differPylonsLLC))
			t.WithFields(testing.Fields{
				"pylons_llc_address":  pylonsLLCAddress.String(),
				"origin_amount":       originPylonAmount.Int64(),
				"target_distribution": tc.differPylonsLLC,
				"actual_amount":       pylonsLLCAccInfoAfter.Coins.AmountOf(types.Pylon).Int64(),
			}).MustTrue(balanceOk, "Pylons LLC should get correct revenue")

			cbOwnerAccInfoAfter := inttestSDK.GetAccountInfoFromAddr(cbOwnerSdkAddr.String(), t)
			originCBOwnerAmount := cbOwnerAccInfo.Coins.AmountOf(types.Pylon)

			balanceOk = cbOwnerAccInfoAfter.Coins.AmountOf(types.Pylon).Equal(sdk.NewInt(originCBOwnerAmount.Int64() + tc.differCBOwner))
			t.WithFields(testing.Fields{
				"cbowner_key":         cbOwnerKey,
				"cbowner_address":     cbOwnerSdkAddr.String(),
				"origin_amount":       originCBOwnerAmount.Int64(),
				"target_distribution": tc.differCBOwner,
				"actual_amount":       cbOwnerAccInfoAfter.Coins.AmountOf(types.Pylon).Int64(),
			}).MustTrue(balanceOk, "Cookbook sender should get correct revenue")
		})
	}
}
