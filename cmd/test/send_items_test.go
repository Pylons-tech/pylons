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

			mCB := GetMockedCookbook("michael", true, t)

			itemIDs := make([]string, len(tc.itemNames))

			for idx, itemName := range tc.itemNames {
				itemID := MockItemGUIDWithFee(mCB.ID, "eugen", itemName, tc.transferFees[idx], t)
				itemIDs[idx] = itemID
			}

			eugenAddr := inttestSDK.GetAccountAddr("eugen", t)
			eugenSdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
			t.MustNil(err, "error converting string address to AccAddress struct")

			mikeAddr := inttestSDK.GetAccountAddr("michael", t)
			mikeSdkAddr, err := sdk.AccAddressFromBech32(mikeAddr)
			t.MustNil(err, "error converting string address to AccAddress struct")

			mikeAccInfo := inttestSDK.GetAccountInfoFromAddr(eugenSdkAddr.String(), t)

			txhash, err := inttestSDK.TestTxWithMsgWithNonce(
				t,
				msgs.NewMsgSendItems(itemIDs, eugenSdkAddr, mikeSdkAddr),
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
				t.MustTrue(item.Sender.String() == mikeSdkAddr.String())
			}

			pylonsLLCAccInfoAfter := inttestSDK.GetAccountInfoFromAddr(pylonsLLCAddress.String(), t)
			originPylonAmount := pylonsLLCAccInfo.Coins.AmountOf(types.Pylon)

			pylonAvailOnLLC := pylonsLLCAccInfoAfter.Coins.AmountOf(types.Pylon).GTE(sdk.NewInt(originPylonAmount.Int64() + tc.differPylonsLLC))
			t.MustTrue(pylonAvailOnLLC, "Pylons LLC should get correct revenue")

			mikeAccInfoAfter := inttestSDK.GetAccountInfoFromAddr(mikeSdkAddr.String(), t)
			originMikeAmount := mikeAccInfo.Coins.AmountOf(types.Pylon)

			availOnMike := mikeAccInfoAfter.Coins.AmountOf(types.Pylon).GTE(sdk.NewInt(originMikeAmount.Int64() + tc.differCBOwner))
			t.MustTrue(availOnMike, "Cookbook sender should get correct revenue")
		})
	}
}
