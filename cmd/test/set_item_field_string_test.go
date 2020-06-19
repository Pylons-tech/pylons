package inttest

import (
	originT "testing"

	testing "github.com/Pylons-tech/pylons_sdk/cmd/fixtures_test/evtesting"

	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/handlers"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/msgs"
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

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			mCB := GetMockedCookbook(t)

			itemID := MockItemGUID(mCB.ID, tc.itemName, t)

			eugenAddr := inttestSDK.GetAccountAddr("eugen", t)
			sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
			t.MustNil(err)
			txhash, err := inttestSDK.TestTxWithMsgWithNonce(
				t,
				msgs.NewMsgUpdateItemString(itemID, tc.field, tc.value, sdkAddr),
				"eugen",
				false,
			)
			if err != nil {
				t.WithFields(testing.Fields{
					"error": err,
				}).Fatal("unexpected transaction broadcast error")
				return
			}

			err = inttestSDK.WaitForNextBlock()
			t.MustNil(err)

			txHandleResBytes, err := inttestSDK.WaitAndGetTxData(txhash, 3, t)
			t.MustNil(err)
			resp := handlers.UpdateItemStringResponse{}
			err = inttestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
			t.MustNil(err)
			t.MustTrue(resp.Message == "successfully updated the item field")
			t.MustTrue(resp.Status == "Success")

			items, err := inttestSDK.ListItemsViaCLI("")
			if err != nil {
				t.WithFields(testing.Fields{
					"error": err,
				}).Fatal("error listing items via cli")
			}

			_, ok := inttestSDK.FindItemFromArrayByName(items, tc.value, false)
			t.MustTrue(ok)
		})
	}
}
