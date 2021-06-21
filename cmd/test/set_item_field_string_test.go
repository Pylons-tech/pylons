package inttest

import (
	"fmt"
	originT "testing"
	"time"

	testing "github.com/Pylons-tech/pylons_sdk/cmd/evtesting"
	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test_utils"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/types"
	"github.com/gogo/protobuf/proto"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

func TestUpdateItemStringViaCLI(originT *originT.T) {
	t := testing.NewT(originT)
	t.Parallel()

	tests := []struct {
		name     string
		itemName string
		field    string
		value    string
	}{
		{
			"basic flow test",
			"SET_ITEM_FIELD_STRING_TEST1",
			"Name",
			"SET_ITEM_FIELD_STRING_TEST1_MODIFIED",
		},
	}

	for tcNum, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			cbOwnerKey := fmt.Sprintf("TestUpdateItemStringViaCLI%d_%d", tcNum, time.Now().Unix())
			MockAccount(cbOwnerKey, t) // mock account with initial balance
			mCB := GetMockedCookbook(cbOwnerKey, false, t)

			itemID := MockItemGUID(mCB.ID, cbOwnerKey, tc.itemName, t)

			sdkAddr := GetSDKAddressFromKey(cbOwnerKey, t)
			updateItmMsg := types.NewMsgUpdateItemString(itemID, tc.field, tc.value, sdkAddr.String())
			txhash, err := inttestSDK.TestTxWithMsgWithNonce(t, &updateItmMsg, cbOwnerKey, false)
			if err != nil {
				TxBroadcastErrorCheck(txhash, err, t)
				return
			}

			WaitOneBlockWithErrorCheck(t)

			txHandleResBytes := GetTxHandleResult(txhash, t)
			txMsgData := &sdk.TxMsgData{
				Data: make([]*sdk.MsgData, 0, 1),
			}
			err = proto.Unmarshal(txHandleResBytes, txMsgData)
			t.MustNil(err)
			t.MustTrue(len(txMsgData.Data) == 1, "number of msgs should be 1")
			t.MustTrue(txMsgData.Data[0].MsgType == (types.MsgUpdateItemString{}).Type(), "MsgType should be accurate")
			resp := types.MsgUpdateItemStringResponse{}
			err = proto.Unmarshal(txMsgData.Data[0].Data, &resp)
			TxResBytesUnmarshalErrorCheck(txhash, err, txHandleResBytes, t)
			TxResultStatusMessageCheck(txhash, resp.Status, resp.Message, "Success", "successfully updated the item field", t)

			items, err := inttestSDK.ListItemsViaCLI("")
			t.MustNil(err, "error listing items via cli")

			_, ok := inttestSDK.FindItemFromArrayByName(items, tc.value, false, false)
			t.WithFields(testing.Fields{
				"item_name": tc.value,
			}).MustTrue(ok, "item id with specific name does not exist")
		})
	}
}
