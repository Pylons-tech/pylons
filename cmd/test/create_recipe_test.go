package inttest

import (
	"fmt"
	originT "testing"
	"time"

	testing "github.com/Pylons-tech/pylons_sdk/cmd/evtesting"

	"github.com/Pylons-tech/pylons_sdk/x/pylons/types"

	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test_utils"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/handlers"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/msgs"
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
			txhash, err := inttestSDK.TestTxWithMsgWithNonce(t,
				msgs.NewMsgCreateRecipe(
					tc.rcpName,
					mCB.ID,
					"",
					"this has to meet character limits lol",
					types.GenCoinInputList("wood", 5),
					types.GenItemInputList("Raichu"),
					types.GenEntries(tc.outputDenom, "Raichu"),
					types.GenOneOutput(2),
					0,
					cbOwnerSdkAddr),
				cbOwnerKey,
				false,
			)
			if err != nil {
				TxBroadcastErrorExpected(txhash, err, tc.desiredError, t)
				return
			}

			WaitOneBlockWithErrorCheck(t)

			txHandleResBytes := GetTxHandleResult(txhash, t)
			resp := handlers.CreateRecipeResponse{}
			err = inttestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
			TxResBytesUnmarshalErrorCheck(txhash, err, txHandleResBytes, t)
			t.MustTrue(resp.RecipeID != "", "recipe id should exist")
		})
	}
}
