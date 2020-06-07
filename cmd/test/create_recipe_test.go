package inttest

import (
	originT "testing"

	testing "github.com/Pylons-tech/pylons_sdk/cmd/fixtures_test/evtesting"

	"github.com/Pylons-tech/pylons_sdk/x/pylons/types"

	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/handlers"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

func TestCreateRecipeViaCLI(originT *originT.T) {
	t := testing.NewT(originT)
	t.Parallel()

	tests := []struct {
		name    string
		rcpName string
	}{
		{
			"basic flow test",
			"TESTRCP_CreateRecipe_001",
		},
	}

	mCB, err := GetMockedCookbook(&t)
	inttestSDK.ErrValidation(&t, "error getting mocked cookbook %+v", err)

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			eugenAddr := inttestSDK.GetAccountAddr("eugen", t)
			sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
			t.MustNil(err)
			txhash := inttestSDK.TestTxWithMsgWithNonce(t,
				msgs.NewMsgCreateRecipe(
					tc.rcpName,
					mCB.ID,
					"",
					"this has to meet character limits lol",
					types.GenCoinInputList("wood", 5),
					types.GenItemInputList("Raichu"),
					types.GenEntries("chair", "Raichu"),
					types.GenOneOutput(2),
					0,
					sdkAddr),
				"eugen",
				false,
			)

			err = inttestSDK.WaitForNextBlock()
			inttestSDK.ErrValidation(t, "error waiting for creating recipe %+v", err)

			txHandleResBytes, err := inttestSDK.WaitAndGetTxData(txhash, 3, t)
			t.MustNil(err)
			resp := handlers.CreateRecipeResponse{}
			err = inttestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
			t.MustNil(err)
			t.MustTrue(resp.RecipeID != "")
		})
	}
}
