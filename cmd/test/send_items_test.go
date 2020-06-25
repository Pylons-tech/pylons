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
		name         string
		itemNames    []string
		transferFees []int64
	}{
		{
			"basic send items test",
			[]string{"SEND_ITEMS_TEST_ITEM1", "SEND_ITEMS_TEST_ITEM2"},
			[]int64{700, 700},
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {

			pylonsLLCAddress, err := sdk.AccAddressFromBech32(config.Config.Validators.PylonsLLC)
			t.MustNil(err, "error converting string address to AccAddress struct")
			pylonsLLCAccInfo := inttestSDK.GetAccountInfoFromAddr(pylonsLLCAddress.String(), t)

			mCB := GetMockedCookbook(false, t)

			itemIDs := make([]string, len(tc.itemNames))

			for idx, itemName := range tc.itemNames {
				itemID := MockItemGUIDWithFee(mCB.ID, "michael", itemName, tc.transferFees[idx], t)
				itemIDs[idx] = itemID
			}

			t.Log("\n\n=======      itemIDs         =======\n\n")
			t.Log(itemIDs)
			t.Log(len(itemIDs))
			t.Log(len(tc.itemNames))
			t.Log(tc.itemNames)

			eugenAddr := inttestSDK.GetAccountAddr("eugen", t)
			eugenSdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)

			eugenAccInfo := inttestSDK.GetAccountInfoFromAddr(eugenSdkAddr.String(), t)

			mikeAddr := inttestSDK.GetAccountAddr("michael", t)
			mikeSdkAddr, err := sdk.AccAddressFromBech32(mikeAddr)
			t.MustNil(err, "error converting string address to AccAddress struct")
			txhash, err := inttestSDK.TestTxWithMsgWithNonce(
				t,
				msgs.NewMsgSendItems(itemIDs, mikeSdkAddr, eugenSdkAddr),
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

			// inttestSDK.GetItemByGUID()
			for _, itemID := range itemIDs {
				item, err := inttestSDK.GetItemByGUID(itemID)
				t.MustNil(err)
				t.MustTrue(item.Sender.String() == eugenSdkAddr.String())
			}

			accInfo := inttestSDK.GetAccountInfoFromAddr(pylonsLLCAddress.String(), t)
			originPylonAmount := pylonsLLCAccInfo.Coins.AmountOf(types.Pylon)
			t.Log("origin pylons amount")
			t.Log(originPylonAmount)
			pylonAvailOnLLC := accInfo.Coins.AmountOf(types.Pylon).GTE(sdk.NewInt(originPylonAmount.Int64() + 200))
			t.Log(accInfo.Coins.AmountOf(types.Pylon))
			t.MustTrue(pylonAvailOnLLC, "Pylons LLC should get correct revenue")

			eugenAccInfoAfter := inttestSDK.GetAccountInfoFromAddr(eugenSdkAddr.String(), t)
			originEugenAmount := eugenAccInfo.Coins.AmountOf(types.Pylon)
			t.Log("origin eugen amount")
			t.Log(originEugenAmount)
			availOnEugen := eugenAccInfoAfter.Coins.AmountOf(types.Pylon).GTE(sdk.NewInt(originEugenAmount.Int64() + 1800))
			t.Log(eugenAccInfoAfter.Coins.AmountOf(types.Pylon))
			t.MustTrue(availOnEugen, "Cookbook sender should get correct revenue")

			// items, err := inttestSDK.ListItemsViaCLI("")
			// if err != nil {
			// 	t.WithFields(testing.Fields{
			// 		"error": err,
			// 	}).Fatal("error listing items via cli")
			// }

			// _, ok := inttestSDK.FindItemFromArrayByName(items, tc.value, false)
			// t.WithFields(testing.Fields{
			// 	"item_name": tc.value,
			// }).MustTrue(ok, "item id with specific name does not exist")
		})
	}
}
