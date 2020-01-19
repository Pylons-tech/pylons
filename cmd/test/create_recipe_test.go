package intTest

import (
	originT "testing"

	testing "github.com/Pylons-tech/pylons/cmd/fixtures_test/evtesting"

	"github.com/Pylons-tech/pylons/x/pylons/types"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
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
	ErrValidation(&t, "error getting mocked cookbook %+v", err)

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			eugenAddr := GetAccountAddr("eugen", t)
			sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
			t.MustNil(err)
			txhash := TestTxWithMsgWithNonce(t,
				msgs.NewMsgCreateRecipe(
					tc.rcpName,
					mCB.ID,
					"",
					"this has to meet character limits lol",
					types.GENERATION,
					types.GenCoinInputList("wood", 5),
					types.GenItemInputList("Raichu"),
					types.GenEntries("chair", "Raichu"),
					types.ItemUpgradeParams{},
					0,
					sdkAddr),
				"eugen",
				false,
			)

			err = WaitForNextBlock()
			ErrValidation(t, "error waiting for creating recipe %+v", err)

			txHandleResBytes, err := GetTxData(txhash, t)
			t.MustNil(err)
			resp := handlers.CreateRecipeResponse{}
			err = GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
			t.MustNil(err)
			t.MustTrue(resp.RecipeID != "")
		})
	}
}
