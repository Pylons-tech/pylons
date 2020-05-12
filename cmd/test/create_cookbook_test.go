package intTest

import (
	originT "testing"

	testing "github.com/Pylons-tech/pylons/cmd/fixtures_test/evtesting"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
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
			eugenAddr := GetAccountAddr("eugen", t)
			sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)

			t.MustNil(err)
			txhash := TestTxWithMsgWithNonce(t, msgs.NewMsgCreateCookbook(
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

			err = WaitForNextBlock()
			ErrValidation(t, "error waiting for creating cookbook %+v", err)

			txHandleResBytes, err := WaitAndGetTxData(txhash, 3, t)
			t.MustNil(err)
			resp := handlers.CreateCBResponse{}
			err = GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
			t.MustNil(err)
			t.MustTrue(resp.CookbookID != "")
		})
	}
}
