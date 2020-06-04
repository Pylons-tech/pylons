package intTest

import (
	originT "testing"

	testing "github.com/Pylons-tech/pylons_sdk/cmd/fixtures_test/evtesting"

	"github.com/Pylons-tech/pylons_sdk/x/pylons/handlers"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
	intTestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test"
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
			itemID := MockItemGUID(tc.itemName, t)

			eugenAddr := intTestSDK.GetAccountAddr("eugen", t)
			sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
			t.MustNil(err)
			txhash := intTestSDK.TestTxWithMsgWithNonce(
				t,
				msgs.NewMsgUpdateItemString(itemID, tc.field, tc.value, sdkAddr),
				"eugen",
				false,
			)

			err = intTestSDK.WaitForNextBlock()
			t.MustNil(err)

			txHandleResBytes, err := intTestSDK.WaitAndGetTxData(txhash, 3, t)
			t.MustNil(err)
			resp := handlers.UpdateItemStringResp{}
			err = intTestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
			t.MustNil(err)
			t.MustTrue(resp.Message == "successfully updated the item field")
			t.MustTrue(resp.Status == "Success")

			items, err := intTestSDK.ListItemsViaCLI("")
			intTestSDK.ErrValidation(t, "error listing items via cli ::: %+v", err)

			_, ok := intTestSDK.FindItemFromArrayByName(items, tc.value, false)
			t.MustTrue(ok)
		})
	}
}
