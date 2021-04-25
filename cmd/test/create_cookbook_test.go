package inttest

import (
	"fmt"
	originT "testing"
	"time"

	testing "github.com/Pylons-tech/pylons_sdk/cmd/evtesting"
	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test_utils"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/gogo/protobuf/proto"
)

func TestCreateCookbookViaCLI(originT *originT.T) {
	t := testing.NewT(originT)
	t.Parallel()

	tests := []struct {
		name   string
		cbName string
	}{
		{
			"basic flow test",
			"TESTCB_CreateCookbook_001",
		},
	}

	for tcNum, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			cbOwnerKey := fmt.Sprintf("TestCreateCookbookViaCLI%d_%d", tcNum, time.Now().Unix())
			MockAccount(cbOwnerKey, t) // mock account with initial balance

			sdkAddr := GetSDKAddressFromKey(cbOwnerKey, t)
			cbMsg := msgs.NewMsgCreateCookbook(
				tc.cbName,
				"",
				"this has to meet character limits lol",
				"SketchyCo",
				"1.0.0",
				"example@example.com",
				0,
				msgs.DefaultCostPerBlock,
				sdkAddr.String(),
			)
			txhash, err := inttestSDK.TestTxWithMsgWithNonce(t, &cbMsg, cbOwnerKey, false)
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
			t.MustTrue(txMsgData.Data[0].MsgType == (msgs.MsgCreateCookbook{}).Type(), "MsgType should be accurate")
			resp := msgs.MsgCreateCookbookResponse{}
			err = proto.Unmarshal(txMsgData.Data[0].Data, &resp)
			TxResBytesUnmarshalErrorCheck(txhash, err, txHandleResBytes, t)
			t.MustTrue(resp.CookbookID != "", "cookbook id should exist")
		})
	}
}
