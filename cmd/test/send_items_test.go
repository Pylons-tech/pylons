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
		name           string
		itemNames      []string
		transferFees   []int64
		LLCResult      int64
		cbSenderResult int64
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

			mCB := GetMockedCookbook(false, t)

			itemIDs := make([]string, len(tc.itemNames))

			for idx, itemName := range tc.itemNames {
				itemID := MockItemGUIDWithFee(mCB.ID, "michael", itemName, tc.transferFees[idx], t)
				itemIDs[idx] = itemID
			}

			eugenAddr := inttestSDK.GetAccountAddr("eugen", t)
			eugenSdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
			t.MustNil(err, "error converting string address to AccAddress struct")

			// eugenAccInfo := inttestSDK.GetAccountInfoFromAddr(eugenSdkAddr.String(), t)

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

			for _, itemID := range itemIDs {
				item, err := inttestSDK.GetItemByGUID(itemID)
				t.MustNil(err)
				t.MustTrue(item.Sender.String() == eugenSdkAddr.String())
			}

			accInfo := inttestSDK.GetAccountInfoFromAddr(pylonsLLCAddress.String(), t)
			originPylonAmount := pylonsLLCAccInfo.Coins.AmountOf(types.Pylon)

			pylonAvailOnLLC := accInfo.Coins.AmountOf(types.Pylon).GTE(sdk.NewInt(originPylonAmount.Int64() + tc.LLCResult))
			t.MustTrue(pylonAvailOnLLC, "Pylons LLC should get correct revenue")

			// eugenAccInfoAfter := inttestSDK.GetAccountInfoFromAddr(eugenSdkAddr.String(), t)
			// originEugenAmount := eugenAccInfo.Coins.AmountOf(types.Pylon)

			// availOnEugen := eugenAccInfoAfter.Coins.AmountOf(types.Pylon).GTE(sdk.NewInt(originEugenAmount.Int64() + tc.cbSenderResult))
			// t.MustTrue(availOnEugen, "Cookbook sender should get correct revenue")
		})
	}
}
