package inttest

import (
	originT "testing"

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

			mCB := GetMockedCookbook("jose", true, t)

			itemIDs := make([]string, len(tc.itemNames))

			for idx, itemName := range tc.itemNames {
				itemID := MockItemGUIDWithFee(mCB.ID, "eugen", itemName, tc.transferFees[idx], t)
				itemIDs[idx] = itemID
			}

			eugenAddr := inttestSDK.GetAccountAddr("eugen", t)
			eugenSdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
			t.MustNil(err, "error converting string address to AccAddress struct")

			joseAddr := inttestSDK.GetAccountAddr("jose", t)
			joseSdkAddr, err := sdk.AccAddressFromBech32(joseAddr)
			t.MustNil(err, "error converting string address to AccAddress struct")

			joseAccInfo := inttestSDK.GetAccountInfoFromAddr(joseSdkAddr.String(), t)

			txhash, err := inttestSDK.TestTxWithMsgWithNonce(
				t,
				msgs.NewMsgSendItems(itemIDs, eugenSdkAddr, joseSdkAddr),
				"eugen",
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
				t.MustTrue(item.Sender.String() == joseSdkAddr.String())
			}

			pylonsLLCAccInfoAfter := inttestSDK.GetAccountInfoFromAddr(pylonsLLCAddress.String(), t)
			originPylonAmount := pylonsLLCAccInfo.Coins.AmountOf(types.Pylon)

			pylonAvailOnLLC := pylonsLLCAccInfoAfter.Coins.AmountOf(types.Pylon).GTE(sdk.NewInt(originPylonAmount.Int64() + tc.differPylonsLLC))
			t.MustTrue(pylonAvailOnLLC, "Pylons LLC should get correct revenue")

			joseAccInfoAfter := inttestSDK.GetAccountInfoFromAddr(joseSdkAddr.String(), t)
			originJoseAmount := joseAccInfo.Coins.AmountOf(types.Pylon)

			availOnJose := joseAccInfoAfter.Coins.AmountOf(types.Pylon).GTE(sdk.NewInt(originJoseAmount.Int64() + tc.differCBOwner))
			t.MustTrue(availOnJose, "Cookbook sender should get correct revenue")
		})
	}
}
