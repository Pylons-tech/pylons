package inttest

import (
	originT "testing"

	testing "github.com/Pylons-tech/pylons_sdk/cmd/fixtures_test/evtesting"
	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/handlers"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
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

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			eugenAddr := inttestSDK.GetAccountAddr("eugen", t)
			sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)

			t.MustNil(err)
			txhash := inttestSDK.TestTxWithMsgWithNonce(t, msgs.NewMsgCreateCookbook(
				tc.cbName,
				"",
				"this has to meet character limits lol",
				"SketchyCo",
				"1.0.0",
				"example@example.com",
				0,
				msgs.DefaultCostPerBlock,
				sdkAddr),
				"eugen",
				false,
			)

			err = inttestSDK.WaitForNextBlock()
			if err != nil {
				t.WithFields(testing.Fields{
					"error": err,
				}).Fatal("error waiting for creating cookbook")
			}

			txHandleResBytes, err := inttestSDK.WaitAndGetTxData(txhash, 3, t)
			t.MustNil(err)
			resp := handlers.CreateCookbookResponse{}
			err = inttestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
			t.MustNil(err)
			t.MustTrue(resp.CookbookID != "")
		})
	}
}
