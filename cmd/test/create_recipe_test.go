package inttest

import (
	"fmt"
	originT "testing"
	"time"

	testing "github.com/Pylons-tech/pylons_sdk/cmd/evtesting"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/gogo/protobuf/proto"

	"github.com/Pylons-tech/pylons_sdk/x/pylons/types"

	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test_utils"
)

func TestCreateRecipeViaCLI(originT *originT.T) {
	t := testing.NewT(originT)
	t.Parallel()

	tests := []struct {
		name         string
		rcpName      string
		outputDenom  string
		desiredError string
		showError    bool
	}{
		{
			name:        "basic flow test",
			rcpName:     "TESTRCP_CreateRecipe_001",
			outputDenom: "chair",
			showError:   false,
		},
		{
			name:         "recipe with pylon denom as output",
			rcpName:      "TESTRCP_CreateRecipe_002",
			outputDenom:  "pylon",
			desiredError: "There should not be a recipe which generate pylon denom as an output",
			showError:    true,
		},
	}

	cbOwnerKey := fmt.Sprintf("TestCreateRecipeViaCLI%d", time.Now().Unix())
	MockAccount(cbOwnerKey, &t) // mock account with initial balance

	cbOwnerSdkAddr := GetSDKAddressFromKey(cbOwnerKey, &t)
	mCB := GetMockedCookbook(cbOwnerKey, false, &t)

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			rcpMsg := types.NewMsgCreateRecipe(
				tc.rcpName,
				mCB.ID,
				"",
				"this has to meet character limits lol",
				types.GenCoinInputList("wood", 5),
				types.GenItemInputList("Raichu"),
				types.GenEntries(tc.outputDenom, "Raichu"),
				types.GenOneOutput(tc.outputDenom, "Raichu"),
				0,
				cbOwnerSdkAddr.String(),
			)
			txhash, err := inttestSDK.TestTxWithMsgWithNonce(t, &rcpMsg, cbOwnerKey, false)
			if err != nil {
				TxBroadcastErrorExpected(txhash, err, tc.desiredError, t)
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
			t.MustTrue(txMsgData.Data[0].MsgType == (types.MsgCreateRecipe{}).Type(), "MsgType should be accurate")
			resp := types.MsgCreateRecipeResponse{}
			err = proto.Unmarshal(txMsgData.Data[0].Data, &resp)
			TxResBytesUnmarshalErrorCheck(txhash, err, txHandleResBytes, t)
			t.MustTrue(resp.RecipeID != "", "recipe id should exist")
		})
	}
}
